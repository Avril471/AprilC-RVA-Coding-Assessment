library(shiny)
library(dplyr)
library(ggplot2)

# --- Data Prep (outside server for efficiency) ---
adae_clean <- adae %>%
  left_join(adsl %>% select(USUBJID), by = "USUBJID")

# --- UI ---
ui <- fluidPage(
  titlePanel("Adverse Events by System Organ Class and Severity"),
  
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput(
        inputId  = "actarm_filter",
        label    = "Filter by Treatment Arm:",
        choices  = sort(unique(adae_clean$ACTARM)),
        selected = sort(unique(adae_clean$ACTARM))  # all selected by default
      )
    ),
    
    mainPanel(
      plotOutput("ae_plot", height = "600px")
    )
  )
)

# --- Server 
server <- function(input, output) {
  
  # Reactive: deduplicate and count after applying treatment arm filter
  filtered_data <- reactive({
    adae_clean %>%
      filter(ACTARM %in% input$actarm_filter) %>%
      distinct(USUBJID, AESOC, AESEV) %>%
      count(AESOC, AESEV, name = "n")
  })
  
  # Reactive: recalculate SOC ordering based on current filtered data
  plot_data <- reactive({
    soc_order <- filtered_data() %>%
      group_by(AESOC) %>%
      summarise(total = sum(n)) %>%
      arrange(total) %>%
      pull(AESOC)
    
    filtered_data() %>%
      mutate(
        AESOC = factor(AESOC, levels = soc_order),
        AESEV = factor(AESEV, levels = c("MILD", "MODERATE", "SEVERE"))
      )
  })
  
  # Render plot — req() prevents rendering when no arms are selected
  output$ae_plot <- renderPlot({
    req(input$actarm_filter)
    
    ggplot(plot_data(), aes(x = n, y = AESOC, fill = AESEV)) +
      geom_bar(stat = "identity") +
      scale_fill_manual(
        values = c(
          "MILD"     = "#fdd9b5",
          "MODERATE" = "#f4845f",
          "SEVERE"   = "#c0392b"
        )
      ) +
      labs(
        title = "Unique Subjects per SOC and Severity Level",
        x     = "Number of Unique Subjects",
        y     = "System Organ Class",
        fill  = "Severity"
      ) +
      theme_bw() +
      theme(legend.position = "right")
  })
}

shinyApp(ui, server)
  

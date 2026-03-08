#Question 1
#Create a regulatory-compliant summary table of Treatment-Emergent Adverse Events (TEAEs).

install.packages(c("pharmaverseadam", "tidyverse", "gtsummary", "ggplot2", "shiny"))
library(pharmaverseadam)
library(tidyverse)
library(ggplot2)
library(gtsummary)
library(shiny)

#Data input
adae <- pharmaverseadam::adae
adsl <- pharmaverseadam::adsl

#Requirement
#– Treatment-emergent AE records will have TRTEMFL == "Y".
#– Rows: System Organ Class (AESOC) and Preferred Term (AEDECOD).
#– Columns: Treatment groups (ACTARM).
#– Cell Values: Subject count (n) and percentage (%).
#– Denominator: Use the total number of subjects in the study from ADSL.
#– Total: Include a summary row at the top for all TEAEs.

adae_teae <- adae %>%
              filter(TRTEMFL=="Y") 
            

teae_table <- tbl_hierarchical(
  data      = adae_teae,
  variables = c(AESOC, AEDECOD),    # rows: SOC then Preferred Term
  by        = ACTARM,               # columns: treatment arms
  denominator = adsl,               # adsl provides the N denominator
  id        = USUBJID,              # subject ID for deduplication
  overall_row = TRUE,               # adds the "Treatment Emergent AEs" summary row at top
  label     = list(..ard_hierarchical_overall.. = "Treatment Emergent Adverse Events")
)

teae_table

# Export to HTML
as_gt(teae_table) %>%
  gt::gtsave("teae_table.html")

# AprilC-RVA-Coding-Assessment
R Shiny Clinical Data Assessment

## Repository Structure
Each question has its own dedicated folder containing the R script and any output files.

---

## Question 1: TEAE Summary Table
**Approach:** Filtered ADAE to treatment-emergent AEs (TRTEMFL == "Y"), joined with ADSL 
to get the full study denominator, then used `{gtsummary}` to build a regulatory-compliant 
summary table with SOC and Preferred Term rows across treatment arm columns.

**Output:** HTML table
🔗 [View Summary table](https://avril471.github.io/AprilC-RVA-Coding-Assessment/Q1/teae_table.html)

---

## Question 2: AE Severity Visualization
**Approach:** Deduplicated ADAE to one record per subject per SOC per severity level, 
then used `{ggplot2}` to build a stacked horizontal bar chart ordered by increasing 
total subject frequency per SOC.

**Output:** PNG file (`Q2/ae_severity_plot.png`)

---

## Question 3: Interactive R Shiny Application
**Approach:** Integrated the Q2 visualization into a Shiny dashboard with a 
`checkboxGroupInput` filter for Treatment Arm (ACTARM). The plot updates reactively 
based on selected arms.

**Output:** Live Shiny app
🔗 [Launch Shiny App](https://choqyy-april-cheng.shinyapps.io/RVA-Q3-Shiny)

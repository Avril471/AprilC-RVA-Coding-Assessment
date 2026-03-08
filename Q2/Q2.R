#Question 2
# Develop a publication-quality bar chart visualizing the distribution of adverse events.

library(dplyr)
library(ggplot2)
#Data input
adae <- pharmaverseadam::adae


#Requirements:
#– X-axis: Count of unique subjects per System Organ Class per Severity. Ensure each subject
#subject is counted at most once per severity level within each SOC.
#– Y-axis: System Organ Class term (AESOC).
#– Color/Fill: Colored by AE Severity/Intensity (AESEV).
#– Ordering: Bars must be stacked and ordered by increasing frequency of total subjects per SOC.

# My data exploring steps:

# unique System Organ Class
n_distinct(adae$AESOC)
# Severity levels and their frequency
adae %>% count(AESEV)
# Cross-tab of SOC x severity 
adae %>% count(AESOC, AESEV) %>% arrange(AESOC)


# Step 1: Deduplicate - one row per subject per SOC per severity
ae_plot_data <- adae %>%
  distinct(USUBJID, AESOC, AESEV) %>%   # count each subject at most once per SOC+severity
  count(AESOC, AESEV, name = "n")

# Step 2: Calculate total subjects per SOC for ordering
soc_order <- ae_plot_data %>%
  group_by(AESOC) %>%
  summarise(total = sum(n)) %>%
  arrange(total) %>%
  pull(AESOC)

# Step 3: Apply SOC ordering as factor
ae_plot_data <- ae_plot_data %>%
  mutate(AESOC = factor(AESOC, levels = soc_order))

# Step 4: Plot
ggplot(ae_plot_data, aes(x = n, y = AESOC, fill = AESEV)) +
  geom_bar(stat = "identity") +
  labs(
    title = "Adverse Events by System Organ Class and Severity",
    x     = "Count of Unique Subjects",
    y     = "System Organ Class",
    fill  = "Severity"
  ) +
  theme_bw() +
  theme(legend.position = "bottom")
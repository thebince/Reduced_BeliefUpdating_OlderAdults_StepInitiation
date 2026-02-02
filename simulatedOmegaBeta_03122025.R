# Script to plot simulated RT from posterior predictive checks (Fig 3A and 3B)

# set working directory 
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path))


library(ggplot2)
library(dplyr)
library(RColorBrewer)
library(tidyr) 

# load data MG
df_mg <- read.csv('simulatedRT_mgmng_50inputs.csv')
df_mg$RTAPAOnset[df_mg$RTAPAOnset == "NaN"] <- NA

betafour_values <- c(0.1, 0.3, 0.6)

fit_data_one <- df_mg %>%
  filter(betafour %in% betafour_values, !is.na(RTAPAOnset)) %>%
  group_by(betafour, omega, condition) %>%
  summarise(
    APA_fit = mean(RTAPAOnset),
    .groups = "drop"
  ) %>%
  mutate(
    omega_factor = as.factor(omega),
    condition = factor(condition,
                       levels = c(1, 2),
                       labels = c("mostly go", "mostly no-go"))
  )

# MNG
df_mng <- read.csv('simulatedRT_mngmg_50inputs.csv')
df_mng$RTAPAOnset[df_mng$RTAPAOnset == "NaN"] <- NA

fit_data_two <- df_mng %>%
  filter(betafour %in% betafour_values, !is.na(RTAPAOnset)) %>%
  group_by(betafour, omega, condition) %>%
  summarise(
    APA_fit = mean(RTAPAOnset),
    .groups = "drop"
  ) %>%
  mutate(
    omega_factor = as.factor(omega),
    condition = factor(condition,
                       levels = c(1, 2),
                       labels = c("mostly go", "mostly no-go"))
  )

# Average of MG and MNG
fit_data_avg <- fit_data_one %>%
  mutate(condition = as.character(condition)) %>%
  inner_join(fit_data_two %>% mutate(condition = as.character(condition)),
             by = c("betafour", "omega", "condition"),
             suffix = c("_one", "_two")) %>%
  mutate(APA_fit = (APA_fit_one + APA_fit_two) / 2) %>%
  select(betafour, omega, condition, APA_fit) %>%
  mutate(
    omega_factor = as.factor(omega),
    condition = factor(condition,
                       levels = c("mostly go", "mostly no-go"))
  )

# plot condition mean (Fig 3.A)
ggplot(fit_data_avg,
       aes(x = condition,
           y = APA_fit,
           group = omega_factor,
           color = omega_factor)) +
  geom_point() +
  geom_line() +
  facet_wrap(~ betafour, nrow = 1, scales = "fixed",
             labeller = labeller(betafour = function(x) paste("β4 =", x))) +
  labs(x = "Condition",
       y = "APA Onset Time (ms)",
       color = "Omega") +
  scale_color_brewer(palette = "Greens", direction = -1, name = "ω",
                     labels = function(x) as.character(as.integer(as.numeric(x)))) +
  guides(color = guide_legend(nrow = 1)) +
  theme(
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    axis.title.x = element_text(face = "bold", size = 7, family = "Helvetica"),
    axis.title.y = element_text(face = "bold", size = 7, family = "Helvetica"),
    axis.text.x = element_text(face = "bold", size = 5, family = "Helvetica"),
    axis.text.y = element_text(face = "bold", size = 9, family = "Helvetica"),
    axis.line = element_line(size = 1),
    axis.ticks.x = element_blank(),
    axis.ticks.y = element_blank(),
    legend.position = "bottom",
    legend.direction = "horizontal",
    legend.justification = c("center", "top"),
    legend.text = element_text(family = "Helvetica", size = 6),
    legend.title = element_text(family = "Helvetica", size = 6),
    legend.key.size = unit(0.4, "cm"),
    plot.title = element_blank(),
    strip.text = element_text(size = 7, family = "Helvetica", face = "bold"),
    strip.background = element_blank()
  )

# ggsave("RTAPA_conditions_avg_bigsim100inputs.png", dpi = 600, width = 9, height = 6, units = "cm")


# Trial History (Fig 3.B)

# Compute means for APA onset by trial history, omega, and betafour
mean_data_one <- df_mg %>%
  filter(betafour %in% betafour_values,
         !is.na(RTAPAOnset),
         Go_Consecutive_Go_NoGo >= -7,
         Go_Consecutive_Go_NoGo <= 5) %>%
  group_by(betafour, omega, Go_Consecutive_Go_NoGo) %>%
  summarise(
    APA_fit_one = mean(RTAPAOnset),
    .groups = "drop"
  ) %>%
  mutate(omega_factor = as.factor(omega))

mean_data_two <- df_mng %>%
  filter(betafour %in% betafour_values,
         !is.na(RTAPAOnset),
         Go_Consecutive_Go_NoGo >= -7,
         Go_Consecutive_Go_NoGo <= 5) %>%
  group_by(betafour, omega, Go_Consecutive_Go_NoGo) %>%
  summarise(
    APA_fit_two = mean(RTAPAOnset),
    .groups = "drop"
  ) %>%
  mutate(omega_factor = as.factor(omega))

fit_data_avg <- mean_data_one %>%
  inner_join(mean_data_two, by = c("betafour", "omega", "Go_Consecutive_Go_NoGo"), suffix = c("_one", "_two")) %>%
  mutate(APA_fit = (APA_fit_one + APA_fit_two) / 2) %>%
  select(betafour, omega, Go_Consecutive_Go_NoGo, APA_fit) %>%
  mutate(omega_factor = as.factor(omega))

ggplot(fit_data_avg, aes(x = Go_Consecutive_Go_NoGo, y = APA_fit, group = omega_factor, color = omega_factor)) +
  geom_line() +
  facet_wrap(~ betafour, nrow = 1, scales = "fixed",
             labeller = labeller(betafour = function(x) paste("β4 =", x))) +
  labs(x = "Trial History",
       y = "APA Onset Time (ms)",
       color = "Omega") +
  scale_x_continuous(breaks = c(-5, 0, 5)) +
  coord_cartesian(xlim = c(-5, 5)) +
  scale_color_brewer(palette = "Greens", direction = -1, name = "ω",
                     labels = function(x) as.character(as.integer(as.numeric(x)))) +
  guides(color = guide_legend(nrow = 1)) +
  theme(
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    axis.title.x = element_text(face = "bold", size = 7, family = "Helvetica"),
    axis.title.y = element_text(face = "bold", size = 7, family = "Helvetica"),
    axis.text.x = element_text(face = "bold", size = 9, family = "Helvetica"),
    axis.text.y = element_text(face = "bold", size = 9, family = "Helvetica"),
    axis.line = element_line(size = 1),
    axis.ticks.x = element_blank(),
    axis.ticks.y = element_blank(),
    legend.position = "bottom",
    legend.direction = "horizontal",
    legend.justification = c("center", "top"),
    legend.text = element_text(family = "Helvetica", size = 6),
    legend.title = element_text(family = "Helvetica", size = 6),
    legend.key.size = unit(0.4, "cm"),
    plot.title = element_blank(),
    strip.text = element_text(size = 7, family = "Helvetica", face = "bold"),
    strip.background = element_blank()
  )

# ggsave("RTAPA_trialhistory_avg_bigsim100inputs.png", dpi = 600, width = 9, height = 6, units = "cm")
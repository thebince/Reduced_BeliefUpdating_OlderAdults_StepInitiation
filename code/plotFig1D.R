# Script to generate Fig 1.D

# set working directory 
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path))
options(warn = -1)


# library (install all libraries if unavailable)
library(lme4)
library(lmerTest)
library(readxl)
library(effectsize)
library(optimx)
library(mgcv)
library(dplyr)
library(ggplot2)
library(gratia)
library(mgcViz)
library(sjPlot)

# for plots
library(RColorBrewer)
red_dark   <- brewer.pal(9, "Reds")[8]   # "#A50F15" - deep crimson, Young
blue_light <- brewer.pal(9, "Blues")[4]  # "#9ECAE1" - clear mid-light blue, Old

group_colors <- c("Young" = red_dark, "Old" = blue_light)

rgb2lum <- function(hex) {
  rgb <- col2rgb(hex) / 255
  sum(c(0.2126, 0.7152, 0.0722) * rgb)
}

sapply(group_colors, rgb2lum)

# load behavioural data
df <- read.csv("../data/behaviouraldataStepping.csv")
df$Difference_APAOnsetGo[df$Difference_APAOnsetGo == "NaN"] <- NA
df$Group[df$Group == "NaN"] <- NA

# set factors
df <- df[!is.na(df$Group), ]
df$Group <- droplevels(as.factor(df$Group))
levels(df$Group) <- c("Young", "Old")
df$Condition <- as.factor(df$Condition)

# Convert Consecutive_Go_NoGo from factor to numeric
df$Go_Consecutive_Go_NoGo <- as.numeric(as.character(df$Go_Consecutive_Go_NoGo))
df$Participant_ID <- as.factor(df$Participant_ID)
unique_Participant_ID <- unique(df$Participant_ID)
group_mapping <- unique(df[, c("Participant_ID", "Group")])

# Check Interaction effect slope in Linear Mixed Model
model_interaction = lmer(Difference_APAOnsetGo ~ 1 + Go_Consecutive_Go_NoGo * Group + (1|Participant_ID),
                         data = df,
                         REML = TRUE)

# Generate plot
int_pot = plot_model(model_interaction, type = "int", terms = c("Consecutive_Go_NoGo", "Group")) +
  scale_color_manual(values = group_colors) +
  scale_fill_manual(values = group_colors) +
  theme(panel.background = element_blank(),       
        panel.grid.major = element_blank(),       
        panel.grid.minor = element_blank(),       
        panel.border = element_blank(),
        axis.title.x = element_text(face = "bold", size = 9, family = "Helvetica"),
        axis.title.y = element_text(face = "bold", size = 9, family = "Helvetica"),
        axis.text.x = element_text(face = "bold", size = 9, family = "Helvetica"),
        axis.text.y = element_text(face = "bold", size = 9, family = "Helvetica"),
        axis.line = element_line(size = 1),
        axis.ticks.x = element_blank(), 
        axis.ticks.y = element_blank(), 
        legend.position = c(0.85, 0.85),
        legend.text = element_text(family = "Helvetica", size = 9),
        legend.title = element_text(family = "Helvetica", size = 9),
        legend.key.size = unit(0.4, "cm"),
        plot.title = element_blank()) +
  labs(x = "Trial History", y = "APA Onset Time (ms)") +
  xlim(-20, 20)+
  ylim(50, 525)

print(int_pot)
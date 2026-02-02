# Script to generate Fig 1. D

# set working directory 
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path))
getwd()
setwd("D:/ISPGR/ISPGR_COP/DataCuration")

# library
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

# load data
df <- read.csv('newRT_29112025_withforces_APAfiltered.csv')
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


# Linear Mixed Model (Interaction)
model_interaction = lmer(Difference_APAOnsetGo ~ 1 + Go_Consecutive_Go_NoGo * Group + (1|Participant_ID),
                         data = df,
                         REML = TRUE)
summary(model_interaction)

int_pot = plot_model(model_interaction, type = "int", terms = c("Consecutive_Go_NoGo", "Group")) +
  theme(panel.background = element_blank(),       
        panel.grid.major = element_blank(),       
        panel.grid.minor = element_blank(),       
        panel.border = element_blank(),
        axis.title.x = element_text(face = "bold", size = 8, family = "Helvetica"),
        axis.title.y = element_text(face = "bold", size = 8, family = "Helvetica"),
        axis.text.x = element_text(face = "bold", size = 8, family = "Helvetica"),
        axis.text.y = element_text(face = "bold", size = 8, family = "Helvetica"),
        axis.line = element_line(size = 1),
        axis.ticks.x = element_blank(), 
        axis.ticks.y = element_blank(), 
        legend.position = c(0.85, 0.85),
        legend.text = element_text(family = "Helvetica", size = 8),
        legend.title = element_text(family = "Helvetica", size = 8),
        legend.key.size = unit(0.3, "cm"),
        plot.title = element_blank()) +
  labs(x = "Trial History", y = "APA Onset Time (ms)") +
  xlim(-20, 20)+
  ylim(50, 550)

print(int_pot)

ggsave("interaction_trialhistory_group_APAOnset_edited_9x6.png", plot = int_pot, width = 9, height = 6, units = "cm", dpi = 600)


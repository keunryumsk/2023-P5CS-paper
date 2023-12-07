nstall.packages("tidyverse")
install.packages("readxl")
install.packages("reshape2")
install.packages("ggpubr")

library(tidyverse)
library(readxl)
library(reshape2)
library(ggpubr)

################################ Figure 2j ##############################

##Read file for ggplot
setwd("~/Desktop/All_Box_plots/P5CS_Paper")
raw_data1 <- read.csv("20230802 MEF Gal OP reverse T20 P5CS overlapping area quantification.csv")
df <- melt(raw_data1)
df_1 <- na.omit(df)

##sample size
sample_size_1 = df_1 %>% group_by(variable) %>% summarize(num=n())

## Boxplot
boxplot <- ggplot(df_1, aes(x = variable, y = value, fill = variable, color = variable)) +
  geom_boxplot(width = 0.75, notch = FALSE, color = "black", outlier.shape = NA, lwd = 1) +
  geom_jitter(alpha = 3/5, size = 5, shape = 16, position = position_jitter(0.2)) +
  scale_fill_manual(values = c("#1C75BC", "#1C75BC")) +
  scale_color_manual(values = c("#14547F", "#14547F")) +
  scale_x_discrete(labels = c("–", "+", "Gal", "-Glc")) +
  theme_classic() +
  theme(legend.position = "none") +
  theme(axis.title.x=element_blank()) +
  theme(axis.line = element_line(size = 1.5, colour = "black")) +
  theme(axis.ticks = element_line(size = 1.5, colour = "black")) +
  theme(axis.ticks.length = unit(0.15, "cm")) +
  theme(axis.text.y = element_text(size = 25)) +
  theme(axis.title = element_blank()) +
  theme(axis.text.x = element_text(size = 25)) +
  theme(axis.ticks.length=unit(0.5,"cm"))



boxplot  

##Add statistics
pair_stat <- list( c("Gal", "Gal.OP"))

boxplot_stat <- boxplot + stat_compare_means(comparisons = pair_stat, label.y = c(65), pair_stat, size = 7, tip.length = 0.01)

boxplot_stat


##Save box plot
ggsave("boxplot_test3.png", plot = boxplot, width = 7, height = 12, units ="cm", dpi = 600)

################################ Figure 2e ##############################

##Read file for ggplot
raw_data2 <- read_xlsx("SS_Glc_Gal_P5CS_TOM20_overlap.xlsx")
df2 <- melt(raw_data2)
df2_1 <- na.omit(df2)

##sample size
sample_size = df2_1 %>% group_by(variable) %>% summarize(num=n())

## Old boxplot
boxplot2 <- ggplot(df2_1, aes(x = variable, y = value, fill = variable, color = variable)) +
  geom_boxplot(width = 0.75, notch = FALSE, color = "black", outlier.shape = NA, lwd = 1) +
  geom_jitter(alpha = 3/5, size = 5, shape = 16, position = position_jitter(0.2)) +
  scale_fill_manual(values = c("#E5E5E5", "#1C75BC", "#1C75BC")) +
  scale_color_manual(values = c("#808285", "#14547F", "#14547F")) +
  scale_x_discrete(labels = c("Glc", "Glc", "Gal", "-Glc")) +
  theme_classic() +
  theme(legend.position = "none") +
  theme(axis.title.x=element_blank()) +
  theme(axis.line = element_line(size = 1.5, colour = "black")) +
  theme(axis.ticks = element_line(size = 1.5, colour = "black")) +
  theme(axis.ticks.length = unit(0.15, "cm")) +
  ylim(0,80) +
  theme(axis.text.y = element_text(size = 25)) +
  theme(axis.title = element_blank()) +
  theme(axis.ticks.length=unit(0.5,"cm")) +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())


boxplot2  

##Add statistics
pair_stat <- list( c("SS", "Glucose"), c("SS", "Galactose"), c("Glucose", "Galactose") )

boxplot_stat2 <- boxplot2 + stat_compare_means(comparisons = pair_stat, label.y = c(60, 70, 65), pair_stat, size = 7, tip.length = 0.01)

boxplot_stat2


##Save box plot
ggsave("boxplot_galactose2.png", plot = boxplot2, width = 15, height = 15, units ="cm", dpi = 600)

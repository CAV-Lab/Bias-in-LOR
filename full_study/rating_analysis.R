library(readr)
library(ggplot2)
library(dplyr)
library(lme4)
data <- read_csv("Responses/full_study_ratings_per_letter.csv")

ml1 <-lmer(rating ~ Intervention + Language+ (1|ResponseId), data = data)
summary(ml1)

ml2 <-lmer(confidence ~ Intervention + Language+ (1|ResponseId), data = data)
summary(ml2)
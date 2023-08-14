library(readr)
library(ggplot2)
library(tidyverse)

data <- read_csv("Responses/full_study_ratings.csv")
data$LetterID = paste('Letter',data$LetterID, sep=' ')
data$LetterID2 = paste('Letter',data$LetterID2, sep=' ')

dataSE1 <- data %>%
  group_by(LetterID) %>%
  summarise( 
    n=n(),
    mean=mean(letter1_rating),
    sd=sd(letter1_rating),
    Label= sprintf("%.02f", mean(letter1_rating)),
    lower=mean-sd,
    upper=mean+sd
  ) 

p1 <- ggplot(data, aes(x=letter1_rating, y=factor(LetterID), color=factor(LetterID)))+
  geom_jitter(shape=16,size=1, position=position_jitter(0.1), alpha=(2/3)) +
  geom_pointrange(data=dataSE1, aes(xmin = lower, xmax = upper,x = mean, y = LetterID ),lwd=1, size=1)+
  scale_color_manual(values = c("#E69F00", "#CC79A7", "#009E73", "#fb8072")) +
  geom_text(data=dataSE1, aes(label= Label, x = mean, y = LetterID, size=18), vjust=1.5,color = "black") +
  labs(x="Rating", y="") +
  guides(color="none", size='none')
p1 + theme_bw() + theme(text = element_text(size = 16))
ggsave("p2.pdf", width = 7, height = 5)

########################### bootstrapping
set.seed(1)

lapply(1:1000, function(i){
  boot_ids <- sample(1:nrow(data), size = nrow(data), replace = T)
  data[boot_ids,] -> boot_data
  boot_data %>%
    group_by(Intervention, LetterID2) %>%
    summarise(mean=mean(letter2_rating)) -> tmp
  tmp$boot <- i
  tmp
}) %>% Reduce(rbind, .) -> boot_res
# boot_res %>% Reduce(rbind, .) -> boot_res
# boot_res %>%
  # group_by()
# boot_res %>%
#   filter(LetterID2 == 1, Intervention == "C") %>%
#   ggplot(aes(mean)) +
#   geom_histogram(bins = 50)
# boot_res %>%
#   filter(LetterID2 == 1, Intervention == "C") -> tmp
boot_res %>%
  group_by(LetterID2, Intervention) %>%
  summarise(mu = mean(mean),
            lower = unname(quantile(mean, probs = c(0.025))),
            upper = unname(quantile(mean, probs = c(0.975)))) -> boot_mu_CI

data %>%
  ggplot(aes(x=letter2_rating, y=factor(Intervention), color=factor(Intervention)))+
  geom_jitter(shape=16,size=1, position=position_jitter(0.1), alpha=(2/3)) +
  geom_pointrange(data=boot_mu_CI, aes(xmin = lower, xmax = upper,x = mu, y = Intervention), lwd=1, size=1)+
    scale_y_discrete(limits=rev)+
    scale_color_manual(values = c("grey", "#bea3ff", "#00BFFF", "#27f2cf")) +
    geom_text(data=boot_mu_CI, aes(x = mu, y = Intervention, size=12, label = sprintf("%.2f", mu)),vjust=1.5, color = "black") +
    labs(x="Rating", y="Intervention", color='Intervention') +
    guides(size='none') +
  facet_wrap(~LetterID2,ncol=2, nrow=2)  + theme_bw() +
  theme(text = element_text(size = 16), legend.position="top",
        strip.background = element_blank())
        # strip.background = element_rect(fill = "white"))
# export::ex
ggsave("p1.pdf", width = 9, height = 6)

data %>%
  filter(LetterID == "Letter 1", Intervention == "C") %>%
  select(letter2_rating) %>%
  unlist() %>%
  hist()
# tmp %>%
#   summarise(mu = mean(mean),
#             lower = unname(quantile(mean, probs = c(0.025))),
#             upper = unname(quantile(mean, probs = c(0.975))))
# mean(tmp$mean)
# unname(quantile(tmp$mean, probs = c(0.025, 0.975)))

# boot_data %>%
#   group_by(., Intervention, LetterID2)

dataSE2 <- data %>%
  group_by(Intervention, LetterID2) %>%
  summarise( 
    n=n(),
    mean=mean(letter2_rating),
    sd=sd(letter2_rating),
    Label= sprintf("%.02f", mean(letter2_rating)),
    lower=mean-sd,
    upper=mean+sd
  ) 

p2 <- ggplot(data, aes(x=letter2_rating, y=factor(Intervention), color=factor(Intervention)))+
  geom_jitter(shape=16,size=1, position=position_jitter(0.1), alpha=(2/3)) +
  geom_pointrange(data=dataSE2, aes(xmin = lower, xmax = upper,x = mean, y = Intervention), lwd=1, size=1)+
  scale_y_discrete(limits=rev)+
  scale_color_manual(values = c("grey", "#bea3ff", "#00BFFF", "#27f2cf")) +
  geom_text(data=dataSE2, aes(label= Label, x = mean, y = Intervention, size=12),vjust=1.5, color = "black") +
  labs(x="Rating", y="Intervention", color='Intervention') +
  guides(size='none')
p2 + theme_bw() +
  facet_wrap(~LetterID2,ncol=2, nrow=2)  + theme_bw() + theme(text = element_text(size = 16), legend.position="top")


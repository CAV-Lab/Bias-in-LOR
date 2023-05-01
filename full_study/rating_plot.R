library(readr)
library(ggplot2)

data <- read_csv("Responses/full_study_ratings.csv")

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
  labs(x="Rating", y="Letter") +
  guides(color="none", size='none')
p1 + theme_bw() + theme(text = element_text(size = 16))



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
  geom_text(data=dataSE, aes(label= Label, x = mean, y = Intervention, size=12),vjust=1.5, color = "black") +
  labs(x="Rating", y="Intervention", color='Intervention') +
  guides(size='none')
p2 + theme_bw() +
  facet_wrap(~LetterID2,ncol=2, nrow=2)  + theme_bw() + theme(text = element_text(size = 16), legend.position="top")


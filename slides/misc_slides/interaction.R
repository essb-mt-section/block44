library(ggplot2)
library(tidyverse)

df <- data.frame(Student=rep(c("NL", "GER"), each=2),
                  Word=rep(c("Dutch", "German"), 2),
                  RT=c(900, 1100, 1100, 900))



p<-ggplot(filter(df, Student=="NL"),
          aes(x=Word, y=RT, group=Student)) +
  geom_line(aes(color=Student), size=1)+
  geom_point(aes(color=Student), size=4) +
  theme_bw()
p

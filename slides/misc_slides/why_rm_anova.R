library(tidyverse)
theme_set(theme_bw())

d = read_csv("voices_music.csv") %>%
    pivot_longer(cols = -Subject, names_to="Condition", values_to="RT") %>%
    mutate(Subject=as.factor(Subject),
           Condition=fct_relevel(Condition, "Silence", "Voices", "Music"))

g = ggplot(d, aes(Condition, RT))

g + geom_point(shape=18, size = 4,
               mapping = aes(group = Subject),
               color = "black")


g2 <- g + geom_point(shape=18,
               mapping = aes(group = Subject,
                             color = Subject),
               size=4)

g2

g2 +  geom_line(mapping = aes(group = Subject,
                          color = Subject))





## example df
#df = data.frame( unemployed = c(3,2,1,1,4),
#               eduction   = c(5,2,4,2,3),
#               job        = c(7,4,5,3,6))

library(ggplot2)
library(dplyr)
library(tidyr)

.long_df <- function(df) {
  df %>%
    mutate(Subject = 1:n()) %>%
    pivot_longer(cols = c(1:ncol(df)),
                 names_to = "Group",
                 values_to="DV")
}

## anova table
manual_anova <- function(df) {
  n_group = ncol(df)
  n = nrow(df)

  df_T = n_group*n -1
  df_M = n_group -1
  df_R = df_T-df_M

  all = unlist(df)
  m = unlist(df %>% summarise(across(everything(), mean)))
  SS_T = sum((all-mean(all))**2)
  SS_M = sum((m-mean(all))**2)*n
  SS_R = sum((df[1]-m[1])**2) +
    sum((df[2]-m[2])**2) +
    sum((df[3]-m[3])**2)

  MS_M = SS_M / df_M
  MS_R = SS_R / df_R
  F = MS_M / MS_R
  p = 1-pf(F, df_M, df_R)
  anova_tab = data.frame(Source=c("Model", "Residual", "Total"),
                         SS = c(SS_M, SS_R, SS_T),
                         df = c(df_M, df_R, df_T),
                         MS = c(MS_M, MS_R, NA),
                         F = c(F, NA, NA),
                         p = c(p, NA, NA)
  )

  latex_apa_stat = paste0("F(", df_M, ",", df_R, ")=", round(F,2),
                        ", \\; p=", round(p, 2))
  return(list(table=anova_tab, F=F, p=p, df=c(df_M, df_R),
              latex_apa_stat = latex_apa_stat))
}

## plotting

plot_anova_base = function(df, gray_dots=FALSE, text_size=28, geom_size=6) {
  dfp = .long_df(df)
  rtn = ggplot(dfp, aes(x = Subject, y = DV)) +
    expand_limits(y=c(0,max(dfp$DV)), x=c(min(dfp$Subject)-0.5, max(dfp$Subject)+0.5)) +
    facet_grid(. ~ Group) +
    theme_bw() +
    theme(text = element_text(size = text_size), legend.position="none")
  if (gray_dots) rtn + geom_point(aes(color = Group, shape=Group), colour="gray", size=geom_size)
  else rtn + geom_point(aes(color = Group, shape=Group), size=geom_size)
}

lines_grand_mean = function() {
  geom_segment(aes(x=min(Subject)-0.5, xend=max(Subject)+0.5,
                   y=mean(DV), yend=mean(DV)), colour="black", size=0.5)
}

lines_group_means = function(df, size=2) {
  tmp = .long_df(df) %>%
    group_by(Group) %>%
    summarise(y = mean(DV), yend = y,
              x = min(Subject)-0.5, xend=max(Subject)+0.5)
  geom_segment(data=tmp, mapping=aes(x=x, xend=xend,  y=y, yend=yend,
                                     colour=Group), size=size)
}

lines_ss_residuals <- function(df, size=2){
  tmp = .long_df(df) %>%
    group_by(Group) %>%
    mutate(y = mean(DV), yend = DV, x = Subject, xend=Subject)
  geom_segment(data=tmp, mapping=aes(x=x, xend=xend,  y=y, yend=yend),
               color="black",  linetype="twodash", size=size)
}

lines_ss_total <- function(df, size=2){
  tmp = .long_df(df) %>%
    mutate(y = mean(DV), yend = DV, x = Subject, xend=Subject)
  geom_segment(data=tmp, mapping=aes(x=x, xend=xend,  y=y, yend=yend),
               color="black",  linetype="twodash", size=size)
}

lines_ss_model <- function(df, size=2){
  tmp = .long_df(df) %>%
    mutate(grand_mean = mean(DV)) %>%
    group_by(Group) %>%
    mutate(y = mean(DV), yend = grand_mean, x = Subject, xend=Subject)
  geom_segment(data=tmp, mapping=aes(x=x, xend=xend,  y=y, yend=yend),
               color="black",  linetype="twodash", size=size)
}

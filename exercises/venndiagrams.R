library(eulerr)

venn_diagram <- function(R2, r2YA, r2YB) {
  # r2YA, r2YB is part correlations!

  r2YAB = R2 - r2YA - r2YB
  fit <- euler(c(Y = 1 - r2YA - r2YB - r2YAB,
                 A = 1 - r2YA - r2YAB,
                 B = 1 - r2YB - r2YAB,
                 "Y&A" = r2YA,
                 "Y&B" = r2YB,
                 "Y&A&B" = R2 - r2YA - r2YB
  ))
}

eulerr_options(fills = list(fill = c("white", "green", "steelblue1"),
                    alpha=c(1, .4,.5), fontsize = 24))

# venn diagram from meeting 3

f = venn_diagram(R2 = .2173,  r2YA = .43^2, r2YB = .18^2)
plot(f, labels = c("Y", "X1", "X2"))

f = venn_diagram(R2 = .56,  r2YA = .11^2, r2YB = .61^2)
plot(f, labels = c("Y", "X1", "X3"))

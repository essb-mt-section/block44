# install renderthis install.packages("renderthis", dependencies = TRUE)

library(renderthis)

for (fl in list.files(pattern = "*.Rmd")) {
  to_html(fl, self_contained = TRUE)
}

# install renderthis install.packages("renderthis", dependencies = TRUE)

library(renderthis)

for (fl in list.files(pattern = "*.Rmd")) {
  #build_pdf(fl)
  build_html(fl, self_contained = TRUE)
}

# Lecture slides 5 to 8 for Block 4.4


## HTML presentations

To generate slides, `knitr` rmd-files of the slides using `xaringan` (see [xaringan Presentations](https://bookdown.org/yihui/rmarkdown/xaringan.html)).


## PDF

PDFs can be generated with `xaringanBuilder` (see [here](https://jhelvy.github.io/xaringanBuilder/)).

* Install `xaringanBuilder`
  * `remotes::install_github("jhelvy/xaringanBuilder", dependencies = TRUE)`
* generate PDF
  * `xaringanBuilder::build_pdf('LECTURE_SLIDES.Rmd')`


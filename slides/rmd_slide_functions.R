library(stringr)

add_slide_numbers_comments <- function(filename) {
  conn <- file(filename, open="r")
  lines <- readLines(conn)
  close(conn)

  c_start = "<!-- -"
  c_end = " -->"
  new = c()
  cnt = 0

  for (i in 1:length(lines)){
    if (str_starts(lines[i], "---")) {
      if (cnt>1) {
        new = c(new, paste0(c_start, strrep(" -", 33), " (", cnt, ")", c_end))
      }
      cnt = cnt + 1
    }
    if (!str_starts(lines[i], c_start)) { # do not include slide comments
      new = c(new, lines[i])
    }
  }

  conn <- file(filename, open="w")
  lines <- writeLines(text=new, con=conn)
  close(conn)
}



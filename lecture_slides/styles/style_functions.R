library(stringr)

vspace <- function(px) {
  paste0("<p style='padding-top: ", px, "px;'></p>\n")
}

.px <- function(value){  # add px is numeric
  if (is.numeric(value)) return(paste0(value, "px"))
  else return(value)
}

.html_style <- function(lst_options) {
  # parameter handled as px if numeric
  # set opacity (from 1 to 100) correctly
  rtn = 'style="'
  for (k in names(lst_options)) {
    val = lst_options[[k]]
    if (!is.na(val)){
      if (k=="opacity") {
        rtn = paste0(rtn, "opacity:", val/100,
                     "; filter:alpha(opacity=", val, "); ")
      } else {
        rtn = paste0(rtn, k, ":", .px(val), "; ")
      }
    }
  }
  return(paste0(rtn, '"'))
}

posbox <- function(width, top, left, opacity=NA){
  # opacity in percent 1--100
  paste0('<div class="posbox" ',
         .html_style(list(width=width, top=top, left=left, opacity=opacity)),
         ">\n")
}
end_posbox <- function(){paste0("\n</div>\n")}

image <- function(image, width=NA, height=NA, top=NA, left=NA, opacity=NA){
  # allows positioning of images

  rtn = ""
  abs_pos = !is.na(top) | !is.na(left)
  if (abs_pos)
    rtn = paste0(posbox(width = width, top=top, left=left))
  rtn = paste0(rtn, '<img src="', image, '" ')
  if (!is.na(width))
    rtn = paste0(rtn, 'width="', .px(width), '" ')
  if (!is.na(height))
    rtn = paste0(rtn, 'height="', .px(height), '" ')
  rtn = paste0(rtn, .html_style(list(display="block", margin="auto",
                                     opacity=opacity)), ">")
  if (abs_pos)
    rtn = paste0(rtn, end_posbox())
  return(rtn)
  }


## make slides in Rmd source

add_slide_numbers_comments <- function(filename) {
  conn <- file(filename, open="r")
  lines <- readLines(conn)
  close(conn)

  c_start = "<!-- -"
  c_end = " -->"
  new = c()
  cnt = 1

  for (i in 1:length(lines)){
    if (str_starts(lines[i], "---")) {
      if (cnt>2) {
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


#cat(posbox(200, 400, 100))




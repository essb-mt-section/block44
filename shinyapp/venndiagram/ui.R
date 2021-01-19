library(shiny)
library(shinyjs)
library(eulerr)

shinyUI(
      fluidPage(
        useShinyjs(),

        HTML('<table width=100%><tr><td valign="top">
           <H1>Venn Diagrams</H1>
           </td><td align="right">
           <img src="./Logo-EUR-black.png" width="150" alt="Erasmus University">
           <p><i><small><a href="http://www.cognitive-psychology.eu/lindemann/">
                                O. Lindemann</a></small></i></p>

           </td></tr></table>'),
        fluidRow(
          column(
            3,
            wellPanel(
              h3("Overlap (in %)"),
              HTML("<p><small><i>The percentage of overlap of two variables.</i></small></p>"),
              numericInput("YX1", label="Y  & X1", value= 0, min = 0, max=100, width=80),
              numericInput("YX2", label="Y  & X2", value=0, min = 0, max=100, width=80),
              numericInput("X1X2", label="X1 & X2", value=0, min = 0, max=100, width=80),
              numericInput("YX1X2", label="Y & X1 & X2", value=0, min = 0, max=100, width=80)
              ),
            tableOutput("table")
          ),
          column(
            6,
            plotOutput("euler_diagram", height = "500px"),
            textOutput("citation")
          ),
          column(
            3,
            strong("Colors"),
            em(p("A comma-separated list of ",
                 a(href = "https://stat.columbia.edu/~tzheng/files/Rcolor.pdf",
                   "x11"),
              "or",
              a(href = "https://en.wikipedia.org/wiki/Web_colors#Hex_triplet",
                "hex colors."))),
            textInput(
              inputId = "fill",
              label = NULL,
              value = "",
              placeholder = "grey70, white, steelblue4",
              width = "100%"
            ),
            fluidRow(
              column(
                8,
                conditionalPanel(
                  condition = "input.legend == true",
                  selectInput("legend_side", NULL, width = "100%",
                              list("right", "left", "top", "bottom"))
                )
              )
            ),
            numericInput(
              inputId = "pointsize",
              label = "Pointsize",
              value = 12,
              min = 1,
              max = 100,
              step = 1,
              width = "100%"
            ),
            checkboxInput("quantities", "Show quantities", value = TRUE),
            sliderInput("alpha", "Opacity", min = 0, max = 1, value = 0.80,
                        width = "100%"),
            hr(),
            fluidRow(
              column(
                6,
                numericInput(
                  inputId = "width",
                  label = "Width (inches)",
                  value = 6,
                  width = "100%"
                )
              ),
              column(
                6,
                numericInput(
                  inputId = "height",
                  label = "Height (inches)",
                  value = 4,
                  width = "100%"
                )
              )
            ),
            fluidRow(
              column(
                6,
                downloadButton("download_plot", "Save plot")
              ),
              column(
                6,
                radioButtons(
                  "savetype",
                  NULL,
                  list("pdf", "png"),
                  inline = TRUE
                )
              )
            )
          ) #
        )
      )
)




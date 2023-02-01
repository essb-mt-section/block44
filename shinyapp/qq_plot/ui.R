library(shiny)

eur_title <- function(title) {
    rtn = paste0('<table style="background-color:#C6C7C9" width=100%>',
         '<tr><td valign="middle" style="padding-left: 10px;" >')
    rtn = paste0(rtn, "<H1>", title, "</H1>")
    rtn = paste0(rtn, '</td><td align="right" style="padding-right: 20px;">
        <img src="./Logo-EUR-black.png" width="150" alt="Erasmus University">
        <p><i><small>',
        '<a href="http://www.cognitive-psychology.eu/lindemann/">O. Lindemann</a>',
        '</small></i></p>
        </td></tr></table>',
        '<br><br>')
    return(HTML(rtn))
}

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    # Application title
    eur_title("Q-Q Plots"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(width=3,
              selectInput("sel_type", "Type of Violation of Normality", 
                                 choices = c("skewed", "bimodal", "fat tails")),
              sliderInput("b0",
                        "Non-Normality",
                        min = -10,
                        max = 10,
                        value = 0,
                        step = 1)
                      ),

        # Show a plot of the generated distribution
        mainPanel(
          column(width=6,
            plotOutput("distPlot")), 
          column(width=6, plotOutput("qqPlot"))
        )
    )
))

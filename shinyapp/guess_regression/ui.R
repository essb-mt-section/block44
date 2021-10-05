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
    eur_title("Guess the Regression!"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("sample_size",
                        label = "Sample Size",
                        choices = c(10, 25, 50, 75, 100, 150, 200, 300, 500, 1000),
                        selected = 50),
            actionButton("refresh", "New Sample"),
            br(),
            hr(),
            sliderInput("b0",
                        "Intercept",
                        min = -2,
                        max = 2,
                        value = -1,
                        step = 0.01),
            sliderInput("b1",
                        "Slope",
                        min = -1,
                        max = 1,
                        value = 0,
                        step = 0.01,),
            checkboxInput("cb_residuals", "Show Residuals", value = FALSE),
            checkboxInput("cb_showcorrect", "Show Correct", value = FALSE)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot"),
            uiOutput("parameter"),
            uiOutput("rss"),
            hr(),
            uiOutput("eq_solution")
        )
    )
))

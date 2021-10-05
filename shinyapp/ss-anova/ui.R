library(shiny)
library(rhandsontable)
source("formulars.R")

plot_size = list(width = "500px", height="280px")

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
ui <- shinyUI(fluidPage(

    eur_title("One-Way Between-Subject ANOVA"),
    fixedRow(
        column(5, wellPanel(
                helpText("The table below contains fictive data from three groups",
                         "with 5 subjects in each group." ,
                         "You can change the data in the table to see how this",
                         "affects the analysis."),
                br(),
                rHandsontableOutput("hot"),
                br(),
                actionButton("refresh", "Refresh Analysis", class = "btn-success")
                ),
        ) ,
        column(7,
               HTML("<center><b>Illustration of the Sum of Squares",
                    "</b></center></br>"),
               tabsetPanel(type = "pills",
                           tabPanel("Data", align="center",
                                    plotOutput("plot_raw_data", width = plot_size$width,
                                               height=plot_size$height)),
                           tabPanel("Group Means",  align="center",
                                    plotOutput("plot_group_means", width = plot_size$width,
                                               height=plot_size$height)),
                           tabPanel("Total SS",  align="center",
                                    plotOutput("plot_ss_total", width = plot_size$width,
                                               height=plot_size$height)),
                           tabPanel("Model SS",  align="center",
                                    plotOutput("plot_ss_model", width = plot_size$width,
                                               height=plot_size$height)),
                           tabPanel("Residual SS",  align="center",
                                    plotOutput("plot_ss_residuals", width = plot_size$width,
                                               height=plot_size$height))
               ))

    ),# end row
    fixedRow( column(12,
            uiOutput("fvalue"), HTML("<hr>")
    )),
    fixedRow( column(5,
                HTML("<center><b>ANOVA Table</b></center></br>"),
                tableOutput("anova_tab")
            ),
            column(7,
                   HTML("<center><b>Formulars</b></center></br>"),
                   tabsetPanel(type = "pills",
                                 tabPanel("SS",  withMathJax(HTML(
                                     formulars$ss_t, formulars$ss_m, formulars$ss_r))),
                                 tabPanel("df",  withMathJax(HTML(
                                     formulars$df_t, formulars$df_m, formulars$df_r))),
                                 tabPanel("F",  withMathJax(HTML(
                                     formulars$ms_m, formulars$ms_r, formulars$f)))
                     )
            )
    ), # end row


))

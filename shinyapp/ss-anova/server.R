library(shiny)
library(rhandsontable)
library(ggplot2)

source("manual_anova.R")

DF = data.frame( Group_A = c(3,2,1,1,4),
                 Group_B   = c(5,2,4,2,3),
                 Group_C        = c(7,4,5,3,6))
text_size=14
geom_size=4
line_size = 1

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {

    first_refresh = TRUE
    values <- reactiveValues()
    ## Handsontable
    observe({
        if (!is.null(input$hot)) {
            DF = hot_to_r(input$hot)
        } else {
            if (is.null(values[["DF"]]))
                DF <- DF
            else
                DF <- values[["DF"]]
        }
        values[["DF"]] <- DF
    })

    output$hot <- renderRHandsontable({
        df <- values[["DF"]]
        if (!is.null(df))
            rhandsontable(df, useTypes = FALSE, stretchH = "all")
    })


    refresh_df <- eventReactive((first_refresh | input$refresh), {
        first_refresh = FALSE
        values[["DF"]]
    })

    output$plot_raw_data <- renderPlot({
        df <- refresh_df()
        plot_anova_base(df, text_size=text_size, geom_size=geom_size) +
            lines_grand_mean() + ggtitle("Data and Grand Mean")
    })

    output$plot_group_means <- renderPlot({
        df <- refresh_df()
        plot_anova_base(df, text_size=text_size, geom_size=geom_size) +
            lines_group_means(df) + ggtitle("Data and Group Means")
    })

    output$plot_ss_total <- renderPlot({
        df <- refresh_df()
        plot_anova_base(df, text_size=text_size, geom_size=geom_size) +
                    lines_grand_mean() + lines_ss_total(df, size=line_size) +
                    ggtitle("Total SS")
    })

    output$plot_ss_residuals <- renderPlot({
        df <- refresh_df()
        plot_anova_base(df, text_size=text_size, geom_size=geom_size) +
            lines_group_means(df) + lines_ss_residuals(df, size=line_size) +
            ggtitle("Residual SS")
    })

    output$plot_ss_model <- renderPlot({
        df <- refresh_df()
        plot_anova_base(df, text_size=text_size, geom_size=geom_size, gray_dots = TRUE) +
            lines_group_means(df) + lines_ss_model(df, size=line_size) +
            lines_grand_mean() + ggtitle("Model SS")
    })

    output$anova_tab <- renderTable(na = "", digits = 2, {
        df <- refresh_df()
        manual_anova(df)$table
    })

    output$fvalue <- renderUI({
        df <- refresh_df()
        aov = manual_anova(df)
        withMathJax(HTML( paste0("$$", aov$latex_apa_stat, "$$")))
    })

})

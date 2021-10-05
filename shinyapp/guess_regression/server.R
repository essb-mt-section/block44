library(shiny)
library(tidyverse)
library(MASS)

rbeta_negative = function(n, shape1, shape2, p_negative) {
    # beta distribution with random negativity
    rbeta(n, shape1, shape2) * (1-2*rbernoulli(n=n, p=p_negative))
}

cor_data <- function(n, cor, mu) {
    Sigma <- matrix(cor, nrow=2, ncol=2) + diag(2)*(1-cor)
    df <- as_tibble(mvrnorm(n=n, mu=mu, Sigma=Sigma)) %>%
        rename("x"="V1", "y"="V2")
    return(df)
}

reg_line = function(b0, b1, color="blue", size=1.2) {
    return(geom_line(aes(x=x, y=b0+b1*x),
                     color=color, size=size))
}

residual_lines = function(b0, b1) {
    return(geom_segment(aes(x=x, y=y, xend=x, yend=b0+b1*x), color="red"))
}

mhtml <- function(...){withMathJax(HTML(paste0(...)))}

regession_num_feedback <- function(df, b0, b1, show_rss=FALSE) {
    rtn = paste0("$$", " y_i= ", round(b0, 2), "+" , round(b1, 2))
    if (show_rss) {
        rss = sum((df$y-(b0 + b1*df$x))^2)
        rtn = paste0(rtn, ", \\quad \\text{RSS}=", round(rss, 3))
    }
    return(paste0(rtn, "$$"))
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    data <- reactiveValues()

    observe({
        if (input$refresh>-1) {
            data$df <- cor_data(n=as.numeric(input$sample_size),
                                cor = rbeta_negative(1, 3, 2, p_negative=0.25),
                                mu = c(0, 0))
            data$lm_model <- lm(y ~ x, data = data$df)
            data$b0 = as.numeric(data$lm_model$coefficients[1])
            data$b1 = as.numeric(data$lm_model$coefficients[2])
            data$r_squared =  summary(data$lm_model)$r.squared
            updateSliderInput(inputId="b0", value = -1)
            updateSliderInput(inputId="b1", value = 0)
        }
    })

    output$distPlot <- renderPlot({
        b0 = input$b0
        b1 = input$b1
        plt = ggplot(data$df, aes(x=x, y=y)) +
            geom_point(size=2) +
            theme_classic()
        if (input$cb_showcorrect)
            plt = plt  + reg_line(data$b0, data$b1, size=0.5, color = "green")
        if (input$cb_residuals)
            plt = plt  + residual_lines(b0, b1)

        return(plt  + reg_line(b0, b1, "blue"))
    })

    output$eq_solution <- renderUI({
        if (input$cb_showcorrect) {
            mhtml("<p>", "Solution:",
                  regession_num_feedback(df=data$df,
                             b0 = data$b0, b1 = data$b1,
                             show_rss = input$cb_residuals),
                  "$$r^2 = ", round(data$r_squared, 2), "$$",
                  "</p>")
        } else {HTML("")}
    })

    output$parameter <- renderUI({
        mhtml("<p>", "Regression equation:",
              regession_num_feedback(df=data$df, b0=input$b0, b1=input$b1,
                                     show_rss = input$cb_residuals),
            "</p>")
    })

    output$rss_formular <- renderUI({
        mhtml("$$", "\\text{RSS} = \\sum_{i=1}^n (y_i - (\\hat\\alpha + \\hat\\beta x_i))^2",
              "$$")
    })


})



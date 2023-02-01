library(shiny)
library(shinyjs)
library(tibble)
library(ggplot2)
library(sn)

skewed <- function(n, v) {
  tibble(x = rsn(n=n, xi=v, omega=1, alpha=v))
}



bimodal <-function(n, ma, mb, sa=1, sb=1) {
  a = rnorm(n=n/2, mean=ma, sd=sa)
  b = rnorm(n=n/2, mean=mb, sd=sb)
  tibble(x = c(a,b))
}

fat_tails <- function(n, v) {
  if (v==0) {
    n_fat = 1
  } else {
    n_fat = round(n * (v/10) )
  }
  
  a = runif(n=n_fat, min=-4, max=4)
  b = rnorm(n=n-n_fat, mean=0, sd=1)
  tibble(x = c(a,b))
}


plot_histo <- function(df) {
  desc = list(mean = mean(df$x), 
              sd = sd(df$x))
  ggplot(df, aes(x = x)) +
    stat_function(fun = dnorm,  args = desc,  color =  "white",
                  geom = "area", fill = "#84CA72", alpha = .5) +
    geom_histogram(aes(y = ..density..), binwidth=0.1, 
                   alpha = .8, fill = "blue") +
    xlim(floor(desc$mean-3*desc$sd), 
         ceiling(desc$mean+3*desc$sd)) 
}

plot_qq <- function(df) {
  ggplot(df, aes(sample = x)) +
    stat_qq() + 
    stat_qq_line()
}

mhtml <- function(...){withMathJax(HTML(paste0(...)))}


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  n <- 10000  
  data <- reactiveValues(b0=-9)
    
    observeEvent(input$sel_type, {
      if (input$sel_type == "skewed") {
        updateSliderInput(inputId="b0",
                    min = -10,
                    max = 10,
                    value = 0,
                    step = 1)
      } else if  (input$sel_type == "bimodal") {
        updateSliderInput(inputId="b0",
                          min = 0,
                          max = 10,
                          value = 0,
                          step = 1)
      } else if  (input$sel_type == "fat tails") {
        updateSliderInput(inputId="b0",
                          min = 0,
                          max = 10,
                          value = 0,
                          step = 1)
      }
    })

    observe({
      if (data$b0 != input$b0) {
        data$b0 = input$b0
        if (input$sel_type == "skewed") {
          data$df <- skewed(n=n, v= -1*input$b0)
        } else if  (input$sel_type == "bimodal") {
          data$df <- bimodal(n, ma=input$b0, mb=0, sa=2, sb=2)
        } else if  (input$sel_type == "fat tails") {
          data$df <- fat_tails(n, v=input$b0)
        }
      }
    })
    

    output$distPlot <- renderPlot({
        plt = plot_histo(data$df) +
           theme(aspect.ratio=1) 
        return(plt)
    })


    output$qqPlot <- renderPlot({
      plt = plot_qq(data$df) +
        theme(aspect.ratio=1) 
      return(plt)
    })
    
})



    #  A simple application to find MODIS tiles
    #  Josh Nowak
    #  08/2016
################################################################################
    #  Load packages
    require(shiny)
################################################################################
    #  Define user interface
    shinyUI(
      fluidPage(
        #  Give the page a title
        titlePanel("Base UI + First Server Intx"),

        #  Create basic layout with a sidebar on the left and tabs on the right
        sidebarLayout(
          #  The sidebarPanel holds all the elements on the left
          sidebarPanel(
            sliderInput("n_obs", "Number of Observations",
              value = 10,
              min = 10,
              max = 1000,
              step = 10,
              round = T,
              width = "100%"
            ),
            hr(),
            numericInput("n_cov", "Number of Covariates",
              value = 1,
              min = 1,
              max = 5,
              step = 1,
              width = "100%"
            )
          ),
          #  The mainPanel hold the elements on the right
          mainPanel(
            #  Report the values of the user inputs
            verbatimTextOutput("print_inputs")
          )
        )
      , title = "My First App")
    )
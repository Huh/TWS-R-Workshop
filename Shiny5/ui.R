    #  A simple application to find MODIS tiles
    #  Josh Nowak
    #  08/2016
################################################################################
    #  Load packages
    require(shiny)
    require(DT)
################################################################################
    #  Define user interface
    shinyUI(
      fluidPage(
        #  Give the page a title
        titlePanel("Sim/Fit App"),

        #  Create basic layout with a sidebar on the left and tabs on the right
        sidebarLayout(
          #  The sidebarPanel holds all the elements on the left
          sidebarPanel(
            sliderInput(
              "n_obs",
              "Number of Observations",
              value = 10,
              min = 10,
              max = 1000,
              step = 10,
              round = T,
              width = "100%"
            ),
            hr(),
            numericInput(
              "n_cov",
              "Number of Covariates",
              value = 1,
              min = 0,
              max = 5,
              step = 1,
              width = "100%"
            ),
            hr(),
            numericInput(
              "inter",
              "Intercept Value",
              value = 1,
              min = -99,
              max = 99,
              width = "100%"
            ),
            hr(),
            h4("Coefficients"),
            uiOutput("dynamic_ui"),
            hr(),
            #  Here we use the title argument to create a popup for to help the
            #   user
            tags$div(title = "Enter a valid R formula (e.g. ~ cov1 + cov2) for building the model matrix",
              textInput(
                "formula",
                "Formula",
                placeholder = "~ rain + snow"
              )
            ),
            hr(),
            radioButtons(
              "distr",
              "Error Distribution",
              choices = c("Normal")#, "Binomial")
            ),
            hr(),
            conditionalPanel(
              condition = "input.distr == 'Normal'",
              numericInput(
                "sd",
                "Standard Deviation",
                min = 0.001,
                max = 999,
                value = 1
              )
            ),
            conditionalPanel(
              condition = "input.distr == 'Binomial'",
              numericInput(
                "sz",
                "Size Parameter",
                min = 1,
                max = 999,
                value = 1,
                step = 1
              )
            ),
            hr(),
            tags$div(title = "Click to create data",
              actionButton(
                "sim_go",
                "Simulate Data",
                icon = icon("gears"),
                width = "100%",
                style = "background-color:#DC143C;color:#FFFFFF"
              )
            )
          ),
          #  The mainPanel hold the elements on the right
          mainPanel(
            tabsetPanel(type = "pills",
              tabPanel("Simulated Data",
                hr(),
                DT::dataTableOutput("sim_table")
              ),
              tabPanel("Model Fit",
                hr(),
                verbatimTextOutput("fit_print")
              )
            )
          )
        )
      , title = "My First App")
    )
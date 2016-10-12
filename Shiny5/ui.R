    #  Load packages
    require(shiny)
    require(DT)
################################################################################
    #  Define user interface
    shinyUI(
      fixedPage(
        #  Give the page a title
        titlePanel("Super Cool SimFit #1"),
        #  A link to the GitHub repository containing the code and help
        tags$a(
          href = "https://github.com/Huh/TWS-R-Workshop",
          "Click here to see the code repository and get help"
        ),
        #  A little CSS to add some padding
        tags$div(style = "padding-bottom: 25px"),
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
            #  Here we use the title argument to create a popup for to help the
            #   user
            tags$div(title = "Enter a valid R formula (e.g. ~ rain + temp)",
              textInput(
                "formula",
                "Formula (minus response)",
                placeholder = "~ rain + temp"
              )
            ),
            hr(),
            uiOutput("dynamic_ui"),
            tags$div(title = "Choose a distribution for the residual error.",
              radioButtons(
                "distr",
                "Error Distribution",
                choices = "Normal"
              )
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
            hr(),
            tags$div(title = "When you are happy with your data and formula click here to fit a model to your data",
              actionButton(
                "fit_go",
                "Fit Model",
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
                h4("Formula Validation"),
                verbatimTextOutput("print_formula"),
                hr(),
                h4("Model Matrix"),
                DT::dataTableOutput("obs_data"),
              value = "SimulateTab"
              ),
              tabPanel("Model Fit",
                hr(),
                verbatimTextOutput("fit_print"),
              value = "FitTab"
              ),
              id = "simfit_tabs"
            )
          )
        )
      )
    )
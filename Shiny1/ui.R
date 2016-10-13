    #  A simple application to find MODIS tiles
    #  Josh Nowak
    #  08/2016
################################################################################
    #  Load packages
    require(shiny)
################################################################################
    #  Define user interface
    shinyUI(
      fixedPage(
        #  Give the page a title
        titlePanel("Basic UI Layout"),

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
                "Formula",
                placeholder = "~ rain + temp"
              )
            )
          ),
          #  The mainPanel hold the elements on the right
          mainPanel(

          )
        )
      )
    )
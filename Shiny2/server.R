    #  Server file for linear model simulation and fitting
    #  Josh Nowak
    #  08/2016
################################################################################
    #  Load required packages
    require(shiny)
################################################################################
    shinyServer(function(input, output, session){
      #  The server reports user inputs in this example what it is doing

      #  Render input settings to screen so user can see what is happening
      output$print_inputs <- renderText({
        req(input$n_obs, input$n_cov)

        paste(
          "User chose", input$n_obs, "observations and", input$n_cov,
            "covariates"
        )

      })

    })
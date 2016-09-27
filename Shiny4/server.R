    #  Server file for linear model simulation and fitting
    #  Josh Nowak
    #  08/2016
################################################################################
    #  Load required packages
    require(shiny)
################################################################################
    shinyServer(function(input, output, session){
      #  The server creates the dynamic UI elements in this example and reports
      #   what it is doing
      output$dynamic_ui <- renderUI({
        #  Require that n_cov has a value before anything is done
        req(input$n_cov, input$n_cov > 0)

        #  Create a text input for the coefficient name and a numeric input for
        #   the value of the coefficient
        #  Using a loop allows us to deal with a changing number of inputs and
        #   creating a loop using lapply returns a list, which is the necessary
        #   class
        lapply(1:input$n_cov, function(i){
          list(
            fluidRow(
              column(6,
                textInput(
                  inputId = paste0("cov_nm", i),
                  label = ifelse(i == 1, "Name", ""),
                  placeholder = "Name"
                )
              ),
              column(6,
                tags$div(
                  numericInput(
                    inputId = paste0("cov_val", i),
                    label = ifelse(i == 1, "Value", ""),
                    value = 0,
                    min = -10,
                    max = 10,
                    step = 0.1
                  ),
                  style = "margin:0"
                )
              )
            )
          )
        })

      })

      #  Render input settings to screen so user can see what is happening
      output$print_inputs <- renderText({
        req(input$n_obs, input$n_cov)

        paste(
          "User chose", format(input$n_obs, big.mark = ","), "observations and",
            input$n_cov, "covariate(s)"
        )

      })

    })
    #  Server file for linear model simulation and fitting
    #  Josh Nowak
    #  08/2016
################################################################################
    #  Load required packages
    require(shiny)
    require(DT)
################################################################################
    #  Source functions - done outside of server code so it is loaded once and
    #   available everywhere
    source("functions/simulate.R")
    source("functions/helpers.R")
################################################################################
    shinyServer(function(input, output, session){
      #  In this version the server is fully functional

      #  Create dynamic name/value inputs for covariates
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

      #  Within reactive environment make the simulation dependent on the user
      #   clicking the button
      #  First create a reactive container to hold the output of the simulation
      #   and the fit
      simfit <- reactiveValues()
      #  Now create a dependency on the sim_go button and only execute the
      #   code when it is pressed
      observeEvent(input$sim_go, {
        withProgress(message = "Running Simulation", {
          hold <- try(sim_funs$simfit(input))
        })

        if(class(hold) == "try-error"){
          #  Set simfit to NULL so plots and tables fail
          simfit$out <- NULL

          showModal(
            modalDialog(
              title = "Error in simulation",
              "Something failed, please check your inputs and try again",
              easyClose = T
            )
          )
        }else{
          simfit$out <- hold
        }

      })

      # Create a table so user can explore the simulated data
      output$sim_table <- DT::renderDataTable({
        req(simfit$out)

        df <- data.frame(
          Response = simfit$out$Data$ObsData,
          simfit$out$Data$CovObs
        )

        #print(head(df))

        DT::datatable(
          round(df, 2),
          rownames = T,
          filter = "top",
          selection = "multiple",
          style = "bootstrap"
        )
      })

      output$fit_print <- renderPrint({
        req(simfit$out)

        summary(simfit$out$Fit)
      })
    })
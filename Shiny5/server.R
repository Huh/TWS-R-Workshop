    #  Server file for linear model simulation and fitting
    #  Josh Nowak
    #  08/2016
################################################################################
    #  Load required packages
    require(shiny)
    require(DT)
################################################################################
    source("utility_functions/sim_funs.R")
    source("utility_functions/helpers.R")
################################################################################
    shinyServer(function(input, output, session){
      #  Because we validate the formula below we should store that result so
      #   we can use it and do not have to perform the same calculation again.
      #  This step simply creates a reactive objective where we can store the
      #   outcome of the validation step.
      form_valid <- reactiveValues()

      #  Create another reactive object to hold the result of our calculations
      hold <- reactiveValues()

      #  Now we will add in some dynamic user inputs
      #  The inputs are described by the formula and so we will extract the
      #   information we need and build the components on the server side, which
      #   will be sent to the user's browser
      output$dynamic_ui <- renderUI({
        #  We can't do anything until the data is built, so require it as a
        #   prerequisite before any code is run
        req(hold$cnms)

        #  Create a numeric input for the value of each coefficient
        #  Using a loop allows us to deal with a changing number of inputs and
        #   creating a loop using lapply returns a list, which is the necessary
        #   class
        lapply(1:length(hold$cnms), function(i){
          tags$div(
            numericInput(
              inputId = paste0("cov", i),
              label = paste("Effect of", hold$cnms[i]),
              value = 0,
              min = -10,
              max = 10,
              step = 0.1
            ),
            style = "margin:0"
          )
        })
      })

      #  Check if the formula input by the user is correct and print what you
      #   find back to the screen
      output$print_formula <- renderText({
        #  Require that input$formula exists before you try to do anything with
        #   it
        req(input$formula)

        frmla <- try(formula(input$formula), silent = T)

        if(class(frmla) == "try-error"){
          form_valid$result <- FALSE
          out <- "Sorry, but that is not a valid formula.  Try again?"
        }else{
          form_valid$result <- TRUE
          out <- "Nice work!  That is a good lookin' formula."
        }
      return(out)
      })

      #  Create model matrix and get names of variables when inputs change
      observe({
        req(input$formula, form_valid$result)

        #  If the formula is not valid then don't do anything
        if(form_valid$result){
          #  Build model matrix
          hold$data <- try(build_mm(input))
          hold$cnms <- try(colnames(hold$data$mm))
        }
      })

      #  Show the user the simulated data in a pretty table, notice we put the
      #   call to build_mm within this render.  This works because it is a
      #   reactive environment.  The object hold is "global" and so it is
      #   available to other functions too!
      output$obs_data <- renderDataTable({
        req(hold$data$mm)

        if(form_valid$result){

          DT::datatable(
            round(hold$data$mm, 2),
            rownames = F,
            filter = "top",
            selection = "multiple",
            style = "bootstrap"
          )
        }else{
          DT::datatable(
            data.frame(thoughts = "this is awkward"),
            rownames = F,
            filter = "top",
            selection = "multiple",
            style = "bootstrap"
          )
        }

      })

      #  Within reactive environment fit a model to the data when the user
      #   clicks on the fit_go button
      #  Create a dependency on the sim_go button and only execute the
      #   code when it is pressed
      observeEvent(input$fit_go, {
        #  Ahhh, pretty progress bar
        withProgress(message = "Running Simulation", {
          #  Finish simulating data
          hold$obs <- try(add_error(hold$data$mm, input))
          #  Fit the model
          mod_out <- try(fit_glm(hold, input), silent = T)
        })

        if(class(mod_out)[1] == "try-error"){
          #  Set simfit to NULL so plots and tables fail
          hold$results <- NULL

          showModal(
            modalDialog(
              title = "Error encountered when fitting model",
              "Something failed, please check your inputs and try again.",
              footer = tags$a(
                href = 'https://github.com/Huh/TWS-R-Workshop/issues',
                'Report bugs and review known issues at this link'
              ),
              easyClose = T
            )
          )

        }else{
          hold$results <- mod_out
        }

      })

      #  Print the model summary back to the user after it has run
      output$fit_print <- renderPrint({
        req(hold$results)

        summary(hold$results)
      })

      #  By default shiny haults actions on tabs once the user navigates away,
      #  this is undesirable behavior that is fixed by the code below
      output$activeTab <- reactive({
        return(input$tab)
      })
      outputOptions(output, 'activeTab', suspendWhenHidden = FALSE)

    })
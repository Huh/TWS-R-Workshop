    #  Server file for linear model simulation and fitting
    #  Josh Nowak
    #  08/2016
################################################################################
    #  Load required packages
    require(shiny)
    require(DT)
################################################################################
    source("utility_functions/sim_funs.R")
################################################################################
    shinyServer(function(input, output, session){
      #  Because we validate the formula below we should store that result so
      #   we can use it and do not have to perform the same calculation again.
      #  This step simply creates a reactive objective where we can store the
      #   outcome of the validation step.
      form_valid <- reactiveValues()

      #  Create another reactive object to hold the result of our calculations
      hold <- reactiveValues()

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

      #  Show the user the simulated data in a pretty table, notice we put the
      #   call to build_mm within this render.  This works because it is a
      #   reactive environment.  The object hold is "global" and so it is
      #   available to other functions too!
      output$obs_data <- renderDataTable({
        req(input$formula)

        if(form_valid$result){
          hold$data <- build_mm(input)
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
    })
    #  Server file for linear model simulation and fitting
    #  Josh Nowak
    #  08/2016
################################################################################
    #  Load required packages
    require(shiny)
################################################################################
    shinyServer(function(input, output, session){
      #  Check if the formula input by the user is correct and print what you
      #   find back to the screen
      output$print_formula <- renderText({
        #  Require that input$formula exists before you try to do anything with
        #   it
        req(input$formula)

        frmla <- try(formula(input$formula), silent = T)

        if(class(frmla) == "try-error"){
          out <- "Sorry, but that is not a valid formula.  Try again?"
        }else{
          out <- "Nice work!  That is a good lookin' formula."
        }
      return(out)
      })
    })
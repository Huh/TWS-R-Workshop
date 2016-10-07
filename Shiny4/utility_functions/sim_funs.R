

    model_defs <- function(input){
      #  A function to parse a formula into the parts of the model definition
      #   needed to simulate data and build the ui
      #  Takes input object, from which the formula is extracted
      #  Returns a list, which is a modified version of the terms attributes
      #   of the formula
      
      #  Coerce character string to formula so we can use the pieces
      frmla <- formula(input$formula)

      #  Extract terms
      trm <- terms(frmla)

      #  Extract the attributes of the trm object so we don't repeat ourselves
      out <- attributes(trm)

      #  We will need to know the number of variables, so add them to the
      #   list of attributes
      out$vars <- all.vars(frmla)

      #  Calculate the number of coefficients given the formula so we know 
      #   how many coefficient values are needed for the model
      out$ncoef <- length(out$term.labels)
      
      #  We will want the formula later when building the model matrix, so 
      #   append it to our list
      out$formula <- frmla

    return(out)
    }
################################################################################
    build_cov_obs <- function(input){
      #  A function to build observations of covariate values
      #  Takes shiny input object and calls model_defs function
      #  Returns a data.frame with one column for each covariate
      #  Note: categorical covariates are not considered, but the extension 
      #   follows the same pattern as the continuous with the added complexity 
      #   of needing to define the number of levels in each covariate

      #  Call model_defs to get the definitions of the model
      out <- model_defs(input)

      #  Create values for continuous covariates
      #   We assume that covariate values are centered and scaled, so the mean 
      #    is 0 and the SD 1
      #  Need a data.frame b/c it is required by model.matrix later on
      cov_obs <- data.frame(
        replicate(
          length(out$vars), 
          rnorm(input$n_obs, 0, 1)
        )
      )

      #  Set column names because we need them later when calling model.matrix
      colnames(cov_obs) <- out$vars

      #  Assign out to the out list
      out$cov_obs <- cov_obs

    return(out)
    }
################################################################################
    build_mm <- function(input){
      #  A function to build the model matrix for simulation
      #  Takes shiny input object
      #  Returns a list consisting of output of model_defs, build_cov_obs and
      #   the call to model.matrix
      #  For this UI all of these calculations are described by the number of 
      #   observations and the formula definition and so it is the output of 
      #   this function that is required to build the remainder of the UI and
      #   upon user interaction simulate data

      #  Build data set and implicitly call model_defs
      out <- build_cov_obs(input)

      #  Build model matrix
      out$mm <- model.matrix(out$formula, data = out$cov_obs)
    
    return(out)
    }
################################################################################
    #  End
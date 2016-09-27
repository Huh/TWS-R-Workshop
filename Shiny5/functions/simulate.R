    #  Functions to simulate and fit linear models
    #  The functions are purposely incomplete and lacking features because these
    #   were written as a training tool.  That said, all of the code is fully 
    #   functional.
    #  Josh Nowak
    #  09/2016
################################################################################
    #  Package dependency list - none required
################################################################################
    #  We store the functions in a list to reduce the number of objects in our
    #   workspace and make the calling of the functions/workflow succinct
    sim_funs <- list()
################################################################################
    sim_funs$build_coef_df <- function(input){
      #  A function to create a df of the names and values of each 
      #   covariate/coefficient
      #  Takes shiny input object, uses cov_nm and cov_val
      #  Returns a data.frame with one column for names and one for values
    
      out <- data.frame(
        Name = c(
          "(Intercept)", 
          tolower(as.character(getParams("cov_nm", input)))
        ),
        Value = c(
          input$inter,
          as.numeric(getParams("cov_val", input))
        ),
        stringsAsFactors = F)

    return(out)
    }
################################################################################
    sim_funs$build_cov_obs <- function(input){
      #  A function to build observations of covariate values
      #  Takes shiny input object, uses n_cov and n_obs
      #  Returns a data.frame with one column for each covariate
      #  Note: categorical covariates are not considered, but the extension 
      #   follows the same pattern as the continuous with the added complexity 
      #   of needing to define the number of levels in each covariate

      #  Create values for continuous covariates
      #   The number of continuous covariates is input$n_cov in the ui
      #   We assume that covariate values are centered and scaled, so the mean 
      #    is 0 and the SD 1
      out <- replicate(
          input$n_cov, 
          rnorm(input$n_obs, 0, 1)
      )

      #  Set column names because we need them later when calling model.matrix
      colnames(out) <- tolower(as.character(getParams("cov_nm", input)))

    #  Return a data.frame b/c it is required by model.matrix
    return(data.frame(out))
    }
################################################################################
    sim_funs$build_mm <- function(input){
    
    
      hold <- lapply(sim_funs[1:2], function(f) f(input) )

      #  Basic check to be sure that input$formula can be converted to a formula
      if(grepl("~", input$formula)){
        frmla <- as.formula(tolower(input$formula))
      }else{
        frmla <- as.formula(tolower(paste0("~", input$formula)))
      }

      #  Build model matrix
      mm <- model.matrix(frmla, data = hold$build_cov_obs)
    
    list(Coefs = hold[[1]], CovObs = hold[[2]], ModMatrix = mm, Formula = frmla)
    }
################################################################################
    sim_funs$build_lp <- function(input){
    
      tmp <- sim_funs$build_mm(input)
      
      #  Check that coefficients entered match model formula/matrix
      coefs <- tmp$Coefs[tmp$Coefs$Name %in% colnames(tmp$ModMatrix),]
      
      lp <- tmp$ModMatrix %*% coefs$Value

      #  Apply link function if required
      out <- switch(
        input$distr,
        "Normal" = lp,
        "Binomial" = plogis(lp)
      )

    c(tmp, list(LinearPredictor = out))
    }
################################################################################
    sim_funs$add_error <- function(input){
      
      lp <- sim_funs$build_lp(input)
      
      out <- switch(
        input$distr,
        "Normal" = rnorm(input$n_obs, lp$LinearPredictor, input$sd),
        "Binomial" = rbinom(input$n_obs, input$sz, lp$LinearPredictor)
      )
    
    c(lp, list(ObsData = out))
    }
################################################################################
    sim_funs$simfit <- function(input){
    
      obs <- sim_funs$add_error(input)

      frmla <- paste(c("y", as.character(obs$Formula)), collapse = "")
      
      fitData <- data.frame(
        y = obs$ObsData,
        obs$CovObs
      )

      #  Binomial not quite right because of required response structure, see
      #   ?glm for explanation of what binomial response should look like
      fit <- switch(
        input$distr,
        "Normal" = lm(frmla, data = fitData)#,
        #"Binomial" = glm(frmla, data = fitData, family = binomial)
      )
    
    list(Data = obs, Fit = fit)
    }
################################################################################
    #  End
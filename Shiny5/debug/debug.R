    #  Shiny application debugging script
    #  Josh Nowak
    #  08/2016
################################################################################
    #  Package dependencies
    #  Required for sourcing functions from GitHub
    require(downloader)
################################################################################
    #  Source required functions from GitHub, this avoids the working directory 
    #   issue
    #  Source plotting functions one script at a time
    #  Get key from GitHub
    std_key <- sha_url("https://raw.githubusercontent.com/Huh/TWS-R-Workshop/master/Shiny5/functions/helpers.R",
      cmd = F)
    #  Source code
    source_url("https://raw.githubusercontent.com/Huh/TWS-R-Workshop/master/Shiny5/functions/helpers.R", 
      sha = std_key)
    std_key <- sha_url("https://raw.githubusercontent.com/Huh/TWS-R-Workshop/master/Shiny5/functions/simulate.R", 
      cmd = F)
    source_url("https://raw.githubusercontent.com/Huh/TWS-R-Workshop/master/Shiny5/functions/simulate.R",
      sha = std_key)
################################################################################
    #  Mimic shiny inputs
    input <- list()
    #  Residual error distribution
    input$distr <- "Normal"
    #  If Normal then specify SD
    input$sd <- 1.1
    #  Number of observations
    input$n_obs <- 10
    #  Valid R formula
    input$formula <- "~Snow*rain"
################################################################################
    #  The first function defines the model and creates all the necessary 
    #   parameters for building the dataset and running the model
    #  Not normally called by the user, but useful for debugging
    md <- model_defs(input)

    #  The second function builds observed covariate values from model defs
    #  It call model_defs and is also not usually called directly
    cov_obs <- build_cov_obs(input)

    #  The third function calls cov_obs and creates the model matrix, the 
    #   actual interpretation of the formula, we will use this output in future
    #   functions.  In our application this is stored in a reactive container 
    #   that works like a list, so mimic that with a list here.
    hold <- list()
    hold$data <- build_mm(input)

    #  Within the application several UI elements are dynamically created.  Here
    #   we mimic that behavior with a for loop
    cnms <- colnames(hold$data$mm)
    for(i in 1:length(cnms)){
      #  Assign some value for the coefficient 
      input[[length(input)+1]] <- runif(1, -2, 2)
      #  Name the last input element as we did in the Shiny application
      names(input)[length(input)] <- paste0("cov", i)
    }

    #  Next we need to build the linear predictor
    #  This function typically called by add_error function
    lp <- build_lp(hold$data$mm, input)

    #  Last simulation step is to add the residual error we desire
    #  This relies on the build_lp function, input$distr and input$sd
    hold$obs <- add_error(hold$data$mm, input)
    
    #  To be clear the workflow is repeated below the way it is in Shiny
    hold <- list()
    hold$data <- build_mm(input)
    hold$obs <- add_error(hold$data$mm, input)
    #  That ends data simulation, next we fit a model
################################################################################
    #  Call fit_glm to fit the model
    hold$results <- fit_glm(hold, input)
    summary(hold$results)
################################################################################
    #  End
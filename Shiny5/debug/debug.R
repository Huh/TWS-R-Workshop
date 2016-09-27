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
    #  Source plotting functions
    #  Get key from GitHub
    std_key <- sha_url("https://raw.githubusercontent.com/Huh/ID_Mule_Deer/master/Plotting_Functions/std_plots.R",
      cmd = F)
    #  Source code
    source_url("https://raw.githubusercontent.com/Huh/ID_Mule_Deer/master/Plotting_Functions/std_plots.R", 
      sha = std_key)
################################################################################
    #  Mimic shiny inputs
    input <- list()
    #  Number of observations
    input$n_obs <- 10
    #  Number of covariates
    input$n_cov <- 3
    #  Value of the intercept
    input$inter <- 0.5
    #  The next input is dynamic, here we fake it manually, but we could 
    #   automate this...note that input$n_cov is 3, so we need 3 values and 
    #   names
    #  Coefficient Names
    input$cov_nm1 <- "Rain"
    input$cov_nm2 <- "Snow"
    input$cov_nm3 <- "Weight"
    #  Coefficient Values
    input$cov_val1 <- 0.1
    input$cov_val2 <- -0.4
    input$cov_val3 <- 0.03
    #  Valid R formula
    input$formula <- "~Rain+Snow+Weight"
    #  Error distribution choice
    input$distr <- "Normal"
    #  If Normal we need the SD
    input$sd <- 1.5
    #  If Binomial we need a size parameter
    input$sz <- NULL
################################################################################
    #  One step workflow
    simfit <- sim_funs$simfit(input)

    
    
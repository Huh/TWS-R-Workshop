    #  Helper functions for the sim/fit application
    #  Josh Nowak
    #  09/2016
################################################################################
    getParams <- function(prefix, input) {
      #  A function to extract input parameters based on some prefix
      #  This is necessary bc Shiny will not allow simple single bracket 
      #   indexing of the input object
      #  Takes a prefix and the shiny input object
      #  Returns subset input object as named list
    
      index <- names(input)[which(grepl(prefix, names(input)))]
      
      params <- lapply(index, function(x){
        input[[x]]
      })
      
      names(params) <- index
    return(params)
    }
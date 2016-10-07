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
################################################################################
    capFirst <- function(x, separate = " "){
      #  A function to format words to look nice.  The first letter of each word
      #   will be capitalized and the remaining letters will be lower case.  The 
      #   space between multi-word phrases can be customized.
      #  Takes a character vector and a collapse argument, this will be the 
      #   separator between multi-word phrases
      #  Returns a character vector

      #  Split the vector into a list to simplify computations
      tmp <- strsplit(x, " ")

      #  One at a time convert the first letter to upper case and the remaining
      #   letters to lower case and then paste them together
      lst <- lapply(tmp, function(x){
        paste(
          substr(toupper(x), 1, 1), 
          substr(tolower(x), 2, nchar(x)), 
          sep = "",
          collapse = separate
        )
      })

      #  We want a simple character vector output, so convert lst to a character
      #   vector
      out <- as.character(lst)

    return(out)
    }
################################################################################
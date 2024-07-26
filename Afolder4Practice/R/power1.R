
#' Power Function
#'
#' 
#' @details
#' It allowed you to raise a numerical value to twice of the other and if there is a non-numeric value it will tell you
#' 
#' @param x Base value
#' @param y The exponent 
#'
#' @author Hamid Semiyari
#' @return numerical value or a message
#'
#' @examples 
#' pwr1()
#' pwr1(x = 2, y =5)
#' pwr1(2, "a")
#' @export
pwr1 <- function(x=2, y=3){
  if (!is.numeric(x) | !is.numeric(y)){
    return(cat("x =", x, "and y=", y, ". Both must be numeric. Please enter numeric values for both"))
  }
  return((x^2)^y)
}


#' @title Create column Power of a data frame
#' @description
#' Two numeric vectors are creating a new vector and it will return a tibble 
#' 
#' @param x is a vector
#' @param y is a vector
#'
#' @return a datafram
#' @export
#'
#' @examples 
#' pwr2()
#' pwr2(x=c(-2,3, 10), y=c(3,5, -1))
#' 
 pwr2 <- function(x=c(2,2), y=c(3,5)){
  if (!is.numeric(x) | !is.numeric(y)){
    stop("Check the class of your vectors both must be numeric")
  }
  else if (sum(is.na(x) | is.na(y)) !=0){
    stop("There is at least one missing value in your vectors")
  }
  else if (length(x) %% length(y) !=0 | length(y) %% length(x) !=0 ) { warning(" The lengths are not equal")}

  else if (length(x) == length(y) & sum(is.na(x) | is.na(y)) ==0 ){
    df <- tibble::tibble(x, y)
    return(dplyr::mutate(df, Power = pwr1(x,y)))
  }  else { stop("Check your vectors!")
  }
   }







#DS 413/613    HOMEWORK  TEXT MINING  
# Instructions: Please submit on Canvas an Rmarkdown File and a Knitted Word
# File
#NAME:
install.packages("textdata")
install.packages("tidytext")
library(tidyverse)
library(dplyr)
library(textdata)
library(tidytext)


text1 <- c("The Gettysburg Address is a speech that US President Abraham", 
           "Lincoln delivered during the American Civil War at the dedication of the", 
           "Soldiers' National Cemetery in Gettysburg, Pennsylvania, on the afternoon of", 
           "November 19,1863, four and a half months after the Union armies defeated those", 
           "of the Confederacy at the Battle of Gettysburg. It is one of the best-known", 
           "speeches in American history. Lincoln's carefully crafted address, not", 
           "even that day's primary speech, came to be seen as one of the greatest and", 
           "most influential statements of American national purpose. In just 271 words,", 
           "beginning with the now famous phrase Four score and seven years ago",
           "referring to the signing of the Declaration of Independence 87 years earlier",
           " Lincoln described the US as a nation conceived in Liberty, and dedicated",
           "to the proposition that all men are created equal and represented the Civil",
           "War as a test that would determine whether such a nation, the Union sundered by",      
           "the secession crisis, could endure. He extolled the sacrifices of those who",
           "died at Gettysburg in defense of those principles.") 

text1

# 1  Use and show R code to convert text1 above to a tibble


# 2  Use and show R code to produce a table that shows the line location
#    for every word in the text.


# 3  Use and show R code to Find frequencies >= 3 for each word in 
#    text1.

# 4  Create a Data visual (Bar Graph) showing and comparing word
#    frequencies that are found in the table produced for # 3

  
# 5  Use and show R code to find the total number of words in the text1.
  
  
  
  
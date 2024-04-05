##_____________________________###
#                                #
#  Web Scrapping_Homework     #
#                                #
##_____________________________###

# Install and load the packages
# rvest for scraping and dplyr for piping

if (!require("pacman")) install.packages("pacman")

# Load contributed packages with pacman
pacman::p_load(rvest, dplyr, tidyverse)


# Problem:------------------------------
# Go to webpage https://www.american.edu/cas/mathstat/faculty/ 
# and scrape name-email-phone- of faculty/staff.
# Put all files in a csv file called "faculty.csv" and submit it to Canvas.


# Open Lu_Tianyi_Project2.Rproj in RStudio, then source this script.
# RStudio supplies Pandoc, which rmarkdown needs for Word output.
source("checks/check_cleaning.R")
rmarkdown::render("Project2.Rmd", output_format = "word_document")

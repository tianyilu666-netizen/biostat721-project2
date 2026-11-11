# Run from the project root with source("checks/check_cleaning.R").
source("R/clean_air.R")

# A small example checks that duplicates and negative values are handled
# before averaging. Distinct rows that become equal after clipping still count.
example <- read.csv("data/AQ_2018.csv", check.names = FALSE)[rep(1, 6), ]
example$Date <- c(rep("01/01/2018", 5), "01/02/2018")
example[[2]] <- c(1, 1, 1, 1, 1, NA)
example[[4]] <- c(-2, -2, 0, 6, 12, NA)
example[[6]] <- c(.01, .01, .01, .01, .01, NA)
file <- tempfile(fileext = ".csv")
write.csv(example, file, row.names = FALSE)
result <- clean_air(file)
stopifnot(nrow(result) == 2, result$pm25[1] == 4.5,
          is.na(result$co[2]), is.na(result$pm25[2]), is.na(result$o3[2]),
          inherits(result$date, "Date"))
stopifnot(inherits(try(clean_air(file, "mg"), silent = TRUE), "try-error"))
unlink(file)

for (year in 2018:2020) {
  path <- paste0("data/AQ_", year, ".csv")
  ppm <- clean_air(path)
  ppb <- clean_air(path, "ppb")
  raw <- read.csv(path, check.names = FALSE)
  stopifnot(nrow(ppm) == length(unique(raw$Date)),
            !anyDuplicated(ppm$date),
            all(as.matrix(ppm[c("co", "pm25", "o3")]) >= 0, na.rm = TRUE),
            isTRUE(all.equal(ppb$o3, 1000 * ppm$o3)),
            identical(ppb$co, ppm$co), identical(ppb$pm25, ppm$pm25))
}
cat("Cleaning checks passed.\n")

# Clean one year of RDU air pollution measurements.
# file_path: path to a supplied AQ CSV file (raw O3 units are ppm).
# o3_units: output ozone units, either "ppm" (default) or "ppb".
# Returns a tibble with one row per observed date, daily co, pm25, o3,
# and columns recording their units. Missing measurements stay missing.
clean_air <- function(file_path, o3_units = "ppm") {
  if (length(o3_units) != 1 || !o3_units %in% c("ppm", "ppb")) {
    stop('o3_units must be "ppm" or "ppb".')
  }
  air <- read.csv(file_path, check.names = FALSE, na.strings = c("", "NA"))
  names(air) <- trimws(names(air))
  air <- dplyr::rename(air,
    date = Date,
    co = `Daily Max 8-hour CO Concentration`,
    pm25 = `Daily Mean PM2.5 Concentration`,
    o3 = `Daily Max 8-hour Ozone Concentration`
  )
  air$date <- as.Date(air$date, format = "%m/%d/%Y")
  if (anyNA(air$date)) stop("The file contains a missing or invalid date.")
  if (any(air$units_O3 != "ppm", na.rm = TRUE)) {
    stop("The input ozone measurements must be in ppm.")
  }

  # Remove exact duplicates before changing values or averaging.
  air <- dplyr::distinct(air)
  pollutants <- c("co", "pm25", "o3")
  for (pollutant in pollutants) {
    negative <- !is.na(air[[pollutant]]) & air[[pollutant]] < 0
    air[[pollutant]][negative] <- 0
  }

  # Ignore missing measurements; keep NA if a whole day is missing.
  daily <- air |>
    dplyr::group_by(date) |>
    dplyr::summarise(
      dplyr::across(dplyr::all_of(pollutants),
        ~ if (all(is.na(.x))) NA_real_ else mean(.x, na.rm = TRUE)),
      .groups = "drop"
    ) |>
    dplyr::arrange(date)

  if (o3_units == "ppb") daily$o3 <- daily$o3 * 1000
  daily$units_co <- "ppm"
  daily$units_pm25 <- "ug/m3 LC"
  daily$units_o3 <- o3_units
  return(daily)
}

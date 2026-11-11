# RDU air pollution in 2018 to 2020

BIOSTAT 721 Project 2 by Tianyi Lu, November 11, 2026.

This project cleans daily CO, PM2.5, and ozone measurements from the EPA monitor at RDU airport and explores monthly patterns. It includes a reusable cleaning function, three tables of daily concentration ranges, and two plots. This is an exposure-data analysis; it does not test an association with sickle cell disease.

## Data source

The three original CSV files were supplied with the BIOSTAT 721 Project 2 assignment on Canvas. They contain EPA air pollution measurements from the RDU airport monitor for 2018, 2019, and January through April 2020. The raw files are kept unchanged in `data/`. Four dates are absent from the 2018 file. No missing dates or concentrations are imputed.

## File structure

- `Lu_Tianyi_Project2.Rproj`: open this file to start the RStudio project.
- `data/AQ_2018.csv`, `data/AQ_2019.csv`, `data/AQ_2020.csv`: original data.
- `R/clean_air.R`: `clean_air(file_path, o3_units = "ppm")`, which returns one row per observed date. Use `o3_units = "ppb"` to convert ozone to ppb.
- `Project2.Rmd`: report source, including tables, plots, interpretation, and AI use statement.
- `Project2.docx`: knitted Word report with code hidden.
- `report_style.docx`: Word reference document used for consistent formatting.
- `render_report.R`: checks the cleaning function and renders the report.
- `checks/check_cleaning.R`: checks duplicate removal, negative values, missing measurements, dates, and ozone conversion.
- `results/`: regenerated daily and monthly CSV files and the two plots.

## How to reproduce

1. Download or clone the repository and open `Lu_Tianyi_Project2.Rproj` in RStudio.
2. Install the required packages once:

   ```r
   install.packages(c("dplyr", "ggplot2", "knitr", "rmarkdown"))
   ```

3. From the project root, run:

   ```r
   source("render_report.R")
   ```

   Alternatively, open `Project2.Rmd` and select **Knit to Word**. Pandoc is included with RStudio; running outside RStudio requires a working Pandoc installation.

4. Open the regenerated `Project2.docx`. The cleaned data, monthly summaries, and plot images are written to `results/`.

The function removes exact duplicate rows before replacing negative concentrations with zero and calculating daily means. Daily means omit missing measurements and retain `NA` when all measurements for a pollutant on a date are missing. Monthly CO and ozone means pool individual daily values across available years, with intervals calculated as mean +/- 1.96 * SD / sqrt(n). January-April use three years; May-December use two. PM2.5 is summarized separately by month and year.

## Checks and environment

The report was rendered with R 4.6.0, dplyr 1.2.1, and ggplot2 4.0.3. The cleaning checks passed for all three files. An independent calculation also matched all 847 daily records, the 24 CO/ozone monthly confidence intervals, and the 28 PM2.5 monthly means. The Word report was checked visually after rendering.

## AI use

ChatGPT/Codex assisted with the code and report draft. The project includes executable cleaning checks, and the report describes how the generated output was checked.

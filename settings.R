
path <- "data/raw/Cereous.xlsx"

# Label used in the output -> name of the sheet in the Excel file
sheets_xl <- c("Vegetative cells" = "Forme vegetative", "Spores" = "Spore")
sheets <- names(sheets_xl)

# General setting
library(tidyverse)
library(readxl)

# Data manipulation and handling
library(data.table)
library(checkmate)
library(emmeans)
library(car)

# Data visualization
library(patchwork)

options(contrasts = c("contr.sum", "contr.poly"))

# Palettes and themes
COL <- c(FDA = "#2a78d6", WHO = "#eb6834")  # blue = FDA, orange = WHO
HOURS <- c(0, 6, 24, 30, 36, 48, 54, 72)

DEG <- "\u00b0C"                            # degree sign (encoding-independent)

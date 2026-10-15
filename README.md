<h1 align="center">R Spatial Data: Numerical, Tabular, Conditional, sf &amp; terra</h1>

<p align="center">
  <img src="https://img.shields.io/badge/R-4.6.1-276DC3?logo=r&logoColor=white" alt="R">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License">
  <img src="https://img.shields.io/badge/Data-Healthcare-green.svg" alt="Data Type">
  <img src="https://img.shields.io/github/repo-size/Attaftazayn/r-spatial-data-Numerical-Tabular-Conditional-sf-and-terra" alt="Repo Size">
</p>

## Overview

Week 5 exercises covering integrated R materials: numerical operations, matrix computation, conditional statements, tabular data manipulation with dplyr, vector-to-sf conversion, and raster processing with terra.

## Tools & Technologies

- **R** (>= 4.1.0)
- **RStudio**
- **Git & GitHub**

## R Packages

| Package | Purpose |
|---------|---------|
| `sf` | Simple Features — vector spatial data |
| `terra` | Raster spatial data |
| `tidyverse` | Data manipulation & visualization |

## Project Structure

```
├── data/
│   └── faskes_raw.csv             # Raw health facility data
├── output/
│   ├── faskes_bersih.csv          # Cleaned data
│   ├── ringkasan_risiko.csv       # Risk summary
│   ├── peta_faskes_risiko.png     # Risk map
│   └── elevasi_dummy.tif          # Cleaned elevation raster
├── Code_Week_5.R                  # Main analysis script
└── README.md
```

## Data

| Column | Type | Description |
|--------|------|-------------|
| `id_faskes` | integer | Health facility ID |
| `nama` | character | Facility name |
| `lon` | character | Longitude (before cleaning) |
| `lat` | character | Latitude (before cleaning) |
| `elevasi_meter` | numeric | Elevation in meters |
| `kapasitas_bed` | integer | Bed capacity |

## Output

| File | Format | Description |
|------|--------|-------------|
| `faskes_bersih.csv` | CSV | Cleaned facility data |
| `ringkasan_risiko.csv` | CSV | Risk class summary |
| `peta_faskes_risiko.png` | PNG | Risk classification map |
| `elevasi_dummy.tif` | GeoTIFF | Cleaned raster |

## Installation

```r
install.packages(c("sf", "terra", "tidyverse"))
```

## Usage

```r
source("Code_Week_5.R")
```

## Workflow

1. Create dummy health facility data with missing values
2. Clean data with `dplyr` pipeline (convert types, remove NAs)
3. Classify risk levels using conditional logic
4. Generate risk summary per class
5. Convert to sf object and visualize with `ggplot2`
6. Clean raster with `terra::classify()` and export GeoTIFF

## License

Data: dummy/synthetic. Code: MIT License.

## Contact

Maintained by [Attaftazayn](https://github.com/Attaftazayn)

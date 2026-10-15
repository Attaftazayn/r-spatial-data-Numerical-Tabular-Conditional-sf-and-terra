pkgs <- c("tidyverse", "sf", "terra")
baru <- pkgs[!pkgs %in% installed.packages()[, "Package"]]
if (length(baru) > 0) {
  install.packages(baru)
}
library(tidyverse)
if (!dir.exists("data")) dir.create("data")
if (!dir.exists("output")) dir.create("output")
elevasi <- c(2, 8, 12, NA, 4, 21, 3)
elevasi_baru <- elevasi + 1
status_rawan <- elevasi < 5
mean(elevasi, na.rm = TRUE)
median(elevasi, na.rm = TRUE)
sd(elevasi, na.rm = TRUE)
quantile(elevasi, probs = c(.25, .5, .75), na.rm = TRUE)
summary(elevasi)
M <- matrix(1:9, nrow = 3, ncol = 3)
M
t(M)        
M * 2       
M %*% t(M)  
nilai <- 85
if (nilai >= 60) {
  print("Lulus")
}
nilai <- 48
if (nilai >= 60) {
  status <- "Lulus"
} else {
  status <- "Remedial"
}
print(status)
lon <- 106.8
lat <- -6.2
elevasi_titik <- 3
if (!is.na(lon) & !is.na(lat)) {
  if (elevasi_titik < 5) {
    print("Koordinat valid; risiko tinggi")
  } else {
    print("Koordinat valid; risiko rendah")
  }
} else {
  print("Koordinat tidak lengkap")
}
elevasi_titik <- 12
if (elevasi_titik < 5) {
  kelas <- "tinggi"
} else if (elevasi_titik < 20) {
  kelas <- "sedang"
} else {
  kelas <- "rendah"
}
print(kelas)
faskes_raw <- tibble(
  id_faskes = 1:8,
  nama = c("RS A", "Puskesmas B", "Klinik C", "RS D", "Klinik E", "RS F", "Puskesmas G", "Klinik H"),
  lon = c("106.82", "106.84", "106.81", NA, "106.87", "106.83", "106.86", "106.80"),
  lat = c("-6.18", "-6.20", "-6.23", "-6.19", "-6.21", NA, "-6.24", "-6.22"),
  elevasi_meter = c(2, 8, 4, 25, NA, 3, 18, 1),
  kapasitas_bed = c(80, 30, 12, 120, 10, 60, 22, 8)
)
write_csv(faskes_raw, "data/faskes_raw.csv")
faskes_bersih <- read_csv("data/faskes_raw.csv", show_col_types = FALSE) %>%
  mutate(
    lon = as.numeric(lon),
    lat = as.numeric(lat)
  ) %>%
  drop_na(lon, lat, elevasi_meter) %>%
  mutate(
    kelas_risiko = case_when(
      elevasi_meter < 5  ~ "tinggi",
      elevasi_meter < 20 ~ "sedang",
      TRUE               ~ "rendah"
    ),
    bed_per_risiko = kapasitas_bed * ifelse(kelas_risiko == "tinggi", 1, 0)
  )
write_csv(faskes_bersih, "output/faskes_bersih.csv")
ringkasan <- faskes_bersih %>%
  group_by(kelas_risiko) %>%
  summarise(
    jumlah_faskes = n(),
    total_bed = sum(kapasitas_bed),
    elevasi_rata2 = mean(elevasi_meter),
    .groups = "drop"
  )
print(ringkasan)
write_csv(ringkasan, "output/ringkasan_risiko.csv")
if (requireNamespace("sf", quietly = TRUE) && requireNamespace("ggplot2", quietly = TRUE)) {
  library(sf)
  library(ggplot2)
  faskes_sf <- st_as_sf(
    faskes_bersih,
    coords = c("lon", "lat"),
    crs = 4326
  )
  print(faskes_sf)
  p <- ggplot(faskes_sf) +
    geom_sf(aes(color = kelas_risiko), size = 3) +
    theme_minimal() +
    labs(
      title = "Fasilitas Kesehatan Berdasarkan Kelas Risiko Elevasi",
      color = "Kelas Risiko"
    )
  print(p)
  ggsave("output/peta_faskes_risiko.png", p, width = 8, height = 5, dpi = 150)
} else {
  message("Paket sf/ggplot2 belum tersedia; bagian spasial dilewati.")
}
if (requireNamespace("terra", quietly = TRUE)) {
  library(terra)
  r <- rast(nrows = 10, ncols = 10, xmin = 106.7, xmax = 106.9, ymin = -6.3, ymax = -6.1)
  values(r) <- sample(c(-1, 1:100), ncell(r), replace = TRUE)
  r_clean <- classify(r, cbind(-Inf, 0, NA))
  plot(r_clean, main = "Raster Elevasi Dummy")
  writeRaster(r_clean, "output/elevasi_dummy.tif", overwrite = TRUE)
} else {
  message("Paket terra belum tersedia; bagian raster dilewati.")
}

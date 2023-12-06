library(readxl)
library(dplyr)
library(stringr)
# importar los datos

df <- read_xlsx("data/bombas.xlsx")[,-c(1,5)]
names(df) <- c("hora", "sitio", "bomba")

# recodificamos el tipo de ataque en 3 categorías
## EB = bombas explosivas
## IB = bombas incendiarias
## IB & EB = incendiarias y explosivas
## COB = crude oil
## O = otros

df$bomba <- ifelse(str_detect(df$bomba, "EB|eb|Eb|Explosive"), "EB",
                   ifelse(str_detect(df$bomba, "IB|Ib"), "IB",
                          ifelse(str_detect(df$bomba, "COB|Crude oil"), "COB",
                                 ifelse(str_detect(df$bomba, "&|and"), "IB & EB", "O")))) %>% 
  as.factor()

df$hora <- as.POSIXct(df$hora, format = "%Y-%m-%d %H:%M:%S")
df$tiempo <- ifelse(df$hora <= "1899-12-31 06:35:00 UTC", "antes", "después")

#df <- geocode(df, address = sitio, method = "arcgis")

df$greenwich <- ifelse(str_detect(df$sitio, "Greenwich"), "Greenwich", "otro")

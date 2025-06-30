# =========================================================
# 00_setup.R
# Proyecto: familia-sanchez
# Objetivo: configurar entorno, paquetes y carga inicial de datos
# =========================================================

rm(list = ls())

# ---------- Paquetes ----------

library(tidyverse)
library(haven)
library(here)
library(janitor)
library(labelled)
library(skimr)
library(glue)

# ---------- Verificar raíz del proyecto ----------
cat("Directorio raíz del proyecto:\n")
print(here())

# ---------- Definir rutas ----------
path_data_raw <- here("data", "merge_lapop.dta")
path_output   <- here("output")
path_scripts  <- here("scripts")

# ---------- Verificar que exista la base ----------
if (!file.exists(path_data_raw)) {
  stop(glue("No se encontró la base en: {path_data_raw}"))
}

cat("\nBase encontrada en:\n")
print(path_data_raw)

# ---------- Cargar base ----------
lapop <- read_dta(path_data_raw) %>%
  janitor::clean_names()

# ---------- Inspección inicial ----------
cat("\nDimensiones de la base:\n")
print(dim(lapop))

cat("\nPrimeros nombres de variables:\n")
print(names(lapop)[1:min(30, ncol(lapop))])

cat("\nVista general:\n")
glimpse(lapop)

# ---------- Guardar objeto opcional en entorno ----------
saveRDS(lapop, here("data", "merge_lapop.rds"))































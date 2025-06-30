# =========================================================
# 01_modelos.R
# Proyecto: familia-sanchez
# Objetivo: desarrollar modelos exploratorios
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
library(sjPlot)
library(ggplot2)
library(dplyr)
library(lme4)
library(performance)
library(interactionTest)
library(tidyr)
library(texreg)
library(margins)
library(stevemisc)
library(ggpubr)
library(effects)
library(broom.mixed)
library(lattice)
library(knitr)
library(MuMIn)
library(knitr)
library(ggeffects)
library(interplot)
library(kableExtra)
library(haven)
library(sjlabelled)
library(sjmisc)
library(parameters)
library(insight)
library(influence.ME)


# ----------- Base ------------

lapop <- read_rds("C:/Users/Dell/Desktop/familia-sanchez/data/merge_lapop.rds")


# ----------Vaariables---------

# Dummy hijos

lapop <- lapop %>%
  mutate(
    tiene_hijos = if_else(q12 > 0, 1, 0, missing = NA_real_)
  )

tabyl(lapop$tiene_hijos)

# Numero de hijos 

lapop <- lapop %>%
  mutate(
    num_hijos = q12
  )

tabyl(lapop$num_hijos)

# Religion 

tabyl(lapop$q3c)
val_labels(lapop$q3c)
tabyl(lapop$q3cn)
val_labels(lapop$q3cn)

lapop <- lapop %>%
  mutate(
    religion_rec = case_when(
      q3c == 1 ~ "catolica",
      q3c == 5 ~ "evangelica",
      q3c %in% c(4, 11) ~ "sin_religion",
      q3c %in% c(2,3,6,7,10,12,77,1501,2701,2702,4113,4114) ~ "otra",
      TRUE ~ NA_character_
    )
  )

lapop$religion_rec <- factor(
  lapop$religion_rec,
  levels = c("sin_religion", "catolica", "evangelica", "otra")
)

tabyl(lapop$religion_rec)


# Paises y años 

tabyl(lapop$pais)
val_labels(lapop$pais)
tabyl(lapop$year)

# Educacion y edad 

lapop <- lapop %>%
  filter(!is.na(religion_rec)) %>%
  mutate(
    edad_std = scale(q2),
    educ_std = scale(ed)
  )


#------- Modelos -------


m0 <- glmer(tiene_hijos ~ 1 +(1 | pais), data = lapop, family = binomial)

screenreg(m0)
icc_m0 <- performance::icc(m0)
print(icc_m0)


m1 <- glmer(tiene_hijos ~ religion_rec + (1 | pais), data = lapop, family = binomial)

screenreg(m1)

icc_m1 <- performance::icc(m1)
print(icc_m1)


m2 <- glmer(
  tiene_hijos ~ religion_rec + edad_std + sex + educ_std + (1 | pais),
  data = lapop,
  family = binomial
)

screenreg(m2)

















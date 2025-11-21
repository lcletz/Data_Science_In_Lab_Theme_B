# Importation de la base de données
library(readr)
df <- read_csv("../data/KIDNEY_FAILURE.csv")

#Inspection initiale (taux de NA)
names(df)                                    
colSums(is.na(df)) / nrow(df) * 100          

# Tableau des valeurs manquantes
na_table <- data.frame(
       variable = names(df),
       nb_NA = colSums(is.na(df)),                          # Nombre de NA
       taux_NA = round(colSums(is.na(df)) / nrow(df) * 100, 2)   # Taux de NA (%)
)
na_table

# Suppression des variables contenant "DATE"
df_no_date <- df[ , !grepl("DATE", names(df)) ]

# Vérification 
names(df_no_date)
colSums(is.na(df_no_date)) / nrow(df_no_date) * 100

# Création de la variable réponse RRT_ever
# 1 si le patient a eu au moins un RRT = 1
# 0 si tous les jours = 0
# NA si toutes les colonnes RRT_YN sont NA
df_no_date$RRT_ever <- apply(
  df_no_date[ , grepl("RRT_YN", names(df_no_date)) ],   
  1,                                                     
  function(x) {
    if (all(is.na(x))) {                                 
      NA                                                 
    } else if (any(x == 1, na.rm = TRUE)) {              
      1
    } else {                                             
      0
    }
  }
)

# Vérification de la distribution de Y
table(df_no_date$RRT_ever, useNA = "ifany")

# Création de la base contenant les identifiants et notre Y 
df_Y <- df_no_date[ , c("SUBJID", "SURNAME", "NAME", "RRT_ever") ]

# Enregistrer en local la nouvelle variable
write_delim(df_Y, "../data/RESPONSE_VAR.csv", delim = ';')

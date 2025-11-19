library(readr)
library(dplyr)

# Voir TO-DO_LIST.txt pour le choix des variables retenues ci-après.

baseline_clin <- read_delim("../data/BASELINE_CLIN.csv", col_names = T)
baseline_clin <- baseline_clin[,c("SUBJID", "ATCD_Smoking", "ATCD_Diabetes", "ATCD_Chronic_hypertension", 
                                 "ATCD_Cheart_failure", "ATCD_Ckidney_disease", "ATCD_Severe_liver_insufficiency", 
                                 "ATCD_Cirrhosis", "ATCD_Immunocompromised")]
baseline_clin <- baseline_clin %>% mutate_all(as.factor)
summary(baseline_clin)

biology <- read_delim("../data/BIOLOGY.csv", col_names = T)
biology <- biology[,c("SUBJID", "INCL_LAB_serum_creatinine", "INCL_LAB_blood_urea_nitrogen")]
biology <- biology %>% mutate_at("SUBJID", as.factor)
summary(biology)

# Remarque : si le `summary` de chaque tableau pour la "variable" SUBJID est bien le même résumé à chaque fois, 
# alors nous savons qu'il ne manque pas d'individus.

inclusion <- read_delim("../data/INCLUSION.csv", col_names = T)
inclusion <- inclusion[,c("SUBJID", "SEX")]
inclusion <- inclusion %>% mutate_all(as.factor)
summary(inclusion)

randomization <- read_delim("../data/RANDOMIZATION.csv", col_names = T)
randomization <- randomization[,c("SUBJID", "INCL_SEPSIS_YN", "AGE_CLASS", "INCL_AKIN", "ARM")]
randomization <-  randomization %>% mutate_all(as.factor)
summary(randomization)

sofa <- read_delim("../data/SOFA.csv", col_names = T)
sofa <- sofa[,c("SUBJID", "SOFA_renal_H0", "SOFA_renal_D7")]
sofa <- sofa %>% mutate_all(as.factor)
summary(sofa)

death28 <- read_delim("../data/DEATH28.csv", col_names = T)
death28 <- death28 %>% mutate_all(as.factor)
summary(death28)

response_var <- read_delim("../data/RESPONSE_VAR.csv", col_names = T)
response_var <- response_var[,c("SUBJID", "RRT_ever")]
response_var <- response_var %>% mutate_all(as.factor)
summary(response_var)

data <- baseline_clin %>% 
  full_join(biology, by="SUBJID") %>%
  full_join(inclusion, by="SUBJID") %>%
  full_join(randomization, by="SUBJID") %>%
  full_join(sofa, by="SUBJID") %>%
  full_join(death28, by="SUBJID") %>%
  full_join(response_var, by="SUBJID")
summary(data)

write_delim(data, "../data/TABLE_TO_IMPUTE.csv", delim = ';')


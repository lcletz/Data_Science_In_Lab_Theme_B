library(readr)
library(dplyr)

data <- read_delim("../data/VITAL_STATUS.csv", col_names = T)
data <- data[,-1]          # row number removed
name_to_remove <- c(grep("NAME", names(data)), grep("DATE", names(data)))
data <- data[, -name_to_remove]

n <- nrow(data)
DEATH28 <- rep(NA, n)
for(i in 1:n){
  DEATH28[i] <- ifelse(any(data[i,]==0), 0, 1)
}

data_to_save <- data.frame(SUBJID = data["SUBJID"], DEATH28 = DEATH28)
write_delim(data_to_save, "../data/DEATH28.csv", delim = ';')

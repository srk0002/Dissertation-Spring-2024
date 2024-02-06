```{r}
###improt data
setwd("C:/Users/srk0002/Documents/R/epidisplay")
sam <- read.csv("H:/Dissertation/Environmental Project Compiled Information.csv", stringsAsFactors = T)
View(sam)
```


library(epiR)
library(epiDisplay)
attach(sam)
frequency(Salmonella_Positive)
table(Salmonella_Positive, Species)
boxplot(Salmonella_Positive, Species)
summary(SAM)
frequency(Salmonella_Positive, Species)
barplot(table(Salmonella_Positive, Species))

tabpct(Species, Salmonella_Positive)
tabpct(Region, Salmonella_Positive)
tabpct(Sample_Method, Salmonella_Positive)

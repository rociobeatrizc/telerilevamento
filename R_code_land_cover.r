# Land Cover Maps: how land has been employed. 

# Patchwork allows you to arrange ggplot's graphics. 
 #https://patchwork.data-imaginist.com/
install.packages("patchwork")
install.packages("ggplot2")

library(raster)
library(RStoolbox) 
library(ggplot2)
library(patchwork)

# for grid.arrange plotting
# install.packages("gridExtra")
# library(gridExtra) 

# Setting WD
setwd("C:/lab") 

# First image: Rio Peixoto in 1992.
# More than one layer, brick function is needed. 
l92 <- brick("defor1_.jpg")

# NIR 1, RED 2, GREEN 3
plotRGB(l92, 1, 2, 3, stretch="lin")
dev.off()

# Second image: Rio Peixoto in 2006. 
l06 <- brick("defor2_.jpg")

# MultiFrame. 
par(mfrow= c(1,2))
plotRGB(l92, r=1, g=2, b=3, stretch="lin")
plotRGB(l06, r=1, g=2, b=3, stretch="lin")

# MF with ggplot2: ggRGB creates RGB image. 
# Allocation
p1 <- ggRGB(l92, r=1, g=2, b=3, stretch="lin")
p2 <- ggRGB(l06, r=1, g=2, b=3, stretch="lin")

# One beside the other by +
# One on top of the other by /
p1 + p1
p1/p2

# Land classification: how much land is meant to agriculture and how much is covered with forest?
# Unsupervised classification, 2 classes. 

# set.seed(1) would allow you to attain the same results
set.seed(1)

# First image
l92c <- unsuperClass(l92, nClasses = 2)
plot(l92c$map)

# Class 1: agriculture, water. 
# Classe 2: forest.

# Second image
l06c <- unsuperClass(l06, nClasses = 2)
plot(l06c$map)

# Frequencies. 
# Amount of pixels for each class (Agriculture, Forest)
# In 1992
freq(l92c$map)

#       value  count
# [1,]     1 306860
# [2,]     2  34432

# In 2006
freq(l06c$map)
#       value  count
# [1,]     1 163752
# [2,]     2 178974

# Proportion of forest and agriculture pixels with respect to the total. 
# 1992 
l92
# Total: 341292
tot92 <- 341292

# Percentage of first and second class. 
prop_92 <- freq(l92c$map) * 100 / tot92
prop_92
# 10% agriculture, 90% forest. 

# 2006
prop_06 <- freq(l06c$map) * 100 / tot06
prop_06 
# 47% agriculture, 52% forest. 

# By freq(l92$map) we get the number of pixels for each class.
# Allocation
prop_forest_92 <- 306023 * 100/ tot92
prop_agriculture_92 <- 35269 * 100/tot92
 
# 2006 
l06
tot06 <- 342726

# Allocation 
prop_forest_06 <-  178716 * 100/ tot06
prop_agriculture_06 <- 164719 * 100/ tot06

# Forest: 90% in 1992, 52% in 2006
prop_forest_92
prop_forest_06

# DataFrame made by three vectors. 
class <- c("Forest","Agriculture") 
percent_1992 <- c(89.83, 10.16)
percent_2006 <- c(52.06, 47.93)

percentages <- data.frame(class, percent_1992, percent_2006)
percentages

# Plot
plot92 <- ggplot(percentages, aes(x=class, y=percent_1992, color=class)) + 
  geom_bar(stat="identity", fill="white")

plot06 <- ggplot(percentages, aes(x=class, y=percent_2006, color=class)) + 
  geom_bar(stat="identity", fill="white")

# It can be written also like this:  
# ggplot(percentages) +    
#   geom_bar(aes(x=class, y=percent_2006, color=class), stat="identity", fill="white")

# Patchwork 
plot92 + plot06

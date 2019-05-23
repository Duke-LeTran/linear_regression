
#Initialize
w <- read.csv("/Users/dukeletran/Documents/Dropbox/Documents/108 - STA, linear regression/Projects/project1/WashArea.csv") #Macbook
w <- read.csv("C:/Users/dletran/Dropbox/Documents/108 - STA, linear regression/Projects/project1/WashArea.csv") #PC - Work
w <- read.csv("/Volumes/WD Red HDD/Duke/Dropbox/Documents/108 - STA, linear regression/Projects/project1/WashArea.csv") #Hackintosh
library(ggplot2)


#Notes
#### Wash Area (n = 99)
# Y = pop (col1)
# X = area (col2)
# Predict the population for a county that is 10 square miles.
# Predict the population for a county that is 100 square miles.
# Predict the average population of all counties that are 5 square miles.
n = 99



#Scatterplots
ggplot(w, aes(x = area, y = pop)) +
  geom_smooth(method='lm', se = FALSE, color = "purple", size = 0.4) +
  geom_point(size=1, shape=18) +
  ggtitle("Washington State:Population vs. County Area (sq mi)") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Population") +
  xlab("County Area (sq mi)")

#Boxplots
ggplot(w,
       aes(y = area, x = factor(""))) +
  geom_boxplot(fill = "white", colour = "#3366FF", outlier.color = "red", outlier.shape = 1) +
  ylab("area") +
  xlab(" ") +
  coord_flip() + #flips it from vertical to sideways plots
  ggtitle("Washington State") +
  theme(plot.title = element_text(hjust = 0.5)) +#centers the title
  stat_boxplot(geom ='errorbar')

ggplot(w,
       aes(y = pop, x = factor(""))) +
  geom_boxplot(fill = "white", colour = "#3366FF", outlier.color = "red", outlier.shape = 1) +
  ylab("pop") +
  xlab(" ") +
  coord_flip() + #flips it from vertical to sideways plots
  ggtitle("Washington State") +
  theme(plot.title = element_text(hjust = 0.5)) +#centers the title
  stat_boxplot(geom ='errorbar')

#Histograms - Washington State
ggplot(w,
       aes(x = pop)) + 
  geom_histogram(binwidth = 1000, color = "black",fill = "white") + 
  xlab("pop") + 
  ggtitle("Washington State") +
  theme(plot.title = element_text(hjust = 0.5))

ggplot(w,
       aes(x = area)) + 
  geom_histogram(binwidth = 0.5, color = "black",fill = "white") + 
  xlab("area (sq mi)") + 
  ggtitle("Washington State") +
  theme(plot.title = element_text(hjust = 0.5))

#historgram of fitted values
test = as.data.frame(w_model$fitted.values)
names(test)

ggplot(test,
       aes(x = w_model$fitted.values)) + 
  geom_histogram(binwidth = 40000, color = "black",fill = "white") + 
  xlab("fitted values") + 
  ggtitle("Washington State") +
  theme(plot.title = element_text(hjust = 0.5))

#simple linear models
w_model = lm(pop ~ area, data=w)
w$ei = w_model$residuals
w$yhat = w_model$fitted.values

#summaries - Washington State
w.sum = summary(w_model)
w.HT = w.sum$coefficients
w.b1 = w.HT[2,1]
w.b0 = w.HT[1,1]
w.sb1 = w.HT

#confidence intervals - 90%
w.CI = confint(w_model, level = 0.90)
w.CI.b1 = w.CI[2,]
w.CI.b1
w.b1

# > w.CI.b1
# 5 %     95 % 
# 302.3326 347.2191 
# > w.b1
# [1] 324.7759

##ASSESSING NORMALITY
# I. QQ Plot
qqnorm(w_model$residuals)
qqline(w_model$residuals)

# II. Shapiro-Wilks
#H0: The errors are normally distributed
#HA: The errors are NOT normally distributed
w.ei = w_model$residuals
w.SWtest = shapiro.test(w.ei)
w.SWtest

# III. Constant Variance (homoscedasticity)
#Fitted Values
ggplot(w, 
       aes(x = yhat, y = ei)) +
  geom_smooth(method='lm', se = FALSE, color = "green", size = 0.4) +
  geom_point(size=1, shape=18) +
  ggtitle("Errors vs. Fitted Values") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Errors") +
  xlab("Fitted Values")

# IV. Fligner Killeen (FK) test
Group = rep("Lower",nrow(w))
Group[w$pop > median(w$pop)] = "Upper"
Group = as.factor(Group)
w$Group = Group
w.FKtest = fligner.test(w$ei, w$Group)
w.FKtest

#SUMMARY 1st iteration
# I. QQPlot - PASS
# II. SW - FAIL (rejected H0)
# III. HS - FAIL (Cone shaped)
# IV. FK - FAIL (rejected H0)


## REMOVING Outliers
#These are the ones I want to remove
cutoff = 39000
w[which(w$ei > cutoff),]
w[which(w$ei < -cutoff),]
out_num = nrow(w[which(w$ei > cutoff),])
out_num = out_num + nrow(w[which(w$ei < -cutoff),])
out_num
# n = 500; potential oultliers = 8
out_per = out_num/n
out_per

#cutoff defined above
outliers1 = which(w$pop > cutoff | w$pop < -cutoff)
w2 = w[-outliers1,]


### SECOND ITERATION
w2_model = lm(pop ~ area, data = w2)

ggplot(w2, aes(x = area, y = pop)) +
  geom_smooth(method='lm', se = FALSE, color = "purple", size = 0.4) +
  geom_point(size=1, shape=18) +
  ggtitle("Washington State: Home Population vs. County Area (sq mi)") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("pop (US dollars)") +
  xlab("County Area (sq mi)")

##ASSESSING NORMALITY - w2
# I. QQ Plot
qqnorm(w2_model$residuals)
qqline(w2_model$residuals)

# II. Shapiro-Wilks
#H0: The errors are normally distributed
#HA: The errors are NOT normally distributed
w2.ei = w2_model$residuals
w2.SWtest = shapiro.test(w2.ei)
w2.SWtest

# III. Constant Variance (homoscedasticity)
#Fitted Values
ggplot(w2, 
       aes(x = yhat, y = ei)) +
  geom_smooth(method='lm', se = FALSE, color = "green", size = 0.4) +
  geom_point(size=1, shape=18) +
  ggtitle("w2: Errors vs. Fitted Values") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Errors") +
  xlab("Fitted Values")

# IV. Fligner Killeen (FK) test
Group = rep("Lower",nrow(w2))
Group[w2$pop > median(w2$pop)] = "Upper"
Group = as.factor(Group)
w2$Group = Group
w2.FKtest = fligner.test(w2$ei, w2$Group)
w2.FKtest

#SUMMARY 2nd iteration
# I. QQPlot - PASS
# II. SW - FAIL (rejected H0)
# III. HS - FAIL (not centered at 0)
# IV. FK - FAIL (rejected H0)
# Predict the population for a county that is 10 square miles.
# Predict the population for a county that is 100 square miles.
# Predict the average population of all counties that are 5 square miles.

##### Washington State - 1st iteration
# CI - Predict the average pop for county with living County Area (sq mi) 10.
w.x1 = 10
w.yhat1 = w.b0 + w.b1*w.x1
# PI - Predict the pop of a particular county with living County Area (sq mi) 100.
w.x2 = 100
w.yhat2 = w.b0 + w.b1*w.x2
# CI - Predict the average pop for county with living County Area (sq mi) 5.
w.x3 = 5
w.yhat3 = w.b0 + w.b1*w.x3


##### Washington State - 2nd iteration
# CI - Predict the average pop for county with living County Area (sq mi) 10. 
w2.x1 = 10
w2.yhat1 = w2.b0 + w2.b1*w2.x1
# PI - Predict the pop of a particular county with living County Area (sq mi) 100.
w2.x2 = 100
w2.yhat2 = w2.b0 + w2.b1*w2.x2
# CI - Predict the average pop for county with living County Area (sq mi) 5.
w2.x3 = 5
w2.yhat3 = w2.b0 + w2.b1*w2.x3



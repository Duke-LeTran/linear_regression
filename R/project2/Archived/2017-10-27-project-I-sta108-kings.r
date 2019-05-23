
#Initialize
k <- read.csv("/Users/dukeletran/Documents/Dropbox/Documents/108 - STA, linear regression/Projects/project1/KingCounty.csv") #Macbook
k <- read.csv("C:/Users/dletran/Dropbox/Documents/108 - STA, linear regression/Projects/project1/KingCounty.csv") #PC - Work
k <- read.csv("/Volumes/WD Red HDD/Duke/Dropbox/Documents/108 - STA, linear regression/Projects/project1/KingCounty.csv") #Hackintosh
library(ggplot2)

names(k)[1:2] = c("price","sqft_living")
names(k)
#Notes
##### King's County (n = 500)
# Y = price (col1)
# X = sqft_living (col2)
# Predict the average house price for houses with living square footage 2800. 
# Predict the price of a particular house with living square footage 3200.
# Predict the average house price for houses with living square footage 8000.
n = 500


#Scatterplots
ggplot(k, aes(x = sqft_living, y = price)) +
  geom_smooth(method='lm', se = FALSE, color = "purple", size = 0.4) +
  geom_point(size=1, shape=18) +
  ggtitle("King County: Home Prices vs. Square Footage") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Price (US dollars)") +
  xlab("Square Footage")

#Boxplots
ggplot(k,
       aes(y = sqft_living, x = factor(""))) +
  geom_boxplot(fill = "white", colour = "#3366FF", outlier.color = "red", outlier.shape = 1) +
  ylab("sqft_living") +
  xlab(" ") +
  coord_flip() + #flips it from vertical to sideways plots
  ggtitle("King's County") +
  theme(plot.title = element_text(hjust = 0.5)) +#centers the title
  stat_boxplot(geom ='errorbar')

ggplot(k,
       aes(y = price, x = factor(""))) +
  geom_boxplot(fill = "white", colour = "#3366FF", outlier.color = "red", outlier.shape = 1) +
  ylab("price") +
  xlab(" ") +
  coord_flip() + #flips it from vertical to sideways plots
  ggtitle("King's County") +
  theme(plot.title = element_text(hjust = 0.5)) +#centers the title
  stat_boxplot(geom ='errorbar')

#Histograms - King County
ggplot(k,
       aes(x = price)) + 
  geom_histogram(binwidth = 40000, color = "black",fill = "white") + 
  xlab("price") + 
  ggtitle("King County") +
  theme(plot.title = element_text(hjust = 0.5))

ggplot(k,
       aes(x = sqft_living)) + 
  geom_histogram(binwidth = 75, color = "black",fill = "white") + 
  xlab("sqft_living") + 
  ggtitle("King County") +
  theme(plot.title = element_text(hjust = 0.5))


#simple linear models
k_model = lm(price ~ sqft_living, data=k)
k$ei = k_model$residuals
k$yhat = k_model$fitted.values

#historgram of fitted values
test = as.data.frame(k_model$fitted.values)
names(test)

ggplot(test,
       aes(x = k_model$fitted.values)) + 
  geom_histogram(binwidth = 40000, color = "black",fill = "white") + 
  xlab("fitted values") + 
  ggtitle("King County") +
  theme(plot.title = element_text(hjust = 0.5))

#summaries - King's County
k.sum = summary(k_model)
k.HT = k.sum$coefficients
k.b1 = k.HT[2,1]
k.b0 = k.HT[1,1]
k.sb1 = k.HT



#confidence intervals - 90%
k.CI = confint(k_model, level = 0.90)
k.CI.b1 = k.CI[2,]
k.CI.b1

# > k.CI.b1
# 5 %     95 % 
# 302.3326 347.2191 
# > k.b1
# [1] 324.7759





##ASSESSING NORMALITY
# I. QQ Plot
x <- qqnorm(k_model$residuals)
x <- qqline(k_model$residuals)
x
# II. Shapiro-Wilks
#H0: The errors are normally distributed
#HA: The errors are NOT normally distributed
k.ei = k_model$residuals
k.SWtest = shapiro.test(k.ei)
k.SWtest

# III. Constant Variance (homoscedasticity)
#Fitted Values
ggplot(k, 
       aes(x = yhat, y = ei)) +
  geom_smooth(method='lm', se = FALSE, color = "green", size = 0.4) +
  geom_point(size=1, shape=18) +
  ggtitle("Errors vs. Fitted Values") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Errors") +
  xlab("Fitted Values")

ggplot(k,
       aes(x = ei)) + 
  geom_histogram(binwidth = 100000, color = "black",fill = "white") + 
  xlab("ei") + 
  ggtitle("Residuals") +
  theme(plot.title = element_text(hjust = 0.5))

# IV. Fligner Killeen (FK) test
Group = rep("Lower",nrow(k))
Group[k$price > median(k$price)] = "Upper"
Group = as.factor(Group)
k$Group = Group
k.FKtest = fligner.test(k$ei, k$Group)
k.FKtest

#SUMMARY 1st iteration
# I. QQPlot - PASS
# II. SW - FAIL (rejected H0)
# III. HS - FAIL (Cone shaped)
# IV. FK - FAIL (rejected H0)


## REMOVING Outliers
#These are the ones I want to remove
cutoff = 2.0 *10^6
k[which(k$ei > cutoff),]
k[which(k$ei < -cutoff),]
out_num = nrow(k[which(k$ei > cutoff),])
out_num = out_num + nrow(k[which(k$ei < -cutoff),])
out_num
# n = 500; potential oultliers = 8
out_per = out_num/n
out_per

#cutoff defined above
outliers1 = which(k$price > cutoff | k$price < -cutoff)
k2 = k[-outliers1,]


### SECOND ITERATION
k2_model = lm(price ~ sqft_living, data = k2)

ggplot(k2, aes(x = sqft_living, y = price)) +
  geom_smooth(method='lm', se = FALSE, color = "purple", size = 0.4) +
  geom_point(size=1, shape=18) +
  ggtitle("King County: Home Prices vs. Square Footage") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Price (US dollars)") +
  xlab("Square Footage")

##ASSESSING NORMALITY - k2
# I. QQ Plot
qqnorm(k2_model$residuals)
qqline(k2_model$residuals)

# II. Shapiro-Wilks
#H0: The errors are normally distributed
#HA: The errors are NOT normally distributed
k2.ei = k2_model$residuals
k2.SWtest = shapiro.test(k2.ei)
k2.SWtest

# III. Constant Variance (homoscedasticity)
#Fitted Values
ggplot(k2, 
       aes(x = yhat, y = ei)) +
  geom_smooth(method='lm', se = FALSE, color = "green", size = 0.4) +
  geom_point(size=1, shape=18) +
  ggtitle("k2: Errors vs. Fitted Values") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Errors") +
  xlab("Fitted Values")

# IV. Fligner Killeen (FK) test

Group = rep("Lower",nrow(k2))
Group[k2$price > median(k2$price)] = "Upper"
Group = as.factor(Group)
k2$Group = Group
k2.FKtest = fligner.test(k2$ei, k2$Group)
k2.FKtest

#SUMMARY 1st iteration
# I. QQPlot - PASS
# II. SW - FAIL (rejected H0)
# III. HS - FAIL (not centered at 0, cone shaped)
# IV. FK - FAIL (rejected H0)

#Prediction
#For the following predictions, we will be using the following estimated regression line:

Y = b0 + b1X

#confidence intervals - 90%
k.CI = confint(k_model, level = 0.90)
k.CI.b1 = k.CI[2,]
k.CI.b1



s{b1} =
  
  
  # Predict the average house price for houses with living square footage 2800. 
  # Predict the price of a particular house with living square footage 3200.
  # Predict the average house price for houses with living square footage 8000.


##### PROBLEM V. ####
# (a) Find a 95% confidence interval for the average salary for a subject with 5 years of experience.
xs.fiveYr = data.frame(yd = 5)
ys.fiveYr.CI = predict(the.model.sal, xs.fiveYr, interval = "confidence", level = 0.95)
ys.fiveYr.CI

##### King's County - 1st iteration
# CI - Predict the average house price for houses with living square footage 2800. 
k.x1 = 2800
k.yhat1 = k.b0 + k.b1*k.x1
# PI - Predict the price of a particular house with living square footage 3200.
k.x2 = 3200
k.yhat2 = k.b0 + k.b1*k.x2
# CI - Predict the average house price for houses with living square footage 8000.
k.x3 = 8000
k.yhat3 = k.b0 + k.b1*k.x3

##### King's County - 2nd iteration
# CI - Predict the average house price for houses with living square footage 2800. 
k2.x1 = 2800
k2.yhat1 = k2.b0 + k2.b1*k2.x1
# PI - Predict the price of a particular house with living square footage 3200.
k2.x2 = 3200
k2.yhat2 = k2.b0 + k2.b1*k2.x2
# CI - Predict the average house price for houses with living square footage 8000.
k2.x3 = 8000
k2.yhat3 = k2.b0 + k2.b1*k2.x3




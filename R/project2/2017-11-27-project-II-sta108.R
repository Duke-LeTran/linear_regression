#Intialize - Read
t1 <- read.csv("/Volumes/WD Red HDD/Duke/Dropbox/Documents/108 - STA, linear regression/Homework/project2/Transform1.csv")
a <- read.csv("/Volumes/WD Red HDD/Duke/Dropbox/Documents/108 - STA, linear regression/Homework/project2/athlete.csv")
h <- read.csv("/Volumes/WD Red HDD/Duke/Dropbox/Documents/108 - STA, linear regression/Homework/project2/housing.csv")

plot(a)


#Initalize - Library
library(ggplot2)


#simple linear models
t1_model = lm(Y ~ X, data=t1)
t1$ei = t1_model$residuals
t1$yhat = t1_model$fitted.values

##ASSESSING NORMALITY
# I. QQ Plot
x <- qqnorm(t1_model$residuals)
x <- qqline(t1_model$residuals)
x
# II. Shapiro-Wilks
#H0: The errors are normally distributed
#HA: The errors are NOT normally distributed
t1.ei = t1_model$residuals
t1.SWtest = shapiro.test(t1.ei)
t1.SWtest

# III. Constant Variance (homoscedasticity)
#Fitted Values
ggplot(t1, 
       aes(x = yhat, y = ei)) +
  geom_smooth(method='lm', se = FALSE, color = "green", size = 0.4) +
  geom_point(size=1, shape=18) +
  ggtitle("Errors vs. Fitted Values") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Errors") +
  xlab("Fitted Values")

ggplot(t1,
       aes(x = ei)) + 
  geom_histogram(binwidth = 100000, color = "black",fill = "white") + 
  xlab("ei") + 
  ggtitle("Residuals") +
  theme(plot.title = element_text(hjust = 0.5))

# IV. Fligner Killeen (FK) test
Group = rep("Lower",nrow(t1))
Group[t1$price > median(t1$price)] = "Upper"
Group = as.factor(Group)
t1$Group = Group
t1.FKtest = fligner.test(t1$ei, t1$Group)
t1.FKtest

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

#multiplot



plot(a)

##### I. Introduction
##### II. Summary of Data

nrow(a) #202
summary(a)

#rcc
ggplot(a,
       aes(x = rcc)) + 
  geom_histogram(binwidth = 0.3, color = "black",fill = "white") + 
  xlab("rcc") + 
  ggtitle("Athlete") +
  theme(plot.title = element_text(hjust = 0.5))







##### III. Model Selection
a2 <- a
names(a2) <- c("Y", "X1", "X2", "X3", "X4", "X5", "X6") #use a2 for non-descriptive X names
full.model = lm(Y~ X1 + X2 + X3 + X4 + X5 + X6, data = a2)
all.models = regsubsets(Y ~., data = a2)


some.stuff = summary(all.models)
names.of.data = c("Y",colnames(some.stuff$which)[-1])
n= nrow(a2) #Will have to change the name
K = nrow(some.stuff$which)
nicer = lapply(1:K,function(i){
  model = paste(names.of.data[some.stuff$which[i,]],collapse = ",")
  p = sum(some.stuff$which[i,])
  BIC = some.stuff$bic[i]
  CP = some.stuff$cp[i]
  results = data.frame(model,p,CP,BIC)
  return(results)
})
nicer = Reduce(rbind,nicer)
nicer


# A. All subsets regression
#```{r, echo=FALSE}
#top two models of each size (two models that have just 1 X, two models that have 2 X’s, etc.)
full.model = lm(Y~ X1 + X2 + X3 + X4 + X5 + X6, data = a2)
all.models = regsubsets(Y ~., data = a2)
some.stuff = summary(all.models)
names.of.data = c("Y",colnames(some.stuff$which)[-1])
n= nrow(a2) #Will have to change the name
K = nrow(some.stuff$which)
nicer = lapply(1:K,function(i){
  model = paste(names.of.data[some.stuff$which[i,]],collapse = ",")
  p = sum(some.stuff$which[i,])
  BIC = some.stuff$bic[i]
  CP = some.stuff$cp[i]
  results = data.frame(model,p,CP,BIC)
  return(results)
})
nicer = Reduce(rbind,nicer)
nicer[which.min(nicer$BIC),]
#```
#Utilzing a function from the R library "leaps" called "regsubsets", short for regresssion subset selection, we are able to generate 




#B. Stepwise regression
full.model = lm(Y~ X1 + X2 + X3 + X4 + X5 + X6, data = a2)
empty.model = lm(Y ~ 1,data = a2)

#Forward step-wise selection
n = nrow(a2)
#AIC - note the k=2
forward.model.AIC = stepAIC(empty.model, scope = list(lower=empty.model, upper=full.model), k=2, direction="forward", trace=FALSE)
#BIC - note the k=log(n)
forward.model.BIC = stepAIC(empty.model,  scope = list(lower=empty.model, upper=full.model), k=log(n), direction="forward", trace=FALSE)

#Backward step-wise selection
backward.model.AIC = stepAIC(full.model, scope = list(lower=empty.model, upper= full.model), k=2, direction="backward", trace=FALSE)
backward.model.BIC = stepAIC(full.model, scope = list(lower=empty.model, upper= full.model), k=log(n), direction="backward", trace=FALSE)

#Forwards-Backwards selection
FB.model.AIC = stepAIC(empty.model, scope = list(lower=empty.model, upper= full.model), k=2, direction="both", trace=FALSE)
FB.model.BIC = stepAIC(empty.model, scope = list(lower=empty.model, upper= full.model), k=log(n), direction="both", trace=FALSE)

#Backwards-Forwards selection
BF.model.AIC = stepAIC(full.model, scope = list(lower=empty.model, upper= full.model), k=2, direction="both", trace=FALSE)
BF.model.BIC = stepAIC(full.model, scope = list(lower=empty.model, upper= full.model), k=log(n), direction="both", trace=FALSE)





a3_X6c_F
a3_X6c_Fs = round(a3_X6c_F[2,5], 4)
a3_X6c_p = a3_X6c_F[2,6]

a3_X6c_Fs
a3_X6c_p


#### IV. Diagnostics

### Diagnostics

#### Assessing Linearity between Xs and Y

#linear model
best_model_large
a3$ei = best_model_large$residuals
a3$yhat = best_model_large$fitted.values
#beta confidence interval
g = 4 #b0, b5, b{6, run}, b{6, swim}
confint(best_model_large, level = 0.99/g) #This uses the Bonferroni
a3.CI.sim = confint(best_model_large, level=0.99)
a3.CI.sim[-1,]
a3.CI.b5 = a3.CI.sim[2,]
a3.CI.b6r = a3.CI[3,]
a3.CI.b6s = a3.CI[4,]
#summary/hypothesis testing
a3.sum = summary(best_model_large)
a3.HT = a3.sum$coefficients
#estimated regression line
a3.b0 = a3.HT[1]
a3.b5 = a3.HT[2]
a3.b6r = a3.HT[3]
a3.b6s = a3.HT[4]
#divide by 2 for one-tailed test
#t-statistic
a3.b0.t = a3.HT[1, 3]/2
a3.b5.t = a3.HT[2, 3]/2
a3.b6r.t = a3.HT[3, 3]/2
a3.b6s.t = a3.HT[4, 3]/2
#p-value
a3.b0.p = a3.HT[1, 4]/2
a3.b5.p = a3.HT[2, 4]/2
a3.b6r.p = a3.HT[3, 4]/2
a3.b6s.p = a3.HT[4, 4]/2



####### INSERT TEXT ANALYSIS

#### Assessing Assumption 1: Normality
##ASSESSING NORMALITY
# I. QQ Plot
x <- qqnorm(best_model$residuals)
x <- qqline(best_model$residuals)
# II. Shapiro-Wilks
#H0: The errors are normally distributed
#HA: The errors are NOT normally distributed
a2.ei = best_model$residuals
a2.SWtest = shapiro.test(a2.ei)
sw_p = a2.SWtest[2]


##### Shaprio-Wilks










### Summary: Outliers Removed

##### Assessing Normality

#I. QQPlot - PASS (improved)

#II. SW - PASS (improved)

##### Assessing Constant Variance

#III. Scatterplot: ei vs Fitted Values - FAILED (improved)

#IV. Histogram of ei - PASS (improved)

#V. FK - PASS (improved, barely pass)













































##### V. Analysis
##### VI. Interpretations
##### VII. Conclusions














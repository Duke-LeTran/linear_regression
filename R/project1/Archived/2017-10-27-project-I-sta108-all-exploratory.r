
#Initialize - Macbook
h <- read.csv("/Users/dukeletran/Documents/Dropbox/Documents/108 - STA, linear regression/Projects/hospital.csv")
k <- read.csv("/Users/dukeletran/Documents/Dropbox/Documents/108 - STA, linear regression/Projects/KingCounty.csv")
w <- read.csv("/Users/dukeletran/Documents/Dropbox/Documents/108 - STA, linear regression/Projects/WashArea.csv")
library(ggplot2)

#Initialize - Work
h <- read.csv("C:/Users/dletran/Dropbox/Documents/108 - STA, linear regression/Projects/hospital.csv")
k <- read.csv("C:/Users/dletran/Dropbox/Documents/108 - STA, linear regression/Projects/KingCounty.csv")
w <- read.csv("C:/Users/dletran/Dropbox/Documents/108 - STA, linear regression/Projects/WashArea.csv")
library(ggplot2)

#Notes
##### King's County (n = 500)
# Y = price (col1)
# X = sqft_living (col2)
# Predict the average house price for houses with living square footage 2800. 
# Predict the price of a particular house with living square footage 3200.
# Predict the average house price for houses with living square footage 8000.

#### Wash Area (n = 99)
# Y = pop (col1)
# X = area (col2)
# Predict the population for a county that is 10 square miles.
# Predict the population for a county that is 100 square miles.
# Predict the average population of all counties that are 5 square miles.

#### Hospital (n = 280)
# Y = Infect (col2)
# X = Days (col1)
# Predict the infection risk for a patient who stayed 10 days.
# Predict the average infection risk for a patients who stay 20 days. 
# Predict the infection risk for a patient who stayed 40 days.

#Scatterplots
ggplot(k, aes(x = sqft_living, y = price)) +
  geom_smooth(method='lm', se = FALSE, color = "purple", size = 0.4) +
  geom_point(size=1, shape=18) +
  ggtitle("King County: Home Prices vs. Square Footage") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Price (US dollars)") +
  xlab("Square Footage")

ggplot(w, aes(x = pop, y = area)) +
  geom_smooth(method='lm', se = FALSE, color = "blue", size = 0.4) +
  geom_point(size=1, shape=18) +
  ggtitle("Washington State: County Population vs. County Area (sq mi)") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("County Population") +
  xlab("County Area (sq mi)")

ggplot(h, aes(x = Days, y = Infect)) +
  geom_smooth(method='lm', se = FALSE, color = "green", size = 0.4) +
  geom_point(size=1, shape=18) +
  ggtitle("Hospital: Estimated Probability of Infection vs. Days in Hospital") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Estimated probability of Infection") +
  xlab("Days pt spent in hospital (days)")

#Boxplots
ggplot(k,
       aes(y = sqft_living, x = factor(""))) +
  geom_boxplot(fill = "white", colour = "#3366FF", outlier.color = "red", outlier.shape = 1) +
  ylab("price") +
  xlab(" ") +
  coord_flip() + #flips it from vertical to sideways plots
  ggtitle("King's County") +
  theme(plot.title = element_text(hjust = 0.5)) +#centers the title
  stat_boxplot(geom ='errorbar')

ggplot(h,
       aes(y = Infect, x = factor(""))) +
  geom_boxplot(fill = "white", colour = "#3366FF", outlier.color = "red", outlier.shape = 1) +
  ylab("Infect") +
  xlab(" ") +
  coord_flip() + #flips it from vertical to sideways plots
  ggtitle("Hospital") +
  theme(plot.title = element_text(hjust = 0.5)) +#centers the title
  stat_boxplot(geom ='errorbar')

ggplot(w,
       aes(y = pop, x = factor(""))) +
  geom_boxplot(fill = "white", colour = "#3366FF", outlier.color = "red", outlier.shape = 1) +
  ylab("County Population") +
  xlab(" ") +
  coord_flip() + #flips it from vertical to sideways plots
  ggtitle("Washington") +
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

#Histogram - Wash Area
ggplot(w,
       aes(x = price)) + 
  geom_histogram(binwidth = 40000, color = "black",fill = "white") + 
  xlab("price") + 
  ggtitle("King County") +
  theme(plot.title = element_text(hjust = 0.5))

#Histogram - Hospital
ggplot(h,
       aes(x = Infect)) + 
  geom_histogram(binwidth = 0.1, color = "black",fill = "white") + 
  xlab("Infect Probability") + 
  ggtitle("Hospital") +
  theme(plot.title = element_text(hjust = 0.5))

ggplot(h,
       aes(x = Infect)) + 
  geom_histogram(binwidth = .2, color = "black",fill = "white") + 
  xlab("Days") + 
  ggtitle("Hospital") +
  theme(plot.title = element_text(hjust = 0.5))

#simple linear models
k_model = lm(sqft_living ~ price, data=k)
k_model
w_model = lm(area ~ pop, data=w)
h_model = lm(Infect ~ Days, data=h)

#summaries - King's County
k.sum = summary(k_model)
k.HT = k.sum$coefficients
k.b1 = k.HT[2,1]
k.b0 = k.HT[1,1]
k.sb1 = k.HT

#summaries - Washington State
w.sum = summary(w_model)
w.HT = w.sum$coefficients
w.b1 = w.HT[2,1]
w.b0 = w.HT[1,1]
w.sb1 = w.HT

#summaries - Hospital
h.sum = summary(h_model)
h.HT = h.sum$coefficients
h.b1 = h.HT[2,1]
h.b0 = w.HT[1,1]
h.sb1 = h.HT

#confidence intervals - 90%
k.CI = confint(k_model, level = 0.90)
k.CI.b1 = k.CI[2,]

w.CI = confint(w_model, level = 0.90)
w.CI.b1 = w.CI[2,]

h.CI = confint(h_model, level = 0.90)
h.CI.b1 = h.CI[2,]

# > w.CI.b1
#          5 %         95 % 
# 0.0002867725 0.0003128022 
# > w.b1
# [1] 0.0002997874
# 
#
# > h.CI.b1
#       5 %      95 % 
# 0.2771738 0.4914787 
# > h.b1
# [1] 0.3843263
# 
# 
# > k.CI.b1
#         5 %        95 % 
# 0.001528100 0.001754973 
# > k.b1
# [1] 0.001641536

##### King's County
# CI - Predict the average house price for houses with living square footage 2800. 
k.x1 = 2800
k.yhat1 = k.b0 + k.b1*k.x1
# PI - Predict the price of a particular house with living square footage 3200.
k.x2 = 3200
k.yhat2 = k.b0 + k.b1*k.x2
# CI - Predict the average house price for houses with living square footage 8000.
k.x3 = 8000
k.yhat3 = k.b0 + k.b1*k.x3

#### Wash Area
# Y = pop (col1)
# X = area (col2)
# PI - Predict the population for a county that is 10 square miles.
w.x1 = 10
w.yhat1 = w.b0 + w.b1*w.x1
# PI - Predict the population for a county that is 100 square miles.
w.x2 = 100
w.yhat2 = w.b0 + w.b1*w.x2
# PI - Predict the average population of all counties that are 5 square miles.
w.x3 = 5
w.yhat3 = w.b0 + w.b1*w.x3

#### Hospital
# Y = Infect (col2)
# X = Days (col1)
# PI - Predict the infection risk for a patient who stayed 10 days.
h.x1 = 10
h.yhat1 = h.b0 + h.b1*h.x1
# CI - Predict the average infection risk for a patients who stay 20 days. 
h.x2 = 20
h.yhat2 = h.b0 + h.b1*h.x2
# PI - Predict the infection risk for a patient who stayed 40 days.
h.x3 = 40
h.yhat3 = h.b0 + h.b1*h.x3

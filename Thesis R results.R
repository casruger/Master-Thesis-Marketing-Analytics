library(readxl)
library(ppcor)
library(car)
library(pkgs)
library(corrplot)
library(lmtest)
set.seed(1234)

Data <- read_excel("Data-thesis-Cas.xlsx")
summary(Data)
dataset <- Data[,c(1,3,4,5,6,7,8,9,10,11,12,18,20,22,23,26,30,31,34,39,41,44,101,102,104)]
dataset_numeric <- dataset[,c(1,12,13,14,15,16,18,19,20,21,22,23,24,25)]

#--------------------Correlation matrix------------------
res <- cor(dataset_numeric)
round(res, 2)


#-------------------Mean maken van moderated variables-------------
CapTenMean<-mean(dataset$CapTen)
TTenMean<-mean(dataset$TTen)
TopTenMean<-mean(dataset$TopTen)
CoaTenMean<-mean(dataset$CoaTen)
AsCoTenMean<-mean(dataset$AsCoTen)
SizeSMean<-mean(dataset$SizeS)
SizeLMean<-mean(dataset$SizeL)


dataset$MCapTen<-(dataset$CapTen-CapTenMean)
dataset$MTTen<-(dataset$TTen-TTenMean)
dataset$MTopTen<-(dataset$TopTen-TopTenMean)
dataset$MCoaTen<-(dataset$CoaTen-CoaTenMean)
dataset$MAsCoTen<-(dataset$AsCoTen-AsCoTenMean)
dataset$MSizeS<-(dataset$SizeS-SizeSMean)
dataset$MSizeL<-(dataset$SizeL-SizeLMean)

#ln
dataset$lnTeamVal<-(log(dataset$TeamVal))
dataset$lnTraTime<-(log(dataset$TraTime))

#ln for validations
dataset$lnAlti<-(log(dataset$Alti))
dataset$lnCapTen<-(log(dataset$CapTen))
dataset$lnCoaTen<-(log(dataset$CoaTen))
dataset$lnAsCoTen<-(log(dataset$AsCoTen))
dataset$lnSizeS<-(log(dataset$SizeS))
dataset$lnSizeL<-(log(dataset$SizeL))
dataset$lnTraDis<-(log(dataset$TraDis))
dataset$lnTopTen<-(log(dataset$TopTen))

#----------------------Models----------------

#TTen
Mod5a1<- glm(Win1 ~ home_away +lnTeamVal +Alti +lnTraTime  +Bundes +Erediv +LaLiga+Premier +Scotisch  +s1920  +Turf +home_away*MTTen  +home_away*MCoaTen +home_away*MAsCoTen +home_away*Turf +home_away*MSizeS +home_away*MSizeL +home_away*lnTraTime  +home_away*Alti, data=dataset, family = "binomial")
summary(Mod5a1)


Mod5b1<- lm(Win2 ~ home_away +lnTeamVal +Alti +lnTraTime  +Bundes +Erediv +LaLiga+Premier +Scotisch  +s1920 +Turf +home_away*MTTen +home_away*MCoaTen +home_away*MAsCoTen +home_away*Turf +home_away*MSizeS +home_away*MSizeL +home_away*lnTraTime  +home_away*Alti, data=dataset)
summary(Mod5b1)


#CapTen
Mod5a2<- glm(Win1 ~ home_away +lnTeamVal +Alti +lnTraTime  +Bundes +Erediv +LaLiga+Premier +Scotisch  +s1920  +Turf +home_away*MCapTen  +home_away*MCoaTen +home_away*MAsCoTen +home_away*Turf +home_away*MSizeS +home_away*MSizeL +home_away*lnTraTime  +home_away*Alti, data=dataset, family = "binomial")
summary(Mod5a2)


Mod5b2<- lm(Win2 ~ home_away +lnTeamVal +Alti +lnTraTime  +Bundes +Erediv +LaLiga+Premier +Scotisch  +s1920 +Turf +home_away*MCapTen +home_away*MCoaTen +home_away*MAsCoTen +home_away*Turf +home_away*MSizeS +home_away*MSizeL +home_away*lnTraTime  +home_away*Alti, data=dataset)
summary(Mod5b2)


#TopTen
Mod5a3<- glm(Win1 ~ home_away +lnTeamVal +Alti +lnTraTime  +Bundes +Erediv +LaLiga+Premier +Scotisch  +s1920  +Turf +home_away*MTopTen  +home_away*MCoaTen +home_away*MAsCoTen +home_away*Turf +home_away*MSizeS +home_away*MSizeL +home_away*lnTraTime  +home_away*Alti, data=dataset, family = "binomial")
summary(Mod5a3)


Mod5b3<- lm(Win2 ~ home_away +lnTeamVal +Alti +lnTraTime  +Bundes +Erediv +LaLiga+Premier +Scotisch  +s1920 +Turf +home_away*MTopTen +home_away*MCoaTen +home_away*MAsCoTen +home_away*Turf +home_away*MSizeS +home_away*MSizeL +home_away*lnTraTime  +home_away*Alti, data=dataset)
summary(Mod5b3)


#All Three
Mod5a4<- glm(Win1 ~ home_away +lnTeamVal +Alti +lnTraTime  +Bundes +Erediv +LaLiga+Premier +Scotisch  +s1920  +Turf +home_away*MTTen +home_away*MCapTen +home_away*MTopTen  +home_away*MCoaTen +home_away*MAsCoTen +home_away*Turf +home_away*MSizeS +home_away*MSizeL +home_away*lnTraTime  +home_away*Alti, data=dataset, family = "binomial")
summary(Mod5a4)


Mod5b4<- lm(Win2 ~ home_away +lnTeamVal +Alti +lnTraTime  +Bundes +Erediv +LaLiga+Premier +Scotisch  +s1920 +Turf +home_away*MTTen +home_away*MCapTen +home_away*MTopTen +home_away*MCoaTen +home_away*MAsCoTen +home_away*Turf +home_away*MSizeS +home_away*MSizeL +home_away*lnTraTime  +home_away*Alti, data=dataset)
summary(Mod5b4)


#--------- VIF values-----------------
car::vif(Mod5a1)
car::vif(Mod5b1)
car::vif(Mod5a2)
car::vif(Mod5b2)
car::vif(Mod5a3)
car::vif(Mod5b3)

car::vif(Mod5a4)
car::vif(Mod5b4)

#--------Loglikelihood tests------------------
Mod5con <- glm(Win1 ~ lnTeamVal +Alti +lnTraTime +Bundes +Erediv +LaLiga+Premier +Scotisch  +s1920, data=dataset, family = "binomial")
summary(Mod5con)


logLik(Mod5a1)
lrtest(Mod5a1, Mod5con)
lrtest(Mod5a2, Mod5con)
lrtest(Mod5a3, Mod5con)
lrtest(Mod5a4, Mod5con)

#validations-----------------------------------------------------------------------------------------

#model alleen maar ln
Mod6a2<- glm(Win1 ~ home_away +lnTeamVal +Alti +lnTraTime  +Bundes +Erediv +LaLiga+Premier +Scotisch  +s1920  +Turf +home_away*lnCapTen  +home_away*lnCoaTen +home_away*lnAsCoTen +home_away*Turf +home_away*SizeS +home_away*SizeL +home_away*lnTraTime  +home_away*Alti, data=dataset, family = "binomial")
summary(Mod6a2)
lrtest(Mod6a2, Mod5con)

Mod6b3<- lm(Win2 ~ home_away +lnTeamVal +Alti +lnTraTime  +Bundes +Erediv +LaLiga+Premier +Scotisch  +s1920  +Turf +home_away*lnTopTen  +home_away*lnCoaTen +home_away*lnAsCoTen +home_away*Turf +home_away*SizeS +home_away*SizeL +home_away*lnTraTime  +home_away*Alti, data=dataset)
summary(Mod6b3)


#travel distance
Mod7a2<- glm(Win1 ~ home_away +lnTeamVal +Alti +lnTraDis  +Bundes +Erediv +LaLiga+Premier +Scotisch  +s1920  +Turf +home_away*lnCapTen  +home_away*CoaTen +home_away*lnAsCoTen +home_away*Turf +home_away*SizeS +home_away*SizeL +home_away*lnTraDis  +home_away*Alti, data=dataset, family = "binomial")
summary(Mod7a2)
lrtest(Mod7a2, Mod5con)

Mod7b3<- lm(Win2 ~ home_away +lnTeamVal +Alti +lnTraDis  +Bundes +Erediv +LaLiga+Premier +Scotisch  +s1920  +Turf +home_away*lnTopTen  +home_away*CoaTen +home_away*lnAsCoTen +home_away*Turf +home_away*SizeS +home_away*SizeL +home_away*lnTraDis  +home_away*Alti, data=dataset)
summary(Mod7b3)


#no winners,lossers
Data_mod <- read_excel("Mod4.xlsx")
dataset_mod <- Data_mod[,c(1,3,4,5,6,7,8,9,10,11,12,18,20,22,23,26,30,31,34,39,41,44,101,102,104)]

CapTenMean<-mean(dataset_mod$CapTen)
TTenMean<-mean(dataset_mod$TTen)
TopTenMean<-mean(dataset_mod$TopTen)
CoaTenMean<-mean(dataset_mod$CoaTen)
AsCoTenMean<-mean(dataset_mod$AsCoTen)
SizeSMean<-mean(dataset_mod$SizeS)
SizeLMean<-mean(dataset_mod$SizeL)

dataset_mod$MCapTen<-(dataset_mod$CapTen-CapTenMean)
dataset_mod$MTTen<-(dataset_mod$TTen-TTenMean)
dataset_mod$MTopTen<-(dataset_mod$TopTen-TopTenMean)
dataset_mod$MCoaTen<-(dataset_mod$CoaTen-CoaTenMean)
dataset_mod$MAsCoTen<-(dataset_mod$AsCoTen-AsCoTenMean)
dataset_mod$MSizeS<-(dataset_mod$SizeS-SizeSMean)
dataset_mod$MSizeL<-(dataset_mod$SizeL-SizeLMean)

#ln
dataset_mod$lnTeamVal<-(log(dataset_mod$TeamVal))
dataset_mod$lnTraTime<-(log(dataset_mod$TraTime))

#Model no winners lossers of competitions
Mod9a2<- glm(Win1 ~ home_away +lnTeamVal +Alti +lnTraTime  +Bundes +Erediv +LaLiga+Premier +Scotisch  +s1920  +Turf +home_away*MCapTen  +home_away*MCoaTen +home_away*MAsCoTen +home_away*Turf +home_away*MSizeS +home_away*MSizeL +home_away*lnTraTime  +home_away*Alti, data=dataset_mod, family = "binomial")
summary(Mod9a2)
Mod9con<-glm(Win1 ~ lnTeamVal +Alti +lnTraTime +Bundes +Erediv +LaLiga+Premier +Scotisch  +s1920, data=dataset_mod, family = "binomial")
lrtest(Mod9a2, Mod9con)

Mod9b3<- lm(Win2 ~ home_away +lnTeamVal +Alti +lnTraTime  +Bundes +Erediv +LaLiga+Premier +Scotisch  +s1920 +Turf +home_away*MTopTen +home_away*MCoaTen +home_away*MAsCoTen +home_away*Turf +home_away*MSizeS +home_away*MSizeL +home_away*lnTraTime  +home_away*Alti, data=dataset_mod)
summary(Mod9b3)

#----------------------------------Assumptions tests----------------
#Test PPlot 
par(mfrow=c(2,2))
unstandardizedPredicted <- predict(Mod5b4)
unstandardizedResiduals <- resid(Mod5b4)
standardizedPredicted <- (unstandardizedPredicted - mean(unstandardizedPredicted)) / sd(unstandardizedPredicted)
standardizedResiduals <- (unstandardizedResiduals - mean(unstandardizedResiduals)) / sd(unstandardizedResiduals)
probDist <- pnorm(standardizedResiduals)
plot(ppoints(length(standardizedResiduals)), sort(probDist), main = "P-plot Win 2 model 4")
abline(0,1)

#linearity 
plot(Mod5b1,1, main = "Win 2 model 1")
plot(Mod5b2,1, main = "Win 2 model 2")
plot(Mod5b3,1, main = "Win 2 model 3")
plot(Mod5b4,1, main = "Win 2 model 4")

#homoscedasitiy  )  # Breusch-Pagan test
summary(Mod5b1)
lmtest::bptest(Mod5a1)
lmtest::bptest(Mod5b1)
lmtest::bptest(Mod5a2)
lmtest::bptest(Mod5b2)
lmtest::bptest(Mod5a3)
lmtest::bptest(Mod5b3)
lmtest::bptest(Mod5a4)
lmtest::bptest(Mod5b4)
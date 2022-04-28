
library(readxl)
# Synthetic dataset1 cleaning
Dataset1 <- read_excel("Dataset1.xlsx")
Dataset1 <- Dataset1[, -1]
dim(Dataset1)
Dataset1[is.na(Dataset1)]<-0 # 0 means missing values


library(StanHeaders)
library(ggplot2)
library(rstan)

fit1 <- stan(file = "S:/502/project/synthetic_non.stan", # Stan program
             data = list(K=5,d1=1000,d2=500,gamma1=-1.5, gamma2=-0.5,gamma3=0.5, gamma4=1.5,y=Dataset1), # named list of data  
             chains = 4, # number of Markov Chains
             warmup = 10, # number of warmup iterations per chain
             iter = 20, # total number of iterations per chain
             cores = 16, # number of cores
             refresh = 1 #show progress every 'refresh' iterations
)



mix_model=stan_model(model_code=stan_code)
fit=sampling(mix_model,data=list(K=5,d1=1000,d2=500,y=dataset1,gamma1=0),iter = 1) # 5000  
d<-as.data.frame(summary(fit))
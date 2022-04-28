# rstan for Mondo.sub
# the last line shows theta values for the 12 items, the ordering
# of theta roughly agrees with that by "ratings", but opposite signs 

Mondo.sub <- Mondo[apply(!is.na(Mondo), 1, sum) >= 5, ]
Mondo.sub <- Mondo.sub[,apply(is.na(Mondo.sub), 2, mean) != 1]
dim(Mondo.sub)  # [1]  232 1344
Mondo.sub[is.na(Mondo.sub)]<-0

library(StanHeaders)
library(ggplot2)
library(rstan)

fit1 <- stan(file = "S:/502/project/Mondo_non.stan", # Stan program
             data = list(K=5,d1=232,d2=1344,y=Mondo.sub,gamma1=0), # named list of data  
             chains = 1, # number of Markov Chains
             warmup = 10, # number of warmup iterations per chain
             iter = 20, # total number of iterations per chain
             cores = 16, # number of cores
             refresh = 1 #show progress every 'refresh' iterations
)
print(fit1, pars=c("theta", "alpha", "beta", "gamma"), probs=c(.1,.5,.9))
d<-as.data.frame(summary(fit1))
d

library(ggplot2)
ggplot(data=d[1:232,])+
  geom_line(mapping=aes(c(1:232),summary.mean))+
  scale_x_discrete("alpha", limits=seq(1,232,12))+
  theme(axis.text.x = element_text(face="bold",     
                                   color="#993333", angle=45))

ggplot(data=d[233:(233+231),])+
  geom_line(mapping=aes(c(1:232),summary.mean))+
  scale_x_discrete("beta", limits=seq(1,232,12))+
  theme(axis.text.x = element_text(face="bold",     
                                   color="#993333", angle=45))

ggplot(data=d[465:(465+11),])+
  geom_line(mapping=aes(c(1:12),summary.mean))+
  scale_x_discrete("theta", limits=c(1:12))+
  theme(axis.text.x = element_text(face="bold",
                                   color="#993333", angle=45))        

ggplot(data=d[465:(465+1343),])+
  geom_line(mapping=aes(c(1:1344),summary.mean))+
  scale_x_discrete("theta", limits=seq(1,1344,50))+
  theme(axis.text.x = element_text(face="bold",
                                   color="#993333", angle=45)) 

d[1809:1811,"summary.mean"]
# [1] 0.7729511 1.7028446 2.8042451

d[465:476,"summary.mean"]    # theta values for the 12 items
# [1]  0.02318188  0.22936118 -0.10265595 -0.05680593  0.80535511
# [6] -0.35060993  0.04348620  0.70187292  1.50241502 -0.05603974
# [11] -0.64395397 -0.04550752


fit2 <- stan(file = "S:/502/project/Mondo_non.stan", # Stan program
             data = list(K=5,d1=232,d2=1344,y=Mondo.sub,gamma1=0), # named list of data  
             chains = 4, # number of Markov Chains
             warmup = 1000, # number of warmup iterations per chain
             iter = 2000, # total number of iterations per chain
             cores = 16, # number of cores
             refresh = 20 #show progress every 'refresh' iterations
)
d_non<-as.data.frame(summary(fit2))
d_non

ggplot(data=d_non[233:(233+231),])+
  geom_line(mapping=aes(c(1:232),summary.mean))+
  scale_x_discrete("beta", limits=seq(1,232,12))+
  theme(axis.text.x = element_text(face="bold",     
                                   color="#993333", angle=45))


plot(fit1)
#The traceplot method is used to plot the time series of the posterior draws. 
#If we include the warmup draws by setting inc_warmup=TRUE, the background color of
#the warmup area is different from the post-warmup phase:
traceplot(fit1, pars = c("theta", "alpha", "beta", "gamma"), inc_warmup = TRUE, nrow = 2)

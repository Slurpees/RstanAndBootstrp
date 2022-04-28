data {
   int K;
   int d1;
   int d2;
   int y[d1,d2];
   real gamma1;
   real gamma2;
   real gamma3;
   real gamma4;
}

parameters {
  real alpha[d1];
  real beta[d1];
  real theta[d2];
}

//*transformed parameters {
//  vector[d1] beta1;
//  beta = exp(beta1);
//}

model {
  vector[K] theta1;
  for(i in 1:d1){
    alpha[i]~normal(1,1);
    beta[i]~normal(0,1);
  }
  for(j in 1:d2){
    theta[j]~normal(0, 1);
  }
  for(i in 1:d1){
   for(j in 1:d2){
    if(y[i][j]>0){
      real eta;
      eta=alpha[i]+beta[i]*theta[j];
      theta1[1]=(1-Phi(eta-gamma1));
      theta1[2] = Phi(eta - gamma1) - Phi(eta - gamma2);
      theta1[3] = Phi(eta - gamma2) - Phi(eta - gamma3);
      theta1[4] = Phi(eta - gamma3) - Phi(eta - gamma4);
      theta1[5] = Phi(eta - gamma4);
      y[i][j]~categorical(theta1);
    }
   }
  }
}
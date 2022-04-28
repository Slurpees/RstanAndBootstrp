data {
   int K;
   int d1;
   int d2;
   int y[d1,d2];
   real gamma1;
}

parameters {
  real alpha[d1];
  real beta[d1];
  real theta[d2];
  positive_ordered[K-2] gamma;
}

model {
  vector[K] theta1;
  for(i in 1:d1){
    alpha[i]~normal(1,1);
    beta[i]~normal(-5,20);
  }
  for(j in 1:d2){
    theta[j]~normal(0,1);
  }
  for(i in 1:d1){
   for(j in 1:d2){
    if(y[i][j]>0){
      real eta;
      eta=alpha[i]+beta[i]*theta[j];
      theta1[1]=(1-Phi(eta-gamma1));
      theta1[2] = Phi(eta - gamma1) - Phi(eta - gamma[1]);
      theta1[3] = Phi(eta - gamma[1]) - Phi(eta - gamma[2]);
      theta1[4] = Phi(eta - gamma[2]) - Phi(eta - gamma[3]);
      theta1[5] = Phi(eta - gamma[3]);
      y[i][j]~categorical(theta1);
    }
   }
  }
}

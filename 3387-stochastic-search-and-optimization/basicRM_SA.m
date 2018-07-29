% J. C. Spall, March 1999
% This code evaluates the basic root-finding (R-M) SA algorithm.  Computes sample mean 
% and standard deviation of the mean from Navg realizations.
%
n=1000;
randn('seed',71111113)
a=0.081;
A=5.1;
alpha=.501;
s=.1;
theta_0=[1,1]';
Navg=2000;
loss_eq2_5(theta_0)
rslossavg=0;
rslossavgsq=0;
for i=1:Navg
  theta=theta_0;
  for k=1:n
    theta=theta-(a/(k+A)^alpha)*gradloss(theta,s)';
  end
  rslossavg=(i-1)*rslossavg/i+loss_eq2_5(theta)/i;
  rslossavgsq=(i-1)*rslossavgsq/i+(loss_eq2_5(theta)^2)/i;
end
mean=rslossavg
stdevmean=(((Navg/(Navg-1))*(rslossavgsq-mean^2))^.5)/(Navg^.5)


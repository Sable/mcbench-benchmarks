%J.C. Spall, Jan. 2000
%This code implements SPSA with constraints for theta to lie in 
%a specified hypercube (i.e., component-wise constraints).  Allows for multiple cases   
%for purposes of statistical evaluation based on knowledge of true (noise-free) loss value
%(set cases=1 if user only wants one run).
clear all
global p z sigma;  %declaration of random var. (z) used for normal noise
                 %generation in loss fn. calls given seed above;
                 %also sigma in noise (noise may be dependent on theta)
p=10;
n=1000;						%total no. of loss measurements
cases=1;
alpha =.602;
gamma =.101;
a=.0017;
c=1.9;      				%chosen by standard guidelines
A=50;
lossfinalsq=0;          %variable for cum.(over 'cases')squared loss values
lossfinal=0;            %variable for cum. loss values
theta_lo=-1000*ones(p,1);   %lower bounds on theta  
theta_hi=1000*ones(p,1);    %upper bounds on theta 
theta_0=6*ones(p,1);  
lossfinaleval='loss_test';  %choice of loss function for final perf. evaluations (noise-free)                            % evaluation
loss='loss_test_noise';     %loss function used in algorithm operations (with noise)
rand('seed',31415927)
randn('seed',3111113)
sigma=.1;       %multiplier in loss noise 
feval(lossfinaleval,theta_0)
for i=1:cases
  theta=theta_0;
  for k=0:n-1
    ak = a/(k+1+A)^alpha;
    ck = c/(k+1)^gamma;
    delta = 2*round(rand(p,1))-1;
    thetaplus = theta + ck*delta;
    thetaminus = theta - ck*delta;
    yplus=feval(loss,thetaplus);
    yminus=feval(loss,thetaminus);
    ghat = (yplus - yminus)./(2*ck*delta);
    theta=theta-ak*ghat;
    % Two lines below invoke component-wise constraints
    theta=min(theta,theta_hi);
    theta=max(theta,theta_lo);
  end
  lossvalue=feval(lossfinaleval,theta);
  lossfinalsq=lossfinalsq+lossvalue^2;
  lossfinal=lossfinal+lossvalue;
end
% Display results: Mean loss value and standard deviation
%
disp('mean loss value over "cases" runs') 
lossfinal/cases
%
if cases > 1 
	disp('sample standard deviation of mean loss value') 
   sd=((cases/(cases-1))^.5)*(lossfinalsq/cases-(lossfinal/cases)^2)^.5;
   sd=sd/(cases^.5)
else
end

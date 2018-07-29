%J.C. Spall, Jan. 2000
%This code implements SPSA with constraints for theta to lie in 
%a specified hypercube.
%Code includes more "bells and whistles" than required for basic SPSA (as
%available at the SPSA web site and code 'spsa_basic_constrained').
%Code includes loss-based and theta-based
%blocking of iterates (both of these blocking steps are optional).
%Code also allows for averaging SP gradients at each iteration. This code includes
%some evaluation material that is not essential to a basic run of SPSA (i.e., when
%cases > 1, the code is performing multiple runs on the same problem).
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
gavg=1;                 %no. of grad. estimates averaged in update
A=50;
lossfinalsq=0;          %variable for cum.(over 'cases')squared loss values
lossfinal=0;            %variable for cum. loss values
theta_lo=-1000*ones(p,1);   %lower bounds on theta  
theta_hi=1000*ones(p,1);    %upper bounds on theta 
tolerancetheta=Inf;        %max. allowable change in any element of theta 
toleranceloss=0;         %tolerance in loss-based blocking step
avg=0;                   %no. of loss evaluations used in loss-based
                         %blocking (0 implies no blocking)  
theta_0=6*ones(p,1);  
lossfinaleval='loss_test'; % choice of loss function for final perf.
                              % evaluation
loss='loss_test';          % loss function used in algorithm operations
rand('seed',31415927)
randn('seed',3111113)
sigma=.1;       %multiplier in loss noise (lower bd. to standard dev.)
feval(lossfinaleval,theta_0)
for i=1:cases
  theta=theta_0;
  lossold=0;	%lossold initialization is for use in loss-based blocking step below
  for j=1:avg
    lossold=lossold+feval(loss,theta);
  end
  for k=0:(n-avg)/(2*gavg+avg)-1
    ak = a/(k+1+A)^alpha;
    ck = c/(k+1)^gamma;
    ghat=0;
    for j=1:gavg
      delta = 2*round(rand(p,1))-1;
      thetaplus = theta + ck*delta;
      thetaminus = theta - ck*delta;
      yplus=feval(loss,thetaplus);
      yminus=feval(loss,thetaminus);
      ghat = (yplus - yminus)./(2*ck*delta)+ghat;
    end
    thetalag=theta;
    theta=theta-ak*ghat/gavg;
    % Two lines below invoke constraints
    theta=min(theta,theta_hi);
    theta=max(theta,theta_lo);
    % Steps below perform "blocking" step with "avg" no. of loss evaluations
    % This blocking is based on extra loss evaluation(s)   
    lossnew=0;
    for j=1:avg
      lossnew=lossnew+feval(loss,theta);
    end
    if lossnew > lossold-avg*toleranceloss; %if avg=0, this statement is always false
      theta=thetalag;
    else                                    %statements to follow are harmless when avg=0
      lossold1=lossold;
      lossold=lossnew;
    end 
    % Blocking below is based on magnitude of theta change (no loss evals.)
    if max(abs(thetalag-theta)) > tolerancetheta;
      theta=thetalag;
      lossold=lossold1;     %only relevant if also using loss-based blocking
    end
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

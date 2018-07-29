% J.C. Spall, Aug. 1998
% twospsaconstrained
% Code for evaluation of second-order SPSA (2SPSA) versus first-order 
% SPSA (1SPSA, as in Chap. 7 of ISSO).  Code is for comparative evaluation purposes; hence,  
% it includes much that is not required for a basic implementation. Further, it is 
% in no way "optimized" for efficiency or generality; this is strictly research
% code for the purpose of getting a basic idea of how 2SPSA works.

% Code includes the capability for initializing 2SPSA by running 1SPSA for 
% N measurements.  This code allows for averaging of the 
% SP gradients and Hessian estimates at EACH iteration after the initial (N) 
% measurements where only 1SPSA is used for estimating theta.  We use "theta"
% for the 2SPSA recursion.  Code allows for checking for simple constraint 
% violation (componentwise constraints).
%
% UPDATE MAR. 2006: Feedback and weighting versions of this code are available from the author;
% this can generally provide enhanced performance. (Reference: Spall, J. C. (2006), “Feedback and Weighting Mechanisms 
% for Improving Jacobian (Hessian) Estimates in the Adaptive Simultaneous Perturbation Algorithm,” Proceedings of the 
% American Control Conference, 14-16 June 2006, Minneapolis, MN, paper ThB09.1 in CD-ROM.)
%
clear all
close all
global z sigma p;       %declaration of random var. used for normal noise
                        %generation in loss fn. calls given seed above 
p=10;
%value of numerator in a_k sequence for all iterations of 1SPSA 
%and first N-measurement-based iterations in the initialization of 2SPSA
a1=.02;
%value of numerator in a_k in 2SPSA part
a2=1;
A1=100;           %stability constant for 1SPSA
A2=0;           %stability constant for 2SPSA
c1=2;         %numerator in c_k for 1SPSA 
c2=2*c1;         %numerator in c_k for 2SPSA
ctilda=2*c2;     %numerator in ctilda_k for 2SPSA;
alpha1=.602;      %a_k decay rate for 1SPSA 
alpha2=1;         %a_k decay rate for 2SPSA
gamma1=.101;      %c_k decay rate for 1SPSA
gamma2=.1666701;        %c_k decay rate for 2SPSA
n=2000;	    	%total no. of function measurements
N=2;				%no. of function meas. for 1SPSA initialization	
loss='lossrosenbr_noise';	  %loss function for use in algorithm (usually with noise)
lossfinaleval='lossrosenbr'; %loss function for "true" evaluation of algorithm (no noise)
cases=1;         % number of cases (replications) of 2SPSA and 1SPSA
gH_avg=1;               %no. of averaged gradients/Hessian in 2SPSA
toleranceloss=2;			%tolerance in loss-based blocking step
avg=1;				%no. of loss evals. per loss-based blocking step (1SPSA&2SPSA)
tolerancetheta=1;		%max. allowable change in elements of theta
rand('seed',31415297)
randn('seed',3111113)
sigma=2;                        
%
%the loop 1:cases below is for doing multiple cases for use in averaging to 
%evaluate the relative performance.  
%
%the first loop in 2SPSA below uses the standard 1SPSA form to initialize 2SPSA
%
%the second loop does 2SPSA following guidelines in Spall ASP (Chap. 7 of ISSO))
%
%lines below initialize various recursions for the gradient/Hess. averaging
%and for final error reporting based on the average of the solutions for 
%"cases" replications.
%
meanHbar=0;
errtheta=0;
losstheta=0;				%cum. sum of loss values
lossthetasq=0;			%cum. sum of loss squared values
theta_lo=-2.048*ones(p,1);   %lower bounds on theta  
theta_hi=2.047*ones(p,1);    %upper bounds on theta 
truetheta=ones(p,1);
theta_0=-.52276*ones(p,1);
%DUMMY STATEMENT FOR SETTING DIMENSIONS OF Hhat (AVOIDS OCCASIONAL
%ERROR MESSAGES)
Hhat=eye(p);
for j=1:cases
%INITIALIZATION OF PARAMETER AND HESSIAN ESTIMATES
  theta=theta_0;
  Hbar=500*eye(p);
  lossold=0;	%lossold calculation is for use in loss-based blocking step below
  for i=1:avg
    lossold=lossold+feval(loss,theta);
  end
%INITIAL N ITERATIONS OF 1SPSA PRIOR TO 2SPSA ITERATIONS
  for k=1:(N-avg)/(2+avg)    %use of N-avg is to account for avg used in setting lossold 
    a_k=a1/(k+A1)^alpha1;
    c_k=c1/k^gamma1; 
    delta=2*round(rand(p,1))-1;
    thetaplus=theta+c_k*delta;
    thetaminus=theta-c_k*delta;  
    yplus=feval(loss,thetaplus);
    yminus=feval(loss,thetaminus);
    ghat=(yplus-yminus)./(2*c_k*delta);   
%   theta update
    thetalag=theta;
    theta=theta-a_k*ghat;
    % Two lines below invoke constraints
    theta=min(theta,theta_hi);
    theta=max(theta,theta_lo);
    % Steps below perform "blocking" step with "avg" no. of loss evaluations
    % This blocking is based on extra loss evaluation(s)   
    lossnew=0;
    for i=1:avg
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
 caseiter=j   %print-out of iteration number (for monitoring progress)  
%
% START 2SPSA ITERATIONS FOLLOWING INITIALIZATION
%  
for k=(N-avg)/(2+avg)+1:(N-avg)/(2+avg)+(n-N)/(gH_avg*4+avg)
    a_k=a2/(k+A2)^alpha2;
    c_k=c2/k^gamma2;
    ctilda_k=ctilda/k^gamma2;
    ghatinput=0;
    Hhatinput=0;
% GENERATION OF AVERAGED GRADIENT AND HESSIAN (NO AVERAGING IF gH_avg=1)                 
    for m=1:gH_avg
      delta=2*round(rand(p,1))-1;
      thetaplus=theta+c_k*delta;
      thetaminus=theta-c_k*delta;  
      yplus=feval(loss,thetaplus);
      yminus=feval(loss,thetaminus);
      ghat=(yplus-yminus)./(2*c_k*delta);  
% GENERATE THE HESSIAN UPDATE
      deltatilda=2*round(rand(p,1))-1;
      thetaplustilda=thetaplus+ctilda_k*deltatilda;
      thetaminustilda=thetaminus+ctilda_k*deltatilda;
% LOSS FUNCTION CALLS      
      yplustilda=feval(loss,thetaplustilda);
      yminustilda=feval(loss,thetaminustilda);
      ghatplus=(yplustilda-yplus)./(ctilda_k*deltatilda);
      ghatminus=(yminustilda-yminus)./(ctilda_k*deltatilda);
% STATEMENT PROVIDING AN AVERAGE OF SP GRAD. APPROXS. PER ITERATION
      ghatinput=((m-1)/m)*ghatinput+ghat/m;
      deltaghat=ghatplus-ghatminus;
      for i=1:p
        Hhat(:,i)=deltaghat(i)./(2*c_k*delta);
      end
      Hhat=.5*(Hhat+Hhat');
      Hhatinput=((m-1)/m)*Hhatinput+Hhat/m; 
    end 
    Hbar=((k-(N-avg)/(2+avg))/(k-(N-avg)/(2+avg)+1))*Hbar+Hhatinput/(k-(N-avg)/(2+avg)+1);          
%   THE THETA UPDATE (FORM BELOW USES GAUSSIAN ELIMINATION TO AVOID DIRECT 
%   COMPUTATION OF HESSIAN INVERSE)
    Hbarbar=sqrtm(Hbar*Hbar+.000001*eye(p)/k);
    thetalag=theta;
    % The main update step
    theta=theta-a_k*(Hbarbar\ghatinput);
    % Two lines below invoke constraints
    theta=min(theta,theta_hi);
    theta=max(theta,theta_lo);
    %   Steps below perform "blocking" step with "avg" no. of loss evaluations
    lossnew=0;
    for i=1:avg
      lossnew=lossnew+feval(loss,theta);
    end
    if lossnew > lossold-avg*toleranceloss;
      theta=thetalag;
    else
      lossold1=lossold;
      lossold=lossnew;
    end 
    if max(abs(thetalag-theta)) > tolerancetheta; 
      theta=thetalag;
      lossold=lossold1;
   end 
 end
theta
meanHbar=meanHbar+Hbar;
errtheta=errtheta+(theta-truetheta)'*(theta-truetheta); 
lossthetasq=lossthetasq+feval(lossfinaleval,theta)^2;
losstheta=losstheta+feval(lossfinaleval,theta);
end
meanHbar/cases
% normalized results of 1SPSA and 2SPSA
if norm(theta_0-truetheta)~= 0
  ((errtheta/cases)^.5)/norm(theta_0-truetheta)
end  
% standard dev. of mean of normalized loss values; these are by multiplied by 
% (cases/(cases-1))^.5 to account for loss of degree of freedom in standard 
% deviation calculation before using with t-test
if cases > 1
  (cases^(-.5))*((cases/(cases-1))^.5)*(lossthetasq/(cases*feval(lossfinaleval,theta_0)^2)-(losstheta/(cases*feval(lossfinaleval,theta_0)))^2)^.5
end
% mean normalized terminal loss value
losstheta/(cases*feval(lossfinaleval,theta_0))
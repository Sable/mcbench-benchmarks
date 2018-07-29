% J.C. Spall, Sept. 1998
% twoSGconstrained
% Code for evaluation of second-order SGSA (2SGSA) versus first-order 
% SGSA (1SGSA, as in Chap. 5 of ISSO).  Code is for comparative evaluation purposes; hence,  
% it includes much that is not required for a basic implementation. Further, it is 
% in no way "optimized" for efficiency or generality; this is strictly research
% code for the purpose of getting a basic idea of how 2SGSA works.
%
% Code includes the capability for initializing 2SGSA by running 1SGSA for
% N iterations.  This code allows for averaging of the 
% SG gradients and Hessian estimates at EACH iteration after the 
% initial (N) iterations where only 1SGSA is used for estimating theta.  We use "thetaH"
% for the 2SGSA recursion and "theta" for the 1SGSA recursion.
%
% UPDATE MAR. 2006: Feedback and weighting versions of this code are available from the author;
% this can generally provide enhanced performance. (Reference: Spall, J. C. (2006), “Feedback and Weighting Mechanisms 
% for Improving Jacobian (Hessian) Estimates in the Adaptive Simultaneous Perturbation Algorithm,” Proceedings of the 
% American Control Conference, 14-16 June 2006, Minneapolis, MN, paper ThB09.1 in CD-ROM.)
%
clear all
close all
global p z sigma
p=10;
% meas. noise standard deviation; multplies all elements of N(0,I)noise % vector
sigma=0;
% value of numerator in a_k sequence for all iterations of 1SGSA 
% and first N iterations in the initialization of 2SGSA
aN=20*1.4;
%value of numerator in a_k in 2SGSA (beginning at N+1)
%the number 23.622 below is relevant to N=500 and A=50
%(i.e., it is such that 23.622/(N+1+A)^.501 = 1)
a=.1*23.622;
A=50;
c=.001;
alpha=1; 
gamma=.5;      
n=1000;
N=500;
% number of cases (replications) of 2SGSA and 1SGSA
cases=1;
% number of individual gradient/Hessian estimates to be averaged at each iter.
gH_avg=1;
avg=1;
rand('seed',31415297)
randn('seed',311113)
thetamin=-5*ones(p,1);   %Lower bounds on theta (in unconstrained, set to large neg. no.) 
thetamax=5*ones(p,1);    %Upper bounds on theta (in unconstrained, set to large po
%
%the loop 1:cases below is for doing multiple cases for use in %averaging to
%evaluate the relative performance.  
%
%the loop 1:N below uses the standard 1SG form to initialize 2SGA
%
%lines below initialize various recuresions for the gradient/Hess. %averaging
%and for final error reporting based on the average of the solutions %for 
%"cases" replications.
meanHbar=0;
errtheta=0;
errthetaIA=0;
errthetaH=0;
losstheta=0;
lossthetaIA=0;
lossthetaH=0;
lossthetasq=0;
lossthetaIAsq=0;
lossthetaHsq=0;
tolerancetheta=10;
toleranceloss=0;
truetheta=zeros(p,1);
theta_0=ones(p,1);
loss4thorder(theta_0)  %this is a particular loss function used in some studies (with loss4thgrad)
%DUMMY STATEMENT FOR SETTING DIMENSIONS OF Hhat (AVOIDS OCCASIONAL
%ERROR MESSAGES)
Hhat=eye(p);
for j=1:cases
  caseiter=j
%INITIALIZATION OF PARAMETER AND HESSIAN ESTIMATES
  theta=theta_0;
  thetaH=theta;
  Hbar=.1*eye(p);
%*********2SG********* 
%INITIAL N ITERATIONS OF 1SG PRIOR TO 2SG ITERATIONS
  for k=1:N
    ak=aN/(k+A)^alpha;
    Gk=loss4thgrad(thetaH);
    thetaHlag=thetaH;
    thetaH=thetaH-ak*Gk;
    % Checking for constraints below
    thetaH=min(thetaH,thetamax);
    thetaH=max(thetaH,thetamin);
    if max(abs(thetaHlag-thetaH)) > tolerancetheta;
      thetaH=thetaHlag;
    end
  end
  lossold=0;
  for i=1:avg
    lossold=lossold+loss4thnoise(thetaH);
  end  
%
% 2SG ITERATIONS FOLLOWING INITIALIZATION
%   
  for k=N+1:n
    ak=a/(k+A-N)^alpha;
    ck=c/k^gamma;
    ghatinput=0;
    Hhatinput=0;
% GENERATION OF AVERAGED GRADIENT AND HESSIAN (NO AVERAGING IF 
% gH_avg=1)                 
    for m=1:gH_avg
      delta=2*round(rand(p,1))-1;
      thetaplus=thetaH+ck*delta;
      thetaminus=thetaH-ck*delta;  
      ghatplus=loss4thgrad(thetaplus); 
      ghatminus=loss4thgrad(thetaminus);
% STATEMENT PROVIDING AN AVERAGE OF SP GRAD. APPROXS. PER ITERATION
      ghatinput=((m-1)/m)*ghatinput+loss4thgrad(thetaH)/m;
      deltaghat=ghatplus-ghatminus;
      for i=1:p
        Hhat(:,i)=deltaghat(i)./(2*ck*delta);
      end
      Hhat=.5*(Hhat+Hhat');
      Hhatinput=((m-1)/m)*Hhatinput+Hhat/m; 
    end 
    Hbar=((k-N)/(k-N+1))*Hbar+Hhatinput/(k-N+1);        
%   THE THETA UPDATE (FORM BELOW USES GAUSSIAN ELIMINATION TO AVOID    %   DIRECT COMPUTATION OF HESSIAN INVERSE)
    Hbarbar=sqrtm(Hbar*Hbar+.000001*eye(p)/k);
    thetaHlag=thetaH;
    thetaH=thetaH-ak*(Hbarbar\ghatinput);
    % Checking for constraints below
    thetaH=min(thetaH,thetamax);
    thetaH=max(thetaH,thetamin);
%   Steps below perform "blocking" step with "avg" no. of loss evaluations
    lossnew=0;
    for i=1:avg
      lossnew=lossnew+loss4thnoise(thetaH);
    end
    if lossnew/avg > lossold/avg-toleranceloss;
      thetaH=thetaHlag;
    else
      lossold1=lossold;
      lossold=lossnew;
    end 
    if max(abs(thetaHlag-thetaH)) > tolerancetheta;
      lossold=lossold1;
      thetaH=thetaHlag;
    end    
  end
  thetaH
  Hbar
  loss4thorder(thetaH)
%  
%********1SGSA*************  
% The iterations below are the basic SG iterations.  Uses the same gain sequences
% as the 1:N block above (where 2SGSA is not fully engaged).  Uses same number
% of loss gradient measurements.  Also count L evaluation in 2SGSA to 
% have same cost as grad. evaluation (hence multiplier "4" vs."3" in "for" loops below).
% The overall loop is broken into two parts to accomodate a sliding window of
% the last IA iterates for an iterate averaging solution.
%
  IA=200;                      % amt. of iterate averaging
  for k=1:N+4*(n-N)*gH_avg - IA
    ak=aN/(k+A)^.602;
    Gk=loss4thgrad(theta);
    thetalag=theta;
    theta=theta-ak*Gk;
    % Checking for constraints below
    theta=min(theta,thetamax);
    theta=max(theta,thetamin);
    if max(abs(thetalag-theta)) > tolerancetheta;
      theta=thetalag;
    end    
  end
  thetabar=0;
  for k=N+4*(n-N)*gH_avg - IA+1:N+4*(n-N)*gH_avg 
    ak=aN/(k+A)^.602;
    Gk=loss4thgrad(theta);
    thetalag=theta;
    theta=theta-ak*Gk;
    % Checking for constraints below
    theta=min(theta,thetamax);
    theta=max(theta,thetamin);
    if max(abs(thetalag-theta)) > tolerancetheta;
      theta=thetalag;
    end    
    thetabar=thetabar+theta;
  end
  theta
  thetabar=thetabar/IA;  
  meanHbar=meanHbar+Hbar;
  errtheta=errtheta+(theta-truetheta)'*(theta-truetheta); 
  errthetaIA=errthetaIA+(thetabar-truetheta)'*(thetabar-truetheta);
  errthetaH=errthetaH+(thetaH-truetheta)'*(thetaH-truetheta);
  lossthetasq=lossthetasq+loss4thorder(theta)^2;
  lossthetaIAsq=lossthetaIAsq+loss4thorder(thetabar)^2;
  lossthetaHsq=lossthetaHsq+loss4thorder(thetaH)^2;
  losstheta=losstheta+loss4thorder(theta);
  lossthetaIA=lossthetaIA+loss4thorder(thetabar);
  lossthetaH=lossthetaH+loss4thorder(thetaH);
end
meanHbar/cases
% normalized results of 1SGSA and 2SGSA
norm_theta=((errtheta/cases)^.5)/((theta_0-truetheta)'*(theta_0-truetheta))^.5
norm_thetaIA=((errthetaIA/cases)^.5)/((theta_0-truetheta)'*(theta_0-truetheta))^.5
norm_thetaH=((errthetaH/cases)^.5)/((theta_0-truetheta)'*(theta_0-truetheta))^.5
% standard dev. of mean of normalized loss values; these are by multiplied by 
% (cases/(cases-1))^.5 to account for loss of degree of freedom in standard 
% deviation calculation before using with t-test
if cases > 1;
  (cases^(-.5))*((cases/(cases-1))^.5)*(lossthetasq/(cases*loss4thorder(theta_0)^2)-(losstheta/(cases*loss4thorder(theta_0)))^2)^.5
  (cases^(-.5))*((cases/(cases-1))^.5)*(lossthetaIAsq/(cases*loss4thorder(theta_0)^2)-(lossthetaIA/(cases*loss4thorder(theta_0)))^2)^.5
  (cases^(-.5))*((cases/(cases-1))^.5)*(lossthetaHsq/(cases*loss4thorder(theta_0)^2)-(lossthetaH/(cases*loss4thorder(theta_0)))^2)^.5
end
norm_losstheta=losstheta/(cases*loss4thorder(theta_0))
norm_lossthetaIA=lossthetaIA/(cases*loss4thorder(theta_0))
norm_lossthetaH=lossthetaH/(cases*loss4thorder(theta_0))

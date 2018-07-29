% J. C. Spall, March 2001
% Code for carrying out iterate averaging, including the sliding window method.
% Code includes mechanism for blocking step if a change in an element of theta exceeds
% certain threshold.
% 
global p z sigma
p=20;
% meas. noise standard deviation; multplies all elements of N(0,I)noise % vector
sigma=.10;
a=.2;
A=100;
alpha=.501; 
n=1000; % no. of iterations
IA=1;                      % amt. of iterate averaging (1<=IA<=n)
% number of cases (replications)  
cases=25;
randn('seed',311113)
thetamin=-500*ones(p,1);   %Lower bounds on theta (in unconstrained, set to large neg. no.) 
thetamax=500*ones(p,1);    %Upper bounds on theta (in unconstrained, set to large pos. no.)
root='cubic_root';
%
%the loop 1:cases below is for doing multiple cases for use in %averaging to
%evaluate the relative performance.  
%
errtheta=0;
%losstheta=0;
tolerancetheta=100; %iterate is blocked if change in theta exceeds this value
truetheta=zeros(p,1);
theta_0=ones(p,1);
for j=1:cases
 caseiter=j
%INITIALIZATION 
  theta=theta_0;
%
% The iterations below are the basic R-M iterations. 
% The overall loop is broken into two parts to accomodate a sliding window of
% the last IA iterates for an iterate averaging solution.
%
    for k=0:n-IA-1
       ak=a/(k+1+A)^alpha;
       Yk=feval(root,theta);
       thetalag=theta;
       theta=theta-ak*Yk;
       if max(abs(thetalag-theta)) > tolerancetheta;
          theta=thetalag;
       end    
    % Checking for constraints below
       theta=min(theta,thetamax);
       theta=max(theta,thetamin);
    end
% Below invokes iterate averaging after the initial iterations  
    thetabar=0;
    for k=n-IA:n-1
       ak=a/(k+1+A)^alpha;
       Yk=feval(root,theta);
       thetalag=theta;
       theta=theta-ak*Yk;
       if max(abs(thetalag-theta)) > tolerancetheta;
           theta=thetalag;
       end    
    % Checking for constraints below
       theta=min(theta,thetamax);
       theta=max(theta,thetamin);
       thetabar=thetabar+theta;
    end
    thetabar=thetabar/IA  
    errtheta=errtheta+(thetabar-truetheta)'*(thetabar-truetheta); 
%   lossthetasq=lossthetasq+loss4thorder(theta)^2;
%   losstheta=losstheta+loss4thorder(theta);
end
% RMS error over all cases (square root of average MSE)
if cases > 1
   ((errtheta/cases)^.5)
else
   errtheta^.5
end
% standard dev. of normalized loss values
%(lossthetasq/(cases*loss4thorder(theta_0)^2)-(losstheta/(cases*loss4thorder(theta_0)))^2)^.5
%losstheta/(cases*loss4thorder(theta_0))

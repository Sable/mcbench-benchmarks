% J. C. Spall, March 2000
% This code computes the FDSA estimate for a given no. of loss measurements.  
% Code allows multiple
% replications ("cases") for averaging solutions.
% Separate code is given in Chapter 7, which is designed for Monte Carlo comparisons of 
% FDSA and SPSA.
% This code includes a d vector for use in storing data for plotting or analysis purposes. 
% This vector has nothing per se to do with the algorithm or optimization process (it was
% used in creating Figure 6.2 in ISSO).
%
global sigma p noise
p=2;
nFD=100;			% No. of loss measurements used in FDSA (per realization)
sigma=1;
loss='loss_waste_noise';
loss_nonoise='loss_waste_noisefree';
cases=50; 
alpha=1;
gamma =.16666701;
% Gain coefficients 
aFD=.4;
cFD=1;
AFD=0;
e=eye(p);
% INITIALIZATION
theta_0=3*ones(p,1); 
theta_lo=0*ones(p,1);   	%lower bounds on theta  
theta_hi=5*ones(p,1);    	%upper bounds on theta 
rand('seed',31415927)
randn('seed',511111113)
meanlossFD=0;
errthetaFD=0;
losssqFD=0;
ghat=zeros(p,1);		%dummy statements for setting dimension
yplus=zeros(1,1);
yminus=zeros(1,1);
t=2.0096;				%t-quantile for confidence interval calculation
truetheta=[1,0.666667]';
for i=1:cases
  replication=i 	% for monitoring output in large-scale runs 
  theta=theta_0;
  d(1,i,2)=feval(loss_nonoise,theta); 	%true loss value for evaluation and plotting purposes 
  													%(not part of optimization process)
  for k=1:nFD/(2*p)
    ak = aFD/(k+AFD)^alpha;
    ck = cFD/k^gamma;
    for j=1:p
      thetaplus = theta+ck*e(:,j);
      thetaminus = theta-ck*e(:,j);
      yplus=feval(loss,thetaplus);
      yminus=feval(loss,thetaminus);
      ghat(j)=(yplus - yminus)/(2*ck);
    end
    theta=theta-ak*ghat;
    % Two lines below invoke constraints
    theta=min(theta,theta_hi);
    theta=max(theta,theta_lo);
    d(k+1,i,2)=feval(loss_nonoise,theta); %records true loss value for ith case, kth iteration  
  end
  eval=feval(loss_nonoise,theta);
  meanlossFD=(i-1)*meanlossFD/i+eval/i;
  losssqFD=(i-1)*losssqFD/i+eval^2/i;
  errthetaFD=(i-1)*errthetaFD/i+((theta-truetheta)'*(theta-truetheta))^.5/i;  
end
meanlossFD
errthetaFD
if cases > 1
   sd_FD=(cases^(-.5))*((cases/(cases-1))^.5)*(losssqFD-meanlossFD^2)^.5
   % Confidence intervals
   [meanlossFD-t*sd_FD,meanlossFD+t*sd_FD]
else   
end

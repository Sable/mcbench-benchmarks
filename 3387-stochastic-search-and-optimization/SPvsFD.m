% This code compares SPSA and FDSA for a given no. of loss measurements.  Code allows multiple
% replications ("cases") for averaging solutions.  Code allows for averaging of SP gradient
% approximations
%
global sigma p noise
p=2;
nSP=2;			% No. of loss measurements used in SPSA (per realization)
nFD=100;			% No. of loss measurements used in FDSA (per realization)
sigma=1;
loss='losswaste_noise';
loss_nonoise='losswaste';
cases=50; 
alpha=1;
gamma =.16666701;
% Gain coefficients unique to SPSA
aSP=.001;
cSP=.0001;
gavg=1;
ASP=20;
% Gain coefficients unique to FDSA
aFD=.4;
cFD=1;
AFD=0;
e=eye(p);
% INITIALIZATION FOR BOTH ALGORITHMS
theta_0=3*ones(p,1);
theta_lo=0*ones(p,1);   	%lower bounds on theta  
theta_hi=5*ones(p,1);   	%upper bounds on theta 
rand('seed',31415927)
randn('seed',511111113)
meanlossSP=0;
meanlossFD=0;
errthetaFD=0;
losssqSP=0;		%this and next line initialize variables for calculating standard dev.
							%of loss values
losssqFD=0;
ghat=zeros(p,1);		%dummy statements for setting dimension
yplus=zeros(1,1);
yminus=zeros(1,1);
t=2.0096;				%t-quantile for confidence interval calculation
truetheta=[1,0.666667]';
for i=1:cases
  replication=i
% SPSA RUNS 
  theta=theta_0;
  for k=1:nSP/(2*gavg)
    ak = aSP/(k+ASP)^alpha;
    ck = cSP/k^gamma;
    ghat=0;
    for j=1:gavg
      delta = 2*round(rand(p,1))-1;
      thetaplus = theta+ck*delta;
      thetaminus = theta-ck*delta;
      yplus=feval(loss,thetaplus);
      yminus=feval(loss,thetaminus);
      ghat=(yplus-yminus)./(2*ck*delta)+ghat;
    end
    theta=theta-ak*ghat/gavg;
 % Two lines below invoke constraints
    theta=min(theta,theta_hi);
    theta=max(theta,theta_lo);
  end
  eval=feval(loss_nonoise,theta);	
  meanlossSP=(i-1)*meanlossSP/i+eval/i;
  losssqSP=(i-1)*losssqSP/i+eval^2/i;
%
% FDSA RUNS
%
  theta=theta_0;
  d(1,i,2)=feval(loss_nonoise,theta);
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
%
% Display of results.  
meanlossSP
meanlossFD
if cases > 1
   sd_SP=(cases^(-.5))*((cases/(cases-1))^.5)*(losssqSP-meanlossSP^2)^.5
   sd_FD=(cases^(-.5))*((cases/(cases-1))^.5)*(losssqFD-meanlossFD^2)^.5
   % Confidence intervals
   [meanlossSP-t*sd_SP,meanlossSP+t*sd_SP]
   [meanlossFD-t*sd_FD,meanlossFD+t*sd_FD]
else   
end

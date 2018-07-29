% J. C. Spall, 2000
% Written in support of text, Introduction to Stochastic Search and Optimization, 2003
% Code does the global version of SPSA based on 
% the Gelfand & Mitter, Fang, et al., etc. idea of
% adding Monte Carlo noise.  The basic FDSA code is 
% commented out in case of future interest in doing a
% global version of that too.
p=10;
N=20000;			%TOTAL NO. OF LOSS MEAS.
sigma=1;       %Meas. noise standard deviation
cases=5;
alpha =.602;
gamma =.101;
% COEFFICIENTS UNIQUE TO SPSA
aSP=20;
bSP=.50;
cSP=10;
gavg=1;      %amount of gradient averaging
ASP=100;
% GAIN COEFFICIENTS UNIQUE TO FDSA
%aFD=.55;
%cFD=1;
%AFD=2.5;
%e=eye(p);
% INITIALIZATION FOR ALGORITHM
theta_0= 2*3.1338*ones(p,1);
STexamp6(theta_0) 
rand('seed',31415927)
randn('seed',1111113)
cumlossSP=0;
%cumlossFD=0;
for i=1:cases
% SPSA RUNS 
  theta=theta_0;
  for k=1:N/(2*gavg)
    ak = aSP/(k+ASP)^alpha;
    ck = cSP/k^gamma;
    ghat=0;
    for j=1:gavg
      delta = 2*round(rand(p,1))-1;
      thetaplus = theta + ck*delta;
      thetaminus = theta - ck*delta;
      yplus=STexamp6(thetaplus)+sigma*randn;
      yminus=STexamp6(thetaminus)+sigma*randn;
      ghat = (yplus - yminus)./(2*ck*delta)+ghat;
    end
    wk=randn(p,1);
    bk=bSP/((log(k+1))*k^(alpha/2));       
    theta=theta-ak*ghat/gavg + bk*wk;
  end
  cumlossSP=(i-1)*cumlossSP/i+STexamp6(theta)/i;
%
% FDSA RUNS
%
%  theta=theta_0;
%  for k=1:N/(2*p)
%    ak = aFD/(k+AFD)^alpha;
%    ck = cFD/k^gamma;
%    for j=1:p
%      thetaplus = theta + ck*e(:,j);
%      thetaminus = theta - ck*e(:,j);
%      yplus=lossnew(thetaplus)+s*randn;
%      yminus=lossnew(thetaminus)+s*randn;
%      ghat(j) = (yplus - yminus)/(2*ck);
%    end
%    theta=theta-ak*ghat;
%  end
%cumlossFD=(i-1)*cumlossFD/i+lossnew(theta)/i;
theta
STexamp6(theta)
end
cumlossSP
%cumlossFD


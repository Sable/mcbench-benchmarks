% this script represents the evolution of the covariance of an OU process in terms of the dispersion ellipsoid
% see A. Meucci (2009) 
% "Review of Statistical Arbitrage, Cointegration, and Multivariate Ornstein-Uhlenbeck"
% available at ssrn.com

% Code by A. Meucci, April 2009
% Most recent version available at www.symmys.com > Teaching > MATLAB

clear; clc; close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input parameters of multivariate OU process
K=1;
J=1;

x0=rand(K+2*J,1);

Mu=rand(K+2*J,1);

A=rand(K+2*J,K+2*J)-.5;
ls=rand(K,1)-.5;
gs=rand(J,1)-.5;
os=rand(J,1)-.5;

S=rand(K+2*J,K+2*J)-.5;

ts=.01*[0:10:100];
NumSimul=10000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% process inputs
Gamma=diag(ls);
for j=1:J
    G=[gs(j)  os(j)
           -os(j) gs(j)];
    Gamma=blkdiag(Gamma,G);
end
Theta=A*Gamma*inv(A);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% one-step exact simulation
Sigma=S*S';
X_0=repmat(x0',NumSimul,1);
[X_t1, MuHat_t1, SigmaHat_t1]=OUstep(X_0,ts(end),Mu,Theta,Sigma);

% multi-step simulation: exact and Euler approximation
X_t=repmat(x0',NumSimul,1);
X_tE=X_t;
for s=1:length(ts)
    Dt=ts(1);
    if s>1
        Dt=ts(s)-ts(s-1);
    end
    [X_t,MuHat_t,SigmaHat_t]=OUstep(X_t,Dt,Mu,Theta,Sigma);
    %[X_tE,MuHat_tE,SigmaHat_tE]=OUstepEuler(X_tE,Dt,Mu,Theta,Sigma);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plots  
Pick=[K+2*J-1 K+2*J];

% horizon simulations
hold on
h5=plot(X_t1(:,Pick(1)),X_t1(:,Pick(2)),'.');
set(h5,'color','r','markersize',4)

% horizon location
hold on
h4=plot(MuHat_t1(Pick(1)),MuHat_t1(Pick(2)),'.');
set(h4,'color','k','markersize',5)

% horizon dispersion ellipsoid 
hold on
h3=TwoDimEllipsoid(MuHat_t1(Pick),SigmaHat_t1(Pick,Pick),2,0,0);
set(h3,'color','k','linewidth',2);

% starting point
hold on
h2=plot(x0(Pick(1)),x0(Pick(2)),'.');
set(h2,'color','b','markersize',5)

% starting generating dispersion ellipsoid
hold on
h1=TwoDimEllipsoid(x0(Pick),Sigma(Pick,Pick),2,0,0);
set(h1,'color','b','linewidth',2);

legend([h1 h3],'generator','horizon');
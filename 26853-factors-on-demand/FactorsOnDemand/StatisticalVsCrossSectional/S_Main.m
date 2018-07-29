%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This scripts runs a case study for Factors on Demand, where estimation is performed using random matrix theory 	
% and attribution is done on industry and characteristic-based factors.

% see Meucci, A. (2010) "Factors on Demand", Risk, 23, 7, p. 84-89
% available at http://ssrn.com/abstract=1565134

% Code by A. Meucci. This version March 2010 
% Last version available at MATLAB Central File Exchange as "Factors on Demand"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load DB_Rets 
R=R(:,1:100);
load DB_Facts

J=10000;
RMT_Cut=20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estimate and represent return distribution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=size(R,2);
K=size(Z,2);

% perform Principal Component Analysis for Random Matrix Theory
X=log(1+R);
S_XX=cov(X,1);
[E,L]=pcacov(S_XX);
B=E(:,1:RMT_Cut); % significant eigenvectors define non-noisy space
E_K_=E(:,RMT_Cut+1:end); % isotropic eigenvectors define noisy space
L_K=sqrt(mean(L(K+1:end))); % isotropic volatility in noisy space

% joint simulations for normalized significant estimation factors Y_F and noise
F=X*B;
[x_F,cdf_F,G_F]=SeparateMargCop(F(:,1:RMT_Cut));
Y_F=norminv(G_F);
Corr_Y_F=eye(RMT_Cut);
[Y_F_,Rot_U_] = SimulateFactorsResiduals(Corr_Y_F, L_K*ones(N-RMT_Cut,1),J);

% simulations for significant estimation factors F
G_F_=normcdf(Y_F_);
F_=MergeMargCop(x_F,cdf_F,G_F_);

% simulations for noise U
U_= Rot_U_*E_K_';

% simulations for returns
X_=F_*B'+U_;
R_=exp(X_)-1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estimate and represent distribution of interpretation factors Y_Z 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[x_Z,cdf_Z,G_Z]=SeparateMargCop(Z);
Y_Z=norminv(G_Z);

% estimate correlations of normalized interpretation factors Y_Z 
Corr_Y_Z = corr(Y_Z);
% estimate cross-correlation of normalized estimation factors Y_F and normalized interpretation factors Y_Z

Corr_YF_YZ =ComputeCrossCorrelation(Y_F, Y_Z, Corr_Y_F);

% simulations for normalized interpretation factors Y_Z
Y_Z_=MvnRndMatchCrossCov(Corr_Y_Z, Corr_YF_YZ, Y_F_, Corr_Y_F);

% simulations for interpretation factors Z
G_Z_=normcdf(Y_Z_);
Z_=MergeMargCop(x_Z,cdf_Z,G_Z_);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run portfolio analysis 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w=ones(N,1)/N;
R_w=R_*w;   

Q=Z_'*Z_/J;
q=-R_w'*Z_/J;
A=[];
b=[];
Aeq=[];
beq=[];
lb=[];
ub=[];
d = quadprog(Q,q,A,b,Aeq,beq,lb,ub);
e_ = R_w-Z_*d;

s=std(R_w,1);
S_R=cov(R_,1);
S_F=cov([Z_ e_],1);
d_=[d;1];

c_w=w.*(S_R*w)/s;
c_d=d_.*(S_F*d_)/s;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%...per security
subplot('Position',[.2 .55 .75 .35])
DisplayCumumlBars(c_w)
xlim([0 N+1])
Ylim=get(gca,'ylim');
grid on

subplot('Position',[.05 .55 .1 .35])
bar(s,'r')
set(gca,'ylim',Ylim);
grid on


%...per factor
subplot('Position',[.2 .1 .75 .35])
DisplayCumumlBars(c_d)
xlim([0 K+2])
set(gca,'ylim',Ylim);
grid on

subplot('Position',[.05 .1 .1 .35])
bar(s,'r')
set(gca,'ylim',Ylim);
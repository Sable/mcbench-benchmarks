% This script compares the numerical and the analytical solution of entropy-pooling, see
% "A. Meucci - Fully Flexible Views: Theory and Practice -
% The Risk Magazine, October 2008, p 100-106"
% available at www.symmys.com > Research > Working Papers

% Code by A. Meucci, September 2008
% Last version available at www.symmys.com > Teaching > MATLAB

clear; clc; close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prior
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% analytical representation
N=2; % market dimension
Mu=zeros(N,1);
r=.6;
Sigma=(1-r)*eye(N)+r*ones(N,N);

% numerical representation
J=100000;
p = ones(J,1)/J;
dd = mvnrnd(zeros(N,1),Sigma,J/2);
X=ones(J,1)*Mu'+[dd;-dd];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% views
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% location
Q=[1 -1];
Mu_Q=.5;

% scatter
G=[-1 1];
Sigma_G=.5^2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  posterior 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% analytical posterior
[Mu_, Sigma_]=Prior2Posterior(Mu,Q,Mu_Q,Sigma,G,Sigma_G);

% numerical posterior
Aeq = ones(1,J);  % constrain probabilities to sum to one...
beq=1;

QX = X*Q';
Aeq = [Aeq   % ...constrain the first moments...
    QX'];
beq=[beq
    Mu_Q];

SecMom=G*Mu_*Mu_'*G'+Sigma_G;  % ...constrain the second moments...
GX = X*G';
for k=1:size(G,1)
    for l=k:size(G,1)
        Aeq = [Aeq
            (GX(:,k).*GX(:,l))'];
        beq=[beq
            SecMom(k,l)];
    end
end
tic
p_ = EntropyProg(p,[],[],Aeq ,beq); % ...compute posterior probabilities
toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PlotDistributions(X,p,Mu,Sigma,p_,Mu_,Sigma_)
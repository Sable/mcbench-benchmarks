% this script verifies the correctness of the eigenvalue-eigenvector representation in terms of real matrices 
% for the transition matrix of an OU process discussed in 

% A. Meucci (2009) 
% "Review of Statistical Arbitrage, Cointegration, and Multivariate Ornstein-Uhlenbeck"
% available at ssrn.com

% Code by A. Meucci, April 2009
% Most recent version available at www.symmys.com > Teaching > MATLAB

clear; clc; close all

N=5;
Theta=rand(N)

[B,L]=eig(Theta);

A=real(B)-imag(B);


Index_j=find(imag(diag(L)));

G=L;
for s=1:2:(length(Index_j))
    G(Index_j(s:s+1),Index_j(s:s+1))=[1 0;0 1]*real(L(Index_j(s),Index_j(s)))+...
        [0 1;-1 0]*imag(L(Index_j(s),Index_j(s)));
end
Theta_=A*G*inv(A)


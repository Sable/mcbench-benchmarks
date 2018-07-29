function [M,K,C,P,phi]= ModalAnalysis(M,K,C,P,lambda)
% Modal Analysis of the System 
%-------------------------------------------------------------------------
% Code written by :Siva Srinivas Kolukula                                 |
%                  Senior Research Fellow                                 |
%                  Structural Mechanics Laboratory                        |
%                  Indira Gandhi Center for Atomic Research               |
%                  INDIA                                                  |
% E-mail : allwayzitzme@gmail.com                                         |
%-------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Purpose : To do the Modal Analysis of the system
%
% Synopsis : [M,K,C,P] = ModalAnalysis(M,K,C,P,lambda]
%
% Variable Description :
%           M - Mass Matrix
%           K - Stiffness Matrix
%           C - Damping Matrix
%           P - Force MAtrix
%           lambda - number of modes to be considered
%           phi - Reduced Normal modes of the system
%--------------------------------------------------------------------------

 % Modal Analysis 
[V,D]=eig(K,M);
[W,k]=sort(diag(D));
V=V(:,k); 
Factor=diag(V'*M*V);
Phi=V*inv(sqrt(diag(Factor)));
Omega=diag(sqrt(Phi'*K*Phi)); 

% selecting only first two Natural Frequencies and Mode shapes
w = diag(Omega(1:lambda)) ;
phi = Phi(:,1:lambda) ;

% Reducing the Degree's of Freedom of M, K and P
M = phi'*M*phi ;
C = phi'*C*phi ;
K = phi'*K*phi ;
P = phi'*P ;
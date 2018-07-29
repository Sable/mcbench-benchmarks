function [Xk_1,pk_1]=klm(Xbk_1,pk,yk,hk,f_unk,Fi,C,G_un,R,Q,k)

%Kalman estimator 

% State equation dX/dt=A*X+B_un*f_un
% ¹Û²â·½³Ç  Y=C*X+G_kn*force

k_1=Fi*pk*C'*inv(C*pk*C'+R);

% Recusive solution for state vetor  

Xk_1=Xbk_1+k_1*(yk-hk-G_un*f_unk);

% Estimate pk_1: A matrix with dimension 2nx2n 
pk_1=Fi*pk*Fi'+Q-k_1*C*pk*Fi';



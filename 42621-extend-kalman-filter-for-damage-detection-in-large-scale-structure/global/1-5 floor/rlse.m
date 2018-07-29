function [f_unk_1]=rlse(yk_1,hk_1,G_un,rk)           
                                                                                
% Estimate sk_1: A matrix with dimension rxr 
Sk_1=inv(G_un'*inv(rk)*G_un);

% Recusive solution for unknown excitation
f_unk_1=Sk_1*G_un'*inv(rk)*(yk_1-hk_1);

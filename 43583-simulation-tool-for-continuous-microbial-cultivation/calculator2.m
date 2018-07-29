function [X,S] = calculator2(D)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global K_S S_0 mu_max Y_XS

X = Y_XS ./ 3 .* (S_0 - D .* K_S ./ (mu_max - D));

S = D .* K_S ./ (mu_max - D);

end
% Bezier parameters
% Copyright by Nguyen Quoc Duan - EMMC11

% Purpose : to compute the parameter terms in Bezier curves
% n : the polynomial degree of Bezier curve

function B_para=B_para(i,n,t)
B_para=(1-t)^(n-i)*t^i;

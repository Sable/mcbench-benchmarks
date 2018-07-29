% combination coefficient function 
% Copyright by Nguyen Quoc Duan - EMMC11

% Purpose : to compute the coefficients in Newton expansion
%           these coefficients also occur in Bezier curves equations
% Conditions: i,n are natural numbers and 0<=i<=n

function C=C(i,n)
C=factorial(n)/(factorial(i)*factorial(n-i));
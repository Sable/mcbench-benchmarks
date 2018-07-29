%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

% This function compute the coefficients
% for the 3th oder polynomial given the 4 coefficients
%  qk   initial joint position
%  qk1  final joint position
%  dotqk initial joint speed
%  dotqk1 final joint speed
%  tk=initial time and tk1=final time
%  The solution is given by a linear system
% output: polynomial coefficients
function  x=pol3interpol(tk,tk1,qk,qk1,dotqk,dotqk1)

A=[1,tk,tk^2,tk^3;
    1,tk1,tk1^2,tk1^3;
    0,1,2*tk,3*tk^2;
    0,1,2*tk1,3*tk1^2];

C=[qk,qk1,dotqk,dotqk1]';

x=inv(A)*C;

% a0=x(1);
% a1=x(2);
% a2=x(3);
% a3=x(4);


end
function logistic
% Logistic growth     
%    using MATLAB for analytical solution                   
%
%   $Ekkehard Holzbecher  $Date: 2006/04/20 $
%--------------------------------------------------------------------------
T = 10;                  % maximum time
r = 1;                   % rate 
kappa = 1;               % capacity
c0 = 0.01;               % initial value

%----------------------execution-------------------------------------------

t = linspace (0,T,100);
e = exp(r*t);
c = c0*kappa*e./(kappa+c0*(e-1));

%---------------------- graphical output ----------------------------------

plot (t,c); grid;
xlabel ('time'); legend ('population');
title ('logistic growth');


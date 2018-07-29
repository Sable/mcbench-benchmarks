% Chapter 12 - Bifurcations of Nonlinear Systems in the Plane.
% Programs_12c - Hopf Bifurcation.
% Copyright Birkhauser 2013. Stephen Lynch.

% Animation of Hopf bifurcation of a limit cycle from the origin.
% NOTE: Run Programs_12d NOT Programs_12c.


function sys=Programs_12c(~,x)
global mu
X=x(1,:);  
Y=x(2,:);  

% Define the system.
P=Y+mu*X-X.*Y.^2;        
Q=mu*Y-X-Y.^3; 

sys=[P;Q]; 
% End of Programs_12c.


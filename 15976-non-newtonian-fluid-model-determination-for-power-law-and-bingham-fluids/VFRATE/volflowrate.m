% Author: Housam Binous

% Non-Newtonian Fluid Model Determination (for power law fluid)

% National Institute of Applied Sciences and Technology, Tunis, TUNISIA

% Email: binoushousam@yahoo.com

function Q=volflowrate(x)

dPg=x(1);
n=x(2);
kappa=x(3);

R=0.01;

% expression of volumetric flow rate for power law fluid

Q=2^(-1/n)*pi*R^3*n/(1+3*n)*(R*dPg/kappa)^(1/n);

end

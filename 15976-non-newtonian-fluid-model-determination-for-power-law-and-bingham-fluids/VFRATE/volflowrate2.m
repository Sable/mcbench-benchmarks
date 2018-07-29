% Author: Housam Binous

% Non-Newtonian Fluid Model Determination (for Bingham fluid)

% National Institute of Applied Sciences and Technology, Tunis, TUNISIA

% Email: binoushousam@yahoo.com

function Q=volflowrate(x)

dPg=x(1);
tau0=x(2);
nu=x(3);

R=0.01;

% expression of volumetric flow rate for Bingham fluid

Q=pi*R^4*dPg/(8*nu)-pi*R^3*tau0/(3*nu)+2*pi*tau0^4*dPg^-3/(3*nu);

end

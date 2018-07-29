% Power utility function u(c)=c^(1-gamma)/(1-gamma) if gamma ~= 1; 
% u(c)=ln(c) if gamma=1. 

% Utility is only defined if c>=0 for gamma<1 and c>0 if gamma>1

% The risk aversion coefficient is pass on to the function by
% define it as a global variable. 


function u=util(c)

global gamma;
u=-inf*ones(size(c)); % initialize into -inf, change only those c positive
cpos=find(c>0);       % find those positive c

if gamma==1 
    u(cpos)=log(c(cpos));
else
    u(cpos)=c(cpos).^(1-gamma)./(1-gamma);
end

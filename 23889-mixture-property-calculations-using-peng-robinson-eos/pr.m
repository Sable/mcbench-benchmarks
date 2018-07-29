% Peng-Robinson EoS computation and property calculations
% Inputs:
% z   = number of moles of all species (n x 1 column vector) [mol]
% p   = pressure [Pa]
% T   = temperature [K]
% pc  = critical pressure of all components (n x 1 column vector)[Pa]
% Tc  = critical temperature of all components (n x 1 column vector)[K]
% w   = acentric factor of all components (n x 1 column vector)
% k   = binary parameters (n x n symmetric matrix)
% cp  = ideal gas heat capacity coefficients (n x m symmetric matrix) [J/mol-K]
% DHf = standard enthalpy of formation for ideal gas (298.15 K and 1 atm) (n x 1 column vector) [J/mol]
% ph  = phase (L or V)
% Outputs:
% V   = molar volume [m3/mol]
% Z   = compressibility factor
% phi = fugacity coefficient
% H   = enthalpy [J/mol]
function [V,Z,phi,H] = pr(z,p,T,pc,Tc,w,k,cpig,DHf,ph)

R  = 8.314; % m3 Pa/(mol K) = J/mol-K
Tr = 298.15; % K
e  = 1 - sqrt(2);
s  = 1 + sqrt(2);

m    =  0.37464 + 1.54226*w - 0.26992*w.^2;
alfa =  (1 + m.*(1 - (T./Tc).^0.5)).^2;
ai   =  0.45724*(R^2)*(Tc.^2)./pc.*alfa;
bi   =  0.07780*R*Tc./pc;
Q    =  ((ai*ai').^0.5).*(1 - k);
a    =  z'*Q*z;
b    =  z'*bi;
dQdT =  0.45724*(R^2)*(k - 1).*(Tc*Tc')./((pc*pc').^0.5).*(1/(2*T^0.5)).*...
    ((m./(Tc.^0.5))*(alfa.^0.5)' + (alfa.^0.5)*(m./(Tc.^0.5))');
dadT = z'*(Q - T*dQdT)*z;

% Coefficients of the EoS model equation
c(1) =  1;
c(2) =  b - R*T/p;
c(3) =  -3*b^2 - 2*R*T/p*b + a/p;
c(4) =  b^3 + R*T/p*b^2 - a*b/p;

% Roots
r    = roots(c);
if upper(ph) == 'L'
    V = min(r);
else
    V = max(r);
end

Z = p*V/(R*T);

abar = (2*z'*Q - a*ones(1,length(z)))'; bbar = bi;
phi  = exp((Z - 1)*bbar/b - log((V - b)*Z/V) + (a/(b*R*T))/(e - s)*log((V + s*b)/(V + e*b))*...
    (1 + abar/a - bbar/b));

HR  = R*T*(Z - 1) - dadT/(2*(s - 1)*b)*log((V + s*b)/(V + e*b));
Hig = z'*(DHf + cpig(:,1)*(T - Tr) + cpig(:,2).*cpig(:,3).*(coth(cpig(:,3)/T) - coth(cpig(:,3)/Tr)) ...
    + cpig(:,4).*cpig(:,5).*(coth(cpig(:,5)/T) - coth(cpig(:,5)/Tr)));
H   = Hig + HR;


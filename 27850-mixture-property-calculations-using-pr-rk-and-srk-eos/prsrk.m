% EoS computation and property calculations
% The (generalized) equation of state is of the form:
% p = RT/(V - b) - a(T)/[(V + epsi*b)*(V + sigm*b)]

% Inputs:
% z    = number of moles of all species (n x 1 column vector) [mol]
% p    = pressure [Pa]
% T    = temperature [K]
% pc   = critical pressure of all components (n x 1 column vector)[Pa]
% Tc   = critical temperature of all components (n x 1 column vector)[K]
% w    = acentric factor of all components (n x 1 column vector)
% k    = binary parameters (n x n symmetric matrix)
% cpig = ideal gas heat capacity coefficients (n x m symmetric matrix) [property unit in cal/mol-K]
% DHf  = standard enthalpy of formation for ideal gas (298.15 K and 1 atm) (n x 1 column vector) [J/mol]
% DGf  = standard Gibbs energy of formation for ideal gas (298.15 K and 1 atm) (n x 1 column vector) [J/mol]
% ph   = phase ('L' or 'V')
% flag = chosen EoS ('PR', 'SRK', or 'RK')
% Outputs:
% rho  = molar density [mol/m3]
% Z    = compressibility factor
% phi  = fugacity coefficient
% A    = Helmholtz energy [J/mol]
% S    = entropy [J/(mol K)]
% H    = enthalpy [J/mol]
% U    = internal eenergy [J/mol]
% G    = Gibbs energy [J/mol]

function [rho,Z,phi,A,S,H,U,G] = prsrk(z,p,T,pc,Tc,w,k,cpig,DHf,DGf,ph,flag)

z    = z(:); % z is always a column vector
R    = 8.314; % m3 Pa/(mol K) = J/mol-K
Tref = 298.15; % K (reference temperature)
Pref = 1e5; % Pa (reference pressure)
DSf  = 1/T*(DHf - DGf); % standard entropy of formation [J/mol-K]. Calculated at the given temperature, not the reference temperature.

switch flag
    case{'PR'}
        epsi = 1 - sqrt(2);
        sigm = 1 + sqrt(2);
        omeg = 0.07780;
        psi  = 0.45724;
        mi   = [0.37464 1.54226 0.26992];
        m    = [ones(length(w),1) w -w.^2]*mi';
    case{'SRK'}
        epsi = 0;
        sigm = 1;
        omeg = 0.08664;
        psi  = 0.42748;
        mi   = [0.480 1.574 0.176];
        m    = [ones(length(w),1) w -w.^2]*mi';
    case{'RK'}
        epsi = 0;
        sigm = 1;
        omeg = 0.08664;
        psi  = 0.42748;
        m    = ((T./Tc).^(-1/4) - 1)./(1 - (T./Tc).^0.5);
end

alfa =  (1 + m.*(1 - (T./Tc).^0.5)).^2;
ai   =  psi*(R^2)*(Tc.^2)./pc.*alfa;
bi   =  omeg*R*Tc./pc;
Q    =  ((ai*ai').^0.5).*(1 - k);
a    =  z'*Q*z;
b    =  z'*bi;
dQdT =  psi*(R^2)*(k - 1).*(Tc*Tc')./((pc*pc').^0.5).*(1/(2*T^0.5)).*...
    ((m./(Tc.^0.5))*(alfa.^0.5)' + (alfa.^0.5)*(m./(Tc.^0.5))');
dadT = z'*dQdT*z;

% Coefficients of the EoS model equation
c(1) =  1;
c(2) =  (epsi + sigm - 1)*b - R*T/p;
c(3) =  (epsi*sigm - (epsi + sigm))*b^2 - R*T*(epsi + sigm)/p*b + a/p;
c(4) =  -epsi*sigm*b^3 - R*T*epsi*sigm/p*b^2 - a*b/p;

% Roots
r = roots(c); %ir = imag(r); r(ir<1e-8) = real(r(ir<1e-10));
for i = 1:length(r), index(i) = isreal(r(i)); end
r = r(index);
if upper(ph) == 'L'
    V = min(r);
else
    V = max(r);
end
rho = 1/V;
Z   = p*V/(R*T);

u   = epsi + sigm;
v   = epsi*sigm;
Bs  = b*p/(R*T);
AR  = a/(b*(sqrt(u^2 - 4*v)))*log((2*Z + Bs*(u - sqrt(u^2 - 4*v)))/(2*Z + Bs*(u + sqrt(u^2 - 4*v)))) - ...
    R*T*log((Z - Bs)/Z) - R*T*log(V/(R*T/p));
SR  = R*log((Z - Bs)/Z) + R*log(V/(R*T/p)) - 1/(b*(sqrt(u^2 - 4*v)))*dadT*...
    log((2*Z + Bs*(u - sqrt(u^2 - 4*v)))/(2*Z + Bs*(u + sqrt(u^2 - 4*v))));
HR  = AR + T*SR + R*T*(Z - 1);

% From Aly, F. A. and Lee, L. L., "Self-Consistent Equations for
% Calculating the Ideal Gas Heat Capacity, Enthalpy, and Entropy",
% Fluid Phase Equilibria, Vol. 6, 1981, p. 169, we have:
% Cp = C1 + C2*((C3/T)/sinh(C3/T))^2 + C4*((C5/T)/cosh(C5/T))^2.
% But:
% Hig = z'*(DHf + (int(Cp,T,Tref,T)*4.184)).
% Sig = z'*(DSf + (int(Cp/T,T,Tref,T)*4.184) - R*ln(P/Pref)) - R*z'*ln(z).
iHig = 4.184*(cpig(:,1)*(T - Tref) + 2*cpig(:,2).*cpig(:,3).*(1./(exp(2*cpig(:,3)/T) - 1) - 1./(exp(2*cpig(:,3)/Tref) - 1)) ...
     + 2*cpig(:,4).*cpig(:,5).*(1./(exp(2*cpig(:,5)/T) + 1) - 1./(exp(2*cpig(:,5)/Tref) + 1)));
iSig = 4.184*(cpig(:,1)*log(T/Tref) - cpig(:,2).*log((exp(2*cpig(:,3)/T) - 1)./((exp(2*cpig(:,3)/Tref) - 1))) ...
     + cpig(:,4).*log((exp(2*cpig(:,5)/T) + 1)./((exp(2*cpig(:,5)/Tref) + 1))) + 2*(cpig(:,2).*cpig(:,3) - cpig(:,4).*cpig(:,5))*(1/T - 1/Tref) ...
     + 2*cpig(:,2).*cpig(:,3).*(1./(T*(exp(2*cpig(:,3)/T) - 1)) - 1./(Tref*(exp(2*cpig(:,3)/Tref) - 1))) ... 
     + 2*cpig(:,4).*cpig(:,5).*(1./(T*(exp(2*cpig(:,5)/T) - 1)) - 1./(Tref*(exp(2*cpig(:,5)/Tref) - 1))));
Hig  = z'*(DHf + iHig);
Sig  = z'*(DSf + iSig - R*log(p/Pref)) - R*z'*log(z);
abar = (2*z'*Q - a*ones(1,length(z)))'; bbar = bi;
phi  = exp((Z - 1)*bbar/b - log((V - b)*Z/V) + (a/(b*R*T))/(epsi - sigm)*log((V + sigm*b)/(V + epsi*b))*...
     (1 + abar/a - bbar/b));

H   = Hig + HR;
S   = Sig + SR;
U   = H - p*V;
A   = U - T*S;
G   = H - T*S;


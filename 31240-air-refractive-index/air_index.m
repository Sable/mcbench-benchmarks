function nr = air_index(wavelength,temperature,pressure,humidity,method,xCO2)
%AIR_INDEX Computes real index of refraction of air given
% wavelength, temperature, pressure, humidity and CO2 concentration

% Real index of refraction is computed using the algorithms
% available at http://emtoolbox.nist.gov/Main/Main.asp
% Two methods can be specified: 'Ciddor' (newer)
% or 'Edlen' (older). The function is vectorized in
% temperature, pressure and humidity

% 'wavelength' is the wavelength in nanometers
% 'temperature' is the temperature in degrees Celsius
% 'pressure' is the pressure in kiloPascal
% 'humidity' is the percent humidity
% 'method' is a string indicating the method: 'edlen' or 'ciddor'
% 'xCO2' is the CO2 concentration in ppm

% Written by John A. Smith, CIRES, University of Colorado at Boulder

[x1 x2 x3]=meshgrid(temperature,1000*pressure,humidity);

S=1e6/wavelength^2;
T=x1+273.15;

% IAPWS
K1=1.16705214528e3;
K2=-7.24213167032e5;
K3=-1.70738469401e1;
K4=1.20208247025e4;
K5=-3.23255503223e6;
K6=1.49151086135e1;
K7=-4.82326573616e3;
K8=4.05113405421e5;
K9=-2.38555575678e-1;
K10=6.50175348448e2;
Omega=T+K9./(T-K10);
A=Omega.^2+K1*Omega+K2;
B=K3*Omega.^2+K4*Omega+K5;
C=K6*Omega.^2+K7*Omega+K8;
X=-B+sqrt(B.^2-4*A.*C);
psv1=1e6*(2*C./X).^4;

% Over Ice
A1=-13.928169;
A2=34.7078238;
Theta=T/273.16;
Y=A1*(1-Theta.^-1.5)+A2*(1-Theta.^-1.25);
psv2=611.657*exp(Y);

psv=psv1.*(x1>=0)+psv2.*(x1<0);
pv=(x3/100).*psv;

if strcmp(method,'ciddor')

% Convert humidity to mole fraction for Ciddor
alpha=1.00062;
beta=3.14e-8;
gamma=5.60e-7;
fpt=alpha+beta*x2+gamma*x1.^2;
xv=(x3/100).*fpt.*psv./x2;

% Ciddor Equation
w0=295.235;w1=2.6422;w2=-0.03238;w3=0.004028;
k0=238.0185;k1=5792105;k2=57.362;k3=167917;
a0=1.58123e-6;a1=-2.9331e-8;a2=1.1043e-10;
b0=5.707e-6;b1=-2.051e-8;
c0=1.9898e-4;c1=-2.376e-6;
d=1.83e-11;e=-0.765e-8;
pR1=101325;TR1=288.15;
Za=0.9995922115;
rhovs=0.00985938;
R=8.314472;Mv=0.018015;
ras=1e-8*(k1/(k0-S)+k3/(k2-S));
rvs=1.022e-8*(w0+w1*S+w2*S^2+w3*S^3);
Ma=0.0289635+1.2011e-8*(xCO2-400);
raxs=ras*(1+5.34e-7*(xCO2-450));
Zm=1-(x2./T).*(a0+a1*x1+a2*x1.^2+(b0+b1*x1).*xv+ ... 
    (c0+c1*x1).*xv.^2)+(x2./T).^2.*(d+e*xv.^2);
rhoaxs=pR1*Ma/(Za*R*TR1);
rhov=xv.*x2.*Mv./(Zm*R.*T);
rhoa=(1-xv).*x2.*Ma./(Zm*R.*T);
nr=1+(rhoa./rhoaxs)*raxs+(rhov/rhovs)*rvs;
else
    
% Modified Edlen Equation
A=8342.54;B=2406147;
C=15998;D=96095.43;
E=0.601;F=0.00972;G=0.003661;
ns=1+1e-8*(A+B/(130-S)+C/(38.9-S));
X=(1+1e-8*(E-F*x1).*x2)./(1+G*x1);
ntp=1+x2*(ns-1).*X/D;
nr=ntp-1e-10*(292.75./T)*(3.7345-0.0401*S).*pv;
end

end
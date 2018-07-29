function y= DAB(T,P,MA,MB,sigmA,sigmB,epsA,epsB)
%DAB Calculates gas-phase diffusivity using Wilke-Lee equation, p. 17 Text.
%   DAB(T,P,MA,MB,sigmA,sigmB,epsA,epsB)
%   T = absolute temperature in K
%   P = pressure in bar
%   MA, MB = molecular weights
%   sigmA, sigmB, epsA, epsB = Lennard-Jones parameters
%   in Angstroms and Kelvin, respectively
%   DAB = diffusivity in square cm/sec.
sigmAB=(sigmA+sigmB)/2;
epsAB=sqrt(epsA*epsB);
x=T/epsAB;
a=1.06036;b=0.15610;c=0.19300;d=0.47635;
e1=1.03587;f=1.52996;g=1.76474;h=3.89411;
MAB=2*(1/MA+1/MB)^-1;
omega=a/x^b+c/exp(d*x)+e1/exp(f*x)+g/exp(h*x);
y=0.001*(3.03-0.98/sqrt(MAB))*T^1.5/(P*sigmAB^2*omega*sqrt(MAB));
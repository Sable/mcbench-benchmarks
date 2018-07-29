%Charge Neutrality Equation
%Assuming that the material contains only one type of dopant
%ND (Donor)
function F = neutral(Nv,Nc,ND,Ev,Ec,Ed,Ef,k,T,gD)
F = Nv*((exp(-((Ev-Ef)/(k*T)))+3*sqrt(pi/2)*((((Ev-Ef)/(k*T))+2.13)+((abs(((Ev-Ef)/(k*T))-2.13)).^2.4+9.6).^(5/12)).^(-3/2)).^-1)-Nc*((exp(-((Ef-Ec)/(k*T)))+3*sqrt(pi/2)*((((Ef-Ec)/(k*T))+2.13)+((abs(((Ef-Ec)/(k*T))-2.13)).^2.4+9.6).^(5/12)).^(-3/2)).^-1)+(ND/(1+gD*exp((Ef-Ed)/(k*T))));
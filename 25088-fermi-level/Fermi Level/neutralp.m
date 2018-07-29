%Charge Neutrality Equation
%Assuming that the material contains only one type of dopant
%NA (Acceptor)
function F = neutralp(Nv,Nc,NA,Ev,Ec,Ea,Efp,k,T,gA)
F = Nv*((exp(-((Ev-Efp)/(k*T)))+3*sqrt(pi/2)*((((Ev-Efp)/(k*T))+2.13)+((abs(((Ev-Efp)/(k*T))-2.13)).^2.4+9.6).^(5/12)).^(-3/2)).^-1)-Nc*((exp(-((Efp-Ec)/(k*T)))+3*sqrt(pi/2)*((((Efp-Ec)/(k*T))+2.13)+((abs(((Efp-Ec)/(k*T))-2.13)).^2.4+9.6).^(5/12)).^(-3/2)).^-1)-(NA/(1+gA*exp((Ea-Efp)/(k*T))));
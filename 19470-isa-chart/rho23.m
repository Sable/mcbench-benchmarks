function rho23=rho23(h)
sldata;
limitpoints;
slopes;
rho2=rho1*(T2/T1)^-(1+(g/(m12*R)));
rho23=rho2*exp(-g*(h-h2)/(R*T2));
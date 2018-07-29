function rho34=rho34(h)
sldata;
limitpoints;
slopes;
rho2=rho1*(T2/T1)^-(1+(g/(m12*R)));
rho3=rho2*exp(-g*(h3-h2)/(R*T2));
rho34=rho3*(T34(h)/T3)^-(1+(g/(m34*R)));
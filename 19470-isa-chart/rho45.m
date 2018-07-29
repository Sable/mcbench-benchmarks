function rho45=rho45(h)
sldata;
limitpoints;
slopes;
rho2=rho1*(T2/T1)^-(1+(g/(m12*R)));
rho3=rho2*exp(-g*(h3-h2)/(R*T2));
rho4=rho3*(T4/T3)^-(1+(g/(m34*R)));
rho45=rho4*(T45(h)/T4)^-(1+(g/(m45*R)));
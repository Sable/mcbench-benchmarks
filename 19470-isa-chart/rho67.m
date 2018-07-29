function rho67=rho67(h)
sldata;
limitpoints;
slopes;
rho2=rho1*(T2/T1)^-(1+(g/(m12*R)));
rho3=rho2*exp(-g*(h3-h2)/(R*T2));
rho4=rho3*(T4/T3)^-(1+(g/(m34*R)));
rho5=rho4*(T5/T4)^-(1+(g/(m45*R)));
rho6=rho5*exp(-g*(h6-h5)/(R*T5));
rho67=rho6*(T67(h)/T6)^-(1+(g/(m67*R)));
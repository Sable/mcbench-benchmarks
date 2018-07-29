function p67=p67(h)
sldata;
limitpoints;
slopes;
T67=-1.96e-3*h+373.2
p2=p1*(T2/T1)^(-g/(m12*R));
p3=p2*exp(-g*(h3-h2)/(R*T2));
p4=p3*(T4/T3)^(-g/(m34*R));
p5=p4*(T5/T4)^(-g/(m45*R));
p6=p5*exp(-g*(h6-h5)/(R*T5));
p67=p6*(T67/T6)^(-g/(m67*R));
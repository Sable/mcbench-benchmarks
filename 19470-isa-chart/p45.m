function p45=p45(h)
sldata;
limitpoints;
slopes;
T45=2.78e-3*h+139.1;
p2=p1*(T2/T1)^(-g/(m12*R));
p3=p2*exp(-g*(h3-h2)/(R*T2));
p4=p3*(T4/T3)^(-g/(m34*R));
p45=p4*(T45/T4)^(-g/(m45*R));
function p56=p56(h)
sldata;
limitpoints;
slopes;
T56=270.5;
p2=p1*(T2/T1)^(-g/(m12*R));
p3=p2*exp(-g*(h3-h2)/(R*T2));
p4=p3*(T4/T3)^(-g/(m34*R));
p5=p4*(T5/T4)^(-g/(m45*R));
p56=p5*exp(-g*(h-h5)/(R*T5));
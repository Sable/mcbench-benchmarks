function p34=p34(h)
sldata;
limitpoints;
slopes;
p2=p1*(T2/T1)^(-g/(m12*R));
p3=p2*exp(-g*(h3-h2)/(R*T2));
T34=9.92e-4*h+196.56;
p34=p3*(T34/T3)^(-g/(m34*R));
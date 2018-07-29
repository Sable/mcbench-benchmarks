function dxdt=ideal(t,x)
% Here you define your differential equation 
% dxdt=your outputs, as initialized with zero array,
dxdt=zeros(2,1);

k=0.5;
u=-k*x(1);
% the differential eq is 
%   x1dot=x2;
%   x2dot=u
% which can formulized as follows for the solver
dxdt(1)=x(2);
dxdt(2)=u;
% Quadratic equation function
%  determines coefficients of ax^2 + bx + c
%  input x,y arrays
%  by: Dr. Sherif Omran
%
%
function [a,b,c]=Quadratic(x,y)

p1=x(2)-x(3);
p2=x(3)-x(1);
p3=x(1)-x(2);
p4=x(3)^2-x(2)^2;
p5=x(1)^2-x(3)^2;
p6=x(2)^2-x(1)^2;
p7=x(2)^2*x(3)-x(2)*x(3)^2;
p8=x(1)*x(3)^2-x(1)^2*x(3);
p9=x(1)^2*x(2)-x(1)*x(2)^2;

delta=x(1)^2*(x(2)-x(3))-x(1)*(x(2)^2-x(3)^2)+1*(x(2)^2*x(3)-x(2)*x(3)^2);

a=(1/delta)*((x(2)-x(3))*y(1)+(x(3)-x(1))*y(2)+(x(1)-x(2))*y(3));
b=(1/delta)*(p4*y(1)+p5*y(2)+p6*y(3));
c=(1/delta)*(p7*y(1)+p8*y(2)+p9*y(3));

return;
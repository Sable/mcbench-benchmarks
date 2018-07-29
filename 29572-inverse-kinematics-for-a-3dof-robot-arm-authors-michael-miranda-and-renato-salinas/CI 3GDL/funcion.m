x0 = [1 1 1 1];
l1 = 30; 
l2 = 20;
l3 = 10;
Px3 = 40;
Py3 = 20;

[x,fval] = fsolve(@funopt,x0);  % Call solver

hipotenusa = (x(3)^2 + x(4)^2)^(1/2);

theta2 = acosd((-hipotenusa^2 + l1^2 + l2^2)/(2*l1*l2))

theta3 = asind((sind(theta2)/hipotenusa)*l1)+180

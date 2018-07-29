function answer = calculate_matrix(x)

x1 = x(1);                          % 1st state variable
x2 = x(2);                          % 2nd state variable
x3 = x(3);                          % 1st co-state variable
x4 = x(4);                          % 2nd co-state variable

a1 = exp(25*x1/(x1+2));
a2 = 100*(x2+0.5)*(23-x1)*a1/(x1+2)^4;
a3 = 50*a1/(x1+2)^2;
a4 = (x2+0.5)*a3;
a5 = x1+0.25;
a6 = x4-x3;

answer = [-2-10*x3*a5+a4 a1 -5*a5^2 0;-1*a4 -1-a1 0 0;-2+a2*a6+5*x3^2 a3*a6 2+10*x3*a5-a4 a4; a3*a6 -2 -1*a1 1+a1];
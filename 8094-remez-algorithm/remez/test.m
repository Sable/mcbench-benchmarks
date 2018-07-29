% By Sherif A. Tawfik, Faculty of Engineering, Cairo University
%Testing Script%
% Example 1
fun=inline('exp(x)');
fun_der= inline('exp(x)');
interval=[0, 2^(-10)];
order =2;

A= remez(fun, fun_der, interval, order);

A1=A(1:end-1);  % the 3 coefficients of the second order polynomial
E=A(end); % the maximum approximation error 

% plotting the error of the whole interval
x=0: 2^-15:2^-10 ;
e=err(x,fun, A1, interval(1)); 
plot(x,e)
xlabel('x')
ylabel('e(x)=f(x)-p(x)')
title('Error function for when approximating exp(x)')

% Example 2
fun=inline('sin(x)');
fun_der= inline('cos(x)');
interval=[0, 2^(-10)];
order =2;

A= remez(fun, fun_der, interval, order);

A1=A(1:end-1);  % the 3 coefficients of the second order polynomial
E=A(end); % the maximum approximation error 

% plotting the error of the whole interval
x=0: 2^-15:2^-10 ;
e=err(x,fun, A1, interval(1)); 
figure;
plot(x,e)
xlabel('x')
ylabel('e(x)=f(x)-p(x)')
title('Error function for when approximating sin(x)')

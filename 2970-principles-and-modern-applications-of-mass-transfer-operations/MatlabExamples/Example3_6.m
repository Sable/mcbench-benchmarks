function y = Example3_6
% Example 3.6, p.139 Text
% Uses the function fsolve from the Optimization Toolbox
% and the M-function example3_6 supplied by the user
% X(1) refers to x1 
% X(2) refers to x2 
% X(3) refers to y1 
% X(4) refers to y2 
% X(5) refers to T (temperature in K)
[X]=fsolve(@example3_6,[0.1 0.9 0.2 0.8 360],optimset('fsolve'));
format compact;
x1=X(1)
x2=X(2)
y1=X(3)
y2=X(4)
T=X(5)

function F = example3_6(x)
P=101.3;
F(1)=1-x(1)-x(2);
F(2)=1-x(3)-x(4);
F(3)=5.155-4.795*(4.955/(5.155-x(1)))^8.765-x(3);
F(4)=x(1)*gam1(x(1),x(2),x(5))*psat1(x(5))/P-x(3);
F(5)=x(2)*gam2(x(1),x(2),x(5))*psat2(x(5))/P-x(4);


function y = gam1(x1,x2,T)

y=exp(-log(x1+x2*delta12(T))+x2*(delta12(T)/(x1+x2*delta12(T))...
    -delta21(T)/(x2+x1*delta21(T))));


function y = gam2(x1,x2,T)

y=exp(-log(x2+x1*delta21(T))-x1*(delta12(T)/(x1+x2*delta12(T))...
    -delta21(T)/(x2+x1*delta21(T))));


function y = delta12(T)
a12=107.38;
a21=469.55;
v1=40.73;
v2=18.07;
R=1.987;
y=(v2/v1)*exp(-a12/(R*T));

function y = delta21(T)
a12=107.38;
a21=469.55;
v1=40.73;
v2=18.07;
R=1.987;
y=(v1/v2)*exp(-a21/(R*T));


function y = psat1(T)
y=exp(16.5938-3644.3/(T-33));


function y = psat2(T)
y=exp(16.2620-3800.0/(T-47));

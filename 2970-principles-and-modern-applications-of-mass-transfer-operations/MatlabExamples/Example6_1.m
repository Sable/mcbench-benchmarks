function y = Example6_1
% Example 6.1, p.295 Text
% Uses the function fsolve from the Optimization Toolbox
% and the M-function example6_1 supplied by the user
% X(1) refers to temperature 
% X(2) refers to vapor composition, yD 
% X(3) refers to liquid composition, xW 

[X]=fsolve(@example6_1,[320 0.7 0.3],optimset('fsolve'));
format compact;
T=X(1)
yD=X(2)
xW=X(3)

function F = example6_1(x)
D=0.6;
W=1-D;
P=1.013;
zF=0.5;
F(1)=W/D+(x(2)-zF)/(x(3)-zF);
F(2)=x(2)-mA(x(1),P)*x(3);
F(3)=x(2)-1+mB(x(1),P)*(1-x(3));


function y = mA(T,P)

y=PA(T)/P;


function y = mB(T,P)

y=PB(T)/P;


function y = PA(T)
TC=540.3; PC=27.4;
A=-7.675;  B=1.371;  C=-3.536;  D=-3.202;
r=1-T/TC;
y=PC*exp((A*r+B*r^1.5+C*r^3+D*r^6)/(1-r));

function y = PB(T)
TC=568.8; PC=24.9;
A=-7.912;  B=1.380;  C=-3.804;  D=-4.501;
r=1-T/TC;
y=PC*exp((A*r+B*r^1.5+C*r^3+D*r^6)/(1-r));


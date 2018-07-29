function Example5_6
% Example 5.6 Packed-Tower for Adiabatic Ammonia Absorbtion, p.273 Text .
% Uses the function fsolve from the Optimization Toolbox
% and the M-function example5_6 supplied by the user.  

[X]=fsolve(@example5_6,[0.2 0.2],optimset('fsolve'));
xAi=X(1)
yAi=X(2)

function F = example5_6(x)
psiA=1.32;
FL=0.0169;
FGA=0.001752;
xA=0.0491;
yA=0.416;
TT=[289 294 306 317 322];  %Temperature levels;
xx=[0 0.05 .10 .15 .20];  %Levels of ammonia mole fraction in liquid;
yy=[0 0.042 0.081 0.136 0.218
   0 0.056 0.103 0.177 0.291
   0 0.093 0.171 0.289 0.468
   0 0.146 0.272 0.452 0.724
   0 0.182 0.337 0.559 0.890];  %Gas-phase ammonia mole fraction data;
F(1)=x(2)-psiA+(psiA-yA)*((psiA-xA)/(psiA-x(1)))^(FL/FGA);
F(2)=x(2)-interp2(TT,xx,yy,314.6,x(1),'spline');

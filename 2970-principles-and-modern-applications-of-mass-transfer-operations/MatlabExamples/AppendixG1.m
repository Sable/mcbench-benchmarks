function AppendixG1
% Appendix G-1. Single-Stage Extraction, page 480 Text .
% Uses the function fsolve from the Optimization Toolbox
% and the M-function appendixG_1 supplied by the user.
% Data are from Example 7.2, p.393 Text.

[X]=fsolve(@appendixG_1,[50 50 0.1],optimset('fsolve'));
E=X(1)
R=X(2)
xCR=X(3)

function F = appendixG_1(x)
FF=50; S=50; xCF=0.60; xBF=0.0; yCS=0.0; yBS=1.0;
vxC=[0.158 0.256 0.360 0.493 0.557 0.596];  %Acetone in water phase;
vxB=[.0123 .0129 .0171 .0510 .0980 .1690];  %Chloroform in water phase;
vyC=[0.287 0.421 0.527 0.613];  %Acetone in chloroform phase;
vyB=[0.700 0.557 0.429 0.284];  %Chloroform in chloroform phase;
vytieC=[0.287 0.421 0.527 0.613 0.610 0.596];  %Data for tie-lines generation;
F(1)=FF+S-x(1)-x(2);
F(2)=FF*xCF+S*yCS-x(1)*interp1(vxC,vytieC,x(3),'spline')-x(2)*x(3);
F(3)=FF*xBF+S*yBS-x(1)*interp1(vyC,vyB,interp1(vxC,vytieC,x(3),'spline'),'spline')...
    -x(2)*interp1(vxC,vxB,x(3),'spline');

function AppendixG2
% Appendix G-2. Multistage Crosscurrent Extraction, page 482 Text .
% Uses the function fsolve from the Optimization Toolbox
% and the M-function appendixG_2 supplied by the user. 
% Data are from Example 7.3, p. 395 Text.

options=optimset('MaxFunEvals',5000);
FF=50; xCF=0.6; xBF=0; S=8;
vxC=[0.158 0.256 0.360 0.493 0.557 0.596];  %Acetone in water phase;
vxB=[.0123 .0129 .0171 .0510 .0980 .1690];  %Chloroform in water phase;
vyC=[0.287 0.421 0.527 0.613];  %Acetone in chloroform phase;
vyB=[0.700 0.557 0.429 0.284];  %Chloroform in chloroform phase;
vytieC=[0.287 0.421 0.527 0.613 0.610 0.596];  %Data for tie-lines generation;
% Stage 1
[X]=fsolve(@appendixG_2,[(FF+S)/2 (FF+S)/2 xCF/2],optimset('fsolve'),FF,xCF,xBF);
xB1=interp1(vxC,vxB,X(3),'spline');
yC1=interp1(vxC,vytieC,X(3),'spline');
yB1=interp1(vyC,vyB,interp1(vxC,vytieC,X(3),'spline'),'spline');
format compact;
fprintf('\n');
fprintf('Stage number 1'); fprintf('\n');
fprintf('E1 = %7.4f.',X(1));
fprintf('    R1 = %7.4f.\n',X(2));
fprintf('xC1 = %7.5f.',X(3));
fprintf('    xB1 = %7.5f.\n',xB1);
fprintf('yC1 = %7.5f.',yC1);
fprintf('    yB1 = %7.5f.\n',yB1);
FF=X(2); E1=X(1);
xCF=X(3); xBF=xB1;
% Stage 2
[X]=fsolve(@appendixG_2,[(FF+S)/2 (FF+S)/2 xCF/2],optimset('fsolve'),FF,xCF,xBF);
xB2=interp1(vxC,vxB,X(3),'spline');
yC2=interp1(vxC,vytieC,X(3),'spline');
yB2=interp1(vyC,vyB,interp1(vxC,vytieC,X(3),'spline'),'spline');
format compact;
fprintf('\n');
fprintf('Stage number 2'); fprintf('\n');
fprintf('E2 = %7.4f.',X(1));
fprintf('    R2 = %7.4f.\n',X(2));
fprintf('xC2 = %7.5f.',X(3));
fprintf('    xB2 = %7.5f.\n',xB2);
fprintf('yC2 = %7.5f.',yC2);
fprintf('    yB2 = %7.5f.\n',yB2);
FF=X(2); E2=X(1);
xCF=X(3); xBF=xB2;
% Stage 3
[X]=fsolve(@appendixG_2,[(FF+S)/2 (FF+S)/2 xCF/2],optimset('fsolve'),FF,xCF,xBF);
xB3=interp1(vxC,vxB,X(3),'spline');
yC3=interp1(vxC,vytieC,X(3),'spline');
yB3=interp1(vyC,vyB,interp1(vxC,vytieC,X(3),'spline'),'spline');
format compact;
fprintf('\n');
fprintf('Stage number 3'); fprintf('\n');
fprintf('E3 = %7.4f.',X(1));
fprintf('    R3 = %7.4f.\n',X(2));
fprintf('xC3 = %7.5f.',X(3));
fprintf('    xB3 = %7.5f.\n',xB3);
fprintf('yC3 = %7.5f.',yC3);
fprintf('    yB3 = %7.5f.\n',yB3);
FF=X(2); E3=X(1);
xCF=X(3); xBF=xB2;
% Composited extract
E=E1+E2+E3;
yC=(E1*yC1+E2*yC2+E3*yC3)/E;
yB=(E1*yB1+E2*yB2+E3*yB3)/E;
fprintf('\n');
fprintf('Composited extract flow rate, kg/h = %7.5f.\n',E);
fprintf('Composited extract acetone content = %7.5f.\n',yC);
fprintf('Composited extract chloroform content = %7.5f.\n',yB);

function F = appendixG_2(x,FF,xCF,xBF)
S=8; yCS=0.0; yBS=1.0;
vxC=[0.158 0.256 0.360 0.493 0.557 0.596];  %Acetone in water phase;
vxB=[.0123 .0129 .0171 .0510 .0980 .1690];  %Chloroform in water phase;
vyC=[0.287 0.421 0.527 0.613];  %Acetone in chloroform phase;
vyB=[0.700 0.557 0.429 0.284];  %Chloroform in chloroform phase;
vytieC=[0.287 0.421 0.527 0.613 0.610 0.596];  %Data for tie-lines generation;
F(1)=FF+S-x(1)-x(2);
F(2)=FF*xCF+S*yCS-x(1)*interp1(vxC,vytieC,x(3),'spline')-x(2)*x(3);
F(3)=FF*xBF+S*yBS-x(1)*interp1(vyC,vyB,interp1(vxC,vytieC,x(3),'spline'),'spline')...
    -x(2)*interp1(vxC,vxB,x(3),'spline');

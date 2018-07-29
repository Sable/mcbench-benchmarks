function [S]= conduc2sali(C,T,P)
% _________________________________________________
% Script which computes the water salinity from pressure and
% conductivity of water data.

% Input:
% C = Water conductivity, mS/cm 
% T = water temperature, ºC
% P = water pressure, db.
%
% Output:
% salin1 = water salinity, using Fofonnoff and Miller equation.
%
% Referents:
% Fofonoff, P. and Millard, R.C. (1983). Algorithms for 
%    computation of fundamental properties of seawater,  
%    Unesco Technical Papers in Marine Sci., 44, 58 pp.
% UNESCO. (1981). Background papers and supporting data on
%    the practical salinity, 1978. Unesco Technical Papers 
%    in Marine Sci., 37, 144 pp.
% Wagner, R.J., Boulger, R.W., Jr., Oblinger, C.J., y Smith, 
%    B.A., 2006, Guidelines and standard procedures for continuous
%    water-quality monitors—Station operation, record computation, 
%    and data reporting: U.S. Geological Survey Techniques
%    and Methods 1–D3, 51 p. + 8 anexos; acceso Abril 10, 2006, 
%    en http://pubs.water.usgs.gov/tm1d3
% http://www.salinometry.com/welcome/
%
% Gabriel Ruiz Mtz.
% Version 1
% 09/10/10
%
% _________________________________________________

if nargin==3
     cnd = C/4.2914;
     R = C; 
     c0 =  0.6766097;
     c1 =  2.00564e-2;
     c2 =  1.104259e-4;
     c3 =  -6.9698e-7;
     c4 =  1.0031e-9;
     RT35 = (((c3+c4*T)*T+c2)*T+c1)*T+c0;
     d1 = 3.426e-2;
     d2 = 4.464e-4;
     d3 = 4.215e-1;
     d4 = -3.107e-3;
     e1 = 2.070e-5;
     e2 = -6.370e-10;
     e3 = 3.989e-15;
     RP = 1+(P*(e1+e2*P+(e3*P^2)))/(1+(d1*T)+(d2*T^2)+(d3+(d4*T))*R);
     RT = R/(RP*RT35);
     XR =sqrt(RT);
     XT = T - 15;
     a0 = 0.0080;
     a1 = -0.1692;
     a2 = 25.3851;
     a3 = 14.0941;
     a4 = -7.0261;
     a5 = 2.7081;
     b0 =  0.0005;
     b1 = -0.0056;
     b2 = -0.0066;
     b3 = -0.0375;
     b4 =  0.0636;
     b5 = -0.0144;
     k  =  0.0162;
     DSAL = (XT/(1+k*XT))*(b0+(b1+(b2+(b3+(b4+(b5*XR))*XR)*XR)*XR)*XR);
     SAL = (((((a5*XR)+a4)*XR+a3)*XR+a2)*XR+a1)*XR+a0;
     S = SAL + DSAL;
else
    clc;
    fprintf('Review the inputs... \n');
end

% Given a real-valued spherical function represented by spherical harmonics coefficients, 
% this MATLAB function evalute its value and gradient at certain spherical angles
% 
% SYNTAX: [f, g] = real_spherical_harmonics(angles, coeff, degree, dl);
%
% INPUTS:
%
% angles                - [theta,phi] are colatitude and longitude, respectively
% coeff                 - real valued coefficients [a_00, a_1-1, a_10, a_11, ... ]
% degree                - maximum degree of spherical harmonics ;
% dl                    - {1} for full band; 2 for even order only  

%
% OUTPUTS:
%
% f                     - Evaluated function value f = \sum a_lm*Y_lm
% g                     - derivatives with respect to theta and phi
%
function [f, g] = real_spherical_harmonics(angles, coeff, degree, dl)
%%=============================================================
%% Project:   Spherical Harmonics
%% Module:    $RCSfile: real_spherical_harmonics.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2007/12/27 06:23:36 $
%% Version:   $Revision: 1.4 $
%%=============================================================

theta = angles(1);
phi = angles(2);

if (nargin<4)
    dl = 1;
end

if (dl==2) 
    coeff_length = (degree+1)*(degree+2)/2 ;
    B = zeros(1,coeff_length);
    Btheta = zeros(1,coeff_length);
    Bphi = zeros(1,coeff_length);
else
    if (dl==1) 
        coeff_length = (degree+1)*(degree+1);
        B = zeros(1,coeff_length);
        Btheta = zeros(1,coeff_length);
        Bphi = zeros(1,coeff_length);
    end
end

for l = 0:dl:degree
    if (dl==2) 
        center = (l+1)*(l+2)/2 - l;
    else
        if (dl==1) 
            center = (l+1)*(l+1) - l;
        end
    end
    lconstant = sqrt((2*l + 1)/(4*pi)); 

    [Plm,dPlm] = P(l,0,theta);
    B(center) = lconstant*Plm;
    Btheta(center) = lconstant * dPlm;
    Bphi(center) = 0;
    for m = 1:l
        precoeff = lconstant * sqrt(2.0)*sqrt(factorial(l - m)/factorial(l + m));
        if (mod(m,2) == 1)
            precoeff = -precoeff;
        end
        [Plm,dPlm] = P(l,m,theta);
        pre1 = precoeff*Plm;  
        pre2 = precoeff*dPlm;
        B(center + m) = pre1*cos(m*phi);
        B(center - m) = pre1*sin(m*phi);
        Btheta(center+m) = pre2*cos(m*phi);
        Btheta(center-m) = pre2*sin(m*phi);
        Bphi(center+m) = -m*B(center-m);
        Bphi(center-m) = m*B(center+m);
    end  
end
	
f = -sum(B.*coeff);
g = zeros(2,1);
g(1) = -sum(Btheta.*coeff);
g(2) = -sum(Bphi.*coeff);		


        



function [Plm, dPlm] = P(l, m, theta)

pmm = 1;
dpmm = 0;
x = cos(theta);
somx2 = sin(theta);
fact = 1.0;

for i = 1:m
	dpmm = -fact * (x*pmm + somx2*dpmm);
	pmm = pmm*(-fact * somx2);
	fact = fact+2;
end
% No need to go any further, rule 2 is satisfied

if (l == m)
	Plm = pmm; 
    dPlm = dpmm; 
    return;
end    

% Rule 3, use result of P(m,m) to calculate P(m,m+1)
pmmp1 = x * (2 * m + 1) * pmm;
dpmmp1 = (2*m+1)*(x*dpmm - somx2*pmm);

% Is rule 3 satisfied?
if (l == m + 1)
	Plm = pmmp1; dPlm = dpmmp1; return;
end

% Finally, use rule 1 to calculate any remaining cases
pll = 0;
dpll = 0;
for ll = m + 2:l
		%% Use result of two previous bands
		pll = (x * (2.0 * ll - 1.0) * pmmp1 - (ll + m - 1.0) * pmm) / (ll - m);
		dpll = ((2.0*ll-1.0)*( x*dpmmp1 - somx2*pmmp1 ) - (ll+m-1.0)*dpmm) / (ll - m);
		%% Shift the previous two bands up
		pmm = pmmp1;  dpmm = dpmmp1;
		pmmp1 = pll;  dpmmp1 = dpll;
end	
Plm = (pll); dPlm = (dpll);
return;

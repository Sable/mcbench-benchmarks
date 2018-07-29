function [w, dwdx, dwdxx] = Weight(type, para, di, dmI)
% EVALUATE WEIGHT FUNCTION
%
% SYNTAX: [w, dwdr, dwdrr] = GaussWeight(type, para, di, dmi)
%
% INPUT PARAMETERS
%    type - Type of weight function
%    para - Weight function parameter
%    di   - Distance
%    dmi  - Support size
% OUTPUT PARAMETERS
%    w    - Value of weight function at r
%    dwdx - Value of first order derivative of weight function with respect to x at r
%    dwdxx- Value of Second order derivative of weight function with respect to x at r
%
r  = abs(di) / dmI;

if (di >= 0.0)
   drdx = 1.0/dmI;
else
   drdx = -1.0/dmI;
end

% EVALUATE WEIGHT FUNCTION AND ITS FIRST AND SECOND ORDER OF DERIVATIVES WITH RESPECT r AT r
if (type == 'GAUSS')
   [w,dwdr,dwdrr] = Gauss(para,r);
elseif (type == 'CUBIC')
   [w,dwdr,dwdrr] = Cubic(r);
elseif (type == 'SPLIN')
   [w,dwdr,dwdrr] = Spline(r);
elseif (type == 'power')
   [w,dwdr,dwdrr] = power_function(para,r); 
elseif (type == 'CSRBF')
   [w,dwdr,dwdrr] = CSRBF2(r);
else
   error('Invalid type of weight function.');
end

dwdx  = dwdr * drdx;
dwdxx = dwdrr * drdx * drdx;


function [w,dwdr,dwdrr] = Gauss(beta,r)
if (r>1.0)
   w     = 0.0;
   dwdr  = 0.0;
   dwdrr = 0.0;
else
   b2 = beta*beta;
   r2 = r*r;
   eb2 = exp(-b2);

   w     = (exp(-b2*r2) - eb2) / (1.0 - eb2);
   dwdr  = -2*b2*r*exp(-b2*r2) / (1.0 - eb2);
   dwdrr = -2*b2*exp(-b2*r2)*(1-2*b2*r2) / (1.0 - eb2);
end

function [w,dwdr,dwdrr] = Cubic(r)
if (r>1.0)
   w     = 0.0;
   dwdr  = 0.0;
   dwdrr = 0.0;
else
   w     = 1-6*r^2+8*r^3-3*r^4;
   dwdr  = -12*r+24*r^2-12*r^3;
   dwdrr = -12+48*r-36*r^2;
end

function [w,dwdr,dwdrr] = power_function(arfa,r)
if (r>1.0)
   w     = 0.0;
   dwdr  = 0.0;
   dwdrr = 0.0;
else
    a2 = arfa*arfa;
   r2 = r*r;
    w     = exp(-r2/a2);
   dwdr  = (-2*r/a2)*exp(-r2/a2);
   dwdrr  = (-2/a2+(-2*r/a2).^2)*exp(-r2/a2);
end

function [w,dwdr,dwdrr] = Spline(r)
if (r>1.0)
   w     = 0.0;
   dwdr  = 0.0;
   dwdrr = 0.0;
elseif (r<=0.5)
   w     = 2/3 - 4*r^2 + 4*r^3;
   dwdr  = -8*r + 12*r^2;
   dwdrr = -8 + 24*r;
else
   w     = 4/3 - 4*r + 4*r^2 - 4*r^3/3;
   dwdr  = -4 + 8*r -4*r^2;
   dwdrr = 8 - 8*r;
end

function [w,dwdr,dwdrr] = CSRBF2(r)
if (r>1.0)
   w     = 0.0;
   dwdr  = 0.0;
   dwdrr = 0.0;
else
	w     = (1-r)^6*(6+36*r+82*r^2+72*r^3+30*r^4+5*r^5);
	dwdr  = 11*r*(r+2)*(5*r^3+15*r^2+18*r+4)*(r-1)^5;
   dwdrr = 22*(25*r^5+100*r^4+142*r^3+68*r^2-16*r-4)*(r-1)^4;
end

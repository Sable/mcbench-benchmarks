%% Rotation Matrices for Real Spherical Harmonics. Direct Determination by Recursion
%% This MATLAB code was written based on the C++ code at link:
%% http://mathlib.zfx.info/html_eng/SHRotate_8h-source.html
%% which I believe was again based on the implementation from Don Williamson.
%% http://www.donw.co.uk/home/downloads/SHRotation.zip
%% The original algorithm was given in the following references:
%% [1] Joseph Ivanic and Klaus Ruedenberg
%%     J. Phys. Chem. 1996, 100, 6342-5347
%%  
%% [2] Additions and Corrections (to previous paper)
%%     Joseph Ivanic and Klaus Ruedenberg
%%     J. Phys. Chem. A, 1998, Vol. 102, No. 45, 9099
%% Todo:
%% http://www.cgg.cvut.cz/~xkrivanj/papers/2005-rapport1728/rr1728-irisa-kr
%% ivanek-shrotation.pdf

function [R] = SHRotate(r, degree)

%%=============================================================
%% Project:   Spherical Harmonics
%% Module:    $RCSfile: SHRotate.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2007/12/27 06:23:35 $
%% Version:   $Revision: 1.4 $
%%=============================================================


% The first 1x1 sub-matrix is always 1
R{1} = 1;

% The l=1 band is rotated by a permutation of the original matrix
R1(-1+2,-1+2) = r(2,2);
R1(-1+2, 0+2) = r(3,2);
R1(-1+2, 1+2) = r(1,2);

R1( 0+2,-1+2) = r(2,3);
R1( 0+2, 0+2) = r(3,3);
R1( 0+2, 1+2) = r(1,3);

R1( 1+2,-1+2) = r(2,1);
R1( 1+2, 0+2) = r(3,1);
R1( 1+2, 1+2) = r(1,1);

R{1+1} = R1;


% Calculate each block of the rotation matrix for each subsequent band
for band=2:degree
    for m=-band:band
        for n=-band:band
            R{band+1}(m+band+1,n+band+1) = M(band,m,n,R);
        end
    end
end


function [ret] = M(l, m, n, R)

d = (m==0);
if (abs(n)==l)
    denom = (2*l)*(2*l-1);
else
    denom = (l*l-n*n);
end

u = sqrt((l*l-m*m)/denom);

v = sqrt((1+d)*(l+abs(m)-1)*(l+abs(m))/denom)*(1-2*d)*0.5;
w = sqrt((l-abs(m)-1)*(l-abs(m))/denom)*(1-d)*(-0.5);

if (u~=0)
    u = u*U(l,m,n,R);
end

if (v~=0)
    v = v*V(l,m,n,R);
end

if (w~=0)
    w = w*W(l,m,n,R);
end

ret = u+v+w;


function [ret] = U(l,m,n,R)

ret = P(0,l,m,n,R);

function [ret] = P(i,l,a,b,R)

ri1 = R{2}(i+2,1+2);
rim1 = R{2}(i+2,-1+2);
ri0 = R{2}(i+2,0+2);

if (b==-l)
    ret = ri1*R{l}(a+l,1) + rim1*R{l}(a+l, 2*l-1);
else
    if (b==l)
        ret = ri1*R{l}(a+l,2*l-1) - rim1*R{l}(a+l, 1);        
    else
        ret = ri0*R{l}(a+l,b+l);
    end
end


function [ret] = V(l,m,n,R)
if (m==0)
    p0 = P(1,l,1,n,R);
    p1 = P(-1,l,-1,n,R);
    ret = p0+p1;
else
    if (m>0)
        d = (m==1);
        p0 = P(1,l,m-1,n,R);
        p1 = P(-1,l,-m+1,n,R);        
        ret = p0*sqrt(1+d) - p1*(1-d);
    else
        d = (m==-1);
        p0 = P(1,l,m+1,n,R);
        p1 = P(-1,l,-m-1,n,R);        
        ret = p0*(1-d) + p1*sqrt(1+d);
    end
end

function [ret] = W(l,m,n,R)
if (m==0)
    error('never gets called')
else
    if (m>0)
        p0 = P(1,l,m+1,n,R);
        p1 = P(-1,l,-m-1,n,R);        
        ret = p0 + p1;
    else
        p0 = P(1,l,m-1,n,R);
        p1 = P(-1,l,-m+1,n,R);        
        ret = p0 - p1;
    end
end

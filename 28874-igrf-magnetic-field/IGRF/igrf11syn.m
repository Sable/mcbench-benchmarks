function    [B]=igrf11syn(fyears,alt,nlat,elong)
%****************************************************
%  Direct conversion of igrf11_f to MATLAB
%  USAGE:   [B]=igrf11syn(fyears,alt,nlat,elong) 
% 
%  INPUT:   fyears = date in fractional years e.g. 1909.5 
%           alt    = altitude in                       (km)
%           nlat   = latiude positive north            (deg)
%           elong  = longitude positive east           (deg)
% OUTPUT:
%                B = [B_North; B_East; B_up]           (nano Teslas)
%

%  Conversion written by
%  Charles L. Rino
%  Rino Consulting
%  September 27 2010/October 3 2010 
%  crino@mindspring.com
%
%  CHANGES
%  date replaced by fyears
%  colat replaced by nlat
%  isv and itype preset to 0 and 1, respectively
%  output changed from [x,y,z,f] to non-redundant vector B=[x; y; z];
%The following text is from the fortran comment lines:
%
%     This is a program for synthesising geomagnetic field values from the 
%     International Geomagnetic Reference Field series of models as agreed
%     in December 2009 by IAGA Working Group V-MOD. 
%     It is the 11th generation IGRF, ie the 10th revision. 
%     The main-field models for 1900.0, 1905.0,..1940.0 and 2010.0 are 
%     non-definitive, those for 1945.0, 1950.0,...2005.0 are definitive and
%     the secular-variation model for 2010.0 to 2015.0 is non-definitive.
%
%     Main-field models are to degree and order 10 (ie 120 coefficients)
%     for 1900.0-1995.0 and to 13 (ie 195 coefficients) for 2000.0 onwards. 
%     The predictive secular-variation model is to degree and order 8 (ie 80
%     coefficients).
%
%     Options include values at different locations at different
%     times (spot), values at same location at one year intervals
%     (time series), grid of values at one time (grid); geodetic or
%     geocentric coordinates, latitude & longitude entered as decimal
%     degrees or degrees & minutes (not in grid), choice of main field 
%     or secular variation or both (grid only).
% Recent history of code:
%     Aug 2003: 
%     Adapted from 8th generation version to include new maximum degree for
%     main-field models for 2000.0 and onwards and use WGS84 spheroid instead
%     of International Astronomical Union 1966 spheroid as recommended by IAGA
%     in July 2003. Reference radius remains as 6371.2 km - it is NOT the mean
%     radius (= 6371.0 km) but 6371.2 km is what is used in determining the
%     coefficients. 
%     Dec 2004: 
%     Adapted for 10th generation
%     Jul 2005: 
%     1995.0 coefficients as published in igrf9coeffs.xls and igrf10coeffs.xls
%     now used in code - (Kimmo Korhonen spotted 1 nT difference in 11 coefficients)
%     Dec 2009:
%     Adapted for 11th generation
%
%   INPUT
%     isv   = 0 if main-field values are required
%     isv   = 1 if secular variation values are required
%     date  = year A.D. Must be greater than or equal to 1900.0 and
%             less than or equal to 2015.0. Warning message is given
%             for dates greater than 2010.0. Must be double precision.
%     itype = 1 if geodetic (spheroid)
%     itype = 2 if geocentric (sphere)
%     alt   = height in km above sea level if itype = 1
%           = distance from centre of Earth in km if itype = 2 (>3485 km)
%     colat = colatitude (0-180)
%     elong = east-longitude (0-360)
%     alt, colat and elong must be double precision.
%   OUTPUT
%     x     = north component (nT) if isv = 0, nT/year if isv = 1
%     y     = east component (nT) if isv = 0, nT/year if isv = 1
%     z     = vertical component (nT) if isv = 0, nT/year if isv = 1
%     f     = total intensity (nT) if isv = 0, rubbish if isv = 1
%     B     = [x; y; z]
%
%     To get the other geomagnetic elements (D, I, H and secular
%     variations dD, dH, dI and dF) use routines ptoc and ptocsv.
%
%     Adapted from 8th generation version to include new maximum degree for
%     main-field models for 2000.0 and onwards and use WGS84 spheroid instead
%     of International Astronomical Union 1966 spheroid as recommended by IAGA
%     in July 2003. Reference radius remains as 6371.2 km - it is NOT the mean
%     radius (= 6371.0 km) but 6371.2 km is what is used in determining the
%     coefficients. Adaptation by Susan Macmillan, August 2003 (for
%     9th generation) and December 2004.
%     1995.0 coefficients as published in igrf9coeffs.xls and igrf10coeffs.xls
%     used - (Kimmo Korhonen spotted 1 nT difference in 11 coefficients)
%     Susan Macmillan July 2005
%************************************************************************************
global gh
%%%%%%%%%%%Variable Changes:
isv=0;
itype=1;
colat=90-nlat;
%****************************************************
cl=NaN*ones(1,13); 
sl=NaN*ones(1,13);  
x     = 0;
y     = 0;
z     = 0;
if fyears < 1900 || fyears > 2020
    error('Date >=1900 & <=2020')
end
if fyears > 2015
    warning('on',' This version of IGRF intended for use to only to 2015 \n')
end
if fyears <2010
    t     = 0.2*(fyears - 1900.0);
    ll    = floor(t);
    one   = ll;
    t     = t - one;
    if fyears<1995.0 
        nmx   = 10;
        nc    = nmx*(nmx+2);
        ll    = nc*ll;
        kmx   = (nmx+1)*(nmx+2)/2;
    else %1995<=fyears<2010
        nmx   = 13;
        nc    = nmx*(nmx+2);
        ll    = floor(0.2*(fyears - 1995));
        ll    = 120*19 + nc*ll;
        kmx   = (nmx+1)*(nmx+2)/2;
    end
    tc  = 1-t;
    if isv==1
        tc = -0.2;
        t  = 0.2;
    end
else %>= 2010
    t=fyears-2010;
    tc =1;
    if isv==1
        t=1;
        tc=0;
    end
    ll    = 2865;
    nmx   = 13;
    nc    = nmx*(nmx+2);
    kmx   = (nmx+1)*(nmx+2)/2;
end

r     = alt;
one   = colat*0.017453292;
ct    = cos(one);
st    = sin(one);
one   = elong*0.017453292;
cl(1) = cos(one);
sl(1) = sin(one);
cd    = 1.0;
sd    = 0.0;
l     = 1;
m     = 1;
n     = 0;

if itype==1  %Skip if itype==2
    %   Conversion from geodetic to geocentric coordinates (using the WGS84 spheroid)
    a2    = 40680631.6;
    b2    = 40408296.0;
    one   = a2*st*st;
    two   = b2*ct*ct;
    three = one + two;
    rho   = sqrt(three);
    r     = sqrt(alt*(alt + 2.0*rho) + (a2*one + b2*two)/three);
    cd    = (alt + rho)/r;
    sd    = (a2 - b2)/rho*ct*st/r;
    one   = ct;
    ct    = ct*cd -  st*sd;
    st    = st*cd + one*sd;
end
ratio = 6371.2/r;  
rr    = ratio*ratio;
p=NaN*ones(1,kmx);
q=NaN*ones(1,kmx);

%     computation of Schmidt quasi-normal coefficients p and x(=q)
p(1)  = 1.0;
p(3)  = st;
q(1)  = 0.0;
q(3)  =  ct;
for k=2:kmx
    if n<m
        m     = 0;
        n     = n + 1;
        rr    = rr*ratio;
        fn    = n;
        gn    = n - 1;
    end
    fm    = m;
    if m==n && k~=3
        one   = sqrt(1.0 - 0.5/fm);
        j     = k - n - 1;
        p(k)  = one*st*p(j);
        q(k)  = one*(st*q(j) + ct*p(j));
        cl(m) = cl(m-1)*cl(1) - sl(m-1)*sl(1);
        sl(m) = sl(m-1)*cl(1) + cl(m-1)*sl(1);
    end
    if m~=n && k~=3
        gmm    = m*m;
        one   = sqrt(fn*fn - gmm);
        two   = sqrt(gn*gn - gmm)/one;
        three = (fn + gn)/one;
        i     = k - n;
        j     = i - n + 1;
        p(k)  = three*ct*p(i) - two*p(j);
        q(k)  = three*(ct*q(i) - st*p(i)) - two*q(j);
    end
    %Synthesis of x, y, and z
    lm    = ll + l;
    one   = (tc*gh(lm) + t*gh(lm+nc))*rr;
    %DEBUG 
    %[nyear,ncoef]=decode_coeff_pointer(lm);
    %fprintf('nyear %6i %5i %5i \n',lm,nyear,ncoef); 
    if m~=0
        two   = (tc*gh(lm+1) + t*gh(lm+nc+1))*rr;
        three = one*cl(m) + two*sl(m);
        x     = x + three*q(k);
        z     = z - (fn + 1.0)*three*p(k);
        if st~=0
            y     = y + (one*sl(m) - two*cl(m))*fm*p(k)/st;
        else
            y     = y + (one*sl(m) - two*cl(m))*q(k)*ct;
        end
        l     = l + 2;
    else
        x     = x + one*q(k);
        z     = z - (fn + 1.0)*one*p(k);
        l     = l + 1;
    end
    m     = m + 1;
end %k loop

%     conversion to coordinate system specified by itype
one   = x;
x     = x*cd +   z*sd;
z     = z*cd - one*sd;
B     =[x; y; z];
%f     = sqrt(x*x + y*y + z*z);
return
function outdata = jatmos70(indata)

% Jacchia 1970 atmosphere main driver

% input

%  indata(1)  = geodetic altitude (kilometers)
%  indata(2)  = geodetic latitude (radians)
%  indata(3)  = geographic longitude (radians)
%  indata(4)  = calendar year (all digits)
%  indata(5)  = calendar month
%  indata(6)  = calendar day
%  indata(7)  = utc hours
%  indata(8)  = utc minutes
%  indata(9)  = geomagnetic index type
%               (1 = indata(12) is Kp, 2 = indata(12) is Ap)
%  indata(10) = solar radio noise flux (jansky)
%  indata(11) = 162-day average F10 (jansky)
%  indata(12) = geomagnetic activity index

% output

%  outdata(1)  = exospheric temperature (deg K)
%  outdata(2)  = temperature at altitude (deg K)
%  outdata(3)  = N2 number density (per meter-cubed)
%  outdata(4)  = O2 number density (per meter-cubed)
%  outdata(5)  = O number density (per meter-cubed)
%  outdata(6)  = A number density (per meter-cubed)
%  outdata(7)  = He number density (per meter-cubed)
%  outdata(8)  = H number density (per meter-cubed)
%  outdata(9)  = average molecular weight
%  outdata(10) = total density (kilogram/meter-cubed)
%  outdata(11) = log10(total density)
%  outdata(12) = total pressure (pascals)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bfh = 440;

rgas = 8314.32;

% unload input data

z = indata(1);
xlat = indata(2);
xlng = indata(3);
iyr = indata(4);
mn = indata(5);
ida = indata(6);
ihr = indata(7);
min = indata(8);
i1 = indata(9);
f10 = indata(10);
f10b = indata(11);
gi = indata(12);

% compute solar coordinates

[sda, sha, dd, dy] = jtme(mn, ida, iyr, ihr, min, xlng);

% calculate exospheric temperature

te = jtinf(f10, f10b, gi, xlat, sda, sha, dy, i1);

% evaluate jacchia model

[dens, dl, em, tz, a(1), a(2), a(3), a(4), a(5), a(6)] = jacchia(z, te);

denlg = 0;
dummy = dl;
den = dl;

if (z <= 170) 
   dummy = jslv(z, xlat, dd);
   denlg = dummy;
end

if (z >= 500) 
    den = jslvh(den, a(5), xlat, sda);
    dl = den;
elseif (z > bfh) 
    dhel1 = a(5);
    dhel2 = a(5);
    dlg1 = dl;
    dlg2 = dl;
    dlg2 = jslvh(dlg2, dhel2, xlat, sda);
    ih = z;
    [fdhel, fdlg] = jfair(dhel1, dhel2, dlg1, dlg2, ih);
    dl = fdlg;
    a(5) = fdhel;
end

dl = dl + denlg;

dens = 10 ^ dl;

% load output data array

outdata(1) = te;

outdata(2) = tz;

for i = 1:1:6
    outdata(i + 2) = 1000000 * (10 ^ a(i));
end

outdata(9) = em;
outdata(10) = dens * 1000;
outdata(11) = dl;
   
p = outdata(10) * rgas * tz / em;
   
outdata(12) = p;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [dens, dl, em, tz, an, ao2, ao, aa, ahe, ah] = jacchia (z, t)

% jacchia 1970 atmosphere

global alpha ei

av = 6.02257e+23;
qn = 0.7811;
qo2 = 0.20955;
qa = 9.343e-03;
qhe = 0.00001289;
rgas = 8.31432;
t0 = 183;

tx = 444.3807 + 0.02385 * t - 392.8292 * exp(-0.0021357 * t);
a2 = 2 * (t - tx) / pi;
txt0 = tx - t0;
t1 = 1.9 * txt0 / 35;
t3 = -1.7 * txt0 / (35 ^ 3);
t4 = -.8 * txt0 / (35 ^ 4);
tz = jtemp(z, tx, t1, t3, t4, a2);

a = 90;
d = min(z, 105);

r = jgauss(a, d, 1, tx, t1, t3, t4, a2);

em = jmweight(d);

td = jtemp(d, tx, t1, t3, t4, a2);

dens = 0.000000021926 * em * exp(-r / rgas) / td;

factor = av * dens;
par = factor / em;
factor = factor / 28.96;

if (z <= 105) 
   dl = log10(dens);
   an = log10(qn * factor);
   aa = log10(qa * factor);
   ahe = log10(qhe * factor);
   ao = log10(2 * par * (1 - em / 28.96));
   ao2 = log10(par * (em * (1 + qo2) / 28.96 - 1));
   ah = 0;
   return;
end

di(1) = qn * factor;
di(2) = par * (em * (1 + qo2) / 28.96 - 1);
di(3) = 2 * par * (1 - em / 28.96);
di(4) = qa * factor;
di(5) = qhe * factor;

r = jgauss(d, z, 2, tx, t1, t3, t4, a2);

for i = 1:1:5
    dit(i) = di(i) * (td / tz) ^ (1 + alpha(i)) * exp(-ei(i) * r / rgas);
    
    if (dit(i) <= 0) 
       dit(i) = 0.000001;
    end
end

if (z > 500) 
   a1 = 500;
   s = jtemp(a1, tx, t1, t3, t4, a2);
   di(6) = 10 ^ (73.13 - 39.4 * log10(s) + 5.5 * log10(s) * log10(s));
   r = jgauss(a1, z, 7, tx, t1, t3, t4, a2);
   dit(6) = di(6) * (s / tz) * exp(-ei(6) * r / rgas);
else
   dit(6) = 1;
end

dens = 0;

for i = 1:1:6
    dens = dens + ei(i) * dit(i) / av;
end

em = dens * av / (dit(1) + dit(2) + dit(3) + dit(4) + dit(5) + dit(6));

dl = log10(dens);

an = log10(dit(1));
ao2 = log10(dit(2));
ao = log10(dit(3));
aa = log10(dit(4));
ahe = log10(dit(5));
ah = log10(dit(6));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [sda, sha, dd, dy] = jtme (mn, ida, iyr, ihr, min, xlng)

% solar declination and hour angle

dtr = pi / 180;

atr = dtr / 3600;

% compute julian date on january 1

jdate = julian(1, 1, iyr);

% compute julian date on day of interest

xmjd = julian(mn, ida, iyr);

% compute day number of the year

dd = xmjd - jdate;
   
% compute fraction of tropical year

dy = dd / 365.2422;

% compute greenwich mean time

gmt = 60 * ihr + min;
   
% compute solar coordinates

a = xmjd + gmt / 1440 - 2451545;

b = a / 36525 + 1;

o = r2r(0.056531 + 0.00023080893 * a);
m = r2r(0.140023 + 0.00445036173 * a);
l = r2r(0.779072 + 0.00273790931 * a);
h = r2r(0.606434 + 0.0366011013 * a);
n = r2r(0.053856 + 0.00145561327 * a);
f = r2r(0.993126 + 0.0027377785 * a);
r = r2r(0.347343 - 0.00014709391 * a);

obliq = atr * (84428 - 47 * b + 9 * cos(r));

p = 6910 * sin(f) + 72 * sin(2 * f) - 17 * b * sin(f) - 7 * cos(f - o) ...
    + 6 * sin(h - l) + 5 * sin(4 * f - 8 * n + 3 * o) ...
    - 5 * cos(2 * (f - m)) - 4 * sin(f - m) + 4 * cos(4 * f - 8 * n ...
    + 3 * o) + 3 * sin(2 * (f - m)) - 3 * sin(o) - 3 * sin(2 * (f - o));

p = l + atr * (p - 17 * sin(r));

a = sin(p) * cos(obliq);

b = cos(p);

% compute solar right ascension and declination

ras = atan3(a, b);
   
sda = asin(sin(obliq) * sin(p));
    
% compute greenwich sidereal time

gst = gast1(xmjd + ihr / 24 + min / 1440);

% compute right ascension of point of interest

rap = mod(gst + xlng, 2.0 * pi);
  
% compute hour angle

sha = mod(rap - ras, 2.0 * pi);
     
if (sha > pi)
   sha = sha - 2.0 * pi;
end

if (sha < -pi)
   sha = sha + 2.0 * pi;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function te = jtinf (f10, f10b, gi, xlat, sda, sha, dy, i1)

% exospheric temperature

c1 = 383;
c2 = 3.32;
c3 = 1.8;

d1 = 28;
d2 = 0.03;
d3 = 1;
d4 = 100;
d5 = -0.08;

e1 = 2.41;
e2 = 0.349;
e3 = 0.206;
e4 = 6.2831853;
e5 = 3.9531708;
e6 = 12.5663706;
e7 = 4.3214352;
e8 = 0.1145;
e9 = 0.5;
e10 = 6.2831853;
e11 = 5.974262;
e12 = 2.16;
   
beta = -0.6457718;
gamma = 0.7504916;
p = 0.1047198;
re = 0.31;

tc = c1 + c2 * f10b + c3 * (f10 - f10b);

eta = 0.5 * abs(xlat - sda);
theta = 0.5 * abs(xlat + sda);
tau = sha + beta + p * sin(sha + gamma);

if (tau > pi)
   tau = tau - 2 * pi;
end

if (tau < -pi)
   tau = tau + 2 * pi;
end

a1 = (sin(theta)) ^ 2.5;
a2 = (cos(eta)) ^ 2.5;
a3 = (cos(tau / 2)) ^ 3;
b1 = 1 + re * a1;
b2 = (a2 - a1) / b1;
tv = b1 * (1 + re * b2 * a3);
tl = tc * tv;

if (i1 == 1) 
   tg = d1 * gi + d2 * exp(gi);
else
   tg = d3 * gi + d4 * (1 - exp(d5 * gi));
end

g3 = 0.5 * (1 + sin(e10 * dy + e11));

g3 = g3 ^ e12;
   
tau1 = dy + e8 * (g3 - e9);
   
g1 = e2 + e3 * (sin(e4 * tau1 + e5));

g2 = sin(e6 * tau1 + e7);
   
ts = e1 + f10b * g1 * g2;

te = tl + tg + ts;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function den = jslv (alt, xlat, day)

den = 0;

if (alt > 170)
   return;
end

z = alt - 90;
x = -0.0013 * z * z;
y = 0.0172 * day + 1.72;
p = sin(y);
sp = (sin(xlat)) ^ 2;
s = 0.014 * z * exp(x);
d = s * p * sp;

if (xlat < 0) 
   d = -d;
end

den = d;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function den = jslvh (den, denhe, xlat, sda)

ezero = 10 ^ denhe;

a = abs(0.65 * (sda / 0.40909079));

b = 0.5 * xlat;

if (sda < 0)
   b = -b;
end

x = 0.7854 - b;

y = sin(x) ^ 3;

dhe = a * (y - 0.35356);

denhe = denhe + dhe;

d1 = 10 ^ denhe;

del = d1 - ezero;

rho = 10 ^ den;

drho = 6.646e-24 * del;

rho = rho + drho;

den = log10(rho);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [fdhel, fdlg] = jfair (dhel1, dhel2, dlg1, dlg2, ih)

% fair density

global cz

bfh = 440;

i = fix((ih - bfh) / 10) + 1;

czi = cz(i);
szi = 1 - czi;

fdlg = (dlg1 * czi) + (dlg2 * szi);

fdhel = (dhel1 * czi) + (dhel2 * szi);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function r = jgauss (z1, z2, nmin, tx, t1, t3, t4, a2)

% gaussian quadrature

global ng xgauss cgauss altmin

r = 0;

for k = nmin:1:8
    ngauss = ng(k);
    a = altmin(k);
    d = min(z2, altmin(k + 1));
    rr = 0;
    del = 0.5 * (d - a);
    j = ngauss - 2;

    for i = 1:1:ngauss
        z = del * (xgauss(i, j) + 1) + a;
       
        rr = rr + cgauss(i, j) * jmweight(z) * jgrav(z) ...
             / jtemp(z, tx, t1, t3, t4, a2);
    end

    rr = del * rr;
    r = r + rr;

    if (d == z2)
       break;
    end
end    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function agrav = jgrav(altitude)

% acceleration of gravity
   
agrav = 9.80665 / ((1 + altitude / 6356.766) ^ 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mweight = jmweight (a)
   
% molecular weight function

global bdata

if (a > 105) 
   mweight = 1;
else
   u = a - 100;
   
   wttmp = bdata(1);
   
   for i = 2:1:7
       wttmp = wttmp + bdata(i) * u ^ (i - 1);
   end
   
   mweight = wttmp;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function temp = jtemp (alt, tx, t1, t3, t4, a2)
   
% temperature function
   
bb = 0.0000045;
   
u = alt - 125.0;

if (u > 0) 
   temp = tx + a2 * atan(t1 * u * (1 + bb * (u ^ 2.5)) / a2);
else
   temp = tx + t1 * u + t3 * (u ^ 3) + t4 * (u ^ 4);
end




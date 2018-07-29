function gst = gast1 (jdate)

% Greenwich apparent sidereal time

% major nutation terms only

% input

%  jdate = Julian date

% output

%  gst = Greenwich apparent sidereal time (radians)
%        (0 <= gst <= 2 pi)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pi2 = 2.0 * pi;

% conversion factors

dtr = pi/180;

atr = dtr/3600;

% time arguments

t = (jdate - 2451545) / 36525;
   
t2 = t * t;

t3 = t * t2;

% fundamental trig arguments

l = mod(dtr * (280.4665 + 36000.7698 * t), pi2);

lp = mod(dtr * (218.3165 + 481267.8813 * t), pi2);

lraan = mod(dtr * (125.04452 - 1934.136261 * t), pi2);

% nutations in longitude and obliquity

dpsi = atr * (-17.2 * sin(lraan) - 1.32 * sin(2 * l) ...
       - 0.23 * sin(2 * lp) + 0.21 * sin(2 * lraan));

deps = atr * (9.2 * cos(lraan) + 0.57 * cos(2 * l) ...
       + 0.1 * cos(2 * lp) - 0.09 * cos(2 * lraan));

% mean and apparent obliquity of the ecliptic

eps0 = mod(dtr * (23 + 26 / 60 + 21.448 / 3600) ... 
       + atr * (-46.815 * t - 0.00059 * t2 + 0.001813 * t3), pi2); 

obliq = eps0 + deps;

% greenwich mean and apparent sidereal time

gstm = mod(dtr * (280.46061837 + 360.98564736629 * (jdate - 2451545) ...
       + 0.000387933 * t2 - t3 / 38710000), pi2);
    
gst = mod(gstm + dpsi * cos(obliq), pi2);


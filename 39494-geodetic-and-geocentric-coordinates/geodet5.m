function [xalt, xlat] = geodet5(req, rpolar, rsc)

% convert geocentric eci position vector to
% geodetic altitude and latitude

% input

%  req    = equatorial radius (kilometers)
%  rpolar = polar radius (kilometers)
%  rsc    = spacecraft eci position vector (kilometers)

% output

%  xalt = geodetic altitude (kilometers)
%  xlat = geodetic latitude (radians)
%         (+north, -south; -pi/2 <= xlat <= +pi/2)

% reference

% "Improved Method for Calculating Exact Geodetic
% Latitude and Altitude", Isaac Sofair

% AIAA JGCD Vol. 20, No. 4 and Vol. 23, No. 2

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a = req;

b = rpolar;

% load components of position vector

x0 = rsc(1);

y0 = rsc(2);

z0 = rsc(3);

eccsqr = 1.0 - b * b / (a * a);

epssqr = a * a / (b * b) - 1.0;

r0 = sqrt(x0 * x0 + y0 * y0);

p = abs(z0) / epssqr;

s = r0 * r0 / (eccsqr * epssqr);

q = p * p - b * b + s;

if (q > 0)
   u = p / sqrt(q);

   v = b * b * u * u / q;

   bigp = 27.0 * v * s / q;

   bigq = (sqrt(bigp + 1.0) + sqrt(bigp))^(2.0/3.0);

   t = (1.0 + bigq + 1.0 / bigq) / 6.0;

   c = sqrt(u * u - 1.0 + 2.0 * t);

   w = (c - u) / 2.0;

   z = sign(z0) * sqrt(q) * (w + sqrt(sqrt(t * t + v) ...
       - u * w - t / 2.0 - 1.0 / 4.0));

   ne = a * sqrt(1.0 + epssqr * z * z / (b * b));

   % geodetic latitude (radians)

   xlat = asin((epssqr + 1.0) * (z / ne));

   % geodetic altitude (kilometers)

   xalt = r0 * cos(xlat) + z0 * sin(xlat) - a * a / ne;

else
   fprintf('\nq not greater than zero in geodet5\n\n');
end

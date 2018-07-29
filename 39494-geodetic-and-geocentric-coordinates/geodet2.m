function [xlat, alt] = geodet2(decl, rmag)

% geocentric to geodetic coordinates
% exact solution (Borkowski, 1989)

% input

%  decl = geocentric declination (radians)
%  rmag = geocentric distance (kilometers)

% output

%  xlat = geodetic latitude (radians)
%  alt  = geodetic altitude (kilometers)

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global req flat

fr = 1 / flat;

% determine x and z components of the geocentric distance

rx = rmag * cos(decl);

rz = rmag * sin(decl);

% compute geodetic latitude and altitude

if (rz == 0)
   % special case - equatorial

   xlat = 0;
   alt = rmag - req;

elseif (abs(decl) == 0.5 * pi)
   % special case - polar

   xlat = decl;
   alt = rmag - (req - req/fr);

else
   % general case

   b = sign(rz) * (req - req/fr);

   e = ((rz + b) * b/req - req)/rx;

   f = ((rz - b) * b/req + req)/rx;

   p = (e * f + 1) * 4/3;

   q = (e * e - f * f) * 2;

   d = p * p * p + q * q;

   if (d >= 0.0)
      s = sqrt(d) + q;
      s = sign(s) * (exp(log(abs(s))/3));
      v = p/s - s;
      v = -(q + q + v * v * v)/(3 * p);
   else
      v = 2 * sqrt(-p) * cos(acos(q/p/sqrt(-p))/3);
   end

   g = 0.5 * (e + sqrt(e * e + v));

   t = sqrt(g * g + (f - v * g)/(g + g - e)) - g;

   xlat = atan((1 - t * t) * req/(2 * b * t));

   alt = (rx - req * t) * cos(xlat) + (rz - b) * sin(xlat);
end


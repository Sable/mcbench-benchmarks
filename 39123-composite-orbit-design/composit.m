% composit.m        September 2, 2013

% sun-synchronous, repeating ground track,
% frozen orbit design - Kozai J2 perturbations

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

global j2 j3 mu req omega argper fi xldot xqp

% astrodynamic and utility constants

j2 = 0.00108263;
j3 = -0.00000254;
mu = 398600.4415;
req = 6378.14;
omega = 0.000072921151467;

pi2 = 2.0 * pi;
dtr = pi / 180.0;
rtd = 180.0 / pi;

x = zeros(3, 1);

clc; home;

fprintf('\n                    program composit');

fprintf('\n\n < sun-synchronous, repeating ground track, frozen orbits >\n\n');

% request initial guesses

while(1)

   fprintf('\nplease input an initial guess for the semimajor axis (kilometers)\n');

   x(1) = input('? ');

   if (x(1) > 0.0)
      break;
   end
   
end

while(1)

   fprintf('\nplease input an initial guess for the eccentricity (non-dimensional)');
   fprintf('\n(0 <= eccentricity < 1)\n');

   x(2) = input('? ');

   if (x(2) >= 0.0 && x(2) < 1.0)
      break;
   end
   
end

while(1)

    fprintf('\nplease input an initial guess for the inclination (degrees)');
    fprintf('\n(90 < inclination <= 180)\n');

    x(3) = input('? ');

    if (x(3) > 90.0 && x(3) <= 180.0)
       break;
    end
    
end

x(3) = x(3) * dtr;

while(1)

   fprintf('\nplease input the number of integer orbits in the repeat cycle\n');

   norbits = input('? ');

   if (norbits > 1)
      break;
   end
   
end

while(1)

   fprintf('\nplease input the number of integer days in the repeat cycle\n');

   ndays = input('? ');

   if (ndays > 0)
      break;
   end
   
end

% compute repetition factor

xqp = norbits / ndays;

% fundamental interval

fi = pi2 / xqp;

% required nodal regression rate

xldot = (360.0 / 365.25) * dtr / 86400.0;

argper = 90.0 * dtr;

% solve system of nonlinear equations

n = 3;

maxiter = 200;

[xf, niter, icheck] = snle ('compfunc', x, n, maxiter);

sma = xf(1);

ecc = xf(2);

inc = rtd * xf(3);

% keplerian period

tkepler = pi2 * sqrt(sma ^ 3 / mu);

tnode = pi2 * (1.0 / xqp) / (omega - xldot);

% print results

clc; home;

fprintf('\n                    program composit');

fprintf('\n\n < sun-synchronous, repeating ground track, frozen orbits >\n\n');

fprintf('mean semimajor axis                %12.4f  kilometers \n\n', sma);

fprintf('mean eccentricity                  %12.10f \n\n', ecc);

fprintf('mean orbital inclination           %12.4f  degrees \n\n', inc);

fprintf('mean argument of perigee           %12.4f  degrees \n\n', argper*rtd);

fprintf('keplerian period                   %12.4f  minutes \n\n', tkepler/60);

fprintf('nodal period                       %12.4f  minutes \n\n', tnode/60);

fprintf('number of orbits in repeat cycle   %12.4f  \n\n', norbits);

fprintf('number of days in repeat cycle     %12.4f  \n\n', ndays);

fprintf('ground trace repetition factor     %12.4f  \n\n', xqp);



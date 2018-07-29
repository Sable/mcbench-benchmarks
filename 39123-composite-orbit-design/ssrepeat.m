% ssrepeat.m        September 2, 2013

% sun-synchronous, repeating ground track orbit design

% Kozai J2 orbit perturbations

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

global j2 mu req omega xldot tnode tkepler

global ecc argper xqp

% astrodynamic and utility constants

j2 = 0.00108263;
mu = 398600.4415;
req = 6378.14;
omega = 7.2921151467e-5;

pi2 = 2.0 * pi;
dtr = pi / 180.0;
rtd = 180.0 / pi;

x = zeros(2, 1);

clc; home;

fprintf('\n                 program ssrepeat');

fprintf('\n\n < sun-synchronous, repeating ground track orbits >\n\n');

while(1)
    
   fprintf('please input an initial guess for the semimajor axis (kilometers)\n');

   sma = input('? ');
   
   if (sma > 0.0)
      break;
   end   
   
end

x(1) = sma;

while(1)
    
   fprintf('\nplease input an initial guess for the inclination (degrees)\n');
   fprintf('(90 < inclination <= 180)\n');

   inc = input('? ');
   
   if (inc > 90.0 && inc <= 180.0)
      break;
   end
   
end

x(2) = inc * dtr;

while (1)
    
   fprintf('\nplease input the orbital eccentricity (non-dimensional)\n');
   fprintf('(0 <= eccentricity < 1)\n');

   ecc = input('? ');
   
   if (ecc >= 0.0 && ecc < 1.0)
      break;
   end 
   
end

if (ecc > 0)
    
   while (1)

      fprintf('\nplease input the argument of perigee (degrees)');
      fprintf('\n(0 <= argument of perigee <= 360)\n');

      argper = input('? ');
      
      if (argper >= 0.0 && argper <= 360.0)
         break;
      end
      
   end 
   
else
    
   argper = 0.0;
   
end

while(1)
    
   fprintf('\n\nplease input the number of integer orbits in the repeat cycle\n');

   norbits = input('? ');
   
   if (norbits > 0)
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

clc; home;

disp('  working ...');

% required nodal regression rate

xldot = (360.0 / 365.25) * dtr / 86400.0;

% compute repetition factor

xqp = norbits / ndays;

% solve system of nonlinear equations

argper = argper * dtr;

n = 2;

maxiter = 200;

[xf, niter, icheck] = snle ('ssrfunc', x, n, maxiter);

sma = xf(1);

inc = rtd * xf(2);

% keplerian period

tkepler = pi2 * sqrt(sma ^ 3 / mu);

% nodal period

tnode = pi2 * (1.0 / xqp) / (omega - xldot);

% print results

clc; home;

fprintf('\n                    program ssrepeat');

fprintf('\n\n < sun-synchronous, repeating ground track orbits >');

fprintf('\n\n');

fprintf('mean semimajor axis                %12.4f  kilometers \n\n', sma);

fprintf('mean eccentricity                  %12.10f \n\n', ecc);

fprintf('mean orbital inclination           %12.4f  degrees \n\n', inc);

fprintf('mean argument of perigee           %12.4f  degrees \n\n', argper*rtd);

fprintf('Keplerian period                   %12.4f  minutes \n\n', tkepler/60);

fprintf('nodal period                       %12.4f  minutes \n\n', tnode/60);

fprintf('number of orbits in repeat cycle   %12.4f  \n\n', norbits);

fprintf('number of days in repeat cycle     %12.4f  \n\n', ndays);

fprintf('ground trace repetition factor     %12.4f  \n\n', xqp);





function newtondemo
% Demonstration of Newton method for single variable functions     
%    using MATLAB                    
%
%   $Ekkehard Holzbecher  $Date: 2006/05/03 $
%--------------------------------------------------------------------------
toll = 1.e-7;      % tolerance
nmax = 20;         % max. no. of iterations 
x = 2.5;           % initial guess

err = toll+1; nit = 0;
while (nit < nmax && err > toll),
   nit = nit+1;
   F = f(x);
   DF = fderiv (x); 
   dx = -F/DF;
   err = abs(dx);
   x = x+dx;
end
display (['Zero obtained after ' num2str(nit) ' iterations:']);
x

function F = f(x)
F = cos(x);

function DF = fderiv(x)
DF = -sin(x);

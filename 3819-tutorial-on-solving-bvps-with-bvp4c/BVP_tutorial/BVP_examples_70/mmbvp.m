function mmbvp
%MMBVP  Exercise for Example 7 of the BVP tutorial.
%   This is the Michaelis-Menten kinetics problem solved in section 6.2 of
%   H.B. Keller, Numerical Methods for Two-Point Boundary-Value Problems,
%   Dover, New York, 1992, for parameters epsilon = 0.1 and k = 0.1.

% Copyright 2004, The MathWorks, Inc.

  % Known parameters, visible in the nested functions.
  epsilon = 0.1;
  k = 0.1;
  d = 0.001;
  
  options = bvpset('stats','on');

  solinit = bvpinit(linspace(d,1,5),[0.01 0],0.01);
  sol = bvp4c(@mmode,@mmbc,solinit,options);
  p = sol.parameters;    % unknown parameter
  xint = linspace(d,1);
  Sxint = deval(sol,xint);

  % Augment the solution array with the values y(0) = p, y'(0) = 0
  % to get a solution on [0, 1]. For this problem the solution is
  % flat near x = 0, but if it had been necessary for a smooth graph, 
  % other values in [0,d] could have been obtained from the series. 
  x = [0 xint];
  y = [[p; 0] Sxint];
  
  figure
  plot(x,y(1,:))
  title('Michaelis-Menten kinetics problem with coordinate singularity.')
  
  % --------------------------------------------------------------------------
  % Nested functions
  %
  
  function dydx = mmode(x,y,p)
  %MMODE  ODE function for the exercise of Example 7 of the BVP tutorial.
    dydx = [  y(2)
              -2*(y(2)/x) + y(1)/(epsilon*(y(1) + k)) ];
  end % mmode  
    
  % --------------------------------------------------------------------------

  function res = mmbc(ya,yb,p)
  %MMBC  Boundary conditions for the exercise of Example 7 of the BVP tutorial.
  %   The boundary conditions at x = d are that y and y' have values yatd and 
  %   ypatd obtained from series expansions. The unknown parameter p = y(0) 
  %   is used in the expansions. y''(d) also appears in the expansions.  
  %   It is evaluated as a limit in the differential equation.
    yp2atd = p /(3*epsilon*(p + k));
    yatd = p + 0.5*yp2atd*d^2;
    ypatd = yp2atd*d;
    res = [ yb(1) - 1
            ya(1) - yatd
            ya(2) - ypatd ];
  end % mmbc
  
  % --------------------------------------------------------------------------
 
end  % mmbvp  

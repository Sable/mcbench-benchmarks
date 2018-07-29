function ex9bvp
%EX9BVP  Example 9 of the BVP tutorial.
%   This boundary value problem is the subject of Chapter 8 of 
%   C.C. Lin and L.A. Segel, Mathematics Applied to Deterministic
%   Problems in the Natural Sciences, SIAM, Philadelphia, 1988. 
%   The ODEs
%   
%      v' = (C - 1)/n
%      C' = (vC - min(x,1))/eta
%
%   are solved on the interval [0, lambda].  The boundary conditions 
%   are v(0) = 0, C(lambda) = 1, and continuity of v(x) and C(x) at 
%   x = 1.  Accordingly, this is a three-point BVP that must be 
%   reformulated for solution with the two-point BVP solver BVP4C.  
%   This reformulation involves introducing unknowns y_1(x) for v 
%   and y_2(x) for C on the interval 0 <= x <= 1 and unknowns y_3(x) 
%   for v and y_4(x) for C on 1 <= x <= lambda. A new independent 
%   variable is introduced for the second interval, tau = 
%   (x - 1)/(lambda - 1), so that it also ranges from 0 to 1. The 
%   differential equations for the four unknowns are then solved
%   on the interval [0, 1].  The continuity conditions on v and C
%   become boundary conditions on the new unknowns.  A plot of v(x)
%   and C(x) on [0, lambda] involves plotting the new unknowns over
%   the subintervals.
%
%   The quantity of most interest is the emergent osmolarity Os =
%   1/v(lambda).  The parameters are related to another parameter
%   kappa by eta = lambda^2/(n*kappa^2).  Lin and Segel develop an 
%   approximate solution for Os valid for "small" n.  Here the BVP is
%   solved for a range of kappa when lambda = 2 and n = 0.005.  The
%   computed Os is compared to the approximation of Lin and Segel.

% Copyright 2004, The MathWorks, Inc.

  % Known parameters, visible in nested functions.
  n = 5e-2;
  lambda = 2;

  sol = bvpinit(linspace(0,1,5),[1 1 1 1]);

  fprintf(' kappa    computed Os  approximate Os \n')
  for kappa = 2:5
    eta = lambda^2/(n*kappa^2);    
    % After creating function handles, the new value of eta 
    % will be used in nested functions.
    sol = bvp4c(@ex9ode,@ex9bc,sol);
    
    K2 = lambda*sinh(kappa/lambda)/(kappa*cosh(kappa));
    approx = 1/(1 - K2);
    computed = 1/sol.y(3,end);
    fprintf('  %2i    %10.3f    %10.3f \n',kappa,computed,approx);
  end

  % v and C are computed separately on 0 <= x <= 1 and 1 <= x <= lambda.
  % A change of independent variable is used for the second interval,
  % which must then be undone to obtain the corresponding mesh.
  x = [sol.x sol.x*(lambda-1)+1];
  y = [sol.y(1:2,:) sol.y(3:4,:)];
  
  figure
  plot(x,y(1,:),x,y(2,:),'--')
  legend('v(x)','C(x)')
  title('A three-point BVP.')
  xlabel(['\lambda = ',num2str(lambda),', \kappa = ',num2str(kappa),'.'])
  ylabel('v and C')
  
  % --------------------------------------------------------------------------
  % Nested functions
  %
  
  function dydx = ex9ode(x,y)
  %EX9ODE  ODE function for Example 9 of the BVP tutorial.
    dydx = [ (y(2) - 1)/n
             (y(1)*y(2) - x)/eta 
             (lambda - 1)*(y(4) - 1)/n
             (lambda - 1)*(y(3)*y(4) - 1)/eta ];
  end % ex9ode
  
  % --------------------------------------------------------------------------
  
  function res = ex9bc(ya,yb)
  %EX9BC  Boundary conditions for Example 9 of the BVP tutorial.
    res = [ ya(1)
            yb(4) - 1
            yb(1) - ya(3)
            yb(2) - ya(4)];
  end % ex9bc
  
  % --------------------------------------------------------------------------
  
end  % ex9bvp


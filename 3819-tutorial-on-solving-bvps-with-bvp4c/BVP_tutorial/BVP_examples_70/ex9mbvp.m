function ex9mbvp
%EX9MBVP  Example 9 of the BVP tutorial, solved as a multi-point BVP
%   This boundary value problem is the subject of Chapter 8 of 
%   C.C. Lin and L.A. Segel, Mathematics Applied to Deterministic
%   Problems in the Natural Sciences, SIAM, Philadelphia, 1988. 
%   The ODEs
%   
%      v' = (C - 1)/n
%      C' = (vC - min(x,1))/eta
%
%   are solved on the interval [0, lambda]. The boundary conditions 
%   are v(0) = 0, C(lambda) = 1, and continuity of v(x) and C(x) at 
%   x = 1.  Example EX9BVP shows how this three-point BVP is
%   reformulated for solution with BVP4C present in MATLAB 6.0.
%   Starting with MATLAB 7.0, BVP4C solves multi-point BVPs directly.
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
  
  % Initial mesh - duplicate the interface point x = 1.
  xinit = [0, 0.25, 0.5, 0.75, 1, 1, 1.25, 1.5, 1.75, 2];   lambda = 2;

  sol = bvpinit(xinit,[1 1]);

  fprintf(' kappa    computed Os  approximate Os \n')
  for kappa = 2:5
    eta = lambda^2/(n*kappa^2);    
    % After creating function handles, the new value of eta 
    % will be used in nested functions.
    sol = bvp4c(@ex9mode,@ex9mbc,sol);
    
    K2 = lambda*sinh(kappa/lambda)/(kappa*cosh(kappa));
    approx = 1/(1 - K2);
    computed = 1/sol.y(1,end);
    fprintf('  %2i    %10.3f    %10.3f \n',kappa,computed,approx);
  end

  figure
  plot(sol.x,sol.y(1,:),sol.x,sol.y(2,:),'--')
  legend('v(x)','C(x)')
  title('A three-point BVP.')
  xlabel(['\lambda = ',num2str(lambda),', \kappa = ',num2str(kappa),'.'])
  ylabel('v and C')
  
  % --------------------------------------------------------------------------
  % Nested functions
  %
  
  function dydx = ex9mode(x,y,region)
  %EX9MODE  ODE function for Example 9 of the BVP tutorial. 
  % Here the problem is solved directly, as a three-point BVP.
    dydx = zeros(2,1);
    dydx(1) = (y(2) - 1)/n;
    % The definition of C'(x) depends on the region.
    switch region
      case 1    % x in [0 1]
        dydx(2) = (y(1)*y(2) - x)/eta; 
      case 2    % x in [1 lambda]
        dydx(2) = (y(1)*y(2) - 1)/eta; 
    end
  end % ex9mode
  
  % --------------------------------------------------------------------------
  
  function res = ex9mbc(YL,YR)
  %EX9MBC  Boundary conditions for Example 9 of the BVP tutorial.
  % Here the problem is solved directly, as a three-point BVP.
    res = [ YL(1,1)             % v(0) = 0
            YR(1,1) - YL(1,2)   % continuity of v(x) at x = 1
            YR(2,1) - YL(2,2)   % continuity of C(x) at x = 1
            YR(2,end) - 1    ]; % C(lambda) = 1
  end % ex9mbc
  
  % --------------------------------------------------------------------------
  
end  % ex9mbvp


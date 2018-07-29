function [x,F,JAC,EXITFLAG] = NewtonRaphson(FUN,x,lambda, maxIter ,Display)
%NewtonRaphson solves a system of nonlinear equations via newton method 
%
%   NewtonRaphson solves equations of the form:
%             
%   F(X) = 0    where F and X may be scalars or vectors
%
%  NewtonRaphson implements the damped newton method with adaptive step
%  size. Theory and discussion can be found here:
%  http://forum.vis.ethz.ch/showthread.php?13434-Damped-Newton-method-Schrittweitensteuerung
%
%  The Jacobian is calculated numerically by a simple forward differential 
%  method. Find more here:
%  http://en.wikipedia.org/wiki/Numerical_differentiation
%
%  The error estimation ist made by root-mean-square
%  http://en.wikipedia.org/wiki/Root_mean_square
%
%
%   x = NewtonRaphson(FUN,X0) starts at the initial guess X0 and tries to 
%    solve the equations in FUN. FUN is a function handle and has to accept
%    input x and return a vector of equation values F evaluated at x.
%    Default values for solver and display setting.
%    
%   x = NewtonRaphson(FUN,X0,lambda) starts at the initial guess X0 and tries to 
%    solve the equations in FUN with user supplied initial relaxation factor. Might
%    be useful to increase solution speed.
%   default value: lambda = 0.1
%
%   x = NewtonRaphson(FUN,X0,lambda,maxIter) ...
%    User supplied maximum number of iterations
%    default value: maxIter = 100
%
%   x = NewtonRaphson(FUN,X0,lambda,maxIter,Display) ...
%    Display options: 
%         'on' - full output during solution process
%         'off' - hide output
%    default value: maxIter = 'off'
%
%  OUTPUT Arguments:
%   x - Solution
%   F - Value at x
%   Jac - Jacobian at x
%   Exitflat: exit conditions of damped newton
%     1: all ok. Solution found
%     -1: no solution found
%     -2: FUN is not a function handle 
%
%   To enter Demo Mode start without any arguments
%     NewtonRaphson();
%  
%   Examples:
%
%  Find zero of function atan(x)
%
%   create function handle (here as an anonymous function)
%  F = @(x)atan(x);
%  x0 = 5; % start value /initial guess
%
%  x = NewtonRaphson(F,x0,1); 
%  
%  Find solution of following system of equations (same as in fsolve help)
%  F = @(x)[2*x(1) - x(2) - exp(-x(1));
%      -x(1) + 2*x(2) - exp(-x(2))];
%  x0 = [1;2];
%
%  x = NewtonRaphson(F,x0,0.1,100,'on');
%
%  Open Issues:
%   - At least some input error checks have to be done... I'm so lazy...
%   - correct some wording/grammar/spelling
% 
% Author: Andi S. 2013

% Check Input arguments / find more at help nargin
if nargin < 5, Display = 'off'; end
if nargin < 4, maxIter = 100; end
if nargin < 3, lambda  = .1; end


if(nargin==0)
    disp('Demo-Mode on f(x) = atan(x)');
    FUN = @(x)atan(x);
    x = 5; % initial guess
    Display = 'on';
    % maximum number of iterations 
    maxIter = 100;    
    % Initial relaxation factor
    lambda = 1.; 
    
end

% check for Input Arguments error
if(~isa(FUN,'function_handle'))
    disp('FUN must be a function handle.');
    x = 0; F = 0; JAC = 0; EXITFLAG = -2;
    return
end

% -------------------------------------------------------------------------
% Solver settings
% -------------------------------------------------------------------------
% Estimate problem size
N = length(x);

% Minimal relaxation factor
Lmin = 1e-10;

% Convergence Criteria
ConvCrit = 1e-6;

% Allocate Memory for Jacobian
JAC = zeros(N);

% -------------------------------------------------------------------------
% Solution
% -------------------------------------------------------------------------

% First Newton Step
% get first Values for x
F = FUN(x);

% numerical Jacobian
for i = 1:N
    xtemp = x;
    h = sqrt(eps)*x(i);
    xtemp(i) = xtemp(i)+h;
    JAC(i,:) = (FUN(xtemp)-F)./h;
end

% calculate step size
s = (JAC\-F);

% first newton step 
x = x + lambda*s; 
F = FUN(x);
err = sqrt(sum(F.^2)/N);

n = 0; % Iteration counter 

if(strcmp(Display,'on'));
    fprintf('n: %i rlx fac: %e error: %e x: ',n,lambda,err);
    fprintf(repmat('%e ',1,N),x);
    fprintf('\n');
end

while( err > ConvCrit && n < maxIter) 
    
    n = n+1;
    
    % calculate Jacobian 
    for i = 1:N
        xtemp = x;
        h = sqrt(eps)*x(i);
        xtemp(i) = xtemp(i)+h;
        JAC(i,:) = (FUN(xtemp)-F)./h;
    end


    sTemp = (JAC\-F);

    % Find optimal step size
    
    if(~(max(abs(lambda * sTemp)) < max(abs(s)) )) 
        
        % step size is not gettin' shorter. So we decrease relaxation factor
        while( ( max(abs(s)) < max(abs(lambda * sTemp))))
        
            % till step size decreases
            lambda = lambda / 2;
            if( lambda < Lmin )
                fprintf('Damping to strong. No convergence.\n');
                return; 
            end
        end % step size is ok now
    end
    
    % next newton step
    s = sTemp; 
    x = x + lambda*s;
    F = FUN(x);
    
    lambda = min( 1., lambda * 2);% increase relaxation factor

    err = sqrt(sum(F.^2)/N);
 
  if(strcmp(Display,'on'));
    fprintf('n: %i rlx fac: %e error: %e x: ',n,lambda,err);
    fprintf(repmat('%e ',1,N),x);
    fprintf('\n');
  end
   
  
end % End of while loop

% -------------------------------------------------------------------------
% Some Postprocessing
% -------------------------------------------------------------------------
if(n<maxIter)
    if(strcmp(Display,'on'));
        disp('Solver converged.');
    end
    EXITFLAG = 1;
else
    if(strcmp(Display,'on'));
        disp('No Solution found... Sorry.');
    end
    EXITFLAG = -1;
end

end

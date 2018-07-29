function [x val]=gradient_descent(func,x, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function finds the local minima of a function.
% 
% The first output of the function should be the function value whereas the
% second should be the gradient
% 
% Inputs:
% func :		the function in which to be optimised over, must
%			return value as first argument and gradient as second
% x    : 		starting point to begin optimisation
% gamma (optional) : 	minimising parameter, small values will get to the 
%                    	local maxima, slowly whereas bigger parameters will
%                    	be faster but might overshoot (default 0.2)
% iter (optional)  : 	Number of iterations over which it is optimised
%                    	(default 100)
% thresh (optional): 	stopping criteria for which the function is not 
%                    	minimised any more. (default 1e-6)
% display (optional): 	Whether or not to display ouput of iteration, 
%                     	function value, and change (default 1)
%
% Outputs:
% x: 			locally optimised location
% val: 			f(x) i.e. the function value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Defaults
gamma=0.2;
iter=100;
thresh=1e-6;
display= 0;

switch nargin    
    case 2
        % Do nothing
    case 3
        gamma=varargin{1};
    case 4
        gamma=varargin{1};
        iter=varargin{2};
    case 5
        gamma=varargin{1};
        iter=varargin{2};
        thresh=varargin{3};
    case 6
        gamma=varargin{1};
        iter=varargin{2};
        thresh=varargin{3};
        display= varargin{4};
    otherwise
        error ('Unexpected number of inputs');
end
 
if display
    fprintf('iter \tf(x) \t||x-xold|| \t||gradient||\n');
end
for i=1:iter
    [val grad]=func(x);
    xnew=x-gamma*grad;		%descend along gradient
    change=norm(xnew-x,2);	%calculate how much the x value has changed
    x=xnew;
    if display
        fprintf('%i\t%.3f\t%.3f\t%.3f\n',i,val,change,norm(grad,2));
    end
    if change<thresh		%if change is really small
        fprintf('Stopped since ||x-xold|| is less than threshold\n');
        break;			%stop
    end
end

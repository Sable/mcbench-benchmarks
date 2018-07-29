function mb_levenbergMarquardt

% 2010 m.bangert@dkfz.de
% solving a toy problem f(x,y) = x^4 + x*y + (1+y)^2 using the Levenberg
% Marquart strategy to enfore positive definite hessian matrices
%
% example : mb_levenbergMarquart (function does not take any argument)

fprintf(['\nLevenberg Marquardt algorithm on toy problem\n\n' ...
           'f(x,y) = x^4 + x*y + (1+y)^2\n\n']);
       
% specify sarting point (note: x(1) = 0 is interesting)
x       = [0 5]'; % starting value for parameters

% plot data
close all
figure
hold on
res   = .1;
limit = 10;
[X Y] = meshgrid(-limit:res:limit,-limit:res:limit);
Z     = X.^4+X.*Y+(1+Y).^2;
contour(X,Y,Z,[0:5:100])
plot3(x(1),x(2),0,'k.','MarkerSize',10);
       
% 1st calculation of objective function and gradient
objFunc         = @(x) x(1).^4 + x(1).*x(2) + (1+x(2)).^2;
objFuncValue    = objFunc(x);
oldObjFuncValue = objFuncValue + 1;
gradFunc        = @(x) [4*x(1) + x(2); x(1) + 2 + 2*x(2)];
dx              = gradFunc(x);
hessianFunc     = @(x) [ 12*x(1) 1;1 2]; % precise hessian

% lamba is the levenberg marquart damping factor to enforce positive
% definite hessian matrices...
lambda          = 10;
H               = hessianFunc(x) + lambda*eye(2);

% iterate
iter      = 0;
numOfIter = 100;
prec      = 1e-5;

% convergence if gradient smaller than prec, change in objective function
% smaller than prec or maximum number of iteration reached...
while iter < numOfIter && abs((oldObjFuncValue-objFuncValue)/objFuncValue)>prec && norm(dx)>prec
    
    % increment iteration counter
    iter = iter + 1;
    
    % remember old objective function value
    oldObjFuncValue = objFuncValue;   
    
    % 1 obtain search direction
    dir = -(H\dx); % this is the efficient matlab notation for -inv(H)*dx
    
    % 2.1 linesearch to to find acceptable stepsize alpha
    alpha = mb_backtrackingLineSearch(objFunc,objFuncValue,x,dx,dir);
        
    % 2.2 update x
    x = x + alpha*dir;
    
    % update objective function
    objFuncValue = objFunc(x);
    
    % recalculate gradient
    dx = gradFunc(x);
    
    % update hessian
    H = hessianFunc(x) + lambda*eye(2); % there might be strategies to adjust lambda while iterating...?!
    
    fprintf(1,'# %d: alpha = %1.6f, OF = %f (grad = %f)\n',iter,alpha,objFuncValue,norm(dx));
    
    % plot
    plot3(x(1),x(2),0,'k.','MarkerSize',10);
    drawnow;
    
end

fprintf(['\n' num2str(iter) ' iteration(s) performed to converge\n'])
fprintf(1,'Final solution: x=(%f,%f)\n',x(1),x(2));

end



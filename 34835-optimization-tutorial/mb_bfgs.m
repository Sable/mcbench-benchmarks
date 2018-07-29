function mb_bfgs

% 2010 m.bangert@dkfz.de
% fitting a gaussian distribution to data with a quasi newton method using
% a bfgs or sr1 update for the hessian matrix
%
% example : mb_bfgs (function does not take any argument)

% set options
mode          = 'BFGS'; % update rule for hessian: either 'SR1' or 'BFGS'
visLineSearch = 1;
visBool       = 1;

fprintf(['\nFitting a gaussian distribution to data ...\n' ...
           'Using ' mode ' Hessian update\n']);

% sample data from a gaussian distribution
randn('seed',12345); % set the seed of the random number generator - if you do not want to do that comment...
numOfSamples = 250;
data(:,1)    = linspace(-2,4,numOfSamples) + 6/numOfSamples*randn(1,numOfSamples);
data(:,2)    = exp(-(linspace(-2,4,250)-1.5).^2) + .05*randn(1,250);

% plot data
if visBool
    close all
    figure
    hold on
    plot(data(:,1),data(:,2),'b+')
    xlabel('X')
    ylabel('Y')
    visHandle = [];
end

% specify input
x       = [1 1 1]'; % starting value for parameters
H       = eye(3);   % initial hessian approximation
       
% 1st calculation of objective function and gradient
objFunc         = @(x) sum((x(3).*exp(-(data(:,1)-x(1)).^2./x(2))-data(:,2)).^2);
objFuncValue    = objFunc(x);
oldObjFuncValue = objFuncValue + 1;
dx              = mb_numDiff(objFunc,x);

% iterate
iter      = 0;
numOfIter = 100;
prec      = 1e-5;

% convergence if gradient smaller than prec, change in objective function
% smaller than prec or maximum number of iteration reached...
while iter < numOfIter && abs((oldObjFuncValue-objFuncValue)/objFuncValue)>prec && norm(dx)>prec
    
    % increment iteration counter
    iter = iter + 1;
    
    % remember odl objective function value
    oldObjFuncValue = objFuncValue;
    
    % implementation of BFGS according to
    % http://en.wikipedia.org/wiki/BFGS_method
    % numbers corresponds 
    
    % 1 obtain search direction
    dir = -(H\dx); % this is the efficient matlab notation for -inv(H)*dx
    
    % 2.1 linesearch to to find acceptable stepsize alpha
    %alpha = mb_backtrackingLineSearch(objFunc,objFuncValue,x,dx,dir);
    alpha = mb_nocLineSearch(objFunc,@(x) mb_numDiff(objFunc,x),x,dir,dir'*dx,objFuncValue);

    % 3
    p = alpha*dir;

        % visualize the line search (optional) used for debugging
        if visLineSearch
            figure
            hold on
            alphas   = linspace(0,2*alpha,100);
            alphaVis = NaN*alphas;
            for i = 1:100
                alphaVis(i) = objFunc(x+alphas(i)*dir);
            end
            plot(alphas,alphaVis,'b') % function in direction of line search
            plot(alpha,objFunc(x+alpha*dir),'r.') % the steplength found
            plot(alphas,objFuncValue + 1e-1*alphas*(dir'*dx),'g') % constraint
            pause(.5)
            close
        end
        
    % 2.2 update x
    x = x + p;
    
    % update objective function (and remember old objective function to
    % check for convergence)
    objFuncValue = objFunc(x);
    
    % 4 calculate difference of gradients
    dx_old = dx;
    dx     = mb_numDiff(objFunc,x);
    q      = dx-dx_old;
    
    % update hessian
    if strcmp(mode,'BFGS')
        H = H + (q*q')/(q'*p) - ((H*p)*(H*p)')/(p'*H*p);
    elseif strcmp(mode,'SR1')
        H = H + ((q-H*p)*(q-H*p)')/((q-H*p)'*p);
    end
    
    % update function with new x and plot
    if visBool
        pause(0.5)
        fitFunc = @(t) x(3).*exp(-(t-x(1)).^2./x(2));
        delete(visHandle);
        visHandle = plot(data(:,1),fitFunc(data(:,1)),'r','LineWidth',4);
        drawnow;
    end
    
    fprintf(1,'Iteration %d: alpha_min=%f, OF=%f\n',iter,alpha,objFuncValue);
    
end

fprintf(['\n' num2str(iter) ' iteration(s) performed to converge\n'])

fprintf(1,'Final solution: x=(%f,%f,%f)\n',x(1),x(2),x(3));

end



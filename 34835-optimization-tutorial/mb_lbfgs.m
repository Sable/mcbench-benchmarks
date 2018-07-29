function mb_lbfgs

% 2010 m.bangert@dkfz.de
% fitting a gaussian distribution to data with a quasi newton method using
% a lbfgs update for the inverse hessian matrix
%
% example : mb_bfgs (function does not take any argument)

% options
visLineSearch = 1;
visBool       = 1;

% sample data from a gaussian distribution
randn('seed',12345); %set the seed of the random number generator - if you do not want to do that comment...
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
mem          = 10;        % number of past gradients and function values used for inverse hessian contruction
x            = NaN*ones(3,mem);
x(:,1)       = [1 1 1]';  % starting value for parameters
objFuncValue = NaN*ones(1,mem);
dx           = NaN*ones(3,mem);

s_k = ones(3,mem-1);
y_k = ones(3,mem-1);
r_k = ones(mem-1,1);
a_k = ones(1,mem-1);

fprintf(['\nFitting a gaussian distribution to data with an L-BFGS-B algorithm...\n\n']);

% 1st calculation of objective function and gradient
objFunc         = @(x) sum((x(3,1).*exp(-(data(:,1)-x(1,1)).^2./x(2,1))-data(:,2)).^2);
objFuncValue(1) = objFunc(x(:,1));
objFuncValue(2) = objFuncValue(1) + 1;
dx(:,1)          = mb_numDiff(objFunc,x(:,1));

% iterate
iter      = 0;
numOfIter = 100;
prec      = 1e-5;

% convergence if gradient smaller than prec, change in objective function
% smaller than prec or maximum number of iteration reached...
while iter < numOfIter && abs((objFuncValue(2)-objFuncValue(1))/objFuncValue(1))>prec && norm(dx(:,1))>prec
    
    % implementation of L-BFGS according to
    % http://en.wikipedia.org/wiki/L-BFGS
    
    % inverse hessian update
    q = dx(:,1);
    for i = 1:min(iter,mem-1)
        a_k(i) = r_k(i)*s_k(:,i)'*q;
        q      = q - a_k(i)*y_k(:,i);
    end
    z = s_k(:,1)'*y_k(:,1)/(y_k(:,1)'*y_k(:,1))*q; % this corresponds to H*q where H is approximated as described in Nocedal 9.1
    for i = min(iter,mem-1):-1:1
        b = r_k(i)*y_k(:,i)'*z;
        z = z + s_k(:,i)*(a_k(i)-b);
    end
    
    % obtain search direction
    dir = -z;
    
    % 2.1 armijo linesearch to to find acceptable stepsize alpha
    alpha = mb_backtrackingLineSearch(objFunc,objFuncValue(1),x(:,1),dx(:,1),dir);
    
    % 3
    p = alpha*dir;
    
        % visualize the line search (optional) used for debugging
        if visLineSearch
            figure
            hold on
            alphas   = linspace(0,2*alpha,100);
            alphaVis = NaN*alphas;
            for i = 1:100
                alphaVis(i) = objFunc(x(:,1)+alphas(i)*dir);
            end
            plot(alphas,alphaVis,'b') % function in direction of line search
            plot(alpha,objFunc(x(:,1)+alpha*dir),'r.') % the steplength found
            plot(alphas,objFuncValue(1) + 1e-1*alphas*(dir'*dx(:,1)),'g') % constraint
            pause(.5)
            close
        end
        
    % 2.2 update x
    x(:,2:end) = x(:,1:end-1);
    x(:,1)     = x(:,1) + p;
    s_k        = -diff(x,[],2);
    
    % update objective function (and remember old objective function to
    % check for convergence)
    objFuncValue(2) = objFuncValue(1);
    objFuncValue(1) = objFunc(x(:,1));
        
    % increment iteration counter
    iter = iter + 1;
    
    fprintf(1,'Iteration %d: alpha_min=%f, OF=%f\n',iter,alpha,objFuncValue(1));
    
    % calculate difference of gradients
    dx(:,2:end) = dx(:,1:end-1);
    dx(:,1)     = mb_numDiff(objFunc,x(:,1));
    y_k         = -diff(dx,[],2);

    r_k = 1./diag(y_k'*s_k);

    % update function with new x and plot
    if visBool
        pause(0.5)
        fitFunc = @(t) x(3).*exp(-(t-x(1)).^2./x(2));
        delete(visHandle);
        visHandle = plot(data(:,1),fitFunc(data(:,1)),'r','LineWidth',4);
        drawnow;
    end
    
end

fprintf(['\n' num2str(iter) ' iteration(s) performed to converge\n'])

fprintf(1,'Final solution: x=(%f,%f,%f)\n',x(1),x(2),x(3));

end


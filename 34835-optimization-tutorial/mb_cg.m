function mb_cg

% 2010 m.bangert@dkfz.de
% conjugate gardient algorithm implented for two toy problems - it is
% possible to experiment with different line searching techniques and
% updates of search directions
%
% example : mb_cg (function does not take input arguments)

% quadratic 9.3.1
A        = [6 1 2;1 1 -2;2 -2 8];
b        = [2;-1;-2];
objFunc  = @(x) .5*x'*A*x + x'*b;
gradFunc = @(x) A*x + b;
x        = [0;0;0];

% rosenbrock 9.3.2
% f     = @(x) (1-x(1)).^2 + 100*(x(2)-x(1).^2).^2;
% gradf = @(x) [-2*(1-x(1))-200*x(1).*(x(2)-x(1).^2);200*(x(2)-x(1).^2)];
% x_0   = [-1;-1];


visLineSearch = 1;

% note in rasmussen uses uses polak update with inaxact line search for
% minimize -> http://www.kyb.tuebingen.mpg.de/bs/people/carl/code/minimize/
mode       = 'fletcher'; % 'fletcher', 'hestenes' or 'polak'
linesearch = 'quadratic'; % 'armijo', 'quadratic' or 'exact'

if numel(x) == 2 % optional visualization for the roenbrock problem
    close all
    figure
    hold on
    limits = 2*[-1 1];
    n = 100;
    Z = NaN*ones(n);
    [X Y] = meshgrid(linspace(limits(1),limits(2),n));
    for i = 1:n
        for j = 1:n
            Z(i,j) = objFunc([X((i-1)*100+1);Y(j)]);
        end
    end
    contour(X,Y,Z,[1:3:20 50:30:300])
    plot(x(1),x(2),'k.','MarkerSize',25)
end

objFuncValue    = objFunc(x);
oldObjFuncValue = objFuncValue + 1;

% implementation according to nocedal 5.2 algorithm 5.4 (FR-CG)
% polak and hestenes updates for beta can be found in the same section
dx  = gradFunc(x);
dir = -dx;

% iterate
iter      = 0;
numOfIter = 100;
prec      = 1e-5;

% convergence if gradient smaller than prec, change in objective function
% smaller than prec or maximum number of iteration reached...
while iter < numOfIter && abs((oldObjFuncValue-objFuncValue)/objFuncValue)>prec && norm(dx)>prec
    
    % iteration counter
    iter = iter + 1;
    
    if strcmp(linesearch,'armijo')
        alpha = mb_backtrackingLineSearch(objFunc,objFuncValue,x,dx,dir);
    elseif strcmp(linesearch,'exact')
        maxStepLength  = 2;
        linesearchFunc = @(delta) objFunc(x+delta*dir);
        alpha          = fminbnd(linesearchFunc,0,maxStepLength); % matlab inherent function to find 1d min
    elseif strcmp(linesearch,'quadratic')
        alpha = mb_quadraticApproximationLineSearch(objFunc,objFuncValue,x,dx,dir);
    end
        
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
        
    % update x
    x = x + alpha*dir;

    % update obj func values
    oldObjFuncValue = objFuncValue;
    objFuncValue    = objFunc(x);
    
    % update dx
    oldDx = dx;
    dx    = gradFunc(x);
        
    if strcmp(mode,'fletcher')
        beta = (dx'*dx)/(oldDx'*oldDx);
    elseif strcmp(mode,'hestenes')
        beta = (dx'*(dx-oldDx))/((dx-oldDx)'*dir);
    elseif strcmp(mode,'polak')
        beta = (dx'*(dx-oldDx))/(oldDx'*oldDx);
    end
    
    % update search direction
    dir = -dx + beta*dir;
    
    % visualization for rosenbrock problem
    if numel(x) == 2
        plot(x(1),x(2),'k.','MarkerSize',25)
        drawnow;
    end
    
    fprintf(['Iteration ' num2str(iter) ' - Obj Func = ' num2str(objFuncValue) ' @ x = [' num2str(x') ']\n']);
    
end

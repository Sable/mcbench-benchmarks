function [y, details] = newton(functionf, dfunctionf, yest, yold, ...
                               tolabs, tolrel, maxit, printConsole)
%newton Newton iteration with Armijo step control for the nonlinear function 
% and Jacobi. Starting from an estimate yest the function computes with a newton
% iteration the solution matrix y of f(y)=0 up to 
% tol = tolrel*||f(y)||+tolabs. 
%
% Call:   [matrix scalar scalar] = 
%                newton(matrix, matrix, scalar, scalar, scalar, structure)
% Input:  matrix yest, size(yest) = (M,N) - estimate of the solution
% Input:  matrix yold, size(yold) = size(y) - parameter of fideq and dfideq
%         (state at previous time level)
% Input:  scalar tolabs>0 - absolute tolerance
% Input:  scalar tolrel>0 - relative tolerance
% Input:  scalar maxit>=1 - maximal number of iterations 
% Input:  printConsole - > 0: print iteration information on console output
% Output: matrix y, size(y) = (M,N) - solution
% Output: scalar res, residuum ||f(y)||
% Output: scalar iter, number of iterations
%
% Author: Raimund Wegener, Stefan Schießl
% Date: 12.10.2011

if (nargin < 8)
    printConsole = 1;
end

%%
% initialization
sigma = 1e-2; alpha = 0.5; lambda = 1;

y = yest; f = functionf(y,yold); psi = 0.5*f(:)'*f(:); res = sqrt(2*psi);
tol= tolrel * res + tolabs;

%% 
%iteration 
[M,N] = size(y); 
iter = 0;
% Flag for the message text
armijoMessage = '';
while (res > tol) && (iter < maxit)
    [i,j,S] = dfunctionf(y); 
    dfdy = sparse(i,j,S,M*N,M*N);  
    % '\' only gives a warning for singular matrices, generate an error
    % for that.
    lastwarn('');
    % bandden:  backslash uses band solver if band density is > bandden.
    % if bandden = 1.0, never use band solver, if bandden = 0.0, always use
    % band solver.
    spparms('bandden',0); 
    del = -dfdy\f(:);
    assert(~strcmp(lastwarn, 'Matrix is singular to working precision.'), ...
        'Step:NotSolvable', 'Matrix is singular to working precision.'); 
    assert(~strcmp(lastwarn, 'Matrix is close to singular or badly scaled.'), ...
        'Step:NotSolvable', 'Matrix is close to singular or badly scaled.'); 
    
    y_ = y + del; 
    f_ = functionf(y_,yold); 
    psi_ = 0.5*f_(:)'*f_(:);
    if (psi_ > (1-2*sigma)*psi)
        lambda = min(lambda/alpha,1);
        y_ = y + lambda*del; f_ = functionf(y_,yold); psi_ = 0.5*f_(:)'*f_(:);
        while psi_ > (1-2*sigma*lambda)*psi
            lambda = lambda*alpha;  
            % step control with Armijo rule
            y_ = y + lambda*del; f_ = functionf(y_,yold); psi_ = 0.5*f_(:)'*f_(:);

        end
        armijoMessage = ['newton/armijo: iter=' num2str(iter) ',\t lambda=' num2str(lambda) '\n'];
        if (printConsole > 1)
            fprintf(armijoMessage)
        end
    end
    
    y = y_; f = f_; psi = psi_; res = sqrt(2*psi);
    iter = iter + 1;
end
message = ['newton: res=' num2str(res) ', iter=' num2str(iter) '\n' armijoMessage];
if (printConsole > 0)
    fprintf(message)
end

if (isnan(res))
   error('Newton:NoConvergence', 'No solution found.'); 
end

if (res > tol)
   error('Newton:AccuracyNotReached', ['newton/armijo: Results are inaccurate (Res: ' num2str(res) ').']); 
end

details.res = res;
details.iter = iter;
details.message = message;

end

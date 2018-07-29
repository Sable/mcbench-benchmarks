function alpha = mb_backtrackingLineSearch(objFunc,objFuncValue,x,dx,dir)

% 2010 m.bangert@dkfz.de
% backtracking line search using armijo criterion
%
% objFunc      - handle for objective function
% objFuncValue - current objective function value @ x
% x            - x
% dx           - dx
% dir          - search direction
%
% example : mb_backtrackingLineSearch(objFunc,objFuncValue,x,dx,dir)

alphaMax     = 1; % this is the maximum step length
alpha        = alphaMax;
fac          = 1/2; % < 1 reduction factor of alpha
c_1          = 1e-1;

while objFunc(x+alpha*dir) > objFuncValue + c_1*alpha*dir'*dx;

    alpha = fac*alpha;
    
    if alpha < 10*eps
        error('Error in Line search - alpha close to working precision');
    end
    
end

end
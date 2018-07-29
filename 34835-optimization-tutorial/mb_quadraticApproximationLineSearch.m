function alpha = mb_quadraticApproximationLineSearch(objFunc,objFuncValue,x,dx,dir)

% 2010 m.bangert@dkfz.de
% line search using a quadratic approximation we are setting to minimum of
% the quadratic function phi(t) = a*t^2+b*t+c which is determined by three 
% points: objFunc(x), gradFunc'(x) and objFunc(x+alpha*dir)
%
% objFunc      - handle for objective function
% objFuncValue - current objective function value @ x
% x            - x
% dx           - dx
% dir          - search direction
%
% example : mb_backtrackingLineSearch(objFunc,objFuncValue,x,dx,dir)

alpha = 1.5;

c     = objFuncValue;
b     = (dir'*dx);
a     = ( objFunc(x+alpha*dir) - b*alpha - c) / ...
             alpha^2;
        
alpha = - b / (2*a);

numOfQuadApprox = 0;
c_1             = 1e-1;
% check if armijo criterion fullfilled
while objFunc(x+alpha*dir) > objFuncValue + c_1*alpha*dir'*dx;

    numOfQuadApprox = numOfQuadApprox + 1;
    
    a     = ( objFunc(x+alpha*dir) - b*alpha - c) / ...
             alpha^2;
    alpha = - b / (2*a);

    if numOfQuadApprox > 10
        warning(['Error in Line search - quadraric approximation failed more than 10 times\n' ...
                 'Starting backtracking line search\n']);
        alpha = mb_backtrackingLineSearch(objFunc,objFuncValue,x,dx,dir);
        return;             
    end
    
end

end
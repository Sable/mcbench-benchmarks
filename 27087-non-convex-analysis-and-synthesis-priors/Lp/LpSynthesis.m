function beta = LpSynthesis(H, Ht, y, p, normfac, err, insweep, tol, decfac)

% Algorithm for solving problems of the form:
% min ||x||_p s.t. ||y-Hx||_2 < err

% Inputs
% H - Forward Transform
% Ht - Backward Transform
% y - collected data
% p - non-convex norm
% normfac - highest singular value of A (default 1)
% err - two norm mismatch (default 1e-6)
% insweep - number of sweeps for internal loop (default 50)
% decfac - lambda decrease factor for outside loop (default 0.5)
% tol - tolerance for convergence (default 1e-4)
% tol - tolerance for convergence

% copyright (c) Angshul Majumdar 2010

if nargin < 4
    p = 1;
end
if nargin < 5
    normfac = 1;
end
if nargin < 6
    err = 1e-6;
end
if nargin < 7
    insweep = 50;
end
if nargin < 8
    tol = 1e-4;    
end
if nargin < 9
    decfac = 0.5;
end

x_initial = Ht(y);
alpha = 1.1*normfac;
x = x_initial;

lambdaInit = decfac*max(abs(Ht(y))); lambda = lambdaInit;

f_current = norm(y-H(x_initial)) + lambda*norm(x,p);

while lambda > lambdaInit*tol
    w = ones(length(x),1);
    for ins = 1:insweep
        f_previous = f_current;
        x = SoftTh(x + (Ht(y - H(x)))/alpha, w.*lambda/(2*alpha));
        w = abs(x).^(p-1);
        f_current = norm(y-H(x)) + lambda*norm(x,p);
        
        if norm(f_current-f_previous)/norm(f_current + f_previous)<tol
            break;
        end
    end
%     norm(y-H(x))
    if norm(y-H(x))<err
        break;
    end
    lambda = decfac*lambda;
end
beta = x;

    function  z = SoftTh(s,thld)
        z = sign(s).*max(0,abs(s)-thld); 
    end
end
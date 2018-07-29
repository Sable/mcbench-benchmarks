function beta = LpAnalysis(H, Ht, A, At, y, p, normfac, err, insweep, decfac, tol)

% Algorithm for solving problems of the form:
% min ||Ax||_p s.t. ||y-Hx||_2 < err

% Inputs
% A - Sparsifying Forward Transform
% At - Sparsifying Backward Transform
% H - Forward Measurement Operator
% Ht - Backward Measurement Operator
% y - collected data
% p - non-convex norm
% normfac - highest singular value of A (default 1)
% err - two norm mismatch (default 1e-6)
% insweep - number of sweeps for internal loop (default 50)
% decfac - lambda decrease factor for outside loop (default 0.5)
% tol - tolerance for convergence (default 1e-4)

% copyright (c) Angshul Majumdar 2010

c = 1.1;

if nargin < 6
    normfac=1;
end
if nargin < 7
    p = 1;
end
if nargin < 8
    err = 1e-6;
end
if nargin < 9
    insweep = 50;
end
if nargin < 10
    decfac = 0.5;
end
if nargin < 11
    tol = 1e-4;
end

alpha = 1.1*normfac;
x_initial = Ht(y);
z_initial = zeros(length(A(x_initial)),1);

x = x_initial; z = z_initial;

lambdaInit = decfac*max(abs(Ht(y))); lambda = lambdaInit;

f_current = norm(y-H(x_initial)) + lambda*norm(A(x),p);

while lambda > lambdaInit*tol
    % debug lambda
    for ins = 1:insweep
        f_previous = f_current;
        
        b = x + (1/alpha)*(Ht(y-H(x)));
        z = (c*z + A(b-At(z)))./((2*alpha/lambda)*(abs(A(x))).^(2-p)+c);
        x = b - At(z);
        
        f_current = norm(y-H(x)) + lambda*norm(A(x),p);
        
        if norm(f_current-f_previous)/norm(f_current + f_previous)<tol
            break;
        end
    end
    if norm(y-H(x))<err
        break;
    end
    lambda = decfac*lambda;
end
beta = x;
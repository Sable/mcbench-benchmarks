function [X,t,mv] = expmv_tspan(A,b,t0,tmax,q,prec,M,shift,force_simple,bal,prnt)
%EXPMV_TSPAN      Exponential of matrix times vector over interval.
%   [X,tvals,mv] = EXPMV_TSPAN(A,b,t0,tmax,q,PREC) computes EXPM(t*A)*b
%   without explicitly forming EXPM(A) for Q+1 >= 2 equally spaced values
%   of T between T0 and TMAX, returning the result in the columns of X:
%   X(:,j) = EXPM(TVALS(j)*A)*b, j = 1:q+1.
%   PREC is the required accuracy, 'double', 'single' or 'half',
%   and defaults to CLASS(A).
%   A total of MV matrix-vector products with A or A^* are used.

%   Reference: A. H. Al-Mohy and N. J. Higham, Computing the action of
%   the matrix exponential, with an application to exponential
%   integrators. MIMS EPrint 2010.30, The University of Manchester, 2010.

%   Awad H. Al-Mohy and Nicholas J. Higham, October 26, 2010.

n = length(A);
if nargin < 11 || isempty(prnt), prnt = false; end
if nargin < 10 || isempty(bal), bal = false; end
if bal
    [D B] = balance(A);
    if norm(B,1) < norm(A,1), A = B; b = D\b; else bal = false; end
end
if nargin < 9 || isempty(force_simple), force_simple = false; end
if nargin < 8 || isempty(shift), shift = true; end
if nargin < 6 || isempty(prec), prec = class(A); end

force_estm = 0; temp = (tmax -t0)*norm(A,1);
if (strcmp(prec,'single') || strcmp(prec,'half') && temp > 85.496) || ...
   (strcmp(prec,'double') && temp > 63.152)
   force_estm = true;
end

if nargin < 7 || isempty(M)
   [M,mv] = select_taylor_degree(A,b,[],[],prec,shift,false,force_estm);
else
   mv = 0;
end

switch prec
    case 'double', tol = 2^(-53);
    case 'single', tol = 2^(-24);
    case 'half',   tol = 2^(-10);
end

X = zeros(n,q+1);
[m_max,pp] = size(M);
U = diag(1:m_max);

[temp,s] = degree_selector(tmax - t0,M);
if prnt, fprintf('q = %g, s = %g\n', q, s), end
h = (tmax - t0)/q;
t = t0:h:tmax;
[X(:,1),temp1,temp2,mvnew] = expmv(t0,A,b,M,prec,shift,false,prnt);
mv = mv + mvnew;
if q <= s || force_simple
    for k = 1:q
        [X(:,k+1),temp1,temp2,mvnew] = ...
        expmv(h,A,X(:,k),M,prec,shift,false,prnt);
        mv = mv + mvnew;
    end
    if prnt, disp('** Easy case **'), end
    if bal, X = D*X; end
    return
end
if prnt, disp('** Hard case **'), end
mu = 0;
if shift
    mu = full(trace(A))/n;
    A = A-mu*speye(n);
end
d = floor(q/s); j = floor(q/d); r = q-d*j;
if prnt, fprintf('d = %g, j = %g, r = %g\n', d, j, r), end
z = X(:,1);
m_opt = degree_selector(d,M);
dr = d;
for i = 1:j+1
    if i > j, dr = r; end
    K = zeros(n,m_opt+1); K(:,1) = z;
    m = 0;
    for k = 1:dr
        f = z; c1 = norm(z,inf);
        for p = 1:m_opt
            if p > m
                K(:,p+1) = (h/p)*(A*K(:,p));
                mv = mv +1;
            end
            temp = (k^p)*K(:,p+1);
            f = f + temp;
            c2 = norm(temp,inf);
            if  c1 + c2 <= tol*norm(f,inf), break, end
            c1 = c2;
        end
        m = max(m,p);
        X(:,k+(i-1)*d+1) = exp(k*h*mu)*f;
    end
    if i <= j, z = X(:,i*d+1); end
end
if bal, X = D*X; end

%---------- Nested function -------------
    function [m ss] = degree_selector(t,M)
        C = (ceil(abs(t)*M))'*U;
        C (C == 0) = inf;
        if pp > 1
            [cost m] = min(min(C));      % cost is the overall cost.
        else
            [cost m] = min(C);
        end
        if cost == inf; cost = 0; end
        ss = max(cost/m,1);
    end
%-----------------------------------------
end

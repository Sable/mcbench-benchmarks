function [out1, out2, out3] = logm_frechet_complex(A,E)
%LOGM_FRECHET_COMPLEX Matrix logarithm and its Frechet derivative in direction E.
%   This code computes the matrix logarithm log(A), 
%   its Frechet derivative in a particular direction E and the condition
%   number of the logarithm. The code is intended for complex A or E.
%   If A and E are real use logm_frechet_real instead, which
%   is optimized to use real arithmetic.
%
%   This code can be called in the following ways:
%   
%   X = logm_frechet_complex(A)
%   L = logm_frechet_complex(A,E)
%   [X, cond] = logm_frechet_complex(A)
%   [X, L] = logm_frechet_complex(A,E)
%   [X, L, cond] = logm_frechet_complex(A,E)
%
%   where X = log(A), cond is an estimate of the associated condition
%   number and L is the Frechet derivative in the direction E.
%    
%   This code is intended for double precision.
%
%   Reference: A. H. Al-Mohy, N. J. Higham and S. D. Relton, Computing the 
%   Frechet Derivative of the Matrix Logarithm and Estimating the Condition 
%   Number, MIMS EPrint 2012.72,
%   The University of Manchester, July 2012.  
%   Name of corresponding algorithm in that paper: Algorithm 5.1
%
%   Awad H. Al-Mohy, Nicholas J. Higham and S. D. Relton, October 3, 2012.

% See what user would like to calculate
n = length(A);
eval_log = false;
eval_fd = false;
eval_cond = false;
if nargin == 1 && nargout <= 1
    eval_log = true;
elseif nargin == 2 && nargout <= 1
    eval_fd = true;
elseif nargin == 1 && nargout == 2
    eval_log = true;
    eval_cond = true;
    E = zeros(n);
elseif nargin == 2 && nargout == 2
    eval_log = true;
    eval_fd = true;
elseif nargin == 2 && nargout == 3
    eval_log = true;
    eval_fd = true;
    eval_cond = true;
else
    error('Invalid combination of inputs and outputs. Use "help logm_frechet"');
end

maxsqrt = 100;
msg_max_sqrt = ['Maximum number of matrix square roots reached: '...
                'answer may not be accurate.\n  Change the value of '...
                'maxsqrt in logm_frechet_complex if required.'];

xvals = [1.586970738772063e-005
         2.313807884242979e-003
         1.938179313533253e-002
         6.209171588994762e-002
         1.276404810806775e-001
         2.060962623452836e-001
         2.879093714241194e-001];

mmax = 7; foundm = false;

% First form complex Schur form (if A not already upper triangular).
if isequal(A,triu(A))
   T = A; Q = eye(n); 
else
   [Q,T] = schur(A,'complex');
end

T0 = T; 

if any( imag(diag(T)) == 0 & real(diag(T)) <= 0 )
   error('A must not have nonpositive real eigenvalues!')
end
p = 0;
s0 = opt_cost(diag(T)); s = s0;
Troots = [];
if s > maxsqrt
   warning('LOGM_FRECHET_COMPLEX:maxsqrt',msg_max_sqrt)
end
for k = 1:min(s,maxsqrt)
    T = sqrtm_tri(T);
    if eval_fd, Troots(:,:,k) = T; end
end

d2 = normAm(T-eye(n),2)^(1/2); d3 = normAm(T-eye(n),3)^(1/3);
alpha2 = max(d2,d3);
if alpha2 <= xvals(2)
   m = find(alpha2 <= xvals(1:2),1); foundm = true;
end

while ~foundm
    more = 0; % more square roots
    if s > s0, d3 = normAm(T-eye(n),3)^(1/3); end
    d4 = normAm(T-eye(n),4)^(1/4);
    alpha3 = max(d3,d4);
    if alpha3 <= xvals(mmax)
        j = find( alpha3 <= xvals(3:mmax),1) + 2;
        if j <= 6
           m = j; break
        else
           if alpha3/2 <= xvals(5) && p < 2
               more = 1; p = p+1;
           end
        end
    end
    if ~more
        d5 = normAm(T-eye(n),5)^(1/5);
        alpha4 = max(d4,d5);
        eta = min(alpha3,alpha4);
        if eta <= xvals(mmax)
            m = find(eta <= xvals(6:mmax),1) + 5;
            break
        end
    end
    if s == maxsqrt
       warning('LOGM_FRECHET_COMPLEX:maxsqrt',msg_max_sqrt)
       m = mmax; break
    end
    T = sqrtm_tri(T); s = s + 1;
    if eval_fd, Troots(:,:,s) = T; end
end

% Compute accurate superdiagonal of T^(1/2^s).
for k = 1:n-1
    T(k,k+1) = powerm2by2(T0(k:k+1,k:k+1),1/2^s);
end

% Compute accurate diagonal of T^(1/2^s) - I.
d = sqrt_power_1(diag(T0),s);
T(1:n+1:end) = d;

% Compute Gaussian quadrature weights and nodes for partial fraction.
[nodes,wts] = gauss_legendre(m);
% Convert from [-1,1] to [0,1].
nodes = (nodes + 1)/2;
wts = wts/2;

Y = logm_pf(T,m);

if eval_log
    X = 2^s*Y;

    % Compute accurate diagonal and superdiagonal of log(T).
    for j = 1:n-1
        X(j:j+1,j:j+1) = logm2by2(T0(j:j+1,j:j+1) );
    end

    X = Q*X*Q'; 
end

if eval_fd
    L = unvec(logm_frechet_only('notransp', E(:)));
end

if eval_cond
    cond = norm(A, 1) * normest1(@logm_frechet_only, 2, []) / norm(X, 1);
end

% Give the user required output.
if eval_log == true
    out1 = X;
    if eval_fd == true
        out2 = L;
        if eval_cond == true
            out3 = cond;
        end
    elseif eval_cond == true
        out2 = cond;
    end
else
    out1 = L;
end

% Nested functions

%%%%%%%%%%%%%%%%%
function s = opt_cost(d)
    s = 0;
    while norm(d-1,inf) > xvals(mmax)
        d = sqrt(d); s = s+1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%
function X = logm_pf(A,m)
%LOGM_PF   Pade approximation to matrix log by partial fraction expansion.
%   LOGM_PF(A,m) is an [m/m] Pade approximant to LOG(EYE(SIZE(A))+A).

n = length(A);
I = eye(n);
X = zeros(n);

for j=1:m
    X = X + wts(j)*(A/(eye(n) + nodes(j)*A));
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%
function vecD = logm_frechet_only (flag, vecE)
% LOGM_FRECHET_ONLY
% Compute the derivative in a given direction without recomputing the
% actual logarithm. Called by normest1 to get the conditioning of the
% problem.
    t = size(vecE, 2);
    % When called by normest1 need to use flags
    skip = false;
    if strcmp(flag, 'real')
        vecD = isreal(A) && isreal (E); 
        skip = true;
    elseif strcmp(flag, 'dim')
        vecD = n^2; skip = true;
    elseif strcmp(flag ,'transp')
        D = zeros(n,n,t); % The derivatives.
        E = zeros(n,n,t);
        for k = 1:t
            E(:,:,k) = unvec(vecE(:,k));
            E(:,:,k) = E(:,:,k)';
            E(:,:,k) = formEs(Q' * E(:,:,k) * Q);
        end
    elseif strcmp(flag, 'notransp')
        D = zeros(n,n,t); % The derivatives.
        E = zeros(n,n,t);
        for k = 1:t
            E(:,:,k) = unvec(vecE(:,k));
            E(:,:,k) = formEs(Q' * E(:,:,k) * Q);
        end
    end
    if skip, return, end

    for k = 1:t
        for j = 1:m
            temp = eye(n) + nodes(j)*T;
            D(:,:,k) = D(:,:,k) + wts(j)*(temp\E(:,:,k))/temp;
        end
        D(:,:,k) = Q * D(:,:,k) * Q';
    end
    if strcmp(flag, 'transp')
        for k = 1:t
            D(:,:,k) = D(:,:,k)';
        end
    end
    vecD = zeros(n^2, t);
    for k = 1:t
        vecD(:,k) = vec(D(:,:,k));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%
function V = unvec(v)
%UNVEC Unvectorizes the column vector vec.
V = zeros(n);
    for j = 0:n-1
        V(:,j+1) = v(1+j*n:(j+1)*n);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%
function v = vec(mat)
v = mat(:);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Es = formEs(E)
%FORMES Finds matrix Es corr. to derivative L(A,E) = L(A^(1/2^s),Es).
s = size(Troots, 3);
% Fix for Troots = []
if isempty(Troots)
    s = 0;
end
Es = 2^s * E;
for b = 1:s
    Es = sylv_tri(Troots(:,:,b),Troots(:,:,b),Es);
end 
end
%%%%%%%%%%%%%%%%%%%%%%

end

% Subfunctions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function R = sqrtm_tri(T)
% Compute upper triangular square root R of T, a column at a time.
% Bjorck and Hammarling method
n = length(T);
R = zeros(n);
for j=1:n
    R(j,j) = sqrt(T(j,j));
    for i=j-1:-1:1
        R(i,j) = (T(i,j) - R(i,i+1:j-1)*R(i+1:j-1,j))/(R(i,i) + R(j,j));
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X = sylv_tri(T,U,B)
%SYLV_TRI    Solve triangular Sylvester equation.
%   X = SYLV_TRI(T,U,B) solves the Sylvester equation
%   T*X + X*U = B, where T and U are square upper triangular matrices.
%   In this code T = U are roots of T which have size n

n = length(T);
X = zeros(n);
opts.UT = true;
% Forward substitution.
for i = 1:n
    X(:,i) = linsolve(T + U(i,i)*eye(n), B(:,i) - X(:,1:i-1)*U(1:i-1,i), opts);
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x12 = powerm2by2(A,p)
%POWERM2BY2    Power of 2-by-2 upper triangular matrix.
%   POWERM2BY2(A,p) is the (1,2) element of the pth power of the 2-by-2 
%   upper triangular matrix A, where p is an arbitrary real number.

a1 = A(1,1);
a2 = A(2,2);

if a1 == a2

   x12 = p*A(1,2)*a1^(p-1);

elseif abs(a1) < 0.5*abs(a2) || abs(a2) < 0.5*abs(a1)

   a1p = a1^p;
   a2p = a2^p;
   x12 =  A(1,2) * (a2p - a1p) / (a2 - a1);

else % Close eigenvalues.

   loga1 = log(a1);
   loga2 = log(a2);
   w = atanh((a2-a1)/(a2+a1)) + 1i*pi*unwinding(loga2-loga1);
   dd = 2 * exp(p*(loga1+loga2)/2) * sinh(p*w) / (a2-a1);
   x12 = A(1,2)*dd;

end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function r = sqrt_power_1(a,n)
%SQRT_POWER_1    Accurate computation of a^(2^n)-1.
%  SQRT_POWER_1(A,N) computes a^(2^n)-1 accurately.

% Reference: A. H. Al-Mohy.  A more accurate Briggs method for the logarithm.
% Numer. Algorithms, DOI: 10.1007/s11075-011-9496-z.

if n == 0, r = a-1; return, end
n0 = n;
if angle(a) >= pi/2
    a = sqrt(a); n0 = n-1;
end
z0 = a - 1;
a = sqrt(a);
r = 1 + a;
for i=1:n0-1
    a = sqrt(a);
    r = r.*(1+a);
end
r = z0./r;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X = logm2by2(A)
%LOGM2BY2    Logarithm of 2-by-2 upper triangular matrix.
%   LOGM2BY2(A) is the logarithm of the 2-by-2 upper triangular matrix A.

a1 = A(1,1);
a2 = A(2,2);

loga1 = log(a1);
loga2 = log(a2);
X = diag([loga1 loga2]);

if a1 == a2
   X(1,2) = A(1,2)/a1;

elseif abs(a1) < 0.5*abs(a2) || abs(a2) < 0.5*abs(a1)
   X(1,2) =  A(1,2) * (loga2 - loga1) / (a2 - a1);

else % Close eigenvalues.
   dd = (2*atanh((a2-a1)/(a2+a1)) + 2*pi*1i*unwinding(loga2-loga1)) / (a2-a1);
   X(1,2) = A(1,2)*dd;

end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x,w] = gauss_legendre(n)
%GAUSS_LEGENDRE  Nodes and weights for Gauss-Legendre quadrature.
%   [X,W] = GAUSS_LEGENDRE(N) computes the nodes X and weights W
%   for N-point Gauss-Legendre quadrature.

% Reference:
% G. H. Golub and J. H. Welsch, Calculation of Gauss quadrature
% rules, Math. Comp., 23(106):221-230, 1969.

i = 1:n-1;
v = i./sqrt((2*i).^2-1);
[V,D] = eig( diag(v,-1)+diag(v,1) );
x = diag(D);
w = 2*(V(1,:)'.^2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
function u = unwinding(z,k)
%UNWINDING    Unwinding number.
%   UNWINDING(Z,K) is the K'th derivative of the
%   unwinding number of the complex number Z.
%   Default: k = 0.

if nargin == 1 || k == 0
   u = ceil( (imag(z) - pi)/(2*pi) );
else
   u = 0;
end
end

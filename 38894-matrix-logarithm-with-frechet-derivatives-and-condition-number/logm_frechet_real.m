function [out1, out2, out3] = logm_frechet_real(A,E)
%LOGM_FRECHET_REAL Matrix logarithm and its Frechet derivative in direction E.
%   This code computes the matrix logarithm log(A), 
%   its Frechet derivative in a particular direction E and the condition
%   number of the logarithm. The code is for use with real A and E; use
%   logm_frechet_complex for a version using complex arithmetic.
%
%   This code can be called in the following ways:
%   
%   X = logm_frechet_real(A)
%   L = logm_frechet_real(A,E)
%   [X, cond] = logm_frechet_real(A)
%   [X, L] = logm_frechet_real(A,E)
%   [X, L, cond] = logm_frechet_real(A,E)
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
%   Name of corresponding algorithm in that paper: Algorithm 6.1
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
                'maxsqrt in logm_frechet_real if required.'];

xvals = [1.586970738772063e-005
         2.313807884242979e-003
         1.938179313533253e-002
         6.209171588994762e-002
         1.276404810806775e-001
         2.060962623452836e-001
         2.879093714241194e-001];

n = length(A);

% Check whether matrices are real.
if nargin == 1, real_data = isreal(A);
else real_data = isreal(A) && isreal(E);
end
if ~real_data 
    error('Matrices are not real, use logm_frechet_complex instead.') 
end

mmax = 7; foundm = false;
% First form real Schur form (if A not already upper triangular).
[Q,T] = schur(A,'real');

% Check for any negative eigenvalues
[~, T1] = rsf2csf(Q, T);
if any( imag(diag(T1)) == 0 & real(diag(T1)) <= 0 )
   error('A must not have nonpositive real eigenvalues!')
end

T0 = T; 
p = 0;
s0 = opt_cost(diag(T1)); s = s0;
Troots = [];
if s > maxsqrt
   warning('LOGM_FRECHET_REAL:maxsqrt',msg_max_sqrt)
end
for k = 1:min(s,maxsqrt)
    T = sqrtm_real(T);
    Troots(:,:,k) = T;
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
        warning('LOGM_FRECHET_REAL:maxsqrt',msg_max_sqrt)
        m = mmax; break, end
    T = sqrtm_real(T); s = s + 1; 
    Troots(:,:,s) = T;
end

%Compute T^(1/2^s) - I more accurately
k = 1; lastb = 0;
while k <= n
    if k == n || (k < n && T0(k+1,k) == 0)
        T(k,k) = sqrt_power_1(T0(k,k),s);
        if lastb == 1
            T(k-1,k) = powerm2by2(T0(k-1:k,k-1:k),1/2^s);
        end
        k = k + 1; lastb = 1;
    else
        T(k:k+1,k:k+1) = sqrt_power_1(T0(k:k+1, k:k+1), s);
        k = k + 2; lastb = 2;
    end
end

    
% Compute Gaussian quadrature weights and nodes for partial fraction.
[nodes,wts] = gauss_legendre(m);
% Convert from [-1,1] to [0,1].
nodes = (nodes + 1)/2;
wts = wts/2;
[Y] = logm_pf(T,m);

if eval_log
    S = 2^s*Y; 
    % Compute accurate diagonal and superdiagonal of log(T)
    k = 1; lastb = 0;
    while k <= n
        if k == n || (k < n && T0(k+1,k) == 0)
            S(k,k) = log(T0(k,k));
            if lastb == 1
                S(k-1,k) = logm2by2(T0(k-1:k,k-1:k));
            end
            k = k + 1; lastb = 1;
        else
            S(k:k+1,k:k+1) = logm2by2(T0(k:k+1, k:k+1));
            k = k + 2; lastb = 2;
        end
    end
    S = Q*S*Q'; 
end

if eval_fd
    L = unvec(logm_frechet_only('notransp', E(:)));
end

if eval_cond
    cond = norm(A, 1) * normest1(@logm_frechet_only, 2, []) / norm(S, 1);
end

% Give the user required output.
if eval_log == true
    out1 = S;
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
%LOGM_PF Pade approx. to matrix log by partial fraction expansion.
%  LOGM_PF(A,m) is an [m,m] Pade approx. to LOG(EYE(SIZE(A) + A)

n = length(A);
I = eye(n);
X = zeros(n);

for j=1:m
    X = X + wts(j) * (A / (eye(n) + nodes(j)*A));
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ vecD ] = logm_frechet_only (flag, vecE)
%Compute the derivative in a given direction without recomputing the
%actual logarithm. Called by normest1 to get the conditioning of the
%problem.
    t = size(vecE, 2);
    %When called by normest1 need to use flags
    skip = false;
    if strcmp(flag, 'real')
        vecD = real_data; skip = true; %Set to 1 as using real data
    elseif strcmp(flag, 'dim')
        vecD = n^2; skip = true;
    elseif strcmp(flag ,'transp')
        D = zeros(n,n,t); %The derivatives
        E = zeros(n,n,t);
        for k = 1:t
            E(:,:,k) = unvec(vecE(:,k));
            E(:,:,k) = E(:,:,k)'; %Transpose
            E(:,:,k) = formEs(Q' * E(:,:,k) * Q);
        end
    elseif strcmp(flag, 'notransp')
        D = zeros(n,n,t); %The derivatives
        E = zeros(n,n,t);
        for k = 1:t
            E(:,:,k) = unvec(vecE(:,k));
            E(:,:,k) = formEs(Q' * E(:,:,k) * Q);
        end
    end
    %If we only need to return some data from the flags then skip
    if ~skip
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
end

%%%%%%%%%%%%%%%%%%%%%%%%%
function V = unvec(v)
%UNVEC Unvectorizes the column vector vec
V = zeros(n);
    for b = 0:n-1
        V(:,b+1) = v(1+b*n:(b+1)*n);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%
function v = vec(mat)
v = mat(:);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Es = formEs(E)
%FORMES Finds the matrix Es corr. to derivative L(A,E) = L(A^(1/2^s),Es).
% s = size(Troots, 3);
%Fix incase Troots = []
if isempty(Troots)
    s = 0;
end
Es = 2^s * E;
for b = 1:s
    Es = sylvsol(Troots(:,:,b),Troots(:,:,b),Es);
end 
end
%%%%%%%%%%%%%%%%%%%%%%

end

% Subfunctions

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
function R = sqrt_power_1(A,s)
%SQRT_POWER_1    Accurate computation of a^(2^s)-1.
%  SQRT_POWER_1(A,S) computes a^(2^s)-1 accurately.
%
% Reference: A. H. Al-Mohy.  A more accurate Briggs method for the logarithm.
% Numer. Algorithms, DOI: 10.1007/s11075-011-9496-z.

if length(A) == 1
    a = A;
    if s == 0, R = a-1; return, end
    n0 = s;
    if angle(a) >= pi/2
        a = sqrt(a); n0 = s-1;
    end
    z0 = a - 1;
    a = sqrt(a);
    r = 1 + a;
    for i=1:n0-1
        a = sqrt(a);
        r = r.*(1+a);
    end
    R = z0./r;
else % On a 2x2 Schur block.
    if s == 0, R = A - eye(2); return, end
    A = sqrtm_real(A);
    Z0 = A - eye(2);
    if s == 1, R = Z0; return, end
    A = sqrtm_real(A);
    P = A + eye(2);
    for i = 1:s - 2
        A = sqrtm_real(A);
        P = P*(eye(2) + A);
    end
    R = Z0 / P;
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X = logm2by2(A)
%LOGM2BY2    Logarithm of 2-by-2 matrix.
%   LOGM2BY2(A) recomputes the log of 2x2 blocks more accurately.
%   In the upper-tri case we only need to return the (1,2) element
%   whereas the real case needs to return the entire 2x2 block.
if isequal(A, triu(A))
    % Upper triangular version used in complex version of the algorithm
    a1 = A(1,1);
    a2 = A(2,2);

    loga1 = log(a1);
    loga2 = log(a2);

    if a1 == a2
       X = A(1,2)/a1;

    elseif abs(a1) < 0.5*abs(a2) || abs(a2) < 0.5*abs(a1)
       X =  A(1,2) * (loga2 - loga1) / (a2 - a1);

    else % Close eigenvalues.
       dd = (2*atanh((a2-a1)/(a2+a1)) + 2*pi*1i*unwinding(loga2-loga1)) / (a2-a1);
       X = A(1,2)*dd;
    end
else % Must be a 2x2 Schur block
l = 0.5 * log(A(1,1)^2 - A(1,2)*A(2,1));
t = atan2(sqrt(-A(1,2)*A(2,1)), A(1,1))/sqrt(-A(1,2)*A(2,1));
X = [
    l         t*A(1,2)
    t*A(2,1)  l
    ];
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

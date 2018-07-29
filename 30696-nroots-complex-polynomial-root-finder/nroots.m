function r = nroots(p)

% NROOTS:  Find polynomial roots.
%   NROOTS(P) computes all (complex) roots of the polynomial whose 
%   coefficients are the elements of the vector P. If P has N+1 (complex)
%   elements, the polynomial is P(1)*X^N + ... + P(N)*X + P(N+1).
%
%   The algorithm first tries to obtain a good approximation to the 
%   roots by finding eigenvalues of the companion matrix associated with 
%   the polynomial, as per the built-in function ROOTS. The algorithm then
%   uses this first-approximation as input to a simple Newton-Raphson (NR) 
%   iterative scheme, in order to refine (polish) the approximation. Any
%   "root" returned by the NR scheme will be rejected if it differs from
%   the original approximation by more than a specified tolerance (a crude 
%   safegaurd against possible failures of the NR scheme).
%
%   NB: the algorithm's goal is simply to refine the output from ROOTS; in 
%   situations where ROOTS fails to compute one or more roots correctly, 
%   NROOTS will most likely fail similarly. However, NROOTS tends to work
%   well in most non-pathological (e.g. non-repeated roots) cases.
%
%   Class support for input c: 
%      float: double, single
%
%   See also ROOTS, POLY.
%
%   ---      AUTHOR:     Vinesh Rajpaul (UCT)
%   ---      VERSION:    09 March 2011

%% Newton-Raphson algorithm parameters

% NR_iter is the number of NR iterations used to refine the first
% approximation to a root [default: 5].

NR_iter = 5;

% NR_delta is the relative change in the first-approximation to the root
% that must be induced by the NR iteration in order for the NR output to be
% rejected. The idea is to prevent the NR algorithm from converging to a
% nearby but `incorrect' root. For an algorithm that is better suited to
% closely-spaced roots or degenerate roots, see MULTROOT [ACM Transactions 
% on Mathematical Software, Vol. 30, No. 2, June 2004].

NR_delta = 1E-8;

%% Input processing

if size(p,1)>1 && size(p,2)>1
    error('Input must be a vector.')
end

if ~all(isfinite(p))
    error('Input to NROOTS must not contain NaN or Inf.');
end

p = p(:).';
n = length(p);

r = zeros(0,1,class(p));  

inz = find(p);
if isempty(inz),
    % All elements are zero
    return
end

% Strip leading zeros and throw away.  
% Strip trailing zeros, but remember them as roots at zero.

nnz = length(inz);
p = p(inz(1):inz(nnz));
r = zeros(n-inz(nnz),1,class(p));  

% Prevent small leading coefficients from introducing Inf by removing them.

d = p(2:end)./p(1);
ind = find(isinf(abs(d)), 1);
while (~isempty(ind))
    p = p(ind+1:end);
    d = p(2:end)./c(1);
    ind = find(isinf(abs(d)), 1);
end

%% First approximation: polynomial roots via companion matrix

n = length(p);
if n > 1
    a = (diag(ones(1,n-2,class(p)),-1));
    a(1,:) = -d;
    r = [r;eig(a)];
end


%% Polished roots: Newton-Raphson approach

X = zeros(1,NR_iter+1);
p_prime = polyder(p);

for j =1:length(r)
    
    X(1) = r(j);
    
    for i=1:NR_iter+1
        f = polyval(p,X(i));
        f_prime = polyval(p_prime,X(i));
        X(i+1) = X(i) - f/f_prime;
    end
        
    f_at_root = abs(polyval(p,X));
    bestGuess = X(f_at_root==min(f_at_root)); 
    bestGuess=bestGuess(1);
    
    % Accept the NR-polished root only if:
    %   (i). it is (within NR_delta) the correct root; and
    %  (ii). it is a better minimiser of the `objective function' ~ it is
    %        an improvement over the first approximation.
    
    if abs(bestGuess-r(j))/abs(r(j)) <= NR_delta ...
            && (abs(polyval(p,bestGuess)) < abs(polyval(p,r(j))) )
        r(j) = bestGuess;
    end
end

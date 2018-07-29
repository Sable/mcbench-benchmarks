function [Uout,eigvals] = qdwheig(H,normH,minlen,NS)
%QDWH-EIG    Eigendecomposition of symmetric matrix via QDWH.
%   [V,D] = QDWHEIG(A) computes the eigenvalues (the diagonal elements
%   of D) and an orthogonal matrix V of eigenvectors
%   of the symmetric matrix A. This function makes use of the function
%   QDWH that implements the QR-based dynamically weighted Halley
%   iteration for the polar decomposition.
%   [U,D] = QDWHEIG(A,normA,minlen,shift) includes the optional
%   input arguments
%      normA: norm(A,'fro'), which is used in the recursive calls.  
%     minlen: the matrix size at which to stop the recursions (default 1).
%         NS: Newton-Schulz postprocessing for better accuracy
%             1: do N-S (default), 0: don't N-S (slightly faster).
  
backtol = 10*eps/2; % Tolerance for relative backward error.
n = length(H);
if nargin < 2 || isempty(normH); normH = norm(H,'fro'); end
if nargin < 3 || isempty(minlen); minlen = 1; end
if nargin < 4 || isempty(NS); NS = 1; end

[Uout,eigvals] = qdwheigrep(H,normH,minlen,backtol);

if NS
   Uout = 3/2*Uout-Uout*(Uout'*Uout)/2; % Newton-Schulz postprocessing.
end

eigvals = diag(sort(eigvals,'ascend'));
Uout = fliplr(Uout); % Order appropriately.

if nargout == 1; Uout = diag(eigvals); end

% Subfunctions.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Uout,eigvals] = qdwheigrep(H,normH,minlen,backtol,a,b,shift)
% Internal recursion.
n = length(H);

% If already almost diagonal,  return trivial solution.
if norm(H-diag(diag(H)),'fro')/normH < backtol
    [eigvals IX] = sort(diag(H),'descend'); eigvals = eigvals';
    Uout = eye(n); Uout = Uout(:,IX);
    return
end

H = (H+H')/2;   % Needed for recursive calls, due to roundoff.

if nargin < 7 || isempty(shift)
   % Determine shift: approximation to median(eig(H)).
   shift = median(diag(H));
end

% Estimate a,b.
if nargin < 5 || isempty(a); a = normest(H-shift*eye(n),3e-1); end
if nargin < 6 || isempty(b); b = .9/condest(H-shift*eye(n)); end

% Compute polar decomposition via QDWH.
U = qdwh(H-shift*eye(n),a,b);

% Orthogonal projection matrix.
U = (U+eye(n))/2;

% Subspace iteration
[U1,U2] = subspaceit(U);
minoff = norm(U2'*H*U1,'fro')/normH; % backward error

if minoff > backtol
    % 'Second subspace iteration'.
    [U1,U2] = subspaceit(U,0,U1);
    minoff = norm(U2'*H*U1,'fro')/normH; % backward error
end

if minoff > backtol
    for irand = 1:2
        % Redo subspace iteration with randomization.
        [U1b,U2b] = subspaceit(U,1);
        minoff2 = norm(U2b'*H*U1b,'fro')/normH; % backward error
        if minoff > minoff2; U1 = U1b; U2 = U2b; end % take better case
    end
end

% One step done; further blocks.
eigvals = [];
if length(U1(1,:)) == 1
    eigvals = [eigvals U1'*H*U1];
end
if length(U2(1,:)) == 1
    eigvals = [eigvals U2'*H*U2];
end

eigvals1 = []; eigvals2 = [];    
if length(U1(1,:)) > minlen
    [Ua eigvals1] = qdwheigrep(U1'*H*U1,normH,minlen,backtol);
    U1 = U1*Ua;
elseif length(U1(1,:)) > 1 % use MATLAB to complete
    [Ua D] = eig(U1'*(H*U1));  [eigs IX] = sort(diag(D),'descend');
    U1 = U1*Ua(:,IX);
    eigvals1 = fliplr(eigs');    
end
if length(U2(1,:)) > minlen
    [Ua eigvals2] = qdwheigrep(U2'*H*U2,normH,minlen,backtol);
    U2 = U2*Ua;
elseif length(U2(1,:)) > 1 % use MATLAB to complete
    [Ua D] = eig(U2'*(H*U2));   [eigs IX] = sort(diag(D),'descend');
    U2 = U2*Ua(:,IX);
    eigvals2 = fliplr(eigs');
end

Uout = [U1 U2];
% Collect eigvals
eigvals = [eigvals eigvals1 eigvals2];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [U0,U1] = subspaceit(U,use_rand,U1)
%SUBSPACEIT   Subspace iteration for computing invariant subspace.
%   [U0,U1] = SUBSPACEIT(U,use_rand,U1) computes an orthogonal basis U0 
%   for the column space of the square matrix U.
%   Normally one or two steps will yield convergence.
%   U1 is the orthogonal complement of U0.
%   Optional inputs:
%     use_rand: 1 to use randomization to form initial matrix (default 0).
%     U1: initial matrix (then use_rand becomes irrelevant).

n = length(U);
xsize = round(norm(U,'fro')^2); % (Accurate) estimate of norm of U0.

if nargin < 2; use_rand = 0; end

% Determine initial matrix.
if nargin >= 3 % Initial guess given.
    UU = U*U1;
elseif use_rand % Random initial guess.
    UU = U*randn(n,min(xsize+3,n));
else % Take large columns of U as initial guess.

% normcols = zeros(1,n);
% for ii = 1:n; normcols(ii) = norm(U(:,ii)); end;
% [normc,IX] = sort(normcols,'descend');
% UU = U(:,IX(1:min(xsize+3,n))); % Take columns of large norm.
UU = U(:,1:min(xsize+3,n));     % Take first columns.

end

[UU,R] = qr(UU,0); UU = U*UU;[UU,R] = qr(UU); % Subspace iteration.
U0 = UU(:,1:xsize); U1 = UU(:,xsize+1:end);


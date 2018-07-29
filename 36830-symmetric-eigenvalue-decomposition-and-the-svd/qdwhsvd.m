function [Uout,singvals,Vout] = qdwhsvd(A,a,b,minlen,NS);
%QDWHSVD   Singular value decomposition (SVD) via QDWH and QDWHEIG.
%   [Uout,singvals,Vout] = QDWHSVD(A) computes the SVD of A via 
%   QDWH and QDWHEIG, where A is a rectangular matrix.
%   [Uout,singvals,Vout] = QDWHSVD(A,a,b,minlen) includes optional 
%   input arguments:
%      a: an estimate for norm(A,2).
%      b: an estimate for 1/cond(A,1) = \sigma_min(A)/\sigma_max(A).
%      minlen: minimum matrix size for QDWH-eig (default 1).
%      NS: Newton-Schulz postprocessing for better accuracy
%          1: do N-S (default), 0: don't do N-S (slightly faster).

[m,n] = size(A);

if m < n
   flip = 1; A = A'; [m,n] = size(A);  % Flip for fat matrix. 
else;
   flip = 0;
end 

normA = norm(A,'fro');

if m > 1.15*n  % Initial QR to reduce to square case.
    [Qini,A] = qr(A,0); m = n;
end

if nargin < 2 || isempty(a)
    a = normest(A,0.1);
end

if nargin < 3 || isempty(b)
    if m ~= n
        [Q,R] = qr(A,0);
        b = a/condest(R)/1.1;        
    else    
    b = a/condest(A)/1.1;
    end
end

if nargin < 4 || isempty(minlen) || minlen < 1; minlen = 1; end
if nargin < 5 || isempty(NS); NS = 1; end

[Uini,HH,it] = qdwh(A,a,b);     % Compute polar decomposition A = UH.

if norm(Uini,'fro')^2 < n-0.5
    % Computed unitary polar factor was not unitary (partial isometry).
    rankdef = 1;
else
    rankdef = 0;
end 

% Done computing polar decomposition A = Uini*HH; now compute 
% eigendecomposition HH = Vout*D*Vout'.

[Vout,singvals] = qdwheig(HH,normA,minlen,NS); 

singvals = diag(sort(diag(singvals),'descend'));
Vout = fliplr(Vout); % Order appropriately.

% Accumulate Uini and Vout to get SVD A = Uout*D*Vout.
Uout = Uini*Vout;

if exist('Qini'); Uout = Qini*Uout; end % When initial QR used for m>1.15n.
if rankdef == 1
    [Uout R] = qr(Uout,0); % Correction, discussed in paper Sec 5.5.
    Uout = Uout*diag(sign(diag(R)));
end

if NS
   Uout = 3/2*Uout-Uout*(Uout'*Uout)/2; % Newton-Schulz.
end

if flip
   Uouttmp = Uout; Uout = Vout; Vout = Uouttmp;
end

if nargout == 1, Uout = diag(singvals); end
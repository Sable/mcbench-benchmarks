function [s, residual] = OLS(A, y, m, err)

% Orthogonal Least Squares [1] for Sparse Signal Reconstruction

% Input
% A = N X d dimensional measurment matrix
% y = N dimensional observation vector
% m = sparsity of the underlying signal

% Output
% s = estimated sparse signal
% r = residual 

% [1] T. Blumensath, M. E. Davies; "On the Difference Between Orthogonal 
% Matching Pursuit and Orthogonal Least Squares", manuscript 2007

if nargin < 4
     err = 1e-5;
end

s = zeros(size(A,2),1);
r(:,1) = y; L = []; Psi = [];
normA=(sum(A.^2,1)).^0.5;
NI = 1:size(A,2);

for i = 2:m+1
    DR = A'*r(:,i-1);
    [v, I] = max(abs(DR(NI))./normA(NI)');
    INI = NI(I);
    L = [L' INI']';
    NI(I)=[];
    Psi = A(:,L);
    x = Psi\y;
    yApprox = Psi*x;
    r(:,i) = y - yApprox;
    if norm(r(:,end)) < err
        break;
    end
end

s(L) = x;
residual = r(:,end);
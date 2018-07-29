function [s, residual] = StOLS(A, y, steps, err)

% Stagewise Orthogonal Least Squares for sparse reconstruction; combining
% ideas from [1] and [2]

% Input
% A = N X d dimensional measurment matrix
% y = N dimensional observation vector
% steps = specifying the number of iterations

% Output
% s = estimated sparse signal
% r = residual 

% Copyright (c) Angshul Majumdar 2009

% [1] T. Blumensath, M. E. Davies; "On the Difference Between Orthogonal 
% Matching Pursuit and Orthogonal Least Squares", manuscript 2007
% [2] D.L. Donoho, Y. Tsaig, I. Drori, J.-L. Starck, “Sparse solution of 
% underdetermined linear equations by stagewise orthogonal matching pursuit”
% preprint http://www-stat.stanford.edu/~idrori/StOMP.pdf

if nargin < 4
     err = 1e-5;
 end
 if nargin < 3
     err = 1e-5;
     steps = 10;
 end


s = zeros(size(A,2),1); t = 0.5;
r(:,1) = y; L = []; Psi = [];
normA=(sum(A.^2,1)).^0.5;
NI = 1:size(A,2);
i = 2;
while (i < steps) && (norm(r(:,end))>err)
    DR = sqrt(length(y)).*A'*r(:,i-1)./norm(r(:,i-1));
    thr = fdrthresh(abs(DR(NI))./normA(NI)', t);
    I = find(abs(abs(DR(NI))./normA(NI)')>thr);
    INI = NI(I);
    L = [L INI];
    NI(I)=[];
    Psi = A(:,L);
    x = Psi\y;
    yApprox = Psi*x;
    r(:,i) = y - yApprox;
    i = i+1;
end

s(L) = x;
residual = r(:,end);
function [s, residual] = ROLS(A, y, n, err)

% Regularized Orthogonal Least Squares for sparse reconstruction; combining 
% ideas from [1] and [2]

% Input
% A = N X d dimensional measurment matrix
% y = N dimensional observation vector
% m = sparsity of the underlying signal

% Output
% s = estimated sparse signal
% r = residual 

% Copyright (c) Angshul Majumdar 2009

% [1] T. Blumensath, M. E. Davies; "On the Difference Between Orthogonal 
% Matching Pursuit and Orthogonal Least Squares", manuscript 2007
% [2] D. Needell and R. Vershynin, “Uniform uncertainty principle and 
% signal recovery via regularized orthogonal matching pursuit,”
% http://arxiv.org/PS_cache/arxiv/pdf/0707/0707.4203v4.pdf

if nargin < 4
     err = 1e-5;
end

s = zeros(size(A,2),1);
r(:,1) = y; L = []; Psi = [];
normA=(sum(A.^2,1)).^0.5;
NI = 1:size(A,2);
i = 2;
while (length(L)-1 < 2*n) && (norm(r(:,end))>err)
    % Find J, the biggest n coordinates
    DR = A'*r(:,i-1);
    [b, ix] = sort(abs(DR(NI))./normA(NI)','descend');
    J = ix(1:n);
    Jvals = b(1:n);
    
    %Find I, the set of comparable coordinates with maximal energy
    w=1;
    best = -1;
    I = zeros(1);
    while w <= n
        first = Jvals(w);
        firstw = w;
        energy = 0;
        while ( w <= n ) && ( Jvals(w) >= 1/2 * first )
            energy = energy + Jvals(w)^2;
            w = w+1;
        end
        if energy > best
            best = energy;
            I = J(firstw:w-1);
        end
    end
   
    INI = NI(I);
    L = [L' INI]';
    NI(I)=[];
    Psi = A(:,L);
    x = Psi\y;
    yApprox = Psi*x;
    r(:,i) = y - yApprox;
    i = i+1;
end

s(L) = x;
residual = r(:,end);
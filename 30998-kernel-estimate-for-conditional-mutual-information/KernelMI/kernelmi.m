function [ I ] = kernelmi( x, y, h, ind )
% Kernel-based estimate for mutual information I(X, Y)
% h - kernel width; ind - subset of data on which to estimate MI

[Nx, Mx]=size(x);
[Ny, My]=size(y);

if any([Nx Ny My] ~= [1 1 Mx])
    error('Bad sizes of arguments');
end

if nargin < 3
    % Yields unbiased estiamte when Mx->inf 
    % and low MSE for two joint gaussian variables
    alpha = 0.25;
    h = (Mx + 1) / sqrt(12) / Mx ^ (1 + alpha);
end

if nargin < 4
    ind = 1:Mx;
end

% Copula-transform variables
x = ctransform(x);
y = ctransform(y);

h2 = 2*h^2;

% Pointwise values for kernels
Kx = squareform(exp(-ssqd([x;x])/h2))+eye(Mx);
Ky = squareform(exp(-ssqd([y;y])/h2))+eye(Mx);

% Kernel sums for marginal probabilities
Cx = sum(Kx);
Cy = sum(Ky);

% Kernel product for joint probabilities
Kxy = Kx.*Ky;

f = sum(Cx.*Cy)*sum(Kxy)./(Cx*Ky)./(Cy*Kx);
I = mean(log(f(ind)));

end


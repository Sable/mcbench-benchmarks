function [ I ] = kernelcmi( x, y, z, h, ind )
% Kernel-based estimate for conditional mutual information I(X, Y|Z)
% h - kernel width; ind - subset of data on which to estimate MI

[Nx, Mx]=size(x);
[Ny, My]=size(y);
[Nz, Mz]=size(z);

if any([Nx Ny Nz My Mz] ~= [1 1 1 Mx Mx])
    error('Bad sizes of arguments');
end

if nargin < 4
    % Yields unbiased estiamte when Mx->inf 
    % and low MSE for two joint gaussian variables
    alpha = 0.25;
    h = (Mx + 1) / sqrt(12) / Mx ^ (1 + alpha);
end

if nargin < 5
    ind = 1:Mx;
end

% Copula-transform variables
x = ctransform(x);
y = ctransform(y);
z = ctransform(z);

h2 = 2*h^2;

% Pointwise values for kernels
Kx = squareform(exp(-ssqd([x;x])/h2))+eye(Mx);
Ky = squareform(exp(-ssqd([y;y])/h2))+eye(Mx);
Kz = squareform(exp(-ssqd([z;z])/h2))+eye(Mx);

% Kernel sums for marginal probabilities
Cx = sum(Kx);
Cy = sum(Ky);

% Kernel products for joint probabilities
Kxz = Kx.*Kz;
Kyz = Ky.*Kz;
Kxyz = Kx.*Ky.*Kz;

f = ((Cx.*Cy)*Kz).*sum(Kxyz)./(Cx*Kyz)./(Cy*Kxz);
I = mean(log(f(ind)));

end


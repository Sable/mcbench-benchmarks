function a = zernike_coeffs(phi, M)
% By: Christopher Wilcox and Freddie Santiago
% Feb 18 2010
% Naval Research Laboratory
% 
% Description: Represent a wavefront as a sum of Zernike polynomials using
%              a matrix inversion.
% 
% This function attempts to solve the a_i's in equation,
% 
%                     M
%                     __
%                    \
%  phi(rho,theta) =  /__  a_i * Z_i(rho,theta)
%                    i=1
% 
% where the Z_i(rho,theta)'s are the Zernike polynomials from the zernfun.m
% file, phi is the wavefront to be represented as a sum of Zernike 
% polynomials, the a_i's are the Zernike coefficients, and M is the number
% of Zernike polynomials to use.
%
% Input:    phi - Phase to be represented as a sum of Zernike polynomials
%                 that must be an nXn array (square)
%           (optional) M - Number of Zernike polynomials to use (Default = 12)
% Output:   a - Zernike coefficients (a_i's) as a vector
% 
% Note: zernfun.m is required for use with this file. It is available here: 
%       http://www.mathworks.com/matlabcentral/fileexchange/7687 

if nargin == 1
    M = 12;
end
if M > 105
    error('The maximum number of coefficients calculated is 105.');
end

if exist('zernfun.m','file') == 0
    error('zernfun.m does not exist! Please download from mathworks.com and place in the same folder as this file.');
else
    x = -1:1/(128-1/2):1;
    [X,Y] = meshgrid(x,x);
    [theta,r] = cart2pol(X,Y);
    idx = r<=1;
    z = zeros(size(X));
    n = [0  1 1 2  2 2  3 3  3 3 4  4 4  4 4  5 5  5 5  5 5 6  6 6  6 6  6 6  7 7  7 7  7 7  7 7 8  8 8  8 8  8 8  8 8  9 9  9 9  9 9  9 9  9 9 10 10 10 10 10 10 10 10 10  10 10 11 11 11 11 11 11 11 11 11 11  11 11 12 12 12 12 12 12 12 12 12  12 12  12 12 13 13 13 13 13 13 13 13 13 13  13 13  13 13];
    m = [0 -1 1 0 -2 2 -1 1 -3 3 0 -2 2 -4 4 -1 1 -3 3 -5 5 0 -2 2 -4 4 -6 6 -1 1 -3 3 -5 5 -7 7 0 -2 2 -4 4 -6 6 -8 8 -1 1 -3 3 -5 5 -7 7 -9 9  0 -2  2 -4  4 -6  6 -8  8 -10 10 -1  1 -3  3 -5  5 -7  7 -9  9 -11 11  0 -2  2 -4  4 -6  6 -8  8 -10 10 -12 12 -1  1 -3  3 -5  5 -7  7 -9  9 -11 11 -13 13];

    y = zernfun(n,m,r(idx),theta(idx));

    Zernike = cell(M);
    for k = 1:M
        z(idx) = y(:,k);
        Zernike{k} = z;
    end

    phi_size = size(phi);
    if phi_size(1) == phi_size(2)
        phi = phi.*imresize(double(idx),phi_size(1)/256);
        phi = reshape(phi,phi_size(1)^2,1);
        Z = nan(phi_size(1)^2,M);
        for i=1:M
            Z(:,i) = reshape(imresize(Zernike{i},phi_size(1)/256),phi_size(1)^2,1);
        end
        a = pinv(Z)*phi;
    else
        error('Input array must be square.');
    end
end
function K = kernelg(X1,X2,s)
% FUNCTION K = kernelg(X1,X2,s)
%   AUTHOR:    Makoto Yamada
%              (myamada@ism.ac.jp)
%   DATE:       12/25/07
% 
%  DESCRIPTION:
% 
%   This function compute the Gaussian kernel.
%
%  INPUTS:
% 
%           X1:     "X1" is a (n times N) dimensional matrix,
%                   where "n" is the vector dimension and N is the number
%                    of samples.
%
%           X2:     "X2" is a (n times N) dimensional matrix.
%                    where "n" is the vector dimension and N is the number
%                    of samples.
%
%            s:      "s" is a parameter for Gaussian kernel, 
%                    exp(-norm(x - y)^2/s).
% 
%  OUTPUTS:
% 
%            K:     N times N dimensional kernel Gram matrix.
% 
% 
%  Example: 
%              load usps;
%              s     = 256*0.7; %Gaussian Kernel Parameter
%              K = kernelg(X,Y,s);

n1    = size(X1,2);
n2    = size(X2,2);

K = zeros(n1,n2);
for ii = 1:n1
    for jj = 1:n2 
        K(ii,jj) = exp(-norm(X1(:,ii) - X2(:,jj))^2/s);
    end
end
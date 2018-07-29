%This program generates the 2D gaussian filter.
%To generate the filter,code should be written as f=gaussian_filter(size_of_kernel,sigma);
%This code was developed by Vivek Singh Bhadouria, NIT-Agartala India on 4
%August 2011, 12:59AM (E-mail:vivekalig@gmail.com)
function f=gaussian_filter(n,s)
x = -1/2:1/(n-1):1/2;
[Y,X] = meshgrid(x,x);
f = exp( -(X.^2+Y.^2)/(2*s^2) );
f = f / sum(f(:));
end
function thresh = fdrthresh(z,q)
    
%
% Copyright (c) 2006. Iddo Drori
%  

%
% Part of SparseLab Version:100
% Created Tuesday March 28, 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail sparselab@stanford.edu
%

az = abs(z);
[sz,iz] = sort(az);
pobs = erfc(sz./sqrt(2));
N = 1:length(z);
pnull =  N' ./length(z);
good = (reverse(pobs) <= (q .* pnull));
if any(good),
    izmax  = iz(1 + length(sz) - max(N(good)));
    thresh = az(izmax);
else
    thresh = max(az) + .01;
end
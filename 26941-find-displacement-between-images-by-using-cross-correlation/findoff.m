%by Davide Di Gloria
%
%Find displacement between 2 grayscale images by using cross-correlation
%
%[dr,dc]=findoff(unreg,ref)
%

function [yoffset,xoffset]=findoff(unreg , base)

c = normxcorr2(unreg,base);

[max_c, imax] = max(abs(c(:)));
[ypeak, xpeak] = ind2sub(size(c),imax(1));

corr_offset = round([(xpeak-(size(c,2)+1)/2) (ypeak-(size(c,1)+1)/2)]);

offset = corr_offset;
xoffset = offset(1);
yoffset = offset(2);

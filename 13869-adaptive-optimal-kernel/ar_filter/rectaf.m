function [afr, afi] = rectaf(xr,xi,laglen,freqlen,alphar,alphai,alpharN,alphaiN,afr,afi)
% rectaf: generate running AF on rectangular grid;	
%	     negative lags, all DFT frequencies
% G.A. Reina 16 Jan 2007
% Modified from the C code provided by D. L. Jones and R. G. Baraniuk
% "An Adaptive Optimal-Kernel Time-Frequency Representation"
%   by D. L. Jones and R. G. Baraniuk, IEEE Transactions on Signal 
%   Processing, Vol. 43, No. 10, pp. 2361--2371, October 1995.

rr = xr(1)*xr(1:laglen) + xi(1)*xi(1:laglen);
ri = xi(1)*xr(1:laglen) - xr(1)*xi(1:laglen);

rrN = xr(freqlen - (0:laglen -1) + 1)*xr(freqlen+1) + xi(freqlen - (0:laglen -1) + 1)*xi(freqlen+1);
riN = xi(freqlen - (0:laglen -1) + 1)*xr(freqlen+1) - xr(freqlen - (0:laglen -1) + 1)*xi(freqlen+1);
          
for ii = 0:(laglen-1),

    temp = ( afr(:, ii+1) .* alphar' - afi(:, ii+1) .* alphai' )  ...
        - ( rrN(ii+1) .* alpharN(:, ii+1) - riN(ii+1) .* alphaiN(:, ii+1) ) ...
        + rr(ii+1);

    afi(:, ii+1) = ( afi(:, ii+1).*alphar' + afr(:, ii+1).*alphai' ) ...
        - ( riN(ii+1).*alpharN(:, ii+1) + rrN(ii+1).*alphaiN(:, ii+1) ) ...
        + ri(ii+1);

    afr(:, ii+1) = temp;

end



 

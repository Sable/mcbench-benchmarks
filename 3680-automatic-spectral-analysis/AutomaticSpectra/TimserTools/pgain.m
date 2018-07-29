function g = pgain(ar,ma)

%PGAIN Power gain of ARMA process [ar,ma]
%   The power gain is the ratio between the power of input
%   and output for an ARMA-system [ar,ma] when the input
%   is white noise.

[dummy,g] = arma2cor(ar,ma,0);
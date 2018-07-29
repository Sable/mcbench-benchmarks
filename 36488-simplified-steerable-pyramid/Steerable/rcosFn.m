function [X, Y] = rcosFn(width,position)
% Return a raised cosine soft threshold function:
%
% Input:    
%       width:    the width of the region over which the transition occurs
%    position:    the location of the center of the threshold

N = 256;  % size of profile

X = pi*[-N-1:1] / (2*N);
Y = cos(X).^2;

%    Make sure end values are repeated, for extrapolation...
Y(1) = Y(2);
Y(N+3) = Y(N+2);

X = position + (2*width/pi) * (X + pi/4);

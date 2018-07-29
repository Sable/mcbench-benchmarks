function Ma = timesv(M,a);
%function Ma = timesv(M,a);
%
% Multiplies a by M:
% a(:,:,i) = M*a(:,:,i)
%
% See also FILTER.

dima = size(a,1);
I = eye(dima);
Ma = armafilterv(a,I,M);

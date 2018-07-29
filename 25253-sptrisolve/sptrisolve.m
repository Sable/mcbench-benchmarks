function x = sptrisolve(T, b, uplo, transpose)
% x = sptrisolve(T, b, uplo, transpose)
%
% Solves the equation Tx=b where T is a sparse triangular
% matrix. Useful for use with an iterative method.
%
% uplo and transpose are optional:
%   - if uplo is 'upper' then T is assumed to be upper trianguler,
%     otherwise it is assumed to be lower. Default is lower.
%   - if transpose is 'transpose' or 'transp' then T'x=b is 
%     solved.
%
% THIS MATERIAL IS PROVIDED AS IS, WITH ABSOLUTELY NO WARRANTY EXPRESSED OR IMPLIED. 
% ANY USE IS AT YOUR OWN RISK.
%
% Copyright (C) August 2009, Haim Avron 
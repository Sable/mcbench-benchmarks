function op = opMatWrapper(operator, n)
% OPDCT  One-dimensional discrete cosine transform (DCT)
%
%    OPDCT(N) creates a one-dimensional discrete cosine transform
%    operator for vectors of length N.

%   Copyright 2008, Ewout van den Berg and Michael P. Friedlander
%   http://www.cs.ubc.ca/labs/scl/sparco
%   $Id: opDCT.m 1040 2008-06-26 20:29:02Z ewout78 $

op = @(x,mode) opMatWrapper_intrnl(operator,n,x,mode);


function y = opMatWrapper_intrnl(operator,n,x,mode)

if mode == 0
   t = operator([],0);
   y = {t{1},t{2},t{3},{'Matrix Input Matrix Output'}};
elseif mode == 1
    for i = 1:n
        y(:,i) = operator(x(:,i),1);
    end
else
   for i = 1:n
        y(:,i) = operator(x(:,i),2);
    end
end

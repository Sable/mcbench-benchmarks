function y=design(x)
% DESIGN 
% DESIGN(x) creates a matrix of 1 and 0 corresponding to x
% y: Rows(x) x Max(x)
  i=1:1:rows(x);
  k=ones(rows(x),1);
  s=sparse(i,x,k,rows(x),max(x));
  y=full(s);
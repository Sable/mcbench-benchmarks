function m=miss(x,v)
% MISS converts specified elements in a matrix to the MATLAB missing value code
% MISS(x,v) If v is a scalar (eg -1), all -1's in x are converted to NaN.  If v is a row (or
% column) vector with the same number of columns (rows) as x, each column (row)
% in x is transformed to NaN according to the corresponding element in v.
% If dim(x)=dim(v), the transformation is done element by element.
[i,j]=size(v);
[ix,jx]=size(x);
if i+j==2
   x(x==v)=NaN;
   m=x;
elseif (i==ix & j==jx)==1
   x(x==v)=NaN;
   m=x;
elseif (i==1 & j==jx)==1
   y=repmat(v,ix,1);
   x(x==y)=NaN;
   m=x;
elseif (i==ix & j==1)==1
   y=repmat(v,1,jx);
   x(x==y)=NaN;
   m=x;
else
   error('Error in matrix dimensions')
end

   
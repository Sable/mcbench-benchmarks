function c=poly(A)
[nr,nc]=size(A); 
if nc==nr
   R0=eye(nc);  R=R0; c=[1 zeros(1,nc)]; 
   for k=1:nc 
      c(k+1)=-1/k*trace(A*R);  
      R=A*R+c(k+1)*R0;
   end
elseif (nr==1 | nc==1)
   A=A(isfinite(A)); n = length(A);
   c = [1 zeros(1,n)];
   for j=1:n
      c(2:(j+1)) = c(2:(j+1)) - A(j).*c(1:j);
   end
else   
   error('Argument must be a vector or a square matrix.')
end

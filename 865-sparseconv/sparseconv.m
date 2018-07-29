function out=sparseconv(x,f)

% SPARSECONV Speedy convolution of sparse vectors
%
%    OUT = SPARSECONV(X, F) computes the convolution of the 
%    (sparse) input vectors X and F. 
%
%    Gert Cuypers 4/10/2001
%    Esat Sista KULeuven


[rij,kol]=size(x);
if kol>1
   x=x.';
end
[rij,kol]=size(x);
if kol>1
   error('x moet vector zijn')
end

[rij,kol]=size(f);
if kol>1
   f=f.';
end

[rij,kol]=size(f);
if kol>1
   error('f moet vector zijn');
end
xs=sparse(x);
[xrow, xcol, xval]=find(xs);
nietnulx=length(xrow);
fs=sparse(f);
[frow, fcol, fval]=find(fs);
nietnulf=length(frow);
xpos=zeros(nietnulf*nietnulx,1);
ypos=zeros(nietnulf*nietnulx,1);
elementen=zeros(nietnulf*nietnulx,1);
dummy=(frow)*ones(1,nietnulx);
ypos(:)=dummy;
xpos(:)=dummy+ones(nietnulf,1)*xrow.'-1;
elementen(:)=ones(nietnulf,1)*xval.';
out=full(sparse(xpos,ypos,elementen,length(x)+length(f)-1,length(f))*fs); 
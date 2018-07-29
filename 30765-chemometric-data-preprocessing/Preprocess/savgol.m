function [x_sg]= savgol(x,width,order,deriv)
% Savitsky-Golay smoothing and differentiation
%
% [x_sg]= savgol(x,width,order,deriv)
%
% input:
% x (samples x variables) data to preprocess
% width (1 x 1)           number of points (optional, default=15)
% order (1 x 1)           polynomial order (optional, default=2)
% deriv (1 x 1)           derivative order (optional, default=0)
%
% output:
% x_sg (samples x variables) preprocessed data
%
% By Cleiton A. Nunes
% UFLA,MG,Brazil


[m,n]=size(x);
x_sg=x;
if nargin<4
  deriv=0;
end
if nargin<3
  order=2; 
end
if nargin<2
  width=min(15,floor(n/2)); 
end
w=max( 3, 1+2*round((width-1)/2) );
o=min([max(0,round(order)),5,w-1]);
d=min(max(0,round(deriv)),o);
p=(w-1)/2;
xc=((-p:p)'*ones(1,1+o)).^(ones(size(1:w))'*(0:o));
we=xc\eye(w);
b=prod(ones(d,1)*[1:o+1-d]+[0:d-1]'*ones(1,o+1-d,1),1);
di=spdiags(ones(n,1)*we(d+1,:)*b(1),p:-1:-p,n,n);
w1=diag(b)*we(d+1:o+1,:);
di(1:w,1:p+1)=[xc(1:p+1,1:1+o-d)*w1]'; 
di(n-w+1:n,n-p:n)=[xc(p+1:w,1:1+o-d)*w1]';
x_sg=x*di;
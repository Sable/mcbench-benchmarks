% Chapter 8 - Planar Systems.
% Program_8a - Program to Plot a Vector Field.
% Save M-file as vectorfield.m. Do NOT run this function file.
% Copyright Birkhauser 2013. Stephen Lynch.

% See the phase protraits in the book.
function vectorfield(deqns,xval,yval,t)
if nargin==3;
    t=0;
end
m=length(xval);
n=length(yval);
x1=zeros(n,m);
y1=zeros(n,m);
for a=1:m
  for b=1:n
    pts = feval(deqns,t,[xval(a);yval(b)]);
    x1(b,a) = pts(1);
    y1(b,a) = pts(2);
  end
end
arrow=sqrt(x1.^2+y1.^2);
quiver(xval,yval,x1./arrow,y1./arrow,.5,'r');
axis tight;

% End of Program_8a.


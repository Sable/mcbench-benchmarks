function a=plasma(n)
% Elegant, fast, non-recursive way to create a plasma 
% fractal PLASMA(n) takes one argument n , where 
% 2^(2+n) is the size of the square plasma matrix. 
% The default value of n is 6, which gives a
% 256 x 256 matrix
%
% Arjun Viswanathan 1999

randn('state',sum(clock*100));
t=cputime;
a=rand(4);
if nargin<1
   n=6;
end

for i=1:n;
   r=size(a,1);c=size(a,2);
   xi=[1:(r-1)/(2*r-1):r];
   yi=[1:(c-1)/(2*c-1):c];
   a=interp2(a,xi,yi','cubic');
   step=2^(-i);
   dev=rand(size(a)).*step-2*step;
   a=a+dev;
end

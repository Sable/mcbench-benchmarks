function [y m]=convolution_(x,nx,h,nh)
m=nx(1)+nh(1):nh(end)+nx(end);
Lx=length(x);
Lh=length(h);
H=[h zeros(1,Lx)]'*ones(1,Lx);
H=H(1:end-Lx);
H=reshape(H,Lx+Lh-1,Lx);
y=(H*x')';
end
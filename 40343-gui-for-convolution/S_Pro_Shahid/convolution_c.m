function [y m]=convolution_c(x,nx,h,nh,increment)
m=(nx(1)+nh(1)):increment:(nx(end)+nh(end));
Lx=length(x);
Lh=length(h);
H=[h zeros(1,Lx)]'*ones(1,Lx);
H=H(1:end-Lx); %%(Lx+Lh-1) by (Lx)elements Matrix
H=reshape(H,Lx+Lh-1,Lx); 
y=(H*x')'*increment;
end
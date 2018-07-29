function y=recserp(x,z)
% RECSERP 
% RECSERP(x,z) constructs a recursive time series based on product
% x: N*K   z: N*K
% y(1)=x(1)+z(1) 
% y(t)=y(t-1)*x(t)+z(t) for t=2,..N
y=[];
y(1,:)=x(1,:)+z(1,:);

n=rows(x);
for i=2:n
   y(i,:)=y(i-1,:).*x(i,:)+z(i,:);
end

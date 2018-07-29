function v=movingvar(x,m);
% Moving variance
% 
% v=movingvar(x,m)
%
% x is the timeseries.
% m is the window length.
% v is the variance.
%
% Aslak Grinsted 2005


n=size(x,1);
f=zeros(m,1)+1/m;


v=filter2(f,x.^2)-filter2(f,x).^2;
m2=floor(m/2);
n2=ceil(m/2)-1;
v=v([zeros(1,m2)+m2+1,(m2+1):(n-n2),zeros(1,n2)+(n-n2)],:);



return

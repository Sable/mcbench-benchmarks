function re=rev(x);
% REV 
% REV(x) reverses the elements of x
d=size(x); li=d(1,1);
ind=li:-1:1;
re=x(ind,:);


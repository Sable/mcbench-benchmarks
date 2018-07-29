function f=fitfit(a,x);
N=max(size(a));
X=x(1:a(N));
Y=x(a(N)+1:a(N)+a(N-1));
[y,x]=meshgrid(X,Y);
ff=a(1)*cos(a(2)*(x.^2+y.^2)+a(3))./(x.^2+y.^2).^a(4);%THIS IS A USER %DEFINED FUNCTION.
%ONE CAN CHANGE IT ACCORDING TO THE FITTNG EQUATION TO BE USED
ff=ff';
[m,n]=size(ff);
f=reshape(ff,1,m*n);



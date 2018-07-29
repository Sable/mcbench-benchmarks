function [f] = binomial(n,d)
%BINOMIAL  calculate the binomial coefficient
%          n and d may be complex and any equal size
%
%        n!
% f = --------  
%     d!(n-d)!
%
%usage: b = binomial(n,d)
%
%tested on version 5.3.1
%
%see also: Gamma, Prod
%see also: mhelp binomial
%
%not correct for negative integer arguments!

%Paul Godfrey
%pgodfrey@conexant.com
%8-12-00

nsize=size(n); n=n(:);
dsize=size(d); d=d(:);

if min(nsize==dsize)==0
   error('Input argument size mismatch!')
end

if (0<n & 0<=d & round(n)==n & round(d)==d & n>=d & max(size(n))==1 & max(size(d))==1)
   f = prod((d+1):n)/prod(1:(n-d));
else
   z=gamma([n d n-d]+1);
   f=z(:,1)./(z(:,2).*z(:,3));
end

f=reshape(f,nsize);

return

%a demo of this routine is
dx=1/16;
dy=dx;
x=-4:dx:4;
y=-4:dy:4;
[X,Y]=meshgrid(x,y);
f=binomial(X,Y);
p=find(abs(f)>4);
%f(p)=sign(real(f(p)))*4;
f(p)=NaN;
mesh(x,y,real(f))
view([23 54]);
rotate3d


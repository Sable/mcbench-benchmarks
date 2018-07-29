function [f] = factd(n)
%FACTD Double Factorial function = n!! 
%
%usage: f = factd(n)
%
%tested under version 5.3.1
%
%     This function computes the double factorial of N.
%     N may be complex and any size. Uses the included 
%     complex Gamma routine.
%
%     f = n*(n-2)*(n-4)*...*5*3*1 for n odd
%     f = n*(n-2)*(n-4)*...*6*4*2 for n even
%
%see also: Gamma, Fact

%Paul Godfrey
%pgodfrey@conexant.com
%8-29-00

[siz]=size(n);
n=n(:);

p=cos(pi*n)-1;

f=2.^((-p+n+n)/4).*pi.^(p/4).*gamma(1+n/2);

p=find(round(n)==n & imag(n)==0 & real(n)>=-1);
if ~isempty(p)
   f(p)=round(f(p));
end

p=find(round(n/2)==(n/2) & imag(n)==0 & real(n)<-1);
if ~isempty(p)
    f(p)=Inf;
end

f=reshape(f,siz);

return

%a demo of this routine is
n=-10:10;
n=n(:);
f=factd(n);
[n f]

ezplot factd
grid on
return

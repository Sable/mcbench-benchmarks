function [f] = fact(n)
%FACT  Vectorized Factorial function
%
%usage: f = fact(n)
%
%tested under version 5.3.1
%
%     This function computes the factorial of 
%     the elements of N.
%     N can be any size but must contain
%     Real, Non-Negative, Integers.
%
%     This routine is much more robust than
%     the built in FACTORIAL function.
%
%see also: Gamma, Prod, Factorial, Binomial

%Paul Godfrey
%pgodfrey@conexant.com
%8-23-00

[row,col]=size(n);
n=n(:);

f=NaN*n;

pp=find(imag(n)==0 & real(n)>=0 & round(n)==n);
%find integer values
nn=n(pp);
ff=zeros(length(pp),1);

s=1;
p=[];
if ~isempty(nn)
   p=find(nn==0);
end
if ~isempty(p)
   ff(p)=s;
end

%upper limit here depends upon realmax
if ~isempty(nn)
for k=1:170
    s=s*k;
%empty=scalar warning
    p=find(nn==k);
    if ~isempty(p)
        ff(p)=s;
    end
end
end

p=find(nn>170);
if ~isempty(p)
    ff(p)=Inf;
end

f(pp)=ff;
f=reshape(f,row,col);

return

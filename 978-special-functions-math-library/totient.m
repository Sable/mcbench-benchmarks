function [t] = totient(n)
%TOTIENT  calculates the totient function (also
%         called the Euler Phi function) of any
%         positive integer n.
%
%Usage:   f = totient(n)
%
%         The totient function computes the number of
%         integers from the set (1...n-1) that are
%         relatively prime to n. It can be used to
%         describe the multiplicative structure of
%         all Galois fields GF(q).
%
%         n can be any size
%
%         Tested under version 5.2.0
%
%Ref: "Error Control Systems" by S.B Wicker
%
%see also Primes, Factor

% Paul Godfrey
% pgodfrey@conexant.com
% 10-23-2001

[r c]=size(n);
n=reshape(n,1,r*c);
t=zeros(1,r*c);
f=zeros(1,10);

for k=1:r*c;
    nk=n(k);
    f=unique(factor(nk));
    t(k)=nk*prod(1-1./f);
end
t=reshape(t,r,c);
p=find(n==1);
t(p)=1;
t=round(t);
return

%a demo of this program is
n=(1:50).';
t=totient(n);
[n t]

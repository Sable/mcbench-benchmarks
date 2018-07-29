function [Who, Num, G]=Naive(OutOfWho,M)

N=length(OutOfWho);

a=zeros(1,N);
for n=1:N
    a(n)=Goodness(OutOfWho(n),M);
end
[dd, Who]=sort(-a);

for n=1:N
    G(n)=Goodness(Who(1:n),M);
end

Num=[1:N];


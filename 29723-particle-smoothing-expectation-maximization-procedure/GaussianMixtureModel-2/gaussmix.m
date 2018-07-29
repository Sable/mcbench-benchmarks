function y=gaussmix(m1,sigma1,m2,sigma2,lambda)

n=length(m1);

for i=1:n
    if rand>lambda
y(i)=random('normal',m1(i),sigma1);
    else
y(i)=random('normal',m2(i),sigma2);
    end
end
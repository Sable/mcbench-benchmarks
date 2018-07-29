function y1=likelihood(y,x,a,b,c,d)
sum=0;
for t=2:length(y)
sum=sum+log(normpdf(y(t),my(c,x(t)),d))+log(normpdf(x(t),mx(a,x(t-1)),b));
end
y1=sum;

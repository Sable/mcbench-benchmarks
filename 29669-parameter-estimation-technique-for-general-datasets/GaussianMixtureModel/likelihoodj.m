function y1=likelihoodj(y,x,a,b,c,d,g,h,lambda)
sum=0;
for t=2:length(y)
sum=sum+log(normpdf(y(t),my(c,x(t)),d))+log(normpdf(x(t),mx(a,x(t-1))+g,sqrt(1+h)*b)*lambda+normpdf(x(t),mx(a,x(t-1)),b)*(1-lambda));
end
y1=sum;

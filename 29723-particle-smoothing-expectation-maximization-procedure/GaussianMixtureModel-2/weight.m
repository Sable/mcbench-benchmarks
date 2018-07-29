%xf2=x(:,t+1),xf1=x(:,t),w2=w(:,t+1),w1=w(:,t)
function y=weight(xf2,xf1,w2,w1,i,a,b,g,h,lambda)
sum=0;
for j=1:length(xf2)
    sum=sum+w2(j)*(normpdf(xf2(j),mx(a,xf1(i))+g,sqrt(1+h)*b)*lambda+normpdf(xf2(j),mx(a,xf1(i)),b)*(1-lambda))/(theta(xf2(j),xf1,w1,a,b,g,h,lambda));
end
y=sum;
end



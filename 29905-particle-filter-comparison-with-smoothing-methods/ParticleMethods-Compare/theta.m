%xf2_j=x(t+1,j),xf1=x(t,:),w1=w(t,:)
function y=theta(xf2_j,xf1,w1,a,b)
%Ensures a nonzero summation in denominator
if sum(w1.*normpdf(xf2_j,mx(a,xf1),b))==0
    y=1;
else
y=sum(w1.*normpdf(xf2_j,mx(a,xf1),b));
end


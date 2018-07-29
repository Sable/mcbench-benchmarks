function y=ewmacovariance(R1,R2,n,s,lambda)
%
% implemented by ewmaestimatevar function
%
%% Written By Ali Najjar
%
if s==1 
    y=R1(n-s)*R2(n-s);
else 
    y=((1-lambda)*((R1(n-1))*(R2(n-1))))+(lambda*ewmacovariance(R1,R2,n-1,s-1,lambda));
end
end
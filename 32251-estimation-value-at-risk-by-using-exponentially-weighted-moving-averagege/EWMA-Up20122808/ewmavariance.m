function y=ewmavariance(R,n,s,lambda)
%
% implemented by ewmaestimatevar function
%
%% Written By Ali Najjar
%
if s==1 
    y=R(n-s)^2;
else 
    y=((1-lambda)*((R(n-1))^2))+(lambda*ewmavariance(R,n-1,s-1,lambda));
end
end


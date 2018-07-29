% This function is used to determine the mean distance
% for uniform sampling over a hypercube.  Used for comparing the
% quality of initial conditions with other algorithms that use 
% only one iterative solution (i.e., can use mean distance here
% to set i.c. with same mean distance in single solution algorithm).
%
% 'thetatmax' and 'thetamin' represents px1 vectors of upper and lower
% bounds to theta elements.
%
p=10;
thetamax=2.047*ones(p,1);
thetamin=-2.048*ones(p,1);
thetatrue=ones(p,1); %must lie inside of hypercube defined by thetamax, thetamin
y=0;
N=200000;
rand('seed',31415927)
for i=1:N
   x=((thetamax-thetamin).*rand(p,1)+thetamin);
   dist=((x-thetatrue)'*(x-thetatrue))^.5;
   y=y+dist;
end
y=y/N
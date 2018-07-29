data = dlmread('iris.dat'); % data file
v=[1:4];
c=5;
measure = 5; % Which quantifier to use in OWA operators you want to use. 
% Possible choices implemented:
% 1=Basic RIM quantifier
% 2=Quadratic quantifier
% 3=Exponential quantifier
% 4=Trigonometric quantifier
% 5=O'Hagans method.
p = [0.1:0.25:4]; % p parameter range
alpha = [0.1:0.1:1]; % alpha parameter range 
pl=1; % Do we use plotting w.r.t. parameters p and m or not pl=0 no plotting pl=1 plotting.
N=10; %How many times data is divided into testing and learning sets.
rn=1/2; % Now data is divided in half; half for the testing set and half for the learning set.

[Mean_accuracy, Variance,p1,m1]=simo2(data,v,c, measure, p, alpha, N,rn,pl)

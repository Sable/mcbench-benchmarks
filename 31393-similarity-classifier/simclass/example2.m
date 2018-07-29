data = dlmread('iris.dat'); % data file

v=[1:4];
c=5;
measure = 1; % Used similarity measure (see classifier.m) 
p = [0.1:0.25:4]; % p parameter range
m = [0.25:0.25:3]; % m parameter range 
pl=1; % Do we use plotting w.r.t. parameters p and m or not pl=0 no plotting pl=1 plotting.
N=10; %How many times data is divided into testing and learning sets.
rn=1/2; % Now data is divided in half; half for the testing set and half for the learning set.

[Mean_accuracy, Variance,p1,m1]=simclass2(data,v,c, measure, p, m, N,rn,pl)

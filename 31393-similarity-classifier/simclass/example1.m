
data = dlmread('iris.dat'); % data file
%Dividing it to testing and learning sets to this example.
datalearn=[data(1:25,:);data(51:75,:);data(101:125,:)];
datatest=[data(26:50,:);data(76:100,:);data(126:150,:)];
v=[1:4];
c=5;
measure = 1; % Used measure (see classifier.m)
p = [0.1:0.25:4]; % p parameter range
m = [0.25:0.25:8]; % m parameter range 
pl=1; % Do we use plotting w.r.t. parameters p and m or not pl=0 no plotting pl=1 plotting. 

[Classification_accuracy,p1,m1,classes]=simclass1(datalearn, datatest,v,c, measure, p, m,pl);
Classification_accuracy


disp('Or if you just want to classify with one parameter values i.e. p=1,m=1')
[Classification_accuracy,p1,m1,classes]=simclass1(datalearn, datatest,v,c, measure, 1, 1,0);
Classification_accuracy



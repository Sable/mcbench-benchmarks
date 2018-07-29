
data = dlmread('iris.dat'); % data file
%Dividing it to testing and learning sets to this example.
datalearn=[data(1:25,:);data(51:75,:);data(101:125,:)];
datatest=[data(26:50,:);data(76:100,:);data(126:150,:)];
v=[1:4];
c=5;
measure = 1; % Which quantifier to use in OWA operators you want to use. 
% Possible choices implemented:
% 1=Basic RIM quantifier
% 2=Quadratic quantifier
% 3=Exponential quantifier
% 4=Trigonometric quantifier
% 5=O'Hagans method. Note: in this case alpha in [0,1]
p = [0.1:0.25:4]; % p parameter range
alpha = [0.25:0.25:8]; % for different alpha values in generating weights for OWA 
pl=1; % Do we use plotting w.r.t. parameters p and m or not pl=0 no plotting pl=1 plotting. 

[Classification_accuracy,p1,alpha1,classes]=simo1(datalearn, datatest,v,c, measure, p, alpha,pl);
Classification_accuracy


disp('Or if you just want to classify with one parameter values i.e. p=1,alpha=1')
[Classification_accuracy,p1,m1,classes]=simo1(datalearn, datatest,v,c, measure, 1, 1,0);
Classification_accuracy



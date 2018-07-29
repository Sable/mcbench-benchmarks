%%
% Data

X1 = 0:600;  %showing off that it works even
X2 = 300:10:900; %if the lines are not all at the  
X3 = 100:5:800; %same interval

Y1 = X1.^2./500000;
Y2 = .002.*X2;
Y3 = sind(X3);

%%
% Show off multiple sets of x-values
figure(1)
clf
%Create the plot and legend
hp = plot(X1,Y1, 'r--', X2, Y2, 'b:', X3, Y3, 'k-');
hl = legend('One','Two','Three',2);
%Add the marks 
marks = {'o','x','v'};
hm = plotsparsemarkers(hp,hl, marks);

%%
% Show off staggering 
X = 0:1000;
Y1 = X.^2./500000;
Y2 = .002.*X;
Y3 = sind(X);
Y4 = log(X)/10;
figure(2)
clf

hp = plot(X,Y1, 'r--', X, Y2, 'b:', X, Y3, 'k-', X, Y4, 'm-.');
hl = legend('One','Two','Three','Four',2);

marks = {'o','x','v','square'};
hm = plotsparsemarkers(hp,hl, marks);

%%
% Works with legend less graphs too
% demonstrating other non default 
% parameers, 10 markers and no staggering
figure(3)
hp = plot(X,Y4,X,Y2);
plotsparsemarkers(hp,[],{'x','o'},10,false)
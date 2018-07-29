%% Dealing with Censored / Clipped Data
% %Copyright (c) 2011, The MathWorks, Inc.

% I have some (x,y) data 

clear all
clc

n = 100; 
x = 10*rand(n,1); 
y = 5 + .5*x + randn(n,1); 

hold off
plot(x,y,'o','Color',[.8 .8 .8]); 
hold on

foo = fit(x,y,'poly1')
plot(foo, 'k')

%% But it's censored, I can't observe values larger than 8 

c = y>8; 
o = min(y,8); 
line(x,o,'Marker','o','Color','b','LineStyle','none') 


%% If I fit a line to the data I observe, bad things happen

bar = fit(x,o, 'poly1')
plot(bar, 'red')

%% Instead I need a likelihood function that takes censoring into account 

b = polyfit(x,o,1) 
s = norm(o-polyval(b,x))/sqrt(n) 
xx = linspace(0,10); 

nloglik = @(p) - sum(log(normpdf(o(~c),p(1)*x(~c)+p(2),p(3)))) ... 
               - sum(log(1-normcdf(o(c),p(1)*x(c)+p(2),p(3)))); 
p = fminsearch(nloglik,[b,s]) 
line(xx,polyval(p(1:2),xx),'Color','b')


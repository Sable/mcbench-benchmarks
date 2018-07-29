% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code.

% Script for using different maturities


% SABR parameter
% Good model 1, bad model 2
a= zeros(1,2);
b=a; n = a; r = a;
f=a;

b(1) = 0.5;
f(1) = 0.0495;
a(1) = 0.1339 * f(1)^(1-b(1));
n(1) = 0.3843;
r(1) = -0.1595;


b(2)=0.5;
n(2)=0.2;
r(2)=-0.2;
% % forward
f(2) = 0.03;
a(2)=0.5* f(2)^(1-b(2));
%(0.2/0.5)^(1/(1-b(2)))
%1-log(0.2) / log(0.5) / log(f(2))
% maturity
t=5;
% strike range
k = 0.0001:0.0001:0.3;

y = zeros(5,length(k));


d = @(x) psabr_4_2(a(1),b(1),r(1),n(1),f(1),x,1,2,2,2,.25,10);
y(1,:) = d(k);
d = @(x) psabr_4_2(a(1),b(1),r(1),n(1),f(1),x,3,2,2,2,.25,10);
y(2,:) = d(k);
d = @(x) psabr_4_2(a(1),b(1),r(1),n(1),f(1),x,6,2,2,2,.25,10);
y(3,:) = d(k);
d = @(x) psabr_4_2(a(1),b(1),r(1),n(1),f(1),x,10,2,2,2,.25,10);
y(4,:) = d(k);


figure;plot(k,y);
legend('t=1', 't=3', 't=6','t=10');

d = @(x) psabr_4_2(a(2),b(2),r(2),n(2),f(2),x,1,2,2,2,.5,10);
y(1,:) = d(k);
d = @(x) psabr_4_2(a(2),b(2),r(2),n(2),f(2),x,3,2,2,2,.5,10);
y(2,:) = d(k);
d = @(x) psabr_4_2(a(2),b(2),r(2),n(2),f(2),x,6,2,2,2,.9,10);
y(3,:) = d(k);
d = @(x) psabr_4_2(a(2),b(2),r(2),n(2),f(2),x,10,2,2,2,.9,10);
y(4,:) = d(k);


figure;plot(k,y);
legend('t=1', 't=3', 't=6','t=10');
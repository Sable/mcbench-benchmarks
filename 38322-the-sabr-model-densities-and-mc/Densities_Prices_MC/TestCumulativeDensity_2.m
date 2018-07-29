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

% Some densities and cumulative densities for SABR

% SABR parameter
% Good model
a = zeros(1,2);
b =a; n = a; r = a;
f =a;

b(1) = 0.5;
f(1) = 0.0495;
a(1) = 0.1339 * f(1)^(1-b(1));
n(1) = 0.3843;
r(1) = -0.1595;

% Degenerate Model
a(2)=0.2;
b(2)=0.5;
n(2)=0.2;
r(2)=-0.2;
% forward
f(2) = 0.03;
% maturity
t=5;
% strike range
k = 0.0001:0.0001:0.5;

for i = 1:2
p = @(x) psabr_4_2(a(i),b(i),r(i),n(i),f(i),x,t,2,2,2,.25,20);
%p = @(x) psabr(a,b,r,n,f,x,t);
y=p(k);
figure;
plot(k,y);

%y = cumsum(y) * 0.001;
y = FSABR2(k,p);
sabr1 = @(x) svol_2(a(i), b(i), r(i), n(i), f(i), x, t);
y2 = 1-BinarySABR(f(i),k,t,sabr1,1);
figure; hold on;
plot(k,y);
plot(k,y2,'r'); hold off;

y = FSABR2x(k,p);
figure;
plot(k,y);

end

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

% Density extrapolation (older version)

% SABR parameter
% Good model
%b = 0.5; f= 0.0495; a= 0.1339 * f^(1-b); n = 0.3843; r = -0.1595;
% Degenerate Model
b=0.4;  n=0.2; r=-0.2; f = 0.05; a = 0.2 * f^(1-b);
% maturity
t=5;
% strike range
k = 0.0001:0.001:0.2;

% m
m = [1.5 2 3 4];
% mu array (lower tail)
mu = [1 2 5 10];
% nu array (upper tail)
nu = [1 2 5 10];
% lower level
l = [.25 .9 .95 .99];
% upper level
u = [1.5 1.8 2 5];

y = zeros(4,length(k));
y1 = zeros(4, length(k));

figure;
for j = 1:4;
    y(j,:) = psabr_4_2(a,b,r,n,f,k,t,m(j),mu(2),nu(2),l(2),u(2));
    y1(j,:) = sprice_4_2(a, b, r, n, f, k, t,m(j), mu(2), nu(2), l(2), u(2), 1);
end
plot(k,y);
title('Offset point');
legend('m=1', 'm=2', 'm=5', 'm=10');
figure;
%plot(k((k>kl)&(k<ku)),y1((k>kl)&(k<ku)));

figure;
for j = 1:4;
    y(j,:) = psabr_4_2(a,b,r,n,f,k,t,m(2),mu(2),nu(2),l(2),u(j));
end
plot(k,y);
title('Upper Tail');
legend('1.5 fwd', '1.8 fwd', '2 fwd', '5 fwd');

figure;
for j = 1:4;
    y(j,:) = psabr_4_2(a,b,r,n,f,k,t,m(2),mu(2),nu(2),l(j),u(2));
end
plot(k,y);
title('Lower Tail');
legend('0.25 fwd', '0.9 fwd', '0.95 fwd', '0.99 fwd');

figure;
for j = 1:4;
    y(j,:) = psabr_4_2(a,b,r,n,f,k,t,m(2),mu(2),nu(j),l(2),u(2));
end
plot(k,y);
title('Upper Tail \nu');
legend('\nu=1', '\nu=2', '\nu=5', '\nu=10');

figure;
for j = 1:4;
    y(j,:) = psabr_4_2(a,b,r,n,f,k,t,m(2),mu(j),nu(2),l(2),u(2));
end
plot(k,y);
title('Lower Tail \mu');
legend('\mu=1', '\mu=2', '\mu=5', '\mu=10');



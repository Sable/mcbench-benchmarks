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

% Density extrapolation for the SABR model (figures from book)

% SABR parameter
% Good model
%b = 0.5;
%f= 0.0495;
%a= 0.1339 * f^(1-b);
%n = 0.3843;
%r = -0.1595;
% Degenerate Model

 b=0.4;
 n=0.2;
 r=-0.2;
% %forward
 f = 0.05;
 a = 0.2 * f^(1-b);
% maturity
t=5;
% strike range
k = 0.0001:0.0001:0.2;
index = find(k==f);
indexup = find(k==0.1);

% m
m = [.6 .75 2 5];
% mu array (lower tail)
mu = [1 2 5 10];
% nu array (upper tail)
nu = [1 2 5 10];
% lower level
l = [.25 .9 .95 .99];
% upper level
u = [1.5 1.8 2 5];

y = zeros(4,length(k));

figure('Color',[1 1 1]);
for j = 1:4;
    y(j,:) = psabr_4_2(a,b,r,n,f,k,t,m(j),mu(2),nu(2),l(2),u(2));
end
hold on;
plot(k,y(1,:),'-','Color',[0 0 0]); plot(k,y(2,:),'--','Color',[0 0 0]);
plot(k,y(3,:),':','Color',[0 0 0]); plot(k,y(4,:),'-.','Color',[0 0 0]);
title('Offset point');
legend('m=0.6', 'm=0.75', 'm=2', 'm=5');
hold off;


figure('Color',[1 1 1]);
for j = 1:4;
    y(j,:) = psabr_4_2(a,b,r,n,f,k,t,m(3),mu(2),nu(2),l(2),u(j));
end
hold on;
plot(k(indexup:end),y(1,indexup:end),'-','Color',[0 0 0]); plot(k(indexup:end),y(2,indexup:end),'--','Color',[0 0 0]);
plot(k(indexup:end),y(3,indexup:end),':','Color',[0 0 0]); plot(k(indexup:end),y(4,indexup:end),'-.','Color',[0 0 0]);

title('Upper Tail Dependency on k_u');
legend('1.5 fwd', '1.8 fwd', '2 fwd', '5 fwd');
hold off;

figure('Color',[1 1 1]);
for j = 1:4;
    y(j,:) = psabr_4_2(a,b,r,n,f,k,t,m(3),mu(2),nu(2),l(j),u(2));
end
hold on;
plot(k(1:index),y(1,1:index),'-','Color',[0 0 0]); plot(k(1:index),y(2,1:index),'--','Color',[0 0 0]);
plot(k(1:index),y(3,1:index),':','Color',[0 0 0]); plot(k(1:index),y(4,1:index),'-.','Color',[0 0 0]);

title('Lower Tail Dependency on k_l');
legend('0.25 fwd', '0.9 fwd', '0.95 fwd', '0.99 fwd');
hold off;

figure('Color',[1 1 1]);
for j = 1:4;
    y(j,:) = psabr_4_2(a,b,r,n,f,k,t,m(3),mu(2),nu(j),l(2),u(2));
end
hold on;
plot(k(indexup:end),y(1,indexup:end),'-','Color',[0 0 0]); plot(k(indexup:end),y(2,indexup:end),'--','Color',[0 0 0]);
plot(k(indexup:end),y(3,indexup:end),':','Color',[0 0 0]); plot(k(indexup:end),y(4,indexup:end),'-.','Color',[0 0 0]);

title('Upper Tail Dependency on \nu_l');
legend('\mu_u=1', '\mu_u=2', '\mu_u=5', '\mu_u=10');
hold off;

figure('Color',[1 1 1]);
for j = 1:4;
    y(j,:) = psabr_4_2(a,b,r,n,f,k,t,m(3),mu(j),nu(2),l(2),u(2));
end
hold on;
plot(k(1:index),y(1,1:index),'-','Color',[0 0 0]); plot(k(1:index),y(2,1:index),'--','Color',[0 0 0]);
plot(k(1:index),y(3,1:index),':','Color',[0 0 0]); plot(k(1:index),y(4,1:index),'-.','Color',[0 0 0]);

title('Lower Tail Dependency on \mu_l');
legend('\mu_l=1', '\mu_l=2', '\mu_l=5', '\mu_l=10');
hold off;


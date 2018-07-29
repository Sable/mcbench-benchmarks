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

% SABR density using several representation of densities

% Init
a= zeros(1,2);
b=a; n = a; r = a;
f=a;

% SABR parameter - Good model
f(1)= 0.0495; b(1) = 0.6;
a(1)= 0.1339 * f(1)^(1-b(1));
n(1) = 0.3843; r(1) = -0.1595;

% SABR parameter - Nasty Model
b(2)=0.7; n(2)=0.42; r(2)=-0.243;
f(2) = 0.041;
a(2)=0.1776*f(2)^(1-b(2));

% SABR parameter - Some Model
f(3) = 0.05;
b(3) = 0.5; n(3) = 0.2;
r(3) = -0.7; a(3) = 0.2*f(3)^(1-b(3));

% maturity
t=5;

% strike ranges
ms = 0.01;
d1 = (0.2-ms*0.5)/200;
d2 = (0.2-ms*0.5-0.0001)/200;
d3 = (1-0.001)/200;
k1 = (ms*0.5):d1:0.2;
k2 = 0.0001:d2:(0.2-ms*0.5);
k3 = 0.001:d3:1;
k = zeros(3,length(k1));
k(1,:) = k1;
k(2,:) = k2;
k(3,:) = k3;
y = zeros(9,length(k));

for i = 1:3
    % Try out the different densities
%p = @(x) psabr_4_2(a(i),b(i),r(i),n(i),f(i),x,t,2,2,2,.25,20);
%p = @(x) psabr_4_2(a(i),b(i),r(i),n(i),f(i),x,t,2,2,2,.25,25.5);
p = @(x) psabr_4(a(i),b(i),r(i),n(i),f(i),x,t);
%p = @(x) psabr(a(i),b(i),r(i),n(i),f(i),x,t);
y(3*(i-1)+1,:)=p(k(i,:));
%figure;
%plot(k,y(3*(i-1)+1,:));

%y = cumsum(y) * 0.001;
y(3*(i-1)+2,:) = FSABR2(k(i,:),p);
%figure;
%plot(k,y(3*(i-1)+2,:));

y(3*(i-1)+3,:) = FSABR2x(k(i,:),p);
%figure;
%plot(k,y(3*(i-1)+3,:));

end
figure; hold on; plot(k1,y(2,:),'g');plot(k1,y(3,:),'r'); hold off;
title('Determining Optimal Strikes');
legend('1-CDF; CMS 1', '1-CDF; CMS 2');

% Findning indices for Triangle arbitrage
i1=find(y(2,:)-y(5,:)<0,1,'first');
i2=find(y(2,:)-y(5,:)<0,1,'last');

figure; hold on; plot(k1,y(3,:),'g');plot(k1,y(5,:),'r'); hold off;
title('Determining Optimal Strikes');
legend('CDF; CMS 1', '1-CDF; CMS 2');
i3 = find(y(3,:)-y(5,:)<0,1,'first'); 

figure; hold on; plot(k3,y(8,:),'g');plot(k3,y(9,:),'r'); hold off;
title('Determining Optimal Strikes');
legend('CDF; CMS 1', '1-CDF; CMS 2');



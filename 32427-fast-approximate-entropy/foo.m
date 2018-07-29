% foo.m
%
% This m-file shows an example of how to use ApEn function
% 
% More specifically, it generates three simulated data with different
% complexity (sine, chirp, and Gaussian noise), and plots the ApEn values
% with varying r

%-------------------------------------------------------------------------
% coded by Kijoon Lee, kjlee@ntu.edu.sg
% Mar 21st, 2012
%-------------------------------------------------------------------------
clear all

m = 2;      % embedded dimension
tau = 1;    % time delay for downsampling
N = 1000;
t = 0.001*(1:N);

% generate simulated data
sint = sin(2*pi*10*t);      % sine curve
chirpt = chirp(t,0,1,150);  % chirp signal
whitet = randn(1,N);        % white noise

% calculate standard deviations
sd1 = std(sint);
sd2 = std(chirpt);
sd3 = std(whitet);

% specify the range of r
rnum = 30;
result = zeros(3,rnum);

% main calculation and display
figure
for i = 1:rnum
    r = i*0.02;
    result(1,i) = ApEn(m, r*sd1, sint, tau);
    result(2,i) = ApEn(m,r*sd2,chirpt, tau);
    result(3,i) = ApEn(m,r*sd3,whitet, tau);
end

r = 0.02*(1:rnum);
plot(r,result(1,:),'o-',r,result(2,:),'o-',r,result(3,:),'o-')
axis([0 rnum*0.02 0 1.05*max(result(:))])
legend('sin','chirp','white noise')
title(['ApEn, m=' num2str(m) ', \tau=' num2str(tau)],'fontsize',14)
xlabel r


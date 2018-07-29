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

% Script illustratin the application of density extrapolation and
% the Doust method from RISK "No-Arbitrage SABR"
clear; clc;
xgrid = 0.001;
xvals = 0.0001:xgrid:1;

alpha = [0.025 0.05 0.15 0.25 0.5];
beta = .4;
rho = -.1;
nu = 0.4;
fwd = 0.0488;
t = 2;
eps = .1;

m = 2;
mu_l = 2;
mu_u = 2;
kl = .5;
ku = 15;

load('Doust_d0.mat')
[x1,x2,x3,x4,x5] = ndgrid(sabrVol',sabrbeta',sabrrho',sabrnu',sabrtau');

yvals1 = zeros(4,length(xvals));
yvals2 = yvals1;
yvals3 = yvals2;
yvals4 = yvals2;

JKHadmissible = zeros(1,length(alpha));
Doust = JKHadmissible;
JKDadmissible = Doust;
pabsorb1 = Doust;
pabsorb = Doust;
tmax = zeros(length(alpha),length(xvals));

for jj = 1:length(alpha)
    yvals2(jj,:)= psabr_6(alpha(jj),beta,rho,nu,fwd,xvals,t,eps);                   % Doust
    yvals1(jj,:)= psabr_4_2(alpha(jj),beta,rho,nu,fwd,xvals,t,m,mu_l,mu_u,kl,ku);   % JK mit Hagan admissible region
    % find kl
   % G = @(x,y) 1 - xgrid*sum(psabr_4_2(alpha(jj),beta,rho,nu,fwd,xvals,t,m,x,mu_u,kl,ku));
   % klz = fzero(G,1)
   % klz

    yvals3(jj,:) = psabr_6_2(alpha(jj),beta,rho,nu,fwd,xvals,t,m,mu_l,mu_u,kl,ku);  % JK mit Doust admissible region
    yvals4(jj,:) = psabr(alpha(jj),beta,rho,nu,fwd,xvals,t);                        % Hagan Original
    figure('Color',[1 1 1]);
    hold on; plot(xvals,yvals1(jj,:),'r'); plot(xvals,yvals2(jj,:),'o-','MarkerSize',3); 
    plot(xvals,yvals3(jj,:),'gx'); plot(xvals,yvals4(jj,:),'-.');
    legend('JK (Hagan admissible)','PD','JK (Doust admissible)','Hagan');
    titlename = 'SABR Probability Density for \alpha= '; titlename = strcat(titlename,num2str(alpha(jj)));
    title(titlename);
    hold off;
    figure('Color',[1 1 1]);
    hold on; plot(xvals(xvals<fwd),yvals1(jj,(xvals<fwd)),'r'); plot(xvals(xvals<fwd),yvals2(jj,(xvals<fwd)),'o-','MarkerSize',3); 
    plot(xvals(xvals<fwd),yvals3(jj,(xvals<fwd)),'gx'); plot(xvals(xvals<fwd),yvals4(jj,(xvals<fwd)),'-.');
    legend('JK (Hagan admissible)','PD','JK (Doust admissible)','Hagan');
    titlename = 'Left Tail for \alpha= '; titlename = strcat(titlename,num2str(alpha(jj)));
    title(titlename);
    hold off;
    index = isnan(yvals1(jj,:)); JKHadmissible(jj) = sum(yvals1(jj,~index))*xgrid;
    index = isnan(yvals2(jj,:)); Doust(jj) = sum(yvals2(jj,~index))*xgrid;
    index = isnan(yvals3(jj,:)); JKDadmissible(jj) = sum(yvals3(jj,~index))*xgrid;
    pabsorb(jj) = interpn(x1,x2,x3,x4,x5,d0,min(alpha(jj)*fwd^(beta-1),1),beta,rho,nu,t,'linear');
    pabsorb1(jj) = 1-Doust(jj);
    tmax(jj,:) = sabrtmax(alpha(jj),beta,rho,nu,fwd,xvals,t);
    titlename = '\tau_{max} for \alpha= '; titlename = strcat(titlename,num2str(alpha(jj)));
    figure('Color',[1 1 1]); plot(tmax(jj,:));title(titlename);
end

figure('Color', [1 1 1]); hold on; plot(alpha,1-JKHadmissible,'r'); plot(alpha, 1-Doust,'g'); 
plot(alpha, 1-JKDadmissible); plot(alpha, pabsorb,'go'); plot(alpha,pabsorb1,'rx'); hold off;
title('Cumulated Probability');
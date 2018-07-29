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

% Test script for illustrating the combination of density extrapolation
% and the method by P. Doust (older version)

xgrid = 0.001;
xvals = 0.0001:xgrid:1;

alpha = [0.05 0.15 0.25 0.5];
beta = .5;
rho = -.1;
nu = 0.4;
fwd = 0.0488;
t = 10;
eps = 1;

m = 5;
mu_l = 3;
mu_u = 3;
kl = .1;
ku = 35;


yvals1 = zeros(4,length(xvals));
yvals2 = yvals1;
yvals3 = yvals2;
yvals4 = yvals2;

for jj = 1:4
    yvals2(jj,:)= psabr_6(alpha(jj),beta,rho,nu,fwd,xvals,t,eps);                   % Doust
    yvals1(jj,:)= psabr_4_2(alpha(jj),beta,rho,nu,fwd,xvals,t,m,mu_l,mu_u,kl,ku);   % JK mit Hagan admissible region
    yvals3(jj,:) = psabr_6_2(alpha(jj),beta,rho,nu,fwd,xvals,t,m,mu_l,mu_u,kl,ku);  % JK mit Doust admissible region
    yvals4(jj,:) = psabr(alpha(jj),beta,rho,nu,fwd,xvals,t);                        % Hagan Original
    figure('Color',[1 1 1]);
    hold on; plot(xvals,yvals1(jj,:),'r'); plot(xvals,yvals2(jj,:),'o-','MarkerSize',3); 
    plot(xvals,yvals3(jj,:),'gx'); plot(xvals,yvals4(jj,:),'-.');
    legend('JK','PD','JKPDCut','H');
    titlename = '\alpha= '; titlename = strcat(titlename,num2str(alpha(jj)));
    title(titlename);
    hold off;
    JK = sum(yvals1(jj,:))*xgrid
    PD = sum(yvals2(jj,:))*xgrid
    JKPD = sum(yvals3(jj,:))*xgrid

    
end
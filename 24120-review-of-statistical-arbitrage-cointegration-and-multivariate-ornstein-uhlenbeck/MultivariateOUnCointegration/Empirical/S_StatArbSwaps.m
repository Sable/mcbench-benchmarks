% this script search for cointegrated stat-arb strategies among swap contracts 
% see A. Meucci (2009) 
% "Review of Statistical Arbitrage, Cointegration, and Multivariate Ornstein-Uhlenbeck"
% available at ssrn.com

% Code by A. Meucci, April 2009
% Most recent version available at www.symmys.com > Teaching > MATLAB

clear; clc; close all

%%%%%% estimation  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load DB_SwapParRates
S=cov(Rates);
[E,Lam]=pcacov(S);


figure % set up dates ticks
h=plot(Dates,Dates); 
a=get(gca,'XTick');
XTick = [];
years = year(Dates(1)):year(Dates(end));
for n = years
    XTick = [XTick datenum(n,1,1)];
end
a=min(Dates); 
b=max(Dates); 
X_Lim=[a-.01*(b-a) b+.01*(b-a)];
close

for n=1:length(Lam)
    Y=Rates*E(:,n)*10000;
    [Mu,Theta,Sigma]=FitOU(Y,1/252);
    Sd_Y=sqrt(Sigma/(2*Theta));
    Thetas(n)=Theta;
    
    figure
    current_line=0*Dates+Y(end);
    Mu_line=0*Dates+Mu;
    Z_line_up=Mu_line+Sd_Y;
    Z_line_dn=Mu_line-Sd_Y;
        
    plot(Dates,Y)
    hold on
    plot(Dates,Mu_line,'k','linewidth',1);
    hold on
    plot(Dates,Z_line_up,'r','linewidth',1)
    hold on
    plot(Dates,Z_line_dn,'r','linewidth',1)
    hold on
    plot(Dates,current_line,'g','linewidth',1)
    
    
    set(gca,'xlim',X_Lim,'XTick',XTick);
    datetick('x','yy','keeplimits','keepticks');
    grid off
    title(['eigendirection n. ' num2str(n) ',    theta = ' num2str(Theta)],'FontWeight','bold');
    xlabel('year','FontWeight','bold');
    ylabel('basis points','FontWeight','bold');
    
    
end

figure
plot(1:length(Lam),Thetas)
xlabel('eigendirection n. ','FontWeight','bold');
ylabel('theta','FontWeight','bold');
    
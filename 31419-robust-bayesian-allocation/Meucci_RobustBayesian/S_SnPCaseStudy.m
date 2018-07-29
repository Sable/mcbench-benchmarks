% ========================= 
%  Robust Bayesian allocation in the stock market, as described in
%  Meucci, A., (2005) "Robust Bayesian Allocation"
% 
%  Most recent version of article and code available at http://symmys.com/node/102
%  =========================

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputs
p_m=.1; % robustness parameter location
p_s=.1; % robustness parameter scatter
load SectorsSnP500

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute weekly returns
Ps=P(1:5:end,:);
R=Ps(2:end,:)./Ps(1:end-1,:)-1;
Dates_P=DP(1:5:end);
Dates_R=Dates_P(2:end);
[Ttot,N]=size(R);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estimation
W=52; % rolling estimation period
NumPortf=10;
Ret_hat=[];
Ret_rB=[];
Dates=[];
for t=W+1:Ttot-1
    Ttot-t+2
    Rets=R(t-W:t,:);

    % sample estimate
    m_hat=mean(Rets)';
    S_hat=cov(Rets);
    [de_hat,ds_hat,w_hat] = EfficientFrontier(NumPortf, S_hat, m_hat);

    % Bayesian prior
    S0=diag(diag(S_hat));
    m0=.5*S0*ones(N,1)/N;
    T=size(Rets,1);
    T0=2*T;
    nu0=2*T;

    % Bayesian posterior parameters
    T1=T+T0;
    m1=1/T1*(m_hat*T+m0*T0);
    nu1=T+nu0;
    S1=1/nu1*( S_hat*T + S0*nu0 + (m_hat-m0)*(m_hat-m0)'/(1/T+1/T0)  );
    [d,d,w1] = EfficientFrontier(NumPortf, S1, m1);

    % robustness parameters
    q_m2=chi2inv(p_m,N);
    g_m=sqrt(q_m2/T1*nu1/(nu1-2));
    q_s2=chi2inv(p_s,N*(N+1)/2);
    PickVol=round(.8*NumPortf);
    v=(ds_hat(PickVol))^2;
    g_s=v/(  nu1/(nu1+N+1)+sqrt( 2*nu1*nu1*q_s2/((nu1+N+1)^3)));
    
    Target=[];
    
    wu=w_hat(PickVol,:)';
    Ret_hat=[Ret_hat R(t+1,:)*wu];

    for k=1:NumPortf-1
        NewTarget=-(10^10);
        if wu'*S1*wu <= g_s
            NewTarget = m1'*wu-g_m*sqrt(wu'*S1*wu);
        end
        Target=[Target NewTarget];
    end

    [Best,k]=max(Target);
    wu=w1(k,:)';
    Ret_rB=[Ret_rB R(t+1,:)*wu];
    
    Dates=[Dates Dates_R(t+1)];
end

NAV_hat=cumprod(1+Ret_hat);
NAV_rB=cumprod(1+Ret_rB);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plots

figure
subplot(2,1,1)
h=plot(Dates,Ret_hat);
xlim([Dates(1) Dates(end)])
YLim=get(gca,'ylim');
Datetick('x','mmmyy','keeplimits','keepticks');
grid on
subplot(2,1,2)
h=plot(Dates,Ret_rB);
set(gca,'ylim',YLim,'xlim',[Dates(1) Dates(end)]);
Datetick('x','mmmyy','keeplimits','keepticks');
grid on

figure
subplot(2,1,1)
h=plot(Dates,NAV_hat);
xlim([Dates(1) Dates(end)])
YLim=get(gca,'ylim');
Datetick('x','mmmyy','keeplimits','keepticks');
grid on
subplot(2,1,2)
h=plot(Dates,NAV_rB);
set(gca,'ylim',YLim,'xlim',[Dates(1) Dates(end)]);
Datetick('x','mmmyy','keeplimits','keepticks');
grid on
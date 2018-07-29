function [Rt]=RateSimCIR(theta,kappa,sigma,lambda,dt,ratestart,months,tau)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CIR term structure simulation, inputs below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear all
% theta=0.10;
% kappa=0.05;
% sigma=0.075;
% lambda=-0.4;
% dt=1/12;
% months=120;
% ratestart=0.10;
% tau=[3/12,6/12,2,5];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Short Rate Dynamics
rt(1)=ratestart;
for i=1:months*4
    rt(i+1)=rt(i)+kappa*(theta-rt(i))*dt/4+sqrt(rt(i))*sigma*sqrt(dt/4)*randn(1);
end
% Term Structure Dynamics
for i=1:months
    rttemp=rt(i*4-3);
    rttemp1(i)=rt(i*4-3);
    for j=1:numel(tau)
        AffineG=sqrt((kappa+lambda)^2+2*sigma^2);                           
        AffineB=2*(exp(AffineG*tau(j))-1)/((AffineG+kappa+lambda)...
            *(exp(AffineG*tau(j))-1)+2*AffineG);                            
        AffineA=2*kappa*theta/(sigma^2)*log(2*AffineG*...
            exp((AffineG+kappa+lambda)*tau(j)/2)/((AffineG+kappa+lambda)*...
            (exp(AffineG*tau(j))-1)+2*AffineG));                            
        A(j)=-AffineA/tau(j);       
        B(j)=AffineB/tau(j);        
        Rt(i,j)=A(j)+B(j)*rttemp;
    end
end
Rt;

%%%%%%%%%%%%% MAKE THE GRAPH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rt;
% figure(2)
% surf(tau,1:120,Rt)
% xlabel('Time to Maturity (Fixed)')
% ylabel('Months Passed')
% title('A Given Simulation of the Term Structure (CIR)')

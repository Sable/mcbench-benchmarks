function [Rt]=RateSimVASICEK(theta,kappa,sigma,lambda,dt,ratestart,months,tau)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VASICEK term structure simulation, inputs below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear all
% theta=0.06;
% kappa=0.05;
% sigma=0.005;
% lambda=-0.2;
% dt=1/12;
% months=120;
% ratestart=0.06;
% tau=[3/12,6/12,2,5];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Short Rate Dynamics
rt(1)=ratestart;
for i=1:months*4
    rt(i+1)=rt(i)+kappa*(theta-rt(i))*dt/4+sigma*sqrt(dt/4)*randn(1);
end    
% Term Structure Dynamics
for i=1:months
   rttemp=rt(i*4-3);
   rttemp1(i)=rt(i*4-3);
for j=1:numel(tau)
        AffineG=kappa^2*(theta-(sigma*lambda)/kappa)-sigma^2/2;    
        AffineB=1/kappa*(1-exp(-kappa*tau(j)));                    
        AffineA=AffineG*(AffineB-tau(j))/kappa^2-(sigma^2*AffineB^2)/(4*kappa);   
        A(j)=-AffineA/tau(j);     
        B(j)=AffineB/tau(j);     
        Rt(i,j)=A(j)+B(j)*rttemp;
end
end

%%%%%%%%%%%%% MAKE THE GRAPH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rt;
% figure(2)
% surf(tau,1:120,Rt)
% xlabel('Time to Maturity (Fixed)')
% ylabel('Months Passed')
% title('A Given Simulation of the Term Structure (Vasicek)')

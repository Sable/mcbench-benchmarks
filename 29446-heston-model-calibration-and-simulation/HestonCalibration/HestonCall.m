function C=HestonCall(St,K,r,T,vt,kap,th,sig,rho,lda)
%--------------------------------------------------------------------------
%PURPOSE: computes the option price using Heston's model.
%--------------------------------------------------------------------------
%USAGE: C=HestonCall(St,K,r,sig,T,vt,kap,th,lda,rho)
%--------------------------------------------------------------------------
%INPUT: St - scalar or vector, price of underlying at time t
%       K - scalar or vector, strike price
%       r - scalar or vector, continuously compound risk free rate expressed as a
%       positive decimal number.
%       sig- scalar or vector, volatility of the volatility of the
%       underlying(same time units as for r)  
%       T - scalar or vector, time to maturity (same time units as for r)
%       vt - scalar or vector, instantaneous volatility
%       kap - scalar or vector, is the rate at which vt reverts to th
%       th - scalar or vector, is the long vol, or long run average price
%       volatility; as t tends to infinity, the expected value of ?t tends to ? 
%       lda - scalar or vector, risk premium for volatility
%       rho - scalar or vector, correlation between underlying and
%       volatility (rho<0 generates the leverage effect)
%--------------------------------------------------------------------------
%OUTPUT: C - scalar or vector, Heston's model call option price
%--------------------------------------------------------------------------


dphi=0.01;
maxphi=50;
phi=(eps:dphi:maxphi)';

%f1 = CF_SVj(log(St),vt,T,r,kap*th,0.5,kap+lda-rho*sig,rho,sig,phi);
%P1 = 0.5+(1/pi)*sum(real(exp(-i*phi*log(K)).*f1./(i*phi))*dphi);
%f2 = CF_SVj(log(St),vt,T,r,kap*th,-0.5,kap+lda,rho,sig,phi);
%P2 = 0.5+(1/pi)*sum(real(exp(-i*phi*log(K)).*f2./(i*phi))*dphi);
%C = St*P1 -K*exp(-r*T)*P2;


f1 = CF_SVj(log(St),vt,T,0,kap*th,0.5,kap+lda-rho*sig,rho,sig,phi);
P1 = 0.5+(1/pi)*sum(real(exp(-i*phi*log(K)).*f1./(i*phi))*dphi);
f2 = CF_SVj(log(St),vt,T,0,kap*th,-0.5,kap+lda,rho,sig,phi);
P2 = 0.5+(1/pi)*sum(real(exp(-i*phi*log(K)).*f2./(i*phi))*dphi);
C = St*P1 -K*exp(-r*T)*P2;


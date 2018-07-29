function PnL=HorizonPricing(Butterflies,X)

r=.04;       % risk-free rate
tau=1/252;   % investment horizon

%  factors: 1. 'MSFT_close'   2. 'MSFT_vol_30'   3. 'MSFT_vol_91'   4. 'MSFT_vol_182'
%  securities:                1. 'MSFT_vol_30'   2. 'MSFT_vol_91'   3. 'MSFT_vol_182'
for s=1:3
    Butterflies(s).DlnY=X(:,1);
end
Butterflies(1).Dsig=X(:,2);
Butterflies(2).Dsig=X(:,3);
Butterflies(3).Dsig=X(:,4);

%  factors:  5. 'YHOO_close'   6. 'YHOO_vol_30'   7. 'YHOO_vol_91'   8. 'YHOO_vol_182'
%  securities:                 4. 'YHOO_vol_30'   5. 'YHOO_vol_91'   6. 'YHOO_vol_182'
for s=4:6
    Butterflies(s).DlnY=X(:,5);
end
Butterflies(4).Dsig=X(:,6);
Butterflies(5).Dsig=X(:,7);
Butterflies(6).Dsig=X(:,8);

%  factors:  %  9. 'GOOG_close'  10. 'GOOG_vol_30'  11. 'GOOG_vol_91'  12. 'GOOG_vol_182'
%  securities:                    7. 'GOOG_vol_30'   8. 'GOOG_vol_91'   9.  'GOOG_vol_182'
for s=7:9
    Butterflies(s).DlnY=X(:,9);
end
Butterflies(7).Dsig=X(:,10);
Butterflies(8).Dsig=X(:,11);
Butterflies(9).Dsig=X(:,12);

PnL=[];
for s=1:length(Butterflies)
    Y=Butterflies(s).Y_0*exp(Butterflies(s).DlnY);
    ATMsig=max(Butterflies(s).sig_0+Butterflies(s).Dsig,10^(-6));
    t=Butterflies(s).T-tau;
    K=Butterflies(s).K;
    sig=MapVol(ATMsig,Y,K,t);

    [C,P]=blsprice(Y,K,r,t,sig);
    Butterflies(s).P_T=C+P;
    PnL=[PnL Butterflies(s).P_T];
end
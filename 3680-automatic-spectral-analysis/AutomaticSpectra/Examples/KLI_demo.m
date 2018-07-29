%KLI_demo

% S. de Waele, March 2003.

clear

a = 1;
b = rc2arset([1 -.3 .4]);
varx = 1;

nobs = 200;
x = gendata(a,b,nobs);

Lmax = 50;
ASAglob_subtr_mean = 0;
arh = sig2ar(x,Lmax);
varh= mean(x.^2);

%Fit of model to data
%And Auto-KLI
%These quantities should be equal according to eq. 4.14 on page 88

ar_set = ar2arset(arh,0:Lmax);
for t = 0:Lmax
    kli_hat(t+1) = KLIndex_hat(x,ar_set{t+1},1,varh);
    kli_auto(t+1) = KLIndex(ar_set{t+1},1,varh,ar_set{t+1},1,varh,nobs);
end

%Kullback-Leibler index (KLI)
%for increasing AR model order
[dummy, set_kli] = KLIndex(arh,1,1,a,b,varx,nobs);

%Kullback-Leibler Discrepancy (KLI)
%The KLD is equal to the KLI apart from a constant
[dummy, set_kld] = KLDiscrepancy(arh,1,1,a,b,varx,nobs);

%Akaike information criterion
aic = kli_hat + 2*(0:Lmax);

plot(0:Lmax,[set_kld' set_kli' kli_hat'],0:Lmax,kli_auto,'-.',0:Lmax,aic)
xlabel('p')
ylabel('KL')
legend('KLD','KLI','KLI_{hat}','KLI_{auto}','AIC')
legend boxoff

title('Fit and error and AIC for estimated AR models.')


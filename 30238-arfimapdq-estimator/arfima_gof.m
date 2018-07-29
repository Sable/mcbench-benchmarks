%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%        Jan Beran's goodness of fit test for ARFIMA(p,d,q) models
%%
%%         H0: empirical spectrum == fitted spectrum
%%         H1: empirical spectrum ~= fitted spectrum
%%
%%      [pval,Tn] = arfima_gof(Z,params,arma_part,wn_var)
%%
%%    [pval,Tn] = arfima_gof(Z,params,arma_part,wn_var,display)
%%
%% Input: Z - the time series
%%
%%        params - a size (1,1+p+q) parameter vector with 
%%                 d phi_1 ... phi_1 ... phi_p theta_1 ...
%%                 ... theta_q ; d =0 for ARMA(p,q) models
%%
%%        arma_part - [p q],where p is the AR and q is the MA lag length 
%%
%%        wn_var - the estimated white noise sequence's variance
%%
%%        display - optional: whether to display the estimated
%%                  autocovariance and autocorrelation of the 
%%                  (hopefully) white noise process. 'DISP' if
%%                  you'd like to display. Default is: no plot.
%%
%% Output: pval - the p-value of the test statistics
%%
%%         Tn - the test statistics evaluated @params 
%%
%% References: Beran, Jan: Statistics for Long memory processes. 
%%                         Chapman & Hall, New York(1994)
%%
%% Copyright: György Inzelt 01-02-2011
%%            inzeltgy@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[pval,Tn] = arfima_gof(Z,params,arma_part,wn_var,display)
  switch nargin
      case 4
          disp_ind =0;
      case 5 
          switch(display)
              case('DISP')
          disp_ind = 1;        
              otherwise
          disp_ind = 0;         
          end
  end
%One might be interested in comparing the goodness-of-fit of a 
%- say - ARFIMA(5,0,0) versus an ARFIMA(1,d,0) model.
[Pxx,w] = periodogram(Z);
Y = Pxx;
w(1,1) = w(2,1)/2;%zero must be excluded

%extracting the parameters
%checking tha ARMA part
l_params = length(params(1,:));

switch(l_params)
    case(1)
d = params(1,1);
theta = 0;
phi =0;
    otherwise
d = params(1,1);     
     if  arma_part(2) == 0, phi = params(1,2:2+arma_part(1)-1)    ; theta =0;
       elseif arma_part(1) ==0,theta = params(1,2:2+arma_part(2)-1)   ; phi =0;
       elseif arma_part(1) ~=0 && arma_part(2) ~=0, phi = params(1,2:2+arma_part(1)-1);
              theta =params(1,2+arma_part(1):2+sum(arma_part)-1);    
     end     
end

%calculating the fractional part in the periodogram
x = exp(-sqrt(-1)*w);  
x = abs(1-x);
x(1,1) = abs(1-exp(-sqrt(-1)*w(1,1)))^(-2*d);
x(2:length(x),1) = x(2:length(x),1).^(-2*d);
%calculating the ARMA part in the periodogram
%and putting together the analytical spectrum
ei = ones(length(Y),1);
MA_ncausal = ei + exp( -sqrt(-1)*w.*ei*(1:1:length(theta)))*theta' ;
MA_causal = ei +  exp( sqrt(-1)*w.*ei*(1:1:length(theta)))*theta'   ;
AR_ncausal =  ei + exp( -sqrt(-1)*w.*ei*(1:1:length(phi)))*-phi'   ;
AR_causal = ei + exp( sqrt(-1)*w.*ei*(1:1:length(phi)))*-phi'   ;

%calculating the estimated white noise covariances
gamma_et_k = zeros(length(Z)-1,1);

for kk = 1:1:length(Z)-1
  %cos_wj = zeros(length(w),1);
  cos_wj = cos((kk-1)*w);
  gamma_et_k(kk) = ((wn_var*pi)/length(Z))*sum(( Y./ (( wn_var/(2))*x.*((MA_ncausal.*MA_causal)./(AR_ncausal.*AR_causal)))).*cos_wj);
end

%rho_et_k = zeros(length(Z)-1,1);
rho_et_k = (1/gamma_et_k(1))*gamma_et_k;
%displaying the autocorrelations and the autocovariances
if disp_ind ==1
subplot(2,1,1)
plot(rho_et_k);title('Estimated autocorrelation of the noise sequence');hold on
subplot(2,1,2)
plot(gamma_et_k);title('Estimated autocovariance of the noise sequence');hold off 
end

Tn = (1/(2*pi))*sum(rho_et_k.^2);
pval = 1 - normcdf( (sqrt((length(Z)/2)))*(Tn*pi-1),0,1) ;

end
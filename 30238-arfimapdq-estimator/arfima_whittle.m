%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% - - Whittle approximate MLE estimator for ARFIMA processes. - -
%% My advice is to start the algorithm with the periodogram regression 
%% estimator's parameter output, otherwise you'd have to make a grid 
%% search. Works separately as well, however.
%%
%%              [LL] = arfima_whittle(params,Z,arma_part)
%%
%%                   Input: 
%%
%% Params = [d phi_1 ... phi_p ... theta_1 ... theta_p]
%% Where:  d        is the fractional differencing parameter
%%         phi_j    the AR coefficients
%%         theta_k  the MA coefficients
%%        
%% Z       = the time series
%%
%% arma_part = the AR and MA lag
%%
%%                    Output:
%%
%% LL, the likelihood function value. Minimized by fmincon. 
%%
%% References: Beran, Jan: Statistics for Long memory processes. 
%%                         Chapman & Hall, New York(1994)
%%
%%             Brockwell, P. - Davis, R.: Time Series Analysis.Ch.12.4.
%%                         Springer Verlag, New York(1993)
%%
%% Copyright: György Inzelt 28-01-2011
%%            inzeltgy@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[LL] = arfima_whittle(params,Z,arma_part)
%the sample spectrum
[Pxx,w] = periodogram(Z);
Y = Pxx;
w(1,1) = w(2,1)/2;%zero must be excluded

%gathering the parameters
l_params = length(params);
        switch(l_params)
            case(1)
            d = params(1);
                theta = 0;
                phi =0;
            otherwise
            d = params(1);     
                if  arma_part(2) == 0, phi = params(2:2+arma_part(1)-1)    ; theta =0;
                    elseif arma_part(1) ==0,theta = params(2:2+arma_part(2)-1)   ; phi =0;
                    elseif arma_part(1) ~=0 && arma_part(2) ~=0, phi = params(2:2+arma_part(1)-1);
                    theta =params(2+arma_part(1):2+sum(arma_part)-1);    
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

f_lambda =  (1/(2*pi))*x.*((MA_ncausal.*MA_causal)./(AR_ncausal.*AR_causal));

LL =  ( (1/length(Z))*sum( Y./( f_lambda )));

message = sprintf('%s %15.5f','Likelihood function value:',LL);
disp(message)

end
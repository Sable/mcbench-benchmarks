% Program to simulate Rayleigh fading using a p-th order autoregressive model AR(p) according to 
% Baddour's work: "Autoregressive modeling for fading channel simulation", IEEE Transaction on Wireless Communications, July 2005.

function [chann]=Rayleigh_fading(P,M,fm,fs,epselonn)
    % P: AR model order
    % M: number of samples
    % fd: maximum doppler frequency in Hz
    % fs: Symbol frequency in ksps
    % epselonn: added bias, depends on the Doppler rate, see the paper "Autoregressive modeling for fading channel simulation". 
   
    % usage: Rayleigh_fading(100,10000,150,3,0.00000001)
    
   
    %-------------------------------------------------------------------------------------------------------------------------   
     
        for p=1:P+1
          vector_corr(p)=besselj(0,2*pi*fm*(p-1)/(fs*1000)); % Bessel autocorrelation function according to Jakes' model
        end
        
        auto_correaltion_matrix=toeplitz(vector_corr(1:P))+eye(P)*epselonn; % adding a small bias, epselonn, to the autocorrelation matrix to overcome the ill conditioning of Yule-Walker equations
        AR_parameters=-inv(auto_correaltion_matrix)*vector_corr(2:P+1)'; % Solving the Yule-Walker equations to obtain the model parameters
        segma_u=auto_correaltion_matrix(1,1)+vector_corr(2:P+1)*AR_parameters;
        
        KKK=2000;
   
        h=filter(1,[1 AR_parameters.'],wgn(M+KKK,1,10*log10(segma_u),'complex')); % Use the function Filter to generate the channel coefficients
        chann=h(KKK+1:end,:);  % Ignore the first KKK samples
         
    %------------------------------------------------------------------------------------------------------------------------- 
    

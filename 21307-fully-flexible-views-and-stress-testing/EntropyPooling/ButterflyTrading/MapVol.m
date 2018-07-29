function s=MapVol(sig,y,K,T)
% in real life a and b below should be calibrated to security-specific time series

a=-.00000000001; 
b= .00000000001; 

s = sig + a/sqrt(T)*(log(K)-log(y)) + b/T*(log(K)-log(y)).^2;
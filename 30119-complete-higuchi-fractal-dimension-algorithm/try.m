%Generate Weierstrauss Cosine (WSC) fucntion usind the matlab
%function, wsc with following parameters:
%No. of samples, N=1024
%Hurst exponent,H=0.5 i.e., Fractal dimension, FDth=1.5
%Remaining parameters=default values
x=wsc(1024,5,26,0.5);
%Estimate the fractal dimension of the generated WSC function using
%the matlab function, hfd with the following parameter:
%kmax=256
xfd=hfd(x,256);
%(1) Try the second command for various values of kmax
%(2) Try the first command for various values of H (i.e., FDth)
%(3) Try the above two commands for various commbinations of the said parameters
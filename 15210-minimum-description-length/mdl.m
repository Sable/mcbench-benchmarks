function x=mdl(m)
%MDL  Returns Rissanen's Minimum Description Length.
% m=model that has been estimated using System Identication toolbox.
% This function requires System Identification toolbox to work.
% Plug-compatible with built-in functions aic(m) and fpe(m).
% MDL can be used like AIC or FPE to compare models of different
% complexities.  Choose model with lowest MDL or AIC or FPE.
% Pintelon & Schoukens (2001) pp. 329,550 say MDL is better 
% than AIC; AIC tends to select a too-complex model.
% Example: Compute & print MDL and AIC for an AR model of order 10.
%   Data=iddata(y,[],1/Fs);
%   m_fb=ar(Data,10,'fb');
%   fprintf('MDL=%.3d; AIC=%.3f\n',mdl(m_fb),aic(m_fb));
% William C Rose 2007-06-05.

d=size(m,'Npar');   % d=number of model parameters
N=m.es.DataLength;  % N=number of data points fitted
V=m.es.LossFcn;     % V=loss function;
x=V*(1+d*log(N)/N); % Rissanen's Minimum Description Length
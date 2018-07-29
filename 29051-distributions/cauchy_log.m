function LLF = cauchy_log(parameters,data)
%---------------------------------------------------
% PURPOSE: 
%  Log Likelihood function of the Cauchy-Lorentz Distribution, 
%  to estimate the location and scale parameters of a data set 
%---------------------------------------------------
% USAGE: 
% LLF = cauchy_log(x, data)
%
% INPUTS: 
% parameters: a vector of parameters of the form [m; s] 
% data:       the data set
% 
% OUTPUTS:
% LLF:      The log-likelihood function
%---------------------------------------------------
% Author:
% Alexandros Gabrielsen, a.gabrielsen@city.ac.uk
% Date: 06/2010
%---------------------------------------------------
[a,b]=size(parameters);
if b>a
   parameters=parameters';
end
n=length(data);
LLF  = -n*log(pi) +n*log(parameters(2)) - sum(log(parameters(2)^2 + (data-parameters(1)).^2));
end
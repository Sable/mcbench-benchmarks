% KEYWORDs: beta log pdf
% this program returns log of f(x)=beta(x; alpha, beta) pdf function and its derivative, 
% the pdf f(x) is defined up to the normalization constant
% USAGE: [log_function, log_function_prime]=log_beta_pdf(x, alpha, beta)
% INPUTs: "x" is vector of argument values
%         "function_parameters" is a vector of parameters of function f(x), function_parameters(1)=alpha
%                               and function_parameters(2)=beta are beta distribution parameters
% OUTPUTs: "log_function" is log[f(x)]
%          "log_function_prime" is (d/dx)log[f(x)]
% NOTES: pdf is log-concave
% Last modified on Jul 15, 2007

function [log_function, log_function_prime]=log_beta_pdf(x, function_parameters)

alpha=function_parameters(1);
beta=function_parameters(2);

log_function=(alpha-1)*log(x)+(beta-1)*log(1-x);
log_function_prime=(alpha-1)./x-(beta-1)./(1-x);



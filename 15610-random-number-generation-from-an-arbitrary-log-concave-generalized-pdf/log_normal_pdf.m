% KEYWORDs: normal log pdf
% this program returns log of f(x)=normal(x; mean_par, variance_par) pdf function and its derivative,
% the pdf f(x) is defined up to the normalization constant
% USAGE: [log_function, log_function_prime]=log_normal_pdf(x, alpha, beta)
% INPUTs: "x" is vector of argument values
%         "function_parameters" is a vector of parameters of function f(x), function_parameters(1)=mean
%                         and function_parameters(2)=variance are parameters of the normal distribution
% OUTPUTs: "log_function" is log[f(x)]
%          "log_function_prime" is (d/dx)log[f(x)]
% NOTES: pdf is log-concave
% Last modified on Jul 15, 2007

function [log_function, log_function_prime]=log_normal_pdf(x, function_parameters)

mean_par=function_parameters(1);
variance_par=function_parameters(2);

log_function=(-0.5/variance_par)*(x-mean_par).^2;
log_function_prime=(-1/variance_par)*(x-mean_par);



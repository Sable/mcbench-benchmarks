function LLF = gram_charlier_log(parameters,data)
%{
---------------------------------------------------
 PURPOSE: 
  Log Likelihood function of the Gram-Charlier Expansion. 
---------------------------------------------------
 USAGE: 
 LLF = gram_charlier_log(x, data)

 INPUTS: 
 parameters: a vector of parameters of the form [mean; variance; skewness; excess kurtosis] 
 data:       the data set
 
 OUTPUTS:
 LLF:      The log-likelihood function

 NOTES:
 For Skewness = 0 and Kurtosis = 3, the distribution becomes the Gaussian Distribution
---------------------------------------------------
 Author:
 Alexandros Gabrielsen, a.gabrielsen@city.ac.uk
 Date: 10/2010
---------------------------------------------------
%}
[a,b]=size(parameters);
if b>a
   parameters=parameters';
end
n=length(data);

mu = parameters(1);
s  = parameters(2);
sk = parameters(3);
ku = parameters(4);

 % Gram-Charlier Expansion Series
 % For some skewness and kurtosis parameters the GC pdf becomes negative, 
 % therefore another approach is to estimate the following specification proposed by:
 % Leon, Rubio and Serna (2004) Autoregressive Conditional Variance, Skewness and Kurtosis and
 % Brio, and Níguez, and Perote (2007) Multivariate Gram-Charlier Densities
 f = log((1 + (sk.*((data-mu)./sqrt(s)).^3 - 3*(data-mu)./sqrt(s))./6 + ((ku-3).*(((data-mu)./sqrt(s)).^4-6*((data-mu)./sqrt(s)).^2+3))./24)).^2;
 g = log(1+ (sk^2)/6 + ((ku-3)^2)/24);
 likelihoods = -0.5*((log(s)) + (((data-mu).^2)./s) + log(2*pi)) + f - g;     
 likelihoods = - likelihoods;
 LLF = sum(likelihoods);
end
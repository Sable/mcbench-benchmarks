function pdf = gram_charlier_pdf(x,m,s,sk,ku,plot);
%{
---------------------------------------------------
 PURPOSE: 
 Estimates and Plots the Probability Density Function of the 
 Gram Charlier Distribution for a series of x values, with m mean,
 s variance, sk skewness and ku kurtosis parameters 
---------------------------------------------------
 USAGE: 
 pdf = gram_charlier_pdf(x,m,s,plot)
 where: 
 x = (n x 1) or (1 x n) vector
 m = (a x 1) or (1 x a) vector 
 s = (c x 1) or (1 x c) vector
 sk = (1 x 1)
 ku = (1 x 1)

 If the location and scale parameter vectors are left empty
 pdf = gram_charlier_pdf(x,[],[]) 
 then they are assumed to be (1 x 101) and (1 x 50). 

 If plot is set to 1, it displays the 3d-dimension pdf of the distribution,
 the default option is disabled. 
---------------------------------------------------
 RETURNS: 
 pdf = (a x c) vector containing the pdf values for each element of x
---------------------------------------------------
 Author:
 Alexandros Gabrielsen, a.gabrielsen@city.ac.uk
 Date: 06/2010
---------------------------------------------------
%}
if nargin == 0 
    error('Data, Mean, Variance, Skewness and Kurtosis Parameters') 
end

if isempty(m) 
    m=[-50:1:50];
end
if isempty(s) 
    s=[1:1:51];
end

a=length(x);
b=length(m);
c=length(s);
d=length(sk);
e=length(ku);

for i = 1:a
  p(i) = ((1+sk*(x(i)^3-3*x(i))/6+(ku-3)*(x(i)^4-6*x(i)^2+3)/24)^2)/(1+sk^2/6+ku^2/24); % Leon Rubio and Serna
% p(i) = (1+sk*(x(i)^3-3*x(i))/6+ku*(x(i)^4-6*data(i)^2+3)/24); %
% Gram-Charlier A Expansion Series,
% However for some skewness and kurtosis parameters the pdf becomes
% negative thus another approach is to estimate the Leon, Rubio and Serna
% 2004 pdf
end
product = prod(p);

for j=1:b
    for k=1:c
pdf(j,k) = (1/(sqrt(2*pi)*s(k)))*exp(-(sum((x-m(j)).^2)/s(k)^2))*product;
    end
end

if nargin == 6
    pflag=1;
    [X,Y] = meshgrid(m,s);
    mesh(X,Y,pdf');figure(gcf);
end
end % Function End


    

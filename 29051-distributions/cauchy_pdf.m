function pdf = cauchy_pdf(x,m,s,plot)
%---------------------------------------------------
% PURPOSE: 
% Estimates and Plots the Probability Density Function of the 
% Cauchy-Lorentz Distribution for a series of x values, with m location 
% parameter and s scale parameter 
%---------------------------------------------------
% USAGE: 
% pdf = cauchy_pdf(x,m,s,plot)
% where: 
% x = (n x 1) or (1 x n) vector
% m = (a x 1) or (1 x a) vector 
% s = (c x 1) or (1 x c) vector
%
% If the location and scale parameter vectors are left empty
% pdf = cauchy_pdf(x,[],[]) 
% then they are assumed to be (1 x 101) and (1 x 50). 
%
% If plot is set to 1, it displays the 3d-dimension pdf of the distribution,
% the default option is disabled. 
%---------------------------------------------------
% RETURNS: 
% pdf = (a x c) vector containing the pdf values for each element of x
%---------------------------------------------------
% Author:
% Alexandros Gabrielsen, a.gabrielsen@city.ac.uk
% Date: 06/2010
%---------------------------------------------------

if nargin == 0 
    error('Data, Location Parameter, Scale Parameter') 
end

a=length(x);
if isempty(m) 
    m=[-50:1:50];
end
if isempty(s) 
   s=[1:1:50];
end

b=length(m);
c=length(s);

for i = 1:a
    for j = 1:b
        for k = 1:c
    p(i,j,k) = (1+((x(i)-m(j))/s(k))^2);
        end
    end
end
product = prod(p);
for ii = 1:b
    for kk = 1:c
pdf(ii,kk) = 1/(pi*s(kk)*product(1,ii,kk));
    end
end

if nargin == 4
    pflag=1;
    [X,Y] = meshgrid(m,s);
     mesh(X,Y,pdf');figure(gcf);
     xlabel('Location Parameter m');
     ylabel('Location Parameter s')
end
end % Function End


    

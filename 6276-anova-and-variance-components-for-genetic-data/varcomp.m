function [theta, sigma2a, sigma2, Nep, L] = varcomp(x, verbose)

if nargin==1
    verbose=0;
end

% VARCOMP(X) is a program that performs a one way ANOVA model II for 
% unequal sample size and returns the variance ratio value (theta), and
% the mean number of pollen donors Nep, for plant population genetic analyses.
% See attached test files from Sokal and Rohlf 1995.

% Juan F. Fernandez-M. Université Paris Sud

% create vector with treatment numbers only
ns = x(:,1);

% number of treatments
treatments = x(size(x,1),1);

% total number
N = size(x,1);

n = zeros(treatments,1);

% estimate treatment size
for i=1:treatments
   n(i) = size(find(ns==i),1);
end

% determine corrected sample size
pops_n = unique(n);
no = 0;
if size(pops_n,1)>1
	a = sum(n);
	b = sum(n.^2);
	c = [a - b/a];
   no = c/(treatments - 1);
else
   no = pops_n;
end
no;

df_among = treatments - 1;
df_total = N - 1;
df_error = df_total - df_among;

% estimate sums for treatments
for i=1:treatments
   data = find(ns==i);
   first = data(1);
   last = data(size(data,1));
   treatsum(i) = sum(x(first:last,2));
end
treatsum;
   
% estimate treatment means
for i=1:treatments
   treatmean(i) = treatsum(i)/n(i);
end
treatmean;

Totalmean = sum(treatsum)/N;

SSamong=0;
SSerror=0;
SStotal=0;

% estimate sum of square of treatments
for i=1:treatments
   SSamong = SSamong + n(i)*((treatmean(i) - Totalmean)^2);
end
SSamong;

% estimate sum of square total
for j=1:N
   SStotal = SStotal + (x(j,2) - Totalmean)^2;
end
SStotal;   

SSerror = SStotal - SSamong;

MSamong = SSamong/df_among;
MSerror = SSerror/df_error;
F       = MSamong/MSerror;



if verbose==1
    disp(' ');
    disp('One-Level ANOVA table:')
    disp('---------------------------------------------------------')
    disp('Source   df      SS             MS             F')
    disp('---------------------------------------------------------')
    disp(['Groups:  ', num2str([df_among SSamong MSamong F]) ])
    disp(['Error :  ' , num2str([df_error SSerror MSerror])])
    disp(['Total :  ', num2str([df_total SStotal])])
    disp('---------------------------------------------------------')
end

sigma2a = (MSamong - MSerror)/no;
sigma2 = (sigma2a + MSerror);
theta = sigma2a/sigma2;
 
if verbose==1
    disp('  ')
    disp('Variance Components:')
    disp('-----------------------------------')
    disp(['VC among groups  (Theta):  ', num2str(theta) ] )
    disp(['VC within groups (error):  ', num2str(1 - theta)  ])
    disp('-----------------------------------')
end

L = 0.5 + (no/2)*( F*( (df_error-2)/df_error )- 1)^-1;
Nep = 1/(2*theta);

if verbose==1
    disp('  ')
    disp('Number of Male Breeders:')
    disp('---------------------------------------------------------')
    disp(['Wilson L mean number of pollen donors per group:  ', num2str(L) ] )
    disp(['Nep (effective number of pollen donors)        :  ', num2str(Nep) ] )
    disp('---------------------------------------------------------')
end
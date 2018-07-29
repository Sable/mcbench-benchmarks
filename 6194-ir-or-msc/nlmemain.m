% This is the main file which executes a Maximum Likelihood Parameter Estimation 
% for a Non Linear Mixed Effects model as proposed by Pinheiro and Bates (1995, 2001).
% This same approximation algorithm is used by the nlme function in S-plus.


clear all
clc
warning off



N=input('How many parameters would you like to estimate?  ');
disp(' ')

B=zeros(N,1);

for n=1:1:N
%Input starting values by the user in the form [B1;B2;B3]
B(n,1)=input('Provide the starting value: ');


end
q=input('How many random effects does the degradation function contain?  ');
disp(' ')

D=input('Specify an estimation of the covariance matrix of the random effects:  ');

disp(' ')

disp('Estimating the parameters in a Nonlinear Mixed Effects Model')
disp('by means of Laplace approximation of the log-likelihood function')
disp('as described by Jose C. Pinheiro and Douglas M. Bates')

Options = optimset('TolX', 1E-5, 'TolFun', 1E-5,'MaxFunEvals', 1E10);
disp('Calculating................')

[Beta_hat,FVAL,EXITFLAG,OUTPUT] = FMINSEARCH('nlmelikelihoodfunction',B,Options,D,q);
disp(' ')
disp(' ')
% Check if the algorithm has converged
if EXITFLAG>=1
disp('The estimatimated values are as follows:  ')
disp(' ')
Beta1=Beta_hat(1)
Beta2=Beta_hat(2)
Beta3=Beta_hat(3)
disp(' ')
Number_of_function_evaluations=FVAL

else disp('Unfortunately the algorithm did not converge to a solution.')
end
disp(' ')
disp(' ')
disp('by Mark Damen')
disp('Technische Universiteit Eindhoven')
disp('Department of Technology Management')
disp('The Netherlands')




























































































% By Mark Damen


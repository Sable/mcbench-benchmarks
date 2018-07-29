% For FDSA, this code provides values of a, A, and c in the gains a_k=a/(k+1+A)^.602 and 
% c_k = c/(k+1)^.101. Code does not have built-in provision for gradient averaging (unlike
% SPSA) due to the relatively large no. of loss evals. required per gradient.  
%
% Specify the dimension, loss function, and i.c. 
%
global p sigma
p=10;
loss='loss4thnoise';
theta=ones(10,1);
alpha=0.602;
%
% User input on measurement noise level, expected no. of iterations in the SPSA run,
% desired magnitude of change in the theta elements, the number of SPSA gradient approximations
% that will be averaged, and the no. of loss evaluations to be used in the gain calculations
% here (note this no. should be divisible by twice the no. of averaged gradients).
%
step= input('What is the initial desired magnitude of change in the theta elements? ');
A = .10*input('What is the expected number of loss evaluations per run? ')...
   /(2*p);
sigma = input('What is the standard deviation of the measurement noise at i.c.? ');
c = max(sigma, .0001);
NL = input('How many loss function evaluations do you want to use in this gain calculation? ');
%
% Calculate the NL/(2*p) FD gradient estimates
%
rand('seed',31415927)
randn('seed',111113); %used in setting seed for noise in loss measurements
gbar=0;
e=eye(p);
atemp=zeros(p,1);
for i=1:NL/(2*p)
   ghat=0;
   for j=1:p
      thetaplus = theta + c*e(:,j);
      thetaminus = theta - c*e(:,j);
      yplus=feval(loss,thetaplus);
      yminus=feval(loss,thetaminus);
      ghat(j) = (yplus - yminus)/(2*c);
   end
   gbar=gbar+abs(ghat);
end
gbar=gbar/(NL/(2*p));
for i=1:p
   atemp(i)=step*((A+1)^alpha)/gbar(i);
end
atemp
a=min(atemp);
c
A
a

    

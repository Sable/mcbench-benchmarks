%J. C. Spall, March 1999
%Written in support of text, Introduction to Stochastic Search and Optimization, 2003
%Simulated annealing code.  Uses geometric decay of temperature.
%Provides two ways of dealing with noisy
%loss measurements: one is by using the tau coefficient to alter the 
%decision criterion and the other is by simple averaging of the loss
%measurements.
%
p=10;
theta_0=2*3.1338*ones(p,1);
sigma=0;			%standard dev. of meas. noise
STexamp6(theta_0)
n=2401;		   %total no. of loss measurements(iterations/lossavg) 
niter=100;		%no. of iters. per temp. setting 	
bk=1;		   	%"Boltzmann's constant"
lambda=.90;		%cooling rate (<=1)
scalpert=1;		%scale factor on pertubation to
		         %to current theta value
tau=0;			%adjustment for noise in key decision statement for accept/rej. update
randn('seed',1111113)
rand('seed',31415927)
cases=1;
lossavg=1;     %number of loss functions averaged if noisy loss meas. (choose s.t.
					%(n-lossavg) is divisible by niter*lossavg)
cumloss=0;
for i=1:cases
  T=50;			%initial temperature
  theta=theta_0;
  E_old=STexamp6(theta)+sum(sigma*randn(lossavg,1))/lossavg;
               %this statement simulates collecting an average of
               %of 'lossavg' independent loss measurements (counts against
               %"budget" of n loss measurements)
  for j=1:(n-lossavg)/(niter*lossavg)	%accounts for 'lossavg' measurements used above 
     for k=1:niter
       perturb=scalpert*T*randn(p,1);
       E_new=STexamp6(theta+perturb)+...
       sum(sigma*randn(lossavg,1))/lossavg;
               %average of 'lossavg' loss measurements (simulated as in E_old) 
       if E_new < E_old + tau
         theta=theta+perturb;
         E_old=E_new;
       else 
         prob=exp(-(E_new-E_old-tau)/(bk*T)); %criterion includes tau for noisy measurements
         test=rand;
       if test < prob
         theta=theta+perturb;
         E_old=E_new;
       else
       end
     end
   end
   T=lambda*T;
  end
  theta
  STexamp6(theta)
  cumloss=(i-1)*cumloss/i+STexamp6(theta)/i;
end
cumloss
         
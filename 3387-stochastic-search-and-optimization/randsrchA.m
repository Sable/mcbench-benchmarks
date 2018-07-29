% J. C. Spall,December 2000.
% This code implements the simple random search algorithm A in ISSO.  
% This code assumes noise-free loss measurements.
%
global p
n=10000;         % no. of loss measurements per run    
p=3;           % problem dimension
cases=1;      % no. of runs being averaged
t=2.02269;     % t-value for 2-sided test based on d.o.f.=cases-1 
loss='lossDopt';
theta_0=[0,0,0]';
feval(loss,theta_0)
D=[-1,1;-1,1;-1,1]; % specifies the lower and upper limits for p
               % components of theta (2-column matrix) 
randn('seed',31415927)
rand('seed',31415927)
meanlossA=0;
meanlosssqA=0;
for i=1:cases
   theta=theta_0;
   lossold=feval(loss,theta);
   for k=1:n
      thetanew=D(:,1)+(D(:,2)-D(:,1)).*rand(p,1);
      lossnew=feval(loss,thetanew);
       if lossnew < lossold  		
          theta=thetanew;
          lossold=lossnew;
       else
       end
   end
   meanlossA=(i-1)*meanlossA/i+lossold/i;
   meanlosssqA=(i-1)*meanlosssqA/i+lossold^2/i;
end
theta
meanlossA
if cases > 1
   sd_A=(cases^(-.5))*((cases/(cases-1))^.5)*(meanlosssqA-meanlossA^2)^.5
   % Confidence intervals
   [meanlossA-t*sd_A,meanlossA+t*sd_A]
else   
end

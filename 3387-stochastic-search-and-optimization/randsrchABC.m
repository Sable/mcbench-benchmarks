% J. C. Spall, February 2000 and December 2000.
% This code compares the three random algorithms (A, B, and C
% in ISSO).  This code assumes noise-free loss measurements.  The code includes 
% confidence interval calculations at end.
%
global p
n=500;         % no. of loss measurements per run    
p=2;           % problem dimension
cases=40;      % no. of runs being averaged
t=2.02269;     % t-value for 2-sided test based on d.o.f.=cases-1 
loss='loss_example2_3';
s_B=3;           % standard dev. of perturbations in Alg. B 
s_C=3;           % standard dev. of perturbations in Alg. C 
theta_0=[4,6.4]';
feval(loss,theta_0)
D=[-8,8;-8,8]; % specifies the 
			%lower and upper limits for p components of theta (2-column matrix) 
randn('seed',31415927)
rand('seed',31415927)
% Algorithm A
meanlossA=0;
meanlosssqA=0;
for i=1:cases
   theta=theta_0;
   lossold=feval(loss,theta);
   for k=1:n
      thetanew=D(:,1)+(D(:,2)-D(:,1)).*rand(p,1);
      lossnew=feval(loss,thetanew);
      if lossnew < lossold  		%update algs B and C to include this more
         							%efficient logic (avoids extra loss eval). 
          theta=thetanew;
          lossold=lossnew;
      else
      end
   end
   meanlossA=(i-1)*meanlossA/i+feval(loss,theta)/i;
   meanlosssqA=(i-1)*meanlosssqA/i+feval(loss,theta)^2/i;
end
% Algorithm B
meanlossB=0;
meanlosssqB=0;
for i=1:cases
   theta=theta_0;
   lossold=feval(loss,theta);
   for k=1:n
      thetanew=theta+s_B*randn(p,1);
      thetanew=min(thetanew,D(:,2));
      thetanew=max(thetanew,D(:,1));
      lossnew=feval(loss,thetanew);
      if lossnew < lossold  	
          theta=thetanew;
          lossold=lossnew;
      else
      end
  end
  meanlossB=(i-1)*meanlossB/i+feval(loss,theta)/i;
  meanlosssqB=(i-1)*meanlosssqB/i+feval(loss,theta)^2/i;
end
% Algorithm C
meanlossC=0; 
meanlosssqC=0;
for i=1:cases
   theta=theta_0;
   b=0;
   k=0;
   while k < n           % k is counter on no. of loss evals. 
      d=s_C*randn(p,1);
      temptheta1=theta+b+d;
      temptheta1=min(temptheta1,D(:,2));
      temptheta1=max(temptheta1,D(:,1));
      temptheta2=theta+b-d;
      temptheta2=min(temptheta2,D(:,2));
      temptheta2=max(temptheta2,D(:,1));
      if feval(loss,temptheta1) < feval(loss,theta)
         theta=temptheta1;
         b=.2*b+.4*d;
         k=k+1;,  % program now goes to end of this "if else"
      elseif feval(loss,temptheta2)< feval(loss,theta)
         theta=temptheta2;
         b=b-.4*d;
         k=k+2;   % program now goes to end of this "if else"
      else 
         b=.5*b;
         k=k+2; 
      end
  end
  meanlossC=(i-1)*meanlossC/i+feval(loss,theta)/i;
  meanlosssqC=(i-1)*meanlosssqC/i+feval(loss,theta)^2/i;
end
meanlossA
meanlossB
meanlossC
if cases > 1
   sd_A=(cases^(-.5))*((cases/(cases-1))^.5)*(meanlosssqA-meanlossA^2)^.5
   sd_B=(cases^(-.5))*((cases/(cases-1))^.5)*(meanlosssqB-meanlossB^2)^.5
   sd_C=(cases^(-.5))*((cases/(cases-1))^.5)*(meanlosssqC-meanlossC^2)^.5
   % Confidence intervals
   [meanlossA-t*sd_A,meanlossA+t*sd_A]
   [meanlossB-t*sd_B,meanlossB+t*sd_B]
   [meanlossC-t*sd_C,meanlossC+t*sd_C]
else   
end

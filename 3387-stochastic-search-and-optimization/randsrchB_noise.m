% J. C. Spall, February 2000.
% This code implements the random algorithm B in ISSO.  This code assumes  
% noisy loss measurements.
% Evaluates both the averaging and threshold idea.
%
global sigma p noise
n=1000;        % no. of loss measurements per run    
p=10;          % problem dimension
sigma=1;			% noise stand. deviation
cases=5;      % no. of runs being averaged
t=2.0096;     % t-value for 2-sided test based on d.o.f.=cases-1 
loss_noise='loss4thnoise';
loss='loss4thorder';
s_B=.5;           % standard dev. of perturbations in Alg. B 
avg=20;          % no. of loss measurements being averaged
threshold=1;     % the positive no. expressing the "acceptance threshold"
theta_0=ones(10,1);
feval(loss,theta_0)
theta_lo=-5*ones(p,1);   %lower bounds on theta  
theta_hi=5*ones(p,1);    %upper bounds on theta 
% Algorithm B under averaging 
meanlossB=0;
meanlosssqB=0;
meandist=0;
truetheta=zeros(10,1);
randn('seed',31415927)
for i=1:cases
   theta=theta_0;
   d(1,i,1)=feval(loss,theta);
   yold=0;
   for l=1:avg 
      yold=yold+feval(loss_noise,theta);
   end
   yoldavg=yold/avg;
   for k=1:n/avg -1
      thetanew=theta+s_B*randn(p,1);
      % Two lines below invoke constraints
      thetanew=min(thetanew,theta_hi);
      thetanew=max(thetanew,theta_lo);
      ynew=0;
      for l=1:avg 
         ynew=ynew+feval(loss_noise,thetanew);
      end
      ynewavg=ynew/avg;
    if ynewavg < yoldavg
       theta=thetanew;
       yoldavg=ynewavg;
    else
    end
    d(k+1,i,1)=feval(loss,theta); %records true loss value for ith case, kth iteration 
  end
  meanlossB=(i-1)*meanlossB/i+feval(loss,theta)/i;
  meanlosssqB=(i-1)*meanlosssqB/i+feval(loss,theta)^2/i;
  meandist=(i-1)*meandist/i+norm(theta-truetheta,2)/i;
  theta
end
disp('mean and confidence intervals under averaging') 
meanlossB
if cases > 1
   sd_B=(cases^(-.5))*((cases/(cases-1))^.5)*(meanlosssqB-meanlossB^2)^.5;sd_B
   % Confidence intervals
   [meanlossB-t*sd_B,meanlossB+t*sd_B]
else   
end
meandist
% Algorithm B with modified acceptance criterion("threshold")  
meanlossB=0;
meanlosssqB=0;
meandist=0;
randn('seed',11113);
for i=1:1
   theta=theta_0;
   yold=feval(loss_noise,theta);
   for k=1:n-1
      thetanew=theta+s_B*randn(p,1);
      thetanew=min(thetanew,theta_hi);
      thetanew=max(thetanew,theta_lo);
      ynew=feval(loss_noise,thetanew);
      if ynew < yold - threshold
        theta=thetanew;
        yold=ynew;
      else
      end
   end
   meanlossB=(i-1)*meanlossB/i+feval(loss,theta)/i;
   meanlosssqB=(i-1)*meanlosssqB/i+feval(loss,theta)^2/i;
  % meandist=(i-1)*meandist/i+norm(theta-[1,0.66667]',2)/i;
end
disp('mean and confidence intervals under altered threshold') 
meanlossB
if cases > 1
   sd_B=(cases^(-.5))*((cases/(cases-1))^.5)*(meanlosssqB-meanlossB^2)^.5;sd_B
   % Confidence intervals
   [meanlossB-t*sd_B,meanlossB+t*sd_B]
else   
end
meandist
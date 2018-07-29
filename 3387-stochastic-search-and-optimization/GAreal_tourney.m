% J. C. Spall, October 1999
% Written in support of text, Introduction to Stochastic Search and Optimization, 2003
% This program runs a GA with real-number coding.  Elitism is used 
% and the mutation operator is simply the addition of a Gaussian
% random vector to the non-elite elements.
% 
% The user is expected to set a variable 'expect_fn' representing the 
% expected number of function evaluations allowed.  The main "while"
% loop in the code tests for when the expected number of function
% evaluations exceeds 'expect_fn' and terminates the iteration on the 
% first generation that would require a no. of function evaluations
% exceeding this value.  The while loop expects that the mutation 
% operator is invoked (P_m represents mutation stand. deviation here; 
% P_m n.e. 0), so that all non-elite elements are
% guaranteed to change at every iteration (differs from the bit form
% where it is possible to repeat a loss function call within and across
% iterations).
%  
% This code handles noisy loss functions via the fact that the variables
% 'loss' and 'lossfinal' can call different functions.  The global 
% variable 'sigma' is used to generate the scaling for noise in the 
% loss measurements.
%
global p N thetamin thetamax
cases=20;         		%no. of Monte Carlo cases  
N=80;          			%population size
p=2;            			%dimension of theta
P_c=.8;         			%crossover rate
P_m=0.05;      			%mutation sigma
elite=2;                %no. of population elements for "elitism" 
                        %(should pick s.t. N-elite = even no.)
expect_fn=4000;         	%expected no. of function evaluations                        
thetamin=zeros(p,1);  		%lower bounds on theta elements
thetamax=10*ones(p,1);   	%upper bounds: ditto
thetamin_0=zeros(p,1);   	%lower bounds on theta for initialization 
thetamax_0=10*ones(p,1);   %upper bounds: ditto 
lossfinaleval ='loss_example9_5';  	%choice of loss function for final perf.
                              	%evaluation (no noise)
loss='loss_example9_5';    		%loss function for use in algorithm evaluations
lossfinalsq=0;          %variable for cum.(over 'cases')squared loss values
lossfinal=0;            %variable for cum. loss values
rand('seed',31415927);
randn('seed',3111113)
global z sigma;       	%declaration of random var. used for normal noise
                      	%generation in loss fn. calls given seed above;
                      	%also sigma in noise (noise is dependent on theta)
sigma=0;            		%multiplier in loss noise (lower bd. to s.d.)          
fitness=zeros(N,1);                %dim.-setting statement
theta=zeros(p,1);                  %dim.-setting statement
%
thetapop=zeros(N,p);  %dummy statement setting dimensions of matrix
							 %containing the theta values  
thetapop_noelite=zeros(N-elite,p);%dummy statement setting
                                  %dimension of matrix used to temp.
                                  %store offspring  
parent1=zeros(1,p); %dummy dimension statement
parent2=zeros(1,p); %ditto 
% User warning if P_m = 0 (to ensure that proper number of function evaluations
% are taken; code assumes all non-elite elements change every iteration)
if P_m==0
   disp('WARNING: P_m should be > 0');
else
end

% Begin outer loop of 'cases' Monte Carlo runs
%
navg=0;
for c=1:cases
   c
   %
   % Initial Random Population
   %
   % Statements below allow intialization of the search using a random
   % placement in natural theta space.  Points are placed uniformly dist.
   % on the hypercube defined by thetamax_0,thetamin_0.  
   %
   for i=1:N
      thetapop(i,:)=((thetamax_0-thetamin_0).*rand(p,1)+thetamin_0)';
   end
   % Evaluation of fitness for initial population
   for i=1:N
      fitness(i)=-feval(loss,thetapop(i,:)');%N by 1 vector of fitness values
   end
   [bestfitness,bestindex]=max(fitness);  bestindex
   %
   % Main loop of GA
   %
   index=zeros(elite,1);
   %cumfit=zeros(N-elite,1);
   n=1;               
   while n<=(expect_fn-N)/(N-elite)
      % Invoke elitism for 'elite' best chromosomes
      temp_fit=fitness;
      for j=1:elite
         [junk,index(j)]=max(temp_fit);
         temp_fit(index(j))=min(temp_fit);
      end
      for j=1:2:N-elite-1
         % Tournament selection below.  Uses tournament size = 2.  
            cand=ceil(N*rand(2,1));  %picks two candidate parents
                                     %from which one will be chosen   
         if fitness(cand(1))>fitness(cand(2))
            parent1_idx=cand(1);
         else
            parent1_idx=cand(2);
         end   
         cand=ceil(N*rand(2,1));  %ditto-for picking other parent   
         if fitness(cand(1))>fitness(cand(2))
            parent2_idx=cand(1);
         else
            parent2_idx=cand(2);
         end
         % Crossover with above two parents
         if rand < P_c
            cross_point=ceil(rand*(p-1)); %an integer 1,...,p-1
            parent1=thetapop(parent1_idx,:);
            %above picks off the chrom. for parent1_idx
            parent2=thetapop(parent2_idx,:);
            %above picks off the chrom. for parent2_idx
            child1=[parent1(1:cross_point),...  
               parent2(cross_point+1:p)];   %merges parents1&2
            child2=[parent2(1:cross_point),...
               parent1(cross_point+1:p)];   %merges parents1&2
            thetapop_noelite(j,:)=child1;%assigns child1 to new chrom. matrix
            thetapop_noelite(j+1,:)=child2;%ditto for child2 
         else
            parent1=thetapop(parent1_idx,:);
               %above picks off the chrom. for parent1_idx
            parent2=thetapop(parent2_idx,:);
               %above picks off the chrom. for parent2_idx
            thetapop_noelite(j,:)=parent1;%assigns parent1 to chrom. matrix
            thetapop_noelite(j+1,:)=parent2;%ditto for parent2 
         end
      end
      %
      % Mutation operator applied to thetapop_noelite vector (elite  
      % chromosomes not subject to mutation)by addition of Gauss.
      % random vector with diag. cov. matrix (standard devs. = P_m)
      %
      thetapop_noelite=thetapop_noelite+P_m*randn(N-elite,p);
      %
      % Invoke constraints to above population
      %
      for j=1:N-elite
         thetapop_noelite(j,:)=min(thetapop_noelite(j,:),thetamax');
         thetapop_noelite(j,:)=max(thetapop_noelite(j,:),thetamin');
      end
      %
      % Put elite chromosomes (theta values) back in population
      %
      for j=1:elite
        thetapop(j,:)=thetapop(index(j),:);
      end
      thetapop(elite+1:N,:)=thetapop_noelite;
      for i=1:N
         fitness(i)=-feval(loss,thetapop(i,:)');
      end
      n=n+1;
   end
   [bestfitness,bestindex]=max(fitness);
   lossvalue=feval(lossfinaleval,thetapop(bestindex,:)');
   lossfinalsq=lossfinalsq+lossvalue^2;
   lossfinal=lossfinal+lossvalue;
   navg=navg+n-1;				%counter for # of iters. taken
end
navg/cases
% standard dev. of loss values
if cases ~= 1 
	disp('standard deviation of mean loss value') 
   sd=((cases/(cases-1))^.5)*(lossfinalsq/cases-(lossfinal/cases)^2)^.5;
   sd=sd/(cases^.5)
else
end
% normalized loss values
disp('mean loss value over "cases" runs') 
mean=lossfinal/cases
        


         



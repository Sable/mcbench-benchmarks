% J. C. Spall, August 1999
% Written in support of text, Introduction to Stochastic Search and Optimization, 2003
% This program runs a GA.  The roulette wheel method for parent
% selection is used here.  Elitism is included.  Parent selection is 
% from the population including the elite chromosomes.  The standard 
% bit form is used here.  As usual, code works in terms of fitness
% values (higher better); results, however, are reported for the loss
% values of actual interest.  This code does not work with constraints 
% on theta values other than those directly associated with thetamax
% and thetamin. 

% This code calls the functions 'bit2num','num2bit',and'fitpop'.
% The user is expected to set a variable 'expect_fn' representing the 
% expected number of function evaluations allowed.  The main "while"
% loop in the code tests for when the expected number of function
% evaluations exceeds 'expect_fn' and terminates the iteration on the 
% first generation that would require a no. of function evaluations
% exceeding this value.  The test in the "while" loop uses a formula
% in ISSO, Exercise 9.6; the "identical" variable in the formula is replaced
% here by an actual running calculation of the identical total.  Note
% that the code actually makes more function evaluations than the 
% expected total due to the desire to avoid excessive bookkeeping and
% slowing of the code.  However, the IDEA of terminating when the 
% expecting running total exceeds a threshold is consistent with the 
% idea of placing a premium on possibly expensive function evaluations. 
%
% This code handles noisy loss functions via the fact that the variables
% 'loss' and 'lossfinal' can call different functions.  The global 
% variable 'sigma' is used to generate the scaling for noise in the 
% loss measurements.
%
clear all
global p N thetamin thetamax
cases=10;         % no. of Monte Carlo cases  
N=40;             % population size
p=10;             % dimension of theta
P_c =.7;          % crossover rate
P_m = 0.002;      % mutation rate
elite=2;                % no. of population elements for "elitism" 
                        % (should pick s.t. N-elite = even no.)
expect_fn=2000;         % expected no. of function evaluations                        
M=4*ones(p,1);          % relevant no. of places to right of decimal
thetamin=-1.6383*ones(p,1);  %lower bounds on theta elements
thetamax=1.6384*ones(p,1);   %upper bounds: ditto
thetamin_0=-1.6383*ones(p,1);   %lower bounds on theta for initialization 
thetamax_0=1.6384*ones(p,1);    %upper bounds: ditto 
lossfinaleval='loss4thorder';   % choice of loss function for final perf.
                                % evaluation
loss='loss4thnoise';
lossfinalsq=0;          %variable for cum.(over 'cases')squared loss values
lossfinal=0;            %variable for cum. loss values
rand('seed',31415927);
randn('seed',3111113)
global z sigma;       %declaration of random var. used for normal noise
                      %generation in loss fn. calls given seed above;
                      %also sigma in noise (noise is dependent on theta)
sigma=.10;            %multiplier in loss noise (lower bd. to s.d.)         
fitness=zeros(N,1);                %dim.-setting statement
theta=zeros(p,1);                  %dim.-setting statement
% User warning if invalid N-elite value
if (round((N-elite)/2)~=(N-elite)/2)
   disp('WARNING: N-elite should be even number');
else
end
%
% Determination of no. bits/theta element
bits=zeros(p,1);
for i=1:p
   b=1;
   while 10^M(i)*(thetamax(i)-thetamin(i))>2^b-1
      b=b+1;
   end
   bits(i)=b;
end
length=ones(1,p)*bits;              %no. of bits in each chromosome    
thetabit=zeros(N,length);  			%dummy statement setting dimensions of matrix
                           			%containing bit values of all chromosomes
thetabit_noelite=zeros(N-elite,length);%dummy statement setting
                                       %dimension of matrix used to temp.
                                       %store offspring  
parent1=zeros(1,length); %dummy dimension statement
parent2=zeros(1,length); %ditto 
%
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
   % on the hypercube defined by thetamin_0, thetamax_0.  The points are 
   % converted to a bit representation for use by the GA.
   %
   for i=1:N
      theta=(thetamax_0-thetamin_0).*rand(p,1)+thetamin_0;
      pointer=1;
      for j=1:p
         thetabit(i,pointer:pointer+bits(j)-1)=num2bit(theta(j),bits(j),...
            thetamin(j),thetamax(j));
         pointer=pointer+bits(j);
      end
   end 
   fitness=fitpop(thetabit,bits,loss);%N by 1 vector of fitness values
   [bestfitness,bestindex]=max(fitness);  bestindex
   % Loop below produces the theta associated with the best fitness value
   pointer=1;
   for j=1:p
      theta(j)=bit2num(thetabit(bestindex,pointer:pointer+bits(j)-1),...
            bits(j),thetamin(j),thetamax(j));
      pointer=pointer+bits(j);
   end
   %
   % Main loop of GA
   %
   index=zeros(elite,1);
   cumfit=zeros(N-elite,1);
   identical=0;   %initialization of variable that keeps track of no.
                  %of identical parents in selection pairs (due to 
                  %resampling)
   n=1;               
   while n< 1+(expect_fn-N+identical*(1-(1-P_m)^length))/(P_c*(N-elite)...
         +(1-P_c)*(N-elite)*(1-(1-P_m)^length))
      % Evaluate obj. function for each individual (an N-dim.vector)
      %fitness = fitpop(thetabit,bits,loss); %higher better
      % Invoke elitism for 'elite' best chromosomes
      temp_fit=fitness;
      for j=1:elite
         [junk,index(j)]=max(temp_fit);
         temp_fit(index(j))=min(temp_fit);
      end
      % Perform parent selection step
      fitness=fitness-min(fitness)+10^(-20); %keeps fitness>0
                                             %(small no. added to avoid 
                                             %zero-divide next step 
      fitness=fitness/sum(fitness); %normalizes sum to one 
      % select N-elite parents (an even no.)
      cumfit=cumsum(fitness); %vector of N cumulative sums
      for j=1:2:N-elite-1
         parent1_idx=min(find(cumfit-rand>0)); %identifies first index 
                                            %in fitness > rand
         parent2_idx=min(find(cumfit-rand>0)); %ditto for 2nd parent 
      % Crossover with above two parents
         if rand < P_c
            cross_point=ceil(rand*(length-1)); %an integer 1,...,length-1
            parent1=thetabit(parent1_idx,:);
            	%above picks off the chrom. for parent1_idx
            parent2=thetabit(parent2_idx,:);
            	%above picks off the chrom. for parent2_idx
            identical=identical+2*xor(1,norm(parent1-parent2)); %determines
            	%whether parents are identical for counting of required
            	%function evaluations
            child1=[parent1(1:cross_point),...  
               parent2(cross_point+1:length)];   %merges parents1&2
            child2=[parent2(1:cross_point),...
               parent1(cross_point+1:length)];   %merges parents1&2
            thetabit_noelite(j,:)=child1;			 %assigns child1 to new chrom. matrix
            thetabit_noelite(j+1,:)=child2;      %ditto for child2 
         else
            parent1=thetabit(parent1_idx,:);
               %above picks off the chrom. for parent1_idx
            parent2=thetabit(parent2_idx,:);
               %above picks off the chrom. for parent2_idx
            thetabit_noelite(j,:)=parent1;%assigns parent1 to chrom. matrix
            thetabit_noelite(j+1,:)=parent2;%ditto for parent2 
         end
      end
      %
      % Mutation operator applied to thetabit_noelite vector (elite  
      % chromosomes not subject to mutation)
      %
      mutate=rand(N-elite,length)<P_m;
      thetabit_noelite=xor(thetabit_noelite,mutate);%exclusive-or operator
                                               %invokes mutation     
      % Put elite chromosomes back in population
      %
      for j=1:elite
        thetabit(j,:)=thetabit(index(j),:);
     end
     % Put chromosomes resulting from selection back in general population 
     thetabit(elite+1:N,:)=thetabit_noelite;
     fitness=fitpop(thetabit,bits,loss);
     n=n+1;
   end
   [bestfitness,bestindex]=max(fitness);
   pointer=1;
   for j=1:p
      theta(j)=bit2num(thetabit(bestindex,pointer:pointer+bits(j)-1),...
         bits(j),thetamin(j),thetamax(j));
      pointer=pointer+bits(j);
   end
   lossvalue=feval(lossfinaleval,theta);lossvalue
   lossfinalsq=lossfinalsq+lossvalue^2;
   lossfinal=lossfinal+lossvalue;
   navg=navg+n-1;
end   
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
        


         



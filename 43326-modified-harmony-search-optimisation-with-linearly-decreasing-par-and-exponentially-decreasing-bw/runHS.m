% This code has been developped by Dr "Ahmad Rezaee Jordehi" and Ms Zoleikha  Ahmadi Jirdehi. For any question on this code, the researchers can
% contact: ahmadrezaeejordehi@gmail.com


%  This code applies harmony search optimisation with linearly decreasing   pitch adjustment rate and exponentially decreasing bandwidth to a   user-defined problem. 
% Generally, this Harmony search variant outperforms   the basic variant. Reference "An improved harmony search algorithm  for solving optimization
% problems" (Applied Mathematics and Computation in Elsevier). Download  link:  http://www.sciencedirect.com/science/article/pii/S0096300306015098
%  11 well-known benchmark test functions have been attached.
%%

clc; clear; close all;

tic;

%% Problem definition

costfunction=@ (x) test1(x);    % Input your objective function here.
n=2;                                                  % Input dimension of problem here.

lb=-5.*ones(1,n);                        % Input lower bound of decision variables here.
ub=10.*ones(1,n);                       % Input upper bound of decision variables here.
 


%%  Harmony search parameters

tmax=100;
HMS=150;
HMCR=0.9;
PAR=0.9;
PARi=0.9;
PARf=0.3;
bwmax=0.5;
bw=0.5;
bwmin=0.2;
c=(log(bwmin./bwmax))./tmax;





%%  Initialisation

HM=zeros(HMS,n);

for i=1:HMS
    
    for d=1:n
        
        HM(i,d)=unifrnd(lb(d),ub(d));
        
    end
end

for i=1:HMS
    
    cost(i,1)=costfunction(HM(i,:));
end

[worstcost worstindex]=max(cost);




%%   Main Loop

for t=1:tmax
    
        
    bw=bwmax.*exp(c.*t);  %  exponential decrease of bandwidth
      
    for i=1:HMS
        
        for d=1:n
            
            if rand<HMCR
                
                aa=round(unifrnd(1,HMS));
                
                NHM(i,d)=HM(aa,d);
                
            
            
            if rand<PAR
                
                if rand<0.5
                    
                    NHM(i,d)=NHM(i,d)+rand.*bw;
                else
                    NHM(i,d)=NHM(i,d)-rand.*bw;
                    
                end
                
            end
            
            
            else
                
                
                NHM(i,d)=unifrnd(lb(d),ub(d));
                
            end
            
            
        end
        
        
        
        
        
        % Bounding new harmony vector to feasible region.
               
        
        for  d=1:n
            
            NHM(d)=max(min(NHM(d),ub(d)),lb(d));
            
        end
        
        
        
        NHF=costfunction(NHM(i,:));
        
        if  NHF<worstcost
            
            HM(worstindex,:)=NHM(i);
            cost(worstindex,1)=NHF;
            
        end
        
            [worstcost worstindex]=max(cost);
        
    end
    
    
    
    
        [a b]=min(cost);
        
        xmin=HM(b,:);
        fmin=cost(b);
        
       cc(t)=fmin;
        
        
        PAR=PAR+(PARf-PARi)./tmax ;     % linealy decreasing pitch adjustment rate
    
    
end

plot(cc);   % plots convergence cutrve of HS


toc;  
        
        
                  
           

%% Results   Presentation

xmin   % optimal decision vector
fmin      % optimal objective value




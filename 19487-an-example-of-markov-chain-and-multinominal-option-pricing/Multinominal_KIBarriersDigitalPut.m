function [price, maxLoopInterval] = Multinominal_KIBarriersDigitalPut(S0,TopBarrier,BottomBarrier,drift,T,volatility,Branches,TimeSteps, directly, improved)

%   Copyright (Variance) 2008 by Ying Li, Mr_LiYing@Yahoo.com
% 
%   This code is provided 'as-is', without any express or implied warranty.  
%   In no event will the author be held liable for any damages arising 
%   from the use of this code.
% 
%   Permission is granted to anyone to use this code for any purpose, 
%   including commercial applications, and to alter it and redistribute it
%   freely, subject to the following restrictions:
% 
%   1. The origin of this code must not be misrepresented; you must not
%      claim that you wrote the original code. If you use this code
%      in a product, an acknowledgment in the product documentation would be
%      appreciated but is not required.
%   2. Altered code versions must be plainly marked as such, and must not be
%      misrepresented as being the original code.
%   3. This notice may not be removed or altered from any source distribution.
  
TopBoundaryReturn=log(TopBarrier)-log(S0);         % Return of the TopBoundary Level
BottomBoundaryReturn=log(BottomBarrier)-log(S0);   % Return of the BottomBoundary Level
StrikeReturn=log(TopBarrier)-log(S0);              % Return of the Strike Level

Variance = volatility*volatility;                          % variance of log return          
r=drift+Variance/2;                              % interest rate  

%************************************************************************%
%       To set the parameters of multininal tree                         %
%    At present, we only support the tree with 3, 5 and 7 branches       %
%************************************************************************%
Interval=1;
ProbOfBranches=[];

if Branches==3
    ProbOfBranches=[0.166667 0.666667 0.166667];
    Interval=1.732051;
elseif Branches==5
    ProbOfBranches=[0.013333 0.213334 0.546666 0.213334 0.013333];
    Interval=1.369304;
elseif Branches==7
    ProbOfBranches=[0.000802 0.026810 0.233813 0.477150 0.233813 0.026810 0.000802];
    Interval=1.198186;
else
    disp(' We only support 3,5,7);')
    exit;
end

RealInterval=Interval*volatility*sqrt(T/TimeSteps);

% Table 1. Risk-neutral probabilities [P] and jump parameters [W].
% [P] p1 p2 p3 p4 p5 p6 ProbOfBranches
% TimeSteps=2 0.500000 0.500000
% TimeSteps=3 0.166667 0.666667 0.166667
% TimeSteps=4 0.000000 0.166667 0.666667 0.166667
% TimeSteps=5 0.013333 0.213334 0.546666 0.213334 0.013333
% TimeSteps=6 0.003316 0.081193 0.415492 0.415492 0.081193 0.003316
% [W] w1 w2 w3 w4 w5 w6 w7
% TimeSteps=2 1.000000 1.000000
% TimeSteps=3 1.732051 0.000000 1.732051
% TimeSteps=4 3.464102 1.732051 0.000000 1.732051
% TimeSteps=5 2.738608 1.369304 0.000000 1.369304 2.738608
% TimeSteps=6 3.189031 1.913419 0.637806 0.637806 1.913419 3.189031
% TimeSteps=7 -3.594559 -2.396373 -1.198186 0.000000 1.198186 2.396373 3.594559
% The above table presents the risk-neutral probabilities [P] and jump parameters [W] for jump processes of
% the order two through seven. These results are based on a lognormally distributed asset price with normally
% distributed returns.

%************************************************************************%
%       To set the payoff in the correponding return for the maturity    %
%************************************************************************%

LogReturns=(TimeSteps*(Branches-1)/2-(0:(TimeSteps*(Branches-1))))*RealInterval+drift*T;

Payoff=zeros(1,1+TimeSteps*(Branches-1));

if directly>0
    for i=1:1+TimeSteps*(Branches-1)
        if (LogReturns(i)<=BottomBoundaryReturn)
          Payoff(i)=1;
        else
          Payoff(i)=0;
        end   
    end
else
    for i=1:1+TimeSteps*(Branches-1)
        if ((LogReturns(i)>BottomBoundaryReturn) && (LogReturns(i)<TopBoundaryReturn))
          Payoff(i)=1;
        else
          Payoff(i)=0;
        end   
    end
end

%************************************************************************%
%            Main Loop: Loop over all nodes backwards                    %
%************************************************************************%

maxLoopInterval=0;          % For checking the effect of improved method

for tau=TimeSteps-1:-1:0    % To calculate backwards
   PayoffNext=Payoff;
   Payoff=zeros(1,1+tau*(Branches-1));
   LoopInterval=1:(1+tau*(Branches-1));
   
    if improved>0     % To improve the efficiency by reducing the inner loop
        ii=0;
        PeakReturn=(tau*(Branches-1)/2-ii)*RealInterval+drift*(tau/TimeSteps)*T;
        
        TopBoundaryIndex=floor((PeakReturn-TopBoundaryReturn)/RealInterval);
   
        TopBoundaryIndex=max(TopBoundaryIndex-(Branches-1)/2,1);
        
        BottomBoundaryIndex=ceil((PeakReturn-BottomBoundaryReturn)/RealInterval);
    
        BottomBoundaryIndex=min(BottomBoundaryIndex+(Branches-1)/2, (1+tau*(Branches-1)));
        
        if ((ii<TopBoundaryIndex)|| (ii>BottomBoundaryIndex))
            LoopInterval=TopBoundaryIndex:BottomBoundaryIndex;
            maxLoopInterval=max(maxLoopInterval,BottomBoundaryIndex-TopBoundaryIndex); % For checking the effect of improved method
        end
    end
    
    
    for ii=LoopInterval; % The inner loop to calculate value for every node at the time tau
              
        currentReturn=(tau*(Branches-1)/2-ii)*RealInterval+drift*(tau/TimeSteps)*T; % The corresponding return of the node
        
        if ((currentReturn>=TopBoundaryReturn) || (currentReturn<=BottomBoundaryReturn))
            if directly>0
                Payoff(ii)=BSBinaryPutByLogPrice(currentReturn,TopBoundaryReturn,(1-tau/TimeSteps)*T,drift,Variance,r);            
            else
                Payoff(ii)=0;
            end
       else          
            Payoff(ii)=(ProbOfBranches*PayoffNext(ii:ii+Branches-1)')*exp(-r*(T/TimeSteps));
        end
    end
end

%************************************************************************%
%                   To get the final price                               %
%************************************************************************%

price=Payoff(1);  % We get the price of knock in in direct mode, or that of knock out option in indirect mode

if directly==0
    price=BSBinaryPutByLogPrice(0,TopBoundaryReturn,T,drift,Variance,r)-Payoff(1);
end



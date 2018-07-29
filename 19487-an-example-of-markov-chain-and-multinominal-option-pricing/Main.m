% The subject is pricing of barrier option in the Black Scholes model.
% The option is a discretely (daily) monitored European style knock-in barrier option. 
% The initial stock price is S0 = 100: Time to maturity is 40 trading days. 
% The barriers are 105, 95, the binary strike price is 105.
% Assume the logarithm of the stock price is a Gaussian process with constant drift and volatility, 
% b = 0.02; c = 0.4 under the risk-neutral measure.
% Assume time is measured in years and one year has 250 (trading) days. There are no dividends.

format long g;
S=100; 
drift=0.02;volatility=0.4;r=drift+0.5*volatility;% under the risk-neutral measure.

T = 40/250;
dt=1/40;%daily
TopBarrier=105; BottomBarrier=95;
StrikePrice=105; % In the code, we always assume StrikePrice=TopBarrier, if there is no other value assigned

%********************************%
%   Finite Difference Solution   %
%********************************%

for j=6:50;
    tic;
    Continuous_CN_Direct_BetweenNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/(20*(j^2)),1,0,0);
    Continuous_CN_Direct_BetweenNodes_time(j-5)=toc;

    tic;
    Continuous_CN_InDirect_BetweenNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/(20*(j^2)),0,0,0);
    Continuous_CN_InDirect_BetweenNodes_time(j-5)=toc;

    tic;
    Discrete_CN_Direct_BetweenNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/40,1,0,0);
    Discrete_CN_Direct_BetweenNodes_time(j-5)=toc;

    tic;
    Discrete_CN_InDirect_BetweenNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/40,0,0,0);
    Discrete_CN_InDirect_BetweenNodes_time(j-5)=toc;

    tic;
    Continuous_Improved_Direct_BetweenNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/(20*(j^2)),1,1,0);
    Continuous_Improved_Direct_BetweenNodes_time(j-5)=toc;

    tic;
    Continuous_Improved_InDirect_BetweenNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/(20*(j^2)),0,1,0);
    Continuous_Improved_InDirect_BetweenNodes_time(j-5)=toc;

    tic;
    Discrete_Improved_Direct_BetweenNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/40,1,1,0);
    Discrete_Improved_Direct_BetweenNodes_time(j-5)=toc;

    tic;
    Discrete_Improved_InDirect_BetweenNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/40,0,1,0);
    Discrete_Improved_InDirect_BetweenNodes_time(j-5)=toc;

    tic;
    Continuous_IFD_Direct_BetweenNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/(20*(j^2)),1,2,0);
    Continuous_IFD_Direct_BetweenNodes_time(j-5)=toc;

    tic;
    Continuous_IFD_InDirect_BetweenNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/(20*(j^2)),0,2,0);
    Continuous_IFD_InDirect_BetweenNodes_time(j-5)=toc;

    tic;
    Discrete_IFD_Direct_BetweenNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/40,1,2,0);
    Discrete_IFD_Direct_BetweenNodes_time(j-5)=toc;

    tic;
    Discrete_IFD_InDirect_BetweenNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/40,0,2,0);
    Discrete_IFD_InDirect_BetweenNodes_time(j-5)=toc;


    tic;
    Continuous_CN_Direct_OnNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/(20*(j^2)),1,0,1);
    Continuous_CN_Direct_OnNodes_time(j-5)=toc;

    tic;
    Continuous_CN_InDirect_OnNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/(20*(j^2)),0,0,1);
    Continuous_CN_InDirect_OnNodes_time(j-5)=toc;

    tic;
    Discrete_CN_Direct_OnNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/40,1,0,1);
    Discrete_CN_Direct_OnNodes_time(j-5)=toc;

    tic;
    Discrete_CN_InDirect_OnNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/40,0,0,1);
    Discrete_CN_InDirect_OnNodes_time(j-5)=toc;

    tic;
    Continuous_Improved_Direct_OnNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/(20*(j^2)),1,1,1);
    Continuous_Improved_Direct_OnNodes_time(j-5)=toc;

    tic;
    Continuous_Improved_InDirect_OnNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/(20*(j^2)),0,1,1);
    Continuous_Improved_InDirect_OnNodes_time(j-5)=toc;

    tic;
    Discrete_Improved_Direct_OnNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/40,1,1,1);
    Discrete_Improved_Direct_OnNodes_time(j-5)=toc;

    tic;
    Discrete_Improved_InDirect_OnNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/40,0,1,1);
    Discrete_Improved_InDirect_OnNodes_time(j-5)=toc;

    tic;
    Continuous_IFD_Direct_OnNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/(20*(j^2)),1,2,1);
    Continuous_IFD_Direct_OnNodes_time(j-5)=toc;

    tic;
    Continuous_IFD_InDirect_OnNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/(20*(j^2)),0,2,1);
    Continuous_IFD_InDirect_OnNodes_time(j-5)=toc;

    tic;
    Discrete_IFD_Direct_OnNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/40,1,2,1);
    Discrete_IFD_Direct_OnNodes_time(j-5)=toc;

    tic;
    Discrete_IFD_InDirect_OnNodes(j-5)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/40,0,2,1);
    Discrete_IFD_InDirect_OnNodes_time(j-5)=toc;

end

% continuousScope=0:1;
% directlyScope=0:1;
% FDMethodScope=0:2;
% OnNodesScope=0:1;
                 
%  for continuous=continuousScope
%      for directly=directlyScope
%          for FDMethod=FDMethodScope
%              for OnNodes=OnNodesScope
%                  tic;
%                  if continuous==0                 
%                      results(continuous+1,FDMethod+1,directly+1,OnNodes+1,j,1)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/40,directly,FDMethod,OnNodes);
%                  else
%                      results(continuous+1,FDMethod+1,directly+1,OnNodes+1,j,1)=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/(20*(j^2)),directly,FDMethod,OnNodes);
%                  end
%                     results(continuous+1,FDMethod+1,OnNodes+1,j,2)=toc;
%              end
%          end
%      end
%  end


%***************************%
%   Multinominal Solution   %
%***************************%

for i=1:10
      tic;
      T3_Direct_Price(i) = Multinominal_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,3,40*i,1,0);
      T3_Direct_Price_Time(i)=toc;

      tic;
      T5_Direct_Price(i) = Multinominal_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,5,40*i,1,0);
      T5_Direct_Price_Time(i)=toc;

      tic;
      T7_Direct_Price(i) = Multinominal_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,7,40*i,1,0);
      T7_Direct_Price_Time(i)=toc;
    
      T3_InDirect_Price(i) = Multinominal_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,3,40*i,0,0);
      T3_InDirect_Price_Time(i)=toc;

      tic;
      T5_InDirect_Price(i) = Multinominal_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,5,40*i,0,0);
      T5_InDirect_Price_Time(i)=toc;

      tic;
      T7_InDirect_Price(i) = Multinominal_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,7,40*i,0,0);
      T7_InDirect_Price_Time(i)=toc;
      
      
      tic;
      [T3_Direct_Improved_Price(i),T3_Interval(i)] = Multinominal_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,3,40*i,1,1);
      T3_Direct_Improved_Price_Time(i)=toc;

      tic;
      [T5_Direct_Improved_Price(i),T5_Interval(i)] = Multinominal_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,5,40*i,1,1);
      T5_Direct_Improved_Price_Time(i)=toc;

      tic;
      [T7_Direct_Improved_Price(i),T7_Interval(i)] = Multinominal_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,7,40*i,1,1);
      T7_Direct_Improved_Price_Time(i)=toc;
    
      T3_InDirect_Improved_Price(i) = Multinominal_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,3,40*i,0,1);
      T3_InDirect_Improved_Price_Time(i)=toc;

      tic;
      T5_InDirect_Improved_Price(i) = Multinominal_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,5,40*i,0,1);
      T5_InDirect_Improved_Price_Time(i)=toc;

      tic;
      T7_InDirect_Improved_Price(i) = Multinominal_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,7,40*i,0,1);
      T7_InDirect_Improved_Price_Time(i)=toc;
    
end

%***************************%
%   Markov Chain Solution   %
%***************************%

for SpatialSteps=6:50
    tic;
    MarkovChain(SpatialSteps-5)=MakovChain_KIBarriersDigitalPut(S,StrikePrice,TopBarrier,BottomBarrier,r,drift,T,volatility,SpatialSteps,dt);
    MarkovChain_Time(SpatialSteps-5)=toc;
end

%  This commented section is for test only. According to the test and comparing with other software, 
%     my code should be correct.

% for SpatialSteps=1:5
%     tic;
%     mk_test(SpatialSteps)=MakovChainBarriersKI_1(100,120,80,0.05, 0.03,0.25,0.1*SpatialSteps,100,1/400);
%     mk_test_time(SpatialSteps)=toc;
% end


%***************************%
%       Super Cycle         %
%***************************%
tic;
for SpatialSteps=100:100:500
    tic;
    SuperMarkovChain(round(SpatialSteps/100))=MakovChain_KIBarriersDigitalPut(S,StrikePrice,TopBarrier,BottomBarrier,r,drift,T,volatility,SpatialSteps,dt);
    SuperMarkovChain_Time(round(SpatialSteps/100))=toc;    
end

for SpatialSteps=100:100:500
    tic;
    SuperDiscrete_CN_Direct_OnNodes(round(SpatialSteps/100))=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/40,1,0,1);
    SuperDiscrete_CN_Direct_OnNodes_time(round(SpatialSteps/100))=toc;

    tic;
    SuperDiscrete_CN_InDirect_OnNodes(round(SpatialSteps/100))=FiniteDifference_KIBarriersDigitalPut(S,TopBarrier,BottomBarrier,drift,T,volatility,j,1/40,0,0,1);
    SuperDiscrete_CN_InDirect_OnNodes_time(round(SpatialSteps/100))=toc;
end

toc
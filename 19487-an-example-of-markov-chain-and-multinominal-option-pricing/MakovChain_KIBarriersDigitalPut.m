function price = MakovChain_KIBarriersDigitalPut(S0,StrikePrice,TopBarrier,BottomBarrier,r,drift,T,volatility,SpatialSteps,dt)
%   Copyright (Variance) 2008 by Ying Li, Mr_LiYing@Yahoo.com
%       MSc Mathematical Trading and Finance
%           Cass Business School, London

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

%***************************%
% Stock & Option Parameters %
%***************************%

StrikeReturn=log(StrikePrice);
TopBoundary=log(TopBarrier);
BottomBoundary=log(BottomBarrier);
Variance = volatility*volatility;                          % variance of log return          

%************************************************************************%
%                     State Space   - Spatial Steps                      %
%                                                                        %
%              Here, I only implemented equally divided grid.            %
%         You can opitimize this section according to your option.       %
%           Generally you should put all critical value on the nodes     %
%************************************************************************%

h=(TopBoundary-BottomBoundary)/(SpatialSteps-1);
LogReturns=TopBoundary+0.5*h-(0:SpatialSteps)*h;
LogReturns(1)=TopBoundary;
LogReturns(1+SpatialSteps)=BottomBoundary;

%************************************************************************%
%                   State Space   - Time Steps                           %
%                                                                        %
%              Here, I only implemented equally divided grid.            %
%         You can opitimize this section according to your option.       %
% Generally you should put all discrete monitoring points on the nodes   %
%************************************************************************%

n = ceil(T/dt);                          % Number of periods
dt=T/n;

%************************************************************************%
%                   Construct Transmition Matrix                         %
%                                                                        %
%       If you change the way of contructing State Space,                %
%               you should change this section also.                     %
%************************************************************************%
DownTransmition=zeros(SpatialSteps-1);
UpTransmition=zeros(SpatialSteps-1);

for i=2:SpatialSteps
    DownTransmition(i)=Prob_Of_Transmition(LogReturns, SpatialSteps,2, i,drift,Variance,dt);
    UpTransmition(i)=Prob_Of_Transmition(LogReturns, SpatialSteps,SpatialSteps,SpatialSteps-i+2,drift,Variance,dt);
end

TransmitionMatrix=zeros((1+SpatialSteps));

for startIndex=2:SpatialSteps
    for endIndex=2:SpatialSteps
        if (endIndex>=startIndex)
            TransmitionMatrix(startIndex,endIndex)=UpTransmition(endIndex-startIndex+1);
        else
            TransmitionMatrix(startIndex,endIndex)=DownTransmition(startIndex-endIndex+1);        
        end
    
         if TransmitionMatrix(startIndex,endIndex)<0
               disp(i,j); 
         end
    end
end

%************************************************************************%
%                   payoff at maturity                                   %
%                                                                        %
%                   which depends on the option type                     %
%                       Here, this is a binary put!                      %
%************************************************************************%

g=zeros(1,1+SpatialSteps)';

for i=1:1+SpatialSteps
  if (LogReturns(i)<=StrikeReturn)
      g(i)=1;
  else
      g(i)=0;
  end 
end

%************************************************************************%
%                           main loop                                    %
%                                                                        %
%                       Yes, this is the core part!                       %
%************************************************************************%

g=exp(-r*T)*TransmitionMatrix^n*g;

%************************************************************************%
%                           interpolation                                %
%                                                                        %
%                       For log(S0) is not always on nodes,              %
%                   according to equally divided construction            %
%************************************************************************%

LnS0=log(S0);
S0Index=ceil((TopBoundary-LnS0) / h+0.5);    
index=(S0Index-2):(S0Index+1);                  % indices of neighbouring points %     

pv = g(index);   % option price at neighbouring points %
price = spline(LogReturns(index),pv,log(S0));        % interpolated value using cubic splines %

price=BSBinaryPutByLogPrice(LnS0,StrikeReturn,T,drift,Variance,r)-price; % I use knock-in and knock-out parity to get the value of knock-in.

end


%************************************************************************%
%       The transmition probability from one state to another state      %
%           The function is based on normal distribution.                %
%************************************************************************%


function output=Prob_Of_Transmition(LogReturns, SpatialSteps,startIndex, endIndex,drift,Variance,dt)
    if ((endIndex==1) || (endIndex==SpatialSteps+1) || (startIndex==1) || (startIndex==SpatialSteps+1))
        output=0;    
    elseif (endIndex==2) 
            output=normcdf((LogReturns(1)-LogReturns(startIndex)-drift*dt)/(sqrt(Variance*dt)))- normcdf(((LogReturns(endIndex)+LogReturns(endIndex+1))/2-LogReturns(startIndex)-drift*dt)/(sqrt(Variance*dt)));
    elseif (endIndex==SpatialSteps) 
            output=normcdf(((LogReturns(endIndex)+LogReturns(endIndex-1))/2-LogReturns(startIndex)-drift*dt)/(sqrt(Variance*dt)))- normcdf((LogReturns(endIndex+1)-LogReturns(startIndex)-drift*dt)/(sqrt(Variance*dt)));
        else    
            output=normcdf(((LogReturns(endIndex)+LogReturns(endIndex-1))/2-LogReturns(startIndex)-drift*dt)/(sqrt(Variance*dt)))- normcdf(((LogReturns(endIndex)+LogReturns(endIndex+1))/2-LogReturns(startIndex)-drift*dt)/(sqrt(Variance*dt)));
    end
end
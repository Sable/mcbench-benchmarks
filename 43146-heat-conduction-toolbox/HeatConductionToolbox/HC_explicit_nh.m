function [Xco Tau MT] = HC_explicit_nh (Tin,TC,DE,HC,SE,DI,TS,TT,TBC,BC)
%
% DESCRIPTION:
%
% Explicit numerical method for one dimensional unsteady state    
% heat transfer by conduction for non-homogenous material
%
% Basic PDE equation :
%
%     dT         d^2 T 
%   ------ = TD ------             for 0 < x < DI  and  tau > 0 
%    dtau        dx^2
%
% Principle of method :
%       ^
%  time |
%       |      m-1     m     m+1
%       |       |      |      |
%       |    ---+------x------+-----   p+1
%       |  dtau |      |      |
%       |    ---o------o------o-----   p 
%       |  dtau |      |      |
%       |    ---+------+------+-----   p-1
%       |       |  dx  |  dx  |
%       |
%       +--------------------------------> 
%                                        x 
% Space description:
%                  DI
%   |<------------------------------>|
%   +   +   +   +   +  . . .     +   +   
%   1   2   3   4   5           n-1  n
%   |<->|
%     SE
%
% Difference equation :
%
%   T(m,p+1) - T(m,p)      TD
%  ------------------- = ------- (T(m-1,p) - 2.T(m,p) + T(m+1,p))
%          TS             SE.SE
%  
%       TD.TS
%  M = -------- <= 0,5
%       SE.SE 
%
%  T(m,p+1) = M.T(m-1,p) + (1 - 2.M)T(m,p) + M.T(m+1,p)
% 
%  T(m,p+1) = M(m-1).T(m-1,p) + (1 - (M(m-1)+M(m)))T(m,p) + M(m).T(m+1,p)
%  for m <2;n-1>
%
%  First-type boundary condition:
%    - temperatures T(1,p) and T(n,p) are given
%    - temperatures T(m,p) for m = 2, n-1 :
%      T(m,p+1) = M (T(m-1,p) + T(m+1,p)) + T(m,p).(1 - 2.M)
%
%  Second-type boundary condition:
%    - heat flux iQ(1,p) and iQ(n,p) are given
%    - temperature T(1,p) :
%                                   SE
%      T(1,p) = T(2,p-1) - iQ(1,p) ---- 
%                                   TC
%    - temperature T(n,p) :
%                                       SE
%      T(end,p) = T(n-1,p-1) - iQ(n,p) ---- 
%                                       TC 
%    - temperatures T(m,p) for m = 2, n-1 :
%      T(m,p+1) = M (T(m-1,p) + T(m+1,p)) + T(m,p).(1 - 2.M)
%
%
% INPUTS:
%
% Tin  - initialization temperatures                        [ K           ]  
% TC   - thermal conductivity                               [ W.m^-1.K^-1 ]
% DE   - density                                            [ kg.m^-3     ]
% HC   - specific heat capacity                             [ kg.m^-3     ]
% SE   - size of element                                    [ m           ]
% DI   - distance                                           [ m           ]
% TS   - time step                                          [ s           ]
% TT   - total time of simulation                           [ s           ]
% TBC  - type of boundary condition 
%        (1 = first-type, 2 = second-type)                  [ -           ]
% BC   - boundary condition       
%         - first-type : BC(1) = T(1),  BC(2) = T(n)        [ K           ]
%         - second-type: BC(1) = iQ(1), BC(2) = iQ(n)       [ W.m^-2      ]
% 
% OUTPUTS:
%
% Xco  - vector of X coordinate                             [ m           ]
% Tau  - vector of time                                     [ s           ]
% MT   - matrix of temperatures                             [ K           ]
%   
% AUXILIARY VARIABLE:
%
% r    - time  step  number                                 [ -           ]
% n    - space point number                                 [ -           ] 
% TD   - thermal diffusivity                                [ m^2.m^-1    ]
% M    - modul (Fourier number)                             [ -           ]
%
% Copyright (C) 2013, Technical University of Kosice
% Author  : Zecova Monika, Terpak Jan
% Revision: 27.08.2013
%
  r = round(TT/TS) + 1;    
  n = round(DI/SE) + 1;    
  
  Xco = 0.0:SE:DI;           
  Tau = 0.0:TS:TT;           
  MT  = zeros(r,n);
  MT(1,:) = Tin;
  
  for j=2:r
    [T]     = explicit_nh (Tin,TC,DE,HC,SE,TS,TBC,BC);
    Tin     = T;               
    MT(j,:) = Tin;             
  end
 
end
function [T] = explicit_nh (Tin,TC,DE,HC,SE,TS,TBC,BC)

  n  = length(Tin);
  TD = zeros(1,n-1);
  for i=1:n-1
    TD(i)= TC(i)/(DE(i)*HC(i));
  end
  M  = TD*TS/(SE*SE);
  
  T  = Tin;
  
  if (M <= 0.5)
     
     if TBC == 1
        T(1)   = BC(1);
        T(end) = BC(2);
     end
  
     if TBC == 2
        T(1)   = T(2)   - BC(1)*SE/TC(1);
        T(end) = T(end-1) - BC(2)*SE/TC(end);
     end 
  
     for m=2:length(Tin)-1
       T(m) = M(m-1)*Tin(m-1) + (1 - (M(m-1)+M(m)))*Tin(m) + M(m)*Tin(m+1);
     end    
  else
     disp(['error: unstable solution, M must be <= 0,5; M = ' num2str(M)]);
  end
end
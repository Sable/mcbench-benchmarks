function [Xco Tau MT] = HC_implicit_h (Tin,TC,DE,HC,SE,DI,TS,TT,TBC,BC)
%
% DESCRIPTION:
%
% Implicit numerical method for one dimensional unsteady state    
% heat transfer by conduction for homogenous material
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
%       |    ---o------x------o-----   p+1
%       |  dtau |      |      |
%       |    ---+------o------+-----   p 
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
%  ------------------- = ------- (T(m-1,p+1) - 2.T(m,p+1) + T(m+1,p+1))
%       dTau              dx.dx
%
%       TD.dtau
%  M = --------- 
%        dx.dx 
%
%  System of equations:
%  
%                  (1+2.M).T(2,p+1) - M.T(3,p+1)   = T(2,p)   + M.T(1,p+1)
%  . . .
% - M.T(i-1,p+1) + (1+2.M).T(i,p+1) - M.T(i+1,p+1) = T(i,p)
%  . . . 
% - M.T(n-2,p+1) + (1+2.M).T(n-1,p+1)              = T(n-1,p) + M.T(n,p+1)
%
%  Matrix notation:
%
%   A.T = b
%
%  The elements of A are given by
%
%   A(n-2,n-2) = 0 except for:
%                                     
%   A(1,1)     = 1 + 2.M;
%   A(1,2)     = - M;
%  
%   A(m,m-1)   = - M;  
%   A(m,m)     = 1 + 2.M;
%   A(m,m+1)   = - M;   for m <2,n-3>
%                          
%   A(n-2,n-3) = - M;
%   A(n-2,n-2) = 1 + 2.M;
%
%  and the elements of b are given by
%
%   b(1)   = Tin(2)   + M*T(1);  
%                            
%   b(m)   = Tin(m+1);    for m <2,n-3>
%                          
%   b(n-2) = Tin(n-1) + M*T(n);   
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
% r  - time  step  number                                   [ -           ]
% n  - space point number                                   [ -           ] 
% TD   - thermal diffusivity                                [ m^2.m^-1    ]
% M    - modul (Fourier number)                             [ -           ]
% A    - matrix (n-2,n-2)                                   [ -           ]
% b    - vector (n-2)                                       [ -           ]
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
    [T]     = implicit (Tin,TC,DE,HC,SE,TS,TBC,BC);
    Tin     = T;               
    MT(j,:) = Tin;             
  end

end
function [T] = implicit (Tin,TC,DE,HC,SE,TS,TBC,BC)
  TD   = TC/(DE*HC);
  M = TD*TS/(SE*SE);

  T = Tin;
  
  if TBC == 1
     T(1)   = BC(1);
     T(end) = BC(2);
  end
  
  if TBC == 2
     T(1)   = T(2)   - BC(1)*SE/TC;
     T(end) = T(end-1) - BC(2)*SE/TC;
  end 
     
  k = length(Tin)-2;
  A = zeros(k,k);
  b = zeros(k,1);

  A(1,1) = (1+2*M);
  A(1,2) = - M;
  b(1)   = Tin(2) + M*T(1);
  
  for i=2:k-1
      A(i,i-1) = - M;
      A(i,i)   = 1 + 2*M;
      A(i,i+1) = - M;
      b(i)     = Tin(i+1);
  end    
  
  A(k,k-1) = - M;
  A(k,k)   = 1 + 2*M;
  b(k)     = Tin(end-1) + M*T(end);

  x = A\b;
  for i=2:length(Tin)-1
      T(i) = x(i-1);
  end    
end
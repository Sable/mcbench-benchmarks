function [Xco Tau MT] = HC_CrankNicolson_nh (Tin,TC,DE,HC,SE,DI,TS,TT,TBC,BC)
%
% DESCRIPTION:
%
% Crank-Nicolson numerical method for one dimensional unsteady state    
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
%       |    ---o------x------o-----   p+1
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
%   T(m,p+1) - T(m,p)     TD
%  ------------------- = -------( T(m-1,p+1) - 2.T(m,p+1) + T(m+1,p+1) )
%       dTau             2.dx.dx
%
%                         TD
%                      + -------( T(m-1,p) - 2.T(m,p) + T(m+1,p) )
%                        2.dx.dx
%
% 2.(T(m,p+1)-T(m,p)) = 
%           M(m-1).T(m-1,p+1)-(M(m-1)+M(m)).T(m,p+1)+M(m).T(m+1,p+1) +
%         + M(m-1).T(m-1,p)  -(M(m-1)+M(m)).T(m,p)  +M(m).T(m+1,p)
%
% - M(m-1).T(m-1,p+1) + (2 + M(m-1) + M(m)).T(m,p+1) - M(m).T(m+1,p+1) =
% = M(m-1).T(m-1,p)   + (2 - M(m-1) - M(m)).T(m,p))  + M(m).T(m+1,p)
% 
%  System of equations:
%
%                  (2 + M(1) + M(2)).T(2,p+1) - M(2).T(3,p+1) =
% = M(1).T(1,p)  + (2 - M(1) - M(2)).T(2,p)   + M(2).T(3,p) + M(1).T(1,p+1)
%  . . . 
%  for m <3,n-3> 
% - M(m-1).T(m-1,p+1) + (2 + M(m-1) + M(m)).T(m,p+1) - M(m).T(m+1,p+1) =
% = M(m-1).T(m-1,p)   + (2 - M(m-1) - M(m)).T(m,p)   + M(m).T(m+1,p)
%  . . . 
% - M(n-2).T(n-2,p+1) + (2 + M(n-2) + M(n-1)).T(n-1,p+1) =
% = M(n-2).T(n-2,p)   + (2 - M(n-2) - M(n-1)).T(n-1,p)   + M(n-1).T(n,p) +
%                                                        + M(n-1).T(n,p+1) 
%
%  Matrix notation:
%
%   A.T = b
%
%  The elements of A are given by
%
%   A(n-2,n-2) = 0 except for:
%                                     
%   A(1,1)     = 2 + M(1) + M(2);
%   A(1,2)     = - M(2);
%  
%   A(m,m-1)   = - M(m-1);  
%   A(m,m)     = 2 + M(m-1) + M(m);
%   A(m,m+1)   = - M(m);   for m <2,n-3>
%                          
%   A(n-2,n-3) = - M(n-2);
%   A(n-2,n-2) = 2 + M(n-2) + M(n-1); 
%
%  and the elements of b are given by
%
% b(1)  = M(1).T(1,p)     + (2-M(1)-M(2)).T(2,p))       + M(2).T(3,p) 
%                                                       + M(1).T(1,p+1)                
%
% b(m)  = M(m-1).T(m-1,p) + (2-M(m-1)-M(m)).T(m,p))     + M(m).T(m+1,p);    
%                                                          for m <2,n-3>
%                          
% b(n-2)= M(n-2).T(n-2,p) + (2-M(n-2)-M(n-1)).T(n-1,p)) + M(n-1).T(n,p)
%                                                       + M(n-1).T(n,p+1)    
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
    [T]     = CrankNicolson_nh (Tin,TC,DE,HC,SE,TS,TBC,BC);
    Tin     = T;               
    MT(j,:) = Tin;             
  end
end
function [T] = CrankNicolson_nh (Tin,TC,DE,HC,SE,TS,TBC,BC)

  n = length(Tin);
  TD= zeros(1,n-1);
  for i=1:n-1
    TD(i)= TC(i)/(DE(i)*HC(i));
  end
  M = TD*TS/(SE*SE);
  T  = Tin;
  
  if TBC == 1
     T(1)   = BC(1);
     T(end) = BC(2);
  end
  
  if TBC == 2
     T(1)   = T(2)     - BC(1)*SE/TC(1);
     T(end) = T(end-1) - BC(2)*SE/TC(end);
  end 
     
  k = length(Tin)-2;
  A = zeros(k,k);
  b = zeros(k,1);

  for i=1:k
    b(i) = M(i)*Tin(i) + ( 2 - M(i) - M(i+1) )*Tin(i+1) + M(i+1)*Tin(i+2);
  end

  A(1,1) = 2 + M(1) + M(2);
  A(1,2) = - M(2);
  b(1)   = b(1) + M(1)*T(1);
  
  for i=2:k-1
      A(i,i-1) = - M(i);
      A(i,i)   = 2 + M(i) + M(i+1);
      A(i,i+1) = - M(i+1);    
  end
  
  A(k,k-1) = - M(k);
  A(k,k)   = 2 + M(k) + M(k+1);
  b(k)     = b(k) + M(k+1)*T(end);

  x = A\b;

  for i=2:length(Tin)-1
      T(i) = x(i-1);
  end     
end
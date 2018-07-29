function [Xco Tau MT] = HC_analytical_h (Tin_coef,TC,DE,HC,SE,DI,TS,TT,TBC,BC)
%
% DESCRIPTION:
%
% Analytical method for one dimensional heat transfer   
% for bounded interval
%
% Basic PDE equation :
%
%     dT         d^2 T 
%   ------ = TD ------             for 0 < x < DI  and  tau > 0 
%    dtau        dx^2
%
%  T(0,tau) = T1, T(DI,tau) = T2   for  tau > 0
%  and  
%  T(x,0) = f(x)                   for 0 <= x <= DI 
%
% Solution of analytical method:
%           
%             2   inf   DI           1                          k*pi*x        
% T(x,tau) = ---- SUM {INT [ f(x) - ---- (T2 - T1)*x - T1 ] sin ------ dx}*
%             DI  k=1   0            DI                           DI      
%
%                 k*pi*x                (k*pi)^2       1 
%          * sin --------- exp(-a*tau*(----------)) + ---- (T2 - T1)*x + T1 
%                   DI                     DI          DI
%
%  
%
% Final solution of analytical method for 
%           f(x) = Tcoef(1) + Tcoef(2)*x + Tcoef(3)*x^2 :
%           
%            NSI    2                                                    
% T(x,tau) = SUM  ------ { [T2 - Tcoef(1) - Tcoef(2)*DI + 
%            k=1   n*pi                                                 
%
%                      2
% + Tcoef(3)*DI^2*(---------- - 1) ]*(-1)^n - T1 + Tcoef(1) -   
%                   (k*pi)^2 
%
%                      2                k*pi*x                (k*pi)^2    
% - Tcoef(3)*DI^2*(----------) } * sin --------- exp(-a*tau*(----------)) +
%                   (k*pi)^2               DI                     DI 
%
%    1
% + ---- (T2 - T1)*x + T1 
%    DI
%  
%
% INPUTS:
%
% Tin_coef - vector of coefficients for f(x)                
%            Tin_coef = [ Tcoef(1)   Tcoef(2)   Tcoef(3) ]
%                         constant    line      parabola
%                       [ K          K/x        K/x^2    ]
% TC   - thermal conductivity                               [ W.m^-1.K^-1 ]
% DE   - density                                            [ kg.m^-3     ]
% HC   - specific heat capacity                             [ kg.m^-3     ]
% SE   - size of element                                    [ m           ]
% TS   - time step                                          [ s           ]
% DI   - distance                                           [ m           ]
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
% NSI  - number of sum items                                [ -           ]
% TD   - thermal diffusivity                                [ m^2.m^-1    ]
% 
% Copyright (C) 2013, Technical University of Kosice
% Author  : Zecova Monika, Terpak Jan
% Revision: 27.08.2013

  NSI = 100;          

  r   = round(TT/TS)+1;
  n   = round(DI/SE)+1;

  Xco = 0.0:SE:DI;           
  Tau = 0.0:TS:TT;           
  MT  = zeros(r,n);
  
  A = Tin_coef;
  for i=1:n
    XX     = (i-1)*SE;
    MT(1,i) = A(1) + A(2)*XX + A(3)*XX^2;
  end

  TD  = TC/(DE*HC);

  for j=2:r                 
    if TBC == 1
      T1  = BC(1);
      T2  = BC(2);
    end

    if TBC == 2
      T1  = MT(j-1,2)   - BC(1)*SE/TC;
      T2  = MT(j-1,n-1) - BC(2)*SE/TC;
    end 

    time = (j-1)*TS; 
    MT(j,1)= T1;
  
    for i=2:n-1
      sums = 0.0;
      XX   = (i-1)*SE;
      for k=1:NSI
        b = - (k*pi/DI)^2;  
        c = T2 - A(1) - A(2)*DI + A(3)*DI^2*(2/(k*pi)^2 - 1);
        d = - T1 + A(1) - A(3)*DI^2*(2/(k*pi)^2);
        sums = sums + (2/(k*pi))*( c*(-1)^k + d)*sin(k*pi*XX/DI)*exp(TD*b*time);
      end
      MT(j,i) = sums + (T2 - T1)*XX/DI + T1;
    end
    MT(j,n)= T2;
  end
end

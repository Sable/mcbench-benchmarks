function [Cl, Cd] = a2clcd(alfa)

% [Cl, Cd] = a2clcd(alfa) computes hydrodynamic coefficients Cl and Cd
% for the fins

% Costants
CLa = 2.865;               % CLalfa [rad^-1]
CDmin = 0.0115;            % CDmin
K = 0.1309;                % K
ALFA1 = 0.419;             % alfa_stall [rad]
ALFA2 = 0.7854;            % alfa45 [rad]

C1 = -1.0572;              % interpolating coefficients
C2 = 1.6434;               % between zone 1 and 3 
C3 = 1.6759;
C4 = -0.5021;

CT = 1.15;                 

% sign correction
mod_alfa=abs(alfa-sign(alfa)*(abs(alfa)>pi/2)*pi);

if mod_alfa < ALFA1
   % zone 1
   Cl = CLa * mod_alfa ;
   Cd = CDmin + K * Cl^2 ;
elseif  mod_alfa < ALFA2
   % zone2 
   Cl = C1 * mod_alfa + C2;
   Cd = C3 * mod_alfa + C4;
else
  % zone 3 , piastra
   Cl = CT*cos(mod_alfa);
   Cd = CT*sin(mod_alfa);
end;

% sign correction
Cl = Cl*sign(sin(2*alfa));

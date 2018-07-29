% Script for testing of heat transfer by conduction 
% with numerical and analytical methods for homogenous material.
%

clc;
clear all;
close all;

% space description:
%                  DI
%   |<------------------------------>|
%   +   +   +   +   +  . . .     +   +   
%   1   2   3   4   5           n-1  n
%   |<->|
%     SE
%

DI  = 0.03;                           % distance,                 m  
n   = 7;                              % point number,             -  
SE  = DI/(n-1);                       % step element,             m
TS  = 0.1;                            % time step,                s  
TT  = 10;                             % total time of simulation, s

% material properties - brass:
TC       =  120.0;                    % thermal conductivity,     W/m/K
DE       = 8400.0;                    % density,                  kg/m^3
HC       =  380.0;                    % specific heat capacity,   J/kg/K

% boundary conditions :
TBC = 1;                              % type of boundary condition, 1 or 2
  switch TBC
    case 1
      BC(1)    =  20.0;               % temperature in point 1
      BC(2)    = 100.0;               % temperature in point n
    case 2
      BC(1)    =  (100.0-20.0)*TC/DI; % heat flow density in point 1
      BC(2)    = -(100.0-20.0)*TC/DI; % heat flow density in point n
    otherwise  
      TBC      =     1;               % type of boundary condition
      BC(1)    =  20.0;               % temperature in point 1
      BC(2)    = 100.0;               % temperature in point n        
  end

% initial temperatures assignment :

switch TBC                             
  case 1
    Tin = 20.0*ones(1,n);             % initial temperatures,    °C 
    Tin_coef   = [20 0 0];            % initial temperatures coefficients
  case 2
    Tin = 60.0*ones(1,n);             % initial temperatures,    °C 
    Tin_coef   = [60 0 0];            % initial temperatures coefficients
  otherwise  
    Tin = 20.0*ones(1,n);             % initial temperatures,    °C 
    Tin_coef   = [20 0 0];            % initial temperatures coefficients
end      

% choose the method:
% 1 - explicit, 2 - implicit, 3 - Crank-Nicolson, 4 - analytical
method = 4;    

switch method
  case 1 % explicit method
   [Xco Tau MT] = HC_explicit_h      (Tin,TC,DE,HC,SE,DI,TS,TT,TBC,BC);
  case 2 % implicit method
   [Xco Tau MT] = HC_implicit_h      (Tin,TC,DE,HC,SE,DI,TS,TT,TBC,BC);
  case 3 % Crank-Nicolson method
   [Xco Tau MT] = HC_CrankNicolson_h (Tin,TC,DE,HC,SE,DI,TS,TT,TBC,BC);
  case 4 % analytical method
   [Xco Tau MT] = HC_analytical_h    (Tin_coef,TC,DE,HC,SE,DI,TS,TT,TBC,BC);
end
  
% Graphs:

figure(1);
% Graph: Temperature - Time
i = 4; % number of point ( from 1 to n)
plot(Tau,MT(:,i));
xlim([0 TT]);
xlabel('Time, s');
ylabel('Temperature, ^oC');
switch method
  case 1
    legend('explicit method');
  case 2
    legend('implicit method');
  case 3
    legend('Crank-Nicolson method');
  case 4
    legend('analytical method');
end
grid on;

figure(2);
% Graph: Temperature - Space
pTime = 0.05;
for j=1:length(MT)
  plot(Xco,MT(j,:));
  hold on;
  pause(pTime);
end
xlabel('Distance, m');
ylabel('Temperature, ^oC');
switch method
  case 1
    legend('explicit method');
  case 2
    legend('implicit method');
  case 3
    legend('Crank-Nicolson method');
  case 4
    legend('analytical method');
end
grid on;

% 3D Graph: Temperature - Time - Space
figure(3);
mesh(Tau,Xco,MT');
xlabel('Time, s');
ylabel('Distance, m');
zlabel('Temperature, ^oC');
%% To plot Basin of Attraction for a given set of equations using Newton
% Raphson Method 
% Governing Equations are:
% x^3-y = 0 ; y^3 - x = 0 
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Warning : On running this the workspace memory will be deleted. Save if
% any data present before running the code !!
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%--------------------------------------------------------------------------
% Code written by : Siva Srinivas Kolukula, PhD                           |
%                   Structural Mechanics Laboratory                       |
%                   Indira Gandhi Center for Atomic Research              |
%                   India                                                 |
% E-mail : allwayzitzme@gmail.com                                         |
% web-link: https://sites.google.com/site/kolukulasivasrinivas/           |
%--------------------------------------------------------------------------
% Version 1 : 19 September 2013

clc ; clear all
warning('off') % To off the warning which shows "Matrix is close to singular 
               % badly scaled" when algorithm passes through a point where the Jacobian
               % matrix is singular

% The roots of the given governing equations
r1 = [-1 ;-1] ;
r2 = [0 ;0] ;
r3 = [1 ;1] ;
% Initial conditions 
x = linspace(-2,2,200) ;
y = linspace(-2,2,200) ;
% Initialize the required matrices
Xr1 = [] ; Xr2 = [] ; Xr3 = [] ; Xr4 = [] ;
tic 
for i = 1:length(x)
     for j = 1:length(y)
          X0 = [x(i);y(j)] ;
          % Solve the system of Equations using Newton's Method
          X = NewtonRaphson(X0) ;
          % Locating the initial conditions according to error
          if norm(X-r1)<1e-8 
             Xr1 = [X0 Xr1]  ;
          elseif norm(X-r2)<1e-8
             Xr2 = [X0 Xr2] ;
          elseif norm(X-r3)<1e-8
             Xr3 = [X0 Xr3] ;
          else               % if not close to any of the roots
             Xr4 = [X0 Xr4] ;
          end
          
     end 
end
toc
warning('on') % Remove the warning off constraint

% Initialize figure
figure
set(gcf,'color','w') 
hold on
plot(Xr1(1,:),Xr1(2,:),'.','color','r') ;
plot(Xr2(1,:),Xr2(2,:),'.','color','b') ;
plot(Xr3(1,:),Xr3(2,:),'.','color','g') ;
plot(Xr4(1,:),Xr4(2,:),'.','color','k') ;
title('Basin of attraction for f(x,y) = x^3-y = 0 and y^3-x=0')
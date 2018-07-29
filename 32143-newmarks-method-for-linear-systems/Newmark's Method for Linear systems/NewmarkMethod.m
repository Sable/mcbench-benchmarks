function [depl,vel,accl,U,t] = NewmarkMethod(M,K,C,P,phi,sdof,acceleration)
% NEWMARK'S METHOD : LINEAR SYSTEM
% Reference : Dynamics of Structures - Anil K. Chopra
%-------------------------------------------------------------------------
% Code written by :Siva Srinivas Kolukula                                 |
%                  Senior Research Fellow                                 |
%                  Structural Mechanics Laboratory                        |
%                  Indira Gandhi Center for Atomic Research               |
%                  INDIA                                                  |
% E-mail : allwayzitzme@gmail.com                                         |
%-------------------------------------------------------------------------
% Purpose : Dynamic Response of a system using linear Newmark's Method
% Synopsis :
%       [depl,vel,accl,U,t] = NewmarkMethod(M,K,C,P,phi,sdof,acceleratio)
% 
% Variable Description :
% INPUT :
%       M - Mass Matrix (in modal coordinates)
%       K - Stiffness Matrix (in modal coordinates)
%       C - Damping Matrix (in modal coordinates)
%       P - Force Matrix (in modal coordinates)
%       sdof - system degree's of freedom
%       acceleration - Type of Newmark's Method to be used 
%       
% OUTPUT :
%        depl - modal displacement's 
%        vel - modal velocities
%        accl - modal accelerations 
%        U - system's displacement
%        t - time values at which integration is done
%--------------------------------------------------------------------------


switch acceleration
    case 'Average' 
        gaama = 1/2 ;beta = 1/4 ;
    case 'Linear'
        gaama = 1/2 ;beta = 1/6 ;
end
% Time step
ti = 0. ;
tf = 4. ;
dt = 0.1 ;
t = ti:dt:tf ;
nt = fix((tf-ti)/dt) ;
n = length(M) ;

% Constants used in Newmark's integration
a1 = gaama/(beta*dt) ; a2 = 1/(beta*dt^2) ;
a3 = 1/(beta*dt) ;       a4 = gaama/beta ;
a5 = 1/(2*beta) ;        a6 = (gaama/(2*beta)-1)*dt ;


depl = zeros(n,nt) ;
vel = zeros(n,nt) ;
accl = zeros(n,nt) ;
U = zeros(sdof,nt) ;
% Initial Conditions
depl(:,1) = zeros ;
vel(:,1) = zeros ;
U(:,1) = phi*depl(:,1) ;
P0 = zeros(n,1) ;
accl(:,1) = M\(P-C*vel(:,1)-K*depl(:,1)) ;

Kcap = K+a1*C+a2*M ;

a = a3*M+a4*C ;
b = a5*M+a6*C ;

% Tme step starts
for i = 1:nt
    delP = P0+a*vel(:,i)+b*accl(:,i) ;
    delu = Kcap\delP ;
    delv = a1*delu-a4*vel(:,i)-a6*accl(:,i) ;
    dela = a2*delu-a3*vel(:,i)-a5*accl(:,i);
    depl(:,i+1) = depl(:,i)+delu ;
    vel(:,i+1) = vel(:,i)+delv ;
    accl(:,i+1) = accl(:,i)+dela ;
    U(:,i+1) = phi*depl(:,i+1) ;
   
end

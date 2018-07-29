% A code is written for Linear Newmark Method and a problem is solved to 
% check the validity of the code
%
% Reference : Dynamics of Structures - Anil K. Chopra
% Page no : 570 (Third Edition, 2001)
%
% Example Problem 15.1 : A reinforced-concrete chimney idealized as the
% lumped mass cantilever is subjected at the top to a step force p(t) 1000
% kips; m = 208.6 kip-sec^2/ft and EI = 5.469X10^10 kip-ft^2. Solve the
% equations of motion after transforming them to the first two modes by the
% linear acceleration method with dt = 0.1 sec.

clear ;clc ;

EI = 5.469*10^10 ;
h = 120 ;

K = (EI/h^3)*[18.83   -11.90    4.773   -1.193   0.1989 ;
             -11.90    14.65   -10.71    4.177  -0.6961 ;
              4.773   -10.71    14.06   -9.514   2.586  ;
             -1.19     4.177   -9.514    9.878  -3.646 ; 
              0.1989  -0.6961   2.586   -3.646   1.609] ;

 C = zeros(size(K)) ;
 sdof = length(K) ;         
 m = 208.6 ;
 M = m*diag([1 1 1 1 0.5]) ;
 
 P = 1000*[0 0 0 0 1]' ;
 
 % Transforming the System Matrices to modal coordinates
 lambda = 2 ;  % Number of modes to be considered
 [M,K,C,P,phi]= ModalAnalysis(M,K,C,P,lambda);
 
 % Newmark Method foe time integration
%acceleration = 'Average' ;
acceleration = 'Linear' ;
[depl,vel,accl,U,t] = NewmarkMethod(M,K,C,P,phi,sdof,acceleration) ;

figure(1)
plot(t,depl(1,:)) ;
xlabel('Time in sec') ;ylabel('q1') ;
figure(2)
plot(t,depl(2,:)) ;
xlabel('Time in sec') ; ylabel('q2') ;
figure(3)
plot(t,U(5,:)) ;
xlabel('Time in sec') ;ylabel('u5') ;
 
 
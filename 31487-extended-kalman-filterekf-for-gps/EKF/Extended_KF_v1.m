%Extended_KF   Extended Kalman Filter
%
% Version 1.0, May 16,2011
% Written by You Chong, Peking University
%
% Syntax:
%     [Xo,Po] = Extended_KF(f,g,Q,R,Z,X,P,Xstate)
%
% State Equation:
%     X(n+1) = f(X(n)) + w(n)
% Observation Equation:
%     Z(n) = g(X(n)) + v(n)
%     w ~ N(0,Q) is gaussian noise with covariance Q
%     v ~ N(0,R) is gaussian noise with covariance R     
% Input:
%     f: function for state transition, type of symbolic expression 
%     g: function for measurement, type of symbolic expression
%     Q: process noise covariance
%     R: measurement noise covariance
%     
%     Z: current measurement
%     
%     X: "a priori" state estimate
%     P: "a priori" estimated state covariance
%
%     Xstate: symbols of state vector
% Output:
%     Xo: "a posteriori" state estimate
%     Po: "a posteriori" estimated state covariance

% Algorithm for Extended Kalman Filter:
% Linearize input functions f and g to get fy(state transition matrix)
% and H(observation matrix) for an ordinary Kalman Filter
% 1. Xp = f(X)                      : One step projection, also provides 
%                                     linearization point
% 
% 2. 
%          d f    |
% fy = -----------|                 : Linearize state equation, fy is the
%       d Xstate  |X=Xp               Jacobian of the process model
%       
% 
% 3.
%          d g    |
% H  = -----------|                 : Linearize observation equation, H is
%       d Xstate  |X=Xp               the Jacobian of the measurement model
%             
%       
% 4. Pp = fy * P * fy' + Q          : Covariance of Xp
% 
% 5. K = Pp * H' * inv(H * Pp * H' + R): Kalman Gain
% 
% 6. Xo = Xp + K * (Z - g(Xp))      : Output state
% 
% 7. Po = [I - K * H] * Pp          : Covariance of Xo

% Example:
% Kalman filter for GPS positioning
% The following is a brief illustration of the principles of GPS. For more
% information see reference [2].
% The Global Positioning System(GPS) is a satellite-based navigation system
% that provides a user with proper equipment access to positioning
% information. The most commonly used approaches for GPS positioning are
% the Iterative Least Square(ILS) and the Kalman filtering(KF) methods. 
% Both of them is based on the pseudorange equation:
%                rho = || Xs - X || + b + v
% in which Xs and X represent the position of the satellite and
% receiver, respectively, and || Xs - X || represents the distance between 
% them. b represents the clock bias of receiver, and it need to be solved 
% along with the position of receiver. rho is a measurement given by 
% receiver for each satellites, and v is the pseudorange measurement noise 
% modeled as white noise.
% There are 4 unknowns: the coordinate of receiver position and the clock
% bias. The ILS is largely used to calculate these unknowns and is
% implemented in this example as a comparison. In the KF solution we use
% the Extended Kalman filter(EKF) to deal with the nonlinearity of the
% pseudorange equation, and a CV model(constant velocity) as the process
% model.

%{
clear all
load SV_Pos                         %position of satellites
load SV_Rho                         %pseudorange of satellites
syms x Vx y Vy z Vz                 %position and velocity of the receiver in 3 dimensions,
syms b d                            %clock bias(b),clock drift(d)
Xstate = [x Vx y Vy z Vz b d].';    %state vector

T = 1; %positioning interval
N = 25;%total steps
% Set f
f = [x+T*Vx;
     Vx;
     y+T*Vy;
     Vy;
     z+T*Vz;
     Vz;
     b+T*d
     d];
% Set Q
Sf = 36;Sg = 0.01;sigma=5;         %state transition variance
Qb = [Sf*T+Sg*T*T*T/3 Sg*T*T/2;
	  Sg*T*T/2 Sg*T];
Qxyz = sigma^2 * [T^3/3 T^2/2;
                  T^2/2 T];
Q=blkdiag(Qxyz,Qxyz,Qxyz,Qb);

% Set initial value of X and P     
X = zeros(8,1);
X([1 3 5]) = [-2.168816181271560e+006 
                    4.386648549091666e+006 
                        4.077161596428751e+006];                 %Initial position
X([2 4 6]) = [0 0 0];                                            %Initial velocity
X(7,1) = 3.575261153706439e+006;                                 %Initial clock bias
X(8,1) = 4.549246345845814e+001;                                 %Initial clock drift
P = eye(8)*10;

fprintf('GPS positioning using EKF started\n') 
tic

for ii = 1:N
    % Set g
    syms xs ys zs                                                % symbols for position of satellites                                          
    g_func = sqrt((x-xs)^2+(y-ys)^2+(z-zs)^2) + b;               % pseudorange equation
    g = [];
    for jj=1:4                                                   % pseudorange equations for each satellites
        g = [g ; 
            subs(g_func,[xs ys zs],SV_Pos{ii}(jj,:))]; 
    end

    % Set R
    Rhoerror = 36;                                               % variance of measurement error(pseudorange error)
    R=eye(4) * Rhoerror; 

    % Set Z
    Z = SV_Rho{ii}.';                                            % measurement value

    [X,P] = Extended_KF(f,g,Q,R,Z,X,P,Xstate);
    Pos_KF(:,ii) = X([1 3 5]).';                                 % positioning using Kalman Filter
    Pos_LS(:,ii) = Rcv_Pos_Compute(SV_Pos{ii},SV_Rho{ii});       % positioning using Least Square as a contrast
    
    fprintf('KF time point %d in %d  ',ii,N)
    time = toc;
    remaintime = time * N / ii - time;
    fprintf('Time elapsed: %f seconds, Time remaining: %f seconds\n',time,remaintime)
end

for ii = 1:3
    subplot(3,1,ii)
    plot(1:N,Pos_KF(ii,:)-mean(Pos_KF(ii,:)),'-r')
    hold on
    plot(1:N,Pos_LS(ii,:)-mean(Pos_KF(ii,:)))
    legend('EKF','ILS')
    xlabel('Sampling index')
    ylabel('Position error(meters)')
end
%}	 

% References:
% 1. R G Brown, P Y C Hwang, "Introduction to random signals and applied 
%   Kalman filtering : with MATLAB exercises and solutions",1996
% 2. Pratap Misra, Per Enge, "Global Positioning System Signals, 
%   Measurements, and Performance(Second Edition)",2006
	                                                                            
function [Xo,Po] = Extended_KF(f,g,Q,R,Z,X,P,Xstate)
N_state = length(Xstate);
N_obs = length(Z);
    
Xp = subs(f,Xstate,X);%1

fy = subs(jacobian(f,Xstate),Xstate,Xp);%2

H = subs(jacobian(g,Xstate),Xstate,Xp);%3

Pp = fy * P * fy.' + Q;%4

K = Pp * H' * inv(H * Pp * H.' + R);%5
    
Xo = Xp + K * (Z - subs(g,Xstate,Xp));%6

I = eye(N_state,N_state);
Po = [I - K * H] * Pp;%7
    
 
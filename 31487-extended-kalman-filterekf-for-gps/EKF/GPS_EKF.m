% Example:
% Kalman filter for GPS positioning
% This file provide an example of using the Extended_KF function with the 
% the application of GPS navigation. The pseudorange and satellite position
% of a GPS receiver at fixed location for a period of 25 seconds is
% provided. Least squares and Extended KF are used for this task.
%
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
% There are 4 unknowns: the coordinate of receiver position X and the clock
% bias b. The ILS can be used to calculate these unknowns and is
% implemented in this example as a comparison. In the KF solution we use
% the Extended Kalman filter (EKF) to deal with the nonlinearity of the
% pseudorange equation, and a CV model (constant velocity)[1] as the process
% model.

% References:
% 1. R G Brown, P Y C Hwang, "Introduction to random signals and applied 
%   Kalman filtering : with MATLAB exercises and solutions",1996
% 2. Pratap Misra, Per Enge, "Global Positioning System Signals, 
%   Measurements, and Performance(Second Edition)",2006

clear all
close all
clc

load SV_Pos                         % position of satellites
load SV_Rho                         % pseudorange of satellites  

T = 1; % positioning interval
N = 25;% total number of steps
% State vector is as [x Vx y Vy z Vz b d].', i.e. the coordinate (x,y,z),
% the clock bias b, and their derivatives.

% Set f, see [1]
f = @(X) ConstantVelocity(X, T);

% Set Q, see [1]
Sf = 36;Sg = 0.01;sigma=5;         %state transition variance
Qb = [Sf*T+Sg*T*T*T/3 Sg*T*T/2;
	  Sg*T*T/2 Sg*T];
Qxyz = sigma^2 * [T^3/3 T^2/2;
                  T^2/2 T];
Q = blkdiag(Qxyz,Qxyz,Qxyz,Qb);

% Set initial values of X and P     
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
    g = @(X) PseudorangeEquation(X, SV_Pos{ii});                 % pseudorange equations for each satellites                

    % Set R
    Rhoerror = 36;                                               % variance of measurement error(pseudorange error)
    R = eye(size(SV_Pos{ii}, 1)) * Rhoerror; 

    % Set Z
    Z = SV_Rho{ii}.';                                            % measurement value

    [X,P] = Extended_KF(f,g,Q,R,Z,X,P);
    Pos_KF(:,ii) = X([1 3 5]).';                                 % positioning using Kalman Filter
    Pos_LS(:,ii) = Rcv_Pos_Compute(SV_Pos{ii}, SV_Rho{ii});      % positioning using Least Square as a contrast
    
    fprintf('KF time point %d in %d  ',ii,N)
    time = toc;
    remaintime = time * N / ii - time;
    fprintf('Time elapsed: %f seconds, Time remaining: %f seconds\n',time,remaintime)
end

% Plot the results. Relative error is used (i.e. just subtract the mean)
% since we don't have ground truth.
for ii = 1:3
    subplot(3,1,ii)
    plot(1:N, Pos_KF(ii,:) - mean(Pos_KF(ii,:)),'-r')
    hold on;grid on;
    plot(1:N, Pos_LS(ii,:) - mean(Pos_KF(ii,:)))
    legend('EKF','ILS')
    xlabel('Sampling index')
    ylabel('Error(meters)')
end
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 1,'\bf Relative positioning error in x,y and z directions','HorizontalAlignment','center','VerticalAlignment', 'top');
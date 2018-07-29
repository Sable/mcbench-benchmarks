function [Y,KK,P]= Kalman1D( X, Q )
% Illustration of one dimensional Kalman filter
% [X,K,P]=Kalman1D (U) returns :
%               -Estimated vector X.
%               -Kalman Gain (same length as X ).
%               -Error variance .
% Ref :
% Welch, Greg and Gary Bishop, "An Introduction to the Kalman Filter," 
%
% july , 2012
% KHMOU Youssef

%Input's length
N=length(X);
X(isinf(X))=[];
X(isnan(X))=[];
% Filter parameters 
A    = 1.00;  % Transition matrix
%B   = 0.00;  % Command matrix
P    = zeros(1,N); %variance matrix
P(1) = 1.01; % initialization
R    = 0.05; % variance noise measurements
%Q    = 0.0052; % variance noise process
Y    = zeros(1,N); % Estimated vector
Y(1) = 0.00 ; % initialization
KK   = zeros(1,N); % Kalman gain vector
% begin
for i=2:N   
   % time update
   X_temp =Y(i-1);
   P_temp =(A*P(i-1)*A')+Q;
   K      = P_temp./(P_temp + R);
   % measurment update
   Y(i)   = X_temp + (K*(X(i)-X_temp));
   P(i)   = (1-K) * P_temp;
   % storing Gain's value
   KK(i)  = K ;
end



    

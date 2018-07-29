% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	Problem 3- closed-loop discrete time Transfer Function 

K=2;
Ts=-1

G=tf(0.1, [1 -0.5], Ts);

H = tf(0.5, [1 -0.1], Ts);

F = feedback(K*G, H)




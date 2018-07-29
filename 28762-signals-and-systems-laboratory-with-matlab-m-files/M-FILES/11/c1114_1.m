% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	State Space model construction



%from Transfer Function


num=[1 1.5 2];
den= [1 2.5 1.5];
sys=tf2ss(num,den);

% second way 
[A,B,C,D]=tf2ss(num,den)


impulse(A,B,C,D);
legend('h(t) from state model')
figure
impulse(num,den)
legend('h(t) from transfer function')



% Transfer Function from state space model 
[num,den]=ss2tf(A,B,C,D,1);
H=tf(num,den)

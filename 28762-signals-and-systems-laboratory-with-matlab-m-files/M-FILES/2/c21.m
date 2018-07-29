% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
% categories where a signal can be classified


%continious time signal
t=0:0.01:10
y=cos(t);
plot(t,y)


%discrete time signal
n=0:10
y=cos(n);
figure
plot(n,y,':o')
figure
stem(n,y)


%digital signal
n=0:10
y=cos(n);
y=round(y);
figure
plot(n,y,':o')
figure
stem(n,y)

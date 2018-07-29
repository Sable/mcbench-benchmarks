% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 

% Stability   

%S1 stable - S2 not stable 
t=0:.1:10;
x=cos(2*pi*t);
plot(t,x);
ylim([-2 2]);

figure
y1=x.^2;
plot(t,y1);
ylim([-0.5 1.5]);

figure
y2=t.*x;
plot(t,y2); 


syms t
x=cos(2*pi*t);
limit(x,t,inf)

y1=x^2;
limit(y1,t,inf)

y2=t*x;
limit(y2,t,inf)

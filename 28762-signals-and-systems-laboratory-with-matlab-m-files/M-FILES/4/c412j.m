% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
% problem 10 - systems with mixed interconnection 


%impulse response
h1=[2,3,4];
h2=[-1,3,1];
h12=h1+h2
h3=[1 1 -1];
h=conv(h12,h3)

%system response to x[n]
figure
x=[1 1 0 0 0];
y=conv(x,h);
stem(0:8,y);
legend('y[n]');
xlim([-1 9]);

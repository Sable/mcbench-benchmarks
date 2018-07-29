% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	Problem 4- Step responses 


z1=[];
p1=[-1 -.2+10j  -.2-10j];
k1=10; 

H=zpk(z1,p1,k1);

t=0:.1:20
y1=step(H,t)  



z2=-3
p2=[-1 -.2+10j  -.2-10j];
k2=10; 

[num,den]=zp2tf(z2,p2,k2);

y2=step(num,den,t)

plot(t,y1,t,y2, ':')
legend('Step1', 'Step2')

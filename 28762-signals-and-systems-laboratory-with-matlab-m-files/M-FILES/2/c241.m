% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
%
% periodic signals

t=1:5;
x=sin(t);
T=2*pi;
for k=1:10
xk(k,:)=sin(t+k*T);
end
xk

%Sum of periodic continuous time signals  
 t=0:.1:6*pi;
 x=cos(t)+sin(3*t);
 plot(t,x)

 
 %	Construction of periodic signals 
 figure
 [s,t]=gensig('square',3,20,0.01);
 plot(t,s)
 ylim([-.3 1.3])
 
 figure
 [s,t]=gensig('pulse',2,10);
 plot(t,s)
 ylim([-.3 1.3])

 figure
 t=0:0.1:10;
 s=square(t);
 plot(t,s);
 ylim([-1.3 1.3])
 
 figure
 s2=square(2*pi*t);
 plot(t,s2);
 ylim([-1.3 1.3]) ; 
 
 figure
 t=0:0.1:20;
 s=sawtooth(t);
 plot(t,s);
 ylim([-1.3 1.3])

 
 figure
 t=0:.1:10;
 x=t.*exp(-t);
 xp=repmat(x,1,8);
 tp=linspace(0,80,length(xp));
 plot(tp,xp)
 
 figure
 N=10;
 x=[1 1 -1 -1];
 xp=repmat(x,1,N);
 n=0:length(xp)-1;
 stem(n,xp);



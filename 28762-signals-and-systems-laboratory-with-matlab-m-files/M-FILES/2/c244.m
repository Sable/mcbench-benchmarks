% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
%

% energy type or power type


%power -type
 syms t T
 x=heaviside(t);
 d=int(abs(x)^2,t,-T,T);
 Ex=limit(d,T,inf)
 Px=limit((1/(2*T))*d,T,inf)

 %energy -type
 syms t T
 x=heaviside(t)-heaviside(t-1);
 d=int(abs(x)^2,t,-T,T);
 Px=limit((1/(2*T))*d,T,inf)
 Ex=limit(d,T,inf)

 
 %energy  and power computation in one period
 t1=0;
 t2=2;
 syms t
 x=2*cos(pi*t);
 Ex=int(abs(x)^2,t,t1,t2)
 Px=(1/(t2-t1))*int(abs(x)^2,t,t1,t2)


% discrete time signal
 N=5;
 n=-N:N;
 x=cos(n);
 E=sum( (abs(x)).^2)
 P=1/(2*N+1)*E

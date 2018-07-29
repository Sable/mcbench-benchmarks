% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
% problem 11 - graph of r[n] and of r[n+1]


% r[n]
 n=-3:6;
 u=(n>=0);
 r=n.*u;
 
 stem(n,r)
 title('Unit ramp sequence r[n]')
 ylim([-.1 6.1])

 

% r[n+1]
 figure
 n=-3:6;
 u1=(n>=-1);
 r=(n+1).*u1;
 
 stem(n,r)
 title('Unit ramp sequence r[n+1]')
 ylim([-.1 7.1])

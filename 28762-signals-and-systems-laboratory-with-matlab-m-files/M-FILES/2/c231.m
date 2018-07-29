% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
%
%  Unit impulse sequence




%delta(t)   
 n=-3:3
 d=gauspuls(n)
 stem(n,d)

%  second way
 figure
 n1=-3:-1;
 n2=0;
 n3=1:3;
 n=[n1 n2 n3]
 d1=zeros(size(n1));
 d2=1;
 d3=zeros(size(n3));
 d=[d1 d2 d3]
 stem(n,d)

%  third way
 figure
 n1=-3;
 n2=3;
 n=n1:n2
 d=(n==0)
 stem(n,d)

 
 
%delta(t-t0) 
figure
 d=gauspuls(n-2);
 stem(n,d)

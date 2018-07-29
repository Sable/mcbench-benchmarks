% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
%

% even or odd  
 t1=0:4
 t2=0:-1:-4
 
 %even
 x1=t1.^2
 x2=t2.^2
 
%  odd
 y1=t1.^3
 y2=t2.^3

 
 %analysis in even and odd parts
 n=-5:5;
 u=(n>=0); 
 stem(n,u);

 figure
 u_n=(n<=0)
 ue=1/2*(u+ u_n);
 stem(n,ue);

 figure
 uo=1/2*(u- u_n);
 stem(n,uo);

 figure
 stem(n,ue+uo)
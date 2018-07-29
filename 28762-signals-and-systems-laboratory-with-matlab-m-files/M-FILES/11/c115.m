% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	Interconnections of systems



%cascade connection 

disp('cascade connection ');
num1=1;
den1=[500 0 0];
num2=[1 1];
den2=[1 2];
[num,den]=series(num1,den1,num2,den2)

printsys(num,den)

%second way 
H1=tf(num1,den1);
H2=tf(num2,den2);
H=series(H1,H2)


%third way 
num=conv(num1,num2)
den=conv(den1,den2);
printsys(num,den)
H=H1*H2




%parallel connection 

disp('parallel connection ');
num1=1;
den1=[500 0 0];
num2=[1 1];
den2=[1 2];
H1=tf(num1,den1);
H2=tf(num2,den2);
H=parallel(H1,H2)


%second way
syms s t
H1=1/(500*s^2);
h1=ilaplace(H1,t); 
H2=(s+1)/(s+2);
h2=ilaplace(H2,t);
h=h1+h2;
H=laplace(h,s);
H=simplify(H);
pretty(H) 


%third way 
H1=1/(500*s^2);
H2=(s+1)/(s+2);
H=H1+H2;
H=simplify(H);
pretty(H)


%fourth way 
H1=tf(num1,den1);
H2=tf(num2,den2);
H=H1+H2





% feedback connection 

disp('feedback connection ');
num1=1;
den1=[500 0 0];
num2=[1 1];
den2=[1 2];
H1=tf(num1,den1);
H2=tf(num2,den2);
H=feedback(H1,H2)


%second way
syms s
H1=1/(500*s^2);
H2=(s+1)/(s+2);
H=H1/(1+H1*H2); 
simplify(H)





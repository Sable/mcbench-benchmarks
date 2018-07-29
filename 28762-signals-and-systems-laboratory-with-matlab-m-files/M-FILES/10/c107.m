% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% Use of the z-Transform to solve difference equations 



%The difference equation is 
%y[n]+0.5y[n-1]+2y[n-2]=0.9^nu[n] , y[n]=0,n<0


syms n z Y

X=ztrans(0.9^n,z)

Y1=z^(-1)*Y;
Y2=z^(-2)*Y;

G=Y+0.5*Y1+2*Y2-X;
SOL=solve(G,Y);
pretty(SOL);

y=iztrans(SOL,n); 

n1=0:10;
y_n=subs(y,n,n1);
stem(n1,y_n)
legend('y[n]')
xlim([-.5 10.5])

%confirmation
yn1=subs(y,n,n-1);
yn2=subs(y,n,n-2);

test=y+0.5*yn1+2*yn2-0.9^n; 
test=simplify(test)


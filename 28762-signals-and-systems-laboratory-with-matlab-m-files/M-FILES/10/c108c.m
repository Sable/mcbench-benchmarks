% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% Problem 5
%                                    0.9^n, 0<=n<=3
%  z-Transform computation of f[n]=  2^-n , 4<=n<=6
%                                     1,    7<=n<=10



n1=0:3;
f1=0.9.^n1;
n2=4:6;
f2=2.^(-n2);
n3=7:10;
f3=ones(size(n3));
n=[n1 n2 n3];
f=[f1 f2 f3];
stem(n,f);
axis([-.5 10.5 -.1 1.1]);

figure
syms n z
n1=4;
n2=7;
n3=11;
f1=0.9^n;
f2=2^(-n);
f3=1;
f=f1*(heaviside(n)-heaviside(n-n1)) +f2*(heaviside(n-n1)-heaviside(n-n2)) +f3*(heaviside(n-n2)-heaviside(n-n3));
n_s=0:10;
f_s=subs(f,n_s);
stem(n_s,f_s);
axis([-.5 10.5 -.1 1.1]);


% a)z-Transform of f[n]
F1=ztrans(f,z)

% b)z-Transform of f[n]
n1=0:3;
f1=0.9.^n1;
n2=4:6;
f2=2.^(-n2);
n3=7:10;
f3=ones(size(n3));
n=[n1 n2 n3];
f=[f1 f2 f3];
F2=sum(f.*(z.^-n))

% c) confirmation
figure
syms n
ftest=iztrans(F1,n)
n=0:10;
ftest1=subs(ftest,n);
stem(n,ftest1);
axis([-.5 10.5 -.1 1.1]);







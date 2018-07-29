%-----------------------------------------
% UNIVERSITY OF TENAGA NASIONAL
% PROGRAMMER: MOHD ANUAR ABD AZIZ
% STUDENT ID: ME071642
% SUBJECT   : COMPUTATIONAL FLUID DYNAMICS
% ASSIGNMENT 1
% MATLAB 6.5
%16 Feb 2005
% ------------------------------------------
clc
clear all
N=200;
L=2;
dx=L/N;
n2=25;             
tb=400+273.15;
ta=34+273.15;
omega=1.78;
eps=1e-6; %minimum error being set

global N omega eps L dx n2 tb ta 
warning off
%-----------------------------------------
% GET NUMBER OF ITERATION FOR EVERY METHOD
% ------------------------------------------
[iter,T]=JACOBBI;
fprintf('Jacobbi method\t\t: %d iteration \n',iter);
[iter,T]=GS;
fprintf('Gauss-Seidel method\t: %d iteration \n',iter);
[iter,T]=SOR;
fprintf('SOR method\t\t\t: %d iteration \n',iter);
%----------------------------------------------------
% GENERATE ACTUAL/THEORETICAL TEMPERATURE DISTRIBUTION
% ----------------------------------------------------
x=mesh;
for i=1:N+2
    A=cosh(sqrt(n2)*(L-x(i)))/cosh(sqrt(n2)*L);
    T(i)=(tb-ta)*A+ta;
end
Ta=T(101);
plot(x,T,'b')
hold
%-----------------------------------------
% GET RESULT AND ERROR FOR EVERY NUMBER OF
% MESH AND PLOT THE GRAPH
% ------------------------------------------
N=25;
x=mesh;
[iter,T]=SOR;
plot(x,T,'g')
[y,i]=min(abs(ones(size(x))-x));
err(1)=abs(T(i)-ta)*100/ta;
errm(1)=N;

N=50;
x=mesh;
[iter,T]=SOR;
plot(x,T,'r')
[y,i]=min(abs(ones(size(x))-x));
err(2)=abs(T(i)-ta)*100/ta;
errm(2)=N;

N=75;
x=mesh;
[iter,T]=SOR;
plot(x,T,'c')
[y,i]=min(abs(ones(size(x))-x));
err(3)=abs(T(i)-ta)*100/ta;
errm(3)=N;

N=100;
x=mesh;
[iter,T]=SOR;
plot(x,T,'m')
[y,i]=min(abs(ones(size(x))-x));
err(4)=abs(T(i)-ta)*100/ta;
errm(4)=N;

N=200;
x=mesh;
[iter,T]=SOR;
plot(x,T,'y')
[y,i]=min(abs(ones(size(x))-x));
err(5)=abs(T(i)-ta)*100/ta;
errm(5)=N;

legend('Actual', '25 mesh','50 mesh','75 mesh','100 mesh','200 mesh');
hold 
xlabel('Distance, X, in meter');
ylabel('Temperature, teta, in Kelvin');
title('Temperature across fin from the base x=0');
grid
figure
plot(errm,err)
xlabel('Number of mesh, N');
ylabel('% difference/error');
title('error vs number of mesh at x= 1.0 m');
grid
fprintf('\n\nNote:-\n\tOptimum omega value is %g\n\tObtained from mfile optimum.m for N=200 mesh',omega);
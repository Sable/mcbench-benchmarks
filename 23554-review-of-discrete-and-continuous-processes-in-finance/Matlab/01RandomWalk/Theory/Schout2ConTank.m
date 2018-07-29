function [th,k,s]=Schout2ConTank(a,b,d)

th=d*b/sqrt(a^2-b^2);
k=1/(d*sqrt(a^2-b^2));
s=sqrt(d/sqrt(a^2-b^2));
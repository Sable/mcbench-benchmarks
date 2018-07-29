%++++++++++++++++++++++++++++++++++++++++++++
%PURPOSE: TO DETERMINE THE OPTIMUM VALUE OF 
%OVER-RELAXATION (OMEGA) FOR APPLICATION
%IN SOR GS, PICKED OVER MINIMUM VALUE OF
%SOR/GS ITERATION.
%++++++++++++++++++++++++++++++++++++++++++++
function [T]=optimum(om1,om2)
N=200;
eps=1e-6;%error
L=2;
dx=L/N;
n2=25;  %n^2=hP/kA
tb=400+273.15;
ta=34+273.15;
kira=0;

global omega eps N tb ta
warning off

[gs,T]=GS;

omega=om1;
while omega<om2
[sor,T]=SOR;
kira=kira+1;
wye(kira)=sor/gs;
exx(kira)=omega;
omega=omega+0.01;
end

plot(exx,wye);
ylabel('#SOR/#GS RATIO');
xlabel('OMEGA');
grid
%{


SpeedReducer  Problem

REF. Qie He, Ling Wang "An effective co-evolutionary particle swarm optimization for constrained engineering design problems", Engineering Applications of Artificial Intelligence 20 (2007) 89–99

REF2: Ivona Brajevic, Milan Tuba, and Milos Subotic, "Performance of the improved artificial bee colony algorithm on standard engineering constrained problems",
INTERNATIONAL JOURNAL OF MATHEMATICS AND COMPUTERS IN SIMULATION, Issue 2, Volume 5, 2011, 135-143.


cite  REF2 for low and up values;

low =[ 2.6 0.7 17 7.3 7.8 2.9 5   ];
up = [ 3.6 0.8 28 8.3 8.3 3.9 5.5 ];
dim = 7;

ds('SpeedReducer',[],30,dim,low,up,10e6)

%}

function y=SpeedReducer(X,str)
y=[];
for i=1:size(X,1);
    u=X(i,:);
    z=fhandle(u);
    y(i)=z+getconstraints(u);
end
return

function Z=getconstraints(u)

PEN=10^15;
lam=PEN; lameq=PEN;
Z=0;
[g,geq]=fnonlin(u);


for k=1:length(g),
    Z=Z+ lam*g(k)^2*getH(g(k));
end

for k=1:length(geq),
   Z=Z+lameq*geq(k)^2*geteqH(geq(k));
end
return


function H=getH(g)
if g<=0, 
    H=0; 
else
    H=1; 
end
return


function H=geteqH(g)
if g==0,
    H=0;
else
    H=1; 
end
return


function f=fhandle(X)
f=[];
for i=1:size(X,1)
    x=X(i,:);
    f(i)=0.7854*x(1)*x(2)^2*(3.3333*x(3)^2+14.9334*x(3)-43.0934)-1.508*x(1)*(x(6)^2+x(7)^2)+7.4777*(x(6)^3+x(7)^3)+0.78054*(x(4)*x(6)^2+x(5)*x(7)^2);
end
return

function [g,geq]=fnonlin(x)
g=[];

g(1) = 27/(x(1)*x(2)^2*x(3))-1;
g(2) = 397.50/(x(1)*x(2)^2*x(3)^2)-1;
g(3) = (1.93*x(4)^3)/(x(2)*x(3)*x(6)^4)-1;
g(4) = (1.93*x(5)^3)/(x(2)*x(3)*x(7)^4)-1;
g(5)= (1/(110*x(6)^3))*sqrt(((750*x(4))/(x(2)*x(3)))^2+16.9e6)-1;
g(6)= (1/(85*x(7)^3))*sqrt(((750*x(5))/(x(2)*x(3)))^2+157.5e6)-1;
g(7)=(x(2)*x(3))/40-1;
g(8)=(5*x(2))/x(1)-1;
g(9)=(x(1)/(12*x(2)))-1;
g(10)=((1.5*x(6)+1.9)/(x(4)))-1;
g(11)=(1.1*x(7)+1.9)/(x(5))-1;

geq=[];
return


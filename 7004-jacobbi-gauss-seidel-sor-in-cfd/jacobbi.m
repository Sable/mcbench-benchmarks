%++++++++++++++++++++++++++++++++++++++++++++
%(Jacobbi)
%updating values at the end 
%Return T result and number of iteration.
%Read the mesh number and etc from global variable
%++++++++++++++++++++++++++++++++++++++++++++
function [iter,Tn]=JACOBBI
global omega eps N tb ta
warning off
[aw,ae,ap,su]=abc;
%initialise all points to be zero
for i=1:N+2
    Tn(i)=0;
end
Tn(1)=tb;
Tn(N+2)=ta;
iter=0;
x=1;
while x==1  
    T=Tn;
    i=2;
    Tn(i)=(ae(1)*T(i+1)+aw(1)*T(i-1)+su(1))/ap(1);
    for i=3:N
         Tn(i)=(ae(2)*T(i+1)+aw(2)*T(i-1)+su(2))/ap(2);        
    end
    i=N+1;
    Tn(i)=(ae(3)*T(i+1)+aw(3)*T(i-1)+su(3))/ap(3);
    differ=abs(Tn-T);
    iter=iter+1;
    if max(differ)<=eps 
        break
    end
end



%++++++++++++++++++++++++++++++++++++++++++++
%SOR- Successive Over Relaxation
%Gauss-Seidel with relaxation
%Return T result and number of iteration.
%Read the mesh number and etc from global variable
%++++++++++++++++++++++++++++++++++++++++++++
function [iter,T]=SOR
global omega eps N tb ta
warning off
[aw,ae,ap,su]=abc;
for i=1:N+2
    T(i)=0;
end
T(1)=tb;

iter=0;
x=1;
while x==1
    To=T;
    i=2;
    T(i)=(ae(1)*T(i+1)+aw(1)*T(i-1)+su(1))/ap(1);
    T(i)=(1-omega)*To(i)+omega*T(i);
    for i=3:N
         T(i)=(ae(2)*T(i+1)+aw(2)*T(i-1)+su(2))/ap(2);
         T(i)=(1-omega)*To(i)+omega*T(i);
    end
    i=N+1;
    T(i)=(ae(3)*T(i+1)+aw(3)*T(i-1)+su(3))/ap(3);
    T(i)=(1-omega)*To(i)+omega*T(i);
    differ=abs(To-T);
    iter=iter+1;
    if max(differ)<=eps 
        break
    end
end 
T(N+2)=T(N+1); % becuasu dT/dx=0 at the tip due to insulation

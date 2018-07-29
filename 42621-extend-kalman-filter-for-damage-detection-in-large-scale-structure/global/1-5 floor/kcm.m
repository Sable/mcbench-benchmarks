function [stiff,damp,fkp,fap,fbp]=kcm(n,xk)
m=10^6*[1.1 1.1 1.1 1.1 1.1];
mass=diag(m); 



% Stiffness Matrix
k(1:n)=xk(2*n+1:3*n);  % Stiffness parameters

stiff=zeros(n);
stiff(1,1)=k(1)+k(2); stiff(1,2)=-k(2);

for i=2:n-1;
   stiff(i,i-1)=-k(i);
   stiff(i,i)=k(i)+k(i+1);
   stiff(i,i+1)=-k(i+1);
end      
stiff(n,n-1)=-k(n); stiff(n,n)=k(n); 

% % Damping matrix
% %c(1:n)=xk(3*n+1:4*n); % Damping parameters
% 
% damp=zeros(n);
% damp(1,1)=c(1)+c(2); damp(1,2)=-c(2);
% 
% for i=2:n-1;
%    damp(i,i-1)=-c(i);
%    damp(i,i)=c(i)+c(i+1);
%    damp(i,i+1)=-c(i+1);
% end      
% damp(n,n-1)=-c(n); damp(n,n)=c(n);

% xpie3 matrix
x=xk(1:n);  % Displacement 

xkp=zeros(n);
xkp(1,1)=x(1); xkp(1,2)=x(1)-x(2);
for i=2:n-1;
   xkp(i,i)=x(i)-x(i-1);
   xkp(i,i+1)=x(i)-x(i+1);
end      
xkp(n,n)=x(n)-x(n-1); 

% xpie4 matrix
xp=xk(n+1:2*n);  %Velocity 

xcp=zeros(n);
xcp(1,1)=xp(1); xcp(1,2)=xp(1)-xp(2);
for i=2:n-1;
   xcp(i,i)=xp(i)-xp(i-1);
   xcp(i,i+1)=xp(i)-xp(i+1);
end      
xcp(n,n)=xp(n)-xp(n-1); 
    

damp=stiff*xk(3*n+2)+mass*xk(3*n+1);

fkp=xkp+xcp*xk(3*n+2);
fap=mass*xp;
fbp=stiff*xp;


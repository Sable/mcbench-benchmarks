function [c,ceq,gc,gceq,hc,hceq]=h134org(x,varargin) 
% example 13.4 of Optimization of Chemical Processes. 
% x = [c1 c2 c3 ... r1 r2 r3 ... theta1 theta2 theta3 ...]' 
% 
% equality constraints first in z
%
% Calculates the constraint functions and their 1. and
% 2. derivatives 
 
[m,n]=size(x); 
  
tanks=m/3; 

% scaling
en=ones(1,tanks); 
xscaling=diag([ en 0.01*en 100*en]); 
gscaling=diag([ en 100*en 0.01]);
x = xscaling * x;
% end scaling

k=0.00625; n0=2.5;  
%THETA=1000;  
THETA=1000 - 25*tanks;  
c0=20; 
 
cf=1; 
cl=tanks; 
rf=cl+1; 
rl=cl+tanks; 
tf=rl+1; 
tl=rl+tanks; 
 
  z=zeros(tf,n); 
   
  % component balance 
  z(cf:cl,:) = [c0(1,ones(1,n));x(1:(cl-1),:)] ... 	% input stream 
	       -  x(cf:cl,:) ...		                  	% output stream 
          -  x(tf:tl,:).*x(rf:rl,:);	            	% reaction 
					 
%  z(1,:) = c0     - x(1,:) - x(7,:).*x(4,:); 
%  z(2,:) = x(1,:) - x(2,:) - x(8,:).*x(5,:); 
%  z(3,:) = x(2,:) - x(3,:) - x(9,:).*x(6,:); 
 
  % reaction equation 
  z(rf:rl,:) = x(rf:rl,:) - k*(x(cf:cl,:).^n0);  
 
%  z(4,:) = x(4,:) - k*(x(1,:).^n0); 
%  z(5,:) = x(5,:) - k*(x(2,:).^n0); 
%  z(6,:) = x(6,:) - k*(x(3,:).^n0); 
 
  % volume constraint 
  z(tf,:) = sum(x(tf:tl,:)) - THETA; 
 
%  z(7,:) = x(7,:) + x(8,:) + x(9,:) - THETA; 

 zs = gscaling * z;	% scaling
 c = zs(tf,:);
 ceq = zs(cf:rl,:);
 
if nargout > 2 
  z = zeros(tf,m); 
  if tanks>1 
    z(cf+1:cl,1:(tanks-1)) = eye(tanks-1,tanks-1); 
  end 
  z(cf:cl,cf:cl) = z(cf:cl,cf:cl)-eye(tanks,tanks); 
  z(cf:cl,rf:rl) = -diag(x(tf:tl,1)); 
  z(cf:cl,tf:tl) = -diag(x(rf:rl,1)); 
  z(rf:rl,cf:cl) = -diag(k*n0*x(cf:cl,1).^(n0-1)); 
  z(rf:rl,rf:rl) = eye(tanks,tanks); 
  z(tf,tf:tl) = ones(1,tanks); 
 
%  z = [ -1  0  0 -x(7)   0     0   -x(4)   0     0 
%         1 -1  0   0   -x(8)   0     0   -x(5)   0 
%         0  1 -1   0     0   -x(9)   0     0   -x(6) 
%         -k*n0*x(1)^(n0-1) 0 0 1 0 0 0 0 0 
%         0 -k*n0*x(2)^(n0-1) 0 0 1 0 0 0 0 
%         0 0 -k*n0*x(3)^(n0-1) 0 0 1 0 0 0 
%         0 0 0 0 0 0 1 1 1 ]; 

  zs = gscaling * z * xscaling;
  gc = zs(tf,:)';
  gceq = zs(cf:rl,:)';
end

if nargout > 4 
  z=zeros(tf,m*m); 
  y2=zeros(1,m*m); 
  for i=cf:cl 
     y1=zeros(m,m); 
     y1(i+tanks,i+2*tanks)=-1;y1(i+2*tanks,i+tanks)=-1;  
     y2(:)=y1; z(i,:)=y2; 
  end 
 
%                y1(4,7)=-1;y1(7,4)=-1; y2(:)=y1; z(1,:)=y2; 
%  y1(:)=z(2,:); y1(5,8)=-1;y1(8,5)=-1; y2(:)=y1; z(2,:)=y2; 
%  y1(:)=z(3,:); y1(6,9)=-1;y1(9,6)=-1; y2(:)=y1; z(3,:)=y2; 
 
  for i=rf:rl 
     y1=zeros(m,m); 
     y1(cf:cl,cf:cl) = -diag(k*n0*(n0-1)*x(cf:cl,1).^(n0-2)); 
     y2(:)=y1; z(i,:)=y2; 
  end 
 
%  y1(:)=z(4,:); y1(1,1)=-k*n0*(n0-1)*x(1)^(n0-2); y2(:)=y1; z(4,:)=y2; 
%  y1(:)=z(5,:); y1(2,2)=-k*n0*(n0-1)*x(2)^(n0-2); y2(:)=y1; z(5,:)=y2; 
%  y1(:)=z(6,:); y1(3,3)=-k*n0*(n0-1)*x(3)^(n0-2); y2(:)=y1; z(6,:)=y2; 
end 
 
return 



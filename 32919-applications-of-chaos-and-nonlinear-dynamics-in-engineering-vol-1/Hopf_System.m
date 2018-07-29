function sys=Hopf_System(~,x)
global b
X=x(1,:);  
Y=x(2,:);  

% Define the system. 
P=1+Y.*X.^2-b*X-X;        
Q=b*X-X.^2.*Y;

sys=[P;Q]; 



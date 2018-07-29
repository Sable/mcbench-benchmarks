function [h1,h2]=mncirc(M,N)
if nargin==1,  
   N=[1/3,1/4,1/6,1/12]*pi; 
   N=[-N(length(N):-1:1),N];
elseif nargin==0
   M=[1.3,1.4,1.5,2,3]; M=[M, 1./M];
   N=[1/3,1/4,1/6,1/12]*pi; 
   N=[-N(length(N):-1:1),N];
end
Mx=[]; My=[]; Nx=[]; Ny=[];
t=[0:pi/30:2*pi];
for i=1:length(M)
   r=M(i)/(1-M(i)^2); x0=r*M(i); 
   Mx=[Mx; r*cos(t)+x0]; 
   My=[My; r*sin(t)];
end
for i=1:length(N)
   r=sqrt(1+N(i)^2)/(2*N(i)); 
   x0=-1/2; y0=1/(2*N(i));
   Nx=[Nx; r*cos(t)+x0]; 
   Ny=[Ny; r*sin(t)+y0];
end
h1=line(Mx',My'); h2=line(Nx',Ny');
set([h1;h2],'Color',[1,0,0],'LineStyle',':');

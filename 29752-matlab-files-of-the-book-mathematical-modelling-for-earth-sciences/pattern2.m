% ------------------------------------------------------------------- %
% Matlab files listed in Appendix B of the following book by          %
% Xin-She Yang, Mathematical Modelling for Earth Sciences,            %
%               Dunedin Academic Presss, Edinburgh, UK, (2008).       %
% http://www.dunedinacademicpress.co.uk/ViewReviews.php?id=100        %
% ------------------------------------------------------------------- %

% ------------------------------------------------------------------- %
% Pattern formation of u,v on a 2-D grid 
% written by Xin-She Yang (Cambridge University)
% PDE forms: 
%     u_t=Da*(u_{xx}+u_{yy})+gamma*f(u,v)
%     v_t=Db*(v_{xx}+v_{yy})+beta*g(u,v)
% Usage: pattern2(200); or  pattern2;
% ------------------------------------------------------------------- %

function pattern2(time)
% Input number of time steps
if nargin<1, time=100; end

% Initialize parameters n=100; Da, Db etc;
n=100; 
Da=0.2; 
Db=0.1; 
gamma=0.5; 
beta=0.2;
% Nonlinear system of partial differential equations.  The solution of 
% the PDEs is obtained by the finite difference method assuming dx=dy=dt=1
% u_t=Da(u_{xx}+u_{yy})+gamma*f(u,v); 
% fstr=f(u,v)='u.*(1-u)'; 
% v_t=Db(v_{xx}+v_{yy})+beta*g(u,v); 
% gstr=g(u,v)='u-u.^2.*v'; 

fstr='u.*(1-u)';
gstr='u-u.^2.*v';
  
%Set initial values of u,v randomly 
u=rand(n,n);  
v=rand(n,n);
ugrad=u*0;
vgrad=v*0;

% Index for u(i,j) and loop
I = 2:n-1; J = 2:n-1;

% Time stepping 
for step=1:time,
% Laplace gradients
ugrad(I,J)=u(I,J-1)+u(I,J+1)+u(I-1,J)+u(I+1,J);
vgrad(I,J)=v(I,J-1)+v(I,J+1)+v(I-1,J)+v(I+1,J);
     
% updating the equations
u =(1-4*Da)*u+Da*ugrad+gamma*eval(fstr);
v =(1-4*Db)*v+Db*vgrad+beta*eval(gstr);
        
% Show results
        subplot(1,2,1);
        pcolor(u);
        shading interp;
        axis equal;axis([0 n 0 n]);
        
 % set font etc for display
hnda=colorbar('horiz'); 
set([gca hnda],'fontsize',14,...
               'fontweight','bold');
title('u(x,y,t)');
% display v
        subplot(1,2,2);
        pcolor(v);
        shading interp; 
        axis equal;
        hndb=colorbar('horiz');
        axis([0 n 0 n]);
set([gca hndb],'fontsize',14,...
               'fontweight','bold');
title('v(x,y,t)');

% Coloring and colormap
colormap jet;
disp (strcat('Time step = ',num2str(step))); 
drawnow;      
end
% ------------------------------------------------------------------- %
% -------------------------- End of Program ---------------------------

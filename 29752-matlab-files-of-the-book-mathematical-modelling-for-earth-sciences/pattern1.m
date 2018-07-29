% ------------------------------------------------------------------- %
% Matlab files listed in Appendix B of the following book by          %
% Xin-She Yang, Mathematical Modelling for Earth Sciences,            %
%               Dunedin Academic Presss, Edinburgh, UK, (2008).       %
% http://www.dunedinacademicpress.co.uk/ViewReviews.php?id=100        %
% ------------------------------------------------------------------- %

% ------------------------------------------------------------------- %
% Pattern formation: a 15 line matlab program
% PDE form: u_t=D*(u_{xx}+u_{yy})+gamma*q(u)
% written by Xin-She Yang (Cambridge University)
% Usage: pattern(200)   or  simply  >pattern
% ------------------------------------------------------------------- %

function pattern(time)
% Input number of time steps
if nargin<1, time=100; end

% Initialize parameters n=100; 
% D=0.2; gamma=0.5;
n=100; D=0.2; gamma=0.5;

% Nonlinear partial differential equation
% The solution of the PDE is obtained by
% finite difference method, assuming dx=dy=dt=1
% u_t=D(u_{xx}+u_{yy})+gamma*q(u) where qstr='u.*(1-u)'; 
qstr='u.*(1-u)';

%Set initial values of u randomly 
u=rand(n,n);  grad=u*0;

% Index for u(i,j) and loop
I = 2:n-1; J = 2:n-1;

% Time stepping 
for step=1:time,
% Laplace gradient/updating the equation
 grad(I,J)= u(I,J-1)+u(I,J+1)+u(I-1,J)+u(I+1,J);
 u =(1-4*D)*u+D*grad+gamma*eval(qstr);
% Boundary conditions -- periodic (default)
u(1,J)=u(end,J); u(I,1)=u(I,end);

% Show results
 pcolor(u);  shading interp; 
% Coloring and colorbar
 h=colorbar; colormap jet;
 drawnow;   
end

% plot as a surface 
surf(u); shading interp; view([-25 70]);
% --------------------- End of Program -------------------------

% This matlab codes implement the adaptive residual subsampling 
% method for radial basis function 1-D initial-boundary value problem. 
%
% Implementation : Method of lines
%                  Time-stepping: 4th order Runge-Kutta method
%                  Space adaptivity: Adaptive residual subsampling for RBFs
%
% For reference, see:
% Adaptive residual subsampling methods for radial basis function
% interpolation and collocation problems. submitted to Computers Math. Appl
%
% Tobin A. Driscoll and Alfa R.H. Heryudono    05/14/2006
% MATLAB 7 is recommended.
%
% Test problem:
% Burger's Equation
% epsilon.u_xx - u.u_x = u_t, 0 < x < 1
% u(0,t)=u(1,t)=0.

Tfin = 1;
dt = Tfin/100;

epsilon = 1e-3; theta = 1e-4;
theta = [theta theta/1000];
initcond = @(x) sin(2*pi*x) + 0.5*sin(pi*x);
[x,c,u0] = coarserefine(initcond,[0 1],theta,13,0.75);

Tdone = 0;
han = plot(x,u0,'-ko',x,-1*x.^0,'ko','MarkerFaceColor','k','MarkerSize',2);
tp = title('','erasemode','xor'); hold on;
xlabel('x');ylabel('u(x,t)');
axis([0 1 -1 1.5])

while Tdone < Tfin
N = length(x);

[A,D1,D2] = deal(zeros(N));
for j=1:N
    [A(:,j),D1(:,j),D2(:,j)] = mq(x,x(j),c(j));
end

lambda = A\eye(N);
D1 = D1*lambda; D1([1 N],:)=[]; D1(:,[1 N])=[];
D2 = D2*lambda; D2([1 N],:)=[]; D2(:,[1 N])=[];

% Solve system of ODEs
options = odeset('RelTol',1e-5,'AbsTol',1e-8,'Jacobian',@Jburgers,'OutputFcn', ...
                  @(t,y,flag,varargin) burgersplot(t,y,flag,varargin,x,han));

set(tp,'string',sprintf('T = %.3f,    N = %3i.',Tdone,N));
[T,U] = ode15s(@burgers,[Tdone Tdone+dt],u0(2:N-1),options,epsilon,D1,D2);

disp('-----------------------');
[x,c,u0] = coarserefine(@(xp)predictor(xp,x,[0;U(end,:)';0]),[0 1],theta,13,0.75);
Tdone = Tdone + dt;
end


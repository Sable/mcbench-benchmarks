% ------------------------------------------------------------------ %
% Pattern formation:  a 15 line matlab program                       %
% PDE form: u_t=D*(u_{xx}+u_{yy})+gamma*q(u) where q(u)='u.*(1-u)';  %
% ------------------------------------------------------------------ %
% This KPP equation and its numerical solution are discussed         %
% in detail in Section 10.4, Chapter 10 of the following book by     %
%    Xin-She Yang, Introduction to Computational Mathematics,        % 
%    World Scientific, (2008)                                        %
%    http://www.worldscibooks.com/mathematics/6867.html              %
% ------------------------------------------------------------------ %

% ================================================================== %
% The solution of this PDE is obtained by the finite difference      %
% method, assuming dx=dy=dt=1.                                       % 
% Programmed by X S Yang (Cambridge University) @ 2008               %
% ================================================================== %
% Usage: pattern(200)   or  simply >pattern
% ================================================================== %

% ----------------------------------------------------
function pattern(n)                    % line 1
% Default the domain size n by n
if nargin<1, n=200; end                % line 2
% ----------------------------------------------------
% Initialize parameters
% ---- time=100, D=0.2; gamma=0.5; -------------------
% These values can be changed, but be careful, and 
% some stabilities analysis is recommended to identify 
% the right parameter values for pattern formation
time=100; D=0.2; gamma=0.5;            % line 3
% ---- Set initial values of u randomly --------------
u=rand(n,n);  grad=u*0;                % line 4
% Vectorization/index for u(i,j) and the loop --------
I = 2:n-1; J = 2:n-1;                  % line 5
% ---- Time stepping ---------------------------------
for step=1:time,                       % line 6
% Laplace gradient of the equation     % line 7
 grad(I,J)= u(I,J-1)+u(I,J+1)+u(I-1,J)+u(I+1,J);
 u =(1-4*D)*u+D*grad+gamma*u.*(1-u);   % line 8
% ----- Show results ---------------------------------
 pcolor(u);  shading interp;           % line 9
% ----- Coloring and showing colorbar ----------------
 colorbar; colormap hsv;               % line 10
 drawnow;                              % line 11
end                                    % line 12
% ----- Topology of the final surface ----------------
surf(u);                               % line 13
shading interp; colormap jet;          % line 14
view([-25 70]);                        % line 15
% ---- end of this program ---------------------------

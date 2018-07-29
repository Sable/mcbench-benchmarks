% Copyright 2013 The MathWorks, Inc.

%% Parameters
rho = 1; % kg/m^3
U = 1;   % m/s
mu = 1e-5; % kg/(m*s)
nu = mu/rho; % m^2/s

L = 0.2; % m
H = 0.03; % m
nx = 11;
ny = 41;

dx = L/(nx-1);
dy = H/(ny-1);
[X,Y] = meshgrid(0:dx:L,0:dy:H);
Re_L = U*L/nu;
delta_L = 5/sqrt(U/nu/L);

v = zeros(ny,nx);
u = zeros(ny,nx);
%% Boundary Conditions
u(:,1) = U; % Incoming
v(:,1) = 0; % Incoming
u(1,:) = 0; % Bottom
v(1,:) = 0; % Bottom
u(ny,:) = U; % Top, free stream
%% Solve with Gaussian Elimination(TDMA specifically)
i = 0;
% March in the x direction
while i < nx-1
    i = i+1;
    % Determine parameters A,B,C,D in TDMA method
    for j = 2:ny-1
        if j == 2
            A(j) = 0;
            B(j) = 2*nu/dy^2 + u(j,i)/dx;
            C(j) = - nu/dy^2 + v(j,i)/2/dy;
            D(j) = u(j,i)^2/dx - (- nu/dy^2 - v(j,i)/2/dy)*u(j-1,i+1);
        elseif j > 2 && j < ny-1
            A(j) = - nu/dy^2 - v(j,i)/2/dy;
            B(j) = 2*nu/dy^2 + u(j,i)/dx;
            C(j) = - nu/dy^2 + v(j,i)/2/dy;
            D(j) = u(j,i)^2/dx ;
        elseif j == ny-1
            A(j) = - nu/dy^2 - v(j,i)/2/dy;
            B(j) = 2*nu/dy^2 + u(j,i)/dx;
            C(j) = 0;
            D(j) = u(j,i)^2/dx - (- nu/dy^2 + v(j,i)/2/dy)*u(j+1,i+1);
        end
    end
    % solve for u with TDMA method
    usol = tdma(A(2:end),B(2:end),C(2:end),D(2:end));
    u(2:ny-1,i+1) = usol;
    % solve for v(j,i+1) based on known u
    for j = 2:ny
        v(j,i+1) = v(j-1,i+1) - dy/2/dx*(u(j,i+1)-u(j,i)+u(j-1,i+1)-u(j-1,i));
    end
end
%% Plotting
% u/U velocity contour
figure,
h1 = subplot(221);
set(h1,'XLim',[0 L],'YLim',[0 H],'NextPlot','replacechildren');
contourf(h1,X,Y,u/U,[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.99]);
colorbar('peer',h1,'SouthOutside');
title(h1,'u/U Velocity Contour');
xlabel(h1,'x (m)'),ylabel(h1,'y (m)');
% velocity vector profile
h2 = subplot(222);
set(h2,'XLim',[0 L],'YLim',[0 H],'NextPlot','replacechildren');
[~,hdelta] = contour(h2,X,Y,u/U,0.99);
set(hdelta,'Color','r','LineWidth',3,'ShowText','On');hold(h2,'on');
quiver(h2,X,Y,u,v,'b');
title(h2,'Velocity Profile and Boundary Layer Thickness (0.99U)');
xlabel(h2,'x (m)'),ylabel(h2,'y (m)');hold(h2,'off');
% streamlines
h3 = subplot(223);
[strx,stry] = meshgrid(0,0:2*dy:H);
set(h3,'XLim',[0 L],'YLim',[0 H],'NextPlot','replacechildren');
streamline(h3,X,Y,u,v,strx,stry);
title(h3,'Streamlines');
xlabel(h3,'x (m)'),ylabel(h3,'y (m)');
% Copyright 2013 The MathWorks, Inc.

%% Initialization
% store input parameters with shorter names
D1 = 0.2; % m
D2 = 0.1; % m
L1 = 0.5; % m
L2 = 0.5; % m
U1 = 0.2; % m/s
nx = 51;  % number of x nodes
ny = 11;  % number of y nodes
nmax = 10000; % maxsimum number of iterations
% compute grid length
dx = (L1+L2)/(nx-1);
dy = max(D1,D2)/(ny-1);
% nondimensionalization
dX = dx/D1;
dY = dy/D1;
PSI = ones(ny,nx);
%% Boundary conditions
PSI(1,:) = 0; % bottom
PSI(floor(D1/dy+1),1:floor(L1/dx+1)) = 1; % left part of top
PSI(floor(D2/dy+1),floor(L1/dx+1):nx) = 1; % right part of top
for j = 1:floor(D1/dy+1)
    PSI(j,1) = (j-1)*dY; % inlet
end
for j = 1:floor(D2/dy+1)
    PSI(j,nx) = D1/D2*(j-1)*dY; % outlet
end
%% Iteration to solve for stream function PSI
err = 1e-6; % convergence criteria
n = 0;
while n < nmax
    n = n + 1;
    tempPSI = PSI;
    % left part of the channel
    for i = 2:floor(L1/dx+1)
        for j = 2:(floor(D1/dy+1)-1)
            PSI(j,i) = 1/(2/dX^2+2/dY^2)*((tempPSI(j,i+1)+PSI(j,i-1))/dX^2+(tempPSI(j+1,i)+PSI(j-1,i))/dY^2);
        end
    end
    % right part of the channel
    for i = floor(L1/dx+1):nx-1
        for j = 2:(floor(D2/dy+1)-1)
            PSI(j,i) = 1/(2/dX^2+2/dY^2)*((tempPSI(j,i+1)+PSI(j,i-1))/dX^2+(tempPSI(j+1,i)+PSI(j-1,i))/dY^2);
        end
    end
    % checking for convergence
    if max(max(abs(PSI-tempPSI))) <= err
        break
    end
end
%% Print convergence result to screeen
if n < nmax
    fprintf('Converged. Total number of iterations: %g\n',n);
else
    fprintf('NOT Converged! Change n_x, n_y, n_max or convergence criteria.\n')
end
%% Solve for velocity u and v from stream function
u = zeros(ny,nx);
v = zeros(ny,nx);
psi = PSI*U1*D1; % dimentionalization
for j = 2:ny-1
    u(j,:) = (psi(j+1,:)-psi(j-1,:))/2/dy;
end
for i = 2:nx-1
    v(:,i) = -(psi(:,i+1)-psi(:,i-1))/2/dx;
end
% velocity at boundaries (inviscid, so slip occurs)
u(1,:) = u(2,:);
u(ny,:) = u(ny-1,:);
v(:,1) = v(:,2);
v(:,nx) = v(:,nx-1);
%% Plot results
[X, Y] = meshgrid(0:dx:(L1+L2),0:dy:max(D1,D2));
% contour plot of stream function
ax1 = subplot(2,1,1);
contourf(ax1,X,Y,PSI),colormap(ax1,'jet')
% vector plot of velocity u and v
ax2 = subplot(2,1,2);
quiver(ax2,X,Y,u,v),
axis([ax1 ax2],[0 L1+L2 0 max(D1,D2)]),
% plot the shape of the channel based on input parameters
if D1 < D2
    cornerposition = [0 D1 L1 D2-D1];
elseif D1 > D2
    cornerposition = [L1 D2 L2 D1-D2];
else
    cornerposition = [0 D1 1 1];
end
rectangle('Parent',ax1,'Position',cornerposition,'FaceColor',[0.94 0.94 0.94])
rectangle('Parent',ax2,'Position',cornerposition,'FaceColor',[0.94 0.94 0.94])
set(get(ax1,'XLabel'),'String','x (m)')
set(get(ax1,'YLabel'),'String','y (m)')
set(get(ax1,'Title'),'String','Normalized Stream Function \Psi')
set(get(ax2,'XLabel'),'String','x (m)')
set(get(ax2,'YLabel'),'String','y (m)')
set(get(ax2,'Title'),'String','Velocity Profile')

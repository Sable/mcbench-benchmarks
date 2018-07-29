%% Unstructured Grid
% This examples shows how to use ConstructProjector2D on unstructured
% grids. Two sets of points are generated randomly. 
clear;clc;
%% Initializing Part I
disp('- Initializing')
rSource=2*pi;
rDestination=rSource*1.05; % This slightly bigger radius causes some points
                           % on destination grid being outside of the
                           % source grid; hence, on those points it is
                           % actually extrapolation and not interpolation.

ns=300;
nd=50;

nPoly=4; % We gonna fit a fourth order polynomial, 
         % i.e. sum_{n,m=0}^{n,m=nPoly} x^n*y^m 
nInterp=35; % nPoly=4 requires 25 points. However, 
            % we are going to use 35 points. This would be 
            % the least-square fit of the surface.
            % Note that: min(nInterp)=(nPoly+1)^2. Otherwise it won't work.
%% Generating the Source grid
disp('- Generating the Source grid')
xs=rand(ns,1)*2*rSource-rSource;
ys=rand(ns,1)*2*rSource-rSource;

%% Generating the Destination Grid
disp('- Generating the Destination Grid')
xd=rand(nd,1)*2*rDestination-rDestination;
yd=rand(nd,1)*2*rDestination-rDestination;

figure
plot(xs,ys,'b.');
hold on
plot(xd,yd,'k.');
axis tight
axis square
legend('Source Grid','Destination Grid')
title('Distribution of the points')

%% Generating the interpolant
disp('- Generating the interpolant')
P=ConstructProjector2D(xs,ys,xd,yd,nPoly,nInterp);

%% Generating sum data
disp('- Generating sum data and interpolating')
F1=@(x,y) (sin(sqrt(x.^2+y.^2)));
F2=@(x,y) (sin(x).*cos(y));
F3=@(x,y) (exp(-sqrt(x.^2+y.^2)));
F4=@(x,y,x0,y0) (exp(-sqrt((x-x0).^2+(y-y0).^2)));

z=zeros(ns,4);
z(:,1)=F1(xs,ys);
z(:,2)=F2(xs,ys);
z(:,3)=F3(xs,ys);
z(:,4)=F4(xs,ys,0,0);

z_Analytic=zeros(nd,4);
z_Analytic(:,1)=F1(xd,yd);
z_Analytic(:,2)=F2(xd,yd);
z_Analytic(:,3)=F3(xd,yd);
z_Analytic(:,4)=F4(xd,yd,0,0);

% Interpolating
z_interp=P*z;

% Note that since the points are randomly generated the RMSE would change
% each time. Depending on how the points are distributed you may get very
% good or very bad RMSE.
RMSE=sqrt(mean( (z_interp-z_Analytic).^2 ));

%% plotting
figure
for i=1:4
  subplot(2,2,i)
  plot(z_interp(:,i),'b.');
  hold on
  plot(z_Analytic(:,i),'r.');
  legend('Interpolated','Analytic');
  title(['RMSE= ' num2str(RMSE(i))]);
end








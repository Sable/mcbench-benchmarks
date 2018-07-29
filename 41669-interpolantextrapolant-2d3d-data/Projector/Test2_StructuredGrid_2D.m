%% Structured grid
% This is a sample code showing how to use ConstructInterpolator().
% This example performs bilinear interpolation.
% Pay attention that no data is needed to construct the interpolator. Only
% the coordinates of the points on source and destination grid.
clear; clc;
%% Initializing Part I
disp('- Initializing')
xMin=0;
xMax=2*pi;
yMin=0;
yMax=2*pi;

nx=40;
ny=40;

nPoly=1;    % This would be a bilinear interpolation
nInterp=4; 

%% Generating the Source Grid
disp('- Generating the source grid.')
[xn,yn]=meshgrid(linspace(xMin,xMax,nx),linspace(yMin,yMax,ny));

%% Finding the cell centers
disp('- Generating the destination grid')
xc=(xn(1:ny-1,1:nx-1)+xn(2:ny,1:nx-1)+xn(1:ny-1,2:nx)+xn(2:ny,2:nx))*0.25;
yc=(yn(1:ny-1,1:nx-1)+yn(2:ny,1:nx-1)+yn(1:ny-1,2:nx)+yn(2:ny,2:nx))*0.25;

figure
surface(xn,yn,zeros(size(xn)));
hold on
plot(xn,yn,'k.');
plot(xc,yc,'b.');
axis tight;
axis square;
title('Source Grid, black dots, & the destination grid, blue dots.', ...
      'FontName','Arial','FontSize',12,'FontWeight','Bold');
%% Constructing the Interpolant
% Note: that we do not need the data on the source grid to create the
% interpolant.
disp('- Constructing the interpolant')
P=ConstructProjector2D(xn(:),yn(:),xc(:),yc(:),nPoly,nInterp);

%% Generarting some Data
disp('- Generating some data and interpolating')
F1=@(x,y) (sin(sqrt(x.^2+y.^2)));
zn=F1(xn,yn);
zc_interp=reshape(P*zn(:),size(xc));
zc_Analytic=F1(xc,yc);
RMSE=sqrt(mean((zc_Analytic(:)-zc_interp(:)).^2));

figure
surface(xc,yc,zc_interp,'EdgeColor','none');
title(['nPoly: ' num2str(nPoly) ', RMSE= ' num2str(RMSE)]);
axis tight

%% Generating some more data
disp('- Generating multiple data field on the source grid and interpolating them.')
F2=@(x,y) (sin(x).*cos(y));
F3=@(x,y) (exp(-sqrt(x.^2+y.^2)));
F4=@(x,y,x0,y0) (exp(-sqrt((x-x0).^2+(y-y0).^2)));

zn(:,:,1)=F1(xn,yn);
zn(:,:,2)=F2(xn,yn);
zn(:,:,3)=F3(xn,yn);
zn(:,:,4)=F4(xn,yn,mean(mean(xn)),mean(mean(yn)));

zc_Analytic(:,:,1)=F1(xc,yc);
zc_Analytic(:,:,2)=F2(xc,yc);
zc_Analytic(:,:,3)=F3(xc,yc);
zc_Analytic(:,:,4)=F4(xc,yc,mean(mean(xn)),mean(mean(yn)));

% Now interpolating
% Note that the same interpolant is used for all data fields and they can
% be all interpolated with one sparse matrix multiplication.
zc_interp=P*reshape(zn,nx*ny,4); % There are 4 data fields.
zc_interp=reshape(zc_interp,(nx-1),(ny-1),4); % these two commands can be combined in one.
                                              % They were separated for clarity.

% calculating the RMSE and plotting
RMSE=zeros(4,1);
figure
for i=1:4
  RMSE(i)=sqrt(mean((reshape(zc_Analytic(:,:,i),(nx-1)*(ny-1),1)-reshape(zc_interp(:,:,i),(nx-1)*(ny-1),1)).^2));
  subplot(2,2,i);
  surface(xc,yc,squeeze(zc_interp(:,:,i)),'EdgeColor','none');
  title(['F' num2str(i) ', nPoly: ' num2str(nPoly) ', RMSE:' num2str(RMSE(i))])
  axis tight
  axis square
end












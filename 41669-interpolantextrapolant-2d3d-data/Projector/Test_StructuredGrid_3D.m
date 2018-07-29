%% Structured grid
% This is a sample code showing how to use ConstructProjector3D().
% This example is going to setup a transformation matrix based on forth
% order polynomials in 3D. 
% Pay attention that no data is needed to construct the interpolator. Only
% the coordinates of the points on source and destination grid.
clear;clc;
%% Initializing Part I
disp('- Initializing')
xMin=0;
xMax=2*pi;
yMin=0;
yMax=2*pi;
zMin=0;
zMax=2*pi;

nx=20;
ny=20;
nz=20;

dx=(xMax-xMin)/(nx-1);
dy=(yMax-yMin)/(ny-1);
dz=(zMax-zMin)/(nz-1);

nPoly=1; % We gonna fit a fourth order polynomial, 
         % i.e. sum_{n,m,t=0}^{n,m,t=nPoly} x^n*y^m*z^t 
nInterp=8; % nPoly=4 requires 125 points. However, 
            % we are going to use 150 points. This would be 
            % the least-square fit of the surface.
            % Note that: min(nInterp)=(nPoly+1)^3. Otherwise it won't work.
%% Turning off the warnings
% Depending on the parameter that you choose the matrices might be nearly
% singular. In this example, despite being nearly singular, they are not 
% affecting the final interpolation. Therefore, I set the warning to off. 
% But generally do not turn it off and if you got this warning check if it 
% is going to affect your results or not.
disp('- Turning the warnings off')
warning('OFF','MATLAB:nearlySingularMatrix');

%% Generating the Source Grid
disp('- Generating the source grid.')
[xn,yn,zn]=meshgrid(linspace(xMin,xMax,nx),linspace(yMin,yMax,ny),linspace(zMin,zMax,nz));

%% Finding the cell centers
disp('- Generating the destination grid')
xc=xn(1:ny-1,1:nx-1,1:nz-1)+dx/2;
yc=yn(1:ny-1,1:nx-1,1:nz-1)+dy/2;
zc=zn(1:ny-1,1:nx-1,1:nz-1)+dz/2;

figure
plot3(xn(:),yn(:),zn(:),'k.','MarkerSize',20);
hold on
plot3(xc(:),yc(:),zc(:),'b.','MarkerSize',20);
axis tight;
axis square;
title('Source Grid, black dots, & the destination grid, blue dots.', ...
      'FontName','Arial','FontSize',12,'FontWeight','Bold');

%% Constructing the Interpolant
% Note: that we do not need the data on the source grid to create the
% interpolant.
disp('- Constructing the interpolant')
P=ConstructProjector3D(xn(:),yn(:),zn(:),xc(:),yc(:),zc(:),nPoly,nInterp);

%% Generarting some Data
disp('- Generating some data and interpolating')
F1=@(x,y,z) (sin(sqrt(x.^2+y.^2+z.^2)));
Vn=F1(xn,yn,zn);
Vc_interp=reshape(P*Vn(:),size(xc));
Vc_Analytic=F1(xc,yc,zc);
RMSE=sqrt(mean((Vc_Analytic(:)-Vc_interp(:)).^2));
disp(['RMSE: ' num2str(RMSE)])

%% Generating some more data
disp('- Generating multiple data field on the source grid and interpolating them.')
F2=@(x,y,z) (sin(x).*cos(y).*sin(z));
F3=@(x,y,z) (exp(-sqrt(x.^2+y.^2+z.^2)));
F4=@(x,y,z,x0,y0,z0) (exp(-sqrt((x-x0).^2+(y-y0).^2+(z-z0).^2)));

Vn(:,:,:,1)=F1(xn,yn,zn);
Vn(:,:,:,2)=F2(xn,yn,zn);
Vn(:,:,:,3)=F3(xn,yn,zn);
Vn(:,:,:,4)=F4(xn,yn,zn,mean(mean(mean(xn))),mean(mean(mean(yn))),mean(mean(mean(zn))));

Vc_Analytic(:,:,:,1)=F1(xc,yc,zc);
Vc_Analytic(:,:,:,2)=F2(xc,yc,zc);
Vc_Analytic(:,:,:,3)=F3(xc,yc,zc);
Vc_Analytic(:,:,:,4)=F4(xc,yc,zc,mean(mean(mean(xn))),mean(mean(mean(yn))),mean(mean(mean(zn))));

% Now interpolating
% Note that the same interpolant is used for all data fields and they can
% be all interpolated with one sparse matrix multiplication.
Vc_interp=P*reshape(Vn,nx*ny*nz,4); % There are 4 data fields.
Vc_interp=reshape(Vc_interp,(ny-1),(nx-1),(nz-1),4); % these two commands can be combined in one.
                                              % They were separated for clarity.

% calculating the RMSE and plotting
RMSE=zeros(4,1);
for i=1:4
  RMSE(i)=sqrt(mean((reshape(Vc_Analytic(:,:,:,i),(nx-1)*(ny-1)*(nz-1),1)-reshape(Vc_interp(:,:,:,i),(nx-1)*(ny-1)*(nz-1),1)).^2));
  disp(['F' num2str(i) ', nPoly: ' num2str(nPoly) ', RMSE:' num2str(RMSE(i))])
end












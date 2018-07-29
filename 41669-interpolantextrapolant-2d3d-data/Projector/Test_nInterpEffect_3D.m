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

nPoly=2; % We gonna fit a fourth order polynomial, 
         % i.e. sum_{n,m,t=0}^{n,m,t=nPoly} x^n*y^m*z^t 
nInterp=27:37;

%% Turning off the warnings
% Depending on the parameter that you choose the matrices might be nearly
% singular. In this example, despite being nearly singular, they are not 
% affecting the final interpolation. Therefore, I set the warning to off. 
% But generally do not turn it off and if you got this warning check if it 
% is going to affect your results or not.
% disp('- Turning the warnings off')
% warning('OFF','MATLAB:nearlySingularMatrix');

%% Generating the Source Grid
disp('- Generating the source grid.')
[xn,yn,zn]=meshgrid(linspace(xMin,xMax,nx),linspace(yMin,yMax,ny),linspace(zMin,zMax,nz));

%% Finding the cell centers
disp('- Generating the destination grid')
xc=xn(1:ny-1,1:nx-1,1:nz-1)+dx/2;
yc=yn(1:ny-1,1:nx-1,1:nz-1)+dy/2;
zc=zn(1:ny-1,1:nx-1,1:nz-1)+dz/2;

% figure
% plot3(xn(:),yn(:),zn(:),'k.','MarkerSize',20);
% hold on
% plot3(xc(:),yc(:),zc(:),'b.','MarkerSize',20);
% axis tight;
% axis square;
% title('Source Grid, black dots, & the destination grid, blue dots.', ...
%       'FontName','Arial','FontSize',12,'FontWeight','Bold');

%% Generarting some Data
disp('- Generating some data and interpolating')
F1=@(x,y,z) (sqrt(x.^2+y.^2+z.^2));
Vn=F1(xn,yn,zn);
Vc_Analytic=F1(xc,yc,zc);

%% Generating the interpolant
disp('- Generating the interpolant and testing nInterp')
RMSE=zeros(size(nInterp));
for i=1:numel(nInterp)
  disp(['-- nInterp= ' num2str(nInterp(i))])
  P=ConstructProjector3D(xn(:),yn(:),zn(:),xc(:),yc(:),zc(:),nPoly,nInterp(i));
  % Interpolating
  Vc_interp=P*Vn(:);

  % Calculating the RMSE
  RMSE(i)=sqrt(mean( (Vc_interp-Vc_Analytic(:)).^2 ));
  disp(['   RMSE= ' num2str(RMSE(i))])
end
%% plotting

figure
plot(nInterp,RMSE,'b.-')
xlabel('nInterp');
ylabel('RMSE');
axis tight

disp('All done!')




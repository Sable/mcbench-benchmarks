%% Unstructured Grid
% This examples shows how nInterp affects the accuracy of the 
% interpolation/extrapolation. Note that since the source and destination
% grids are randomely generated, you will get a different results each time
% you execute this code.
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
nInterp=25:45; 

%% Turning off the warnings
% Depending on the parameter that you choose the matrices might be nearly
% singular. In this example, despite being nearly singular, they are not 
% affecting the final interpolation. Therefore, I set the warning to off. 
% But generally do not turn it off and if you got this warning check if it 
% is going to affect your results or not.
disp('- Turning the warnings off')
warning('OFF','MATLAB:nearlySingularMatrix');

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

%% Generating sum data
disp('- Generating sum data and interpolating')
F1=@(x,y) (sin(sqrt(x.^2+y.^2)));

z=F1(xs,ys);
z_Analytic=F1(xd,yd);

%% Generating the interpolant
disp('- Generating the interpolant')
RMSE=zeros(size(nInterp));
for i=1:numel(nInterp)
  disp(['-- nInterp= ' num2str(nInterp(i))])
  P=ConstructProjector2D(xs,ys,xd,yd,nPoly,nInterp(i));

  % Interpolating
  z_interp=P*z;

  % Calculating the RMSE
  RMSE(i)=sqrt(mean( (z_interp-z_Analytic).^2 ));
  disp(['   RMSE= ' num2str(RMSE(i))])
end
%% plotting

figure
plot(nInterp,RMSE,'b.-')
xlabel('nInterp');
ylabel('RMSE');
axis tight

disp('All done!')






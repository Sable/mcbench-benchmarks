function [imgls,opts,sls]=FCLSM(img,imgfcm,beta)

img=double(img);

se=5;       %template radius for spatial filtering
sigma=2;    %spatial filter weight
d0=.5;      %fuzzy thresholding
epsilon=1.5;    %Dirac regulator

%adaptive definition of penalizing item mu
u=d0<=imgfcm;
bwa=bwarea(u);  %area of initial contour
bw2=bwperim(u);
bwp=sum(sum(bw2));  %peripherium of initial contour
mu=bwp/bwa;     %Coefficient of the internal (penalizing) energy term P(\phi);
opts.mu=mu;
timestep=0.2/mu; %The product timestep*mu must be less than 0.25 for stability
opts.timestep=timestep;
%end

% fs=fspecial('disk',5);
% imgs=imfilter(img,fs,'replicate');
fs=fspecial('gaussian',se,sigma);
img_smooth=conv2(double(img),double(fs),'same');
[Ix,Iy]=gradient(img_smooth);
f=Ix.^2+Iy.^2;
g=1./(1+f);  % edge indicator function.

% define initial level set function as -c0, c0 
%   at points outside and inside of a region R, respectively.
u=u-0.5;
u=4*epsilon*u;
sls(1,:,:)=double(u);

lambda=1/mu;
opts.lambda=lambda;
% nu=2*imgfcm-1;     % Coefficient of the weighted area term Ag(\phi);
nu=-2*(2*beta*imgfcm-(1-beta));
opts.alf=nu;
%Note: Choose a positive(negative) alf if the initial contour is
% outside(inside) the object.

% start level set evolution
bGo=1;
nTi=0;
while bGo
    u=EVOLUTION(u, g, lambda, mu, nu, epsilon, timestep, 100);
    nTi=nTi+1;
    sls(nTi+1,:,:)=u;
    
    pause(0.001);
    imshow(img,[]);hold on;
    [c,h] = contour(u,[0 0],'m');
    title(sprintf('Time Step: %d',nTi*100));
    hold off
    if ~strcmp(questdlg('Continue or not?'),'Yes'),bGo=0;end
    pause(0.1);
end

imgls=u;

imshow(img,[]);
hold on
imgt(:,:)=sls(1,:,:);
[c,h] = contour(imgt,[0 0],'m');
[c,h] = contour(u,[0 0],'g','linewidth',2); 
totalIterNum=[num2str(nTi*100), ' iterations'];  
title(['Magenta: Initial; Green: Final after ', totalIterNum]);
hold off

%% core functions of level set methods
function u = EVOLUTION(u0, g, lambda, mu, nu, epsilon, delt, numIter)
u=u0;
[vx,vy]=gradient(g);
 
for k=1:numIter
    u=NeumannBoundCond(u);
    [ux,uy]=gradient(u); 
    normDu=sqrt(ux.^2 + uy.^2 + 1e-10);
    Nx=ux./normDu;
    Ny=uy./normDu;
    diracU=Dirac(u,epsilon);
    K=curvature_central(Nx,Ny);
    weightedLengthTerm=lambda*diracU.*(vx.*Nx + vy.*Ny + g.*K);
    penalizingTerm=mu*(4*del2(u)-K);
    weightedAreaTerm=nu.*diracU.*g;
    u=u+delt*(weightedLengthTerm + weightedAreaTerm + penalizingTerm); 
    % update the level set function
end

% the following functions are called by the main function EVOLUTION
function f = Dirac(x, sigma)
f=(1/2/sigma)*(1+cos(pi*x/sigma));
b = (x<=sigma) & (x>=-sigma);
f = f.*b;

function K = curvature_central(nx,ny)
[nxx,junk]=gradient(nx);  
[junk,nyy]=gradient(ny);
K=nxx+nyy;

function g = NeumannBoundCond(f)
% Make a function satisfy Neumann boundary condition
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);  
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);          
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);


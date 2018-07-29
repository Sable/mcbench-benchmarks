%% Parameter setting %%

param.nx = 64;
param.ny = 64;
param.nz = 64;

param.sx = 64; % mm
param.sy = 64; % mm
param.sz = 64; % mm

% Detector setting, according to Varian Trilogy OBI (real size)
param.su = 256;	% mm
param.sv = 200;	% mm

%The real detector panel pixel density (number of pixels)
param.nu = 128;		
param.nv = 100;

% X-ray source and detector setting
param.DSD = 900;    %  Distance source to detector 
param.DSO = 400;	%  X-ray source to object axis distance

% angle setting
dir = -1;   % gantry rotating direction
param.deg = 0:4.3:360;
param.deg = param.deg*dir;
param.nProj = length(param.deg);

% filter='ram-lak','cosine', 'hamming', 'hann' 
param.filter='hamming'; % high pass for sintetic images 

param.dx = param.sx/param.nx;
param.dy = param.sy/param.ny;
param.dz = param.sz/param.nz;
param.du = param.su/param.nu;
param.dv = param.sv/param.nv;

param.off_u = 0; param.off_v = 0; % detector rotation shift (real size)

% % % For fast CPU calculation % % %
param.xs = [-(param.nx-1)/2:1:(param.nx-1)/2]*param.dx;
param.ys = [-(param.ny-1)/2:1:(param.ny-1)/2]*param.dy;
param.zs = [-(param.nz-1)/2:1:(param.nz-1)/2]*param.dz;

param.us = (-(param.nu-1)/2:1:(param.nu-1)/2)*param.du + param.off_u;
param.vs = (-(param.nv-1)/2:1:(param.nv-1)/2)*param.dv + param.off_v;


%% projection
load Phantom64.mat % img

proj = CTprojection(img,param);

for i=1:param.nProj
    figure(1); imagesc(max(proj(:,:,i)',0)); axis off; axis equal; colormap gray; colorbar;
    title(num2str(i));
    pause(0.01);
end
    

%% filtered backprojection
% filter='ram-lak','shepp-logan','cosine', 'hamming', 'hann' 
param.filter='hamming'; 
% param.filter='ram-lak'; 

Reconimg = CTbackprojection(proj, param);

for i=1:param.nz
    figure(2); imagesc(max(Reconimg(:,:,i),0)); axis off; axis equal; colormap gray; colorbar;
    title(num2str(i));
    pause(0.01);
end

%% MLEM
param.filter = 'none';

img = ones(param.nx, param.ny, param.nz,'single');
Norimg = CTbackprojection(ones(param.nu, param.nv, param.nProj, 'single'), param);

for iter = 1:50
    
    proj_ratio = proj./CTprojection(img,param);
    proj_ratio(isnan(proj_ratio)) = 0;
    proj_ratio(isinf(proj_ratio)) = 0;
    
    img_ratio = CTbackprojection(proj_ratio, param)./Norimg;
    img_ratio(isnan(img_ratio)) = 0;
    img_ratio(isinf(img_ratio)) = 0;
    
    img = img.*img_ratio;
    
    figure(3); imagesc(max(img(:,:,round(end/2)),0)); axis off; axis equal; colormap gray; colorbar;
    title(['Iteration - ',num2str(iter)]);
    pause(0.1);
end










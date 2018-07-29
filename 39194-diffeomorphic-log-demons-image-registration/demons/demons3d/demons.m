% Demons Registration

function demons

figure(1); clf; colormap gray;

%% Parameters
niter           = 10;
sigma_fluid     = 1.0; % regularize update      field
sigma_diffusion = 1.0; % regularize deformation field
sigma_i         = 1.0; % weight on similarity term
sigma_x         = 1.0; % weight on spatial uncertainties (maximal step)
diffeomorphic   = 1;   % use exp(u)
nlevel          = 2;   % multiresolution
do_display      = 1;   % display iterations

% Load images
load('data/im1.mat');
load('data/im2.mat');

F = 256*F(31:90,31:90,:);
M = 256*M(31:90,31:90,:);

if nlevel == 1
    
    %% Register
    disp(['Register...']);
    opt = struct('niter',niter, 'sigma_fluid',sigma_fluid, 'sigma_diffusion',sigma_diffusion, 'sigma_i',sigma_i, 'sigma_x',sigma_x, 'diffeomorphic',diffeomorphic, 'do_display',do_display, 'do_plotenergy',1);
    [Mp,sx,sy,sz] = register(F,M,opt);

else
    
    %% Multiresolution
    vx = zeros(size(M)); % deformation field
    vy = zeros(size(M));
    vz = zeros(size(M));
    for k=nlevel:-1:1
        disp(['Register level: ' num2str(k) '...']);

        % downsample
        scale = 2^-(k-1);
        Fl  = resize(F,scale);
        Ml  = resize(M,scale);
        vxl = resize(vx*scale,scale);
        vyl = resize(vy*scale,scale);
        vzl = resize(vz*scale,scale);

        % register
        opt = struct('niter',niter,...
                     'sigma_fluid',sigma_fluid,...
                     'sigma_diffusion',sigma_diffusion,...
                     'sigma_i',sigma_i,...
                     'sigma_x',sigma_x,...
                     'diffeomorphic',diffeomorphic,...
                     'vx',vxl, 'vy',vyl, 'vz',vzl,...
                     'do_display',do_display, 'do_plotenergy',1);
        [Mp,sxl,syl,szl,vxl,vyl,vzl] = register(Fl,Ml,opt);

        % upsample
        vx = resize(vxl/scale,size(M));
        vy = resize(vyl/scale,size(M));
        vz = resize(vzl/scale,size(M));
    end
    
end

end

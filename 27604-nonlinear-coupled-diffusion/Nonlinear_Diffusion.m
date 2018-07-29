% function [U,minv,SS] = Nonlinear_Diffusion(U_0,tau,eps,p,T, theta, sigma, fig_handle)
% performs nonlinear scalar valued and coupled vector/matrix valued diffusion 
% inputs:
%           U_0             n x m x dxw input field:
%                                       d=1, w=1: scalar valued diffusion (e.g. grayscale image)
%                                       d>1, w=1: coupled vector valued diffusion (e.g. color image)
%                                       d>1, w>1: coupled isotropic matrix valued diffusion (e.g. nonlinear structure tensor)
%           tau             1 x 1       (optional) time step size
%           eps             1 x 1       (optional) epsilon for the diffusivity function
%           p               1 x 1       (optional) p of the diffusivity function:
%                                       p=0 corresponds to homogeneous diffusion ~ gaussian smoothing
%                                       0<p<1 corresponds to forward diffusion
%                                       p=1 (default) corresponds to TV flow 
%                                       p>1 corresponds to backward diffusion (edge enhancing flow)
%                                       p = 2 corresponds to the balanced forward-backward diffusion
%           T               1 x 1       (optional) diffusion time; number of iterations
%           theta           1 x 1       (optional) the threshold on the average total variation as a stopping criterion
%           sigma           1 x 1       (optional) sigma for the gaussian used for regularization. 
%                                       use sigma = 0 for no regularization
%           fig_handle      h           (optional) figure handle, if passed empty (fig_handle = []); does not draw anything, otherwise
%                                       draws the evolving function in a new figure(if nothing is passed for fig_handle) or in the 
%										fig_handle 's figure
% outputs:
%           U               n x m x dxw the filtered image
%           minv            n x m       (optional) average speed of pixels' evolution. 
%           SS              {}          (optional) if requested, is the scale space of the diffused image(cell array of 
%                                       the diffused image at each time step)
% Note: 
% - this implementation uses two point, one sided differences which is more accurate(and also slower) than 3 point central differences
% - use smaller tau for more accurate approximations. reasonable values for tau are approximately between 1 and 10
% - avoid using theta(set to 0) if you want exact number of iterations (e.g. a scale space pyramid of fixed length)
% - use regularization for tradeoffs between accuracy and speed. a rasonable range for sigma is approximately between 0.5 and 1. avoid
%   regularization if high accuracy is needed.
% - the average speed of pixels' evolution can be used as the scale of textures in a discriminative texture feature space (see references)
% for more information, refer to dr Thomas Brox's PhD thesis and publications(e.g. Rousson et Al, CVPR 2003 and Brox et al ECCV 2004)
% 
% Author: Omid Aghazadeh, Royal Institute of Technology (KTH), 2010/05/18
function [U,minv,SS] = Nonlinear_Diffusion(U_0,tau,eps,p,T, theta,sigma, fig_handle)
if nargin<8; fig_handle = figure; end;
if nargin<7; sigma = 0.5; end;
if nargin<6; theta = 5; end;
if nargin<5; T = 20; end;
if nargin<4; p = 1; end; % TV flow
if nargin<3; eps = 1e-3; end;
if nargin<2; tau = 5; end;

[sy sx d w] = size(U_0);
eps2 = eps^2;
N = sy * sx; % number of pixels in each channel
ixx = zeros(1,5*N);

% constructing matrices ixy and ixx so that:
% (ixx(x,i) is the neighbor of ixy(x,i) (and therefore the neighbor of xth pixel) in direction i,
% where i=0 corresponding to the pixel itself, i=1: top pixel, i=2: left, i=3: right and i=4: bottom
% ixx and ixy are reshaped into one dimension. they are indicies for each channel separately.
ax = (1:N);
ixy = repmat(ax,1,5); % ys {self, top, left, right, bottom}
ixx(1:N) = ax;
ixx((N+1):(2*N)) = ax -1 ;
ixx((2*N+1):3*N) = ax -sy ;
ixx((3*N+1):4*N) = ax +sy ;
ixx((4*N+1):5*N) = ax +1 ;

IX_B.left = 1:sy;
IX_B.right = N-sy+1:N;
IX_B.top = 1:sy:N;
IX_B.bottom = sy:sy:N;

t_ix = ax; % marking pixels at boundaries to avoid losing mass and also the computation of gradient at boundaris
t_ix(IX_B.left) = 0; 
t_ix(IX_B.right) = 0;
t_ix(IX_B.top) = 0;
t_ix(IX_B.bottom) = 0;
ix_v = t_ix(t_ix~=0); % indecies of the pixels NOT being at the boundaries
ix_ch_lr = reshape(reshape(ax,[sy sx])',[1 sy*sx]); % computing the transformation in indicies using which the tri-diagonal matrix AA can be constructed for left and right indicies.

U = U_0(:);
su0 = sum(abs(U_0(:)));
if nargout > 2; SS = {double(U_0)}; end;
int_pd_norm = zeros(1,N); % summation of absolute value of the change in pixels intensities
int_pd_e1 = zeros(1,N); % summation of the timesteps where pixels changed their values

IX_N.ix_i_jm1 = ix_v -1 ; % indicies of the neighboring pixels (i+ki,j+kj); could also use the ixx matrix, but this one should be faster
IX_N.ix_i_j = ix_v ;
IX_N.ix_i_jp1 = ix_v + 1;
IX_N.ix_ip1_jm1 = ix_v + sy - 1;
IX_N.ix_ip1_j = ix_v + sy;
IX_N.ix_ip1_jp1 = ix_v + sy + 1;
IX_N.ix_im1_jm1 = ix_v - sy - 1;
IX_N.ix_im1_j = ix_v - sy ;
IX_N.ix_im1_jp1 = ix_v - sy + 1;

plot_U(U_0,sy,sx,d,w,0,T,fig_handle,theta,N);
if sigma>0
    fl = 2*ceil(2*sigma)+1;
    f_reg = fspecial('gaussian',[fl fl],sigma); % regularizing gaussian filter
end
for i = 1 : T
    g_arg_sq = inf * ones(d,w,5*N);

    PU = U;
    for tw = 1 : w
        for td = 1 : d
            ixstart = (td-1)*N + (tw-1)*d*N;
            tu = U((ixstart+1):(ixstart+N));
            tu(IX_B.left) = tu(IX_B.left+sy); % manually changing the pixels at boundaries to look like their neighbors!
            tu(IX_B.right) = tu(IX_B.right-sy);
            tu(IX_B.top) = tu(IX_B.top+1);
            tu(IX_B.bottom) = tu(IX_B.bottom-1);
            U((ixstart+1):(ixstart+N)) = tu;
            if sigma>0 % regularization
                 tu = reshape(filter2(f_reg,reshape(tu,[sy sx]),'same'),N,1); % gaussian regularization only affects the diffusivities and not the U itself
            end
            g_arg_sq(td,tw,:) =discretize(tu,IX_N,N,ix_v); % discretization of separate channels. g_arg_sq is the argument of the diffusivity g(|\nabla u|^2)
        end
    end
    
    [U] = solve_semi_implicit_scheme(U,g_arg_sq,ix_v,N,d,w,ax,tau,p,eps2,ixx,ixy,ix_ch_lr);
    
    if nargout>2; SS{end+1} = reshape(U,size(U_0)); end;
    
    a_pd_u_pd_t = reshape(mean(mean(abs(reshape(U,size(U_0)) - reshape(PU,size(U_0))),3),4),1,N);
    int_pd_norm = int_pd_norm + a_pd_u_pd_t; % numerator of the inverse scale feature, see (4.8) in dr Brox's PhD thesis
    int_pd_e1 = int_pd_e1 + double(a_pd_u_pd_t ==0);  % denumerator of the inverse scale feature
    AVG_TV = plot_U(U,sy,sx,d,w,i,T,fig_handle,theta,N); % average total variation
    U = U * su0/sum(abs(U(:))); % avoiding any mass change!
    if AVG_TV < theta, break, end   
end
U = reshape(U,size(U_0));
if nargout> 1
    minv = int_pd_norm./(4)./(T - int_pd_e1 +eps);
    minv = reshape(minv,sy,sx);
%     invsc = sum(minv(:)>1);
%     if invsc; display(sprintf('warning, %d pixels had scale less than 1 pixel!',invsc)); end;
end
end

function val = g(mag2,eps2,p)
    val = 1./(mag2 + eps2).^(p/2);
end


% constructs the sparse matrix A, and solves the equation (I-D \tau A)u^{k+1} = u^{k} in 1D
% for u^{k+1} where A is tri-diagonal. A\B is efficiently computed in case of A being tri-diagonal. 
% the mex function is utilized to achieve the fastest speed. 
% Note that in case of left and right neighbors of pixels, the constructed matrix A will not be tri-diagonal and
% and will be located on the "sy"th diagonals instead of the first. using the transformation in indicies ix_ch_lr, both
% U and AA are transformed such that the resulting AA is tri-diagonal in case of left-right neighborhoods.
% page 20-21 of dr Brox's PhD thesis. 
function U = solve_tridiagonal(U,gs,ix,ixn1,ixn2,ixy,ixx,N,ax,tau,D,ix_ch_lr)
val_ix = [ix ixn1 ixn2];
ixy_v = ixy(val_ix);
ixx_v = ixx(val_ix);
g_v = [-(gs(ixn1) + gs(ixn2)); gs(ixn1); gs(ixn2)];

A = sparse(ixy_v,ixx_v,g_v,N,N,length(val_ix));
AA = sparse(ax,ax,ones(size(ax)),N,N,N) - D*tau * A;

OU = U;
if exist('ix_ch_lr','var')
    U = U(ix_ch_lr);
    AA = AA(ix_ch_lr,ix_ch_lr);  
end 

if ~is_tridiagonal(AA), error('invalid matrix'); end

b = full(diag(AA)); c = full(diag(AA,1)); a = full(diag(AA,-1));
U = thomas_mex(b,c,a,U)';

if exist('ix_ch_lr','var'), U(ix_ch_lr) = U; end;

ixch = OU ~= U;
soldixch = sum(abs(OU(ixch)));
snewixch = sum(abs(U(ixch)));
U(ixch) = U(ixch) * soldixch/snewixch; % avoiding mass loss/gain by re-scaling the answer
end


% discretizes the pdes with respect to space using one sided two pixel differences.
% page 15,16 of dr Brox's PhD thesis
function g_arg_sq = discretize(U,IX_N,N,ix_v)
g_arg_sq = zeros(1,5*N);

g_arg_sq(N+ix_v) = (U(IX_N.ix_i_j) - U(IX_N.ix_i_jm1)).^2 + 1/16*(U(IX_N.ix_ip1_jm1) - U(IX_N.ix_im1_jm1) + U(IX_N.ix_ip1_j) - U(IX_N.ix_im1_j)).^2; % (2.16) 4 

g_arg_sq(2*N+ix_v) = (U(IX_N.ix_i_j) - U(IX_N.ix_im1_j)).^2 + 1/16*(U(IX_N.ix_im1_jp1) - U(IX_N.ix_im1_jm1) + U(IX_N.ix_i_jp1) - U(IX_N.ix_i_jm1)).^2; % (2.16) 2

g_arg_sq(3*N+ix_v) = (U(IX_N.ix_ip1_j) - U(IX_N.ix_i_j)).^2 + 1/16*(U(IX_N.ix_ip1_jp1) - U(IX_N.ix_ip1_jm1) + U(IX_N.ix_i_jp1) - U(IX_N.ix_i_jm1)).^2; % (2.16) 1

g_arg_sq(4*N+ix_v) = (U(IX_N.ix_i_jp1) - U(IX_N.ix_i_j)).^2 + 1/16*(U(IX_N.ix_ip1_jp1) - U(IX_N.ix_im1_jp1) + U(IX_N.ix_ip1_j) - U(IX_N.ix_im1_j)).^2; % (2.16) 3
end

% semi implicitly discretizes the pdes with respect to time
% page 20 of dr Brox's PhD thesis
function [U] = solve_semi_implicit_scheme(U,g_arg_sq,ix_v,N,D,W,ax,tau,p,eps2,ixx,ixy,ix_ch_lr)
gs = squeeze(g(sum(sum(g_arg_sq,1),2),eps2,p));

for tw = 1 : W
    for td = 1 : D
        ixstart = (td-1)*N + (tw-1)*D*N ;

        U_bt = solve_tridiagonal(U((ixstart+1):(ixstart+N)),gs,ix_v,ix_v+N,ix_v+4*N,ixy,ixx,N,ax,tau,2); % top and bottom 
        U_lr = solve_tridiagonal(U((ixstart+1):(ixstart+N)),gs,ix_v,ix_v+2*N,ix_v+3*N,ixy,ixx,N,ax,tau,2,ix_ch_lr); % left and right
        U((ixstart+1):(ixstart+N)) = (U_bt + U_lr)/2;       

    end
end
end

% is used to plot the evolving function(field)
function AVG_TV = plot_U(U,sy,sx,d,w,t,T,fig_handle,theta,N)
[TV,AVG_TV] = calc_TV(U,sy,sx,N,w,d);
if isempty(fig_handle), return, end;
figure(fig_handle);
U = reshape(U(:),[sy sx d w]);
if w*d == 1 || w*d == 3
    if w*d == 3
%         U = U/255; 
        U = (U-min(U(:)))/(max(U(:)) - min(U(:))); 
    end
    imagesc(U);
    if d==1,colormap(gray);end
else
    s = ceil(sqrt(w*d));
    for td = 1 : d
        for tw = 1 : w
            dim = (tw-1)*d+td;
            subplot(s,s,dim);
            imagesc(U(:,:,td,tw)); colormap gray;
        end
    end
end
title(sprintf('It %d(%d), avgtv=%0.1f, theta=%0.1f',t,T,AVG_TV,theta));
drawnow;
end

% computes the total variation of the evolving image. used for automatic stopping criterion.
function [TV,AVG_TV] = calc_TV(U,sy,sx,N,w,d)
stv = zeros(sy,sx);
for tw = 1 : w
    for td = 1 : d
        ixstart = (td-1)*N + (tw-1)*d*N;
        ttu = reshape(U((ixstart+1):(ixstart+N)),[sy sx]);
        [ttux ttuy] = gradient(ttu);
        ttugm = sqrt(ttux.^2 + ttuy.^2);
        stv = stv + ttugm;
    end
end 
TV = sum(stv(:));
AVG_TV = mean(stv(:))/w/d;
end

% checks if matrix AA is exactly tri-diagonal
function res=is_tridiagonal(AA)
res = full(sum(sum((AA + tril(triu(AA)) - (triu(AA) - triu(AA,2)) - (tril(AA) - tril(AA,-2))) ~=0))) == 0;
end
% function F = discriminative_texture_feature(I_TEXT,theta,verbose,colored,include_intensity,scale)
% computes the discriminative texture feature presented in Thomas Brox's PhD thesis and also in several
% CVPR and ECCV papers e.g. 
% M. Rousson, T. Brox, and R. Deriche. Active unsupervised texture segmentation on a diffusion
%  based feature space, CVPR, 2003
% Thomas Brox and Joachim Weickert, A TV Flow Based Local Scale Measure for Texture Discrimination,
%  ECCV, 2004 (in this work, they utilized TV regularization instead of TV flow)
% Here, instead, as suggested in Brox's PhD thesis, edge enhancing flow is utilized to smooth the entire
% feature vector instead of TV flow. The feature vector consists of:
%   - 1 dimension for texture scale
%   - 3 dimensions for texture orientation and stength
%   - 1 optional dimension for pixel intensity
% if case of color texture representation, the dimension of the feature vector is increased to 3 x 5 = 15
% Inputs:
%       I_TEXT              M x N x d   a colored or a gray scaled value image to extract the texture from
%       theta               1 x 1       (optional) a stopping criterion: a threshold on the average total variation
%                                       of the feature vector.
%       verbose             []          (optional) an array including 1 or 2 or both to depict the diffusion process
%                                       for texture scale(verbose=1) and texture feature vector (verbose =2). To avoid any output
%                                       use verbose = []
%       colored             1 x 1       (optional) determines if a colored texture feature vector should be computed
%       include_intensity   1 x 1       (optional) determines if the pixel instensity should be added to the feature vector
%       tau_diff            1 x 1       (optional) time step size parameter of nonlinear diffusion of feature vector
%       steps_diff          1 x 1       (optional) diffusion time of nonlinear diffusion of feature vector
%       sigma_diff          1 x 1       (optional) sigma for gaussian regularization of nonlinear diffusion of feature vector
% Outputs:
%       F                   D x (M*N)   the computed feature vector of either 5 or 15 dimensions
% 
% Note:
% - It is possible to augment the 5 dimensional feature vector by a 3 dimensional color feature vector to reduce the 15 dimensions
%   to 8 dimensions if you are worried about the curse of dimensionality
% - pixel intensity is required to smooth the feature vector and "fill in" the empty feature vector where no gradient is present
%   one can remove the dimension corresponding to pixel intensity AFTER the nonlinear coupled diffusion
% - the parameters for the computation of the texture scale are chosen similar to the mentioned references
% - the parameters for the coupled nonlinear diffusion of the feature vector are slightly modified to speed up the diffusion process
%   use smaller time step sizes and avoid gaussian regularization for more accurate diffusion with cost of much more computation time
%   see Nonlinear_Diffusion.m for the exact definition of its parameters.
% 
% Author: Omid Aghazadeh, Royal Institute of Technology(KTH), 2010/05/15
function F = discriminative_texture_feature(I_TEXT,theta,verbose,colored,include_intensity,tau_diff,steps_diff,sigma_diff)
if nargin<2; theta = 6; end; if nargin<3, verbose = [1 2]; end; if nargin<4, colored= 0; end; if nargin<5, include_intensity = 1; end;
if nargin<6, tau_diff = 5; end; if nargin<7, steps_diff = 100; end, if nargin<8, sigma_diff = 0.5; end;
tic; fprintf('computing texture feature... ');
[sy sx d] = size(I_TEXT);
if d > 1 && colored
    F0 = [];
    for i = 1 : d
        F0 = cat(3,F0,get_texture_feature_one_channel(I_TEXT(:,:,i),include_intensity,verbose));  
        if sum(verbose==1),title(sprintf('texture scale for channel %d',i));end
    end
else
    if d>1,I_TEXT = double(rgb2gray(uint8(I_TEXT)));  end
    F0 = get_texture_feature_one_channel(I_TEXT,include_intensity,verbose); 
    if sum(verbose==1),title('texture scale');end
end
if sum(verbose ==2), fig_hand = figure; set(fig_hand,'Name','Texture Feature Vector Diffusion'); else fig_hand = []; end;
FNLS = Nonlinear_Diffusion(F0,tau_diff,1e-3,1.5,steps_diff,theta,sigma_diff,fig_hand);
F = [];
for i = 1 : size(FNLS,3)
    F = cat(1,F,reshape(FNLS(:,:,i),1,sy*sx));
end
fprintf('%f seconds\n',toc);
end

function [F0] = get_texture_feature_one_channel(I,include_intensity,verbose)
I_x = filter2([-1 0 1],I,'same');
I_y = filter2([-1 0 1]',I,'same');
Igm = sqrt(I_x.^2 + I_y.^2) + eps;
if sum(verbose ==1), fig_hand = figure; set(fig_hand,'Name','Texture Scale Evolution'); else fig_hand = []; end;
[U,minv] = Nonlinear_Diffusion(I,1,1e-3,1,20,0,0,fig_hand); 
F0 = cat(3,I_x.^2./Igm,I_y.^2./Igm,I_x.*I_y./Igm,minv*max(I(:)));
if include_intensity, F0 = cat(3,I,F0); end
end
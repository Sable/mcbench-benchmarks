function C = ContCode(I,k,varargin)
% ContCode Compute the Multidirectional Feature Encoding (Contour Code Representation) of an Image
% USAGE:
% 1. C = ContCode(I,k)
% 2. C = ContCode(I,k,D_f,P_f)
% INPUTS:
%
% I--------------> Input Image
% k--------------> Order of Directional Filters (k>=2)
% D_f(Optional)--> Name of the Directional Filter (Refer to NSCT Toolbox, Default: 'sinc')
% P_f(Optional)--> Name of the Pyramidal Filter (Refer to NSCT Toolbox, Default: 'pyrexc')
%
% OUTPUTS:
%
% C----> Contour Code Representation of 'I'
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Please cite the following paper in all works using this code.
% Zohaib Khan, Ajmal Mian and Yiqun Hu, "Contour Code: Robust and efficient multispectral palmprint encoding for human recognition," Computer Vision (ICCV), 2011 IEEE International Conference on , vol., no., pp.1935-1942, 6-13 Nov. 2011%
% IMPORTANT NOTE:
%
% This function requires 'NSCT Toolbox', installed before use.
% Downloadable from:
% http://www.mathworks.com/matlabcentral/fileexchange/10049
% (Please refer to the Readme.txt of the NSCT toolbox to make it working)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

optargin = size(varargin,2);
stdargin = nargin - optargin;
if (nargin==stdargin) % Use Default Filters
    D_f = 'sinc';
    P_f = 'pyrexc';
elseif(nargin==stdargin+2) % Use Specified Filters
    D_f = varargin{1};
    P_f = varargin{2};
end

n_orient = 2^k; % No. of Orientations
orients = 1:n_orient; % Vector of all Orientations
orient_order = [fliplr(orients(1:n_orient/4)) orients(n_orient/2+1: n_orient) fliplr(orients(n_orient/4+1:n_orient/2))]; % Order of Orientations w.r.t. NSCT subbands

coeffs = nsctdec(double(I), k, D_f, P_f); % NSCT Decomposition

ordered_coeffs = zeros(numel(I),n_orient);
for i = 1:n_orient % Reordering the Coefficients according to 'orient_order'
    ordered_coeffs(:,i) = coeffs{2}{orient_order(i)}(:);
end

[~,C] = min(ordered_coeffs,[],2); % Index of Subband Corresponding to Minimum Peak repsonse
C = reshape(C,size(I)); % Reshaping to Original Image size
end
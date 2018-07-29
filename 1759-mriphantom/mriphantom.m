function Sk = mriphantom(kx,ky)
%========================================================================
% Sk = function mriphantom(kx,ky)
% 
% Creates simulated raw MRI data of a Shepp Logan head phantom 
% for given k space points
% input is the kx and ky coordinates in the image frequency space
% default values for kx and ky are for a Carthesian sampling.
% Input 
%   kx, ky  Matrices with kx and ky sampling coordinates
%   E       Optional analytical phantom data matrix as produced by 
%           image toolbox function phantom.m (see comments below).
% Data are from an analytical expression for a continuous phantom.
% Core equations for this are taken form :
%  Rik van der Walle et al IEEE Trans Med Imag 19(12) p1160.
%
% Note that the standard matlab function just gives the phantom 
% sampled in image space on a carthesian grid. 
% This function delivers the simulated raw MRI data sampled through 
% a user defined path in k-space (image frequency space)
%
% Author : Ronald Ouwekerk Johns Hopkins University Dept. Radiology
% 601 N. Caroline Street Room 4250 Baltimore, MD 21287-0845 USA
% rouwerke@mri.jhu.edu
% Written :May 2002 
% Modified June 2002 :  Revised to give a non-NaN result for k=0
%                       Suppress output if nargout == 0
%                       Added comments to explain the difference with phantom.m
%
% Whenever this software is used for publications an acknowledgment 
% would be much appreciated. 
%                           RO
%========================================================================
FOV = 2;    
N = 64;

if nargin < 2
    %=====================================================================
    % Set the field of view to 24 cm (see image toolbox phantom.m)
    % resolution 128x128 points
    % create k-space coordinates for Carthesion sampling 
    % Should be equivalent to IFFT of the phantom
    %=====================================================================
    FOV = 0.24;
    res = FOV/N;
    Kmax = 1/(2*res);
    ky = linspace(-Kmax,Kmax, N);
    ky = ky(ones(N,1),:);
    kx = permute(ky, [2,1]);
end;
if ( (nargin < 3 ) | isempty(E) )  & (exist('phantom.m')==2)
    %========================================================================
    % Create 2D phantom to get defining matrix E
    %========================================================================
    [P,E] = phantom;
elseif ~(exist('phantom.m')==2)
    P = [];
    E = modified_shepp_logan;
end;

%========================================================================
% copy the elements of E and scale to field of view 
% Matlab phantom.m default yields FOV =[-1,1]= 2
% Scale all dimensions to desired FOV (*FOV/2).
%   Column 1:  rho  the additive intensity value of the ellipse
%   Column 2:  a    the length of the horizontal semi-axis of the ellipse 
%   Column 3:  b    the length of the vertical semi-axis of the ellipse
%   Column 4:  x0   the x-coordinate of the center of the ellipse
%   Column 5:  y0   the y-coordinate of the center of the ellipse
%   Column 6:  alpha  the angle (in degrees) between the horizontal semi-axis 
%                   of the ellipse and the x-axis of the image   
%========================================================================
[me,ne] = size(E);
rho = E(:,1)';  
nellipses = length(rho);
a   = FOV/2 * E(:,2)';
b   = FOV/2 * E(:,3)';
x0  = FOV/2 * E(:,4)';
y0  = FOV/2 * E(:,5)';
alpha = pi*E(:,6)'/180;


%========================================================================
% Stretch kspace coordinates to column vector (retain original size info)
%========================================================================
[mk,nk] = size(kx);
kx = kx(:);
ky = ky(:);
k = kx + j*ky;
klen = length(kx);

%========================================================================
% Calculate angle of the vector to the ellipse center in real space.
%========================================================================
gamma = atan2(y0, x0);
te = sqrt(x0.^2 + y0.^2);

%========================================================================
% Replicate all the ellipse defining vectors to the number of k space values
%========================================================================
gamma = gamma(ones(klen,1),:);
te = te(ones(klen,1),:);
alpha = alpha(ones(klen,1),:);
rho = rho(ones(klen,1),:);
a = a(ones(klen,1),:);
b = b(ones(klen,1),:);

%========================================================================
% Calculate k space vectors angle and magnitude
%========================================================================
kphi = angle(k);
kr = abs(k);

%========================================================================
% Replicate k space and time vectors to the number of ellipses
%========================================================================
kr = kr(:,ones(1,nellipses));
kphi = kphi(:,ones(1,nellipses));

%========================================================================
% Precalculate some values 
%========================================================================
pi2 = 2*pi;
cose = cos(gamma - kphi);

%========================================================================
% Projection angles:
% Difference of the k space vector angle and the angles of the ellipses
%========================================================================
sind = sin(kphi - alpha);
cosd = cos(kphi - alpha);

akphi = sqrt(a.^2 .* cosd.^2 + b.^2 .* sind.^2);
%========================================================================
% Calculate the signals for each ellips and each k space point kx,ky
% avoid division by zero    besselj(1,0) = 0 so set 0/0 = 1
%========================================================================
knz = (akphi.*kr ~=0);
bess = ones(size(akphi.*kr));
bess(knz) = besselj(1,pi2.*akphi(knz).*kr(knz)) ./(akphi(knz).*kr(knz));
Sk = exp(-j*pi2.*kr.*te.*cose) .*rho.*a.*b.* bess;
%========================================================================
% Sum the signals for all ellipses and reshape the data back to 
% the matrix size of the kx and ky input data
%========================================================================
Sk = sum(Sk,2);
Sk = reshape(Sk, mk,nk);
%========================================================================
% Show the result, including the reconstruction if default Carthesian 
% sampling was used
%========================================================================
if  nargin >= 2
    fh = figure;
    subplot(1,2,1);
    if ~isempty(P)
        imagesc(abs(P));
    end;    
    title('Software head phantom')
    axis image
    
    subplot(1,2,2);
    imagesc(abs(Sk));
    title('Simulated raw data')
    return
else
    fh = figure;
    subplot(1,3,1);
    if ~isempty(P)
        imagesc(abs(P));
    end;
    axis image

    subplot(1,3,2);
    imagesc(abs(Sk));    
    title('Simulated raw data')
    axis image

    subplot(1,3,3);
    I = fftshift(fft2(Sk));
    imagesc(abs(I));
    axis image    
    title('2DFFT Reconstructed image')
end;
%========================================================================
% Suppress output if not asked for any
%========================================================================
if nargout < 1
    Sk = [];
end;


%========================================================================
% END
%========================================================================

%========================================================================
% local function Copied from function phantom.m 
% to produce a result without the image toolbox
%========================================================================

%========================================================================
function toft=modified_shepp_logan
%
%   This head phantom is the same as the Shepp-Logan except 
%   the intensities are changed to yield higher contrast in
%   the image.  Taken from Toft, 199-200.
%      
%         A    a     b    x0    y0    phi
%        ---------------------------------
toft = [  1   .69   .92    0     0     0   
        -.8  .6624 .8740   0  -.0184   0
        -.2  .1100 .3100  .22    0    -18
        -.2  .1600 .4100 -.22    0     18
         .1  .2100 .2500   0    .35    0
         .1  .0460 .0460   0    .1     0
         .1  .0460 .0460   0   -.1     0
         .1  .0460 .0230 -.08  -.605   0 
         .1  .0230 .0230   0   -.606   0
         .1  .0230 .0460  .06  -.605   0   ];
%========================================================================
% end local function toft=modified_shepp_logan
%========================================================================

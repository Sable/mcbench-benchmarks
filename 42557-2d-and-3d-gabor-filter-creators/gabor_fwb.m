function varargout=gabor_fwb(aspect,theta,bw,psi,sigma,sz)
% Returns 2D or 3D gabor filter.
% gb=GABOR_FWB(aspect,theta,bw,psi,sigma,sz)
%
% aspect = aspect ratio (ratio of x to y), (eg: 0.5, for major < minor axis)
% theta  = angle in rad of major axis, (0-2*pi) 
% bw     = spatial bandwidth in pixels (decreasing fine detail,), (eg: >=1)
%               scales the frequency of the cosine modulation
% psi    = phase shift, [optional, default: 0] 
% sigma  = scales the falloff of the gaussian, (must be >=2) [default: = bw]
%              + can set to 'auto' to maintain default functionality
% sz     = size of gabor kernel created  [optional, size set automatically 
%           to 3 standard deviations of gaussian kernel]
        
% handle optional inputs
if nargin<4
    psi = 0;
end
if nargin<5
    sigma = 'auto';
end
% allow 'auto' sizing of guassian kernel
if strcmp(sigma,'auto');
    sigma = bw;
end
if nargin<6
    % figure out size
    len1 = 3*sigma; % length along theta direction
    len2 = len1/aspect;
    sz(1) = round(len1*cos(theta)+len2*sin(theta)); % column/x dimension
    sz(2) = round(len1*sin(theta)+len2*cos(theta)); % row/y direction
end
% allow just one number to be given for size
if length(sz)<2;
    sz(2) = sz(1);
end
sx = sz(2);
sy = sz(1);

% figured out size above, now make matrix of points
[x y]=meshgrid(-sy:sy,sx:-1:-sx);

% rotate reference frame to point in theta direction
xp = x*cos(theta)+y*sin(theta);
yp = -x*sin(theta)+y*cos(theta);

% create gaussian pointing in theta direction with size determined by
%   aspect ration
sigmajor = sigma;
sigminor = sigma/aspect;
h1 = exp(-(xp.^2/sigmajor^2+yp.^2/sigminor^2));

% multiply by cosine with appropriate bw
F=1/bw;  % Frequency
h2 = cos(2*pi*(F*xp)+psi);

g = h1.*h2;

if nargout>0
    varargout{1} = g;
end
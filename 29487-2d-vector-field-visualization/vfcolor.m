function img = vfcolor(varargin)

% VFCOLOR  Displays a 2d vector field in false color.
%
% With no arguments, shows the color coding.
%  Red Orange Yellow LGreen DGreen Cyan Blue Violet
%  = E NE N NW W SW S SE (assuming N and E are positive)
%
% Usage:
%   img = vfcolor(f ,maxd)   % f complex or MxNx2
%   img = vfcolor(fx,fy ,maxd)  % separate f components
%
% See also QUIVER, CQUIVER

if (nargin == 0)
    % show disk
    side = 27;
    [xf,yf] = meshgrid(ceil(-side/2:side/2),ceil(-side/2:side/2));
    corners = find(sqrt(xf.^2+yf.^2) >= side/2);
    xf(corners) = 0;
    yf(corners) = 0;
elseif (size(varargin{1},3)==2)
    % two f planes
    xf = varargin{1}(:,:,1);
    yf = varargin{1}(:,:,2);
    if (nargin > 1)
        maxs = varargin{2};
    end;
elseif (nargin >= 2)&(all(size(varargin{1}) == size(varargin{2})))
    % two f arguments
    xf = varargin{1};
    yf = varargin{2};
    if (nargin > 2)
        maxs = varargin{3};
    end;
else
    % complex f
    xf = full(real(varargin{1}));
    yf = full(imag(varargin{1}));
    if (nargin > 1)
        maxs = varargin{2};
    end;
end;

if exist('maxs','var')&imag(maxs)
    maxs = abs(maxs);
end;

% compute f image in correct colors
[nrow,ncol] = size(xf);
h = mod(8*(atan2(yf,xf)/(2*pi)),8);
%h1 = floor(h)+1;
h2 = mod(ceil(h),8)+1;
h1 = mod(h2-2,8)+1;
hr = ceil(h)-h;
s = sqrt(xf.^2+yf.^2);
if exist('maxs','var')
    s = s./(maxs+eps);
else
    s = s./(max(s(:))+eps);
end;
c = reshape([1 0 0; 1 0.5 0; 1 1 0; 0 1 0; 0 0.6 0; 0 1 1; 0 0 1; 1 0 1],8,1,3);
img1 = zeros(nrow,ncol,3);
img1(:) = c(h1,1,:);
img2 = zeros(nrow,ncol,3);
img2(:) = c(h2,1,:);
rhr = repmat(hr,[1,1,3]);
img = rhr.*img1+(1-rhr).*img2;
rs = repmat(s,[1,1,3]);
%img = rs.*img+0.8*(1-rs);
img = rs.*img+(1-rs);
imagesc(img);  % display
axis xy equal tight

if (nargin == 0)
    axis('xy');
    set(gca,'XTick',[],'YTick',[]);
    text(0.5,14,'Neg','Rotation',90,'VerticalAlignment','bottom','HorizontalAlignment','center');
    text(27.5,14,'Pos','Rotation',-90,'VerticalAlignment','bottom','HorizontalAlignment','center');
    text(14,0.5,'Neg','VerticalAlignment','top','HorizontalAlignment','center');
    text(14,27.5,'Pos','VerticalAlignment','bottom','HorizontalAlignment','center');
    %set(gca,'XTick',[0.5 14 27.5],'YTick',[0.5 14 27.5],'XTickLabel',{'-max','0','+max'},'YTickLabel',{'-max','0','+max'});
end;

if (nargout == 0)
    clear img;
end;
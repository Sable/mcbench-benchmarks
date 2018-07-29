function cquiver(varargin)

% CQUIVER  Display 2D vector field as equal length arrow grid
%
% Displays a 2d vector field using an equal-length arrow grid and colors 
% to indicate magnitude.  Colors are taken from the current colormap.
% For grayscale, try colormap(flipud(gray)).
%
% Usage:
%   img = cquiver(flow ,maxd)   % flow complex or MxNx2
%   img = cquiver(fx,fy ,maxd)  % separate flow components
% 
% Portions based on ncquiverref by Andrew Roberts
% See license.txt for details
%
% See also QUIVER, VFCOLOR

if (size(varargin{1},3)==2)
    % two flow planes
    u = varargin{1}(:,:,1);
    v = varargin{1}(:,:,2);
    if (nargin > 1)
        maxd = varargin{2};
    end;
elseif (nargin >= 2)&(all(size(varargin{1}) == size(varargin{2})))
    % two flow arguments
    u = varargin{1};
    v = varargin{2};
    if (nargin > 2)
        maxd = varargin{3};
    end;
else
    % complex flow
    u = full(real(varargin{1}));
    v = full(imag(varargin{1}));
    if (nargin > 1)
        maxd = varargin{2};
    end;
end;

[th,z] = cart2pol(u,v);

if exist('maxd','var')&imag(maxd)
    maxd = abs(maxd);
else
    maxd = sqrt(max(u(:).^2+v(:).^2));
end;

cmap = colormap;
nclr = size(cmap,1);
cont = linspace(0,maxd,nclr+1);
cont(1) = [];

[nrow,ncol] = size(z);
[x,y] = meshgrid(1:ncol,1:nrow);
arrow=0.40;
scalelength = 1;
for i=1:length(cont)

  if i==1
   mask=find(z<cont(i));
  elseif i==length(cont)
   mask=find(z>=cont(i-1));
  else
   mask=find(z<cont(i) & z>=cont(i-1));
  end
  mask = mask';

  % Center vectors over grid points
  [u,v] = pol2cart(th(mask),scalelength);
  xstart=x(mask)-0.5*u;
  xend=x(mask)+0.5*u;
  ystart=y(mask)-0.5*v;
  yend=y(mask)+0.5*v;

  % Get x coordinates of each vector plotted
  lx = [xstart; ...
       xstart+(1-arrow/3)*(xend-xstart); ...
       xend-arrow*(u+arrow*v); ...
       xend; ...
       xend-arrow*(u-arrow*v); ...
       xstart+(1-arrow/3)*(xend-xstart); ...
       nan(size(xstart))];

  % Get y coordinates of each vector plotted
  ly = [ystart; ...
       ystart+(1-arrow/3)*(yend-ystart); ...
       yend-arrow*(v-arrow*u); ...
       yend; ...
       yend-arrow*(v+arrow*u); ...
       ystart+(1-arrow/3)*(yend-ystart); ...
       nan(size(ystart))];

  % Plot the vectors
  line(lx,ly,'Color',cmap(i,:));

end

axis equal tight
set(gca,'CLim',[0 maxd]); %,'XLim',[-.5 ncol+.5],'YLim',[-.5 nrow+.5]);
%colorbar;

function main(varargin)
%GUI for viewing the Mandelbrot and the monic quadratic Julia sets.
%
%   MAIN ('PropertyName',PropertyValue,...)
%
%   List of properties
%   FractalType
%      {'mandelbrot','julia'}  default 'mandelbrot'
%      Choose between the Mandelbrot or the monic quadratic Julia set
%   JuliaConstant
%      any complex value       default 0.285+0.01i
%      This is the constant 'c' used for generating the monic quadratic
%      Julia set with
%      z_n+1 = z_n + c
%   MaxIter
%      positive value          default 256
%      The maximum number of iterations for determining if a certain point
%      has diverged or not
%   EscapeRadius
%      positive value          default 2.0
%      This is used to determine when a point has diverged
%   Width
%      positive value          default 400
%      Determines the number of datapoints to use width-wise
%   Height
%      positive value          default 400
%      Determines the number of datapoints to use height-wise
%   Subfunction
%      {'c','matlab'}          default 'c'
%      Type of fractal generator subfunction to use. Either the C or the
%      matlab versions.
%   XLim
%      2-element vector        default [-2,2]
%      The initial region boundaries
%   YLim
%      2-element vector        default [-2,2]
%      The initial region boundaries
%   ImageCacheSize
%      positive value          default 8
%      This program stores the previous ImageCacheSize-2 images. Must be at
%      least 2.
%   NonDivergingSetColor
%      1x3 matrix              default [0,0,0]
%      Color of the non-diverging points in RGB components. Must be between
%      0.0 and 1.0.
%   Colormap
%      function handle         default @hsv
%      Function for determining the colormap. For example, @hsv. The
%      function must have the form out=function(in) where in is the number
%      of colors in the colormap and out is an [in x 3] matrix giving the
%      RGB components of the colormap. The RGB values must be scaled
%      between 0.0 and 1.0.
%      
%   NumColor
%      positive value          default 255
%      Number of colors to use when coloring the diverging points.
%
%  This version is from October 28, 2010
%  October 28, 2010, fixed non-complex constant bug for makejulia_c.c
%  October 27, 2010, added inputparser and inhibited rotate3d
%  October 25, 2010, improved image cache and added more comments
%  October 23, 2010, first version
%  Written by Christopher Leung
%  christopher.leung@mail.mcgill.ca
%
%  In memory to Benoit Mandelbrot

% Parse input
p = inputParser;
p.addParamValue('FractalType', 'mandelbrot',...
    @(x)any(strcmpi(x,{'mandelbrot','m','julia','j'})));
p.addParamValue('JuliaConstant', 0.285+0.01i, @isnumeric);
p.addParamValue('MaxIter', 256, @(x)isnumeric(x)&&isreal(x)&&x>0);
p.addParamValue('EscapeRadius', 2, @(x)isnumeric(x)&&isreal(x)&&x>0);
p.addParamValue('Width', 400, @(x)isnumeric(x)&&isreal(x)&&x>0);
p.addParamValue('Height', 400, @(x)isnumeric(x)&&isreal(x)&&x>0);
p.addParamValue('Subfunction', 'c',...
    @(x)any(strcmpi(x,{'c','matlab','m'})));
p.addParamValue('XLim', [-2,2],...
    @(x)isnumeric(x)&&isreal(x)&&numel(x)>=2&&(x(2)-x(1))>0);
p.addParamValue('YLim', [-2,2],...
    @(x)isnumeric(x)&&isreal(x)&&numel(x)>=2&&(x(2)-x(1))>0);
p.addParamValue('ImageCacheSize', 8, @(x)isnumeric(x)&&isreal(x)&&x>2);
p.addParamValue('NonDivergingSetColor', [0,0,0],...
    @(x)isnumeric(x)&&isreal(x)&&all(x>=0)&&all(x<=1)&&size(x,1)==1);
p.addParamValue('Colormap', @hsv, @(x)isa(x,'function_handle'));
p.addParamValue('NumColor', 255, @(x)isnumeric(x)&&isreal(x)&&x>0);
p.parse(varargin{:});

% Colormap, windows has size constraint of 256
% Keep 1 slot for mandelbrot set points hence the 255
cm = [p.Results.NonDivergingSetColor(1:3); colormap(...
      p.Results.Colormap(min(p.Results.MaxIter,p.Results.NumColor)))];

% Determine if using C version or Matlab version for generating the fractal
if any(strcmpi(p.Results.Subfunction,{'c'}))
    if any(strcmpi(p.Results.FractalType,{'j','julia'}))
        if exist('makejulia_c','file') == 3
            hmakefractal = ...
                @(varargin)makejulia_c(varargin{:},p.Results.JuliaConstant);
        else
            warning('main:unknownfunction',...
                ['Must compile "makejulia_c.c" before using it. ',...
                'Reverted to matlab subfunction.']);
            hmakefractal = ...
                @(varargin)makejulia(varargin{:},p.Results.JuliaConstant);
        end
    else
        if exist('makemandel_c','file') == 3
            hmakefractal = @makemandel_c;
        else
            warning('main:unknownfunction',...
                ['Must compile "makemandel_c.c" before using it. ',...
                'Reverted to matlab subfunction.']);
            hmakefractal = @makemandel;
        end
    end
else
    if any(strcmpi(p.Results.FractalType,{'j','julia'}))
        hmakefractal = ...
            @(varargin)makejulia(varargin{:},p.Results.JuliaConstant);
    else
        hmakefractal = @makemandel;
    end
end

% Initialize figure
% Two axes, one for mandelbrot image, the other with initial limits to
% allow zooming and panning outside the image boundary
hfig = figure(1);
hax = zeros(2,1);
for k = 1:2
    hax(k) = axes(...
        'Parent', hfig,...
        'XLim', p.Results.XLim,...
        'YLim', p.Results.YLim,...
        'DataAspectRatio', [1 1 1],...
        'DataAspectRatioMode', 'manual',...
        'Box','on',...
        'XTick',[],...
        'YTick',[]);
end
set(hax(1),'Color',cm(2,:)); % bg color to 1 iteration for escape
set(hax(2),'Color','none');  % no color to these axes
xlabel(hax(1),[num2str(mean(p.Results.XLim),'%0.12f'),' \pm ',...
    num2str((p.Results.XLim(2)-p.Results.XLim(1))/2,'%0.12f')]);
ylabel(hax(1),[num2str(mean(p.Results.YLim),'%0.12f'),' \pm ',...
    num2str((p.Results.YLim(2)-p.Results.YLim(1))/2,'%0.12f')]);

% Display the image in hax(1) and let hax(2) be on top
% Have 'cache' versions of the image for better panning with himage(1)
% corresponding to the topmost image and himage(cache) is the background,
% i.e., the initial image. The other himage are previous generated image.
set(hfig,'CurrentAxes',hax(1));
[x,y] = meshgrid(...
    linspace(p.Results.XLim(1),p.Results.XLim(2),p.Results.Width),...
    linspace(p.Results.YLim(1),p.Results.YLim(2),p.Results.Height));
mu = hmakefractal(x,y,p.Results.EscapeRadius,p.Results.MaxIter);
CData = ones(size(mu));
CData(mu~=p.Results.MaxIter) = ...
    mod(mu(mu~=p.Results.MaxIter)-1,p.Results.NumColor)+2;
himage = zeros(p.Results.ImageCacheSize,1);
for k = p.Results.ImageCacheSize:-1:1
    if (k~=p.Results.ImageCacheSize)
        set(hax(1),'NextPlot','add');
    end
    himage(k) = image(...
        'XData',p.Results.XLim,...
        'YData',p.Results.YLim,...
        'CData',CData);
end
colormap(cm);

% Link the axes for automatic XLim and YLim resizing
linkaxes(hax,'xy');

% Anonymous function for generating and redrawing the fractal with 
% the new boundaries
redraw = @redrawmandel;
    function redrawmandel
        % Get new plot limits from the axes
        XLim = get(hax(1),'XLim');
        YLim = get(hax(1),'YLim');
        % Update labels
        xlabel(hax(1),[num2str(mean(XLim),'%0.12f'),' \pm ',...
            num2str((XLim(2)-XLim(1))/2,'%0.12f')]);
        ylabel(hax(1),[num2str(mean(YLim),'%0.12f'),' \pm ',...
            num2str((YLim(2)-YLim(1))/2,'%0.12f')]);
        % Generate new image
        [x,y] = meshgrid(...
            linspace(XLim(1),XLim(2),p.Results.Height),...
            linspace(YLim(1),YLim(2),p.Results.Width));
        mu = hmakefractal(x,y,p.Results.EscapeRadius,p.Results.MaxIter);
        CData = ones(size(mu));
        CData(mu~=p.Results.MaxIter) = ...
            mod(mu(mu~=p.Results.MaxIter)-1,p.Results.NumColor)+2;
        % Update image cache
        for m = p.Results.ImageCacheSize-1:-1:2
            set(himage(m),...
                'XData',get(himage(m-1),'XData'),...
                'YData',get(himage(m-1),'YData'),...
                'CData',get(himage(m-1),'CData'));
        end
        % Update topmost image
        set(himage(1),...
            'XData',XLim,...
            'YData',YLim,...
            'CData',CData);
    end

% Set the zoom and pan callback functions
set(zoom,'ActionPostCallback',{@postcallback,redraw});
set(pan,'ActionPostCallback',{@postcallback,redraw});

% Eliminate rotate3d
set(rotate3d,'ButtonDownFilter',@rotatebuttondown);
end

function postcallback(obj,evd,redraw)
% Callback function for zoom and pan
redraw();
end

function res = rotatebuttondown(obj,evd)
% Return true to inhibit rotate3d
res = true(1);
end

function mu = makemandel(x,y,escape,maxiter)
% Generate mandelbrot set for xy coordinates given a certain escape radius
% and a maximum number of iterations
c = x(:)+1i*y(:);     % Put the coordinates in complex form
z = zeros(size(c));   % Initialize z_n
mu = ones(size(x));   % Initialize mu, the number of iterations before 
                      % divergence
z_index = 1:numel(z); % Index of non-divergent z_n

% Loop until max iter reached
% Assuming maxiter will always be reached so no need to check for empty
% z_index (this assumes that there is nothing to see otherwise)
% Content of loop is taken from 'Mandelbrot set vectorized' by Lucio Cetto
% from Matlab Central
for iter = 1:maxiter
    z(z_index) = z(z_index).^2 + c(z_index);
    z_index = z_index(abs(z(z_index))<escape);
    mu(z_index) = iter;
end
end

function mu = makejulia(x,y,escape,maxiter,c)
% Generate monic quadratic julia set for xy coordinates given a certain 
% escape radius and a maximum number of iterations
z = x(:)+1i*y(:);     % Put the coordinates in complex form
mu = ones(size(x));   % Initialize mu, the number of iterations before 
                      % divergence
z_index = 1:numel(z); % Index of non-divergent z_n

% Loop until max iter reached
% Assuming maxiter will always be reached so no need to check for empty
% z_index (this assumes that there is nothing to see otherwise)
% Content of loop is derived from 'Mandelbrot set vectorized' by Lucio
% Cetto from Matlab Central
for iter = 1:maxiter
    z(z_index) = z(z_index).^2 + c;
    z_index = z_index(abs(z(z_index))<escape);
    mu(z_index) = iter;
end
end

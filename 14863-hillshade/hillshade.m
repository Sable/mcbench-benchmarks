function h = hillshade(dem,X,Y,varargin)
% PUPROSE: Calculate hillshade for a digital elevation model (DEM)
% -------------------------------------------------------------------
% USAGE: h = hillshade(dem,X,Y,varagin)
% where: dem is the DEM to calculate hillshade for
%        X and Y are the DEM coordinate vectors
%        varargin are parameters options
%
% OPTIONS: 
%        'azimuth'  is the direction of lighting in deg (default 315)
%        'altitude' is the altitude of the lighting source in
%                   in degrees above horizontal (default 45)
%        'zfactor'  is the DEM altitude scaling z-factor (default 1)
%        'plotit'   creates a simple plot of the hillshade
%
% EXAMPLE:
%       h=hillshade(peaks(50),1:50,1:50,'azimuth',45,'altitude',100,'plotit')
%       - calculates the hillshade for an example 50x50 peak surface.
%       - changes the default settings for azimuth and altitude.
%       - creates an output hillshade plot

% See also: GRADIENT, CART2POL
%
% Note: Uses simple unweighted gradient of 4 nearest neighbours for slope
%       calculation (instead of Horn's method) with ESRIs hillshade
%       algorithm.
%
% Felix Hebeler, Dept. of Geography, University Zurich, February 2007.
% modified by Andrew Stevens (astevens@usgs.gov), 5/04/2007

%% configure inputs
%default parameters
azimuth=315;
altitude=45;
zf=1;
plotit=0;

%parse inputs
if isempty(varargin)~=1     % check if any arguments are given
    [m1,n1]=size(varargin);
    opts={'azimuth';'altitude';'zfactor';'plotit'};
    for i=1:n1;             % check which parameters are given
        indi=strcmpi(varargin{i},opts);
        ind=find(indi==1);
        if isempty(ind)~=1
            switch ind
                case 1
                    azimuth=varargin{i+1};
                case 2
                    altitude=varargin{i+1};
                case 3
                    zf=varargin{i+1};
                case 4
                    plotit=1;
            end
        end
    end
end

%% Initialize paramaters
dx=abs(X(2)-X(1));  % get cell spacing in x and y direction
dy=abs(Y(2)-Y(1));  % from coordinate vectors

% lighting azimuth
azimuth = 360.0-azimuth+90; %convert to mathematic unit 
azimuth(azimuth>=360)=azimuth-360;
azimuth = azimuth * (pi/180); %  convert to radians

%lighting altitude
altitude = (90-altitude) * (pi/180); % convert to zenith angle in radians

%% calc slope and aspect (radians)
[fx,fy] = gradient(dem,dx,dy); % uses simple, unweighted gradient of immediate neighbours
[asp,grad]=cart2pol(fy,fx); % convert to carthesian coordinates
%grad = grad/d; % multiply w cellsize
grad=atan(zf*grad); %steepest slope
% convert asp
asp(asp<pi)=asp(asp<pi)+(pi/2);
asp(asp<0)=asp(asp<0)+(2*pi);

%% hillshade calculation
h = 255.0*( (cos(altitude).*cos(grad) ) + ( sin(altitude).*sin(grad).*cos(azimuth-asp)) ); % ESRIs algorithm
h(h<0)=0; % set hillshade values to min of 0.

h=setborder(h,1,NaN); % set border cells to NaN

%% plot results if requested
if plotit==1
    figure
    imagesc(X,Y,h)
    axis image
    set(gca,'ydir','normal')
    colormap(gray)
end

%% -- Subfunction--------------------------------------------------------------------------
function grid = setborder(grid,bs,bvalue)
grid(1:bs,:)=bvalue; %toprows
grid(size(grid,1)-bs+1:size(grid,1),:)=bvalue; %bottom rows
grid(:,1:bs)=bvalue; %left cols
grid(:,size(grid,2)-bs+1:size(grid,2))=bvalue;
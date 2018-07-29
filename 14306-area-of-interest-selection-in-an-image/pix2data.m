function [dataX, dataY] = pix2data( ax, pixelX, pixelY )
%PIX2DATA Translate a Figure Pixel position into an Axes data point
%  If no Axes given, it defaults to GCA.
%  [X, Y] = PIX2DATA( AXES, x, y )
%  [X, Y] = PIX2DATA( AXES, [x y] )
%  [X, Y] = PIX2DATA( x, y )
%  [X, y] = PIX2DATA( [x y] )
%
%  For scalar or vector X and Y, output will have X and Y in columns
%  POINT  = PIX2DATA( AXES, x, y )
%  POINT  = PIX2DATA( AXES, [x y] )
%  POINT  = PIX2DATA( x, y )
%  POINT  = PIX2DATA( [x y] )
%  
%  See Also: DATA2PIX

% Chuck Packard, The Mathworks, Inc.
% 25 March 95

if nargin == 0
   error( 'Need AXES and X,Y position.' )
end

%See if there is a GCA, don't create one
if isempty( get(0,'children') )
   error( 'No Figure windows.' );
end
if isempty( get( gcf, 'children' ) )
   error( 'No Axes in current Figure.' );
end

if nargin == 1
   if size( ax, 2 ) ~= 2
      error( 'When defaulting to GCA, first argument should be [X Y].' )
   end
   pixelY = ax(:,2);
   pixelX = ax(:,1);
   ax = gca;

elseif nargin == 2
   if length(ax) == 1 & size(pixelX,2) == 2
      pixelY = pixelX(:,2);
      pixelX(:,2) = [];
   else
      pixelY = pixelX;
      pixelX = ax;
      ax = gca;
   end
end

%Check data, make X and Y column vectors
xSize = size(pixelX);
ySize = size(pixelY);
if any( ySize ~= xSize )
   error( 'Size of X and Y data not consistent.' );
end

%Get position of Axes in pixels
origAxesUnits = get(ax,'units');
set( ax, 'units', 'pixels' )
axPos = fix(get(ax,'position'));
set( ax, 'units', origAxesUnits )

%Find extent of Axes in data
xlimits = get(ax,'xlim');
ylimits = get(ax,'ylim');
dataWidth = xlimits(2) - xlimits(1);
dataHeight = ylimits(2) - ylimits(1);

%Find normalized position of points and determine pixel position
% as offset from lower left of Axes.
X = xlimits(1) + (((pixelX - axPos(1)) ./ axPos(3)) .* dataWidth);
Y = ylimits(1) + (((pixelY - axPos(2)) ./ axPos(4)) .* dataHeight);

if nargout < 2
   if min(ySize) ~= 1
      %What would it mean to concatenate two matrices for this function?
      dataX = X;
   elseif ySize(1) == 1 & ySize(2) > 1
      %Need to transpose data so it looks nice in column format
      dataX = [X' Y'];
   else
      dataX = [X Y];
   end
else
   dataX = X;
   dataY = Y;
end 
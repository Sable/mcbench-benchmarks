function [yGrid] = resample2 ( xData, yData, xGrid )
% [yGrid] = gridLine ( xData, yData, xGrid )
% Will take arbitrarilly sampled data (xData, yData) and return it
% resampled at the points of xGrid. Avoid NaN and Inf in the input as these
% can cause unpredictable side-effects. xGrid should be monotonically
% increasing but points need not be equidistant or unique.

assert ( nargin == 3, 'Require exactly 3 arguments.' );
assert ( nargout <= 1, 'Only one output argument.' );
assert ( length(xData) == numel(xData), 'xData must be a vector.' );
assert ( length(yData) == numel(yData), 'yData must be a vector.' );
assert ( length(xGrid) == numel(xGrid), 'xGrid must be a vector.' );
assert ( isreal(xData), 'xData must be real for algorithm to make sense.' );
assert ( isreal(xGrid), 'xGrid must be real for algorithm to make sense.' );

% Allocate memory for return values.
yGridGaps = nan(size(xGrid));

%Loop through all points in xGrid.
for i = 1:length(xGrid);
	%%%%%%%%%%%%%%%%%%%
	%Choose an interval to work with.
	
	%Special case for first point.
	if ( i == 1 )
		% Use interval after to guess interval before.
		binStart = xGrid(i) - (xGrid(i+1)-xGrid(i))/2;		
		%And include all values to halfway between first and second point.
		binStop = (xGrid(i)+xGrid(i+1))/2;		

	%Special case for last point.
	elseif ( i == length(xGrid) )
		% Start halfway between second-last and last point.
		binStart = (xGrid(i)+xGrid(i-1))/2;
		% Use interval before to guess interval after.
		binStop = xGrid(i) + (xGrid(i)-xGrid(i-1))/2;
		
	% All points except the first and the last.
	else
		%Start halfway to the point before
		binStart = (xGrid(i)+xGrid(i-1))/2;
		% And go halfway to the point after.
		binStop = (xGrid(i)+xGrid(i+1))/2;

	%Done selecting interval.
	end

	%Select al measurements within the selected interval.
	binValues = yData(xData>binStart & xData<binStop);
	
	% Calculate the mean of the selected measurements.
	yGridGaps(i) = mean( binValues );

end %Done with this point in xGrid, go to next.
	
% Find all points along xGrid for which there were no measurements.
yGridSelect = ~isnan( yGridGaps );

%Extract these from xGrid
xGridSelected = xGrid(yGridSelect);

% Extract these from yGridGaps
yGridSelected = yGridGaps( yGridSelect );

%Interpolate all the missing points.
yGrid = interp1( xGridSelected, yGridSelected, xGrid, 'linear', nan(1) );


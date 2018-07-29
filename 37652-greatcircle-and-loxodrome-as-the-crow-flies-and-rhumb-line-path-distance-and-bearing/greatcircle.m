function varargout=greatcircle(varargin)
%GREATCIRCLE "As the crow flies" path, distance and bearing.
%
%	GREATCIRCLE(LAT1,LON1,LAT2,LON2) returns the shortest distance (in km)
%	along the great circle between two points defined by spherical 
%	coordinates latitude and longitude (in decimal degrees). If input
%	arguments are vectors or matrix, it returns a vector/matrix of 
%	distances of the same size.
%
%	[LAT,LON,DISTANCE,BEARING]=GREATCIRCLE(LAT1,LON1,LAT2,LON2) where all
%	input arguments are scalars, computes the way points of coordinates LAT
%	and LON, the distances (in km), and the bearing angles (in degrees from 
%	North) along the path, with default 100 intermediate points. Note that
%	last bearing angle is NaN.
%
%	[...]=GREATCIRCLE(...,N) uses N intermediate points.
%
%	Example:
%
%	  load topo
%	  contour(0:359,-89:90,topo,[0,0],'k')
%	  [lat,lon,dis] = greatcircle(48.8,2.3,35.7,139.7);
%	  hold on, plot(lon,lat,'r','linewidth',2), hold off
%	  title(sprintf('Paris to Tokyo = %g km',dis(end)))
%
%	See also LOXODROME.
%
%	Author: Francois Beauducel <beauducel@ipgp.fr>
%	Created: 2012-07-26
%	Updated: 2012-11-14
%
%	References:
%	  http://www.movable-type.co.uk/scripts/latlong.html
%	  http://en.wikipedia.org/wiki/Haversine_formula

%	Copyright (c) 2012, François Beauducel, covered by BSD License.
%	All rights reserved.
%
%	Redistribution and use in source and binary forms, with or without 
%	modification, are permitted provided that the following conditions are 
%	met:
%
%	   * Redistributions of source code must retain the above copyright 
%	     notice, this list of conditions and the following disclaimer.
%	   * Redistributions in binary form must reproduce the above copyright 
%	     notice, this list of conditions and the following disclaimer in 
%	     the documentation and/or other materials provided with the distribution
%	                           
%	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%	ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%	LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%	POSSIBILITY OF SUCH DAMAGE.

if nargin < 4 | nargin > 5
	error('Number of input arguments not correct.')
else
	lat1 = varargin{1};
	lon1 = varargin{2};
	lat2 = varargin{3};
	lon2 = varargin{4};
end

if nargin < 5
	n = 100;
else
	n = varargin{5};
end

if any(~cellfun(@isnumeric,varargin))
	error('All input arguments must be numeric.')
end

rearth = 6371;	% volumetric Earth radius (in km)

if nargout > 1

	if any(~cellfun(@isscalar,varargin))
		error('To compute path way all input arguments must be scalars.')
	end

	% checks that segment is the shortest
	if abs(lon2-lon1) > 180
		lon2 = lon2 + 360*sign(lon1-lon2);
	end

	% defines a linear vector of longitudes
	lon = linspace(lon1,lon2,n);

	% computes latitudes along the great circle
	if lon1 == lon2
		lat = linspace(lat1,lat2,n);
	else
		lat = atand((sind(lat1)*cosd(lat2)*sind(lon - lon2) - sind(lat2)*cosd(lat1)*sind(lon - lon1))./(cosd(lat1)*cosd(lat2).*sind(lon1 - lon2)));
	end
	varargout = {lat,lon};

	if nargout > 2
		% computes the distance using Haversine's formula
		a = haversin(lat - lat1) + cosd(lat1).*cosd(lat).*haversin(lon - lon1);
		dist = rearth*2*asin(sqrt(a));
		varargout = {lat,lon,dist};
	end

	if nargout > 3
		% computes the bearing angle
		bear = atan2(sind(lon2-lon).*cosd(lat2),cosd(lat).*sind(lat2) - sind(lat).*cosd(lat2).*cosd(lon2-lon))*180/pi;
		bear(end) = NaN;
		varargout = {lat,lon,dist,bear};
	end
	
else
	dist = rearth*2*asin(sqrt(haversin(lat2 - lat1) + cosd(lat1).*cosd(lat2).*haversin(lon2 - lon1)));
	varargout = {dist};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = haversin(x)
% Haversin's function

y = sind(x/2).^2;


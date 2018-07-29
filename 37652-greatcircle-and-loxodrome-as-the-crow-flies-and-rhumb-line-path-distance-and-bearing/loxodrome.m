function [lat,lon,dist,bear]=loxodrome(varargin)
%LOXODROME Rhumb line path and distance.
%
%	[LAT,LON]=LOXODROME(LAT1,LON1,LAT2,LON2) computes the line between two 
%	points defined by their spherical coordinates latitude and longitude 
%	(in decimal degrees), crossing all meridians of longitude at the same 
%	angle, i.e. a path derived from an initial and constant bearing.
%	LAT and LON contain vectors of coordinates of the way points.
%
%	[LAT,LON,DISTANCE,BEARING]=LOXODROME(...) returns also vector of
%	distances (in km) along the path way, and constant bearing angle (in
%	degrees from North, a scalar).
%
%	[...]=LOXODROME(...,N) uses N intermediate points (default is 100).
%
%	Example:
%
%	  load topo
%	  contour(0:359,-89:90,topo,[0,0],'k')
%	  [lat,lon,dis,bear] = loxodrome(48.8,2.3,35.7,139.7);
%	  hold on, plot(lon,lat,'r','linewidth',2), hold off
%	  title(sprintf('Paris to Tokyo = %g km - bear = %g N',dis(end),bear))
%
%
%	See also GREATCIRCLE.
%
%	Author: Francois Beauducel <beauducel@ipgp.fr>
%	Created: 2012-10-30
%	Updated: 2012-11-08
%
%	References:
%	  http://en.wikipedia.org/wiki/Rhumb_line
%
%	Acknowledgments: Jorge David Taramona Perea, Jacques Vernin.

%	Development history:
%	  [2012-11-08] correction of the bearing angle calculation, with 
%	     consequence to distance values. Detection by Jacques Vernin.
%
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

if nargin < 4
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

if any(~cellfun(@isnumeric,varargin)) | any(~cellfun(@isscalar,varargin))
	error('All input arguments must be numeric scalars.')
end

% length of one degree of latitude (in km)
degkm = 6371*pi/180;

% defines linear vectors of latitudes and longitudes
lat = arcgdd(linspace(gdd(lat1),gdd(lat2),n));
lon = linspace(lon1,lon2,n);

if nargout > 2
	% computes the bearing angle
	bear = atan2d(lon2 - lon1,arcgdd(lat2) - arcgdd(lat1));
	
	% computes the distance along the path
	if lat1 ~= lat2
		dist = degkm*(lat - lat1)./cosd(bear);
	else
		dist = degkm*(lon - lon1).*cosd(lat1);
	end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = gdd(x)
%GDD Gudermann function in degree.

y =  atand(sinh(x*pi/180));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = arcgdd(x)
%ARCGDD Gudermann inverse function in degree.

%y =  180/pi * log(tand(45 + x/2));
y = atanh(sind(x))*180/pi;
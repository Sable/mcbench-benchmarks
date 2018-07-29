% Earth Observing System Data Visualization
% 
%   Part 2 (Using the Mapping Toolbox)
%
%   This M-file contains the sequence of MATLAB commands listed in
%   the November 2002 MATLAB Digest article on "Reading and Visualizing
%   Data from the Earth Observing System (EOS)," from the section that
%   requires the Mapping Toolbox.
%
%   Rob Comer and Chris Lawton
%   Copyright 2002 The MathWorks, Inc. 



%== MAP PROJECTION OF COMBINED SST AND NDVI ==============================

% Set up figure, title, colormap, and map axes. Use a Mollweide projection
% with Greenwich as its central meridian.
figure('Color','k');
title({'SST from MODIS and NDVI from AVHRR, July 2001'},'Color','w')
colormap(cmap);
ax = axesm('MapProjection','mollweid','Origin',[0 0 0]);
set(ax,'Color',[0 0 0])

% Display the global NDVI on the map axes. The CDataMapping property
% must be set to 'direct' so that the data values directly index into the
% colormap. Add 1 because indexing for uint8s is zero-based but indexing
% for doubles is one-based. FLIPUD is required because columns in a 
% "regular matrix map" must run from south to north.
ndviNorthwestCorner = [89.5 -179.5];  % Lat/lon of upper-left-most cell center
ndviCellSize = 1;                     % Size of grid cells in degrees
hmesh = meshm(flipud(double(ndviMapped) + 1),...  % Converting uint8 image
              [ndviCellSize ndviNorthwestCorner],... % The 'legend'
              'CDataMapping','direct');  % Go directly into the colormap

% Display the MODIS SST swath over the global NDVI grid.
hsurf = surfm(sstLat,sstLon,double(sstMapped) + 1,...
              'CDataMapping','direct');

% Show 2 color scale bars, one for SST and one for NDVI.
% Move the map to make room, then add the color scales.
set(ax,'Position',get(ax,'Position') + [0 0.12 0 0])
colorscale(sstCmapLim,sstDataLim,5,'horiz',...
    'Position',[0.1 0.10, 0.8, 0.03],'XColor','w','YColor','w')
title('Sea Surface Temperature','Color','w')
xlabel('degrees Celsius')
colorscale(ndviCmapLim,ndviDataLim,0.2,'horiz',...
    'Position',[0.1 0.28, 0.8, 0.03],'XColor','w','YColor','w')
title('Normalized Difference Vegetation Index','Color','w')

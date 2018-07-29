% Earth Observing System Data Visualization
% 
%   Part 1 (Main Example)
%
%   This M-file contains the sequence of MATLAB commands listed in the
%   November 2002 MATLAB Digest article on "Reading and Visualizing Data
%   from the Earth Observing System (EOS)," up to the section that
%   requires the Mapping Toolbox.
%
%   Rob Comer and Chris Lawton
%   Copyright 2002 The MathWorks, Inc. 



%== DATA SELECTION AND HDFTOOL============================================

% Load the sea surface temperature (SST) swath data set, the corresponding
% geolocation data set, and the NDVI grid into HDFTOOL.
hdftool('MOD28L2.A2001185.0830.003.2001308112641.hdf')
hdftool('MOD03.A2001185.0830.003.2001305034045.hdf')
hdftool('PAL_CLIMATE_JUL_01-10_2001.HDF')



%== COLOR SCALES AND SHARING A COLORMAP ==================================

% We'll want separate colorbars for SST and NDVI, and we'll want tick marks
% labelled in physical units. So instead of using MTALAB's COLORBAR
% command, we'll use our COLORSCALE function. Because each figure can only
% have one colormap, we concatenate a 128-color SST colormap with a
% 128-color NDVI colormap.

% Load the colormap and display a standard colorbar.
load colormaps
cmap = [sstCmap; ndviCmap];   % We saved our colormap in two equal parts
figure
colormap(cmap)
set(axes,'Visible','off')
h = colorbar('horiz');
set(get(h,'Title'),'String','Standard Colorbar')

% Examine the colormap with COLORMAPEDITOR.
colormapeditor

% Assign colormap ranges to SST and NDVI, and relate them to physical
% units.
sstCmapLim  = [3 128];
sstDataLim  = [0  35];
ndviCmapLim = [  131   256];
ndviDataLim = [-0.25  1.00];

% Add color scales for SST and NDVI to the current figure.
pos = get(h,'Position'); % Position color scales relative to the color bar
colorscale(sstCmapLim, sstDataLim,5,'horiz','Position',pos + [0 0.70 0 0])
title('SST Colorscale')
xlabel('degrees Celsius')
colorscale(ndviCmapLim,ndviDataLim,0.2,'horiz','Position',pos + [0 0.35 0 0])
title('NDVI Colorscale')



%== READING MODIS SEA SURFACE TEMPERATURE SWATH ==========================

% Read MODIS Sea-Surface Temperature (SST).
mod28L2File = 'MOD28L2.A2001185.0830.003.2001308112641.hdf';
sstInfo = hdfinfo(mod28L2File,'eos');
sstSwath = sstInfo.Swath;
idx = {[1 1],[4 4],[]}; % Subset by 4 in each dimension
sst = hdfread(sstSwath,'Fields','sst','Index',idx);

% Read flags and construct land mask.
commonFlags = hdfread(sstSwath,'Fields','common_flags','Index',idx);
land = (bitget(commonFlags,8) == 1);

% Read SST attributes: scale and units.
sstInfoHDF = hdfinfo(mod28L2File);
datasets = sstInfoHDF.Vgroup.Vgroup(2).SDS;
sstDataset = datasets(strmatch('sst',{datasets.Name},'exact'));
sstAttr    = sstDataset.Attributes;
sstSlope     = double(sstAttr(strmatch('Slope',    {sstAttr.Name})).Value)
sstIntercept = double(sstAttr(strmatch('Intercept',{sstAttr.Name})).Value)
sstUnits     = sstAttr(strmatch('Units',{sstAttr.Name})).Value

% Read MODIS geolocation data fields.
mod03File = 'MOD03.A2001185.0830.003.2001305034045.hdf';
geoInfo = hdfinfo(mod03File,'eos');
sstLat = double(hdfread(geoInfo.Swath,'Fields','Latitude', 'Index',idx));
sstLon = double(hdfread(geoInfo.Swath,'Fields','Longitude','Index',idx));
sstLat(sstLat == -999) = NaN;
sstLon(sstLon == -999) = NaN;


%== MAPPING SST VALUES TO THE COLORMAP ===================================

% The SST values are encoded in the HDF-EOS data file.  To convert an encoded
% data value to absolute temperature units (degrees Celsius), one must
% multiply by sst_slope, then add sst_intercept. However, instead of
% converting to an intermediate double-valued array in degrees Celsius,
% we directly scale and shift the encoded SST values to correspond to the
% SST section of the colormap, in preparation for visualizing them via
% direct color mapping (i.e., with 'CDataMapping' set to 'direct'). First
% determine coefficients a(1) and a(2) such that a(1) * sst + a(2) will
% linearly map the encoded SST values directly onto the portion of the
% SST section of our colormap.

% Find the encoded SST limits that correspond to the temperature limits
% in sstDataLim.
sstCodelim = (sstDataLim - sstIntercept)/sstSlope;

% Solve a 2-by-2 linear system:
%   a(1) * sstCodelim + a(2) = sstCmapLim - 1
a = (sstCmapLim - 1)/[sstCodelim; [1 1]];

% Finally, scale and shift, clip to stay within the appropriate part
% of the colormap, and convert to uint8 (for economy of storage).
% Also, be sure to remap the special value of zero and apply the land mask.
sstMapped = a(1) * double(sst) + a(2);  % Scale and shift
sstMapped(sstMapped < sstCmapLim(1)-1) = sstCmapLim(1)-1;  % Clip bottom
sstMapped(sstMapped > sstCmapLim(2)-1) = sstCmapLim(2)-1;  % Clip top
sstMapped(sst == 0) = 0;   % Remap special value (displays as white)
sstMapped(land) = 1;       % Apply land mask (displays as dark gray)
sstMapped = uint8(round(sstMapped)); % Save storage with uint8



%== VISUALIZING THE MODIS SST SWATH ======================================

% Display the re-mapped SST as an indexed-color image using the colormap.                               
figure('Position',[100 100 size(sstMapped,2) size(sstMapped,1)])
colormap(cmap)
image(sstMapped)
set(gca,'Position',[0 0 1 1],'DataAspectRatio',[1 1 1]);

% Apply CONTOUR to the latitude and longitude geolocation arrays to
% create a lat-lon grid that illustrates the location of the swath and its
% spatial distortions. Use a contour interval of 5 degrees.
interval = 5;
latContourValues = interval ...
    * (ceil(min(sstLat(:))/interval) : floor(max(sstLat(:))/interval));
lonContourValues = interval ...
    * (ceil(min(sstLon(:))/interval) : floor(max(sstLon(:))/interval));
hold on
[c,h] = contour(sstLat,latContourValues,'k'); clabel(c,h)
[c,h] = contour(sstLon,lonContourValues,'k'); clabel(c,h)
hold off

% Use the geolocation fields as inputs to SURFACE to re-display the swath in
% latitude-longitude coordinates, the use COLORSCALE to add a color scale bar
% with units indicated in degrees Celsius.
figure
colormap(cmap)
axes('DataAspectRatio',[1 1 1],...
    'XTick',-180:5:180,'YTick',-90:5:90,...
    'XLim',[20 50],'YLim',[12 37],...
    'XGrid','on','YGrid','on')
xlabel('Longitude, degrees')
ylabel('Latitude, degrees')
title('Geolocated SST swath, July 4, 2001')
surface(sstLon, sstLat, double(sstMapped) + 1,...
    'Linestyle','none','CDataMapping','Direct')
% Add color scale
pos = get(gca,'Position');
set(gca,'Position',pos + [-0.06 0 0 0])
colorscale(sstCmapLim, sstDataLim, 5, 'vert',...
           'Position',[0.92 pos(2) 0.025 pos(4)])
xlabel('SST')
ylabel('degrees Celsius')



%== READING AVHRR GLOBAL NDVI GRID =======================================

% Read NDVI data from the AVHRR Climate file.
ndviFile = 'PAL_CLIMATE_JUL_01-10_2001.HDF';
ndvi = hdfread(ndviFile,'Data-Set-2');

% Read NDVI data description and attributes.
ndviInfo = hdfinfo(ndviFile);
ndviAttr = ndviInfo.SDS.Attributes;
ndviAddOffset   = double(ndviAttr(...
    strmatch('add_offset',  {ndviAttr.Name},'exact')).Value)
ndviScaleFactor = double(ndviAttr(...
    strmatch('scale_factor',{ndviAttr.Name},'exact')).Value)



%== MAPPING NDVI VALUES TO THE COLORMAP ==================================

% The approach here is the same as for the sea surface temperature data
% mappings, except that the linear relationship between the encoded NDVI
% values and actual NDVI levels is expressed in terms of an offset and
% scale factor rather than an intercept and slope. To convert an encoded
% data value to absolute NDVI units, one must subtract the offset, then
% multiply by the scale factor.

% Find the encoded NDVI limits that correspond to the absolute NDVI limits
% in ndviDataLim.
ndviCodelim = ndviDataLim/ndviScaleFactor + ndviAddOffset;

% Solve a 2-by-2 linear system:
%   b(1) * ndviCodelim + b(2) = ndviCmapLim - 1
b = (ndviCmapLim - 1)/[ndviCodelim; [1 1]];

% Finally, scale and shift, clip to stay within the appropriate part
% of the colormap, and convert to uint8. Also, be sure to individually
% remap the special values (1 denoting water and 0 missing data).
ndviMapped = b(1) * double(ndvi) + b(2);  % Scale and shift
ndviMapped(ndviMapped < ndviCmapLim(1)-1) = ndviCmapLim(1)-1;  % Clip bottom
ndviMapped(ndviMapped > ndviCmapLim(2)-1) = ndviCmapLim(2)-1;  % Clip top
ndviMapped(ndvi==0) = 130-1;   % Missing data (displays as gray)
ndviMapped(ndvi==1) = 129-1;   % Water (displays as blue)
ndviMapped = uint8(round(ndviMapped));  % Save storage with uint8



%== VISUALIZING THE NDVI GRID ============================================

% Show the NDVI grid over global latitude-longitude axes, and add a color
% scale.
figure
colormap(cmap)
image(ndviMapped,'XData',[-179.5 179.5],'YData',[89.5 -89.5])
set(gca,'YDir','normal','DataAspectRatio',[1 1 1],...
    'XTick',[-180 : 30 : 180],'YTick',[-90 : 30 : 90],...
    'XLim',[-180 180],'YLim',[-90 90])
xlabel('Longitude, degrees')
ylabel('Latitude, degrees')
title('NDVI from AVHRR, July 1-10, 2001')
% Add color scale
pos = get(gca,'Position');
set(gca,'Position',pos + [0 0.075 0 0])
colorscale( ndviCmapLim, ndviDataLim, 0.2, 'horiz','Position',[pos(1:3) 0.05])
xlabel('NDVI')


%== COMBINED SST AND NDVI DISPLAY ========================================

% Now show the NDVI and SST together on a latitude-longitude grid
% after zooming in on the region containing the SST swath. We add a
% color scale for each data set.
figure('Renderer','zbuffer')
colormap(cmap)
image(ndviMapped,'XData',[-179.5 179.5],'YData',[89.5 -89.5])
set(gca,'YDir','normal','DataAspectRatio',[1 1 1],...
    'XTick',-180:5:180,'YTick',-90:5:90,...  % Ticks every 5 degrees
    'XLim',[15 60],'YLim',[0 45]) % Axes limits in degrees
xlabel('Longitude, degrees')
ylabel('Latitude, degrees')
title('SST swath plotted over one-degree NDVI grid')
surface(sstLon, sstLat, ones(size(sstLon)), double(sstMapped) + 1,...
    'Linestyle','none','CDataMapping','Direct');
% Add color scales
pos = get(gca,'Position');
set(gca,'Position',pos + [-0.12 0 0 0])
colorscale(ndviCmapLim, ndviDataLim, 0.2, 'vert',...
           'Position',[0.9 pos(2) 0.025 pos(4)])
xlabel('NDVI')
colorscale(sstCmapLim, sstDataLim, 5, 'vert',...
           'Position',[0.8 pos(2) 0.025 pos(4)])
xlabel('SST')
ylabel('degrees Celsius')

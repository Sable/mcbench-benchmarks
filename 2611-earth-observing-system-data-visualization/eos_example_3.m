% Earth Observing System Data Visualization
% 
%   Part 3 (Color Scaling Preview)
%
%   This M-file contains the sequence of MATLAB commands from the
%   "Color Scaling Preview" section of the November 2002 MATLAB Digest
%   article on "Reading and Visualizing Data from the Earth Observing
%   System (EOS).
%
%   Rob Comer and Chris Lawton
%   Copyright 2002 The MathWorks, Inc. 



%== GLOBAL NDVI WITH SCALED COLOR MAPPING AND COLORBAR ===================
figure
colormap(ndviCmap)
i = imagesc(ndvi,ndviCodelim);
set(i,'XData',[-179.5 179.5],'YData',[89.5 -89.5])
set(gca,'YDir','normal','DataAspectRatio',[1 1 1],...
    'XTick',-180:30:180,'YTick',-90:30:90,...  % Ticks every 30 degrees
    'XLim',[-180 180],'YLim',[-90 90])         % Axes limits in degrees
xlabel('Longitude, degrees')
ylabel('Latitude, degrees')
title('NDVI from AVHRR, July 1-10, 2001')
pos = get(gca,'Position');  % Save axes position

% Add colorbar
h = colorbar('horiz');
label = sprintf('NDVI / %.3f + %.0f', ndviScaleFactor, ndviAddOffset);
set(get(h,'XLabel'),'String',label)
set(gca,'Position',pos + [0 0.075 0 0])  % Put axes where we want it
set(h,'Position',[pos(1:3) 0.05])        % Put colorbar where we want it


%== GLOBAL NDVI + SST SWATH WITH DIRECT COLOR MAPPING AND COLORSCALE =====
figure('Renderer','zbuffer')
colormap([sstCmap; ndviCmap])
image(ndviMapped,'XData',[-179.5 179.5],'YData',[89.5 -89.5])
set(gca,'YDir','normal','DataAspectRatio',[1 1 1],...
    'XTick',-180:30:180,'YTick',-90:30:90,...  % Ticks every 30 degrees
    'XLim',[-180 180],'YLim',[-90 90])         % Axes limits in degrees
xlabel('Longitude, degrees')
ylabel('Latitude, degrees')
title('SST swath plotted over one-degree NDVI grid')
surface(sstLon, sstLat, ones(size(sstLon)), double(sstMapped) + 1,...
    'Linestyle','none','CDataMapping','Direct');

% Add color scales
pos = get(gca,'Position');
set(gca,'Position',pos + [0 0.13 0 0])
colorscale(ndviCmapLim, ndviDataLim, 0.2, 'horiz',...
           'Position',[pos(1) 0.22 pos(3) 0.03])
ylabel('NDVI')
colorscale(sstCmapLim, sstDataLim, 5, 'horiz',...
           'Position',[pos(1) 0.1 pos(3) 0.03])
ylabel('SST')
xlabel('degrees Celcius')

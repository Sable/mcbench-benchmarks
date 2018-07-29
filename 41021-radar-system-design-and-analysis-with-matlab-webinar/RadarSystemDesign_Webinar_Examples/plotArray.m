%Copyright 2013 The MathWorks, Inc
function hax = plotArray(sAnt,atitle,hax)
%% Visualize Array Geometry  
figure('WindowStyle','docked'),
viewArray(sAnt,'Title',atitle)
hax(end+1) = gca;
set(gca,'Position',[0 0.55 0.5 0.5])
%% Visualize 3D Array Response  
hax(end+1) = axes('Position',[0.1 0 .9 .9]);
fc = 3e9;                      % Operating frequency
c  = physconst('LightSpeed');  % Propagation Speed
plotResponse(sAnt,fc,c,'RespCut','3D','Format','polar')
title('');colorbar off
%% Link Viewpoints
hlink = linkprop(hax,'View');
setappdata(gcf,'Link',hlink)


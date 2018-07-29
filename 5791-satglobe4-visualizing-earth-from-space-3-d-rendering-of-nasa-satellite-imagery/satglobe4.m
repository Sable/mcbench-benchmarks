% SATGLOBE4 - Draw an idealized satellite view of earth
%
% This file renders a fully manipulatable satellite view
% of earth at a resolution of four pixels per degree, with added
% international political boundaries and gridlines.
% The imagery was obtained from NASA, then postprocessed.
% The globe was rendered using the Matlab Mapping Toolbox.
%
% The Mapping Toolbox is not needed to use this file; however,
% if you have the toolbox, you will be able to use the plot3m
% command to add your own graphics. If not, you can simply use plot3.
%
% In order to save storage space, this m-file loads image
% data from the file satglobe.mat, and then creates the
% graticule mesh itself. This process allows users who
% do not have the Matlab Mapping Toolbox to render the
% figure, but it does take a few moments to compute the
% mesh. Using this trick, the data storage is reduced
% considerably; however, once the figure is rendered, you
% may wish to save it as a regular Matlab figure file
% to increase speed.
%
% Michael Kleder, 2004

function satglobe4
load satglobe4
th=repmat((0:.25:180)'*pi/180,[1 1441]);
ph=repmat((-180:.25:180)*pi/180,[721 1]);
s.children(1).properties.XData = sin(th).*cos(ph);
s.children(1).properties.YData = sin(th).*sin(ph);
s.children(1).properties.ZData = cos(th);
s.children(1).properties.CData = double(c)/255;
figure;
struct2handle(s,gcf);
set(gcf,'color','k','renderer','zbuffer','inverthardcopy','off','name',...
   'Earth at 4 Pixels per Degree, by Michael Kleder');
return
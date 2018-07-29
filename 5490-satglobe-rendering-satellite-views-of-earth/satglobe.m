% SATGLOBE - Draw an idealized satellite view of earth
%
% This file renders a fully manipulatable satellite view
% of earth at a resolution of two pixels per degree, with added
% international political boundaries and gridlines.
% The imagery was obtained from NASA, and the globe was
% rendered using the Matlab Mapping Toolbox.
%
% The Mapping Toolbox is not needed to use this file.
%
% In order to save storage space, this m-file loads image
% data from the file satglobe.mat, and then creates the
% graticule mesh itself. This process allows users who
% do not have the Matlab Mapping Toolbox to render the
% figure, but it does take a few moments to compute the
% mesh. Using this trick, the data storage is reduced
% considerably; however, once the figure is redered, you
% may wish to save it as a regular Matlab figure file
% to increase speed.
%
% Michael Kleder, 2004

function satglobe
load satglobe
th=repmat((0:.5:180)'*pi/180,[1 721]);
ph=repmat((-180:.5:180)*pi/180,[361 1]);
s.children(1).properties.XData = sin(th).*cos(ph);
s.children(1).properties.YData = sin(th).*sin(ph);
s.children(1).properties.ZData = cos(th);
s.children(1).properties.CData = double(c)/255;
figure;
struct2handle(s,gcf);
set(gcf,'color','k','renderer','zbuffer','inverthardcopy','off','name',...
   'Earth at 2 Pixels per Degree, by Michael Kleder');
return
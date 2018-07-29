function makemap(fig,filename)
%MAKEMAP Creates a clickable imagemap.
%    MAKEMAP(FIG,FILENAME) creates two files FILENAME.html and FILENAME.png
%    which are clickable imagemaps of the figure FIG.  FIG defaults to gcf and
%    FILENAME defaults to "map".
%
%    Empty text objects mark the hotspots on the imagemap.  Set their 'tag' to
%    be 'click' and their UserData to a structure with two fields, "url" and
%    "description".  These fields specify the target of the click and the "alt"
%    text of the link respectively.  Newer browsers render the "alt" text as a
%    tooltip.
%
%
%    Example:
%
%    % Create some random data.
%    x = rand(10,1);
%    y = rand(10,1);
%    plot(x,y,'.');
%
%    % Create the text labels to use as markers for where to put the hot zones.
%    for i = 1:length(x)
%        ud.url = 'http://www.matthewsim.com/';
%        ud.description = sprintf('point #%.0f%s%2.2f,%2.2f',i,char(10),x(i),y(i));
%        text(x(i),y(i),'','tag','click','UserData',ud)
%    end
%
%    % Create the file.
%    makemap(gcf,'map');
% 
%    % Open the page.
%    web(['file:///' which('map.html')],'-browser')

% Matthew J. Simoneau
% Copyright 2003 The MathWorks, Inc. 

if (nargin < 1)
   fig = gcf;
end
if (nargin < 2)
   filename = 'map';
end

mapFile = fopen([filename '.html'],'w');
fprintf(mapFile,'<img src="%s.png" usemap="#one"/>\n\n',filename);
fprintf(mapFile,'<map name="one">\n');

figPos = get(fig,'Position');

axesList = findobj('type','axes');
for iAxes = 1:length(axesList)
    ax = axesList(iAxes);

    set(ax,'Units','Pixels')
    axPos = get(ax,'Position');

    clickList = flipud(findobj(ax,'tag','click'));
    for iClick = 1:length(clickList)
        click = clickList(iClick);
        set(click,'units','pixels')
        pos = get(click,'Position');
        ud = get(click,'UserData');
        f = '    <area shape="circle" coords="%.0f,%.0f,3" href="%s" alt="%s"/>\n';
        fprintf(mapFile,f, ...
            pos(1)+axPos(1)-1, ...
            figPos(4)-(axPos(2)+axPos(4))+(axPos(4)-pos(2))+2, ...
            ud.url, ...
            ud.description);
    end
end
 
fprintf(mapFile,'</map>\n');
fclose(mapFile);

figure(fig)
g = getframe(fig);
imwrite(g.cdata,[filename '.png'])

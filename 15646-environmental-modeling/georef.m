function [xx0,yy0,xx1,yy1,xline,yline,xloc,yloc] = georef ()
% Map input and georeferencing     
%    using MATLAB                    
%
%   $Ekkehard Holzbecher  $Date: 2006/08/25 $
%------------------------- Input ------------------------------------------
[infile,path] = uigetfile('*.jpg','Select graphics file...');
infilepath = strcat(path,infile);
lx = 1000; ly = 1000;
h = figure;   
[X,map] = imread(infilepath);
imagesc(X); 
axis off; hold on;
ax1 = gca; 
ax1 = axes ('Position',get(ax1,'Position'),...
    'Color','none','XLim',[0 lx],'Ylim',[0 ly],'XTick',[],'YTick',[]);
    
%------------------------ Geo-reference -----------------------------------
h = gca; hold on;

h0 = text (0,-ly*0.05,'Set referencepoint 1','BackgroundColor','y',...
    'EdgeColor','red','LineWidth',2);
%h0 = msgbox ('Set referencepoint 1');
[x0,y0,but] = ginput(1);
h1 = plot (x0,y0,'k+');
coords = inputdlg({'horizontal','vertical'},'Field position',1,{'0','0'});
xx0 = str2double(coords(1)); yy0 = str2double(coords(2)); 
delete (h0);

h0 = text (0,-ly*0.05,'Set referencepoint 2','BackgroundColor','y',...
    'EdgeColor','red','LineWidth',2);
[x1,y1,but] = ginput(1);
h2 = plot (x1,y1,'k+');
coords = inputdlg({'horizontal','vertical'},'Field position',1,{'4000','3000'});
xx1 = str2double(coords(1)); yy1 = str2double(coords(2));
delete (h0,h1,h2);

mx = (xx1-xx0)/(x1-x0); xmin = xx0-mx*x0; xmax = xx1+mx*(lx-x1);
my = (yy1-yy0)/(y1-y0); ymin = yy0-my*y0; ymax = yy1+my*(ly-y1);
ax1 = axes ('Position',get(ax1,'Position'),...
    'Color','none','XLim',[xmin xmax],'Ylim',[ymin ymax]);
h = gca; hold on;
% --------------------------- Set Line ------------------------------------

h0 = text (xmin,ymin-0.05*(ymax-ymin),'Set line: left mouse button: set; right: last value',...
    'BackgroundColor','y','EdgeColor','red','LineWidth',2);
but = 1; count = 0;
while but == 1
    [xi,yi,but] = ginput(1);
    plot (xi,yi,'rx');
    count = count+1;
    xline(count) = xi; yline(count) = yi; % only if position in model region 
end
line (xline,yline,'Color','r');
delete (h0);
% --------------------------- Set Locations--------------------------------

h0 = text (xmin,ymin-0.05*(ymax-ymin),'Set locations: left mouse button: set; right: last value',...
    'BackgroundColor','y','EdgeColor','red','LineWidth',2);
h = gca; hold on;
but = 1; count = 0;
while but == 1
    [xj,yj,but] = ginput(1);
    plot (xj,yj,'bo');
    count = count+1;
    xloc(count) = xj; yloc(count) = yj; % only if position in model region 
end
delete (h0)
% ------------------------------- Output ----------------------------------
xx0
xx1
yy0
yy1
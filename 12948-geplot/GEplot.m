function GEplot(filename,Lat,Lon,style,opt11,opt12,opt21,opt22)
%
% function GEplot(filename,Lat,Lon,style,opt11,opt12,opt21,opt22)
%
% Description: creates a file in kmz format that can be opened into Google Earth.
%    GEplot uses the same syntax as the traditional plot function but
%    requires Latitude and Longitudd (WGS84) instead of x and y (note that Lat is
%    the first argument).
%    If you need to convert from UTM to Lat/Lon you may use utm2deg.m also
%    available at Matlab Central
%
% Arguments:
%    filename Example 'rafael', will become 'rafael.kmz'.  The same name
%             will appear inside Temporary Places in Google Earth as a layer.
%    dot_size Approximate size of the mark, in meters
%    Lat, Lon Vectors containing Latitudes and Longitudes.  The number of marks
%             created by this function is equal to the length of Lat/Lon vectors
%(opt)style   allows for specifying symbols and colors (line styles are not
%             supported by Google Earth currently. (see bellow)
%(opt)opt...   allows for specifying symbol size and line width (see bellow)
%
% Example:
%    GEplot('my_track',Lat,Lon,'o-r','MarkerSize',10,'LineWidth',3)
%    GEplot('my_track',Lat,Lon)
%
% Plot style parameters implemented in GEplot
%            color               symbol                line style
%            -----------------------------------------------------------
%            b     blue          .     point              -    solid
%            g     green         o     circle          (none)  no line
%            r     red           x     x-mark               
%            c     cyan          +     plus                  
%            m     magenta       *     star             
%            y     yellow        s     square
%            k     black         d     diamond
%            w     white (new)   S     filled square (new)
%                                D     filled diamond (new)
%                                O     filled circle=big dot (new)
%
% Plot properties: 'MarkerSize' 'LineWidth'       
%
% Additional Notes:
% 'Hold on' and 'Hold off' were not implemented since one can generate a
%    .kmz file for each plot and open all simultaneously within GE.
% Unless you have a lot of data point it is recomended to show the symbols
%    since they are created in a separate folder so within Google Earth it
%    is very easy to show/hide the line or the symbols.
% Current kml/kmz format does not support different linestyles, just solid.
%    Nevertheless it is possible to define the opacity of the color (the 
%    first FF in the color definition means no transparency).
% Within Matlab, it is possible to generate a second plot with the 
%    same name, then you just need to select File/Revert within GE to update.
%
%
% Author: Rafael Palacios, Universidad Pontificia Comillas
% http://www.iit.upcomillas.es/palacios
% November 2006
% Version 1.1: Fixed an error while plotting graphs without symbols.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Argument checking
%
error(nargchk(3, 8, nargin));  %3 arguments required, 8 maximum
n1=length(Lat);
n2=length(Lon);
if (n1~=n2)
   error('Lat and Lon vectors should have the same length');
end
if (nargin==5 || nargin==7)
    error('size arguments must be "MarkerSize" or "LineWidth" strings followed by a number');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% symbol size and line width
%
markersize=7; %matlab default
linewidth=2;  %matlab default is 0.5, too thin for map overlay
if (nargin==6)
    if (strcmpi(opt11,'markersize')==1)
        markersize=opt12;
    elseif (strcmpi(opt11,'linewidth')==1)
        linewidth=opt12;
    else
        error('size arguments must be "MarkerSize" or "LineWidth" strings followed by a number');
    end
end
if (nargin==8)
    if (strcmpi(opt21,'markersize')==1)
        markersize=opt22;
    elseif (strcmpi(opt21,'linewidth')==1)
        linewidth=opt22;
    else
        error('size arguments must be "MarkerSize" or "LineWidth" strings followed by a number');
    end
end
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% symbol, line style and color
%
symbol='none';
iconfilename='none';
linestyle='-';
color='b';
colorstring='ffff0000';

if (nargin>=4)
    %linestyle
    if (strfind(style,'-'))
        linestyle='-';
    else
        linestyle='none';
    end

    %symbol
    if (strfind(style,'.')), symbol='.'; iconfilename='dot'; end
    if (strfind(style,'o')), symbol='o'; iconfilename='circle'; end
    if (strfind(style,'x')), symbol='x'; iconfilename='x'; end
    if (strfind(style,'+')), symbol='+'; iconfilename='plus'; end
    if (strfind(style,'*')), symbol='*'; iconfilename='star'; end
    if (strfind(style,'s')), symbol='s'; iconfilename='square'; end
    if (strfind(style,'d')), symbol='d'; iconfilename='diamond'; end
    if (strfind(style,'S')), symbol='S'; iconfilename='Ssquare'; end
    if (strfind(style,'D')), symbol='D'; iconfilename='Sdiamon'; end
    if (strfind(style,'O')), symbol='O'; iconfilename='dot'; end
    if (strfind(style,'0')), symbol='O'; iconfilename='dot'; end

    %color
    if (strfind(style,'b')), color='b'; colorstring='ffff0000'; end
    if (strfind(style,'g')), color='g'; colorstring='ff00ff00'; end
    if (strfind(style,'r')), color='r'; colorstring='ff0000ff'; end
    if (strfind(style,'c')), color='c'; colorstring='ffffff00'; end
    if (strfind(style,'m')), color='m'; colorstring='ffff00ff'; end
    if (strfind(style,'y')), color='y'; colorstring='ff00ffff'; end
    if (strfind(style,'k')), color='k'; colorstring='ff000000'; end
    if (strfind(style,'w')), color='w'; colorstring='ffffffff'; end
end

iconfilename=strcat('GEimages/',iconfilename,'_',color,'.png');
if (symbol=='.') 
    markersize=markersize/5;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creating kml file
%
fp=fopen(strcat(filename,'.kml'),'w');
if (fp==-1)
    message=sprint('Unable to open file %s.kml',filename);
    error(message);
end
fprintf(fp,'<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(fp,'<kml xmlns="http://earth.google.com/kml/2.1">\n');
fprintf(fp,'<Document>\n');
fprintf(fp,'<name>%s</name>\n',strcat(filename,'.kml'));
fprintf(fp,'<description>Graph generated in Matlab (using GEplot.m by Rafael Palacios)</description>\n');
%
%Symbol styles definition
fprintf(fp,'<Style id="mystyle">\n');
fprintf(fp,'   <IconStyle>\n');
fprintf(fp,'      <scale>%.2f</scale>\n',markersize/14); %scale adjusted for .png image sizes
fprintf(fp,'      <Icon><href>%s</href></Icon>\n',iconfilename);
fprintf(fp,'   </IconStyle>\n');
fprintf(fp,'   <LineStyle>\n');
fprintf(fp,'      <color>%s</color>\n',colorstring);
fprintf(fp,'      <width>%d</width>\n',linewidth);
fprintf(fp,'   </LineStyle>\n');
fprintf(fp,'</Style>\n');
fprintf(fp,'\n');


if (linestyle=='-')
    fprintf(fp,'    <Placemark>\n');
    fprintf(fp,'      <description><![CDATA[Line created with Matlab GEplot.m]]></description>\n');
    fprintf(fp,'      <name>Line</name>\n');
    fprintf(fp,'      <visibility>1</visibility>\n');
    fprintf(fp,'      <open>1</open>\n');
    fprintf(fp,'      <styleUrl>mystyle</styleUrl>\n');
    fprintf(fp,'      <LineString>\n');
    fprintf(fp,'        <extrude>0</extrude>\n');
    fprintf(fp,'        <tessellate>0</tessellate>\n');
    fprintf(fp,'        <altitudeMode>clampToGround</altitudeMode>\n');
    fprintf(fp,'        <coordinates>\n');
    for k=1:n1
      fprintf(fp,'%11.6f, %11.6f, 0\n',Lon(k),Lat(k));
    end
    fprintf(fp,'        </coordinates>\n');
    fprintf(fp,'      </LineString>\n');
    fprintf(fp,'    </Placemark>\n');
end

if (strcmp(symbol,'none')==0)
fprintf(fp,'    <Folder>\n');
fprintf(fp,'      <name>Data points</name>\n');
for k=1:n1
    fprintf(fp,'      <Placemark>\n');
    fprintf(fp,'         <description><![CDATA[Point created with Matlab GEplot.m]]></description>\n');
%    fprintf(fp,'         <name>Point %d</name>\n',k);  %you may add point labels here
    fprintf(fp,'         <visibility>1</visibility>\n');
    fprintf(fp,'         <open>1</open>\n');
    fprintf(fp,'         <styleUrl>#mystyle</styleUrl>\n');
    fprintf(fp,'         <Point>\n');
    fprintf(fp,'           <coordinates>\n');
    fprintf(fp,'%11.6f, %11.6f, 0\n',Lon(k),Lat(k));
    fprintf(fp,'           </coordinates>\n');
    fprintf(fp,'         </Point>\n');
    fprintf(fp,'      </Placemark>\n');
end
fprintf(fp,'    </Folder>\n');
end

fprintf(fp,'</Document>\n');
fprintf(fp,'</kml>\n');

fclose(fp);

if (strcmp(symbol,'none')==1)
   zip(filename,{strcat(filename,'.kml')});
else
   zip(filename,{strcat(filename,'.kml'), iconfilename});
end
movefile(strcat(filename,'.zip'),strcat(filename,'.kmz'));
delete(strcat(filename,'.kml'));

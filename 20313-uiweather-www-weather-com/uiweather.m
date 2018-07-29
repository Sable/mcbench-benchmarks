function uiweather(varargin)
% UIWEATHER  displays the current and forecast weather information obtained from "www.weather.com" service.
%
% There are two modes possible.
% -----------------------------
%    a. As a standalone GUI which displays the weather information. For standalone
%       mode you will need an UIWEATHERINI.M file which contains start settings
%       like color, units and the specified city codes. The UIWEATHERINI should
%       simplify the function call. So you can predefine the settings before and
%       use only UIWEATHER without start parameters to show the weather forecast
%       for specified cities.
%
%    b. It is possible to place the weather forecast within another GUI. 
%       In this case you should specify the GUI handle, position in pixels and 
%       some other settings if necessary. UIWEATHER.INI is not(!) used in this case.
%       
% If multiple city codes are specified you can use the contextmenu to switch 
% between city names. The tooltipstring provides additional infos.
%
%       supported features:
%                       parent - handle of the host figure
%                     position - Pixel position of the left down corner
%                        units - 'c' for celsius or 'f' for farenheit
%                    textcolor - as the name implies
%              backgroundcolor - as the name implies
%          iconbackgroundcolor - the background color for the weather icons
%                      twcicon - 1 or 0 to enable/disable the "TWC" icon
%                     citycode - cellarray of city codes
%                                
%
% How to get the city code:
% -------------------------
%    1. Go to http://www.weather.com (or http://weather.yahoo.com)
%    2. Enter your city name in the search box and click the GO button.
%    3. Click the link for your city from the search results.
%       This action will display the page with your city's current weather information.
%    4. Grab your city code from the address bar of your web browser and add
%       the city name which is necessary for the contextmenu.
%
%       Example: The city code for Boston in the following link is USMA0046:
%       http://www.weather.com/outlook/travel/businesstraveler/local/USMA0046
%       
%       city code for using with UIWEATHER is: 'Boston:USMA0046'
%
% Examples:
% ---------
%    uiweather('parent',gcf,'position',[50 50], ...
%              'citycode',{'Munich:GMXX0087' 'Natick:USMA0273'}, ...
%              'units','c')
%
%    uiweather('parent',gcf,'position',[50 50], ...
%              'citycode',{'Natick:USMA0273'}, ...
%              'units','f')
%
% NOTE!!! :-)
% -----------
% No responsibility is taken for the correctness of the weather
% information. Please contact "The Weather Channel" in such cases... :-)
%
%
%  Author: Elmar Tarajan (MCommander@gmx.de)
%  Version: 1.6

%   Service readapt to "www.weather.com"
%
%  Version: v1.5
% 
%   2008/05/30 detailed forecast information in tooltipstring
%   2008/05/28 some code improvements
%   2008/05/28 improved handling of UIWEATHER.INI file
%   2008/05/25 "update"-callback implemented
%   2008/05/24 improved look / bug fixed

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize default settings
H.version             = 'v1.6';
H.parent              = [];
H.position            = [10 10];
%
H.textcolor           = [ 1  1  1];
H.backgroundcolor     = [.5 .5 .5];
H.iconbackgroundcolor = [.6 .7 .9];
H.units               = {'f'};
H.twcicon             = 1;
H.citycode            = [];
%
if nargin==0
   %
   % overwrite some default settings if UIWEATHER.INI exists
   fid=fopen('uiweather.ini');
   if fid~=-1
      while 1
         tline = fgetl(fid);
         if ~ischar(tline), break, end
         %
         % find "="-character
         id = find(tline=='=');
         % create the key
         key = tline(1:id-1);
         % check if the key is supported
         if any(strcmp({'textcolor', ...
                        'backgroundcolor', ...
                        'units', ...
                        'twcicon', ...
                        'detailed', ...
                        'citycode'},key))
            %
            value = tline(id+1:end);
            tmp = str2num(value);
            if isempty(tmp)
               H = setfield(H,key,strread(value,'%s'));
            else
               H = setfield(H,key,tmp);
            end% if
         end% if
      end
      fclose(fid);
   else
      % show help if uiweather.ini not exists
      help('uiweather')
      return
   end% if
   %
else
   % input parser
   for n = 1:2:length(varargin)
      if isfield(H,lower(varargin{n}))
         H = setfield(H,lower(varargin{n}),varargin{n+1});
      end
   end% for
   %
end% if
% uiweather ui builder
H = uigroup_builder(H);
% update gui with current weather information
updatefcn([],[],H,H.citycode{1})
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function updatefcn(cnc1,cnc2,H,city)
%-------------------------------------------------------------------------------
% cnc1 and cnc2 are temp variables which will never used (placeholder)
uicontrol(H.days(1))
set(H.city,'string','Please wait...','Enable','inactive')
set([H.days H.lupd H.icon H.temp],'enable','off')
drawnow
%
city = city(find(city==':')+1:end);
data = urlread(sprintf('http://www.weather.com/weather/print/%s',city));
if isempty(data);
   set(H.city,'string',sprintf('ERROR: Please try again later'),'Enable','on')
   return
end

info = char(regexp(data,'<B>Forecast for (.*?)</B>','match'));
info = info(17:end-4);

lupd = char(regexp(data,'Last Updated (.*?) <','match'));
lupd = lupd(14:end-1);

data = char(regexp(data,'<!-- begin loop -->.*<!-- end loop -->','match'));
data = regexp(data, '<TR>.*?</TR>','match');
data = regexprep(data, '<FONT.*?>(.*?)</FONT>','$1');
data = regexprep(data, '<B>(.*?)</B>','$1');

set(H.city,'string',info)
set(H.lupd,'string',lupd)
for n=1:5
   %
   tmp = regexp(char(data{n}), '<TD.*?>.*?</TD>','match');
   tmp = regexprep(tmp,'<TD.*?>(.*?)</TD>','$1');
   %
   tmp{1} = strrep(tmp{1},'<BR>',',');
   tmp{2} = regexp(tmp{2}, 'http.*?gif','match');
   tmp{4} = strrep(tmp{4},'&deg;','°');
   tmp{5} = regexp(tmp{5},'\d','match');
   %
   set(H.days(n),'string',tmp{1},'tooltipstring',tmp{1})
   [a b] = imread(char(tmp{2}));
   rgb = [nan(31,24,3) ind2rgb(a,b)];
   set(H.icon(n),'cdata',rgb,'tooltipstring',tmp{3})
   
   switch upper(char(H.units))
      case 'C'
         tmp{4} = sprintf('%.f°/%.0f°',(sscanf(tmp{4},'%f°/%f°')-32)*5/9);
   end% switch
   
   txt = sprintf('%s%s',tmp{4},upper(H.units{1}));
   set(H.temp(n),'string',txt)
   set(H.temp(n),'tooltipstring',sprintf('temperature %s',txt))
   txt = sprintf('%s%%',tmp{5}{1});
   set(H.prec(n),'string',txt)
   set(H.prec(n),'tooltipstring',sprintf('precipitation %s',txt))
end% for


set(H.city,'Enable','on')
set([H.days H.icon H.temp H.lupd],'enable','on')
uicontrol(H.days(1))
drawnow


return
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function H = uigroup_builder(H)
%-------------------------------------------------------------------------------
if isempty(H.parent)
   ssz = get(0,'ScreenSize');
   H.parent = figure('menubar','none','numbertitle','off', ...
      'Name','www.weather.com', ...
      'units','pixel','position',[(ssz(3:4)-[418 93])/2 418 93], ...
      'resize','off', 'HandleVisibility','off', ...
      'color',[.2 .2 .2],'visible','off');
end% if
%
H.cmenu = uicontextmenu('Parent',H.parent);
%
icon = nan(1,1,3);
if H.twcicon
   icon = twcicon(H.backgroundcolor);
end% if
%
H.city = uicontrol('parent',H.parent,'units','pixel','style','radiobutton', ...
   'position',[H.position+[0 59] 270 15],'cdata',nan(1,1,3), ...
   'FontSize',8,'FontWeight','Bold', ...
   'backgroundcolor',H.backgroundcolor,'foregroundcolor',H.textcolor, ...
   'uicontextmenu',H.cmenu,'cdata',icon,'tooltipstring','forecast for');

H.lupd = uicontrol('parent',H.parent,'units','pixel','style','text', ...
   'position',[H.position+[270 59] 129 15],'cdata',nan(1,1,3), ...
   'FontSize',8,'FontWeight','Bold', ...
   'horizontalalignment','right', ...
   'backgroundcolor',H.backgroundcolor,'foregroundcolor',H.textcolor-0.8, ...
   'uicontextmenu',H.cmenu,'cdata',icon,'tooltipstring','last update');
%
for i=1:5
   %
   H.days(i) = uicontrol('parent',H.parent,'units','pixel','style','text','uicontextmenu',H.cmenu, ...
      'position',[H.position+[80*(i-1) 47] 79 11], ...
      'FontSize',7, ...
      'cdata',nan(1,1,3), ...
      'backgroundcolor',H.backgroundcolor,'foregroundcolor',H.textcolor);
   %
   H.icon(i) = uicontrol('parent',H.parent,'units','pixel','style','radiobutton','uicontextmenu',H.cmenu, ...
      'cdata',nan(1,1,3),'position',[H.position+[80*(i-1) 12] 79 34], ...
      'backgroundcolor',[1 1 1]);
   %
   H.temp(i) = uicontrol('parent',H.parent,'units','pixel','style','text','uicontextmenu',H.cmenu, ...
      'position',[H.position+[80*(i-1) 0] 54 11],'FontSize',7,'cdata',nan(1,1,3), ...
      'backgroundcolor',H.backgroundcolor,'foregroundcolor',H.textcolor);
   %
   H.prec(i) = uicontrol('parent',H.parent,'units','pixel','style','text','uicontextmenu',H.cmenu, ...
      'position',[H.position+[80*(i-1)+54 0] 25 11],'FontSize',7,'cdata',nan(1,1,3), ...
      'backgroundcolor',H.backgroundcolor,'foregroundcolor',H.textcolor-0.8,'tooltipstring','precipitation');   
   %
end% for
%
for i=1:length(H.citycode)
   tmp(i) = uimenu(H.cmenu,'label',H.citycode{i}(1:find(H.citycode{i}==':')-1),'callback',{@changecity,H});
end% for
set(tmp(1),'checked','on')
%
uimenu(H.cmenu,'Label','about...','separator','on','callback',{@about,H.version})
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function H = changecity(hObj,data,H)
%-------------------------------------------------------------------------------
set(get(H.cmenu,'children'),'checked','off')
set(hObj,'checked','on')
city = get(hObj,'Label');
city = H.citycode{strncmp(city,H.citycode,length(city))};
set([H.city H.lupd],'callback',{@updatefcn,H,city})
updatefcn([],[],H,city)
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cdata = twcicon(backgrcolor)
%-------------------------------------------------------------------------------
cdata(:,:,1) = [ ...
	  1   0   0   1   0   0   0   0   0   0   0   1   0   0   0   0 ; ...
	  1   1   1   0   0   0   0   0   0   0   1   0   0   0   0   0 ; ...
	  0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0 ; ...
	 27  52  44  52  44  44   0  27  21   1  41   0  21  55  17   1 ; ...
	109 236 253 236 220 228  21 185 137  52 202  77 220 228 220  36 ; ...
	  9  27 210  86  21 210  88 228 185 119 185 202 122  18  90  28 ; ...
	  0   5 210  77   0 166 202 185 202 185 166 220  40   1   0   0 ; ...
	  0  10 210  77   0 122 253 108 166 253  90 220  71   0  26   7 ; ...
	  1  10 228  77   0  77 253  55 119 253  28 137 228 159 228  55 ; ...
	  1   0 108  41   0  21 119  11  40 112   1   7 112 159  88   1 ; ...
	  0   0   0   0   0   0   0   0   0   0   1   0   0   0   0   1 ; ...
	  0   0   0   0   0   0   0   0   1   1   0   0   0   1   1   1 ; ...
	  0   0   0   0   0   0   0   1   1   0   0   0   0   1   1   1 ; ...
	]/255;
cdata(:,:,2) = [ ...
	 76  78  78  76  73  73  70  68  65  63  60  57  55  52  50  47 ; ...
	 76  76  76  73  73  72  68  65  63  60  57  55  52  50  47  45 ; ...
	 70  70  68  65  65  60  65  60  55  55  50  50  45  41  41  41 ; ...
	 86 104 101 104 101 101  60  86  70  57  83  45  70  87  55  36 ; ...
	149 241 254 241 228 233  70 199 158 104 211 114 228 233 228  66 ; ...
	 74  86 221 129  70 221 124 233 199 143 199 211 147  50 119  61 ; ...
	 63  69 221 114  41 182 211 199 211 199 182 228  74  29  20  29 ; ...
	 60  68 221 114  34 147 254 138 182 254 119 228  98  15  58  41 ; ...
	 57  68 233 114  34 114 254  87 143 254  61 158 233 171 233  87 ; ...
	 57  60 138  83  41  70 143  52  74 133  36  41 133 171 108  31 ; ...
	 55  52  41  45  47  41  29  41  34  20  36  32  20  20  20  29 ; ...
	 52  50  50  47  45  41  41  41  36  36  34  32  32  31  31  29 ; ...
	 50  50  47  45  41  41  41  36  36  34  32  32  32  31  29  29 ; ...
	]/255;
cdata(:,:,3) = [ ...
	170 173 173 170 169 169 168 165 164 162 161 158 157 154 153 151 ; ...
	170 170 170 169 169 166 165 164 162 161 158 157 154 153 151 149 ; ...
	168 168 165 164 164 161 164 161 157 157 153 153 149 150 145 145 ; ...
	174 182 181 182 181 181 161 174 164 158 171 149 164 169 154 140 ; ...
	204 248 254 248 241 244 164 227 207 182 233 185 241 244 241 158 ; ...
	166 174 239 193 164 239 192 244 227 198 227 233 202 150 185 154 ; ...
	162 166 239 185 150 219 233 227 233 227 219 241 162 134 131 138 ; ...
	161 165 239 185 146 202 254 197 219 254 185 241 173 131 151 142 ; ...
	158 165 244 185 146 185 254 169 198 254 154 207 244 211 244 169 ; ...
	158 161 197 171 150 164 198 152 162 191 140 142 191 211 176 135 ; ...
	157 154 150 149 151 150 138 145 139 131 140 137 131 131 131 134 ; ...
	154 153 153 151 149 145 145 145 140 140 139 137 137 135 135 134 ; ...
	153 153 151 149 145 145 145 140 140 139 137 137 137 135 134 134 ; ...
	]/255;
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function about(obj,cnc,ver)
%-------------------------------------------------------------------------------
answer = questdlg({['UIWEATHER ' ver]...
   '(c) 2009 by Elmar Tarajan [MCommander@gmx.de]'}, ...
   'about...','look for updates','Bug found?','OK','OK');
switch answer
   case 'look for updates'
      web(['http://www.mathworks.com/matlabcentral/fileexchange/' ...
         'loadAuthor.do?objectId=936824&objectType=author'],'-browser');
   case 'Bug found?'
      web(['mailto:MCommander@gmx.de?subject=UIWEATHER%20' ver '-BUG:' ...
         '[Description]-[ReproductionSteps]-[Suggestion' ...
         '(if%20possible)]-[MATLAB%20v' strrep(version,' ','%20') ']'],'-browser');
   case 'OK'
end% switch
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% I LOVE MATLAB! You too? :) %%%
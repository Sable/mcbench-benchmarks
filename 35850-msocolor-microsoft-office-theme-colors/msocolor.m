function MSO = msocolor(varargin)
%MSOCOLOR   Get Microsoft Office theme colors
%   C = MSOCOLOR returns a struct of colors associated with the default MS
%   Office (2007 or later with Open Office XML Theme support). The output
%   struct C has the following fields:
%
%      C.TextColor              : [1x3] (Default to) Text/Background Light 1
%      C.BackgroundColor        : [1x3] (Default to) Text/Background Dark 1
%      C.AccentColors           : [6x3] Accent 1 - Accent 6
%      C.HyperlinkColor         : [1x3] Hyperlink
%      C.FollowedHyperlinkColor : [1x3] FollowedHyperlink
%
%   Theme colors are extracted either interactively from MS Office via .NET
%   interface or directly from the MS Office color theme directories.
%   Therefore, MSOCOLOR will error out if it cannot detect a compatible
%   version of MS Office on the computer.
%
%   MSOCOLOR(THEME) retrieves the color scheme associated with MS Office
%   Theme spceified by the string THEME. The default is 'Office'. Possible
%   theme names can be found under "Themes Colors" See http://bit.ly/GOnHEU
%   (links to Microsoft website) for where to find Office theme color
%   toolbar button. Both user-defined and built-in themes are supported.
%
%   MSOCOLOR(APPNAME) retrieves the color scheme associated with the active
%   file in the specified Office application. APPNAME may be one of 'word',
%   'excel', or 'powerpoint'.
%
%   MSOCOLOR(APPNAME,FILENAME) retrieves the color scheme of the Office
%   data file specified by FILENAME.
%
%   MSOCOLOR(THEME,'Param1',Value1,'Param2',Value2,...) sets retrieval
%   options:
%
%      TextColor           : {'dark'}|'light' - Specifies dark or light
%                            color for the text
%      BackgroundColor     : 'dark'|{'light'} - Specified light or dark
%                            color for the background
%      TextBackGroundType  : {1}|2 - Specifies to use which Text/Background
%                            pair to use.
%      Darken              : [0-100] - Darkens all colors by the percentage
%                            specified.
%      Lighten             : [0-100] - Lightens all colors by the
%                            percentage speciifed.
%
%   * By setting TextColor, BackgroundColor is automatically set to the
%   opposite color scheme, and vice varsa.
%   * If both Darken and Lighten options are given, MSOCOLOR takes the last
%   option specified.
%
%   Example: To use the Accent colors as the plot line colors:
%
%      C = msocolor('Office');
%      axes('NextPlot','replacechildren','ColorOrder',C.AccentColors);
%      plot(rand(20,6)) legend show
%
%   Note that NextPlot property of the axes must be set to
%   'replacechildren' to change ColorOrder for subsequent plot command to
%   keep the ColorOrder.

% Copyright 2012 Takeshi Ikuma
% History:
% rev. - : (03-25-2012) original release
% rev. 1 : (03-26-2012) bug fix
%          * Compatibility fix for 2011b
% rev. 2 : (04-19-2012)
%          * New feature: color scheme can also be retrieved from either
%            active or specified data file within Word/Excel/PowerPoint.
% rev. 3 : (04-24-2012)
%          * Bug fixes.

try
   [appid,istheme,name,dktxt,type,brightness] = parse_input(nargin,varargin);
catch ME
   throwAsCaller(ME);
end

if istheme
   try
      colormatrix = getExcelThemeColorScheme(name);
   catch ME
      ME.throwAsCaller();
   end
else
   try
      colormatrix = getFileColorScheme(appid,name);
   catch ME
      ME.throwAsCaller();
   end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% normalize color to 0-1
colormatrix(:) = colormatrix/255;

% brightness adjustment
if brightness~=0
   hsl = rgb2hsl(colormatrix);
   if brightness>0 % lighter by brightness*100 %
      hsl(:,3) = brightness + hsl(:,3)*(1-brightness);
   elseif brightness<0 % darker by -brightness*100 %
      hsl(:,3) = hsl(:,3)*(1+brightness);
   end
   colormatrix(:) = round(hsl2rgb(hsl)*255)/255; % to be close to MSO values
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Form output struct

if type==1
   if dktxt, txt = 7; bgd = 8;
   else      txt = 8; bgd = 7;
   end
else
   if dktxt, txt =  9; bgd = 10;
   else      txt = 10; bgd =  9;
   end
end
MSO.TextColor = colormatrix(txt,:);
MSO.BackgroundColor = colormatrix(bgd,:);
MSO.AccentColors = colormatrix(1:6,:);
MSO.HyperlinkColor = colormatrix(11,:);
MSO.FollowedHyperlinkColor = colormatrix(12,:);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

function colormatrix = getFileColorScheme(appid,name)

NET.addAssembly('mscorlib'); % for System.Runtime.InteropServices.Marshal

if ~isempty(name) && exist(name,'file')~=2
   error('Specified file does not exist.');
end

app = [];
closeapp = true;
try
switch appid
   case 1 % word
      try
         NET.addAssembly('microsoft.office.interop.word');
      catch %#ok
         error('Microsoft Word is not installed on this PC.');
      end
      if isempty(name) % active document
         try
            app = Microsoft.Office.Interop.Word.Application(System.Runtime.InteropServices.Marshal.GetActiveObject('Word.Application'));
            closeapp = false;
         catch %#ok
            error('Microsoft Word is not running.');
         end
         try
            DOC = app.ActiveDocument;
         catch %#ok
            error('No Word document currently open.');
         end
      else
         app = Microsoft.Office.Interop.Word.ApplicationClass;
         app.ChangeFileOpenDirectory(pwd); % set to use the same current directory as MATLAB

         % open existing document (creates new if does not exist)
         DOC = app.Documents.Open(name);
      end
      colormatrix = getThemeColorScheme(DOC.DocumentTheme.ThemeColorScheme);
      DOC.Close();
   case 2 % excel
      try
         NET.addAssembly('microsoft.office.interop.excel');
      catch %#ok
         error('Microsoft Excel is not installed on this PC.');
      end
      if isempty(name) % active document
         try
            app = Microsoft.Office.Interop.Excel.Application(System.Runtime.InteropServices.Marshal.GetActiveObject('Excel.Application'));
            closeapp = false;
         catch %#ok
            error('Microsoft Excel is not running.');
         end
         try
            WB = app.ActiveWorkbook;
            if isempty(WB), error('empty'); end
         catch %#ok
            error('No Excel workbook currently open.');
         end
      else
         app = Microsoft.Office.Interop.Excel.ApplicationClass;
         app.DefaultFilePath = pwd; % set to use the same current directory as MATLAB

         % open existing document (creates new if does not exist)
         WB = app.Workbooks.Open(name);
      end
      colormatrix = getThemeColorScheme(WB.Theme.ThemeColorScheme);
      WB.Close();
   case 3 % powerpoint
      try
         NET.addAssembly('microsoft.office.interop.powerpoint');
      catch %#ok
         error('Microsoft PowerPoint is not installed on this PC.');
      end
      
      try
         app = Microsoft.Office.Interop.PowerPoint.Application(System.Runtime.InteropServices.Marshal.GetActiveObject('PowerPoint.Application'));
         closeapp = false;
      catch %#ok
         app = [];
      end
      
      if isempty(name) % active document
         if isempty(app)
            error('Microsoft PowerPoint is not running.');
         end
         try
            PRES = app.ActivePresentation;
            if isempty(PRES), error('empty'); end
         catch %#ok
            error('No PowerPoint presentation currently open.');
         end
         Nfiles = app.Presentations.Count();
      else
         if isempty(app)
            app = Microsoft.Office.Interop.PowerPoint.ApplicationClass;
         end
   
         if strncmp(computer,'PCWIN',5) && numel(name)>2 && name(2)~=':'
            name = [pwd filesep name];
         end
         
         % open existing document (creates new if does not exist)
         Nfiles = app.Presentations.Count();
         PRES = app.Presentations.Open(name);
      end
      
      colormatrix = getThemeColorScheme(PRES.SlideMaster.Theme.ThemeColorScheme);

      % close the file if it has not been already opened
      if ~closeapp && app.Presentations.Count()>Nfiles
         PRES.Close();
      end
end
catch ME
   if ~isempty(app) && closeapp
      app.Quit();
   end
   ME.rethrow();
end
if ~isempty(app) && closeapp
   app.Quit();
end

end

function colormatrix = getExcelThemeColorScheme(name)
try
   NET.addAssembly('microsoft.office.interop.excel');
catch %#ok
   error('Microsoft Office is not installed on this PC.');
end
app = Microsoft.Office.Interop.Excel.ApplicationClass;
try
   if strcmpi(name,'Office')  % Default theme, must retrieve via .NET interface
      % if user default template set, temporarily rename
      usrtemp = [char(app.StartupPath) filesep 'Book.xltx'];
      tempexists = exist(usrtemp,'file');
      if tempexists % temporarily rename so new Workbook will be created with default MS template
         system(['ren ' usrtemp ' ' usrtemp '.tmp']);
      end
      try
         newWB = app.Workbooks.Add;
         colormatrix = getThemeColorScheme(newWB.Theme.ThemeColorScheme);
      catch ME_in % revert the template
         newWB.Close;
         system(['ren ' usrtemp '.tmp ' usrtemp]);
         rethrow(ME_in);
      end
      newWB.Close;
      if tempexists % revert the template
         system(['ren ' usrtemp '.tmp ' usrtemp]);
      end
      
   else % Others as specified in Theme Colors folders
      % get MSO and User pathes
      msopath = char(app.Path);
      usrpath = char(app.TemplatesPath);
      ver = floor(str2double(char(app.Version))); % Excel version
      if msopath(end)==filesep, msopath(end) = ''; end
      if usrpath(end)==filesep, usrpath(end) = ''; end
      msopath = sprintf('%s%sDocument Themes %d%sTheme Colors%s%s.xml',fileparts(msopath),filesep,ver,filesep,filesep,name);
      usrpath = sprintf('%s%sDocument Themes%sTheme Colors%s%s.xml',usrpath,filesep,filesep,filesep,name);
      
      if exist(usrpath,'file')
         colormatrix = parseThemeColorXML(usrpath);
      elseif exist(msopath,'file')
         colormatrix = parseThemeColorXML(msopath);
      else
         error('Invalid Color Theme name specified.');
      end
   end
catch ME_out
   app.Quit;
   rethrow(ME_out);
end
app.Quit;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function colormatrix = getThemeColorScheme(colortheme)

NET.addAssembly('office');
import Microsoft.Office.Core.*

try
   % color Schemes that are in the same order as the colornames in the main
   % function
   colorschemes = {
      MsoThemeColorSchemeIndex.msoThemeAccent1
      MsoThemeColorSchemeIndex.msoThemeAccent2
      MsoThemeColorSchemeIndex.msoThemeAccent3
      MsoThemeColorSchemeIndex.msoThemeAccent4
      MsoThemeColorSchemeIndex.msoThemeAccent5
      MsoThemeColorSchemeIndex.msoThemeAccent6
      MsoThemeColorSchemeIndex.msoThemeDark1
      MsoThemeColorSchemeIndex.msoThemeLight1
      MsoThemeColorSchemeIndex.msoThemeDark2
      MsoThemeColorSchemeIndex.msoThemeLight2
      MsoThemeColorSchemeIndex.msoThemeHyperlink
      MsoThemeColorSchemeIndex.msoThemeFollowedHyperlink};
   rgb = zeros(numel(colorschemes),1);
   for n = 1:numel(colorschemes)
      rgb(n) = typecast(colortheme.Colors(colorschemes{n}).RGB,'uint32');
   end
   r = mod(rgb,256);
   gb = floor(rgb/256);
   g = mod(gb,256);
   b = mod(floor(gb/256),256);
   colormatrix = [r g b];
catch ME_in
   rethrow(ME_in)
end
end

function colormatrix = parseThemeColorXML(filename)
% PARSEXML Convert XML file to a MATLAB structure.

% color scheme name
cnames = {'accent1','accent2','accent3','accent4','accent5','accent6',...
   'dk1','lt1','dk2','lt2','hlink','folHlink'};

% initialize the output matrix
colormatrix = zeros(numel(cnames),3);

try
   tree = xmlread(filename);
catch ME %#ok
   return;
end

% root node - check its name is a:clrSceme
rootchk = false;
for j = 0:tree.getLength-1
   root = tree.item(j);
   rootchk = strcmp(root.getNodeName,'a:clrScheme');
   if rootchk, break; end
end
if ~rootchk, return; end

% traverse child nodes for color nodes (must match colorstruct field names)
if ~root.hasChildNodes, return; end
for j = 0:root.getLength-1
   cnode = root.item(j);
   if ~cnode.hasChildNodes, continue; end % must have a child
   
   nname = regexp(char(cnode.getNodeName),'a:(.+)','tokens','once');
   [ok,I] = ismember(nname,cnames);
   if ~ok, continue; end % unknown color name
   
   rgbok = false;
   for k = 0:cnode.getLength-1
      cdata = cnode.item(k);
      switch char(cdata.getNodeName)
         case 'a:srgbClr'
            aname = 'val';
         case 'a:sysClr'
            aname = 'lastClr';
         otherwise
            aname = '';
      end
      if isempty(aname), continue; end
      
      attribs = cdata.getAttributes;
      for i = 0:attribs.getLength-1
         attrib = attribs.item(i);
         rgbok = strcmp(attrib.getName,aname);
         if rgbok
            rgbstr = char(attrib.getValue);
            
            if isempty(regexp(rgbstr,'^[\da-fA-F]{6}$','once'))
               warning('msocolor:UnknownRGB','Unexpected RGB string: %s',rgbstr);
            else
               colormatrix(I,:) = hex2dec(reshape(rgbstr,2,3)');
            end
            break;
         end
      end
      if rgbok, break; end
   end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RGB<->HSL COLOR conversion functions for brightness control

function hsl = rgb2hsl(rgb)

hsl = zeros(size(rgb));
J = rgb(:,1)==rgb(:,2) & rgb(:,1)==rgb(:,3); % true if gray
hsl(J,3) = rgb(J,1); % only L is non-zero

J(:) = ~J;
hsl(J,:) = rgb2hsl_color(rgb(J,:));

end

function hsl = rgb2hsl_color(rgb)

var_Min = min(rgb,[],2);    % Min. value of RGB
[var_Max,Imax] = max(rgb,[],2);    % Max. value of RGB
del_Max = var_Max - var_Min;             % Delta RGB value

% Set L
hsl(:,3) = (var_Max+var_Min)/2;

% Set S
I = hsl(:,3)<0.5;
hsl(I,2) = del_Max(I) ./ ( var_Max(I) + var_Min(I) );
I(:) = ~I;
hsl(I,2) = del_Max(I) ./ ( 2 - var_Max(I) - var_Min(I) );

% Set H
x = bsxfun(@(vmax,vrgb)(vmax-vrgb)/6,var_Max,rgb);
del_RGB = bsxfun(@(x,dmax)(x./dmax + 1/2),x,del_Max);

idx = Imax==1; % red dominant color
hsl(idx,1) = del_RGB(idx,3) - del_RGB(idx,2);
idx = Imax==2; % green dominant color
hsl(idx,1) = 1/3 + del_RGB(idx,1) - del_RGB(idx,3);
idx = Imax==3; % blue dominant color
hsl(idx,1) = 2/3 + del_RGB(idx,2) - del_RGB(idx,1);

hsl(:,1) = mod(hsl(:,1),1);
end

function rgb = hsl2rgb(hsl)
% gray
J = hsl(:,2)==0;
rgb = repmat(hsl(:,3),1,3);

% color
J(:) = ~J;
rgb(J,:) = hsl2rgb_color(hsl(J,:));
end

function rgb = hsl2rgb_color(hsl)

I = hsl(:,3)<0.5;
var_2 = zeros(size(hsl,1),1);
var_2(I) = hsl(I,3).*(1+hsl(I,2));
I(:) = ~I;
var_2(I) = (hsl(I,3)+hsl(I,2)) - (hsl(I,2).*hsl(I,3));
var_1 = 2 * hsl(:,3) - var_2;

H = hsl(:,1);
rgb(:,1) = hue2rgb( var_1, var_2, H + 1/3 );
rgb(:,2) = hue2rgb( var_1, var_2, H);
rgb(:,3) = hue2rgb( var_1, var_2, H - 1/3 );

end

function val = hue2rgb( v1, v2, vH )             %Function Hue_2_RGB

vH(:) = mod(vH,1);

val = zeros(size(vH));
I = vH < 1/6;
val(I) = v1(I) + (v2(I)-v1(I)).*6.*vH(I);
J = vH < 1/2 & ~I;
I(:) = I | J;
val(J) = v2(J);
J(:) = vH < 2/3 & ~I;
I(:) = I | J;
val(J) = v1(J) + ( v2(J) - v1(J) ) .* ( ( 2/3 ) - vH(J) ) * 6;
J(:) = ~I;
val(J) = v1(J);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [appid,istheme,name,dktxt,type,brightness] = parse_input(N,argin)

appid = 2; % 'excel'
istheme = true;
name = 'Office';
dktxt = true;
type = 1;
brightness = 0;
n0 = 1;

% if no argument, use the default
if N==0, return; end

if ~ischar(argin{1}) || size(argin{1},1)~=1
   error('THEME must be a string of characters.');
end

appid = find(strcmpi(argin{1},{'word','excel','powerpoint'}),1);
istheme = isempty(appid);

if istheme
   name = char(argin{1}); % theme name
   if N==1, return; end
else
   if mod(N,2)==0 % file name
      name = char(argin{2});
      if N==2, return; end
      n0 = 2;
   else
      name = '';
      if N==1, return; end
   end
end

Nopts = floor((N-n0)/2);
if 2*Nopts+n0 ~= N
   error('OPTIONS must be given in Name/Value pairs.');
end

if ~iscellstr(argin(n0+1:2:end))
   error('OPTION parameter names must be strings of characters.');
end

opts = reshape(argin(n0+1:end),2,Nopts);
for n = 1:Nopts
   val = opts{2,n};
   switch lower(opts{1,n})
      case 'textcolor'
         I = strcmpi(val,{'dark','light'});
         if ~(I(1)||I(2))
            error('TextColor option must be ''dark'' or ''light''');
         end
         dktxt = I(1);
      case 'backgroundcolor'
         I = strcmpi(val,{'dark','light'});
         if ~(I(1)||I(2))
            error('BackgroundColor option must be ''dark'' or ''light''');
         end
         dktxt = I(2);
      case 'textbackgroundtype'
         if ~isnumeric(val) || numel(val)~=1 || ~any(val==[1 2])
            error('TextBackGroundType must be either 1 or 2.');
         end
         type = val;
      case 'darken'
         if ~isnumeric(val) || numel(val)~=1 || val<0 || val>100
            error('Darken must be given as a number between 0 and 100.');
         end
         brightness = -val/100;
      case 'lighten'
         if ~isnumeric(val) || numel(val)~=1 || val<0 || val>100
            error('Lighten must be given as a number between 0 and 100.');
         end
         brightness = val/100;
      otherwise
         error('Invalid option.');
   end
end
end

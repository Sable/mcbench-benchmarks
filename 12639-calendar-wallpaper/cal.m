function cal(varargin)

%CAL    Creates a calendar wallpaper image (.jpg) for a particular year.
%   CAL generates a JPG calendar image that can be used as a wallpaper.
%
%   CAL YEAR generates a calendar image file for the year YEAR.
%
%   CAL SIZE generates an image with size SIZE. SIZE can be one of the
%   following:
%     -small    the calendar takes up about 60% of the image
%     -medium   the calendar takes up about 80% of the image
%     -large    the calendar takes up the whole image
%
%   CAL -smooth generates a smoother image. It creates an image twice the
%   size, and resizes by half to produce an anti-aliased image.
%
%   See also calendar.

%   Jiro Doke
%   January 2004
%   jiro.doke@mathworks.com

error(nargchk(0, 3, nargin));

this_year = [];
sz = .8;
isSmooth = false;

% Process input arguments
for var = varargin
  if ischar(var{1})
    switch lower(var{1})
      case '-small'
        sz = .6;
    
      case '-medium'
        sz = .8;
      
      case '-large'
        sz = 1;
      
      case '-smooth'
        isSmooth = true;
      
      otherwise
        this_year = str2double(var{1});
        if isnan(this_year)
          error('Invalid input argument.');
        elseif fix(this_year) ~= this_year
          error('Invalid year.');
        end
    end
  else
    error('Invalid input argument.');
  end
end

if isempty(this_year)
  this_year = clock;
  this_year = this_year(1);
end

if isSmooth
  screenSize = get(0, 'ScreenSize')*2;
else
  screenSize = get(0, 'ScreenSize');
end
screenSize(1:2) = [1 1];

% The calendarSize specifies how big the calendar image is on the screen.
% The image will be centered on the screen. Make the size equal or smaller
% than the screen resolution. 
calendarSize = screenSize(3:4) * sz;

pixelsPerInch = get(0, 'ScreenPixelsPerInch');

FontFactor = calendarSize(1)/1024;

monthNameSize = 12 * FontFactor;
dayNameSize   = 9  * FontFactor;
mainTitleSize = 16 * FontFactor;

bgcolor = [0 0 0];
fgcolor = [.75 .75 .75];

month_names = {
  'January'
  'February'
  'March'
  'April'
  'May'
  'June'
  'July'
  'August'
  'September'
  'October'
  'November'
  'December'};

day_names={
  'Su'
  'Mo'
  'Tu'
  'We'
  'Th'
  'Fr'
  'Sa'};

h=figure(...
  'units'                         , 'pixels', ...
  'position'                      , screenSize, ...
  'paperunits'                    , 'inch', ...
  'papersize'                     , screenSize(3:4)/pixelsPerInch, ...
  'paperposition'                 , screenSize/pixelsPerInch, ...
  'visible'                       , 'off', ...
  'color'                         , bgcolor, ...
  'inverthardcopy'                , 'off', ...
  'defaultTextFontName'           , 'verdana', ...
  'defaultTextFontUnits'          , 'pixels', ...
  'defaultTextHorizontalAlignment', 'center', ...
  'defaultTextVerticalAlignment'  , 'top', ...
  'defaultTextFontSize'           , dayNameSize, ...
  'defaultTextFontWeight'         , 'bold', ...
  'defaultTextColor'              , fgcolor, ...
  'defaultAxesUnits'              , 'pixels', ...
  'defaultAxesFontName'           , 'Verdana', ...
  'defaultAxesFontWeight'         , 'bold', ...
  'defaultAxesFontUnits'          , 'pixels', ...
  'defaultAxesColor'              , bgcolor, ...
  'defaultAxesXTick'              , [], ...
  'defaultAxesYTick'              , [], ...
  'defaultAxesXColor'             , bgcolor, ...
  'defaultAxesYColor'             , bgcolor);

imageAdjust = [screenSize(3:4)-calendarSize 0 0]/2;
imageFactor = calendarSize([1 2 1 2]);

ax = zeros(12, 1);
for id = 1:12   % Create month

  ax(id) = axes('position', ...
    imageAdjust + imageFactor .* ...
    [(mod(id-1,4)+2)/6, (2-floor((id-1)/4))/4+1/16, 1/6-1/64, 1/4-3/64]);
  
  title(month_names{id}, 'fontsize', monthNameSize);
  
  % Create day labels
  for id2 = 1:7
    text(id2-1+.5, 7, day_names{id2}, 'fontweight', 'bold');
  end

  % Get dates from CALENDAR
  a = calendar(this_year, id);
  a = reshape(a', 1, numel(a));

  % Create dates
  for id3 = 1:length(a)
    if a(id3) ~= 0
      text(mod(id3-1,7)+.5, 6-floor((id3-1)/7), num2str(a(id3)));
    end
  end
  
end

title_h = axes('position', imageAdjust+imageFactor.*[2/6, 3/4+1/16, 4/6, 1/64]);
set(title_h, 'box', 'off');
title(sprintf('Calendar for %d', this_year), 'fontsize', mainTitleSize);

set(ax, ...
  'box'                       , 'off', ...
  'xlim'                      , [0 7], ...
  'ylim'                      , [0 7]);

axes(...
  'position'                  , imageAdjust+imageFactor.*[.5 0 .45 .05], ...
  'xlim'                      , [0 1], ...
  'ylim'                      , [0 1]);
text(1, 0                     , 'Created with MATLAB®', ...
  'horizontalalignment'       , 'right', ...
  'verticalalignment'         , 'bottom', ...
  'fontweight'                , 'normal', ...
  'fontangle'                 , 'italic');

%--------------------------------------------------------------------------
% Create MATLAB membrane logo
L = 40*membrane(1,25);
logoax = axes(...
  'CameraPosition'            , [-193.4013 -265.1546  220.4819],...
  'CameraTarget'              , [26 26 10], ...
  'CameraUpVector'            , [0 0 1], ...
  'CameraViewAngle'           , 9.5, ...
  'DataAspectRatio'           , [1 1 .9],...
  'Position'                  , imageAdjust+imageFactor.*[.1 .05 .2 .2], ...
  'Visible'                   , 'off', ...
  'XLim'                      , [1 51], ...
  'YLim'                      , [1 51], ...
  'ZLim'                      , [-13 40], ...
  'parent'                    , h);

surface(L, ...
  'EdgeColor'                 , 'none', ...
  'FaceColor'                 , [0.9 0.2 0.2], ...
  'FaceLighting'              , 'phong', ...
  'AmbientStrength'           , 0.3, ...
  'DiffuseStrength'           , 0.6, ...
  'Clipping'                  , 'off',...
  'BackFaceLighting'          , 'lit', ...
  'SpecularStrength'          , 1.1, ...
  'SpecularColorReflectance'  , 1, ...
  'SpecularExponent'          , 7, ...
  'Tag'                       , 'TheMathWorksLogo', ...
  'parent'                    , logoax);

light(...
  'Position'                  , [40 100 20], ...
  'Style'                     , 'local', ...
  'Color'                     , [0 0.8 0.8], ...
  'parent'                    , logoax);

light(...
  'Position'                  , [.5 -1 .4], ...
  'Color'                     , [0.8 0.8 0], ...
  'parent'                    , logoax);
%--------------------------------------------------------------------------

wait_h = waitbar(0, 'Creating image...');

% Save image in the current directory
print(h, '-r0', '-djpeg100', sprintf('cal%d', this_year));

if isSmooth
  x = imread(sprintf('cal%d.jpg', this_year));
  
  % Sometimes, the image size is not an even number. This fixes it.
  matSize = size(x);
  matSize = floor(matSize/2)*2;
  x = x(1:matSize(1),1:matSize(2),:);

  x = double(x);
  xnew = uint8((...
    x(1:2:end,1:2:end,:)+x(2:2:end,1:2:end,:)+...
    x(1:2:end,2:2:end,:)+x(2:2:end,2:2:end,:)...
    )/4);

  imwrite(xnew, sprintf('cal%d.jpg', this_year), 'Quality', 100);
end

% Open image in a web browser
web(sprintf('cal%d.jpg', this_year), '-browser');

close(wait_h);
close(h);

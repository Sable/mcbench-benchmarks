%DEMO_MSOCOLOR   Demo script for MSOCOLOR
%   This script generates the screenshot for MSOCOLOR submission on the
%   MatlabCentral FEX. It takes fairly long time to run this demo as
%   MSOCOLOR, which searches and reads XML files, is called repeatedly.
%   
%   It displays color palettes of 6 randomly chosen Microsoft Office Color
%   Themes (with an exception of the default Office theme, which is always
%   shown). These palettes are identical to those shown by Microsoft Office
%   applications and show the base theme colors, and 5 different shades
%   using 'Darken' and 'Lighten' options of MSOCOLOR.

% Copyright 2012 Takeshi Ikuma
% History:
% rev. - : (03-02-2012) original release

clear; close all; drawnow;

% number of themes to show
N = 2; % rows
M = 3; % columns

% Get MS Office Theme Colors folder
app = Microsoft.Office.Interop.Excel.ApplicationClass;
msopath = char(app.Path);
ver = floor(str2double(char(app.Version))); % Excel version
if msopath(end)==filesep, msopath(end) = ''; end
msopath = sprintf('%s%sDocument Themes %d%sTheme Colors%s',fileparts(msopath),filesep,ver,filesep,filesep);
app.Quit;

% Get color theme XML files
files = dir([msopath '*.xml']);

% randomly choose themes
I = randperm(numel(files));
themes = [{'Office'};regexprep({files(I(1:N*M-1)).name}','.xml$','','once')];

sz = 1;
x = (0:9)*1.25;
y = [5.25 (4:-1:0)];
xlim = [x(1)+0.5 x(end)+1.5];
ylim = [y(end)+0.5 y(1)+1.5];

lt = {'Darken',5
   'Darken',15
   'Darken',25
   'Darken',35
   'Darken',50};
dk = {'Lighten',50
   'Lighten',35
   'Lighten',25
   'Lighten',15
   'Lighten',5}; % lighter
ac = {'Lighten',80
   'Lighten',60
   'Lighten',40
   'Darken',25
   'Darken',50}; % lighterx3, darkerx2

% Draw color palettes
c = zeros(1,1,3);
for n = 1:N
   for m = 1:M
      % place the axes
      pos = [(m-1)/M (N-n)/N 0.99/M 0.9/N];
      axes('Position',pos,'Visible','off','XLim',xlim,'YLim',ylim,'NextPlot','replacechildren');
      
      % print Theme name
      theme = themes{(m-1)*N+n};
      text(mean(xlim),ylim(2),theme,'VerticalAlignment','bottom','HorizontalAlignment','center');
      
      % get theme with TextBackgroundType=1 (default)
      C = msocolor(theme);
      c(:) = C.BackgroundColor;
      image('XData',x(1)+[1 1],'YData',y(1)+[1 1],'CData',c);
      c(:) = C.TextColor;
      image('XData',x(2)+[1 1],'YData',y(1)+[1 1],'CData',c);
      for j = 1:6
         c(:) = C.AccentColors(j,:,:);
         image('XData',x(4+j)+[1 1],'YData',y(1)+[1 1],'CData',c);
      end
      
      % get theme with TextBackgroundType=2
      C = msocolor(theme,'TextBackgroundType',2);
      c(:) = C.BackgroundColor;
      image('XData',x(3)+[1 1],'YData',y(1)+[1 1],'CData',c);
      c(:) = C.TextColor;
      image('XData',x(4)+[1 1],'YData',y(1)+[1 1],'CData',c);
      
      drawnow

      % get different brightness for all
      for i = 1:5
         C = msocolor(theme,lt{i,:});
         c(:) = C.BackgroundColor;
         image('XData',x(1)+[1 1],'YData',y(i+1)+[1 1],'CData',c);
         
         C = msocolor(theme,dk{i,:});
         c(:) = C.TextColor;
         image('XData',x(2)+[1 1],'YData',y(i+1)+[1 1],'CData',c);

         C = msocolor(theme,'TextBackgroundType',2,lt{i,:});
         c(:) = C.BackgroundColor;
         image('XData',x(3)+[1 1],'YData',y(i+1)+[1 1],'CData',c);
         
         C = msocolor(theme,'TextBackgroundType',2,dk{i,:});
         c(:) = C.TextColor;
         image('XData',x(4)+[1 1],'YData',y(i+1)+[1 1],'CData',c);

         C = msocolor(theme,ac{i,:});
         for j = 1:6
            c(:) = C.AccentColors(j,:,:);
            image('XData',x(4+j)+[1 1],'YData',y(i+1)+[1 1],'CData',c);
         end
         
         drawnow
      end
   end
end

% Generate the PNG image (uses EPS Utility Toolbox, another one of my FEX upload).
% epswrite msopalette
% eps2raster('msopalette','png','Resolution',300,'Size',[2 0])
% delete msopalette.eps

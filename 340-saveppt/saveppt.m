% SAVEPPT saves plots to PowerPoint.
% function SAVEPPT(filespec,title,prnopt) saves the current Matlab figure
%  window or Simulink model window to a PowerPoint file designated by
%  filespec.  If filespec is omitted, the user is prompted to enter
%  one via UIPUTFILE.  If the path is omitted from filespec, the
%  PowerPoint file is created in the current Matlab working directory.
%
%  Optional input argument TITLE will add a title to the PowerPoint slide.
%
%  Optional input argument PRNOPT is used to specify additional save options:
%
%    -fHandle   Handle of figure window to save
%    -sName     Name of Simulink model window to save
%    -r###      Set bitmap resolution to ### dots/inch (This applies only to large
%               images which get converted to BMP when captured by the clipboard.)
%
%  Examples:
%  >> saveppt
%       Prompts user for valid filename and saves current figure
%  >> saveppt('junk.ppt')
%       Saves current figure to PowerPoint file called junk.ppt
%  >> saveppt('junk.ppt','Stock Price','-f3')
%       Saves figure #3 to PowerPoint file called junk.ppt with a
%       slide title of "Stock Price".
%  >> saveppt('models.ppt','System Block Diagram','-sMainBlock')
%       Saves Simulink model named "MainBlock" to file called models.ppt
%       with a slide title of "System Block Diagram".
%
%  The command-line method of invoking SAVEPPT will also work:
%  >> saveppt models.ppt 'System Block Diagram' -sMainBlock
%
%  However, if you want to save a specific figure or simulink model
%  without title text, you must use the function-call method:
%  >> saveppt('models.ppt','','-f8')

%Ver 2.2, Copyright 2005, Mark W. Brown, mwbrown@ieee.org
%  changed slide type to include title.
%  added input parameter for title text.
%  added support for int32 and single data types for Matlab 6.0
%  added comments about changing bitmap resolution (for large images only)
%  swapped order of opening PPT and copying to clipboard (thanks to David Abraham)
%  made PPT invisible during save operations (thanks to Noah Siegel)

function saveppt(filespec,titletext,prnopt)

% Establish valid file name:
if nargin<1 | isempty(filespec);
  [fname, fpath] = uiputfile('*.ppt');
  if fpath == 0; return; end
  filespec = fullfile(fpath,fname);
else
  [fpath,fname,fext] = fileparts(filespec);
  if isempty(fpath); fpath = pwd; end
  if isempty(fext); fext = '.ppt'; end
  filespec = fullfile(fpath,[fname,fext]);
end

% Default title text:
if nargin<2
  titletext = '';
end

% Start an ActiveX session with PowerPoint:
ppt = actxserver('PowerPoint.Application');

% Capture current figure/model into clipboard:
if nargin<3
  print -dmeta
else
  print('-dmeta',prnopt)
end

if ~exist(filespec,'file');
  % Create new presentation:
  op = invoke(ppt.Presentations,'Add');
else
  % Open existing presentation:
  op = invoke(ppt.Presentations,'Open',filespec,[],[],0);
end

% Get current number of slides:
slide_count = get(op.Slides,'Count');

% Add a new slide (with title object):
slide_count = int32(double(slide_count)+1);
new_slide = invoke(op.Slides,'Add',slide_count,11);

% Insert text into the title object:
set(new_slide.Shapes.Title.TextFrame.TextRange,'Text',titletext);

% Get height and width of slide:
slide_H = op.PageSetup.SlideHeight;
slide_W = op.PageSetup.SlideWidth;

% Paste the contents of the Clipboard:
pic1 = invoke(new_slide.Shapes,'Paste');

% Get height and width of picture:
pic_H = get(pic1,'Height');
pic_W = get(pic1,'Width');

% Center picture on page (below title area):
set(pic1,'Left',single((double(slide_W) - double(pic_W))/2));
set(pic1,'Top',single(double(slide_H) - double(pic_H)));

if ~exist(filespec,'file')
  % Save file as new:
  invoke(op,'SaveAs',filespec,1);
else
  % Save existing file:
  invoke(op,'Save');
end

% Close the presentation window:
invoke(op,'Close');

% Quit PowerPoint
invoke(ppt,'Quit');

return
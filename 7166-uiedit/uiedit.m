function h=uiedit(varargin),
% UIEDIT multi-line edit box
%   UIEDIT invokes a GUI object which is similar to the edit box available
%   in GUIDE.  The major difference is that the edit object in GUIDE does
%   not allow the user to input more than one line of text.  
%
%   UIEDIT supports:
%       - Scrollbars
%       - Multi-line text
%       - Copy & Paste
%
%   WARNING!!
%   If you are using a version prior to 6.5.1 Matlab 6.5 (R13 SP1)
%   Please see the following documentation for compatability.
%   http://www.mathworks.it/support/solutions/data/1-1ABWL.html;jsessionid=C49Th9nSj1FD1PrK6MyKylJWfCYyMTV8GFDWYvxQt5ZqWpGv5hfN!-660561515?solution=1-1ABWL
%
%   h = UIEDIT returns a handles to the graphic object.
%   SET(h,'property',value) and GET(h,'property') can be used to modify the
%   current object.  Some knowledge of activex controls is required to
%   modify some of the properties.
%
%   Properities are slightly different than most GUI objects.  Type get(h)
%   to see a list of properties.
%
%   example:
%       h = uiedit(gcf,[50,50,460,320]);
%       set(h,'text','This is a uiedit control example')
%
%   See also:  UICONTROL, ACTXCONTROL

%   Created by:  Daniel Claxton

%   Check how many inputs
if nargin,
    if nargin == 1,
        fig = varargin{1};
        position = [0,0,560,420];
    elseif nargin == 2,
        fig = varargin{1};
        position = varargin{2};
    end
else
    fig = gcf;
    position = [0,0,560,420];
end

% Check to see if it's safe to load this activex control
if check_files,
    h = actxcontrol('Forms.TextBox.1',position,fig);
    set_defaults(h);
else
    h = 0;
    disp(' This version of Matlab is not compatible with UIEDIT.m')
    disp(' Please Upgrade to version 6.5.1 or higher')
    disp(' See also: ''uiedit help'' for instructions on fixing this problem')
end

% Set Default Properties
function set_defaults(h),
    h.multiline = 1;
    h.wordwrap = 0;
    h.scrollbars = 3;
%     h.MousePointer = 'fmMousePointerIBeam';

    
function out = check_files

mfil = '\toolbox\matlab\winfun\comcli\private\newprogid.m';
dllfil = '\bin\win32\comcli.dll';

d = pwd;
dd = d;
j = 0;
for i=1:length(d),
    if strcmp(d(i),'\'),
        j = j+1;
%         d(i) = '/';
    end
    if j==2,
        break
    end
end
matlabdir = d(1:i);

fid = fopen([matlabdir mfil]);
for i = 1:3,
    RevisionLine = fgetl(fid);
end
fclose(fid)

Rev = num2str(RevisionLine(13:17));

if Rev >= 1.3,
    out = 1;
else
    out = 0;
end


% Old File
% Copyright 1984-2002 The MathWorks, Inc.
% $Revision: 1.2 $ $Date: 2002/04/09 01:57:43 $

% New File
% Copyright 1984-2002 The MathWorks, Inc.
% $Revision: 1.3 $ $Date: 2002/09/05 19:16:38 $
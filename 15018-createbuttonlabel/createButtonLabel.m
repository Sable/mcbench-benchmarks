function buttonIcon = createButtonLabel(string,varargin)
% createButtonLabel: creates a tightly cropped RGB image (button-label) of a simple text string
%
%          This is very useful for labeling uicontrols (pushbuttons), with the syntax:
%
%                           set(hndl,'cdata',buttonIcon)
%
%          All valid Parameter-Value pairs, INCLUDING TEXT ROTATION, are
%          supported. Note that this function requires the Image Processing
%          Toolbox, and that it triggers the creation of a temporary
%          figure, which will be momentarily visible during
%          button-label creation.
%
%          Allows easy creation of multi-line text for labeling
%          pushbuttons.
%
% SYNTAX:  BUTTONICON = CREATEBUTTONLABEL(STRING,PVs,FIGOPT);
%
% USAGE: buttonIcon = createButtonLabel(string)
%              Create a tightly cropped RGB image of a text object of the
%              simple string indicated in input STRING. Uses default
%              properties (fontname, fontsize, fontweight, fontcolor,
%              bgcolor, rotation, etc.) for text object.
%
%         buttonIcon = createButtonLabel(string,PVs)
%              Provide additional Parameter-Value pairs, either in a cell
%              array of strings, or in a structure of parameters. All PV
%              pairs valid for text objects are supported.
%
%         buttonIcon = createButtonLabel(string,PVs,figOpt)
%              Provides optional argument for controlling the (requisite)
%              temporary figure. By default, the temporary figure will be
%              (visibly) created and destroyed within this function.
%              However, if you will be calling CREATEBUTTONLABEL multiply (labeling
%              tabs in a tabPanel, for instance), it might be less
%              distracting to reuse the same figure, and to destroy the
%              figure after the last call. This parameter will allow you to
%              do so.
%
% ARGUMENTS:
%
%          BUTTONICON: Output RGB image
%
%          STRING: The string to be captured as a tightly-cropped RGB
%              Image.
%
%          PVs (OPTIONAL): Cell array or structure of any parameter-value pairs
%                 valid for TEXT object. (See 'Text Properties' for details.) 
%                 Particularly useful: {'rotation',90} or {'rotation',270}.
%
%          FIGOPT (OPTIONAL): Control parameter for temporary figure. Valid options:
%              1: REUSE/DESTROY (DEFAULT): reuse existing temporary figure, or create
%                 one if it doesn't exist. Destroy figure on completion.
%              2: REUSE existing temporary figure, or create one if it
%                 doesn't exist. Do not destroy figure.
%
% EXAMPLES:
%
%         1) Create cdata to label a vertically-oriented pushbutton, apply
%              structure of text parameters, destroy figure.
%
%         txt.rotation = 270;
%         txt.color = 'r';
%         txt.backgroundcolor = 'y';
%         buttonIcon = createButtonLabel('PRESS',txt);
%
%         2) Create cdata, apply PV pairs, leave figure open for re-use.
%
%         buttonIcon = createButtonLabel('PUSH',{'fontname','Helvetica','fontweight','bold'},2);
%
%         3) Multi-line text on a pushbutton:
%         buttonIcon =  createButtonLabel({'PUSH', 'ME!'},...
%                    {'fontname','Helvetica','fontweight',...
%                     'bold','horizontalAlignment','center',...
%                     'color','r'});
%
% SO: Why is this useful? Try this (and then try it without createButtonLabel!):
%
%         4)
%             x = createButtonLabel('PRESS',...
%                 {'rotation',270,'fontsize',18,'fontweight','b',...
%                 'color','c','backgroundcolor','y'});
%             figure;uicontrol('style','pushbutton','units','pixels',...
%                 'pos',[10 10 60 100],'callback','disp(''I was pushed!'')',...
%                 'backgroundcolor','y','cdata',x);

% Created by Brett Shoelson
% brett.shoelson@mathworks.com
% 05/14/07
%
% Modifications:
% 02/29/08 Force figure into 'normal' (not docked) state
% 06/22/09 Modified at the suggestion of Dave Forstot to allow
%    the creation of multi-line text buttons. (Thanks, Dave.)

% Validate and parse inputs
string = parseValidateInputs(string,varargin{:});

% Depending on figOpt parameter, branch to use/reuse/destroy temporary button-label figure
ExistFig = findobj('tag','tmpcreateButtonLabelfig');
if ~isempty(ExistFig)
    figure(ExistFig);
    clf;
else
    figure('units','pixels','position',[100 100 500 500],'tag','tmpcreateButtonLabelfig','windowstyle','normal');
end


ax = axes('units','pixels','position',[0 0 500 500],'visible','on','xtick',[],'ytick',[],'color','w');
tmp = text(250,250,string,'units','pixels','fontunits','pixels');

% Apply any input Parameter-Value pairs
applyPVs(tmp,PVs);
% Temporarily change fontcolor to black for detection, then return it to
% intended color
currColor = get(tmp,'color');
set(tmp,'color','k');
% Create button-label
F = getframe(ax);
im = im2double(F.cdata(:,:,1));
im = im < 1;
[y,x] = find(im);
set(tmp,'color',currColor);
set(ax,'color',get(tmp,'backgroundcolor'));
buttonIcon = getframe(ax,[min(x(:))-1 500-max(y(:))-1 max(x(:))-min(x(:))+2 max(y(:))-min(y(:))+2]);
buttonIcon = buttonIcon.cdata;

if figOpt == 1
    delete(findobj('tag','tmpcreateButtonLabelfig'));
end

% NESTED FUNCTIONS
    function string = parseValidateInputs(string,varargin)
        error(nargchk(1,3,nargin))
        error(nargoutchk(0,1,nargout))
        if ~(ischar(string) || iscellstr(string))
            try
                string = num2str(string);
            catch
                error('CREATEBUTTONLABEL: Requires at a minimum a single input, which must be a string.')
            end
        end
        % Defaults
        figOpt = 1;
        PVs = [];
        if ~isempty(varargin)
            if ~isempty(varargin{1})
                PVs = varargin{1};
            end
            if nargin == 3
                figOpt = varargin{2};
            end
            if ~ismember(figOpt,1:2)
                error('CREATEBUTTONLABEL: Invalid option for figOpt parameter.')
            end
        end
    end

    function applyPVs(obj,pvarray)
        if isempty(pvarray)
            return;
        end
        if isstruct(pvarray)
            set(obj,pvarray);
        else %Cell
            for ii = 1:2:numel(pvarray)
                set(obj,pvarray{ii},pvarray{ii+1});
            end
        end
    end

end
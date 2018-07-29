function createLineInColorOrder(varargin)
%CREATELINEINCOLORORDER Forces lines to use the colororder of the axes
%   CREATELINEINCOLORORDER ON Enables this feature on the root.
%   CREATELINEINCOLORORDER OFF Disables this feature on the root.
%   CREATELINEINCOLORORDER(H) sets this feature at the ancestry level of H,
%   assuming H is a handle to an axes or figure.
%
%   When you enable this feature on an ancestor, it will force any new and
%   old lines, created in the parent axes that is being plotted into, to
%   obey the 'ColorOrder' of that axes.
%
%   To use this helper function, make sure that the function is always on
%   your MATLAB path, and then enable the feature. 
%
%   Place the enabling code in your "startup.m" file to make it work for
%   all future sessions of MATLAB.  For more information, see the M-file
%   code.
%
%   Greg Aloe
%   09-24-2002
%   v2.0

%   By enabling this feature, your ancestor's 'defaultLineCreateFcn' will
%   be set  to 'createLineInColorOrder'.  By disabling it, the setting is
%   removed.

% v1.0  09-24-2002
% Initial release.
%
% v2.0 02-05-2003
% Added input arguments to turn it on and off.
% Noted that it would be nice to use function handles so that the function
% does not need to always reside on the path, but I want to keep this
% available for backward compatibility, and to work throughout all versions
% of MATLAB.

% Enable/disable the feature if there is an input, or else do the work
if nargin>0
    arg1 = varargin{1};

    % If arg1 is an axes or figure handle, set feature on the handle, 
    %   otherwise, try to toggle feature on root
    if ishandle(arg1) & (strcmp('axes',lower(get(arg1,'type'))) | strcmp('figure',lower(get(arg1,'type'))))
        set(arg1,'DefaultLineCreateFcn','createLineInColorOrder');
    else
        switch arg1
            case {'on','1',1}
                set(0,'DefaultLineCreateFcn','createLineInColorOrder');
            case {'off','0',0}
                set(0,'DefaultLineCreateFcn','remove');
            otherwise
                if isstr(arg1)
                    warning(sprintf('Unknown command option, %s.',varargin{1}));
                else
                    warning('Unknown command option, or not a valid axes or figure handle.');
                end
        end
    end
else
    % Find the line being created and its parent axes
    hline = gcbo;
    hax = get(hline,'parent');
    
    % Get children flipped since objects created first are at bottom of stack
    hlines = flipud(findobj(hax,'type','line'));
    
    % Get the axes' colororder
    colors = get(hax,'colororder');
    ncolors = length(colors);
    
    % Set the colors of each line created in order
    for n = 1:length(hlines)
        num = mod(n,ncolors);
        if num == 0;
            num = ncolors;
        end
        set(hlines(n),'color',colors(num,:))
    end
end
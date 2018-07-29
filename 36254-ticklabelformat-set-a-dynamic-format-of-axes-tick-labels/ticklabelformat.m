function ticklabelformat(hAxes,axName,format)
%TICKLABELFORMAT  Sets axis tick labels format
%
% TICKLABELFORMAT enables setting the format of the tick labels
%
% Syntax:
%    ticklabelformat(hAxes,axName,format)
%
% Input Parameters:
%    hAxes  - handle to the modified axes, such as returned by the gca function
%    axName - name(s) of axles to modify: 'x','y','z' or combination (e.g. 'xy')
%    format - format of the tick labels in sprintf format (e.g. '%.1f V') or a
%             function handle that will be called whenever labels need to be updated
%
%    Note: Calling TICKLABELFORMAT again with an empty ([] or '') format will revert
%    ^^^^  to Matlab's normal tick labels display behavior
%
% Examples:
%    ticklabelformat(gca,'y','%.6g V') - sets y axis on current axes to display 6 significant digits
%    ticklabelformat(gca,'xy','%.2f')  - sets x & y axes on current axes to display 2 decimal digits
%    ticklabelformat(gca,'z',@myCbFcn) - sets a function to update the Z tick labels on current axes
%    ticklabelformat(gca,'z',{@myCbFcn,extraData}) - sets an update function as above, with extra data
%
% Warning:
%    This code heavily relies on undocumented and unsupported Matlab functionality.
%    It works on Matlab 7+, but use at your own risk!
%
% Technical description and more details:
%    http://UndocumentedMatlab.com/blog/setting-axes-tick-labels-format/
%
% Bugs and suggestions:
%    Please send to Yair Altman (altmany at gmail dot com)
%
% Change log:
%    2012-04-18: first version
%
% See also: sprintf, gca

    % Check # of args (we now have narginchk but this is not available on older Matlab releases)
    if nargin < 1
        help(mfilename)
        return;
    elseif nargin < 3
        error('YMA:TICKLABELFORMAT:ARGS','Not enough input arguments');
    end
    
    % Check input args
    if ~ishandle(hAxes) || ~isa(handle(hAxes),'axes')
        error('YMA:TICKLABELFORMAT:hAxes','hAxes input argument must be a valid axes handle');
    elseif ~ischar(axName)
        error('YMA:TICKLABELFORMAT:axName','axName input argument must be a string');
    elseif ~isempty(format) && ~ischar(format) && ~isa(format,'function_handle') && ~iscell(format)
        error('YMA:TICKLABELFORMAT:format','format input argument must be a string or function handle');
    end
    
    % normalize axes name(s) to lowercase
    axName = lower(axName);
    
    if strfind(axName,'x')
        install_adjust_ticklbl(hAxes,'X',format)
    end
    if strfind(axName,'y')
        install_adjust_ticklbl(hAxes,'Y',format)
    end
    if strfind(axName,'z')
        install_adjust_ticklbl(hAxes,'Z',format)
    end

% Install the new tick labels for the specified axes
function install_adjust_ticklbl(hAxes,axName,format)

    % If empty format was specified
    if isempty(format)
        % Remove the current format (revert to default Matlab format)
        set(hAxes,[axName 'TickLabelMode'],'auto')
        setappdata(hAxes,[axName 'TickListener'],[])
        return
    end

    % Determine whether to use the specified format as a
    % sprintf format or a user-specified callback function
    if ischar(format)
        cb = {@adjust_ticklbl axName format};
    else
        cb = format;
    end

    % Now install axis tick listeners to adjust tick labels
    % (use undocumented feature for adjustments)
    ha = handle(hAxes);
    hp = findprop(ha,[axName 'Tick']);
    hl = handle.listener(ha,hp,'PropertyPostSet',cb);
    setappdata(hAxes,[axName 'TickListener'],hl)

    % Adjust tick labels now
    %eventData.AffectedObject = hAxes;
    %adjust_ticklbl([],eventData,axName,format)
    set(hAxes,[axName 'TickLabelMode'],'manual')
    set(hAxes,[axName 'TickLabelMode'],'auto')

% Default tick labels update callback function (used if user did not specify their own function)
function adjust_ticklbl(hProp,eventData,axName,format)	%#ok<INUSL>
    hAxes = eventData.AffectedObject;
    tickValues = get(hAxes,[axName 'Tick']);
    tickLabels = arrayfun(@(x)(sprintf(format,x)),tickValues,'UniformOutput',false);
    set(hAxes,[axName 'TickLabel'],tickLabels)

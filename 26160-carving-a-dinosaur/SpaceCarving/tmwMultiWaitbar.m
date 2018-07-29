function tmwMultiWaitbar( label, value, amnt )
%TMWMULTIWAITBAR: add, remove or update an entry on the multi waitbar
%
%   TMWMULTIWAITBAR(LABEL, VALUE) adds a waitbar for the specified label, or
%   if it already exists updates the value. LABEL must be a string and
%   VALUE a number between zero and one or the string 'Close' to remove the
%   entry Setting value equal to 0 or 'Reset' will cause the progress bar
%   to reset and the time estimate to be re-initialised. 
%
%   TMWMULTIWAITBAR(LABEL,'INCREMENT',AMNT) increments a progress bar by
%   AMNT instead of setting the value explicitly.
% 
%   TMWMULTIWAITBAR(LABEL,'COLOR',color) changes the color of the specified
%   waitbar.
%
%   Examples:
%   >> tmwMultiWaitbar( 'Task 1', 0 );
%   >> tmwMultiWaitbar( 'Task 2', 0 );
%   >> tmwMultiWaitbar( 'Task 1', 0.1 );
%   >> tmwMultiWaitbar( 'Task 2', 'Increment', 0.2 );
%   >> tmwMultiWaitbar( 'Task 2', 'Close' );
%   >> tmwMultiWaitbar( 'Task 1', 'Reset' );
%   >> tmwMultiWaitbae( 'Task 1', 'Color', 'green')
%   >> tmwMultiWaitbae( 'Task 1', 'Color', [1 0 0.5])

%   Copyright 2007-2008 The MathWorks, Inc.
%   $Revision: 33 $Date: 2007-10-17$


persistent on 

switch label
    case 'turn off'
        on = false;
        return
    case 'turn on'
        on = true;
        return
end
if ~isempty(on) && ~on
    return
end

if nargin<2
    error( 'tmwMultiWaitbar:BadSyntax', 'Usage: MULTIWAITBAR(LABEL,VALUE)' );
end

% Try to get hold of the figure
f = findall( 0, 'Type', 'figure', 'Tag', 'MultiProgress' );
if isempty(f)
    f = nCreateFig();
    set( f, 'ResizeFcn', @nRedraw );
else
    f = f(1);
end

% Get the list of entries and see if this one already exists
entries = getappdata( f, 'ProgressEntries' );
if isempty(entries)
    idx = [];
else
    idx = strmatch( label, {entries.label}, 'exact' );
end

% Now work out whether to add, update or remove
if ischar( value ) && ismember( upper(value), {'RESET','ZERO','SHOW'} )
    value = 0;
end
if ischar( value ) && ismember( upper(value), {'INC','INCREMENT'} )
    % Increment an existing value
    if isempty(idx)
        value = amnt;
    else
        value = entries(idx).value + amnt;
    end
end


if ischar( value ) && ismember( upper(value), {'COLOR','COLOUR'} )
    % Increment an existing value
    entries(idx).color = amnt;    
    iSetAppData( f, 'ProgressEntries', entries );
    nUpdateEntry(entries(idx),entries(idx).value);    
    nRedraw();
    return
end


if ischar( value ) && ismember( upper(value), {'DONE','CLOSE'} )
    if ~isempty(idx)
        % Remove the selected entry
        entries = nDeleteEntry( entries, idx );
    end
    if isempty( entries )
        close( f );
        drawnow();
    else
        setappdata( f, 'ProgressEntries', entries );
        nRedraw();
    end
else
    if isempty(idx)
        % Create a new entry
        entries = nAddEntry( entries, label, value );        
        setappdata( f, 'ProgressEntries', entries );
        nRedraw();
        nUpdateEntry(newentry,value);
    else
        % Update the selected entry
        entries(idx,:) = nUpdateEntry( entries(idx,:), value );
        iSetAppData( f, 'ProgressEntries', entries );
    end
end

%-------------------------------------------------------------------------%
    function iSetAppData( src, param, value )
        % Safely set application data into a handle
        if ishandle( src )
            setappdata( src, param, value );
        end
    end

%-------------------------------------------------------------------------%
    function nRedraw( src, evt ) %#ok<INUSD>
        entries = getappdata( f, 'ProgressEntries' );
        p = get( f, 'Position' );
        border = 5;
        textheight = 16;
        barheight = 16;
        panelheight = 10;

        % Check the height is correct
        heightperentry = textheight+barheight+panelheight;
        requiredheight = 2*border + numel(entries)*heightperentry - panelheight;
        if ~isequal( p(4), requiredheight )
            p(2) = p(2) + p(4) - requiredheight;
            p(4) = requiredheight;
            set( f, 'Position', p );
        end
        ypos = p(4) - border;
        width = p(3) - 2*border;
        for ii=1:numel(entries)
            set( entries(ii).labeltext, 'Position', [border ypos-textheight width*0.75 textheight] );
            set( entries(ii).etatext, 'Position', [border+width*0.75 ypos-textheight width*0.25 textheight] );
            ypos = ypos - textheight;
            set( entries(ii).axes, 'Position', [border ypos-barheight width barheight] );
            ypos = ypos - barheight;
            set( entries(ii).panel, 'Position', [-500 ypos-500-panelheight/2 p(3)+1000 500] );
            ypos = ypos - panelheight;
            N=numel(entries(ii).bar)-1;
            for k=1:N
                fade = 0.4;
                if ii == numel(entries)
                    color = entries(ii).color*(1-fade*(N-k)/(N-1));
                else
                    gray = [1,1,1] * mean(entries(ii).color);
                    color = gray*(1-fade*(N-k)/(N-1));
                end
                set(entries(ii).bar(k),'FaceColor',color);                
                set(entries(ii).bar(k),'EdgeColor',color);
            end
            set(entries(ii).bar(N+1),'FaceColor','none')
            set(entries(ii).bar(N+1),'EdgeColor',[0 0 0])
        end
        drawnow();
    end

%-------------------------------------------------------------------------%
    function entry = nUpdateEntry( entry, value )
        % Make sure it's within limits
        value = max(0,value);
        value = min(1,value);
        entry.value = value;
        N=numel(entry.bar)-1;
        colorWidthV = 0.4;
        colorWidthH = 0.01;
        for k=1:N
            
            if value < colorWidthH
                scaling = 0;
            else
                scaling = (k-1)/(N-1);
            end
            colorWidthV_ = colorWidthV*scaling;
            colorWidthH_ = colorWidthH*scaling;
            set( entry.bar(k), 'Position', [colorWidthH_ colorWidthV_ max(0.001,value-2*colorWidthH_) 1-2*colorWidthV_] );
        end
        set( entry.bar(N+1), 'Position', [0 0 max(0.001,value) 1] );
        
        set( entry.labeltext, 'String', sprintf( '%s (%d%%)', entry.label, round(value*100) ) );


        if value <= 0
            % Zero value, so clear the eta
            entry.created = now();
            eta = '';
        else
            elapsedtime = now() - entry.created; % in days by default

            % Only show the remaining time if we've had time to estimate
            if elapsedtime < (5/(60*60*24)) % 5 secs
                % Not enough time has passed since starting, so leave blank
                eta = '';
            else
                % Calculate a rough ETA
                remainingtime = elapsedtime * (1-entry.value) / entry.value;

                if remainingtime > 2
                    eta = sprintf( '%d days', round(remainingtime) );
                else
                    remainingtime = remainingtime * 24; % Convert to hours
                    if remainingtime > 2
                        eta = sprintf( '%d hours', round(remainingtime) );
                    else
                        remainingtime = remainingtime * 60; % Convert to minutes
                        if remainingtime > 2
                            eta = sprintf( '%d mins', round(remainingtime) );
                        else
                            remainingtime = round(remainingtime * 60); % Convert to seconds
                            if remainingtime > 1
                                eta = sprintf( '%d secs', remainingtime );
                            elseif remainingtime == 1
                                eta = '1 sec';
                            else
                                eta = ''; % Nearly done (<1sec)
                            end
                        end
                    end
                end
            end
        end
        set( entry.etatext, 'String', eta );
        drawnow('expose');
    end

%-------------------------------------------------------------------------%
    function entries = nAddEntry( entries, label, value )
        labeltext = uicontrol( 'Style', 'Text', ...
            'String', sprintf( '%s (%d%%)', label, round(value*100) ), ...
            'Parent', f, ...
            'HorizontalAlignment', 'Left' );
        etatext = uicontrol( 'Style', 'Text', ...
            'String', '', ...
            'Parent', f, ...
            'HorizontalAlignment', 'Right' );
        myaxes = axes( ...
            'Units', 'Pixels', ...
            'XLim', [0 1], 'YLim', [0 1], ...
            'XTick', [], 'YTick', [], ...
            'Box', 'on', ...
            'HandleVisibility', 'off', ...
            'Parent', f );
        mypanel = uipanel( 'Parent', f, 'Units', 'Pixels' );
        mybar = zeros(10,1);
        for k=1:10
        mybar(k) = rectangle( 'Parent', myaxes, ...
            'FaceColor', [1 0 0], ...
            'EdgeColor', 0.5*[1 0 0], ...
            'Position', [0 0 max(0.001,value), 1] );
        end
        newentry = struct( ...
            'label', label, ...
            'value', value, ...
            'created', now(), ...
            'labeltext', labeltext, ...
            'etatext', etatext, ...
            'axes', myaxes, ...
            'panel', mypanel, ...
            'bar', mybar, ...
            'color', [1 0 0]);
        if isempty( entries )
            entries = newentry;
        else
            entries = [entries;newentry];
        end       
    end % nAddEntry

%-------------------------------------------------------------------------%
    function entries = nDeleteEntry( entries, idx )
        delete( entries(idx).labeltext );
        delete( entries(idx).etatext );
        delete( entries(idx).axes );
        delete( entries(idx).panel );
        entries(idx,:) = [];
    end % nDeleteEntry

%-------------------------------------------------------------------------%
    function f = nCreateFig()
        f = figure( ...
            'Name', 'Progress', ...
            'Tag', 'MultiProgress', ...
            'Color', get(0,'DefaultUIControlBackgroundColor'), ...
            'MenuBar', 'none', ...
            'ToolBar', 'none', ...
            'NumberTitle', 'off', ...
            'HandleVisibility', 'callback' );
        % Resize
        p = get( f, 'Position' );
        p(3:4) = [450 50];
        set( f, 'Position', p);
        setappdata( f, 'ProgressEntries', [] );
    end % nCreateFig

%-------------------------------------------------------------------------%
end% EOF
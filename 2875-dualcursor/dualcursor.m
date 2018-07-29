function val = dualcursor(state,deltalabelpos,marker_color,datalabelformatfcnh,axh)
%dualcursor       Add dual vertical cursors to a plot
%
%Syntax
%   dualcursor
%   dualcursor('state');
%   dualcursor([X1 X2]);
%   dualcursor('state',deltalabelpos);
%   dualcursor([X1 X2],deltalabelpos);
%   dualcursor('update', ...)       %Updates existing cursors when data has changed
%   dualcursor(..., ..., marker_color_spec);
%   dualcursor(..., ..., ..., fcnhandle);
%   dualcursor(..., ..., ..., ..., axh);
%   val = dualcursor        %return values of the 2 cursors on the current axis
%   val = dualcursor(h)     %return values of the 2 cursors on the axis or line w/handle h
%
%Description
% Easy Mode:
%  dualcursor on    %Turns on data cursors
%  dualcursor off   %Turns off data cursors
%  dualcursor       %Toggles the state of data cursors
%  val = dualcursor %Return the coordinates of the 2 cursors
%      val = [x1 y1 x2 y2]
%
% Interaction:
%  Click on the cursors to drag them around.
%  Click on the cursor label to reposition.
%  If multiple lines are plotted, click on a line to make it active.
%  Right click on a cursor to:
%     - Export the selected region to the workspace
%       (exports as a structure named cursors)
%     - Export the selected region to a new figure
%     - Export cursor data to workspace
%       (exports as a variable named cursordata = [x1 y1 x2 y2])
%     - Remove the cursors from the plot
%  Click on the delta calculation labels to reposition them.
%
% Advanced Options:
% 1.  Specify initial x-coordinates for the cursors
%  dualcursor([x1 x2]);   %Adds cursors at x1, x2
%
% 2.  Specify the location of the text label for displaying x2-x1, y2-y1 results
%  dualcursor([],deltalabelpos);   %Specifies the location to display DeltaX
%                                         %and DeltaY calculations
%  deltalabelpos = [DeltaX_x, DeltaX_y; DeltaY_x, DeltaY_y] in normalized axis units
%  default = [.65 -.08;.9 -.08]  puts them just below the lower right-hand corner.
%  If this is too hard, you can also reposition the labels with your mouse!
%
% 3.  Specifying the color and marker for the cursors
%  dualcursor([],[],marker_color_spec);
%      %Turns on data cursor, using specified marker and color
%      %marker_color_spec is a one or two element string, specifying color and/or marker
%      %style.  >>help plot   for valid marker and color specifiers
%  ex 'go'  - red circles
%     's'   - squares, with default color (red)
%
% 4.  Update the existing cursors when the data in the plot has changed.
%   dualcursor('update');
%     This mode is useful when using the cursors on a live data stream.
%
%  This simply updates the appropriate values to reflect the latest data.  Here's
%  how to do this:
%    - When you initialize the graphics before taking data, make your initial call
%       to dualcursor (dualcursor on, for instance)
%    - In the code that updates the graphics display with new data, call
%   dualcursor update
%
% 5.  Specify custom formatting for the data label showing individual cursor values
%  This is implemented with a function handle (@).  You provide a handle to a
%  specifically formatted function:
%   dualcursor(..., ..., ..., fcnhandle)
%  %Specifies the text and formatting for the data label
%  %fcnhandle is a handle to the function that defines the formatting.  This function
%  %must have the following argument syntax:
%       function textstring = mytextstring(xv,yv);
%       Input:
%         xv          (scalar)  The x cursor value
%         yv          (scalar)  The y cursor value
%       Output:
%         textstring  (string)  The formatted text string
%                     {'string'} Cell array of strings for multi-line display
%
%       Example
%       Create the following function.  save as frequencystring.m
%          function textstring = frequencystring(xv,yv);
%          textstring = {['Amp: ' num2str(yv,'%2g') ' dB']
%                        ['f: ' num2str(xv,'%2g') ' Hz'];};
%    %Use this code when you are ready to call dualcursor
%    fcnhandle = @frequencystring;  %Create handle to your function
%    dualcursor(..., ..., ..., fcnhandle)
%
% 6.  Add cursors to a specific axis (not necessarily current axis).
%   dualcursor(..., ..., ..., ..., axh);
%    Adds the cursors to the axis with handle axh
%    This mode is useful when axis handles might be hidden
%
%
% Example
% %Set up some interesting data
%   load handel
%   Ns = 2^12;
%   Y = fft(y,Ns);
%   Y = 2/Ns*abs(Y(1:Ns/2));
%   df = Fs/Ns;
%   f = (0:1:Ns/2-1)*df;
%  %Plot it
%   figure;
%   plot(f,100*[Y sqrt(Y)])
%   title('My cursor example');
%   xlabel('Frequency (Hz)');
%   ylabel('Amplitude');
%   axis([0 1200 0 inf]);
%
% %Turn on cursors
%   dualcursor
%
% %Turn off cursors
%   dualcursor off
%
% %Place cursors at x=300 and x=400, place DeltaX/DeltaY display in the upper left
% %  hand corner, and use a green square for the cursor.
%   dualcursor([300 400],[.05 1.05; .25 1.05],'gs');
%
% %Move the cursors around. Try moving the data label, too
%
% %Now, wasn't that fun?  Finally, get the current cursor positions
%   val = dualcursor;
%       %val = [x1 y1 x2 y2]
%
%
% NOTE: HandleVisibility of axis must be set to 'on' or 'callback'
%
% see also: DATALABEL, LINELABEL

% This function is provided as an example only.  It has not been
% tested, and therefore, it is not officially supported by The
% MathWorks, Inc.

% Written by Scott Hirsch
% shirsch@mathworks.com
% Copyright 2002-2009 The MathWorks, Inc. 
% This is a (major) modfication of datalabel, available at MATLAB Central

%Parse input arguments
%If output argument, return the cursor values

%See if the user specified a formatting function for the datalabel


if nargin<4 || isempty(datalabelformatfcnh)    %Nope.  Use the default one included here.
    datalabelformatfcnh = @local_maketextstring;
end;

if nargout
    if nargin==0    %Use current axis
        h = gca;
    else
        h = state;
        if strcmp(get(h,'Type'),'line');
            h = get(h,'Parent');
        end;
    end;
    cursors = findobj(h,'Tag','Cursor');
    if length(cursors)==2       %Should be empty (no cursors), or length=2
        for ii=1:2
            cn = getappdata(cursors(ii),'CursorNumber');
            ind = (cn-1)*2+1:cn*2;      %Index into val
            val(ind) = getappdata(cursors(ii),'Coordinates');
        end;
    else
        val = [];
        warning('I could not find any cursors');
    end;
    return
elseif nargin<5 || isempty(axh)    %Did the user specify a handle?
    axh = gca;
end;


%If no input arguments, switch state (turn off/on)
if (nargin==0 & nargout==0) | isempty(state)  %Switch state.  Check current state
    dots = findobj(axh,'Type','line','Tag','Cursor');  %See if there are any cursors
    if isempty(dots)    %None found.  Turn cursors on
        state = 'on';
    else
        state = 'off';
    end;
end;

%Check if the first argument is numeric.  The user is specifying
%  the initial x-coordinates of the markers
if nargin>=1 & isnumeric(state) %First input is x coordinates of markers
    x_init = state(:);

    %error check
    if length(x_init)~=2
        error('First input must be 2 element vector of x coordinates');
    end;
    state = 'on';       %Turn on data cursors.
else        %Default position = 1/3, 2/3 x axis limits
    %    xl = xlim;              %X Limits.  this is the letter L, not the number 1
    if strcmp(get(axh,'Type'),'figure') ||  strcmp(get(axh,'Type'),'uipanel') || strcmp(get(axh,'Type'),'root');    %user clicked on the axis itself; do nothing
        return
    end;


    xl = xlim(axh);
    lim = localObjbounds(axh);  % Problem using objbounds with hggroup objects, so I have a simple version of my own
    lim = lim(1:2);         %x values only
    xl(isinf(xl)) = lim(isinf(xl));
    width = diff(xl);     %Axis width
    x_init = xl(1)+[1/3 2/3]*width;

end;

% Get handle to figure just once
hFig = ancestor(axh,'figure');


switch state
    case 'on'
        %Initialization
        % Set the WindowButtonDownFcn
        % Add the cursors.

        %If there are already some data cursors on this plot, delete them!
        dualcursor('off',[],[],[],axh);

        %Parse user inputs

        %Check for user input of position for delta labels
        if nargin<2 | isempty(deltalabelpos)
            deltalabelpos = [.65 -.08;.9 -.08];            %Use defaults
            %[x1 y1; x2 y2]
        end;


        %Marker and color specification
        if nargin >= 3 ,
            %Parse marker string.  User might specify color, marker, or both
            colors = 'bgrcmyk';
            markers = '+o*.xsdv^><ph';
            for ii=1:length(marker_color)
                col_ind = strfind(colors,marker_color(ii));
                if ~isempty(col_ind)        %It's a color
                    color = marker_color(ii);
                else                        %Try a marker instead
                    mark_ind = strfind(markers,marker_color(ii));
                    if ~isempty(mark_ind)
                        marker = marker_color(ii);
                    end;
                end;
            end;
        end;

        %Handle default marker and color
        if ~exist('color','var'), color = 'r'; end; %set default
        if ~exist('marker','var'), marker = '*'; end; %set default

        %Add the cursors.
        %Ideally, the user specified the 2 x coordinates.
        %If not, just put the cursors somewhere nice.
        lineh = local_findlines(axh);

        %Line data
        if isempty(lineh)
            x1 = 0;
            y1 = 0;

            %             erasemode = 'normal';       %default
        else

            %if multiple lines, define callback to allow for selection

            set(lineh,'ButtonDownFcn', ...
                'setappdata(get(gco,''Parent''),''SelectedLine'',gco);dualcursor(''selectline'',[],[],[],get(gco,''Parent''))');

            %set erasemode to xor.  This speeds things up a ton with large data sets
            %             erasemode = get(lineh,'EraseMode');
            %             set(lineh,'EraseMode','xor');

            lineh = min(lineh);           %Lets just use one line.  This was probably added first
            setappdata(axh,'SelectedLine',lineh); %The currently selected line.

            %Why the last line?  Because it is the first one added
            xl = get(lineh,'XData');
            yl = get(lineh,'YData');
        end;

        %Find nearest value on the line
        [xv1,yv1] = local_nearest(x_init(1),xl,yl);
        [xv2,yv2] = local_nearest(x_init(2),xl,yl);

        %Build the string for the data label
        textstring1 = feval(datalabelformatfcnh,xv1,yv1);
        textstring2 = feval(datalabelformatfcnh,xv2,yv2);

        %Add the data label
        th1 = text(xv1,yv1,textstring1,'FontSize',8,'Tag','CursorText','Parent',axh);
        th2 = text(xv2,yv2,textstring2,'FontSize',8,'Tag','CursorText','Parent',axh);

        %For R13 or higher (MATLAB 6.5), use a background color on the text string
        v=ver('MATLAB');
        v=str2num(v.Version(1:3));
        if v>=6.5
            set(th1,'BackgroundColor','y');
            set(th2,'BackgroundColor','y');
        end;

        yl = ylim(axh);
        lim = localObjbounds(axh);
        lim = lim(3:4);     %y values only
        yl(isinf(yl)) = lim(isinf(yl));

        %Add the cursors
        ph1 = line([xv1 xv1 xv1],[yl(1) yv1 yl(2)], ...
            'Color',color, ...
            'Marker',marker, ...
            'Tag','Cursor', ...
            'UserData',[lineh th1], ...
            'LineStyle','-', ...
            'Parent',axh);
        ph2 = line([xv2 xv2 xv2],[yl(1) yv2 yl(2)], ...
            'Color',color, ...
            'Marker',marker, ...
            'Tag','Cursor', ...
            'UserData',[lineh th2], ...
            'LineStyle','-', ...
            'Parent',axh);

        %Add context menu to the cursors
%         cmenu = uicontextmenu('Parent',get(axh,'Parent'));
        cmenu = uicontextmenu('Parent',hFig);
        set([ph1 ph2],'UIContextMenu',cmenu);

        % Define the context menu items
        item1 = uimenu(cmenu, 'Label', 'Export region to workspace', ...
            'Callback', 'dualcursor(''exportws'',[],[],[],get(gco,''Parent''))');
        item2 = uimenu(cmenu, 'Label', 'Export region to new figure', ...
            'Callback', 'dualcursor(''exportfig'',[],[],[],get(gco,''Parent''))');
        item3 = uimenu(cmenu, 'Label', 'Export cursor data to workspace', ...
            'Callback', 'dualcursor(''exportcursor'',[],[],[],get(gco,''Parent''));');
        item4 = uimenu(cmenu, 'Label', 'Turn cursors off', ...
            'Callback', 'dualcursor(''off'',[],[],[],get(gco,''Parent''))', ...
            'Separator','on');


        setappdata(th1,'Coordinates',[xv1 yv1]);
        setappdata(ph1,'Coordinates',[xv1 yv1]);
        setappdata(th2,'Coordinates',[xv2 yv2]);
        setappdata(ph2,'Coordinates',[xv2 yv2]);
        setappdata(th1,'CursorNumber',1);
        setappdata(ph1,'CursorNumber',1);
        setappdata(th2,'CursorNumber',2);
        setappdata(ph2,'CursorNumber',2);
        setappdata(th1,'FormatFcnH',datalabelformatfcnh);
        setappdata(th2,'FormatFcnH',datalabelformatfcnh);
        setappdata(th1,'Offset',[0 0]);     %Offset for the text label from the data value
        setappdata(th2,'Offset',[0 0]);     %Offset for the text label from the data value

        %     mh = uicontextmenu('Tag','DeleteObject', ...
        %         'Callback','ud = get(gco,''UserData'');delete([gco ud(2)]);');
        %     set([th1 th2],'UIContextMenu',mh);

        set(th1,'UserData',[lineh ph1]);     %Store handle to line
        set(th2,'UserData',[lineh ph2]);     %Store handle to line


        %Calculate Difference
        dx = xv2 - xv1;
        dy = yv2 - yv1;

        %Add display for cursor deltas
        deltah(1) = text(deltalabelpos(1,1),deltalabelpos(1,2),['({x}_{2}-{x}_{1}) = ' num2str(dx,'%+.3f')], ...
            'Units','Normalized', ...
            'HorizontalAlignment','left', ...
            'Tag','CursorDeltaText', ...
            'FontSize',8, ...
            'Interpreter','tex', ...
            'Parent',axh);      %dx
        deltah(2) = text(deltalabelpos(2,1),deltalabelpos(2,2),['{y}_{2}-{y}_{1} = ' num2str(dy,'%+.3f')], ...
            'Units','Normalized', ...
            'HorizontalAlignment','left', ...
            'Tag','CursorDeltaText', ...
            'FontSize',8, ...
            'Interpreter','tex', ...
            'Parent',axh);      %dy

        %Set Application Data.
        setappdata(axh,'Delta_Handle',deltah);
        setappdata(axh,'Marker',marker);
        setappdata(axh,'Color',color);

        s = warning('off','MATLAB:modes:mode:InvalidPropertySet');
        set(hFig,'WindowButtonDownFcn','dualcursor(''down'',[],[],[],get(gco,''Parent''))')
        warning(s)
        set(hFig,'DoubleBuffer','on');       %eliminate flicker

        
        % Set up zoom and pan so that cursors are always displayed
        z = zoom(hFig);
        p = pan(hFig);
        set(z,'ActionPostCallback',@repositionCursors);
        set(p,'ActionPostCallback',@repositionCursors);

        
    case 'down'      % Execute the WindowButtonDownFcn
        htype = get(gco,'Type');
        tag = get(gco,'Tag');
        marker = getappdata(axh,'Marker');
        color  = getappdata(axh,'Color');

        %If it's a movable object (Cursor, CursorText label, or Cursor Delta Text
        %label), make it movable.
        if strcmp(tag,'CursorText') | strcmp(tag,'Cursor') | strcmp(tag,'CursorDeltaText')
            set(gco,'EraseMode','xor')
            set(gcf,'WindowButtonMotionFcn','dualcursor(''move'',[],[],[],get(gco,''Parent''))', ...
                'WindowButtonUpFcn','dualcursor(''up'',[],[],[],get(gco,''Parent''))');
        end;

        if strcmp(tag,'Cursor') %If clicked on a cursor
            %Label the cursor we are moving.  Add a text label just above the plot
            CursorNumber = getappdata(gco,'CursorNumber');
            cnstr = num2str(CursorNumber);

            xl = xlim(axh);
            lim = localObjbounds(axh);
            lim = lim(1:2);     %x values only
            xl(isinf(xl)) = lim(isinf(xl));
            %             yl = lim(3:4);


            xv = getappdata(gco,'Coordinates');
            xv = xv(1);

            %Convert to normalized
            xn = (xv - xl(1))/(xl(2) - xl(1));
            yn = 1.05;

            CNh = text(xn,yn,cnstr, ...
                'Units','Normalized', ...
                'HorizontalAlignment','center', ...
                'Parent',axh);      %dx

            %For R13 or higher (MATLAB 6.5), use a background color on the text string
            v=ver('MATLAB');
            v=str2num(v.Version);
            if v>=6.5
                set(CNh,'BackgroundColor','c');
            end;
            setappdata(gco,'CNh',CNh);

        end

    case 'move'          % Execute the WindowButtonMotionFcn
        htype = get(gco,'Type');
        tag = get(gco,'Tag');
        if ~isempty(gco)

            %Special (simple) case - just repositioning the delta labels
            if strcmp(tag,'CursorDeltaText')    %The cursor delta labels.
                cp = get(axh,'CurrentPoint');
                pt = cp(1,[1 2]);

                %Put into normalized units
                ax = axis;
                lim = localObjbounds(axh);
                ax(isinf(ax)) = lim(isinf(ax));

                pt(1) = (pt(1) - ax(1))/(ax(2)-ax(1));
                pt(2) = (pt(2) - ax(3))/(ax(4)-ax(3));

                set(gco,'Position', [pt 0])
                drawnow
                return
            end;

            %Is this the cursor or the text
            if strcmp(tag,'CursorText')             %The text
                th = gco;
                handles = get(gco,'UserData');
                ph = handles(2);
                slide = 0;      %Don't slide along line; just reposition text
            else                                    %The marker
                ph = gco;
                handles = get(gco,'UserData');
                th = handles(2);
                slide = 1;      %Slide along line to next data point
            end;

            offset = getappdata(th,'Offset');       %Offset from data value

            cp = get(axh,'CurrentPoint');
            pt = cp(1,[1 2]);

            %Constrain to Line
            lh = getappdata(get(th,'Parent'),'SelectedLine');
            %             lh = handles(1);        %Line

            x = cp(1,1);       %first xy values
            y = cp(1,2);       %first xy values

            if slide            %Move to new data value
                xl = get(lh,'XData');
                yl = get(lh,'YData');


                %Get nearest value
                [xv,yv]=local_nearest(x,xl,yl);


                %If we are moving a cursor, must move the cursor number label, too
                if strcmp(tag,'Cursor')
                    %Move the Cursor Number label, too
                    CNh = getappdata(gco,'CNh');
                    pos = get(CNh,'Position');
                    xlm = xlim(axh);
                    lim = localObjbounds(axh);
                    lim = lim(1:2);     %x values only
                    xlm(isinf(xlm)) = lim(isinf(xlm));
                    xn = (xv - xlm(1))/(xlm(2)-xlm(1));
                    set(CNh,'Position',[xn pos(2:3)])
                end;

                yl = ylim(axh);
                lim = localObjbounds(get(lh,'Parent'));
                lim = lim(3:4);     %y values only
                yl(isinf(yl)) = lim(isinf(yl));
                datalabelformatfcnh = getappdata(th,'FormatFcnH');

                textstring = feval(datalabelformatfcnh,xv,yv);
                set(th,'Position', [xv yv 0] + [offset 0],'String',textstring)
                set(ph,'XData',[xv xv xv],'YData',[yl(1) yv yl(2)]);

                setappdata(ph,'Coordinates',[xv yv]);
                setappdata(th,'Coordinates',[xv yv]);

                %Update delta calculation
                cursors = findobj(axh,'Tag','Cursor');
                cn1 = getappdata(cursors(1),'CursorNumber');
                if cn1==2   %Switch order
                    temp = cursors(1);
                    cursors(1) = cursors(2);
                    cursors(2) = temp;
                end;


                deltah = getappdata(axh,'Delta_Handle');    %Handle to cursors

                %Positions of two dualcursors
                xy1 = getappdata(cursors(1),'Coordinates');
                xy2 = getappdata(cursors(2),'Coordinates');


                %Calculate Difference
                dx = xy2(1) - xy1(1);
                dy = xy2(2) - xy1(2);

                set(deltah(1),'String',['({x}_{2}-{x}_{1}) = ' num2str(dx,'%+.3f')]);
                set(deltah(2),'String',['({y}_{2}-{y}_{1}) = ' num2str(dy,'%+.3f')]);

            else                %Just move text around.
                set(th,'Position', [x y 0])
            end;
            drawnow
        end;

    case 'up'           % Execute the WindowButtonUpFcn
        htype = get(gco,'Type');
        tag = get(gco,'Tag');
        if strcmp(tag,'CursorText') | strcmp(tag,'Cursor') | strcmp(tag,'CursorDeltaText');
            set(gco,'EraseMode','Normal')
            set(gcf,'WindowButtonMotionFcn','')

            if strcmp(tag,'CursorText') %If the text label, record it's relative position
                cp = get(axh,'CurrentPoint');
                pt = cp(1,[1 2]);

                coords = getappdata(gco,'Coordinates');
                offset(1) = pt(1) - coords(1);
                offset = pt - coords;
                setappdata(gco,'Offset',offset);
            end;


            if strcmp(tag,'Cursor')        %Delete the temporary cursor number label
                CNh = getappdata(gco,'CNh');
                delete(CNh);
            end;

        end;
        
    case 'selectline'          % User selected a new line to be active
        %Make the selected line bold
        lh = getappdata(axh,'SelectedLine');
        lw = get(lh,'LineWidth');
        set(lh,'LineWidth',5*lw);
        drawnow

        %Update the cursors
        dualcursor('update',deltalabelpos,marker_color,datalabelformatfcnh,axh);

        %Put the line back the way you found it!
        set(lh,'LineWidth',lw);

    case 'update'               %Update the cursor value
        %Find the position of the existing cursors

        cursors = findobj(axh,'Tag','Cursor');
        cd1 = getappdata(cursors(1),'Coordinates');
        cd2 = getappdata(cursors(2),'Coordinates');
        cn1 = getappdata(cursors(1),'CursorNumber');
        cn2 = getappdata(cursors(2),'CursorNumber');
        clear x
        x(cn1) = cd1(1);        %x value of cursor number cn1
        x(cn2) = cd2(1);        %x value of cursor number cn2

        lh = getappdata(axh,'SelectedLine');

        handles = get(cursors(cn1),'UserData');
        th1 = handles(2);
        handles = get(cursors(cn2),'UserData');
        th2 = handles(2);

        offset1 = getappdata(th1,'Offset');       %Offset from data value
        offset2 = getappdata(th2,'Offset');       %Offset from data value


        ylm = ylim(axh);
        lim = localObjbounds(get(lh,'Parent'));
        lim = lim(3:4);     %y values only
        ylm(isinf(ylm)) = lim(isinf(ylm));


        xl = get(lh,'XData');
        yl = get(lh,'YData');


        %Get nearest value
        [xv1,yv1]=local_nearest(x(1),xl,yl);
        [xv2,yv2]=local_nearest(x(2),xl,yl);

        datalabelformatfcnh = getappdata(th1,'FormatFcnH');

        %         textstring1 = {['x=' num2str(xv1)];['y=' num2str(yv1)]};
        %         textstring2 = {['x=' num2str(xv2)];['y=' num2str(yv2)]};
        textstring1 = feval(datalabelformatfcnh,xv1,yv1);
        textstring2 = feval(datalabelformatfcnh,xv2,yv2);
        set(th1,'Position', [xv1 yv1 0] + [offset1 0],'String',textstring1)
        set(th2,'Position', [xv2 yv2 0] + [offset2 0],'String',textstring2)
        set(cursors(cn1),'XData',[xv1 xv1 xv1],'YData',[ylm(1) yv1 ylm(2)]);
        set(cursors(cn2),'XData',[xv2 xv2 xv2],'YData',[ylm(1) yv2 ylm(2)]);
        %Update delta calculation
        deltah = getappdata(axh,'Delta_Handle');    %Handle to delta calculation

        %                 %Positions of two dualcursors
        xy1 = getappdata(cursors(1),'Coordinates');
        xy2 = getappdata(cursors(2),'Coordinates');

        %Calculate Difference
        dx = xv2 - xv1;
        dy = yv2 - yv1;

        set(deltah(1),'String',['{x}_{2}-{x}_{1} ' num2str(dx,'%+.3f')]);
        set(deltah(2),'String',['{y}_{2}-{y}_{1} ' num2str(dy,'%+.3f')]);
        
    case 'exportws'     %Export selected region to workspace
        [xd,yd] = local_extractregion(axh);

        %If there's only one line, don't make the user hassle with cell arrays
        if length(xd)==1
            xd = xd{1};
            yd = yd{1};
        end;

        cursors.xd = xd;
        cursors.yd = yd;

        assignin('base','cursors',cursors);
        disp('Variable: cursors created in workspace');

    case 'exportfig'     %Export selected region to a new figure
        %         [xd,yd,proplist,props] = local_extractregion;
        [xd,yd,hgS] = local_extractregion(axh);

        %Create new plot
        fh = figure;
        ax = axes;
        struct2handle(hgS,ax);

        %Get labels from axes, too
        %Clunky, but it seems to work
        %First, create empty title, xlabel, ylabel
        newhandles(1) = title('');
        newhandles(2) = xlabel('');
        newhandles(3) = ylabel('');

        %Get strings from original plot
        props = {'Title','xlabel','ylabel'};
        vals = get(axh,props);
        handles = [vals{:}];
        str = get(handles,'String');

        %Set the new strings to match
        set(newhandles,{'String'},str)

    case 'exportcursor'
        % Get cursor coordinates
        cursordata = dualcursor(axh);
        
        % Push the data into the base workspace.
        assignin('base','cursordata',cursordata);
        disp('Variable: cursordata created in workspace');

    case 'off'   % Unset the WindowButton...Fcns
        % set(get(axh,'Parent'),'WindowButtonDownFcn','','WindowButtonUpFcn','')

        s = warning('off','MATLAB:modes:mode:InvalidPropertySet');
        set(hFig,'WindowButtonDownFcn','','WindowButtonUpFcn','')
        warning(s)
        

        h1 = findobj(axh,'Tag','CursorText');       %All text
        h2 = findobj(axh,'Tag','Cursor');           %The cursors
        h3 = findobj(axh,'Tag','CursorDeltaText');           %The cursors

        lineh = local_findlines(axh);
        set(lineh,'ButtonDownFcn','');

        %         erasemode = getappdata(axh,'OriginalEraseMode');
        %         if isempty(erasemode), erasemode = 'normal'; end;   %handles first time
        %         set(local_findlines(axh),'EraseMode',erasemode);

        delete([h1;h2;h3]);

end %switch/case on action
end

% function hFig = figHandle(axh)
% % Get the handle to the parent figure
% hFig = ancestor(axh,'figure');
% end

function repositionCursors(~,ev)
% Reposition Cursors so that they are both on the axes
% Useful after zooming and panning

axh = ev.Axes;

% Get axis limits. Pretend limits are a little smaller.  This helps pull
% cursor in from edge
xLimits = xlim(axh).*[1.02 .98];

% Get locations of each cursor
cursors = findobj(axh,'Tag','Cursor');
cd1 = getappdata(cursors(1),'Coordinates');
cd2 = getappdata(cursors(2),'Coordinates');
cn1 = getappdata(cursors(1),'CursorNumber');
cn2 = getappdata(cursors(2),'CursorNumber');
xCursors(cn1) = cd1(1);        %x value of cursor number cn1
xCursors(cn2) = cd2(1);        %x value of cursor number cn2

% If cursor is off left edge, snap left
% If cursor is off right edge, snap right

% First cursor
xCursors(1) = max([xLimits(1) xCursors(1)]); % Bring to left edge if needed
xCursors(1) = min([xLimits(2) xCursors(1)]); % Bring to right edge if needed

% Second cursor
xCursors(2) = max([xLimits(1) xCursors(2)]); % Bring to left edge if needed
xCursors(2) = min([xLimits(2) xCursors(2)]); % Bring to right edge if needed

% If both cursors are on an edge, put one in middle
if xCursors(1)==xCursors(2)
    if xCursors(1) == xLimits(1)        % Left edge.  #2 to middle
        xCursors(2) = mean(xLimits);
    elseif xCursors(1)== xLimits(2)     % Right edge. #1 to middle
        xCursors(1) = mean(xLimits);
    end
end

% Put cursors in new positions
dualcursor(xCursors)



end

function [xv,yv]=local_nearest(x,xl,yl)
%Inputs:
% x   Selected x value
% xl  Line Data (x)

%Find nearest value of [xl] to (x)
%Special Case: Line has a single non-singleton value
if sum(isfinite(xl))==1
    fin = find(isfinite(xl));
    xv = xl(fin);
    yv = yl(fin);
else
    %Normalize axes
    xlmin = min(xl);
    xlmax = max(xl);
    xln = (xl - xlmin)./(xlmax - xlmin);
    xn = (x - xlmin)./(xlmax - xlmin);


    %Find nearest x value only.
    c = abs(xln - xn);

    [junk,ind] = min(c);

    %Nearest value on the line
    xv = xl(ind);
    yv = yl(ind);
end;
end

function textstring = local_maketextstring(xv,yv)
textstring = {['x = ' num2str(xv,'%2g')];
    ['y = ' num2str(yv,'%2.2g')]};
end

function [xd,yd,hgS] = local_extractregion(axh)
val = dualcursor(axh);

%Find all lines
lineh = local_findlines(axh);

Nl = length(lineh);

%Get all line properties, so we can reproduce the appearance
hgS = handle2struct(lineh);       %Get properties

xd = get(lineh,'XData');
yd = get(lineh,'YData');

%Figure out the index into these lines that val corresponds to
x1ind = zeros(Nl,1);
x2ind = zeros(Nl,1);

%Special handling for single line case
if Nl==1
    xd= {xd};
    yd = {yd};
end;

for ii = 1:Nl
    x1ind(ii) = max(find(xd{ii}<=val(1)));
    x2ind(ii) = max(find(xd{ii}<=val(3)));

    %Keep data from this region only
    xd{ii} = xd{ii}(x1ind(ii):x2ind(ii));
    yd{ii} = yd{ii}(x1ind(ii):x2ind(ii));

    %Update handle structure, to make plotting really easy
    hgS(ii).properties.XData = xd{ii};
    hgS(ii).properties.YData = yd{ii};

end;
end

function lineh = local_findlines(axh);
lineh = findobj(axh,'Type','line');        %Find a line to add cursor to
dots = findobj(axh,'Type','line','Tag','Cursor');  %Ignore existing cursors
lineh = setdiff(lineh,dots);

%Ignore lines with only one or two values - these are probably annotations of some
%sort
xdtemp = get(lineh,'XData');
linehtemp = lineh;
lineh=[];
if ~iscell(xdtemp)      %If there's only one line, force data into a cell array
    xdtemp = {xdtemp};
end;

for ii=1:length(xdtemp);
    if length(xdtemp{ii})>2
        lineh = [lineh; linehtemp(ii)];
    end;
end;
end

function lim = localObjbounds(axh);
% Get x limits of all data in axes axh
kids = get(axh,'Children');
xmin = Inf; xmax = -Inf;
ymin = Inf; ymax = -Inf;
for ii=1:length(kids)
    try % Pass through if can't get data.  hopefully we hit at least one
        xd = get(kids(ii),'XData');
        xmin = min([xmin min(xd(:))]);
        xmax = max([xmax max(xd(:))]);

        yd = get(kids(ii),'YData');
        ymin = min([ymin min(yd(:))]);
        ymax = max([ymax max(yd(:))]);
    end
end
% Nuclear option, in case things went really bad
xmin(xmin==Inf) = 0;  xmax(xmax==-Inf) = 1;
ymin(ymin==Inf) = 0;  ymax(ymax==-Inf) = 1;

lim = [xmin xmax ymin ymax];
end

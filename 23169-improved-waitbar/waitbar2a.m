function fout = waitbar2a(x, whichbar, varargin)
% WAITBAR2a - Displays wait bar with fancy color shift effect
%
% Adaptation of the MatLab standard waitbar function:
%
%   H = WAITBAR2A(X,'title', property, value, property, value, ...)
%   creates and displays a waitbar of fractional length X.  The
%   handle to the waitbar figure is returned in H.
%   X should be between 0 and 1.  Optional arguments property and
%   value allow to set corresponding waitbar figure properties.
%   Property can also be an action keyword 'CreateCancelBtn', in
%   which case a cancel button will be added to the figure, and
%   the passed value string will be executed upon clicking on the
%   cancel button or the close figure button.
%
%   WAITBAR2A(X) will set the length of the bar in the most recently
%   created waitbar window to the fractional length X.
%
%   WAITBAR2A(X, H) will set the length of the bar in waitbar H
%   to the fractional length X.
%
%	WAITBAR2A(X, H), where H is the handle to a uipanel GUI object, will
%	initialize the waitbar inside that uipanel, rather than in its own
%	window.
%
%   WAITBAR2A(X, H, 'updated title') will update the title text in
%   the waitbar figure, in addition to setting the fractional
%   length to X.
%
%   WAITBAR2A is typically used inside a FOR loop that performs a
%   lengthy computation.  A sample usage is shown below:
%
%       h = waitbar2a(0,'Please wait...', 'BarColor', 'g');
%       for i = 1:100,
%           % computation here %
%           waitbar2a(i/100, h);
%       end
%       close(h);
%
% Examples for the 'BarColor' option:
%   - Standard color names: 'red', 'blue', 'green', etcetera
%   - Standard color codes: 'r', 'b', 'k', etcetera
%   - A RGB vector, such as [.5 0 .5] (deep purple)
%   - Two RGB colors in a matrix, such as [1 0 0; 0 0 1] (gradient red-blue)
%
% The latter example shows how to create a custom color-shift effect. The top
% row of the 2x3 matrix gives the initial color, and the bottom row the
% end color.
%
%   Clay M. Thompson 11-9-92
%   Vlad Kolesnikov  06-7-99
%   Jasper Menger    12-5-05 ['BarColor' option added, code cleaned up]
%   Ross L. Hatton   02-4-09 [Added option to put progress bar into a GUI
%   uipanel, and support for decrementing the waitbar display (useful for
%   resetting an embedded waitbar)
%   (Copyright 1984-2002 The MathWorks, Inc.)

if nargin >= 2
    if ischar(whichbar)
        % We are initializing
        type = 2; 
        name = whichbar;
    elseif isnumeric(whichbar)
		% check if the handle is a handle to an existing waitbar, or is the
		% handle of a uipanel to create a waitbar into
		
		if strcmp(get(whichbar,'Tag'),'TMWWaitbar')
			% We are updating an existing waitbar, given a handle
			type = 1; 
			f    = whichbar;
			
		elseif strcmp(get(whichbar,'Type'),'uipanel')
			% We are creating a new waitbar in an existing ui panel
			type = 3;
			f	 = whichbar;
			name = get(whichbar,'Title'); %pull the existing title, if any
		else
			
			error('Handle inputs should be either existing waitbars or uipanels')
			
		end
		
    else
        error(['Input arguments of type ', class(whichbar), ' not valid.']);
    end
elseif nargin == 1
	% If only given one argument, apply to the first waitbar, or create a
	% new one if none exist (this search will ignore waitbars which have
	% been embedded into uipanels)
    f = findobj(allchild(0), 'flat', 'Tag', 'TMWWaitbar');
    if isempty(f)
        type = 2;
        name = 'Waitbar';
    else
        type = 1;
        f    = f(1);
    end
else
    error('Input arguments not valid.');
end

% Progress coordinate (0 - 100%)
x = max(0, min(100 * x, 100));


switch type
    case 1
        % waitbar(x) update
        p = findobj(f, 'Tag', 'progress');
        l = findobj(f, 'Tag', 'background');
        if isempty(f) || isempty(p) || isempty(l),
            error('Couldn''t find waitbar handles.');
        end
        xpatch  = [0 x x 0];
        xline   = get(l, 'XData');
		udata   = get(f, 'UserData');
        b_map   = udata.colormap;
        p_color = b_map(floor(x / 100 * (size(b_map,1)-1)) + 1, :);
		
		% Check to see if the waitbar is being decremented. If it is, then
		% temporarily set the erasemode of the progress bar to "normal"
		oldxpatch = get(p,'XData');
		if x < oldxpatch(2)
			
			set(p,'EraseMode','normal')
			
		end
		
        set(p, 'XData'    , xpatch);
        set(p, 'FaceColor', p_color);
        set(l, 'XData'    , xline);

        if nargin > 2
            % Update waitbar title
            hAxes  = findobj(f, 'type', 'axes');
            hTitle = get(hAxes, 'title');
            set(hTitle, 'string', varargin{1});
		end
		
		% make sure that the erase mode on the progress bar is back to "none"
		set(p,'EraseMode','none')

    case 2
        % waitbar(x,name) initialize
        vertMargin = 0;
        if nargin > 2
            % we have optional arguments: property-value pairs
            if rem(nargin, 2) ~= 0
                error( 'Optional initialization arguments must be passed in pairs' );
            end
        end

        % Set units to points, and put the waitbar in the centre of the screen
        oldRootUnits = get(0,'Units');
        set(0, 'Units', 'points');
        
        screenSize     = get(0,'ScreenSize');
        axFontSize     = get(0,'FactoryAxesFontSize');
        pointsPerPixel = 72/get(0,'ScreenPixelsPerInch');
        width          = 360 * pointsPerPixel;
        height         = 75 * pointsPerPixel;
        pos            = [screenSize(3) / 2 - width / 2, ...
                          screenSize(4) / 2 - height / 2, ...
                          width, height];



        f = figure(...
            'Units'        , 'points', ...
            'BusyAction'   , 'queue', ...
            'Position'     , pos, ...
            'Resize'       , 'off', ...
            'CreateFcn'    , '', ...
            'NumberTitle'  , 'off', ...
            'IntegerHandle', 'off', ...
            'MenuBar'      , 'none', ...
            'Interruptible', 'off', ...
            'Visible'      , 'off');


		%Set the figure properties and get color information from input
		%arguments
		[f, waitbartext, cancelBtnFcn] = propset(f,varargin);
		
		%If the user called for the creation of a cancel button, make it
		if ~isempty(cancelBtnFcn)
			% Create a cancel button
			cancelBtnHeight = 23 * pointsPerPixel;
			cancelBtnWidth  = 60 * pointsPerPixel;
			newPos          = pos;
			vertMargin      = vertMargin + cancelBtnHeight;
			newPos(4)       = newPos(4) + vertMargin;
			callbackFcn     = cancelBtnFcn;
			set(f, 'Position', newPos, 'CloseRequestFcn', callbackFcn);
			cancelButt = uicontrol(...
				'Parent'       , f, ...
				'Units'        , 'points', ...
				'Callback'     , callbackFcn, ...
				'ButtonDownFcn', callbackFcn, ...
				'Enable'       , 'on', ...
				'Interruptible', 'off', ...
				'String'       , 'Cancel', ...
				'Tag'          , 'TMWWaitbarCancelButton', ...
				'Position'     , [pos(3) - cancelBtnWidth * 1.4, 7, ...
								  cancelBtnWidth, cancelBtnHeight]); 
		end

        % -----------------------------------------------------------------
       
        % Create axes
        axNorm = [.05 .3 .9 .2];
        axPos  = axNorm .* [pos(3:4), pos(3:4)] + [0 vertMargin 0 0];
        h = axes(...
            'XLim'          , [0 100], ...
            'YLim'          , [0 1], ...
            'Box'           , 'on', ...
            'Units'         , 'Points', ...
            'FontSize'      , axFontSize, ...
            'Position'      , axPos, ...
            'XTickMode'     , 'manual', ...
            'YTickMode'     , 'manual', ...
            'XTick'         , [], ...
            'YTick'         , [], ...
            'XTickLabelMode', 'manual', ...
            'XTickLabel'    , [], ...
            'YTickLabelMode', 'manual', ...
            'YTickLabel'    , []);

        % Display text on top of axes
        tHandle       = title(name);
        tHandle       = get(h,'title');
        oldTitleUnits = get(tHandle,'Units');
        tExtent       = get(tHandle,'Extent');
        set(tHandle, 'Units', 'points', 'String', name, 'Units', oldTitleUnits);

        % Make sure the lay-out is OK
        titleHeight = tExtent(4) + axPos(2) + axPos(4) + 5;
        if titleHeight > pos(4)
            pos(4)      = titleHeight;
            pos(2)      = screenSize(4) / 2 - pos(4) / 2;
            figPosDirty = true;
        else
            figPosDirty = false;
        end
        if tExtent(3) > pos(3) * 1.1;
            pos(3)       = min(tExtent(3) * 1.1, screenSize(3));
            pos(1)       = screenSize(3) / 2 - pos(3) / 2;
            axPos([1,3]) = axNorm([1, 3]) * pos(3);
            figPosDirty  = true;
            set(h, 'Position', axPos);            
        end
        if figPosDirty
            set(f, 'Position', pos);
		end


		%Draw the progress bar
		draw_progress_bar(f,h,x);
        
		% Make figure visible, and restore the original units
        set(f, 'HandleVisibility', 'Callback', 'Visible', 'on');
        set(0, 'Units', oldRootUnits);

		   
	case 3
        % waitbar(x,uipanel_handle) initialize waitbar inside a uipanel

		if nargin > 2
            % we have optional arguments: property-value pairs
            if rem(nargin, 2) ~= 0
                error( 'Optional initialization arguments must be passed in pairs' );
            end
		end

		%Get the default units and font size
        axFontSize     = get(0,'FactoryAxesFontSize');
		
		[f, waitbartext, cancelBtnFcn] = propset(f,varargin);

		
		%%%%
		%Geometry of the waitbar, relative to the uipanel
		bar_length			= .96;
		bar_height			= .4;
		bar_vertical_margin = .1;
		text_to_bar_height	= .5;
		button_to_bar_height = .8;
		button_to_bar_length = .3;
		button_to_bar_right_align = 0;
		
		%derived measures
		bar_horizontal_margin = .5*(1-bar_length);
		center_above_bar = 1 - .5*(1-bar_height-bar_vertical_margin);
		
		
		
		%If the user called for the creation of a cancel button, make it
		if ~isempty(cancelBtnFcn)
			% Create a cancel button
			cancelBtnHeight = bar_height * button_to_bar_height;
			cancelBtnWidth  = bar_length * button_to_bar_length;
			cancelBtnLeft   = 1 - bar_horizontal_margin - ...
				button_to_bar_right_align - cancelBtnWidth;
			cancelBtnBottom = center_above_bar - .5*cancelBtnHeight;

			cancelBtnPos = [cancelBtnLeft cancelBtnBottom cancelBtnWidth cancelBtnHeight];
			
			callbackFcn     = [cancelBtnFcn];
			cancelButt = uicontrol(...
				'Parent'       , f, ...
				'Units'        , 'normalized', ...
				'Callback'     , callbackFcn, ...
				'ButtonDownFcn', callbackFcn, ...
				'Enable'       , 'on', ...
				'Interruptible', 'off', ...
				'String'       , 'Cancel', ...
				'Tag'          , 'TMWWaitbarCancelButton', ...
				'Position'     , cancelBtnPos); 
		end

        % -----------------------------------------------------------------
			
        % Create axes for the bar
		axPos = [bar_horizontal_margin bar_vertical_margin bar_length bar_height];
        h = axes(...
            'XLim'          , [0 100], ...
            'YLim'          , [0 1], ...
            'Box'           , 'on', ...
            'FontSize'      , axFontSize, ...
            'Position'      , axPos, ...
            'XTickMode'     , 'manual', ...
            'YTickMode'     , 'manual', ...
            'XTick'         , [], ...
            'YTick'         , [], ...
            'XTickLabelMode', 'manual', ...
            'XTickLabel'    , [], ...
            'YTickLabelMode', 'manual', ...
            'YTickLabel'    , [], ...
			'Parent'        , f);

        % Display text on top of axes
          tHandle       = title(h,waitbartext,'FontUnits','normalized','FontSize',text_to_bar_height);
	



		%Initialize the progress bar
		draw_progress_bar(f,h,x);
        
        % Make figure visible, and restore the original units
        set(f, 'HandleVisibility', 'Callback', 'Visible', 'on');
		
end % of case
drawnow;

% Pass on figure handles to output
if nargout == 1,
    fout = f;
end


end %main function

%Initialization function that handles common code for figure or uipanel
%waitbars
function [f, waitbartext, cancelBtnFcn] = propset(f,propargs)


	% Default color shift: dark red -> light
	barcolor1 = [0.5 0 0];
	barcolor2 = [1.0 0 0];

	%Set the tag to show that this is a waitbar
	set(f,'Tag','TMWWaitbar');
	
	%set default waitbartext
	waitbartext = 'Waitbar';
	
	%set default empty cancelbtnfcn
	cancelBtnFcn = [];

	%%%%%%%%%%%%%%%%%%%%%
	% set figure properties as passed to the function
	% pay special attention to the 'cancel' request
	% also, look for the 'waitbartext' option, which acts like 'name' when
	% initializing into a uipanel
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	if nargin > 1
		propList         = propargs(1:2:end);
		valueList        = propargs(2:2:end);
		cancelBtnCreated = 0;
		for ii = 1:length(propList)
			try
				if strcmpi(propList{ii}, 'createcancelbtn')
					cancelBtnFcn = valueList{ii};
				elseif strcmpi(propList{ii}, 'barcolor')
					% Set color of waitbar
					barcolor = valueList{ii};
					if ischar(barcolor)
						% Character color input: convert color code or name to RGB vector
						switch lower(barcolor)
							case {'r', 'red'}    , barcolor2 = [1 0 0];
							case {'g', 'green'}  , barcolor2 = [0 1 0];
							case {'b', 'blue'}   , barcolor2 = [0 0 1];
							case {'c', 'cyan'}   , barcolor2 = [0 1 1];
							case {'m', 'magenta'}, barcolor2 = [1 0 1];
							case {'y', 'yellow'} , barcolor2 = [1 1 0];
							case {'k', 'black'}  , barcolor2 = [0 0 0];
							case {'w', 'white'}  , barcolor2 = [1 1 1];
							otherwise            , barcolor2 = rand(1, 3);
						end
						% Color shift: dark -> light
						barcolor1 = 0.5 * barcolor2;
					else
						% RGB vector color input
						barcolor1 = barcolor(1, :);
						if size(barcolor, 1) > 1
							barcolor2 = barcolor(2, :);
						else
							barcolor2 = barcolor1;
						end
					end % of BarColor option
				elseif strcmpi(propList{ii}, 'waitbartext') 
					waitbartext = valueList{ii};
				else
					% simply set the prop/value pair of the figure
					set(f, propList{ii}, valueList{ii});
				end
			catch
				% Something went wrong, so display warning
				warning('Could not set property ''%s'' with value ''%s'' ', propList{ii}, num2str(valueList{ii}));
			end % of try
		end % of proplist loop
	end % of setting figure properties
	
	
	% Create two color gradient colormap
	color_res = 64;
	b_map = [linspace(barcolor1(1),barcolor2(1),color_res)',...
		linspace(barcolor1(2),barcolor2(2),color_res)',...
		linspace(barcolor1(3),barcolor2(3),color_res)'];

	%Store the b_map into the userdata for the panel
	udata = get(f,'UserData'); %To make sure we don't wipe out any other UserData
	udata.colormap = b_map;
	set(f, 'UserData', udata);
	
end


function draw_progress_bar(f,h,x)

	%get the colormap data
	udata = get(f,'UserData');
	b_map = udata.colormap;
	
	% Draw the bar
	xprogress  = [0 x x 0];
	yprogress  = [0 0 1 1];
	xbackground   = [100 0 0 100];
	ybackground   = [0 0 1 1];
	p_color = b_map(floor(x / 100 * (size(b_map,1)-1)) + 1, :);
	l_color = get(gca, 'XColor');
	p       = patch(xprogress, yprogress, p_color, 'Tag', 'progress', 'EdgeColor', 'none', 'EraseMode', 'none','Parent',h);
	l       = patch(xbackground, ybackground, 'w', 'Tag', 'background', 'FaceColor', 'none', 'EdgeColor', l_color, 'EraseMode', 'none','Parent',h);

end
function h_group = im_pix_line(h_parent,x_init,y_init)
%IM_PIX_LINE Create draggable and resizable line pixel by pixel.
% H = IM_PIX_LINE(HPARENT, X, Y) creates a draggable line on
%   the object specified by HPARENT.  The function returns H, a handle to
%   the line, which is an hggroup object.  HPARENT specifies the hggroups's
%   parent, which is typically an axes object, but can also be any other
%   object that can be the parent of an hggroup. X and Y specify the
%   initial end point positions of the line in the form
%   X = [X1 X2], Y =[Y1 Y2].
%
%   A draggable line can be dragged interactively using the mouse.
%
%   The draggable line has a context menu associated with it that allows you to
%   copy the current end point positions to the clipboard in the form
%   [X1 Y1; X2 Y2] and change the color used to display the line.
%
%   API Function Syntaxes
%   ---------------------
%   A draggable line contains a structure of function handles, called
%   an API, that can be used to manipulate it.  To retrieve this
%   structure from the draggable line, use the IPTGETAPI function.
%
%       API = IPTGETAPI(H)
%
%   Functions in the API, listed in the order of the structure fields, include:
%
%   setPosition
%
%       Sets the end point positions of the line.
%
%           api.setPosition(X,Y)
%           api.setPosition([X1 Y1; X2 Y2])
%
%   getPosition
%
%       Returns the end point positions of the line.
%
%           pos = api.getPosition()
%
%       where pos is a 2-by-2 array [X1 Y1; X2 Y2].
%
%   delete
%
%       Deletes the draggable line associated with the API.
%
%           api.delete()
%
%   setColor
%
%       Sets the color used to draw the draggable line.
%
%           api.setColor(new_color)
%
%       where new_color is a three-element vector specifying an RGB
%       value.
%
%   addNewPositionCallback
%
%       Adds the function handle FCN to the list of new-position callback
%       functions.
%
%           id = api.addNewPositionCallback(fcn)
%
%       Whenever the draggable line changes its position, each
%       function in the list is called with the syntax:
%
%           fcn(pos)
%
%       where pos is a 2-by-2 array [X1 Y1; X2 Y2].
%
%       The return value, id, is used only with removeNewPositionCallback.
%
%   removeNewPositionCallback
%
%       Removes the corresponding function from the new-position callback
%       list.
%
%           api.removeNewPositionCallback(id)
%
%       where id is the identifier returned by api.addNewPositionCallback.
%
%   setDragConstraintFcn
%
%       Sets the drag constraint function to be the specified function
%       handle, fcn.
%
%           api.setDragConstraintFcn(fcn)
%
%       Whenever the draggable line is moved or resized because of a mouse drag,
%       the constraint function is called using the syntax:
%
%           constrained_position = fcn(new_position)
%
%       where new_position is a 2-by-2 array [X1 Y1; X2 Y2].
%
%       This allows a client, for example, to control where the line may be
%       moved and how the line may be resized.
%
%   getDragConstraintFcn
%
%       Returns a function handle to the current drag constraint function.
%
%           fcn = api.getDragConstraintFcn()
%
%   Remarks
%   -------
%   If you use IM_PIX_LINE with an axis that contains an image object, 
%   and do not specify a drag constraint function, users can drag
%   the point outside the extent of the image and lose the point.
%   When used with an axis created by the PLOT function, the axis
%   limits automatically expand to accommodate the movement of
%   the point.    
%    
%   Examples
%   --------
%       % Use a custom color for displaying the line.
%       figure, imshow('pout.tif');
%       h = im_pix_line(gca,[10 100], [100 100]);
%       api = iptgetapi(h);
%       api.setColor([0 1 0]);
%       % Now, explore the context menu of the draggable line by right
%       % clicking on the line.
%       % Try to zoom in and out, you will find the line is drawed pixel
%       % by pixel
%
%       % Use addNewPositionCallback API function.
%       figure, imshow('pout.tif');
%       h = im_pix_line(gca,[10 100], [100 100]);
%       api = iptgetapi(h);
%       id = api.addNewPositionCallback(@(pos) title(mat2str(pos,3)));
%       % Now move the mouse, note that the 2-by-2 position vector of the
%       % line is displayed in the title above the image.  Finally, remove
%       % the callback using removeNewPositionCallback
%       api.removeNewPositionCallback(id);
%
%       % Use makeConstrainToRectFcn to prevent dragging out line outside
%       % extent of image. 
%       figure, imshow('pout.tif');
%       h = im_pix_line(gca,[10 100], [100 100]);
%       api = iptgetapi(h);
%       % IMPORTANT: use 'imline' here since makeConstrainToRectFcn can
%       % only recognize one of the imline, imrect, impoint !!!
%       fcn = makeConstrainToRectFcn('imline',get(gca,'XLim'),get(gca,'YLim'));
%       api.setDragConstraintFcn(fcn);
%
%   See also IMPOINT, IMRECT, IPTGETAPI, makeConstrainToRectFcn.

%   Copyright 2004-2005 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2005/12/12 23:22:09 $
%   
%   adopted by gauss.1982@gmali.com
%   15:52 2006-12-15 $
%

iptchecknargin(3, 3, nargin, mfilename);
if ~ishandle(h_parent)
    error('Images:im_pix_line:invalidHandle', ...
        'HPARENT must be a valid graphics handle.');
end
if strcmp(get(h_parent, 'type'), 'axes')
    h_axes = h_parent;
else
    h_axes = ancestor(h_parent, 'axes');
    if isempty(h_axes)
        error('Images:im_pix_line:noAxesAncestor', ...
            'HPARENT must be a descendent of an axes object.');
    end
end

try
    h_group = hggroup('ButtonDownFcn', @startDrag, 'Parent', h_parent);
catch
    error('Images:im_pix_line:failureToParent', ...
        'HPARENT must be able to have an hggroup object as a child.');
end

%Returns API used to draw line graphic.
draw_api = pixLineSymbol(h_group);

% Initialize position variable for managing end point positions of line.
% This position variable is created to allow for abstraction of drag
% behavior in future.  Position is in the form [X1 Y1; X2 Y2]
position = [reshape(x_init,2,1),reshape(y_init,2,1)];

% constraint_function is used by dragMotion() to give a client the
% opportunity to constraint where the draggable line can be
% dragged.
drag_constraint_function  = identityFcn;

% new_position_callback_functions is used by sendNewPosition() to
% notify interested clients whenever the rectangle position changes.
new_position_callback_functions = makeList;

% Pattern for set associated with callbacks that get called as a
% result of the set.
insideSetPosition = false;

% Size of SelectionHighlight markers on end of line is 5 pixels.  This
% constant is used throughout im_pix_line
marker_end_size = 5;

h_fig = iptancestor(h_axes, 'figure');
cmenu = uicontextmenu('Parent', h_fig);

%In order for IMDISTLINE to be draggable in IMTOOL, the HitTest property
%of the line objects created by LineSymbol() must be set to 'on'.
%this requires that the context menu be associated with the line objects
%rather than the h_group.
set(findobj(h_group,'Type','line'), 'UIContextMenu', cmenu);

uimenu(cmenu, ...
    'Label', 'Copy Position', ...
    'Callback', @copyPosition');

set_color_menu = uimenu(cmenu, ...
    'Label', 'Set Line Color');
color_choices = getColorChoices;

for k = 1:numel(color_choices)
    uimenu(set_color_menu, 'Label', color_choices(k).Label, ...
        'Callback', @(varargin) setColor(color_choices(k).Color));
end
setColor(color_choices(1).Color);

api.setPosition                 = @setPosition;
api.getPosition                 = @getPosition;
api.delete                      = @deleteLine;
api.setColor                    = @setColor;
api.addNewPositionCallback      = @addNewPositionCallback;
api.removeNewPositionCallback   = @removeNewPositionCallback;
api.getDragConstraintFcn        = @getDragConstraintFcn;
api.setDragConstraintFcn        = @setDragConstraintFcn;

setappdata(h_group, 'API', api);

updateView(position);

% Create update function that knows how to get the position it needs when it
% will be called from HG contexts where it may not have access to the position
% otherwise.
update_fcn = @(varargin) updateView(api.getPosition());

% Install pointer manager in figure.
iptPointerManager(h_fig);

% Store pointer behavior in the hggroup object and all its children.
enterFcn = @(f,cp) set(f, 'Pointer', 'fleur');
iptSetPointerBehavior(findobj(h_group), enterFcn);
  
updateAncestorListeners(h_group,update_fcn);

    %----------------------------
    function setPosition(varargin)

        % Validate inputs before caling break recursion pattern.
        iptchecknargin(1, 2, nargin, sprintf('%s/setPosition',mfilename));

        % Pattern to break recursion
        if insideSetPosition
            return
        else
            insideSetPosition = true;
        end

        switch nargin
            case 1
                position = varargin{1};
            case 2
                %Ensure that position vector always remains
                %in the form [X1 Y1; X2 Y2] independent of whether data is
                %entered as row or column vectors
                position = [reshape(varargin{1},2,1),...
                    reshape(varargin{2},2,1)];
        end

        updateView(position);
        sendNewPosition;

        % Pattern to break recursion
        insideSetPosition = false;
    end

    %-------------------------
    function pos = getPosition
        pos = position;
    end

    %---------------------------------------
    function id = addNewPositionCallback(fun)
        id = new_position_callback_functions.appendItem(fun);
    end

    %------------------------------------
    function removeNewPositionCallback(id)
        new_position_callback_functions.removeItem(id);
    end

    %--------------------------------
    function setDragConstraintFcn(fun)
        drag_constraint_function = fun;
    end

    %---------------------------------
    function fh = getDragConstraintFcn
        fh = drag_constraint_function;
    end

    %--------------------------------
    function deleteLine(src, varargin) %#ok varargin needed by HG caller
        if ishandle(h_group)
            delete(h_group);
        end
    end

    %---------------------------
    function updateView(position)
        draw_api.updateView(position);
    end

    %----------------------
    function setColor(color)
        draw_api.setColor(color)
    end

    %------------------------------
    function copyPosition(varargin) %#ok varargin needed by HG caller

        clipboard('copy', position);

    end

    %--------------------------------
    function sendNewPosition(varargin) %#ok varargin needed by HG caller
        
        list = new_position_callback_functions.getList();
        for k = 1:numel(list)
            fun = list{k};
            fun(position);
        end

    end

    %-------------------------------
    function startDrag(varargin) %#ok varargin needed by HG caller

        % Calculate scale of current axes.  CurrentPoint property of axes
        % is reported in axes units.  Convert marker size to axes units to
        % determine whether an end point has been selected.

        [dx_per_pixel,dy_per_pixel]=getAxesScale(h_axes);

        if strcmp(get(h_fig, 'SelectionType'), 'normal')
            % Get the mouse location in data space.
            [start_click_x,start_click_y] = getCurrentPoint(h_axes);            
            
            % Disable figure's pointer manager.
            iptPointerManager(h_fig, 'disable');

            initial_pos_x = position(:,1);
            initial_pos_y = position(:,2);
            start_position = position;

            end_point_index = ...
                abs(initial_pos_x-start_click_x)< marker_end_size*dx_per_pixel...
                & abs(initial_pos_y-start_click_y) < marker_end_size*dy_per_pixel;

            if ( any(end_point_index) )
                %move end point
                drag_motion_callback_id = iptaddcallback(h_fig, ...
                    'WindowButtonMotionFcn', ...
                    @endPointMotion);

                drag_up_callback_id = iptaddcallback(h_fig, ...
                    'WindowButtonUpFcn', ...
                    @stopEndPointMotion);
            else
                %translate entire line
                drag_motion_callback_id = iptaddcallback(h_fig, ...
                    'WindowButtonMotionFcn', ...
                    @dragMotion);

                drag_up_callback_id = iptaddcallback(h_fig, ...
                    'WindowButtonUpFcn', ...
                    @stopDrag);
            end

        end

        %---------------------------
        function dragMotion(varargin) %#ok varargin needed by HG caller

            if ~ishandle(h_axes)
                return;
            end

            [new_x new_y] = getCurrentPoint(h_axes);
            delta_x = new_x - start_click_x;
            delta_y = new_y - start_click_y;

            candidate_position = start_position + ...
                [repmat(delta_x,2,1) repmat(delta_y,2,1)];

            new_position = drag_constraint_function(candidate_position);

            setPosition(new_position);

        end % end dragMotion

        %-------------------------
        function stopDrag(varargin) %#ok varargin needed by HG caller
            dragMotion();

            iptremovecallback(h_fig, 'WindowButtonMotionFcn', ...
                drag_motion_callback_id);
            iptremovecallback(h_fig, 'WindowButtonUpFcn', ...
                drag_up_callback_id);
            
            % Enable figure's pointer manager.
            iptPointerManager(h_fig, 'enable');

        end % end stopDrag

        %-------------------------------
        function endPointMotion(varargin) %#ok varargin needed by HG caller

            ax = ancestor(h_group, 'axes');
            if ~ishandle(ax)
                return;
            end

            [new_x new_y] = getCurrentPoint(h_axes);
            delta_x = new_x - start_click_x;
            delta_y = new_y - start_click_y;

            if (all(end_point_index))
                %if end points overlap, arbitrarily choose one of the end
                %points to drag
                end_point_index = logical([1 0]);
            end

            fixed_point = start_position(~end_point_index,:);
            moving_point = start_position(end_point_index,:);

            candidate_position(end_point_index,:) =...
                moving_point + [delta_x delta_y];

            candidate_position(~end_point_index,:) = fixed_point;

            new_position=drag_constraint_function(candidate_position);
            setPosition(new_position);

        end % end endPointMotion

        %-----------------------------------
        function stopEndPointMotion(varargin) %#ok varargin needed by HG caller
            endPointMotion();

            iptremovecallback(h_fig, 'WindowButtonMotionFcn', ...
                drag_motion_callback_id);
            iptremovecallback(h_fig, 'WindowButtonUpFcn', ...
                drag_up_callback_id);
            
            % Enable figure's pointer manager.
            iptPointerManager(h_fig, 'enable');
            
        end % end stopEndPointMotion


    end % end startDrag

end %end im_pix_line


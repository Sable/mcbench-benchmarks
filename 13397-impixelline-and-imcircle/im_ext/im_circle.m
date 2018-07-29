function h_group = im_circle(h_parent, cen, r)
%im_circle Create draggable rectangle.
%   H = im_circle(HPARENT, CEN, R) creates a draggable circle with radius r
%   on the object specified by HPARENT.  
%   The function returns H, a handle to the rectangle,
%   which is an hggroup object.  HPARENT specifies the hggroup's parent, which
%   is typically an axes object, but can also be any other object that can be
%   the parent of an hggroup. CEN is a two-element vector that specifies
%   the initial location of the center. CEN has the form [XCEN,YCEN].
%   R is scalar that specifies the radius.
%
%   A draggable circle can be dragged interactively using the mouse.  When
%   the circle occupies a small number of screen pixels, its appearance
%   changes to aid visibility.
%
%   The draggable circle has a context menu associated with it that allows
%   you to copy the current position to the clipboard and change the color
%   used to display the circle.
%
%   API Function Syntaxes
%   ---------------------
%   A draggable circle contains a structure of function handles, called
%   an API, that can be used to manipulate it.  To retrieve this
%   structure from the draggable circle, use the IPTGETAPI function.
%
%       API = IPTGETAPI(H)
%
%   Functions in the API, listed in the order of the structure fields, include:
%
%   setPosition
%
%       Sets the draggable circle to a new position.
%
%           api.setPosition(new_position)
%
%       where new_position is a four-element position vector.
%
%   getPosition
%
%       Returns the current position of the draggable circle.
%
%           position = api.getPosition()
%
%   delete
%
%       Deletes the draggable circle associated with the API.
%
%           api.delete()
%
%   setColor
%
%       Sets the color used to draw the draggable circle.
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
%       Whenever the draggable circle changes its position, each
%       function in the list is called with the syntax:
%
%           fcn(position)
%
%       The return value, id, is used only with
%       removeNewPositionCallback.
%
%   removeNewPositionCallback
%
%       Removes the corresponding function from the new-position callback
%       list.
%
%           api.removeNewPositionCallback(id)
%
%       where id is the identifier returned by
%       api.addNewPositionCallback.
%
%   setDragConstraintFcn
%
%       Sets the drag constraint function to be the specified function
%       handle, fcn.
%
%           api.setDragConstraintFcn(fcn)
%
%       Whenever the draggable circle is moved because of a mouse drag,
%       the constraint function is called using the syntax:
%
%           constrained_position = fcn(new_position)
%
%       where new_position is a four-element position vector. This allows a
%       client, for example, to control where the circle may be dragged.
%
%   getDragConstraintFcn
%
%       Returns a function handle to the current drag constraint function.
%
%           fcn = api.getDragConstraintFcn()
%   
%   Remarks
%   -------
%   If you use im_circle with an axis that contains an image object, 
%   and do not specify a drag constraint function, users can drag
%   the point outside the extent of the image and lose the point.
%   When used with an axis created by the PLOT function, the axis
%   limits automatically expand to accommodate the movement of
%   the point.    
%    
%   Examples
%   --------
%       % Display updated position in the title. Specify a drag
%       % constraint function using makeConstainToRectFcn to keep 
%       % the circle inside the original xlim and ylim ranges.    
%       figure, imshow('cameraman.tif');
%       h = im_circle(gca, [110,60], 30);
%       api = iptgetapi(h);
%       api.addNewPositionCallback(@(p) title(mat2str(p)));
%       % IMPORTANT: use 'imline' here since makeConstrainToRectFcn can
%       % only recognize one of the imline, imrect, impoint !!!
%       fcn = makeConstrainToRectFcn('imrect',get(gca,'XLim'),get(gca,'YLim'));
%       api.setDragConstraintFcn(fcn);
%
%       % Use a custom color for displaying the circle.
%       figure, imshow('cameraman.tif')
%       h = im_circle(gca, [110,60], 30);
%       api = iptgetapi(h);
%       api.setColor([1 0 0]);
%
%       % When the circle position occupies only a few pixels on the
%       % screen, the circle is drawn in a different style to increase
%       % its visibility.
%       figure, imshow cameraman.tif
%       h = im_circle(gca, [110,60], 30);
%
%   See also  IMLINE, IMPOINT, IPTGETAPI, makeConstrainToRectFcn.

  
  iptchecknargin(3, 3, nargin, mfilename);
  if ~ishandle(h_parent)
    error('Images:im_circle:invalidHandle', ...
          'HPARENT must be a valid graphics handle.');
  end
  if strcmp(get(h_parent, 'type'), 'axes')
    h_axes = h_parent;
  else
    h_axes = ancestor(h_parent, 'axes');
    if isempty(h_axes)
      error('Images:im_circle:noAxesAncestor', ...
            'HPARENT must be a descendent of an axes object.');
    end
  end

  try
    h_group = hggroup('ButtonDownFcn', @startDrag, 'Parent', h_parent, ...
                      'HitTest', 'on');
  catch
    error('Images:im_circle:failureToParent', ...
          'HPARENT must be able to have an hggroup object as a child.');
  end

  draw_api = defaultCircle(h_group);
  
  % constraint_function is used by dragMotion() to give a client the opportunity
  % to constrain where the circle can be dragged.
  drag_constraint_function = identityFcn;

  % new_position_callback_functions is used by sendNewPosition() to
  % notify interested clients whenever the circle position changes.
  new_position_callback_functions = makeList;
    
  % Pattern for set associated with callbacks that get called as a
  % result of the set.
  insideSetPosition = false;
  insideSetRadius   = false;
    
  h_fig = iptancestor(h_axes, 'figure');
  cmenu = uicontextmenu('Parent', h_fig);
  set(h_group, 'UIContextMenu', cmenu);
  uimenu(cmenu, ...
         'Label', 'Copy Position', ...
         'Callback', @copyPosition');
  set_color_menu = uimenu(cmenu, ...
                          'Label', 'Set Circle Color');
  color_choices = getColorChoices;
  for k = 1:numel(color_choices)
    uimenu(set_color_menu, 'Label', color_choices(k).Label, ...
           'Callback', @(varargin) setColor(color_choices(k).Color));
  end
  setColor(color_choices(1).Color);
  
  % Ô²ÐÄ£¬°ë¾¶
  center = cen;
  radius = r;
  position = [cen(1)-r,cen(2)-r,2*r,2*r];
  
  
  api.setCenter                  = @setCenter;
  api.getCenter                  = @getCenter;
  api.setRadius                  = @setRadius;
  api.getRadius                  = @getRadius;
  api.delete                     = @deleteRect;
  api.setColor                   = @setColor;
  api.addNewPositionCallback     = @addNewPositionCallback;
  api.removeNewPositionCallback  = @removeNewPositionCallback;
  api.getDragConstraintFcn       = @getDragConstraintFcn;
  api.setDragConstraintFcn       = @setDragConstraintFcn;  
  
  api.setDragConstraintCallback  = @setDragConstraintFcn; 
  
  setappdata(h_group, 'API', api);

  % Make the pointer be a fleur when it is over the rect.  Store the same pointer
  % behavior in the hggroup and all its children.
  pointer_fcn = @(varargin) set(h_fig, 'Pointer', 'fleur');
  iptSetPointerBehavior(findobj(h_group), pointer_fcn);
  
  updateView(center, radius);
  
  % Create update function that knows how to get the position it needs when it
  % will be called from HG contexts where it may not have access to the position
  % otherwise.
  update_fcn = @(varargin) updateView(api.getCenter(), api.getRadius());
  
  updateAncestorListeners(h_group,update_fcn);
  
  % Install a pointer manager in the figure and enable it.
  iptPointerManager(h_fig);

  %---------------------------------
  function setCenter(new_center)
  
    % Pattern to break recursion
    if insideSetPosition
        return
    else
        insideSetPosition = true;
    end     

    center = new_center;
    position = [...
      center(1)-radius,center(2)-radius,2*radius,2*radius];
    updateView(center, radius);
    sendNewPosition;
    
    % Pattern to break recursion
    insideSetPosition = false;
    
  end

  %-------------------------
  function cen = getCenter
    cen = center;
  end

  %-------------------
  function setRadius(r)
    
    % Pattern to break recursion
    if insideSetRadius
        return
    else
        insideSetPosition = true;
    end
    
    radius = r;
    position = [...
    center(1)-radius,center(2)-radius,2*radius,2*radius];
    updateView(center, radius);
    sendNewPosition;
    
    % Pattern to break recursion
    insideSetPosition = false;

  end

  %---------------------
  function r = getRadius
    r = radius;
  end

  %----------------------------------------
  function id = addNewPositionCallback(fun)
    id = new_position_callback_functions.appendItem(fun);
  end

  %-------------------------------------
  function removeNewPositionCallback(id)
    new_position_callback_functions.removeItem(id);
  end

  %---------------------------------
  function setDragConstraintFcn(fun)
    drag_constraint_function = fun;
  end

  %---------------------------------
  function fh = getDragConstraintFcn
    fh = drag_constraint_function;
  end

  %----------------------------
  function deleteRect(varargin) %#ok varargin needed by HG caller
    if ishandle(h_group)
      delete(h_group);
    end
  end

  %-----------------------
  function updateView(cen, r)
    draw_api.updateView(cen, r);
  end

  %-----------------------
  function setColor(color)
    draw_api.setColor(color);
  end
  
  %------------------------------
  function copyPosition(varargin) %#ok varargin needed by HG caller
  
    clipboard('copy', position);
  
  end

  %---------------------------------
  function sendNewPosition(varargin) %#ok varargin needed by HG caller

    list = new_position_callback_functions.getList();
    for k = 1:numel(list)
      fun = list{k};
      fun(position);
    end

  end

  %--------------------------------
  function startDrag(src, varargin) %#ok varargin needed by HG caller
      
    if strcmp(get(h_fig, 'SelectionType'), 'normal')
        start_position = position;
        
        % Get the mouse location in data space.
        [start_x,start_y] = getCurrentPoint(h_axes);
        
        % Disable the figure's pointer manager until the drag is completed.
        iptPointerManager(h_fig, 'disable');

        drag_motion_callback_id = iptaddcallback(h_fig, ...
                                                 'WindowButtonMotionFcn', ...
                                                 @dragMotion);
        
        drag_up_callback_id = iptaddcallback(h_fig, ...
                                             'WindowButtonUpFcn', ...
                                             @stopDrag);
    end
    
    %----------------------------
    function dragMotion(varargin) %#ok varargin needed by HG caller
    
      if ~ishandle(h_axes)
          return;
      end

      [new_x,new_y] = getCurrentPoint(h_axes);      
      delta_x = new_x - start_x;
      delta_y = new_y - start_y;
      candidate_position = start_position + [delta_x delta_y 0 0]; 
      
      new_position = drag_constraint_function(candidate_position);
      
      new_radius = new_position(4)/2;
      new_center = [new_position(1)+new_radius,new_position(2)+new_radius];
      setCenter(new_center);
    
    end

    
    %--------------------------
    function stopDrag(varargin) %#ok varargin needed by HG caller
      dragMotion();

      iptremovecallback(h_fig, 'WindowButtonMotionFcn', ...
                        drag_motion_callback_id);
      iptremovecallback(h_fig, 'WindowButtonUpFcn', ...
                        drag_up_callback_id);
      
      % Enable the figure's pointer manager.
      iptPointerManager(h_fig, 'enable');
      
    end % stopDrag

    
  end % startDrag

  
end % im_circle

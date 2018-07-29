function interactivelegend(varargin)
% INTERACTIVELEGEND    Makes a figure interactive
%   This function make plots in a figure act in an interactive way: when
%   selected, they are highlighted and an associated tag is shown. Clicking
%   on the axes background unselects the plot. This can be used to avoid
%   the use of a cumbersome legend when a figure contains many plots.
%
%   Syntaxes:
%
%       interactivelegend(handles);
%       interactivelegend(handles,opts);
%
%   These syntaxes enable interactivity for the plots whose handles are given
%   in vector "handles", and displays their 'Tag' property (which are empty
%   strings by default). Details of how the plots are highlighted are given
%   in the (optional) structure "opts". See below for a description of the
%   option structure "opts".
%
%   Vector "handles" can also contain handles to axes: interactivelegend 
%   then automatically finds the axes' children and all the plot objects
%   in these axes will be interactive. Thus, the function can be simply
%   called for the current figure with the command "gca" in lieu of vector
%   "handles":
%   
%       interactivelegend(gca)
%
%   will actually work.
%
%   Syntaxes:
%
%       interactivelegend(handles,tags);
%       interactivelegend(handles,tags,opts);
%
%   These syntaxes first assign the tags in cell array "tags" to the plots'
%   'Tag' properties, and displays them when they are highlighted as
%   before.
%
%   The optional structure "opts" is used to adjust various properties of
%   the interactive objects. Note that field names are case sensitive.
%
%       opts.selected.Color         is the plot's highlighted color
%       opts.selected.LineStyle     is the plot's highlighted linestyle
%       opts.selected.LineWidth     is the plot's highlighted linewidth
%       ...                         
%
%   In general, any plot object property can be adjusted using the field
%   opts.selected.PROPERTY. 
%
%       opts.unselected             is a structure describing the
%                                   unselected plots properties.
%
%   By default, opts.unselected is simply the original property structure,
%   so that opts.unselected needs not be specified. If specified, the
%   properties in opts.unselected are applied to the plots when they are
%   not selected.
%
%       opts.tag.Color              is the text tag's color
%       ...
%
%   In general, any text tag property can be adjusted using the field
%   opts.tag.PROPERTY. In particular, opts.tag.Color defaults to 
%   opts.selected.Color. Note however that opts.tag.String should not be
%   specified since it will override the displayed text (and will be the
%   same for all tags).
%
%       opts.pointer               is the figure's pointer
%
%   Default is a crosshair; see set(gcf,'Pointer') for all pointer types.
%
%   If structure "opts" is ommitted, the following default values are used:
%
%       opts.selected.Color = 'r';
%       opts.selected.LineWidth = 2;
%       opts.tag.Color = 'r';
%       opts.pointer = 'crosshair';
%
%   Note that "opts" is stored in the 'UserData' fields of all the axes
%   containing interactive objects. Any data which is stored in the axes' 
%   'UserData' field will be overwritten. Additionnal fields are created
%   by interactivelegend in structure "opts" to store the interactive
%   objects' states. This means that bad behavior will be obtained if the
%   function is called successively after each plot, such as in:
%
%       hold on;
%       p1 = plot(...);
%       interactivelegend(p1);
%       p2 = plot(...);
%       interactivelegend(p2);
%       etc.
%
%   Each time interactivelegend is called, data from the previous calls is
%   erased from the axes 'UserData' field. The correct way to do this would
%   be:
%
%       hold on;
%       p1 = plot(...);
%       p2 = plot(...);
%       interactivelegend([p1 p2]);
%
%   or even:
%
%       hold on;
%       plot(...);
%       plot(...);
%       interactivelegend(gca);
%
%   Function interactivelegend should be called at most one time for each
%   axes; if the provided handles span many axes, the function will still
%   work but the interactive objects will behave as a single set (e.g.
%   selected plots in one axes will be deselected if another axes
%   containing interactive plots are selected, whereas different axes will
%   behave independantly if interactivelegend is called once for each
%   axes).

% Copyright 2003
% Francois Bouffard (fbouffar@gel.ulaval.ca)
% Université Laval, Québec, QC, Canada
%
% CHANGE LOG
%
%   2003-10-02  First released version, submitted on
%               http://www.matlabcentral.com as interactivelegend.m
%   
%   2003-10-08  Correct handling of handles spanning multiple axes
%               implemented: when giving a vector of handles to the
%               function, the objects acts one coherent set (e.g. are
%               deselected when the background of another axes set is
%               clicked), while they behave separately if the function is
%               called for each axes.
%
%               Copyright notice added.
%
%               Help section updated.
%
%   2005-03-30  Fix of a problem when calling the function with the 
%               optional cell array of tags: the tags were assigned to 
%               objects in the wrong order.
%
%   2005-04-19  Fix: tag now appears above all other plot elements.

% ===============================
% Managing input arguments
% ===============================

% Getting number of arguments
Narg = nargin;
if Narg == 0
    error('Not enough input arguments');
end;

% If last argument is a structure
% then it is assigned to "opts"
% and Narg is decreased
if isstruct(varargin{Narg})
    opts = varargin{Narg};
    Narg = Narg - 1;
end;

% First argument is vector "handles"
opts.handles = varargin{1};

% Converting handles to axes into
% plot handles
plot_handles = [];
for k = 1:length(opts.handles)
    if is_axes_handle(opts.handles(k))
        % axes handle: we get its children, but we must flip it to
        % get object handles in order of creation
        new_handles = flipud(get(opts.handles(k),'Children'));
    else
        new_handles = opts.handles(k);
    end;
    plot_handles = [plot_handles; new_handles];
end;
opts.handles = plot_handles;

% Defaults options
if ~isfield(opts,'selected')
    opts.selected.Color = 'r';
    opts.selected.LineWidth = 2;
else
    if ~isfield(opts.selected,'Color')
        opts.selected.Color = 'r';
    end;
    if ~isfield(opts.selected,'LineWidth')
        opts.selected.LineWidth = 2;
    end;
end;
if ~isfield(opts,'tag')
    opts.tag.Color = opts.selected.Color;
end;
if ~isfield(opts,'pointer')
    opts.pointer = 'crosshair';
end;

% Assigning defaults for opts.unselected
% Properties that are set are stored in
% opts.unselected_properties (we cannot
% use the entire property set since some
% of them are read-only).
opts.unselected_properties = {'Color'; 'LineStyle'; 'LineWidth'; 'Marker'; 'MarkerSize'};
if ~isfield(opts,'unselected')
    opts.unselected = get(opts.handles,opts.unselected_properties);
end;

% Setting unselected properties so that
% the look'n'feel of interactivelegend
% is applied as soon as the function is
% called and not only on the first click.
set(opts.handles,opts.unselected_properties,opts.unselected);

% If there is an argument left, then it
% is "tags", and "tags" are assigned to
% the plots 'Tag' properties. See function
% assign_tags() below.
if Narg > 1
    tags = varargin{2};
    assign_tags(opts.handles,tags);
end;

% ===============================
% Assigning axes and plots
% ButtonDownFcn's, axes UserData
% and figure's pointer
% ===============================

% Getting the set of handles for axes that
% are the parents of the plots whose handles
% are opts.handles. See function 
% get_unique_parents below.
opts.axes_handles = get_unique_parents(opts.handles);

% Setting ButtonDownFcn's for opts.handles
% and axes_handles
set(opts.handles,'ButtonDownFcn',@click_plot);
set(opts.axes_handles,'ButtonDownFcn',@click_axes);

% Storing the opts structure in axes_handles
% UserData property (each set of axes thus
% have a copy of opts).
set(opts.axes_handles,'UserData',opts);

% Getting the set of handles for figures
% that are the parents of the axes whose
% handles are axes_handles. See function
% get_unique_parents below.
figure_handles = get_unique_parents(opts.axes_handles);

% Setting Pointer property for figure_handles
set(figure_handles,'Pointer',opts.pointer);

% ===============================
% --- Functions -----------------
% ===============================

% ===============================
% Assigns provided tags to the
% plots' 'Tag' properties
% ===============================

function assign_tags(handles,tags);

% Finding the smallest number between
% the number of handles and the number
% of tags.
lh = length(handles);
lt = length(tags);
L = min([lh lt]);

% Assigning the list of tags to the
% 'Tag' property
for k = 1:L
    set(handles(k),'Tag',tags{k});
end;

% ===============================
% Axes click function
% ===============================

function click_axes(obj,evendata);

% Getting the opts structure stored in
% the current axis UserData property
opts = get(gca,'UserData');

% Returning the currently selected 
% plot (if any) to its initial state.
% See the clear_selected() function below.
clear_selected;

% Setting the current figure's pointer
% property to opts.pointer, in case the
% pointer has been changed (e.g. by
% zooming or editing the figure).
set(gcf,'Pointer',opts.pointer);

% Storing the new opts structure which may
% have changed if opts.taghandle was deleted.
set(opts.axes_handles,'UserData',opts);

% ===============================
% Plot click function
% ===============================

function click_plot(obj,evendata);

% Getting the opts structure stored in
% the current axis UserData property
opts = get(gca,'UserData');

% Returning the currently selected 
% plot (if any) to its initial state.
% See the clear_selected() function below.
clear_selected;

% Getting the location of the click, and
% some information about the x-axis
current_point = get(gca,'CurrentPoint');
xscale = get(gca,'XLim');
dx = xscale(2)-xscale(1);

% Setting the current selected plot
% properties to opts.selected
set(obj,opts.selected);

% Creating the text tag using the
% selected plot's 'Tat' property
opts.taghandle = text(current_point(1,1)+0.02*dx,current_point(1,2),get(obj,'Tag'));

% Setting the text tag properties
% using opts.tag if it exists
if isfield(opts,'tag');
    set(opts.taghandle,opts.tag);
end;

% Storing the selected plot handle
% in opts.selected_handle
opts.selected_handle = obj;

% Moving the selected plot to the
% front layer and saving its previous
% position to opts.objpos. See function
% move_plot() below.
opts.objpos = move_plot(obj,1);

% Moving the tag above everything else
move_plot(opts.taghandle,1);

% Setting the current figure's pointer
% property to opts.pointer, in case the
% pointer has been changed (e.g. by
% zooming or editing the figure).
set(gcf,'Pointer',opts.pointer);

% Storing the new opts structure which may
% have changed if opts.taghandle was deleted.
set(opts.axes_handles,'UserData',opts);

% ===============================
% Clear selected plot
% ===============================

function clear_selected;

% Getting the opts structure stored in
% the current axis UserData property
opts = get(gca,'UserData');

% Setting opts.unselected properties
% for all plots.
% opts.unselected may be a structure
% (if set by the user) or a cell array
% (default setting). It should always
% exist.
if iscell(opts.unselected)
    set(opts.handles,opts.unselected_properties,opts.unselected);
else
    set(opts.handles,opts.unselected);
end;

% If opts.taghandle points to a valid
% tag handle, the tag is deleted.
if isfield(opts,'taghandle');
    if ishandle(opts.taghandle)
        delete(opts.taghandle);
    end;
end;

% If opts.selected_handle points to a
% valid plot and opts.objpos exists,
% the plot whose handle is
% opts.selected_handle is moved back
% to layer opts.objpos so that it is
% not on the front layer anymore.
% See function move_plot() below.
if isfield(opts,'selected_handle') & isfield(opts,'objpos');
    if ishandle(opts.selected_handle)
        move_plot(opts.selected_handle,opts.objpos);
    end;
end;

% Storing the new opts structure which may
% have changed if opts.taghandle was deleted.
set(opts.axes_handles,'UserData',opts);

% ===============================
% Move plots to top or bottom
% ===============================

function current_pos = move_plot(obj,pos);

% Getting the list of current axes' children
axes_children = get(gca,'Children');

% Finding current plot's position in the list
current_pos = find(obj == axes_children);

% If it is in the list, change the list so
% that the current plot is found at the
% requested position pos.
if ~isempty(current_pos)
    % Delete current plot's handle in the list
    axes_children(current_pos) = [];
    % Insert current plot's handle at pos
    if pos == 1
        axes_children = [obj; axes_children];
    elseif pos >= length(axes_children)
        axes_children = [axes_children; obj];
    else
        axes_children = [axes_children(1:pos-1); obj; axes_children(pos:end)];
    end;
    % Set the new list in current axes'
    % 'Children' property.
    set(gca,'Children',axes_children);
end;

% ===============================
% Gets a list of all the parents
% of a set of children handles
% ===============================

function parents = get_unique_parents(children);
parents = get(children,'Parent');
if iscell(parents)
    parents = cell2mat(parents);
end;
parents = unique(parents);

% ===============================
% Finds wether a handle is one of
% the existing axes handles
% ===============================

function isit = is_axes_handle(handle);
L = length(handle);
isit = zeros(size(handle));
% Getting all existing axes
figure_handles = get(0,'Children');
axes_handles = get(figure_handles,'Children');
if iscell(axes_handles)
    axes_handles = cell2mat(axes_handles);
end;
for k = 1:L
    idx = find(handle(k)==axes_handles);
    if ~isempty(idx)
        isit(k) = 1;
    end;
end;

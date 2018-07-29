function handle = progressbar( handle,increment,string,titlestr )
%
% progressbar - shows a progress bar dialog based on the function "waitbar"
%
% Format: handle = progressbar( handle,increment [,string,titlestr] )
%
% Input:    handle      - handle to current progress bar, [] for a new one
%           increment   - a fraction (0..1) to increment by.
%                         (-1) signals the function to remove the handle from
%                         the persistant list and close the progressbar
%           string      - a string to be replaced in the progress bar (optional)
%           titlestr    - a title for the dialog box (optional)
%
% Output:   handle      - a graphic handle of the dialog box
%
%
% NOTE:     this function uses a persistant list of handles and thier values.
%           therefore,  to delete a progressbar, please call the function with: 
%               progressbar( handle,-1 );
%
%           an "abort" button is formed inside the progressbar, if the calling process
%           uses the persistent function "gui_active". when the "abort" button is pressed,
%           the Callback function "gui_active" changes it's value to zero, which enables 
%           the application to interactively stop execution
%
% Example:  gui_active(1);      % will add an abort button
%           h           = progressbar( [],0,'my test' );
%           max_count   = 1e+3;
%           for idx = 1:max_count
%               fprintf( '%d\n',idx )';
%               h = progressbar( h,1/max_count );
%               if ~gui_active
%                   break;
%               end
%           end
%           progressbar( h,-1 );
%


persistent handle_list counter_list last_handle last_idx;

% initialize
% =============
call_flag = min( nargin,4 );

% analyze input and decide what to do
% ====================================
if isempty( handle )            % create a new dialog
    counter_list(end+1) = 0;
    last_idx            = length( counter_list );
    switch call_flag
    case 2, last_handle = waitbar( increment,'Please Wait...' );
    case 3, last_handle = waitbar( increment,string );
    case 4, last_handle = waitbar( increment,string,'Name',titlestr );
    end        
    handle_list(end+1)  = last_handle;
    handle              = last_handle;
    check_position( handle_list );      % so that the figures don't hide each other
    if (gui_active)
        add_button( last_handle );      % add the abort button if the state of the gui_active is set
    end

elseif ( increment == -1 )      % delete correct handle from the list
    last_handle             = handle;
    last_idx                = find( handle_list == handle );
    handle_list( last_idx ) = [];
    counter_list( last_idx )= [];
    if ishandle( last_handle )      % close the figure, if it's open
        close( last_handle );       % since user can close it by him self
    end
    last_handle             = [];
    
elseif (handle == last_handle)  % update last dialog
    counter_list(last_idx)  = counter_list(last_idx) + increment;
    if ishandle( handle )       % nobody killed my figure
        switch call_flag
        case 2, waitbar( counter_list(last_idx),handle );
        case 3, waitbar( counter_list(last_idx),handle,string );
        case 4, waitbar( counter_list(last_idx),handle,string,'Name',titlestr );
        end
    else                        % somebody killed my figure -> so I create it again
        switch call_flag
        case 2, handle = waitbar( counter_list(last_idx),'Please Wait...' );
        case 3, handle = waitbar( counter_list(last_idx),string );
        case 4, handle = waitbar( counter_list(last_idx),string,'Name',titlestr );
        end
        handle_list(last_idx)   = handle;
        last_handle             = handle;
        check_position( handle_list );      % so that the figures don't hide each other
        if (gui_active)
            add_button( last_handle );      % add the abort button if the state of the gui_active is set
        end
    end    
else                            % find the handle inside the list
    last_handle = handle;
    last_idx    = find( handle_list == handle );
    if ~isempty( last_idx )
        counter_list(last_idx)  = counter_list(last_idx) + increment;
        switch call_flag
        case 2, waitbar( counter_list(last_idx),last_handle );
        case 3, waitbar( counter_list(last_idx),last_handle,string );
        case 4, waitbar( counter_list(last_idx),last_handle,string,'Name',titlestr );
        end        
    end
end
  
% update display after all
% ==========================
drawnow;

% =======================================================================================
%                               Inner Function Implementation
% =======================================================================================

function add_button( fig_handle )
%
% adds the abort button to the waitbar
%

% collect handles and set control units to pixels
axes_handle     = get( fig_handle,'currentaxes' );
last_fig_units  = get( fig_handle,'units' );
last_axes_units = get( axes_handle,'units' );
set( fig_handle,'units','pixels' );
set( axes_handle,'units','pixels' );

% read controls position
fig_position    = get( fig_handle,'position' );
axes_position   = get( axes_handle,'position' );
fig_width       = fig_position(3);
fig_height      = fig_position(4);
axes_xcoord     = axes_position(1);
axes_ycoord     = axes_position(2);
axes_width      = axes_position(3);
axes_height     = axes_position(4);

% load the button icon and create the button
load( 'gauge_abort_icon' );
button_width    = ButtonSize16x16(1)+2;
button_height   = ButtonSize16x16(2)+2;
button_margin   = 10;
button_xcoord   = (fig_width + axes_width + axes_xcoord - button_width)/2 - button_margin;
button_ycoord   = (axes_height - button_height)/2 + axes_ycoord;
button_handle   = uicontrol( 'Parent',fig_handle,'units','pixels',...
    'Position',[ button_xcoord,button_ycoord,button_width,button_height ],...
    'Callback','gui_active(0);progressbar(get(gcbo,''parent''),-1);close(get(gcbo,''parent''));',...
    'CData',Icon16x16 );

% resize axis to accommodate the button, and restore axes and figure units back to previous
axes_position(3) = axes_width - button_width - button_margin;
set( axes_handle,'position',axes_position );
set( fig_handle,'units',last_fig_units );
set( axes_handle,'units',last_axes_units );

% ---------------------------------------------------------------------------------------

function check_position( handle_list )
%
% makes sure that the progressbar does not hide it's nested progressbars
%

% process only if there is more than one progress bar on the screen
if (length(handle_list)>1)
    y_increment = 70;                   % pixels
    x_increment = 30;                   % pixels
    
    % change units to pixels
    screen_units    = get( 0,'units' );
    last_fig_units  = get( handle_list(end-1),'units' );
    cur_fig_units   = get( handle_list(end),'units' );
    set( 0,'units','pixels' );
    set( handle_list(end-1),'units','pixels' );
    set( handle_list(end),'units','pixels' );
    
    % get positions, and calc new position for progress bar
    screen_size     = get( 0,'screensize' );
    last_position   = get( handle_list(end-1),'position' );
    cur_position    = get( handle_list(end),'position' );
    cur_position(1) = last_position(1) + x_increment;
    cur_position(2) = last_position(2) - y_increment;
    
    % check that we don't go outside the screen
    if (cur_position(1)+cur_position(3)>screen_size(3))
        cur_position(1) = x_increment;
    end
    if (cur_position(2)<screen_size(1))
        cur_position(2) = screen_size(4) - y_increment - cur_position(4);
    end       
        
    % store new position and restore units
    set( handle_list(end),'position',cur_position );
    set( 0,'units',screen_units );
    set( handle_list(end-1),'units',last_fig_units );
    set( handle_list(end),'units',cur_fig_units );
end
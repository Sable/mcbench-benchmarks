% Function 'cview' for displaying TIFF images
%
% Note: RGB (colour) images are converted to greyscale for convienience, and can be changed if required
%
% Last updated: 23/04/2008

function cview(callstr,text_entered)

% Callbacks:
% 'window_resize' - when the figure window has been resized (need to re-adjust button positions)
% 'file_select' - for changing the filename *shared with layer_select*
% 'layer_select' - for changing the current layer *shared with file_select*
% 'colour_select' - for changing the colourmap
% 'colourbar_select' - for toggling the colorbar
% 'axes_select' - for turning the axes on/off
% 'image_select' - for changing between image and contour
% 'colourmin' - if the minimum color slider was used
%  etc .......

% Stuff to be added (not in order);
% change layer by typing value
% RGB image handling
% other image file types (eg. jpeg)

% On the first call, no arguments passed
% Just initialise the figure
if nargin==0
    
    % Find all of the *.tif files in the pwd
    % Note that Unix systems are case-sensitive
    orig_pwd=pwd;
    tif_list=dir('*.tif');
    if isunix==1
        TIF_list=dir('*.TIF');
    else
        TIF_list=dir('qqqq.qqqq'); %Just to create an empty structure
    end
    tif_list=cat(1,tif_list,TIF_list); %Add the two lists together
    
    % Put the file names into a single item, and sort it
    for ii = 1:length(tif_list)
        file_list{ii}=tif_list(ii).name;
    end
    % In case can't find any TIF files, don't setup the figure
    if length(tif_list)==0
        disp('ERROR: No TIF files found in pwd');
        var_list=evalin('base','whos');
        for ii=1:length(var_list)
            file_list{ii}=var_list(ii).name;
        end
        if length(var_list)==0
            disp('ERROR: No variables in workspace');
            return
        end
    end
    [dummy sort_indx]=sort(file_list);
    file_list=file_list(sort_indx(1:1:end));
    
    % Create the main figure window
    gui = figure('NumberTitle','off','position',[100 100 796 530]);
    set(gui,'tag',['cviewwindow' int2str(gcf)],'Name',['cview [' int2str(gcf) '] - ' orig_pwd]);
    % Get the position of the figure (for placing uicontrols)
    gui_pos=get(gui,'position');
    
    % Just create a set of axes
    image_axes=axes;
    axis off;
    
    % Setup the uicontrol
    file_refresh=uicontrol('style','pushbutton','position',[130 gui_pos(4)-25 60 20],'string','Refresh list','callback','cview(''filelist_refresh'')');
    file_selected=uicontrol('style','popup','callback','cview(''file_select'')','string',file_list);
    set(file_selected,'value',1); % For the initialisation, just select the first file by default
    
    forv_file=uicontrol('style','radiobutton','callback','cview(''forv_toggle_file'')','string','Files','Value',1);
    forv_var=uicontrol('style','radiobutton','callback','cview(''forv_toggle_var'')','string','Variable','Value',0);
    
    layer_select=uicontrol('style','slider','string','None','callback','cview(''layer_select'')','min',1,'max',1.1);
    layer_value=uicontrol('style','text');
    set(layer_select,'value',1); %So that the layer doesn't start at zero
    
    colours={'none','default','inv_gray','gray','hsv','hot','bone','copper','pink','white','flag','lines','colorcube','jet','prism','cool','autumn','spring','winter','summer'};
    colourbar_select=uicontrol('style','toggle','string','Colourbar','callback','cview(''colourbar_select'')');
    colour_select=uicontrol('style','popup','string',colours,'callback','cview(''colour_select'')');
    
    axes_select=uicontrol('style','checkbox','callback','cview(''axes_select'')','string','Axes');
    
    contour_depth=[1 2 3 4 5 10 20 50];
    depth_select=uicontrol('style','popup','callback','cview(''image_select'')','string',{contour_depth});
    image_select=uicontrol('style','popup','callback','cview(''image_select'')','string',{'Image','Contour'});
    
    colourmin=uicontrol('style','slider','callback','cview(''colourmin'')','min',0,'max',65536,'sliderstep',[1/65536 10/65536]);
    colourmax=uicontrol('style','slider','callback','cview(''colourmax'')','min',0,'max',65536,'sliderstep',[1/65536 10/65536]);
    mintext=uicontrol('style','edit','callback','cview(''mintext'',get(gcbo,''string''));');
    maxtext=uicontrol('style','edit','callback','cview(''maxtext'',get(gcbo,''string''));');
    
    colourbar_refresh=uicontrol('style','pushbutton','string','Refresh','callback','cview(''colourbar_refresh'')');
    colourbar_reset=uicontrol('style','pushbutton','string','Reset','callback','cview(''colourbar_reset'')');
    
    function_select=uicontrol('style','popup','string',{'Info','Zoom','Line Profile','X-Profile','Y-Profile','3-D','Average','Save'},'callback','cview(''function_select'')');
    
    % Enable window resize callback (note this seems to need to be enabled after adding other uicontrol)
    set(gui,'ResizeFcn','cview(''window_resize'')');
    
    % if there weren't any TIFF files, default to variable list
    if length(tif_list)==0
        set(forv_file,'Value',0);
        set(forv_var,'Value',1);
    end
    
    % Save key variables
    info.orig_pwd=orig_pwd; % The starting pwd
    info.colours=colours; % The list of the colourmaps
    info.colour_select=colour_select; % The handle for the colour_select uicontrol
    info.colourbar_select=colourbar_select; % The handle for the colourbar_select uicontrol
    info.file_refresh=file_refresh; % The handle for the file_refresh
    info.file_list=file_list; % The list of the filenames
    info.image_axes=image_axes; % The handle for the axes
    info.file_selected=file_selected; % The handle for the file_select uicontrol
    info.layer_select=layer_select; % The handle for the layer_select uicontrol
    info.layer_value=layer_value; % The handle for the layer_value uicontrol
    info.axes_select=axes_select; % The handle for the axes_select uicontrol
    info.contour_depth=contour_depth; % The list of the contour depths
    info.image_select=image_select; % The handle for the image/contour uicontrol
    info.depth_select=depth_select; % The handle for the depth select uicontrol
    info.colourmin=colourmin; % Handle for the min color slider
    info.colourmax=colourmax; % Handle for the max color slider
    info.mintext=mintext; % Handle for the minimum color text
    info.maxtext=maxtext; % Handle for the minimum color text
    info.colourbar_refresh=colourbar_refresh; % Handle for the refresh colourbar uicontrol
    info.colourbar_reset=colourbar_reset; % Handle for the reset colourbar uicontrol
    info.function_select=function_select; % Handle for the function_select uicontrol
    info.forv_file=forv_file; % Handle for the file or variable radio button
    info.forv_var=forv_var; % Handle for the file or variable radio button
    set(gui,'userdata',info);
    
    cview('window_resize'); % To get the positions of the uicontrol
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin>=1
    
    % First just extract the information
    gui=findobj('tag',['cviewwindow' int2str(gcf)]); % Find the figure
    info=get(gui,'userdata');
    
    
    % Deal with each callback completely separately (not necessarily the most efficient method)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% window_resize
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if strcmp(callstr,'window_resize')
        gui_pos=get(gui,'position');
        file_selected=info.file_selected;
        set(file_selected,'position',[10 gui_pos(4)-40 300 20]);
        file_refresh=info.file_refresh;
        set(file_refresh,'position',[229 gui_pos(4)-20 80 20]);
        forv_file=info.forv_file;
        set(forv_file,'position',[10 gui_pos(4)-20 80 18]);
        forv_var=info.forv_var;
        set(forv_var,'position',[100 gui_pos(4)-20 80 18]);
        layer_select=info.layer_select;
        set(layer_select,'position',[320 gui_pos(4)-40 100 20]);
        layer_value=info.layer_value;
        set(layer_value,'position',[350 gui_pos(4)-20 40 20]);
        colourbar_select=info.colourbar_select;
        set(colourbar_select,'position',[430 gui_pos(4)-20 70 20]);
        colour_select=info.colour_select;
        set(colour_select,'position',[430 gui_pos(4)-40 70 20]);
        axes_select=info.axes_select;
        set(axes_select,'position',[640 gui_pos(4)-40 45 20]);
        image_select=info.image_select;
        set(image_select,'position',[510 gui_pos(4)-40 65 20]);
        depth_select=info.depth_select;
        set(depth_select,'position',[585 gui_pos(4)-40 45 20]);
        colourmin=info.colourmin;
        set(colourmin,'position',[gui_pos(3)-40 50 20 100]);
        colourmax=info.colourmax;
        set(colourmax,'position',[gui_pos(3)-40 gui_pos(4)-150 20 100]);
        mintext=info.mintext;
        set(mintext,'position',[gui_pos(3)-50 170 50 20]);
        maxtext=info.maxtext;
        set(maxtext,'position',[gui_pos(3)-50 gui_pos(4)-180 50 20]);
        colourbar_refresh=info.colourbar_refresh;
        set(colourbar_refresh,'position',[gui_pos(3)-105 0 60 15]);
        colourbar_reset=info.colourbar_reset;
        set(colourbar_reset,'position',[gui_pos(3)-35 0 35 15]);
        function_select=info.function_select;
        set(function_select,'position',[700 gui_pos(4)-40 80 20]);
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% file_select OR layer_select
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if strcmp(callstr,'file_select') | strcmp(callstr,'layer_select')
        
        % Check to see in the correct directory, if not move to it
        orig_pwd=info.orig_pwd;
        current_pwd=pwd;
        if strcmp(orig_pwd,current_pwd)==0
            cd(orig_pwd)
        end
        
        % Extract the file_name
        file_selected=info.file_selected;
        file_list=info.file_list;
        layer_select=info.layer_select;
        layer_value=info.layer_value;
        % Get the handle for the selected file
        current_file=get(file_selected,'value');
        % Find the name of the corresponding file
        file_name=char(file_list(current_file));
        
        if strcmp(callstr,'file_select')
            % If selected new file, then will need to set up the layer selector
            old_layer=get(layer_select,'value'); % Get the old layer number
            % Get the number of layers
            if get(info.forv_file,'Value')==1
                no_layers=length(imfinfo(file_name));
            else
                no_layers=1;
            end
            % If only one layer, then steps less than 1 meaningless
            if no_layers>1
                min_step=1/(no_layers-1);
            else 
                min_step=1;
            end
            max_step=(5*min_step);
            set(layer_select,'sliderstep',[min_step max_step]);
            set(layer_select,'max',no_layers+0.01);
            % Use the old layer number if appropriate, otherwise use layer 1
            if old_layer<=no_layers
                layer_no=old_layer;
            else 
                layer_no=1;
            end
            
            set(layer_select,'value',layer_no);
            set(layer_value,'string',int2str(layer_no));
            
        elseif strcmp(callstr,'layer_select')
            
            % Get the new layer value and display it
            layer_no=(get(layer_select,'value'));
            set(layer_value,'string',int2str(layer_no));
        end
        
        % Read in the data and display
        if get(info.forv_file,'Value')==1
            [data map]=imread(file_name,layer_no);
            if length(size(data))==3
                data=double(data);
                data=data(:,:,1)+data(:,:,2)+data(:,:,3);
            end
        else
            data=evalin('base',file_name);
            map=[];
        end
        
        
        image_axes=info.image_axes;
        axes(image_axes);
        
        
        image_select=info.image_select;
        if get(image_select,'value')==1
            
            % If a new layer use the old colorscale, otherwise, adopt new one
            if strcmp(callstr,'layer_select')
                
                im_hndl=image(data);
                set(im_hndl,'CDatamapping','scaled');
                mintext=info.mintext;
                maxtext=info.maxtext;
                colourmin=info.colourmin;
                colourmax=info.colourmax;
                minval=round(get(colourmin,'value'));
                maxval=round(get(colourmax,'value'));
                caxis([minval maxval]);
                
            else 
                im_hndl=image(data);
                set(im_hndl,'CDatamapping','scaled');
            end
            
        elseif get(image_select,'value')==2
            depth_select=info.depth_select;
            set(gui,'Name',['cview [' int2str(gcf) '] - Contours may take a while to be generated...please be patient']);
            imcontour(data,get(depth_select,'value'));
            set(gui,'Name',['cview [' int2str(gcf) '] - ' orig_pwd]);
        end
        
        
        % If a new file, find out what the colourlimits are and adjust the colourlimits displayed
        if strcmp(callstr,'file_select')
            colourmin=info.colourmin;
            colourmax=info.colourmax;
            mintext=info.mintext;
            maxtext=info.maxtext;
            colour_limits=get(gca,'CLim');
            colour_limits=round(colour_limits);
            if colour_limits(1)<0
                colour_limits(1)=0;
            end
            
            set(colourmin,'value',colour_limits(1));
            set(colourmax,'value',colour_limits(2));
            set(mintext,'value',colour_limits(1));
            set(maxtext,'value',colour_limits(2));
            set(mintext,'string',colour_limits(1));
            set(maxtext,'string',colour_limits(2));
            
        end  
        
        axis image;
        axes_select=info.axes_select;
        if get(axes_select,'value')==0;
            axis off;
        else get(axes_select,'value')==1;
            axis on;
        end
        set(image_axes,'position',[0.05 0.1 0.8 0.8]);
        x=size(data,2);y=size(data,1);
        axis([0.5 x+0.5 0.5 y+0.5]);
        
        % If the zoom has been selected, only display that area
        function_select=info.function_select;
        function_value=get(function_select,'value');
        if function_value==2
            
            data=double(info.data);
            rect=info.rect;
            left=rect(1);
            right=rect(1)+rect(3);
            top=rect(2);
            bottom=rect(2)+rect(4);
            % Verify the limits
            [height width]=size(data);
            if left<1; left=1; end
            if right>width; right=width; end
            if top<1; top=1; end
            if bottom>height; bottom=height; end
            
            xlim([left right]);
            ylim([top bottom]);
        end
        
        colourbar_select=info.colourbar_select;
        if get(colourbar_select,'value')==1
            cbarhndl=colorbar;
            set(cbarhndl,'visible','on');
        else
            cbarhndl=0;
        end
        
        
        % Save the current layer
        
        info.data=data;
        info.map=map;
        info.cbarhndl=cbarhndl;
        set(gui,'userdata',info);
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% forv_toggle_file
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if strcmp(callstr,'forv_toggle_file')
        forv_file=info.forv_file;
        forv_var=info.forv_var;
        set(forv_file,'Value',1);
        set(forv_var,'Value',0);
        cview('filelist_refresh');
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% forv_toggle_var
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if strcmp(callstr,'forv_toggle_var')
        forv_file=info.forv_file;
        forv_var=info.forv_var;
        set(forv_var,'Value',1);
        set(forv_file,'Value',0);
        cview('filelist_refresh');
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% filelist_refresh
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if strcmp(callstr,'filelist_refresh')
        
        forv_file=info.forv_file;
        forv_var=info.forv_var;
        
        if get(forv_file,'Value')==1
            tif_list=dir('*.tif');
            if isunix==1
                TIF_list=dir('*.TIF');
            else
                TIF_list=dir('qqqq.qqqq'); %Just to create an empty structure
            end
            tif_list=cat(1,tif_list,TIF_list); %Add the two lists together
            
            % Put the file names into a single item, and sort it
            for ii = 1:length(tif_list)
                file_list{ii}=tif_list(ii).name;
            end
            % In case can't find any TIF files
            if length(tif_list)==0
                disp('ERROR: No TIFF files in pwd');
                file_list='   ';
            end
        elseif get(forv_var,'Value')==1
            var_list=evalin('base','whos');
            for ii=1:length(var_list)
                file_list{ii}=var_list(ii).name;
            end
            if length(var_list)==0
                disp('ERROR: No variables in workspace');
                file_list='   ';
            end
            
        end
        
        [dummy sort_indx]=sort(file_list);
        file_list=file_list(sort_indx(1:1:end));
        
        file_selected=info.file_selected;
        set(file_selected,'string',file_list,'value',1); 
        info.file_list=file_list;
        set(gui,'userdata',info);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% colour_select
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if strcmp(callstr,'colour_select')
        
        colour_select=info.colour_select;
        
        if get(colour_select,'value')==1
            map=info.map;
            if ~isempty(map)
                colormap(map);
            else 
                map=colormap('gray');
            end
            
        elseif get(colour_select,'value')==2
            
            % Create the colourmap
            n=64;
            red=[zeros(1,n),zeros(1,n),0:1/(n-1):1,ones(1,n)];
            blue=[0:1/(n-1):1,ones(1,n),1:-1/(n-1):0,zeros(1,n)];
            green=[zeros(1,n),0:1/(n-1):1,ones(1,n),1:-1/(n-1):0];
            colormap([red',green',blue']);
            
        elseif get(colour_select,'value')==3
            n=64;
            red=[1:-1/(n-1):0];
            colormap([red',red',red']);
        else
            colours=info.colours;
            current_colour_index=get(colour_select,'value');
            colormap(char(colours(current_colour_index)));
        end   
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% colourbar_reset
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if strcmp(callstr,'colourbar_reset')
        
        % If the zoom was on, turn it off and reset the axis limits
        function_select=info.function_select;
        function_value=get(function_select,'value');
        if function_value==2
            set(function_select,'value',1);
            xlim('auto');
            ylim('auto');
        end
        cview('file_select')
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% colourbar_select
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if strcmp(callstr,'colourbar_select')
        
        cbarhndl=info.cbarhndl;
        if cbarhndl==0
            cbarhndl=colorbar;
            info.cbarhndl=cbarhndl;
            set(gui,'userdata',info);
        end
        
        colourbar_select=info.colourbar_select;
        if get(colourbar_select,'value')==1
            set(cbarhndl,'visible','on');
        else
            set(cbarhndl,'visible','off');
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% axes_select
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if strcmp(callstr,'axes_select')
        
        axes_select=info.axes_select;
        if get(axes_select,'value')==0;
            axis off;
        else get(axes_select,'value')==1;
            axis on;
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% image_select
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if strcmp(callstr,'image_select')
        
        image_axes=info.image_axes;
        data=info.data;
        axes(image_axes);
        
        image_select=info.image_select;
        if get(image_select,'value')==1
            im_hndl=image(data);
            set(im_hndl,'CDatamapping','scaled');
            
        elseif get(image_select,'value')==2
            depth_select=info.depth_select;
            set(gui,'Name',['cview [' int2str(gcf) '] - Contours may take a while to be generated...please be patient']);
            imcontour(data,get(depth_select,'value'));
            orig_pwd=info.orig_pwd;
            set(gui,'Name',['cview [' int2str(gcf) '] - ' orig_pwd]);
        end
        axis image;
        axes_select=info.axes_select;
        if get(axes_select,'value')==0;
            axis off;
        else get(axes_select,'value')==1;
            axis on;
        end
        set(image_axes,'position',[0.05 0.1 0.8 0.8]);
        x=size(data,2);y=size(data,1);
        axis([0 x 0 y]);
        
        colourbar_select=info.colourbar_select;
        if get(colourbar_select,'value')==1
            cbarhndl=colorbar;
            set(cbarhndl,'visible','on');
        else
            cbarhndl=0;
        end
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% colourmin - of the minimum slider was used
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if strcmp(callstr,'colourmin')
        
        colourmin=info.colourmin;
        colourmax=info.colourmax;
        mintext=info.mintext;
        maxtext=info.maxtext;
        
        % Check for the limits, and adjust acordingly
        if get(colourmin,'value')>=get(colourmax,'value')
            if get(colourmin,'value')<=get(colourmin,'max')-1
                set(colourmax,'value',get(colourmin,'value')+1);
            elseif get(colourmin,'value')==get(colourmin,'max')
                set(colourmin,'value',get(colourmin,'max')-1);
                set(colourmax,'value',get(colourmin,'value')+1);
            else
                set(colourmin,'value',get(colourmax,'value')-1);
            end
        end
        
        % Display the limits
        minval=round(get(colourmin,'value'));
        maxval=round(get(colourmax,'value'));
        set(colourmin,'value',minval);
        set(colourmax,'value',maxval);
        set(mintext,'value',minval);
        set(maxtext,'value',maxval);
        set(mintext,'string',minval);
        set(maxtext,'string',maxval);
        
        % Change the image to suit
        caxis([minval maxval]);
    end  
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% colourmax - of the maximum slider was used
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if strcmp(callstr,'colourmax')
        
        colourmin=info.colourmin;
        colourmax=info.colourmax;
        mintext=info.mintext;
        maxtext=info.maxtext;
        
        
        % Check for the limits, and adjust acordingly
        if get(colourmax,'value')<=get(colourmin,'value')
            if get(colourmax,'value')>=get(colourmin,'min')+1
                set(colourmin,'value',get(colourmax,'value')-1);
            elseif get(colourmax,'value')==get(colourmax,'min')
                set(colourmax,'value',get(colourmin,'min')+1);
                set(colourmin,'value',get(colourmax,'value')-1);
            else
                set(colourmin,'value',get(colourmax,'value')-1);
            end
        end
        
        % Display the limits
        minval=round(get(colourmin,'value'));
        maxval=round(get(colourmax,'value'));
        set(colourmin,'value',minval);
        set(colourmax,'value',maxval);
        set(mintext,'value',minval);
        set(maxtext,'value',maxval);
        set(mintext,'string',minval);
        set(maxtext,'string',maxval);
        
        % Change the image to suit
        caxis([minval maxval]);      
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% mintext - if a new minimum has been typed
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if strcmp(callstr,'mintext')
        
        
        colourmin=info.colourmin;
        colourmax=info.colourmax;
        mintext=info.mintext;
        maxtext=info.maxtext;
        
        val_entered=str2num(text_entered);
        if ~isempty(val_entered)
            if val_entered>=get(colourmax,'value')
                if val_entered<=get(colourmin,'max')-1
                    set(colourmax,'value',val_entered+1);
                    set(colourmin,'value',val_entered);
                elseif val_entered==get(colourmin,'max')
                    set(colourmin,'value',get(colourmin,'max')-1);
                    set(colourmax,'value',get(colourmin,'value')+1);
                else
                    set(colourmin,'value',get(colourmax,'value')-1);
                end
            elseif val_entered>get(colourmax,'max')
                set(colourmax,'value',get(colourmax,'max'));
            elseif val_entered<get(colourmax,'min')
                set(colourmin,'value',get(colourmin,'min'));
            else
                set(colourmin,'value',val_entered);
            end
            
            % Display the limits
            minval=round(get(colourmin,'value'));
            maxval=round(get(colourmax,'value'));
            set(colourmin,'value',minval);
            set(colourmax,'value',maxval);
            set(mintext,'value',minval);
            set(maxtext,'value',maxval);
            set(mintext,'string',minval);
            set(maxtext,'string',maxval);
            
            caxis([minval maxval]);
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% maxtext - if a new maximum has been typed
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if strcmp(callstr,'maxtext')
        
        colourmin=info.colourmin;
        colourmax=info.colourmax;
        mintext=info.mintext;
        maxtext=info.maxtext;
        
        
        val_entered=str2num(text_entered);
        if ~isempty(val_entered)
            
            if val_entered<=get(colourmin,'value')
                if val_entered>=get(colourmax,'min')+1
                    set(colourmin,'value',val_entered-1);
                    set(colourmax,'value',val_entered);
                elseif val_entered==get(colourmax,'min')
                    set(colourmax,'value',get(colourmin,'min')+1);
                    set(colourmin,'value',get(colourmax,'value')-1);
                else
                    set(colourmin,'value',get(colourmax,'value')-1);
                end
            elseif val_entered>get(colourmax,'max')
                set(colourmax,'value',get(colourmax,'max'));
            elseif val_entered<get(colourmax,'min')
                set(colourmin,'value',get(colourmin,'min'));
            else 
                set(colourmax,'value',val_entered);
            end
            
            minval=round(get(colourmin,'value'));
            maxval=round(get(colourmax,'value'));
            
            % Display the limits
            minval=round(get(colourmin,'value'));
            maxval=round(get(colourmax,'value'));
            set(colourmin,'value',minval);
            set(colourmax,'value',maxval);
            set(mintext,'value',minval);
            set(maxtext,'value',maxval);
            set(mintext,'string',minval);
            set(maxtext,'string',maxval);
            
            caxis([minval maxval]);
        end
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% colourbar_refresh
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if strcmp(callstr,'colourbar_refresh')
        cbarhndl=colorbar;
        info.cbarhndl=cbarhndl;
        set(gui,'userdata',info);
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% function_select
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if strcmp(callstr,'function_select')
        function_select=info.function_select;
        function_value=get(function_select,'value');
        if function_value==1
            data=double(info.data);
            rect=getrect;
            rect=round(rect);
            left=rect(1);
            right=rect(1)+rect(3);
            top=rect(2);
            bottom=rect(2)+rect(4);
            % Verify the limits
            [height width]=size(data);
            if left<1; left=1; end
            if right>width; right=width; end
            if top<1; top=1; end
            if bottom>height; bottom=height; end
            data=data(top:bottom,left:right);
            data_min=min(min(data));
            data_max=max(max(data));
            % Find the average value of the selected data
            data_ave=mean(mean(data));
            
            % Find the RMS
            data_rms=sqrt(sum(sum((data-data_ave).^2))/(size(data,1)*size(data,2)));
            
            % Create a figure to display the results
            res_figure=figure('NumberTitle','off','IntegerHandle','off','MenuBar', 'none','Name','Selected area properties','position',[250 600 220 140]);
            
            uicontrol(res_figure,'style','text','FontWeight','bold','string',['Start (x,y) = ' int2str(left) ',' int2str(top)],'position',[10 110 200 20]);
            uicontrol(res_figure,'style','text','FontWeight','bold','string',['End (x,y) = ' int2str(right) ',' int2str(bottom)],'position',[10 90 200 20]);
            uicontrol(res_figure,'style','text','FontWeight','bold','string',['Minimum pixel value = ' int2str(data_min)],'position',[10 70 200 20]);
            uicontrol(res_figure,'style','text','FontWeight','bold','string',['Maximum pixel value = ' int2str(data_max)],'position',[10 50 200 20]);
            uicontrol(res_figure,'style','text','FontWeight','bold','string',['Average value = ' num2str(data_ave)],'position',[10 30 200 20]);
            uicontrol(res_figure,'style','text','FontWeight','bold','string',['RMS = ' num2str(data_rms)],'position',[10 10 200 20]);
        end
        
        if function_value==2 % zoom
            data=double(info.data);
            rect=getrect;
            rect=round(rect);
            left=rect(1);
            right=rect(1)+rect(3);
            top=rect(2);
            bottom=rect(2)+rect(4);
            % Verify the limits
            [height width]=size(data);
            if left<1; left=1; end
            if right>width; right=width; end
            if top<1; top=1; end
            if bottom>height; bottom=height; end
            
            xlim([left right]);
            ylim([top bottom]);
            
            % Save the rectangle (not the limits, as these may change with a new image/layer
            info.rect=rect;
            set(gui,'userdata',info);
        end
        
        if function_value==3 % Line profile
            c=improfile;
            figure;
            plot(1:length(c),c);
            axis([0 length(c) 0 max(c)]);
            xlabel('Distance along line (pixels)');
            ylabel('Intensity');
        end
        
        if (function_value==4) | (function_value==5) % X- or Y- Profile
            data=double(info.data);
            rect=getrect;
            rect=round(rect);
            left=rect(1);
            right=rect(1)+rect(3);
            top=rect(2);
            bottom=rect(2)+rect(4);
            % Verify the limits
            [height width]=size(data);
            if left<1; left=1; end
            if right>width; right=width; end
            if top<1; top=1; end
            if bottom>height; bottom=height; end
            data=data(top:bottom,left:right); 
            
            %Find the cross section sum
            if function_value==4
                beam_cs=sum(data,1); 
                beam_sf=(beam_cs/max(beam_cs)); %Beam scaling factor
                figure;
                plot(left:right,beam_sf.*100);title('Normalised Intensity Profile (%)');
                axis([left right 0 100]);
                xlabel('Vertical column (pixel)');
                ylabel('Intensity (%)');
            elseif function_value==5
                beam_cs=sum(data,2); 
                beam_sf=(beam_cs/max(beam_cs)); %Beam scaling factor
                figure;
                yvec=top:bottom;
                plot(beam_sf.*100,yvec);title('Normalised Intensity Profile (%)');
                axis ij
                axis([0 100 top bottom]);
                xlabel('Intensity (%)');
                ylabel('Horizontal row (pixel)');
            end
        end
        if function_value==6
            data=double(info.data);
            [x,y]=meshgrid(1:size(data,2),1:size(data,1));
            surf(x,y,data);
            rotate3d;
        end
        
        if function_value==7 % Average
            
            % Check to see in the correct directory, if not move to it
            orig_pwd=info.orig_pwd;
            current_pwd=pwd;
            if strcmp(orig_pwd,current_pwd)==0
                cd(orig_pwd)
            end
            
            % Extract the file_name
            file_selected=info.file_selected;
            file_list=info.file_list;
            % Get the handle for the selected file
            current_file=get(file_selected,'value');
            % Find the name of the corresponding file
            file_name=char(file_list(current_file));
            
            no_layers=length(imfinfo(file_name));
            h=waitbar(0,'Please Wait');
            data=0;
            for layer=2:no_layers
                data=data+double((imread(file_name,layer)));
                waitbar(layer/no_layers);
            end
            averaged=data/no_layers;
            close(h);
            
            if findstr(file_name,'.TIF')~=[]
                file_name=strrep(file_name,'.TIF','');
            else
                file_name=strrep(file_name,'.tif','');
            end
            imwrite(uint16(averaged),[file_name '_averaged.tif']);
            cview('filelist_refresh');
        end
        
        
        
        if function_value==8 % Save
            image_axes=info.image_axes;
            image_frame=getframe(image_axes);
            str1='Enter filename:'; % Prompt text
            str2='Save current image'; % Figure title
            str3={'.tif'}; % Default text
            res=inputdlg(str1,str2,1,str3);
            if ~isempty(res)
                imwrite(uint8(image_frame.cdata),char(res));
            end
        end
        
    end
    
    if ~isunix
        pixval on;
    end
    
end
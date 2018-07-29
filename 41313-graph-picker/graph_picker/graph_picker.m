function  [X, Y, axis_data, im]=graph_picker( im )
%graph_picker()
%Allows one to pick points off of a graph contained in image im, or loaded
%from file or pasted via gui.
%First pick two reference lines in each of x and y directions (using "Pick"
%buttons) and enter graph values.  You may then pick points with the "Points"
%button which appears in the GUI.  When done picking points, a right-click
%outputs all selected points to standard output.
%You may also use this tool to get the axes() coefficients for use when
%plotting over an image.
%This requires the imclipboard and rotate_image functions in your path
%(available from the Matlab File Exchange)

%Copyright Travis Wiens travis.mlfx@nutaksas.com

%% Initialize

if nargin<1
    im=zeros(2,2);%initial image if none specified
end

N_argout=nargout;%copy to variable

figsize=[150 50 800 600];%initial figure size
set(0,'defaultfigureposition',figsize);
h_fig=figure;
set(h_fig,'name','Data Picker','resize','off','color',[.82 .82 .82],'toolbar','figure');

%set up some figure parameters
fontsize=10;
linespace=35;%(pixels) spacing between lines
leftmargin=25;%
topmargin=25;
buttonheight=25;%
buttonwidth=60;%
buttonspacing=10;
buttonwidth2=2*buttonwidth+buttonspacing;%

textwidth=400;
textheight=buttonheight;

hpos=figsize(4)-topmargin;%running horizontal postion
vpos=leftmargin;


%define some colours
green=[0 1 0];
red=[1 0 0];
textgrey=[0.5 0.5 0.5];
bkcolor=get(gcf,'color');

X_ref_px=[10 size(im,2)-10];
Y_ref_px=[size(im,1)-10 10];

X_ref_val=[0 100];
Y_ref_val=[0 100];

Points_save=[];

quit_flag=false;%this will be set to true by Quit button
%h_imax=axes('position',[0.03  0.03  0.94  .70]);
h_imax=axes('position',[0.01  0.01  0.98  .65]);


update_plot(im,X_ref_px,Y_ref_px,X_ref_val,Y_ref_val, h_imax);

%% Load Image
h_load=uicontrol('Style','pushbutton','String','Load Image','position',...
    [vpos hpos buttonwidth2 buttonheight],'callback',@fcn_load,'fontsize',fontsize,...
    'tooltip','Select image from file');
    function fcn_load(hObject,evendata,handles)
        fname_default='*';
        fm='*.*';
        [fname,pname] = uigetfile(fm,'Select Image File');
        if (fname ~= 0)
            filename = sprintf('%s%s',pname,fname);
            im=imread(filename);
        else
            warning('Image load error')
            warndlg('Image Load Error')
        end
        X_ref_px=[10 size(im,2)-10];
        Y_ref_px=[size(im,1)-10 10];
        X_ref_val=[str2double(get(h_X_ref_val1,'String')) str2double(get(h_X_ref_val2,'String'))];
        Y_ref_val=[str2double(get(h_Y_ref_val1,'String')) str2double(get(h_Y_ref_val2,'String'))];
        update_plot(im,X_ref_px,Y_ref_px,X_ref_val,Y_ref_val, h_imax);
        
    end
vpos=vpos+buttonwidth2+buttonspacing;


%% Paste Image
h_paste=uicontrol('Style','pushbutton','String','Paste Image','position',...
    [vpos hpos buttonwidth2 buttonheight],'callback',@fcn_paste,'fontsize',fontsize,...
    'tooltip','Paste image from clipboard');

if ~exist('imclipboard','file')
    set(h_paste,'ForegroundColor',textgrey);
    set(h_paste,'tooltip','imclipboard package required, available from Matlab File Exchange')
    set(h_paste,'callback','');
end

    function fcn_paste(hObject,evendata,handles)
        im=imclipboard('paste');
        X_ref_px=[10 size(im,2)-10];
        Y_ref_px=[size(im,1)-10 10];
        X_ref_val=[str2double(get(h_X_ref_val1,'String')) str2double(get(h_X_ref_val2,'String'))];
        Y_ref_val=[str2double(get(h_Y_ref_val1,'String')) str2double(get(h_Y_ref_val2,'String'))];
        update_plot(im,X_ref_px,Y_ref_px,X_ref_val,Y_ref_val, h_imax);
        
    end
vpos=vpos+buttonwidth2+buttonspacing;


%% Rotate Image
h_rotate=uicontrol('Style','pushbutton','String','Rotate Image','position',...
    [vpos hpos buttonwidth2 buttonheight],'callback',@fcn_rotate,'fontsize',fontsize,...
    'tooltip','Rotate image by aligning two horizontal points');

if ~exist('rotate_image','file')
    set(h_rotate,'ForegroundColor',textgrey);
    set(h_rotate,'tooltip','rotate_image package required, available from Matlab File Exchange')
    set(h_rotate,'callback','');
end

    function fcn_rotate(hObject,evendata,handles)
        set(h_instr,'String','Click two horizontal points on graph (right click to cancel)')
        X_ref_val=[str2double(get(h_X_ref_val1,'String')) str2double(get(h_X_ref_val2,'String'))];
        Y_ref_val=[str2double(get(h_Y_ref_val1,'String')) str2double(get(h_Y_ref_val2,'String'))];
        update_plot(im,X_ref_px,Y_ref_px,X_ref_val,Y_ref_val, h_imax)
        [x1, y1, button] = ginput(1);
        if button==1
            [x2, y2, button] = ginput(1);
            if button==1
                theta=atan((y2-y1)/(x2-x1))*180/pi;
                %must rotate three colors separately
                im_tmp_r=rotate_image( theta, double(im(:,:,1)));
                im_tmp_g=rotate_image( theta, double(im(:,:,2)));
                im_tmp_b=rotate_image( theta, double(im(:,:,3)));
                im=zeros(size(im_tmp_r,1),size(im_tmp_r,2),3,'uint8');
                im(:,:,1)=uint8(im_tmp_r);
                im(:,:,2)=uint8(im_tmp_g);
                im(:,:,3)=uint8(im_tmp_b);
            end
        end
        X_ref_val=[str2double(get(h_X_ref_val1,'String')) str2double(get(h_X_ref_val2,'String'))];
        Y_ref_val=[str2double(get(h_Y_ref_val1,'String')) str2double(get(h_Y_ref_val2,'String'))];
        update_plot(im,X_ref_px,Y_ref_px,X_ref_val,Y_ref_val, h_imax)
        set(h_instr,'String','')
    end
vpos=vpos+buttonwidth2+buttonspacing;

hpos=hpos-linespace;
vpos=leftmargin;

%% Select References

tmp=uicontrol('Style','text','String','Pick 4 Calibration Points (2 X, 2 Y)','Position',[vpos hpos textwidth textheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','left');

hpos=hpos-linespace;
vpos=leftmargin;
tmp=uicontrol('Style','text','String','X 1','Position',[vpos hpos buttonwidth buttonheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','left',...
    'tooltip','Pick first horizontal reference point and enter value');
vpos=vpos+buttonwidth+buttonspacing;

tmp=uicontrol('Style','pushbutton','String','Pick','position',...
    [vpos hpos buttonwidth buttonheight],'callback',@fcn_pick_x1,'fontsize',fontsize,...
    'tooltip','Pick first horizontal reference point and enter value');
    function fcn_pick_x1(hObject,evendata,handles)
        set(h_instr,'String','Click Horizontal Calibration Point on Graph')
        X_ref_val=[str2double(get(h_X_ref_val1,'String')) str2double(get(h_X_ref_val2,'String'))];
        Y_ref_val=[str2double(get(h_Y_ref_val1,'String')) str2double(get(h_Y_ref_val2,'String'))];
        update_plot(im,X_ref_px,Y_ref_px,X_ref_val,Y_ref_val, h_imax)
        [x, y, button] = ginput(1);
        if button==1
            X_ref_px(1)=x;
        end
        %set(h_X_ref_px1,'String',sprintf('%0.1f',X_ref_px(1)));
        X_ref_val=[str2double(get(h_X_ref_val1,'String')) str2double(get(h_X_ref_val2,'String'))];
        Y_ref_val=[str2double(get(h_Y_ref_val1,'String')) str2double(get(h_Y_ref_val2,'String'))];
        update_plot(im,X_ref_px,Y_ref_px,X_ref_val,Y_ref_val, h_imax)
        set(h_instr,'String','')
    end
vpos=vpos+buttonwidth+buttonspacing;

tmp=uicontrol('Style','text','String','Value:','Position',[vpos hpos buttonwidth buttonheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','left',...
    'tooltip','Pick first horizontal reference point and enter value');
vpos=vpos+buttonwidth+buttonspacing;

h_X_ref_val1=uicontrol('Style','edit','String',sprintf('%0.1f',X_ref_val(1)),'Position',[vpos hpos buttonwidth buttonheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','left',...
    'tooltip','Pick first horizontal reference point and enter value');
vpos=vpos+2*(buttonwidth+buttonspacing);

%%%%%%%%%%%%

tmp=uicontrol('Style','text','String','X 2','Position',[vpos hpos buttonwidth buttonheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','left',...
    'tooltip','Pick second horizontal reference point and enter value');
vpos=vpos+buttonwidth+buttonspacing;

tmp=uicontrol('Style','pushbutton','String','Pick','position',...
    [vpos hpos buttonwidth buttonheight],'callback',@fcn_pick_x2,'fontsize',fontsize,...
    'tooltip','Pick second horizontal reference point and enter value');
    function fcn_pick_x2(hObject,evendata,handles)
        set(h_instr,'String','Click Horizonatl Calibration Point on Graph')
        X_ref_val=[str2double(get(h_X_ref_val1,'String')) str2double(get(h_X_ref_val2,'String'))];
        Y_ref_val=[str2double(get(h_Y_ref_val1,'String')) str2double(get(h_Y_ref_val2,'String'))];
        update_plot(im,X_ref_px,Y_ref_px,X_ref_val,Y_ref_val, h_imax)
        [x, y, button] = ginput(1);
        if button==1
            X_ref_px(2)=x;
        end
        %set(h_X_ref_px2,'String',sprintf('%0.1f',X_ref_px(2)));
        X_ref_val=[str2double(get(h_X_ref_val1,'String')) str2double(get(h_X_ref_val2,'String'))];
        Y_ref_val=[str2double(get(h_Y_ref_val1,'String')) str2double(get(h_Y_ref_val2,'String'))];
        update_plot(im,X_ref_px,Y_ref_px,X_ref_val,Y_ref_val, h_imax)
        set(h_instr,'String','')
    end
vpos=vpos+buttonwidth+buttonspacing;

tmp=uicontrol('Style','text','String','Value:','Position',[vpos hpos buttonwidth buttonheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','left',...
    'tooltip','Pick second horizontal reference point and enter value');
vpos=vpos+buttonwidth+buttonspacing;

h_X_ref_val2=uicontrol('Style','edit','String',sprintf('%0.1f',X_ref_val(2)),'Position',[vpos hpos buttonwidth buttonheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','left',...
    'tooltip','Pick second horizontal reference point and enter value');
vpos=vpos+buttonwidth+buttonspacing;

%%%%
tmp=uicontrol('Style','text','String','Log','Position',[vpos hpos buttonwidth buttonheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','right',...
    'tooltip','Check here for logarithmic scaling on the x axis');
vpos=vpos+buttonwidth+buttonspacing;

h_log_x=uicontrol('Style','checkbox','value',false,'Position',[vpos hpos buttonwidth buttonheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','right',...
    'tooltip','Check here for logarithmic scaling on the x axis');
vpos=vpos+buttonwidth+buttonspacing;

hpos=hpos-linespace;
vpos=leftmargin;

%%%%%%%
tmp=uicontrol('Style','text','String','Y 1','Position',[vpos hpos buttonwidth buttonheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','left',...
    'tooltip','Pick first vertical reference point and enter value');
vpos=vpos+buttonwidth+buttonspacing;

tmp=uicontrol('Style','pushbutton','String','Pick','position',...
    [vpos hpos buttonwidth buttonheight],'callback',@fcn_pick_y1,'fontsize',fontsize,...
    'tooltip','Pick first vertical reference point and enter value');
    function fcn_pick_y1(hObject,evendata,handles)
        set(h_instr,'String','Click Vertical Calibration Point on Graph')
        X_ref_val=[str2double(get(h_X_ref_val1,'String')) str2double(get(h_X_ref_val2,'String'))];
        Y_ref_val=[str2double(get(h_Y_ref_val1,'String')) str2double(get(h_Y_ref_val2,'String'))];
        update_plot(im,X_ref_px,Y_ref_px,X_ref_val,Y_ref_val, h_imax)
        [x, y, button] = ginput(1);
        if button==1
            Y_ref_px(1)=y;
        end
        %set(h_Y_ref_px1,'String',sprintf('%0.1f',Y_ref_px(1)));
        X_ref_val=[str2double(get(h_X_ref_val1,'String')) str2double(get(h_X_ref_val2,'String'))];
        Y_ref_val=[str2double(get(h_Y_ref_val1,'String')) str2double(get(h_Y_ref_val2,'String'))];
        update_plot(im,X_ref_px,Y_ref_px,X_ref_val,Y_ref_val, h_imax)
        set(h_instr,'String','')
    end
vpos=vpos+buttonwidth+buttonspacing;

tmp=uicontrol('Style','text','String','Value:','Position',[vpos hpos buttonwidth buttonheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','left',...
    'tooltip','Pick first vertical reference point and enter value');
vpos=vpos+buttonwidth+buttonspacing;

h_Y_ref_val1=uicontrol('Style','edit','String',sprintf('%0.1f',Y_ref_val(1)),'Position',[vpos hpos buttonwidth buttonheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','left',...
    'tooltip','Pick first vertical reference point and enter value');
vpos=vpos+2*(buttonwidth+buttonspacing);

%%%%%%%%%%%%

tmp=uicontrol('Style','text','String','Y 2','Position',[vpos hpos buttonwidth buttonheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','left',...
    'tooltip','Pick second vertical reference point and enter value');
vpos=vpos+buttonwidth+buttonspacing;

tmp=uicontrol('Style','pushbutton','String','Pick','position',...
    [vpos hpos buttonwidth buttonheight],'callback',@fcn_pick_y2,'fontsize',fontsize,...
    'tooltip','Pick second vertical reference point and enter value');
    function fcn_pick_y2(hObject,evendata,handles)
        set(h_instr,'String','Click Vertical Calibration Point on Graph')
        X_ref_val=[str2double(get(h_X_ref_val1,'String')) str2double(get(h_X_ref_val2,'String'))];
        Y_ref_val=[str2double(get(h_Y_ref_val1,'String')) str2double(get(h_Y_ref_val2,'String'))];
        update_plot(im,X_ref_px,Y_ref_px,X_ref_val,Y_ref_val, h_imax)
        [x, y, button] = ginput(1);
        if button==1
            Y_ref_px(2)=y;
        end
        %set(h_Y_ref_px2,'String',sprintf('%0.1f',Y_ref_px(2)));
        X_ref_val=[str2double(get(h_X_ref_val1,'String')) str2double(get(h_X_ref_val2,'String'))];
        Y_ref_val=[str2double(get(h_Y_ref_val1,'String')) str2double(get(h_Y_ref_val2,'String'))];
        update_plot(im,X_ref_px,Y_ref_px,X_ref_val,Y_ref_val, h_imax)
        set(h_instr,'String','')
    end
vpos=vpos+buttonwidth+buttonspacing;

tmp=uicontrol('Style','text','String','Value:','Position',[vpos hpos buttonwidth buttonheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','left',...
    'tooltip','Pick second vertical reference point and enter value');
vpos=vpos+buttonwidth+buttonspacing;

h_Y_ref_val2=uicontrol('Style','edit','String',sprintf('%0.1f',Y_ref_val(2)),'Position',[vpos hpos buttonwidth buttonheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','left',...
    'tooltip','Pick second vertical reference point and enter value');
vpos=vpos+buttonwidth+buttonspacing;

%%%%
tmp=uicontrol('Style','text','String','Log','Position',[vpos hpos buttonwidth buttonheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','right',...
    'tooltip','Check here for logarithmic scaling on the y axis');
vpos=vpos+buttonwidth+buttonspacing;

h_log_y=uicontrol('Style','checkbox','value',false,'Position',[vpos hpos buttonwidth buttonheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','right',...
    'tooltip','Check here for logarithmic scaling on the y axis');
vpos=vpos+buttonwidth+buttonspacing;

hpos=hpos-linespace;
vpos=leftmargin;

%% Point Picking
tmp=uicontrol('Style','pushbutton','String','Points','position',...
    [vpos hpos buttonwidth buttonheight],'callback',@fcn_pick_point,'fontsize',fontsize,...
    'tooltip','Click this button to begin selecting points. The (x,y) values at these points will be returned.');
    function fcn_pick_point(hObject,evendata,handles)
        set(h_instr,'String','Click Points (Right Click to Stop)')
        
        X_ref_val=[str2double(get(h_X_ref_val1,'String')) str2double(get(h_X_ref_val2,'String'))];
        Y_ref_val=[str2double(get(h_Y_ref_val1,'String')) str2double(get(h_Y_ref_val2,'String'))];
        
        update_plot(im,X_ref_px,Y_ref_px,X_ref_val,Y_ref_val, h_imax)
        
        flag_run=true;
        Points_save=[];
        
        while (flag_run)
            [x, y, button] = ginput(1);
            
            if button==1
                if get(h_log_x,'value')
                    X_val=exp(log(X_ref_val(1))+(log(X_ref_val(2))-log(X_ref_val(1)))*(x-X_ref_px(1))/diff(X_ref_px));
                else
                    X_val=X_ref_val(1)+(x-X_ref_px(1))*diff(X_ref_val)/diff(X_ref_px);
                end
                if abs(X_val)>1e3|abs(X_val)<1
                    set(h_X_val,'String',sprintf('%0.3e',X_val));
                else
                    set(h_X_val,'String',sprintf('%0.3f',X_val));
                end
                if get(h_log_y,'value')
                    Y_val=exp(log(Y_ref_val(1))+(log(Y_ref_val(2))-log(Y_ref_val(1)))*(y-Y_ref_px(1))/diff(Y_ref_px));
                else
                    Y_val=Y_ref_val(1)+(y-Y_ref_px(1))*diff(Y_ref_val)/diff(Y_ref_px);
                end
                if abs(Y_val)>1e3||abs(Y_val)<1
                    set(h_Y_val,'String',sprintf('%0.3e',Y_val));
                else
                    set(h_Y_val,'String',sprintf('%0.3f',Y_val));
                end
                
                Points_save=[Points_save;X_val Y_val];
                hold on
                plot(x,y,'r*');
                hold off
            else
                flag_run=false;
            end
        end
        fprintf('X=[')
        fprintf('%e ',Points_save(:,1))
        fprintf('];\nY=[')
        fprintf('%e ',Points_save(:,2))
        fprintf('];\n')
        
        set(h_instr,'String','')
    end
vpos=vpos+buttonwidth+buttonspacing;

tmp=uicontrol('Style','text','String','X:','Position',[vpos hpos 0.5*buttonwidth buttonheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','right');
vpos=vpos+0.5*buttonwidth+buttonspacing;

h_X_val=uicontrol('Style','text','String','0.0','Position',[vpos hpos 1.5*buttonwidth buttonheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','left');
vpos=vpos+1.5*buttonwidth+buttonspacing;

tmp=uicontrol('Style','text','String','Y:','Position',[vpos hpos 0.5*buttonwidth buttonheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','right');
vpos=vpos+0.5*buttonwidth+buttonspacing;

h_Y_val=uicontrol('Style','text','String','0.0','Position',[vpos hpos 1.5*buttonwidth buttonheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','left');
vpos=vpos+1.5*buttonwidth+buttonspacing;



%% Output axes info
tmp=uicontrol('Style','pushbutton','String','Get Axes','position',...
    [vpos hpos buttonwidth buttonheight],'callback',@fcn_axes,'fontsize',fontsize,...
    'tooltip','Get axes information. This can be used for plotting over the image.');
    function fcn_axes(hObject,evendata,handles)
        X_ref_val=[str2double(get(h_X_ref_val1,'String')) str2double(get(h_X_ref_val2,'String'))];
        Y_ref_val=[str2double(get(h_Y_ref_val1,'String')) str2double(get(h_Y_ref_val2,'String'))];
        
        x_min=1;
        y_min=1;
        y_max=size(im,1);
        x_max=size(im,2);
        
        
        
        
        if get(h_log_x,'value')
            X_0=exp(log(X_ref_val(1))+(x_min-X_ref_px(1))*(log(X_ref_val(2))-log(X_ref_val(1)))/diff(X_ref_px));
            X_1=exp(log(X_ref_val(1))+(x_max-X_ref_px(1))*(log(X_ref_val(2))-log(X_ref_val(1)))/diff(X_ref_px));
        else
            X_0=X_ref_val(1)+(x_min-X_ref_px(1))*diff(X_ref_val)/diff(X_ref_px);
            X_1=X_ref_val(1)+(x_max-X_ref_px(1))*diff(X_ref_val)/diff(X_ref_px);
        end
        if get(h_log_y,'value')
            Y_1=exp(log(Y_ref_val(1))+(y_min-Y_ref_px(1))*(log(Y_ref_val(2))-log(Y_ref_val(1)))/diff(Y_ref_px));
            Y_0=exp(log(Y_ref_val(1))+(y_max-Y_ref_px(1))*(log(Y_ref_val(2))-log(Y_ref_val(1)))/diff(Y_ref_px));
            
        else
            Y_1=Y_ref_val(1)+(y_min-Y_ref_px(1))*diff(Y_ref_val)/diff(Y_ref_px);
            Y_0=Y_ref_val(1)+(y_max-Y_ref_px(1))*diff(Y_ref_val)/diff(Y_ref_px);
        end
        
        set(h_axes,'String',sprintf('%0.3e %0.3e %0.3e %0.3e',X_0,X_1,Y_0,Y_1));
        
        fprintf('axis([%0.3e %0.3e %0.3e %0.3e])\n',X_0,X_1,Y_0,Y_1);
    end
vpos=vpos+buttonwidth+buttonspacing;

h_axes=uicontrol('Style','edit','String','-','Position',[vpos hpos 5*buttonwidth buttonheight],...
    'backgroundcolor',bkcolor,'fontsize',fontsize,'HorizontalAlignment','left');




%% Quit


hpos=hpos-linespace;
vpos=leftmargin;

tmp=uicontrol('Style','pushbutton','String','Quit','position',...
    [vpos hpos buttonwidth buttonheight],'callback',@fcn_exit,'fontsize',fontsize);
    function fcn_exit(hObject,evendata,handles)
        
        if N_argout>0
            quit_flag=true;
        else
            close(h_fig);
        end
    end
vpos=vpos+buttonwidth+buttonspacing;


%% Help
tmp=uicontrol('Style','pushbutton','String','Help','position',...
    [vpos hpos buttonwidth buttonheight],'callback',@fcn_help,'fontsize',fontsize);
    function fcn_help(hObject,evendata,handles)
        
        %set(h_instr,'String','Call Travis (306) 986-9168')
        msgbox(sprintf('This GUI is used to help read data points off of a graph.\nFirst, select known data points from the graph and enter the graph values into the corresponding edit boxes.\nThen click the ''Points'' button to select desired data points.  The x,y data pairs will be displayed in the GUI. When done, right click and the series of points will be output to the terminal.\nThe ''Get Axis'' button may be used to get axis data for use if you later want to plot data over the image with the same scale.'))
        
    end
vpos=vpos+buttonwidth+buttonspacing;



%% Instructions Field
h_instr=uicontrol('Style','text','String','','Position',[vpos hpos 390 25],...
    'backgroundcolor',bkcolor,'fontsize',fontsize+2,'fontweight','bold','HorizontalAlignment','left');


%% Exit
if N_argout>0
    while(quit_flag==false)
        pause(1)
    end
    
    
    if isempty(Points_save)
        X=[];
        Y=[];
    else
        X=Points_save(:,1);
        Y=Points_save(:,2);
    end
    
    X_ref_val=[str2double(get(h_X_ref_val1,'String')) str2double(get(h_X_ref_val2,'String'))];
    Y_ref_val=[str2double(get(h_Y_ref_val1,'String')) str2double(get(h_Y_ref_val2,'String'))];
    
    x_min=1;
    y_min=1;
    y_max=size(im,1);
    x_max=size(im,2);
    
    X_0=X_ref_val(1)+(x_min-X_ref_px(1))*diff(X_ref_val)/diff(X_ref_px);
    X_1=X_ref_val(1)+(x_max-X_ref_px(1))*diff(X_ref_val)/diff(X_ref_px);
    Y_1=Y_ref_val(1)+(y_min-Y_ref_px(1))*diff(Y_ref_val)/diff(Y_ref_px);
    Y_0=Y_ref_val(1)+(y_max-Y_ref_px(1))*diff(Y_ref_val)/diff(Y_ref_px);
    
    
    axis_data=[X_0,X_1,Y_0,Y_1];
    
    close(h_fig);
end

end




%%%%%%%%%%%%%%%%%%
function update_plot(im,X_ref_px,Y_ref_px,X_ref_val,Y_ref_val, h_imax)
axes(h_imax)
cla
image(im);
hold on

plot(X_ref_px(1)*[1 1],[1 size(im,1)],':r');
plot(X_ref_px(2)*[1 1],[1 size(im,1)],':r');
plot([1 size(im,2)],Y_ref_px(1)*[1 1],':r');
plot([1 size(im,2)],Y_ref_px(2)*[1 1],':r');
text(X_ref_px(1),size(im,1),num2str(X_ref_val(1)),'color','r');
text(X_ref_px(2),size(im,1),num2str(X_ref_val(2)),'color','r');
text(0,Y_ref_px(1),num2str(Y_ref_val(1)),'color','r');
text(0,Y_ref_px(2),num2str(Y_ref_val(2)),'color','r');

set(gca,'YTick',[])
set(gca,'XTick',[])

hold off

end

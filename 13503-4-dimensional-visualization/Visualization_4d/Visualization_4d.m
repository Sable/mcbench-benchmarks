function varargout = Visualization_4d(varargin)
% VISUALIZATION_4D M-file for Visualization_4d.fig
%      VISUALIZATION_4D, by itself, creates a new VISUALIZATION_4D or raises the existing
%      singleton*.
%
%      H = VISUALIZATION_4D returns the handle to a new VISUALIZATION_4D or the handle to
%      the existing singleton*.
%
%      VISUALIZATION_4D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VISUALIZATION_4D.M with the given input arguments.
%
%      VISUALIZATION_4D('Property','Value',...) creates a new VISUALIZATION_4D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Visualization_4d_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Visualization_4d_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help Visualization_4d

% Last Modified by GUIDE v2.5 07-Feb-2007 22:44:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Visualization_4d_OpeningFcn, ...
                   'gui_OutputFcn',  @Visualization_4d_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Visualization_4d is made visible.
function Visualization_4d_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Visualization_4d (see VARARGIN)

% Choose default command line output for Visualization_4d
handles.output = hObject;

handles.folder=[pwd '/Visual_Data/'];
d = dir([handles.folder '*.mat']);
handles.datalist=char(d.name);

if isempty(handles.datalist)==1
    set(handles.select_data,'String','Visual_Data - Folder is Empty')
else
    set(handles.select_data,'String',handles.datalist)
end

handles.cbar=0;
guidata(hObject, handles);

% UIWAIT makes Visualization_4d wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Visualization_4d_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in rotate.
function rotate_Callback(hObject, eventdata, handles)
% hObject    handle to rotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rotate

handles=guidata(gcbo);

if get(hObject,'Value')==get(hObject,'Max')
    rotate3d on
else
    rotate3d off
end
    
guidata(gcbo,handles)





% --- Executes on button press in boundary_slices.
function boundary_slices_Callback(hObject, eventdata, handles)
% hObject    handle to boundary_slices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of boundary_slices
handles=guidata(gcbo);

if get(hObject,'Value')==get(hObject,'Max')
    set(handles.boundary,'Visible','on')
else
    set(handles.boundary,'Visible','off')
end
    
guidata(gcbo,handles)




% --- Executes on button press in grid_on_slice.
function grid_on_slice_Callback(hObject, eventdata, handles)
% hObject    handle to grid_on_slice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of grid_on_slice


handles=guidata(gcbo);

if get(hObject,'Value')==get(hObject,'Max')
    set(handles.boundary,'EdgeColor','k')
    set(handles.sliceplane_x,'EdgeColor','k')
    set(handles.sliceplane_y,'EdgeColor','k')
    set(handles.sliceplane_z,'EdgeColor','k')
    
else
    set(handles.boundary,'EdgeColor','none')
    set(handles.sliceplane_x,'EdgeColor','none')
    set(handles.sliceplane_y,'EdgeColor','none')
    set(handles.sliceplane_z,'EdgeColor','none')
end
    
guidata(gcbo,handles)

% --- Executes on button press in grid_on.
function grid_on_Callback(hObject, eventdata, handles)
% hObject    handle to grid_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of grid_on


handles=guidata(gcbo);

if get(hObject,'Value')==get(hObject,'Max')
    grid on
else
    grid off
end
    
guidata(gcbo,handles)



% --- Executes on slider movement.
function x_slider_Callback(hObject, eventdata, handles)
% hObject    handle to x_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles=guidata(gcbo);

i=get(hObject,'Value');

axes(handles.axes1)
delete(handles.sliceplane_x)
handles.sliceplane_x=slice(handles.X,handles.Y,handles.Z,handles.V,i,[],[]);

if get(handles.grid_on_slice,'Value')==0
    
    delete(handles.sliceplane_x_boundary)
    handles.sliceplane_x_boundary=plot3([i i i i i],[handles.ymin handles.ymax handles.ymax handles.ymin handles.ymin],...
        [handles.zmin handles.zmin handles.zmax handles.zmax handles.zmin],'k');
end

set(handles.sliceplane_x,'FaceColor','interp')

% set(handles.sliceplane_x,'Visible','off')
% set(handles.sliceplane_x(i),'Visible','on')

if get(handles.grid_on_slice,'Value')==get(handles.grid_on_slice,'Min')
    set(handles.sliceplane_x,'EdgeColor','none')
end
set(handles.sliceplane_x,'Visible','on')

set(handles.x_slice,'Value',1,'Enable','on')

guidata(gcbo,handles)


% --- Executes on slider movement.
function y_slider_Callback(hObject, eventdata, handles)
% hObject    handle to y_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles=guidata(gcbo);

i=get(hObject,'Value');

axes(handles.axes1)
delete(handles.sliceplane_y)
handles.sliceplane_y=slice(handles.X,handles.Y,handles.Z,handles.V,[],i,[]);

if get(handles.grid_on_slice,'Value')==0
    
    delete(handles.sliceplane_y_boundary)    
    handles.sliceplane_y_boundary=plot3([handles.xmin handles.xmax handles.xmax handles.xmin handles.xmin ],[i i i i i],...
        [handles.zmin handles.zmin handles.zmax handles.zmax handles.zmin],'k');
end

set(handles.sliceplane_y,'FaceColor','interp')

if get(handles.grid_on_slice,'Value')==get(handles.grid_on_slice,'Min')
    set(handles.sliceplane_y,'EdgeColor','none')
end
set(handles.sliceplane_y,'Visible','on')
set(handles.y_slice,'Value',1,'Enable','on')
guidata(gcbo,handles)



% --- Executes on slider movement.
function z_slider_Callback(hObject, eventdata, handles)
% hObject    handle to wf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles=guidata(gcbo);

i=get(hObject,'Value');
axes(handles.axes1)
delete(handles.sliceplane_z)
handles.sliceplane_z=slice(handles.X,handles.Y,handles.Z,handles.V,[],[],i);

if get(handles.grid_on_slice,'Value')==0
    delete(handles.sliceplane_z_boundary)
    handles.sliceplane_z_boundary=plot3([handles.xmin handles.xmax handles.xmax handles.xmin handles.xmin ],...
        [handles.ymin handles.ymin handles.ymax handles.ymax handles.ymin],[i i i i i],'k');
end

set(handles.sliceplane_z,'FaceColor','interp')

if get(handles.grid_on_slice,'Value')==get(handles.grid_on_slice,'Min')
    set(handles.sliceplane_z,'EdgeColor','none')
end

set(handles.sliceplane_z,'Visible','on')
set(handles.z_slice,'Value',1,'Enable','on')

guidata(gcbo,handles)

% --- Executes on button press in x_slice.
function x_slice_Callback(hObject, eventdata, handles)
% hObject    handle to x_slice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of x_slice
handles=guidata(gcbo);

if get(hObject,'Value')==get(hObject,'Max')
    set(handles.sliceplane_x,'Visible','on')
    if get(handles.grid_on_slice,'Value')==0
        set(handles.sliceplane_x_boundary,'Visible','on')
    end
else
    set(handles.sliceplane_x,'Visible','off')
    set(handles.sliceplane_x_boundary,'Visible','off')    
end
    
guidata(gcbo,handles)

% --- Executes on button press in y_slice.
function y_slice_Callback(hObject, eventdata, handles)
% hObject    handle to y_slice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of y_slice
handles=guidata(gcbo);

if get(hObject,'Value')==get(hObject,'Max')
    set(handles.sliceplane_y,'Visible','on')
    if get(handles.grid_on_slice,'Value')==0
        set(handles.sliceplane_y_boundary,'Visible','on')
    end
else
    set(handles.sliceplane_y,'Visible','off')
    set(handles.sliceplane_y_boundary,'Visible','off')    
end
    
guidata(gcbo,handles)

% --- Executes on button press in z_slice.
function z_slice_Callback(hObject, eventdata, handles)
% hObject    handle to z_slice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of z_slice
handles=guidata(gcbo);

if get(hObject,'Value')==get(hObject,'Max')
    set(handles.sliceplane_z,'Visible','on')
    if get(handles.grid_on_slice,'Value')==0
        set(handles.sliceplane_z_boundary,'Visible','on')
    end
        
else
    set(handles.sliceplane_z,'Visible','off')
    set(handles.sliceplane_z_boundary,'Visible','off')
end
    
guidata(gcbo,handles)



% --- Executes on selection change in select_data.
function select_data_Callback(hObject, eventdata, handles)
% hObject    handle to select_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns select_data contents as cell array
%        contents{get(hObject,'Value')} returns selected item from select_data

handles=guidata(gcbo);

selected=get(hObject,'Value');
aaa=handles.datalist(selected,:);

eval(['load Visual_Data/' aaa])
cla

set([handles.x_slice handles.z_slice],'Value',0)
set(handles.y_slice,'Value',1)

set(handles.boundary_slices,'Value',0)
handles.X=X;
handles.Y=Y;
handles.Z=Z;
handles.V=V;

xmin=(min(min(min(X))));
ymin=(min(min(min(Y))));
zmin=(min(min(min(Z))));

xmax=(max(max(max(X))));
ymax=(max(max(max(Y))));
zmax=(max(max(max(Z))));

xmid=(xmax+xmin)/2;
ymid=(ymax+ymin)/2;
zmid=(zmax+zmin)/2;

handles.xmin=xmin;
handles.ymin=ymin;
handles.zmin=zmin;

handles.xmax=xmax;
handles.ymax=ymax;
handles.zmax=zmax;

alengthx=xmax-xmin;
alengthy=ymax-ymin;
alengthz=zmax-zmin;

xslice=xmin;
yslice=ymin;
zslice=zmin;

cen=[0.5*(xmax+xmin),0.5*(ymax+ymin),0.5*(zmax+zmin)];

[xx,yy,zz]=sphere(10);

xx=xx*(xmax-xmin)/2;
yy=yy*(ymax-ymin)/2;
zz=zz*(zmax-zmin)/2;

xx=xx+cen(1);
yy=yy+cen(2);
zz=zz+cen(3);

axes(handles.axes1)

outer_sphere=mesh(xx,yy,zz);
set(outer_sphere,'Visible','off')
hold on

set(handles.x_slider,'Min',xmin,'Max',xmax,'Value',xmid)%,'SliderStep',[0.01*alengthx 0.1*alengthx])
set(handles.y_slider,'Min',ymin,'Max',ymax,'Value',ymid)%,'SliderStep',[0.01*alengthy 0.1*alengthy])
set(handles.z_slider,'Min',zmin,'Max',zmax,'Value',zmid)%,'SliderStep',[0.01*alengthz 0.1*alengthz])

% qqq
% return


handles.boundary=slice(X,Y,Z,V,xslice,yslice,zslice);
set(handles.boundary,'FaceColor','interp')

if get(handles.boundary_slices,'Value')==0
    set(handles.boundary,'Visible','off')
else
    set(handles.boundary,'Visible','on')
end

hold on



if get(handles.color_bar,'Value')==1
    
    if handles.cbar==0
        handles.cbar=colorbar('Location','EastOutside');
    else
        delete(handles.cbar)
        handles.cbar=colorbar('Location','EastOutside');
    end
end

box on
axis tight
view(125,20)

% handles.sliceplane_x=slice(X,Y,Z,V,(xmax+xmin)/2,[],[]);
handles.sliceplane_x=slice(X,Y,Z,V,xmid,[],[]);
% handles.sliceplane_x_boundary=plot3([0 0 0 0 0],[ymin ymax ymax ymin ymin],[zmin zmin zmax zmax zmin],'k');
handles.sliceplane_x_boundary=plot3([xmid xmid xmid xmid xmid],[ymin ymax ymax ymin ymin],[zmin zmin zmax zmax zmin],'k');

% handles.sliceplane_y=slice(X,Y,Z,V,[],(ymax+ymin)/2,[]);
handles.sliceplane_y=slice(X,Y,Z,V,[],ymid,[]);
handles.sliceplane_y_boundary=plot3([xmin xmax xmax xmin xmin ],[ymid ymid ymid ymid ymid],[zmin zmin zmax zmax zmin],'k');

% handles.sliceplane_z=slice(X,Y,Z,V,[],[],(zmax+zmin)/2);
handles.sliceplane_z=slice(X,Y,Z,V,[],[],zmid);
handles.sliceplane_z_boundary=plot3([xmin xmax xmax xmin xmin ],[ymin ymin ymax ymax ymin],[zmid zmid zmid zmid zmid],'k');

set([handles.sliceplane_z handles.sliceplane_y handles.sliceplane_z],'FaceColor','interp')
% qqq

if get(handles.grid_on_slice,'Value')==1
    set([ handles.sliceplane_x_boundary handles.sliceplane_y_boundary handles.sliceplane_z_boundary ],'Visible','off')
else
    set(handles.boundary,'EdgeColor','none')
    set([ handles.sliceplane_x handles.sliceplane_y handles.sliceplane_z],'Edgecolor','none')
end

if get(handles.x_slice,'Value')==0
    set(handles.sliceplane_x_boundary ,'Visible','off')
    set(handles.sliceplane_x,'Visible','off')
end

if get(handles.y_slice,'Value')==0
    set(handles.sliceplane_y_boundary ,'Visible','off')
    set(handles.sliceplane_y,'Visible','off')
end

if get(handles.z_slice,'Value')==0
    set(handles.sliceplane_z_boundary ,'Visible','off')
    set(handles.sliceplane_z,'Visible','off')
end

camlookat(outer_sphere)

set([handles.boundary_slices handles.grid_on_slice handles.grid_on handles.x_slider handles.y_slider, ...
    handles.z_slider,handles.capture_image, handles.rotate  handles.x_slice handles.y_slice handles.z_slice, ...
    handles.color_bar, handles.x_label_txt, handles.y_label_txt,handles.z_label_txt,handles.Plot_title],'Enable','on')

set(handles.axes1,'PlotBoxAspectRatio',[1 1 1]);

ttt=title('Variation of \Omega with \alpha , \beta & \gamma');
set(ttt,'FontSize',12)

xlabel('\alpha')
ylabel('\beta')
zlabel('\gamma')

guidata(gcbo,handles)


function x_label_txt_Callback(hObject, eventdata, handles)
% hObject    handle to x_label_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_label_txt as text
%        str2double(get(hObject,'String')) returns contents of x_label_txt as a double

handles=guidata(gcbo);

x_label=get(hObject,'String');
xl=xlabel(x_label);

guidata(gcbo,handles)


function z_label_txt_Callback(hObject, eventdata, handles)
% hObject    handle to z_label_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_label_txt as text
%        str2double(get(hObject,'String')) returns contents of z_label_txt as a double

handles=guidata(gcbo);

z_label=get(hObject,'String');
% set(handles.z_text,'String',z_label)
zl=zlabel(z_label);

guidata(gcbo,handles)


function y_label_txt_Callback(hObject, eventdata, handles)
% hObject    handle to y_label_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_label_txt as text
%        str2double(get(hObject,'String')) returns contents of y_label_txt as a double

handles=guidata(gcbo);

y_label=get(hObject,'String');
% set(handles.y_text,'String',y_label)
yl=ylabel(y_label);

guidata(gcbo,handles)


function Plot_title_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Plot_title as text
%        str2double(get(hObject,'String')) returns contents of Plot_title
%        as a double

handles=guidata(gcbo);

plot_title=get(hObject,'String');
% set(handles.Plot_title_static_txt,'String',plot_title)
ttt=title(plot_title)
set(ttt,'FontSize',12)

guidata(gcbo,handles)


% --- Executes on button press in color_bar.
function color_bar_Callback(hObject, eventdata, handles)
% hObject    handle to color_bar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of color_bar

handles=guidata(gcbo);

if get(handles.color_bar,'Value')==1
    
    if handles.cbar==0
        handles.cbar=colorbar('Location','EastOutside');
    else
        delete(handles.cbar)
        handles.cbar=colorbar('Location','EastOutside');
    end
elseif handles.cbar~=0
    delete(handles.cbar)
    handles.cbar=0;
end

guidata(gcbo,handles)


% --- Executes on button press in capture_image.
function capture_image_Callback(hObject, eventdata, handles)
% hObject    handle to capture_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=guidata(gcbo);
[file,path] = uiputfile('4D_Plot.jpg',['Capture as Image'])
filename=[path,file]

if file~=0
    set([ handles.select_data, handles.color_bar, handles.boundary_slices, handles.grid_on_slice,...
        handles.set_label_txt, handles.grid_on, handles.x_slice, handles.y_slice, handles.z_slice,...
        handles.rotate, handles.capture_image, handles.x_label_txt, handles.y_label_txt, handles.z_label_txt,...
        handles.Plot_title, handles.x_slider, handles.y_slider, handles.z_slider, handles.text1,...
        handles.set_title_txt, handles.text2, handles.text3,handles.uipanel1],'Visible','off')

    saveas(gca,filename)

    set([ handles.select_data, handles.color_bar, handles.boundary_slices, handles.grid_on_slice,...
        handles.set_label_txt,handles.grid_on, handles.x_slice, handles.y_slice, handles.z_slice,...
        handles.rotate, handles.capture_image, handles.x_label_txt, handles.y_label_txt, handles.z_label_txt,...
        handles.Plot_title, handles.x_slider, handles.y_slider, handles.z_slider, handles.text1,...
        handles.set_title_txt, handles.text2, handles.text3,handles.uipanel1],'Visible','on')
end

guidata(gcbo,handles)

function exit_Callback(hObject, eventdata, handles)
% hObject    handle to file_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcbo);
delete(handles.figure1);
% clc
a=0;
save Extra.dat a
delete('Extra.dat')
clear
closereq
load alltools
msg=['                                                                    ';...
     '     j.divahar@yahoo.com                                            '];
   

button = msgbox(msg,'Thank you For Trying !','custom',Tvanakam,Tcolormap);


function varargout = minegui(varargin)
% MINEGUI MATLAB code for minegui.fig
%      MINEGUI, by itself, creates a new MINEGUI or raises the existing
%      singleton*.
%
%      H = MINEGUI returns the handle to a new MINEGUI or the handle to
%      the existing singleton*.
%
%      MINEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MINEGUI.M with the given input arguments.
%
%      MINEGUI('Property','Value',...) creates a new MINEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before minegui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to minegui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% David Willingham February 2013
% Copyright 2013 The MathWorks, Inc

% Edit the above text to modify the response to help minegui

% Last Modified by GUIDE v2.5 06-Feb-2013 11:36:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @minegui_OpeningFcn, ...
                   'gui_OutputFcn',  @minegui_OutputFcn, ...
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


% --- Executes just before minegui is made visible.
function minegui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to minegui (see VARARGIN)

% Choose default command line output for minegui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes minegui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = minegui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in import_data.
function import_data_Callback(hObject, eventdata, handles)
% hObject    handle to import_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

importcopper
axes(handles.axes1);
scatter3(x,y,z,8,c,'filled')
xlabel('East');ylabel('North');zlabel('Elevation')
title('Copper Mine Assay Data')
set(handles.x_list,'string',num2str(unique(x)));
set(handles.y_list,'string',num2str(unique(y)));
set(handles.z_list,'string',num2str(unique(z)));
set(handles.c_list,'string',num2str(flipud(unique(c))));

lx = unique(x);
for i = 1:length(lx)
    I = lx(i) == x;
    data{i} = [x(I),y(I),z(I),c(I)];
end
set(handles.drillhole,'string',num2str([1:length(data)]'));
% --- Executes on selection change in x_list.
function x_list_Callback(hObject, eventdata, handles)
% hObject    handle to x_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns x_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from x_list


% --- Executes during object creation, after setting all properties.
function x_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in y_list.
function y_list_Callback(hObject, eventdata, handles)
% hObject    handle to y_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns y_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from y_list


% --- Executes during object creation, after setting all properties.
function y_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in z_list.
function z_list_Callback(hObject, eventdata, handles)
% hObject    handle to z_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns z_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from z_list
if (isfield(handles,'hc') == 1)
    delete(handles.hc);
end
importcopper
Mz = str2num(get(handles.z_list,'string'));
Mz = Mz(get(handles.z_list,'value'));


% Extracting the x,y,z data

MzI = Mz == z;
MxZ = x(MzI);
MyZ = y(MzI);
MzZ = z(MzI);
McZ = c(MzI);

cu = flipud(unique(c));
Ic = find(max(McZ)==cu);
set(handles.c_list,'Value',Ic);
% Visualizing the plane
axes(handles.axes2);
view(2)
cla
scatter(MxZ,MyZ,25,McZ)
title(['Z intersection: ',num2str(Mz)])
xlabel('X')
ylabel('Y')
h = colorbar;
title(h,'Cu Perc');
hold on
% Creating a finer grid
[XX,YY] = meshgrid(1600:5:3000,4500:5:5400);
% Using interpolation to fill in the gaps
CC = griddata(MxZ,MyZ,McZ,XX,YY);
% Contour plot of the plane
contour(XX,YY,CC)
caxis([min(c) max(c)])

axes(handles.axes1);
hold on
[~,hc] = contour3(XX,YY,CC);

for i = 1:length(hc)
    zz = get(hc(i),'Zdata');
    [r,c] =size(zz);
    ZZ = repmat(Mz,r,c);
    set(hc(i),'Zdata',ZZ);
end
handles.hc = hc;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function z_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in c_list.
function c_list_Callback(hObject, eventdata, handles)
% hObject    handle to c_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns c_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from c_list
if (isfield(handles,'hc') == 1)
    delete(handles.hc);
end

importcopper
Mc = str2num(get(handles.c_list,'string'));
Mc = Mc(get(handles.c_list,'value'));
I = find(Mc == c);

% Extracting the x,y,z data
Mx = x(I);
My = y(I);
Mz = z(I);
zu = unique(z);
Iz = find(Mz==zu);
set(handles.z_list,'Value',Iz);

MzI = Mz == z;
MxZ = x(MzI);
MyZ = y(MzI);
MzZ = z(MzI);
McZ = c(MzI);
% Visualizing the plane
[M,IM]= max(McZ);
ux = str2num(get(handles.x_list,'string'));
v = find(MxZ(IM) == ux);
set(handles.x_list,'value',v)
set(handles.drillhole,'value',v)
uy = str2num(get(handles.y_list,'string'));
v2 = find(MyZ(IM) == uy);
set(handles.y_list,'value',v2)

lx = unique(x);
for i = 1:length(lx)
    I = lx(i) == x;
    data{i} = [x(I),y(I),z(I),c(I)];
end
% v = get(handles.drillhole,'Value');
drillhole = data{v};
vx = find(drillhole(1,1) == unique(x));
vy = find(drillhole(1,2) == unique(y));

if (isfield(handles,'hs2') == 1)
    delete(handles.hs2);
    handles = rmfield(handles, 'hs2');
end
if (isfield(handles,'hs') == 1)
    delete(handles.hs);
    handles = rmfield(handles, 'hs');
end
axes(handles.axes1);
hold on
hs2 = scatter3(drillhole(:,1),drillhole(:,2),drillhole(:,3),50,drillhole(:,4),'filled');
handles.hs2 = hs2;

pos = get(handles.axes2,'pos');
handles.pos = pos; 

axes(handles.axes2);
cla
view(2)
scatter(MxZ,MyZ,25,McZ)
title(['Z intersection: ',num2str(Mz)])
xlabel('X')
ylabel('Y')
h = colorbar;
set(handles.axes2,'pos',handles.pos)
handles.h = h;
title(h,'Cu Perc');
hold on
% Creating a finer grid
[XX,YY] = meshgrid(1600:5:3000,4500:5:5400);
% Using interpolation to fill in the gaps
CC = griddata(MxZ,MyZ,McZ,XX,YY);
% Contour plot of the plane
contour(XX,YY,CC)
caxis([min(c) max(c)])

axes(handles.axes1);
hold on
[~,hc] = contour3(XX,YY,CC);

for i = 1:length(hc)
    zz = get(hc(i),'Zdata');
    [r,c] =size(zz);
    ZZ = repmat(Mz,r,c);
    set(hc(i),'Zdata',ZZ);
end
handles.hc = hc;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function c_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in drillhole.
function drillhole_Callback(hObject, eventdata, handles)
% hObject    handle to drillhole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drillhole contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drillhole
if (isfield(handles,'hs') == 1)
    delete(handles.hs);
    handles = rmfield(handles, 'hs');
end
if (isfield(handles,'hs2') == 1)
    delete(handles.hs2);
    handles = rmfield(handles, 'hs2');
end
if (isfield(handles,'hc') == 1)
    delete(handles.hc);
    handles = rmfield(handles, 'hc');
end
if (isfield(handles,'h') == 1)
    colorbar(handles.h,'off')
    set(handles.axes2,'pos',handles.pos)
    handles = rmfield(handles, 'h');
end

importcopper
lx = unique(x);
for i = 1:length(lx)
    I = lx(i) == x;
    data{i} = [x(I),y(I),z(I),c(I)];
end
v = get(handles.drillhole,'Value');
drillhole = data{v};
vx = find(drillhole(1,1) == unique(x));
vy = find(drillhole(1,2) == unique(y));
set(handles.x_list,'value',vx);
set(handles.y_list,'value',vy);
axes(handles.axes1);
hold on
hs = scatter3(drillhole(:,1),drillhole(:,2),drillhole(:,3),50,drillhole(:,4),'filled');

% Statistics on Drill Holes
% Identifying holes max Cu
for j = 1:length(data)
    M(j,1) = max(data{j}(:,4));
    m(j,1) = min(data{j}(:,4));
    Med(j,1) = median(data{j}(:,4));
end
dhmI = M>2; 
dhmI = double(dhmI);

val = get(handles.drillhole,'value');
set(handles.drill,'string',num2str(val));
set(handles.max,'string',num2str(M(val)));
set(handles.min,'string',num2str(m(val)));
set(handles.med,'string',num2str(Med(val)));
set(handles.high,'string',num2str(dhmI(val)));

handles.hs = hs;
guidata(hObject,handles)

axes(handles.axes2)
cla
view(2)
z1 = data{val}(:,3);
c1 = data{val}(:,4);


xlabel('depth');
ylabel('Cu Perc')
znew = [min(z1):1:max(z1)];
cnew = interp1(z1,c1,znew,'cubic');

% fitresult = createFit(z1, c1); %created using curve fitting toolbox
% cnew = feval(fitresult,znew);
hold on
plot(z1,c1)
plot(znew,cnew,'r')
title('Drill Hole Cu Perc')
legend('Original Cu Perc', 'Interpolated Cu Perc', 'Location', 'NorthEast' );
% Label axes
xlabel( 'Elevation' );
ylabel( 'Cu Perc' );
grid on
% --- Executes during object creation, after setting all properties.
function drillhole_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drillhole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function drill_Callback(hObject, eventdata, handles)
% hObject    handle to drill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of drill as text
%        str2double(get(hObject,'String')) returns contents of drill as a double
importcopper
% indentify drill holes
lx = unique(x);
for i = 1:length(lx)
    I = lx(i) == x;
    data{i} = [x(I),y(I),z(I),c(I)];
end
% Statistics on Drill Holes
% Identifying holes max Cu
for j = 1:length(data)
    M(j,1) = max(data{j}(:,4));
    m(j,1) = min(data{j}(:,4));
    Med(j,1) = median(data{j}(:,4));
end
dhmI = M>2; 
dhmI = double(dhmI);

val = get(handles.drill,'string');
val = str2num(val);
set(handles.max,'string',num2str(M(val)));
set(handles.min,'string',num2str(m(val)));
set(handles.med,'string',num2str(Med(val)));
set(handles.high,'string',num2str(dhmI(val)));
set(handles.drillhole,'value',val);



% --- Executes during object creation, after setting all properties.
function drill_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max_Callback(hObject, eventdata, handles)
% hObject    handle to max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max as text
%        str2double(get(hObject,'String')) returns contents of max as a double


% --- Executes during object creation, after setting all properties.
function max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function min_Callback(hObject, eventdata, handles)
% hObject    handle to min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min as text
%        str2double(get(hObject,'String')) returns contents of min as a double


% --- Executes during object creation, after setting all properties.
function min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function med_Callback(hObject, eventdata, handles)
% hObject    handle to med (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of med as text
%        str2double(get(hObject,'String')) returns contents of med as a double


% --- Executes during object creation, after setting all properties.
function med_CreateFcn(hObject, eventdata, handles)
% hObject    handle to med (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function high_Callback(hObject, eventdata, handles)
% hObject    handle to high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of high as text
%        str2double(get(hObject,'String')) returns contents of high as a double


% --- Executes during object creation, after setting all properties.
function high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in iso_plot.
function iso_plot_Callback(hObject, eventdata, handles)
% hObject    handle to iso_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
importcopper
axes(handles.axes2);
view(2)
cla
legend off

scatter3(x,y,z,10,c,'filled')
xlabel('East');ylabel('North');zlabel('Elevation')
title('Copper Mine Assay Data')
set(handles.pleasewait,'string','Please Wait...');
pause(0.1);
[X,Y,Z] = meshgrid(1600:5:3000,4500:5:5500,3500:5:4200);
C = griddata(x,y,z,c,X,Y,Z);
%Highlighting hi grade Cu areas 
for i = 520:5:535
    cu = unique(c);
    val = cu(i);
    [faces,verts,colors] = isosurface(X,Y,Z,C,val,C);
    patch('Vertices', verts, 'Faces', faces, ...
        'FaceVertexCData', colors, ...
        'FaceColor','interp', ...
        'edgecolor', 'none',...
        'FaceAlpha',0.1);
end
h = colorbar;
title(h,'Cu %')
view(3)
handles.h = h;
guidata(hObject,handles)
set(handles.pleasewait,'string','done');
pause(0.1);
set(handles.pleasewait,'string','');

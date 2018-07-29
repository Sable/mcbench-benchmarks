function varargout = sp_gen(varargin)
%
%
% sp_gen is a GUI for generating Spirals.
%
%A. Select the plane that will be parallel to the spiral
%B. Select the type of spiral:
%You can choose from Archimedean,Logarithmic,Fermat,Hyperbolic,Lituus,Spherical and Polynomial Spirals.
%you can see the equations used for the selected spiral, and change the parameters.
%C. Select the normal component of the spiral. Note that this feature is
%not available for the spherical spirals.
%D. Add thickness to the spiral. This will provide volume and will give you
%the possibility to generate surfaces. Note that this feature is not
%available for the polynomial spirals.
%E. Generate and export spiral variables to the workspace.
%
%%%%%%BUGS
%
%I am aware of the surface bug. This is clearly visible in the spherical
%spiral, but also in the other spirals if you play with the normal
%component.This is caused because the surface twists around itself. I
%provide a partial correction, in function 'generate_thickness' in the 'if' 
%statement in lines 1128-1130.
%
% If anybody comes with a solution to this or finds other bugs, please post
% on File EXchange. 
%
%
%Created by Katelouzos Ioannis.


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sp_gen_OpeningFcn, ...
                   'gui_OutputFcn',  @sp_gen_OutputFcn, ...
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


% --- Executes just before sp_gen is made visible.
function sp_gen_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sp_gen (see VARARGIN)

% Choose default command line output for sp_gen
handles.output = hObject;
handles.plane=[0 0 1];
vr=[[1 0;-1 0;0 1;0 -1]*null([0 0 1])';0 0 0];
fc=[1 5 3;2 5 3;2 5 4;1 4 5];
fv.vertices=vr;
fv.faces=fc;
handles.fv=fv;
handles.xpl=zeros(3,3);
handles.ypl=zeros(3,3);
handles.zpl=zeros(3,3);
handles.surface=0;
handles.scloud=0;
handles.cloud=0;
handles.cerchi=[0;0;0];
handles.oct=zeros(8,3);
handles.spiral=zeros(3,1);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sp_gen wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sp_gen_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in spiral_type.
function spiral_type_Callback(hObject, eventdata, handles)
% hObject    handle to spiral_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=(get(hObject,'Value'));
zz=(get(handles.zcomp,'Value'));
switch val
    case 1
        set(handles.text15,'String','r = a + b * theta');
        set(handles.g,'Enable','off');
        set(handles.h,'Enable','off');
        set(handles.i,'Enable','off');
        set(handles.alpha,'Enable','on');
        set(handles.beta,'Enable','on');
        set(handles.zcomp,'Enable','on');
        set(handles.thick,'Enable','on');
        set(handles.surfface,'Enable','on');
        if zz~=1
        set(handles.c,'Enable','on');
        set(handles.d,'Enable','on');
        set(handles.e,'Enable','on');
        set(handles.f,'Enable','on');
        
        end
    case 2
        set(handles.text15,'String','r = a * exp( b * theta )');
        set(handles.g,'Enable','off');
        set(handles.h,'Enable','off');
        set(handles.i,'Enable','off');
        set(handles.alpha,'Enable','on');
        set(handles.beta,'Enable','on');
        set(handles.zcomp,'Enable','on');
        set(handles.thick,'Enable','on');
        set(handles.surfface,'Enable','on');
        if zz~=1
        set(handles.c,'Enable','on');
        set(handles.d,'Enable','on');
        set(handles.e,'Enable','on');
        set(handles.f,'Enable','on');
        
        end
    case 3 
        set(handles.text15,'String','r = +- sqrt( theta )');
        set(handles.g,'Enable','off');
        set(handles.h,'Enable','off');
        set(handles.i,'Enable','off');
        set(handles.alpha,'Enable','off');
        set(handles.beta,'Enable','off');
        set(handles.zcomp,'Enable','on');
        set(handles.thick,'Enable','on');
        set(handles.surfface,'Enable','on');
        if zz~=1
        set(handles.c,'Enable','on');
        set(handles.d,'Enable','on');
        set(handles.e,'Enable','on');
        set(handles.f,'Enable','on');
        
        end
    case 4
        set(handles.text15,'String','r = a / theta');
        set(handles.g,'Enable','off');
        set(handles.h,'Enable','off');
        set(handles.i,'Enable','off');
        set(handles.alpha,'Enable','on');
        set(handles.beta,'Enable','off');
        set(handles.zcomp,'Enable','on');
        set(handles.thick,'Enable','on');
        set(handles.surfface,'Enable','on');
        if zz~=1
        set(handles.c,'Enable','on');
        set(handles.d,'Enable','on');
        set(handles.e,'Enable','on');
        set(handles.f,'Enable','on');
        
        end
    case 5
        set(handles.text15,'String','r = sqrt( 1 / theta )');
        set(handles.g,'Enable','off');
        set(handles.h,'Enable','off');
        set(handles.i,'Enable','off');
        set(handles.alpha,'Enable','off');
        set(handles.beta,'Enable','off');
        set(handles.zcomp,'Enable','on');
        set(handles.thick,'Enable','on');
        set(handles.surfface,'Enable','on');
        if zz~=1
        set(handles.c,'Enable','on');
        set(handles.d,'Enable','on');
        set(handles.e,'Enable','on');
        set(handles.f,'Enable','on');
        
        end
    case 6
        set(handles.text15,'String','x=cos(t)cos(c) y=sin(t)cos(c)  z=-sin(c) c=atan(a*t)');
        set(handles.g,'Enable','off');
        set(handles.h,'Enable','off');
        set(handles.i,'Enable','off');
        set(handles.alpha,'Enable','on');
        set(handles.beta,'Enable','off');
        set(handles.zcomp,'Enable','off');
        set(handles.c,'Enable','off');
        set(handles.d,'Enable','off');
        set(handles.e,'Enable','off');
        set(handles.f,'Enable','off');
        set(handles.thick,'Enable','on');
        set(handles.surfface,'Enable','on');
    otherwise
        set(handles.text15,'String','curvature = f(curve length) k=a*s^4+b*s^3+g*s^2+h*s+i');
        set(handles.g,'Enable','on');
        set(handles.h,'Enable','on');
        set(handles.i,'Enable','on');
        set(handles.alpha,'Enable','on');
        set(handles.beta,'Enable','on');
        set(handles.zcomp,'Enable','on');
        set(handles.thick,'Enable','off');
        set(handles.surfface,'Enable','off');
        if zz~=1
        set(handles.c,'Enable','on');
        set(handles.d,'Enable','on');
        set(handles.e,'Enable','on');
        set(handles.f,'Enable','on');
        end

end
guidata(hObject, handles);
% Hints: contents = get(hObject,'String') returns spiral_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from spiral_type


% --- Executes during object creation, after setting all properties.
function spiral_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spiral_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Xeq_Callback(hObject, eventdata, handles)
% hObject    handle to Xeq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pl=handles.plane;
x=str2double(get(hObject,'String'));
if pl(3)==0 && pl(2)==0, x=1;
set(hObject,'String','1');
end
handles.plane(1)=x;
handles=refresh_plane(handles);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of Xeq as text
%        str2double(get(hObject,'String')) returns contents of Xeq as a double


% --- Executes during object creation, after setting all properties.
function Xeq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xeq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
handles.plane(1)=str2double(get(hObject,'String'));
guidata(hObject, handles);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Yeq_Callback(hObject, eventdata, handles)
% hObject    handle to Yeq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pl=handles.plane;
x=str2double(get(hObject,'String'));
if pl(1)==0 && pl(3)==0, x=1;
set(hObject,'String','1');
end
handles.plane(2)=x;
handles=refresh_plane(handles);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of Yeq as text
%        str2double(get(hObject,'String')) returns contents of Yeq as a double


% --- Executes during object creation, after setting all properties.
function Yeq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Yeq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
handles.plane(2)=str2double(get(hObject,'String'));
guidata(hObject, handles);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Zeq_Callback(hObject, eventdata, handles)
% hObject    handle to Zeq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Zeq as text
%        str2double(get(hObject,'String')) returns contents of Zeq as a double
pl=handles.plane;
x=str2double(get(hObject,'String'));
if pl(1)==0 && pl(2)==0, x=1;
set(hObject,'String','1');
end
handles.plane(3)=x;
handles=refresh_plane(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Zeq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zeq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
handles.plane(3)=str2double(get(hObject,'String'));
guidata(hObject, handles);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in show_plane.
function show_plane_Callback(hObject, eventdata, handles)
% hObject    handle to show_plane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=refresh_plane(handles);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of show_plane



function thick_Callback(hObject, eventdata, handles)
% hObject    handle to thick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=str2double(get(hObject,'String'));
if x<0;
set(hObject,'String','0');
end
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of thick as text
%        str2double(get(hObject,'String')) returns contents of thick as a double


% --- Executes during object creation, after setting all properties.
function thick_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lengt_Callback(hObject, eventdata, handles)
% hObject    handle to lengt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lengt as text
%        str2double(get(hObject,'String')) returns contents of lengt as a double

x=str2double(get(hObject,'String'));
pr=str2double(get(handles.precision,'String'));
if x<=2*pr;
pr=str2double(get(handles.precision,'String'));
set(hObject,'String',sprintf('%g', pr*2));
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lengt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lengt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function h=refresh_plane(handles)
cpos=get(handles.axes1,'CameraPosition');
pl=handles.plane;
 vr=[[1 0;-1 0;0 1;0 -1;1 1; 1 -1;-1 -1;-1 1]*null(pl)';0 0 0];
fv.vertices=vr;
xpl=[vr(8,1) vr(3,1) vr(5,1);vr(2,1) vr(9,1) vr(1,1);vr(7,1) vr(4,1) vr(6,1)];
ypl=[vr(8,2) vr(3,2) vr(5,2);vr(2,2) vr(9,2) vr(1,2);vr(7,2) vr(4,2) vr(6,2)];
zpl=[vr(8,3) vr(3,3) vr(5,3);vr(2,3) vr(9,3) vr(1,3);vr(7,3) vr(4,3) vr(6,3)];
handles.xpl=xpl;
handles.ypl=ypl;
handles.zpl=zpl;
spir=handles.spiral;

if isempty(find(spir));
    mm=1;
else mm=max(max(abs(spir)));
end
xpl=xpl.*mm/2;
ypl=ypl.*mm/2;
zpl=zpl.*mm/2;
plot3(spir(1,:),spir(2,:),spir(3,:));
hold on;
if get(handles.show_plane,'Value')==1
    mesh(xpl,ypl,zpl,'FaceAlpha',0.1,'FaceColor','g','EdgeAlpha',0.5,'EdgeColor','k');
end
set(handles.axes1,'CameraPosition',cpos);
set(handles.axes1,'DataAspectRatio',[1 1 1]);
set(get(handles.axes1,'XLabel'),'String','X','Color','r','FontWeight','bold');
set(get(handles.axes1,'YLabel'),'String','Y','Color','r','FontWeight','bold');
set(get(handles.axes1,'ZLabel'),'String','Z','Color','r','FontWeight','bold');
hold off;
h=handles;


% --- Executes on button press in export_internal.
function export_internal_Callback(hObject, eventdata, handles)
% hObject    handle to export_internal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cloud=handles.cloud;
assignin('base','Spiral_IntCloud',cloud);


% --- Executes on button press in show_scloud.
function show_scloud_Callback(hObject, eventdata, handles)
% hObject    handle to show_scloud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.export_scloud,'BackgroundColor',[0 1 0]);
set(handles.export_scloud,'Enable','on');
H=figure(2);
title('Surface Cloud Ordinary','Color','b','FontWeight','bold');
oct=handles.oct;
hold on;
for it=1:length(oct(1,1,:))
    plot3(oct(:,1,it),oct(:,2,it),oct(:,3,it),'.');
end
set(get(H,'CurrentAxes'),'DataAspectRatio',[1 1 1]);
set(get(get(H,'CurrentAxes'),'XLabel'),'String','X','Color','r','FontWeight','bold');
set(get(get(H,'CurrentAxes'),'YLabel'),'String','Y','Color','r','FontWeight','bold');
set(get(get(H,'CurrentAxes'),'ZLabel'),'String','Z','Color','r','FontWeight','bold');
hold off;
H=figure(3);
title('Surface Cloud Random','Color','b','FontWeight','bold');
scloud=gen_scloud(handles,oct);
handles.scloud=scloud;
hold on;
plot3(scloud(:,1),scloud(:,2),scloud(:,3),'.');
set(get(H,'CurrentAxes'),'DataAspectRatio',[1 1 1]);
set(get(get(H,'CurrentAxes'),'XLabel'),'String','X','Color','r','FontWeight','bold');
set(get(get(H,'CurrentAxes'),'YLabel'),'String','Y','Color','r','FontWeight','bold');
set(get(get(H,'CurrentAxes'),'ZLabel'),'String','Z','Color','r','FontWeight','bold');
hold off;
guidata(hObject, handles);


% --- Executes on button press in show_surface.
function show_surface_Callback(hObject, eventdata, handles)
% hObject    handle to show_surface (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.export_surface,'BackgroundColor',[0 1 0]);
set(handles.export_surface,'Enable','on');
H=figure(4);

oct=handles.oct;
C = permute(cat(1, oct, oct(1,:,:)),[3,1,2]);
xsurf=squeeze(C(:,:,1));
ysurf=squeeze(C(:,:,2));
zsurf=squeeze(C(:,:,3));
surface.x=xsurf;
surface.y=ysurf;
surface.z=zsurf;
handles.surface=surface;
mesh(xsurf,ysurf,zsurf,'FaceAlpha',0.1,'FaceColor','g','EdgeAlpha',0.5,'EdgeColor','k');
title('Surface','Color','b','FontWeight','bold');
set(get(H,'CurrentAxes'),'DataAspectRatio',[1 1 1]);
set(get(get(H,'CurrentAxes'),'XLabel'),'String','X','Color','r','FontWeight','bold');
set(get(get(H,'CurrentAxes'),'YLabel'),'String','Y','Color','r','FontWeight','bold');
set(get(get(H,'CurrentAxes'),'ZLabel'),'String','Z','Color','r','FontWeight','bold');
guidata(hObject, handles);


% --- Executes on button press in show_internal.
function show_internal_Callback(hObject, eventdata, handles)
% hObject    handle to show_internal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.export_internal,'BackgroundColor',[0 1 0]);
set(handles.export_internal,'Enable','on');
H=figure(1);
title('Internal Cloud','Color','b','FontWeight','bold');
oct=handles.oct;

cloud=gen_cloud(handles,oct);
handles.cloud=cloud;
hold on;
plot3(cloud(:,1),cloud(:,2),cloud(:,3),'.');
set(get(H,'CurrentAxes'),'DataAspectRatio',[1 1 1]);
set(get(get(H,'CurrentAxes'),'XLabel'),'String','X','Color','r','FontWeight','bold');
set(get(get(H,'CurrentAxes'),'YLabel'),'String','Y','Color','r','FontWeight','bold');
set(get(get(H,'CurrentAxes'),'ZLabel'),'String','Z','Color','r','FontWeight','bold');
hold off;
guidata(hObject, handles);


% --- Executes on button press in export_scloud.
function export_scloud_Callback(hObject, eventdata, handles)
% hObject    handle to export_scloud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oct=handles.oct;
scloud=handles.scloud;
B = permute(oct,[1 3 2]);
ou = reshape(B,length(oct(:,1,1))*size(oct,3),3);
assignin('base','Spiral_SurCloud_ord',ou);
assignin('base','Spiral_SurCloud_rand',scloud);


% --- Executes on button press in export_surface.
function export_surface_Callback(hObject, eventdata, handles)
% hObject    handle to export_surface (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
surface=handles.surface;
assignin('base','Spiral_Surface',surface);


% --- Executes on button press in export_line.
function export_line_Callback(hObject, eventdata, handles)
% hObject    handle to export_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
assignin('base','Spiral_line',handles.spiral);


% --- Executes on button press in gen_spiral.
function gen_spiral_Callback(hObject, eventdata, handles)
% hObject    handle to gen_spiral (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cpos=get(handles.axes1,'CameraPosition');
stype=get(handles.spiral_type,'Value');
alpha=str2double(get(handles.alpha,'String'));
beta=str2double(get(handles.beta,'String'));
c=str2double(get(handles.c,'String'));
d=str2double(get(handles.d,'String'));
e=str2double(get(handles.e,'String'));
f=str2double(get(handles.f,'String'));
g=str2double(get(handles.g,'String'));
h=str2double(get(handles.h,'String'));
i=str2double(get(handles.i,'String'));
thick=str2double(get(handles.thick,'String'));
pr=str2double(get(handles.precision,'String'));
lengt=str2double(get(handles.lengt,'String'));
theta=0:pr:lengt*pi;
switch stype
    case 1
        r=alpha+beta*theta;
    case 2
        r=alpha*(exp(beta*theta));
    case 3
        r=sqrt(theta);
        r2=-r;
    case 4
        r=alpha./theta;
    case 5
        r=sqrt(1./theta);
    case 6
        t=-lengt:pr:lengt;
        c=atan(alpha*t);
        x=cos(t).*cos(c); 
        y=sin(t).*cos(c);
        z=-sin(c); 
        [theta,r]=cart2pol(x,y);
    otherwise
        if alpha>0
            l=sqrt(lengt);
            p=pr^2;
        else 
            l=lengt;
            p=pr;
        end
        [x y]=curv2cart(alpha,beta,g,h,i,l,p,handles);
        [theta,r]=cart2pol(x,y);
end
zc=(get(handles.zcomp,'Value'));
if stype~=6
switch zc
    case 1
        z=zeros(1,length(theta));
    case 2
        z=c*r.^d+e*theta.^f;
    case 3 
        z = c*sin(r.*d) + e*sin(theta.*f);
    case 4
        z = c*exp(d*r) + e*exp(f*theta);
    otherwise
        z = c*log(r).^d + e*log(theta).^f;
end
end
if stype==4 || stype==5
    theta=theta(end:-1:2);
    r=r(end:-1:2);
    z=z(end:-1:2);
end
[x,y]=pol2cart(theta,r);
spiral=[x;y;z];
if stype==3 
    [x2,y2]=pol2cart(theta,r2);
    z2=-z;
    spiral=[fliplr(x2) x(2:end);fliplr(y2) y(2:end);fliplr(z2) z(2:end)];
end
pl=handles.plane;
rotate= vrrotvec([0 0 1],pl);
rm = vrrotvec2mat(rotate);
spir=rm*spiral;
nnn=sum(spir,1);
w=nnn==nnn;
w=find(w==0);
spir(:,w)=[];
handles.spiral=spir;
if ~isempty(find(spir))
    refresh_plane(handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   cerchiles generation
hold on;
if thick>0
    if stype==1 || stype==2 || stype ==6 ||stype==4 ||stype==5
        [cerchi oct]=generate_thickness(1,handles);
    elseif stype==3
        [cerchi oct]=generate_thickness(2,handles);
    else %stype==7
        cerchi=[0;0;0];
        oct=zeros(8,3);
    end
handles.cerchi=cerchi;
handles.oct=oct;
end
end
set(handles.axes1,'CameraPosition',cpos);
set(handles.axes1,'DataAspectRatio',[1 1 1]);
set(get(handles.axes1,'XLabel'),'String','X','Color','r','FontWeight','bold');
set(get(handles.axes1,'YLabel'),'String','Y','Color','r','FontWeight','bold');
set(get(handles.axes1,'ZLabel'),'String','Z','Color','r','FontWeight','bold');
hold off;
if stype ~= 7 && thick >0
set(handles.show_internal,'BackgroundColor',[0 1 0]);
set(handles.show_internal,'Enable','on');
set(handles.show_scloud,'BackgroundColor',[0 1 0]);
set(handles.show_scloud,'Enable','on');
set(handles.show_surface,'BackgroundColor',[0 1 0]);
set(handles.show_surface,'Enable','on');
set(handles.export_line,'BackgroundColor',[0 1 0]);
set(handles.export_line,'Enable','on');
set(handles.export_internal,'BackgroundColor',[1 0 0]);
set(handles.export_internal,'Enable','off');
set(handles.export_scloud,'BackgroundColor',[1 0 0]);
set(handles.export_scloud,'Enable','off');
set(handles.export_surface,'BackgroundColor',[1 0 0]);
set(handles.export_surface,'Enable','off');
else
    set(handles.show_internal,'BackgroundColor','r');
set(handles.show_internal,'Enable','off');
set(handles.show_scloud,'BackgroundColor','r');
set(handles.show_scloud,'Enable','off');
set(handles.show_surface,'BackgroundColor','r');
set(handles.show_surface,'Enable','off');
set(handles.export_line,'BackgroundColor',[0 1 0]);
set(handles.export_line,'Enable','on');
set(handles.export_internal,'BackgroundColor','r');
set(handles.export_internal,'Enable','off');
set(handles.export_scloud,'BackgroundColor','r');
set(handles.export_scloud,'Enable','off');
set(handles.export_surface,'BackgroundColor','r');
set(handles.export_surface,'Enable','off');
end
guidata(hObject, handles);



function alpha_Callback(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha as text
%        str2double(get(hObject,'String')) returns contents of alpha as a double


% --- Executes during object creation, after setting all properties.
function alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beta_Callback(hObject, eventdata, handles)
% hObject    handle to beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of beta as text
%        str2double(get(hObject,'String')) returns contents of beta as a double


% --- Executes during object creation, after setting all properties.
function beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in zcomp.
function zcomp_Callback(hObject, eventdata, handles)
% hObject    handle to zcomp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=(get(hObject,'Value'));
switch val
    case 1
        set(handles.text20,'String','z = 0');
        set(handles.c,'Enable','off');
        set(handles.d,'Enable','off');
        set(handles.e,'Enable','off');
        set(handles.f,'Enable','off');      
    case 2
        set(handles.text20,'String','z = c*r^d + e*theta^f');
        set(handles.c,'Enable','on');
        set(handles.d,'Enable','on');
        set(handles.e,'Enable','on');
        set(handles.f,'Enable','on');
    case 3 
        set(handles.text20,'String','z = c*sin(r*d) + e*sin(theta*f)');
        set(handles.c,'Enable','on');
        set(handles.d,'Enable','on');
        set(handles.e,'Enable','on');
        set(handles.f,'Enable','on');
    case 4
        set(handles.text20,'String','z = c*exp(d*r) + e*exp(f*theta)');
        set(handles.c,'Enable','on');
        set(handles.d,'Enable','on');
        set(handles.e,'Enable','on');
        set(handles.f,'Enable','on');
    otherwise
        set(handles.text20,'String','z = c*log(r)^d + e*log(theta)^f');
        set(handles.c,'Enable','on');
        set(handles.d,'Enable','on');
        set(handles.e,'Enable','on');
        set(handles.f,'Enable','on');
end
guidata(hObject, handles);
% Hints: contents = get(hObject,'String') returns zcomp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from zcomp


% --- Executes during object creation, after setting all properties.
function zcomp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zcomp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e_Callback(hObject, eventdata, handles)
% hObject    handle to e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e as text
%        str2double(get(hObject,'String')) returns contents of e as a double


% --- Executes during object creation, after setting all properties.
function e_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_Callback(hObject, eventdata, handles)
% hObject    handle to f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f as text
%        str2double(get(hObject,'String')) returns contents of f as a double


% --- Executes during object creation, after setting all properties.
function f_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c_Callback(hObject, eventdata, handles)
% hObject    handle to c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c as text
%        str2double(get(hObject,'String')) returns contents of c as a double


% --- Executes during object creation, after setting all properties.
function c_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function d_Callback(hObject, eventdata, handles)
% hObject    handle to d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of d as text
%        str2double(get(hObject,'String')) returns contents of d as a double


% --- Executes during object creation, after setting all properties.
function d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g_Callback(hObject, eventdata, handles)
% hObject    handle to g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g as text
%        str2double(get(hObject,'String')) returns contents of g as a double


% --- Executes during object creation, after setting all properties.
function g_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function h_Callback(hObject, eventdata, handles)
% hObject    handle to h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of h as text
%        str2double(get(hObject,'String')) returns contents of h as a double


% --- Executes during object creation, after setting all properties.
function h_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function i_Callback(hObject, eventdata, handles)
% hObject    handle to i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of i as text
%        str2double(get(hObject,'String')) returns contents of i as a double


% --- Executes during object creation, after setting all properties.
function i_CreateFcn(hObject, eventdata, handles)
% hObject    handle to i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [xo yo]=curv2cart(a,b,c,d,e,l,p,handles)
set(handles.timebar_text,'Visible','on','String','Generating Spiral');
drawnow update
s=0:p:l;
s2=-s;
x1=zeros(1,length(s));
y1=zeros(1,length(s));
x2=zeros(1,length(s));
y2=zeros(1,length(s));
k=a*s.^4+b*s.^3+c*s.^2+d*s+e;
k2=a*s2.^4+b*s2.^3+c*s2.^2+d*s2+e;
x1(2)=s(2);
y1(2)=0;
x2(2)=s2(2);
y2(2)=0;
perc=(length(s)*2-4)/100;
ls=length(s)-2;
for i=3:(length(s))
    sss=sprintf('Genetaring Spiral...%3.1f %%', i/perc);
    set(handles.timebar_text,'String',sss);
    drawnow update
    dth=k(i)*s(2);
    cth=(x1(i-1)-x1(i-2))/norm([x1(i-1) y1(i-1)]-[x1(i-2) y1(i-2)]);
    sth=(y1(i-1)-y1(i-2))/norm([x1(i-1) y1(i-1)]-[x1(i-2) y1(i-2)]);
    if sth>=0
        scorr=1;
    else scorr=-1;
    end
    newth=dth+scorr*acos(cth);
    xx=cos(newth);
    yy=sin(newth);
    x1(i)=(xx*s(2))+x1(i-1);
    y1(i)=(yy*s(2))+y1(i-1);
end

for i=3:(length(s))
    sss=sprintf('Genetaring Spiral...%3.1f %%', (i+ls)/perc);
    set(handles.timebar_text,'String',sss);
    drawnow update
    dth=k2(i)*s2(2);
    cth=(x2(i-1)-x2(i-2))/norm([x2(i-1) y2(i-1)]-[x2(i-2) y2(i-2)]);
    sth=(y2(i-1)-y2(i-2))/norm([x2(i-1) y2(i-1)]-[x2(i-2) y2(i-2)]);
    if sth>=0
        scorr=1;
    else scorr=-1;
    end
    newth=dth+scorr*acos(cth);
    xx=cos(newth);
    yy=sin(newth);
    x2(i)=(xx*s(2))+x2(i-1);
    y2(i)=(yy*s(2))+y2(i-1);
end
set(handles.timebar_text,'Visible','off');
xo=[fliplr(x2) x1];
yo=[fliplr(y2) y1];



function precision_Callback(hObject, eventdata, handles)
% hObject    handle to precision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=str2double(get(hObject,'String'));
l=str2double(get(handles.lengt,'String'));
if x<=0 
    set(hObject,'String','0.1');
    x=0.1;
elseif x>1 
    set(hObject,'String','1');
    x=1;
end
    if l<=2*x
        set(hObject,'String',sprintf('%g', l/2));
    end

guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of precision as text
%        str2double(get(hObject,'String')) returns contents of precision as a double


% --- Executes during object creation, after setting all properties.
function precision_CreateFcn(hObject, eventdata, handles)
% hObject    handle to precision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        set(handles.text20,'String','z = 0');
        set(handles.c,'Enable','off');
        set(handles.d,'Enable','off');
        set(handles.e,'Enable','off');
        set(handles.f,'Enable','off');
        set(handles.text15,'String','r = a + b * theta');
        set(handles.g,'Enable','off');
        set(handles.h,'Enable','off');
        set(handles.i,'Enable','off');
        set(handles.alpha,'Enable','on');
        set(handles.beta,'Enable','on');
        set(handles.zcomp,'Enable','on');
        set(handles.spiral_type,'Value',1);
        set(handles.zcomp,'Value',1);
        set(handles.thick,'Enable','on');
        set(handles.surfface,'Enable','on');
handles.plane=[0 0 1];
set(handles.Xeq,'String','0');
set(handles.Yeq,'String','0');
set(handles.Zeq,'String','1');
vr=[[1 0;-1 0;0 1;0 -1]*null([0 0 1])';0 0 0];
fc=[1 5 3;2 5 3;2 5 4;1 4 5];
fv.vertices=vr;
fv.faces=fc;
handles.fv=fv;
handles.cerchi=[0;0;0];
handles.oct=zeros(8,3);
handles.surface=0;
handles.scloud=0;
handles.cloud=0;
handles.spiral=zeros(3,1);
set(handles.show_internal,'BackgroundColor','r');
set(handles.show_internal,'Enable','off');
set(handles.show_scloud,'BackgroundColor','r');
set(handles.show_scloud,'Enable','off');
set(handles.show_surface,'BackgroundColor','r');
set(handles.show_surface,'Enable','off');
set(handles.export_line,'BackgroundColor','r');
set(handles.export_line,'Enable','off');
set(handles.export_internal,'BackgroundColor','r');
set(handles.export_internal,'Enable','off');
set(handles.export_scloud,'BackgroundColor','r');
set(handles.export_scloud,'Enable','off');
set(handles.export_surface,'BackgroundColor','r');
set(handles.export_surface,'Enable','off');
guidata(hObject, handles);
refresh_plane(handles);
guidata(hObject, handles);

function [cerchi oct]=generate_thickness(a,handles)
surfface=str2double(get(handles.surfface,'String'));
stype=get(handles.spiral_type,'Value');
thick=str2double(get(handles.thick,'String'));
spir=handles.spiral;
set(handles.timebar_text,'Visible','on','String','Generating Thickness');
drawnow update;
if a==1
cerchi=[[0;0;0] spir(:,2:end)-spir(:,1:end-1)];
start=2;
else cerchi=spir(:,2:(end+1)/2)-spir(:,1:(end+1)/2-1);
    start=1;
end
oct=zeros(surfface,3,length(cerchi));    
perc=(length(cerchi)-1)/100;
    for it=start:length(cerchi)
        sss=sprintf('Genetaring Thickness...%3.1f %%', it/perc);
        set(handles.timebar_text,'String',sss);
        drawnow update;
        cerc=cerchi(:,it);
        mm=norm(cerc)*thick;
        nullity=(null(cerc'))';
        if dot(cerc,[1 0 0])>0 
            nullity=[-1 0;0 1]*nullity;
        end
        vects=gen_polygon(handles,surfface,mm);
        piu=zeros(3,surfface);
        piu=bsxfun(@plus,piu,spir(:,it));
        oct(:,:,it)=vects*nullity+piu';
    end
if a==2
    oct(:,:,end)=oct(:,:,end)-vects*nullity/2;
    cerchi=[cerchi fliplr(-cerchi)];
    oct= cat(3, oct, flipdim(-oct,3));
end
if stype==6
    piu=zeros(3,surfface);
    piu=bsxfun(@plus,piu,spir(:,1));
    oct(:,:,1)=piu';
    piu=zeros(3,surfface);
    piu=bsxfun(@plus,piu,spir(:,end));
    oct(:,:,end)=piu';
end

for it=start:length(cerchi)
    plot3(oct(:,1,it),oct(:,2,it),oct(:,3,it));
end
set(handles.timebar_text,'Visible','off');



function surfface_Callback(hObject, eventdata, handles)
% hObject    handle to surfface (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of surfface as text
%        str2double(get(hObject,'String')) returns contents of surfface as a double
x=floor(str2double(get(hObject,'String')));
if x<4;
x=4;
end
sss=sprintf('%d', x);
set(hObject,'String',sss);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function surfface_CreateFcn(hObject, eventdata, handles)
% hObject    handle to surfface (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function vects=gen_polygon(handles,surfface,mm)
div=0:2*pi/surfface:2*pi-2*pi/surfface;
vects=[cos(div')*mm sin(div')*mm];

function scloud=gen_scloud(handles,oct)
set(handles.timebar_text,'Visible','on','String','Generating Thickness');
drawnow update;
faces=length(oct(:,1,1))-1;
perc=(length(oct(1,1,:))-1)*faces/100;
oct=cat(1, oct, oct(1,:,:));
pl=1;
scloud=zeros(2*perc*100,3);
for slength=1:length(oct(1,1,:))-1
for polygon=1:faces
    it=(slength-1)*faces+polygon;
    sss=sprintf('Genetaring Surface Cloud...%3.1f %%', it/perc);
        set(handles.timebar_text,'String',sss);
        drawnow update;
p1=oct(polygon,:,slength);
p2=oct(polygon+1,:,slength);
p3=oct(polygon+1,:,slength+1);
p4=oct(polygon,:,slength+1);
p=[p1;p2;p3;p4];
[or,in]=min([norm(p1);norm(p2);norm(p3);norm(p4)]);
p=circshift(p,-in+1);
dx=p(2,:)-p(1,:);
dy=p(4,:)-p(1,:);
x1=p(1,:)/2+dx*rand;
y1=p(1,:)/2+dy*rand;
pp1=x1+y1;
x2=p(1,:)/2+dx*rand;
y2=p(1,:)/2+dy*rand;
pp2=x2+y2;
scloud(pl,:)=pp1;
pl=pl+1;
scloud(pl,:)=pp2;
pl=pl+1;
end
end


function cloud=gen_cloud(handles,oct)
set(handles.timebar_text,'Visible','on','String','Generating Internal Cloud');
drawnow update;
faces=length(oct(:,1,1));
perc=(length(oct(1,1,:)))*faces/100;
oct=cat(1, oct, oct(1,:,:));
pl=1;
j=2;    % j*faces is the number of points in every spital slice
pp=zeros(j*perc*100,3);

for slength=1:length(oct(1,1,:))-1
for polygon=1:faces-1
    it=(slength-1)*faces+polygon;
    sss=sprintf('Genetaring Internal Cloud...%3.1f %%', it/perc);
        set(handles.timebar_text,'String',sss);
        drawnow update;
    apenanti=mod(floor(faces/2)+polygon+1,faces);
    if apenanti==0,apenanti=faces;end
p1=oct(polygon+1,:,slength);
p2=oct(polygon,:,slength);
p3=oct(apenanti,:,slength);
p4=oct(apenanti,:,slength+1);
p5=oct(polygon+1,:,slength+1);
p6=oct(polygon,:,slength+1);
p=[p1;p2;p3;p4;p5;p6];

dy=p2-p1;
dz=p3-p1;
dx=p5-p1;

for k=1:j
dyp=dy*rand;
dxp=dx*rand;
dzn=norm(dy-dyp)*norm(dz)/norm(dy);
dzp=dz./norm(dz)*rand*dzn;
pp(pl,:)=p(1,:)+dzp+dxp+dyp;
pl=pl+1;
end
end
end
cloud=pp;

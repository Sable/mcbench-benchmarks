function varargout = Understanding_Euler_Angles(varargin)
% Understanding_Euler_Angles M-file for Understanding_Euler_Angles.fig
%      Understanding_Euler_Angles, by itself, creates a new Understanding_Euler_Angles or raises the existing
%      singleton*.
%
%      H = Understanding_Euler_Angles returns the handle to a new Understanding_Euler_Angles or the handle to
%      the existing singleton*.
%
%      Understanding_Euler_Angles('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Understanding_Euler_Angles.M with the given input arguments.
%
%      Understanding_Euler_Angles('Property','Value',...) creates a new Understanding_Euler_Angles or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RotationsGUI1_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RotationsGUI1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help Understanding_Euler_Angles

% Last Modified by GUIDE v2.5 01-Oct-2006 23:41:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Understanding_Euler_Angles_OpeningFcn, ...
                   'gui_OutputFcn',  @Understanding_Euler_Angles_OutputFcn, ...
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


% --- Executes just before Understanding_Euler_Angles is made visible.
function Understanding_Euler_Angles_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Understanding_Euler_Angles (see VARARGIN)

% Choose default command line output for Understanding_Euler_Angles
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
axes(handles.axes1)

% nothing=0;
% save TempDat nothing
% delete *.mat

Rotations


% UIWAIT makes Understanding_Euler_Angles wait for user response (see UIRESUME)
% uiwait(handles.Understanding_Euler_Angles);


% --- Outputs from this function are returned to the command line.
function varargout = Understanding_Euler_Angles_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

SS=get(0,'ScreenSize');
x=(SS(3)-800)/2;
y=(SS(4)-544)/2;
set(handles.Understanding_Euler_Angles,'Position',[ x    y   800   544])

set(handles.axes2,'Visible','off')

set(handles.Angle1,'String',  '   ')
set(handles.Angle2,'String',  '   ')
set(handles.Angle3,'String',  '   ')

set(handles.Set1,'Enable','off')
set(handles.Set2,'Enable','off')
set(handles.Set3,'Enable','off')

set(handles.POR1,'Enable','off')
set(handles.POR2,'Enable','off')
set(handles.POR3,'Enable','off')

set(handles.PAR1,'Enable','off')
set(handles.PAR2,'Enable','off')
set(handles.PAR3,'Enable','off')

set(handles.Set0,'Value',1)

set(handles.Set1,'Value',0)
set(handles.Set2,'Value',0)
set(handles.Set3,'Value',0)

set(handles.POR1,'Value',0)
set(handles.POR2,'Value',0)
set(handles.POR3,'Value',0)

set(handles.PAR1,'Value',0)
set(handles.PAR2,'Value',0)
set(handles.PAR3,'Value',0)










% --- Executes on button press in Set0.
function Set0_Callback(hObject, eventdata, handles)
% hObject    handle to Set0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Set0
load Maxes
if (get(hObject,'Value') == get(hObject,'Max'))
    set(CoAxes0,'Visible','on')
else
    set(CoAxes0,'Visible','off')
end

% --- Executes on button press in Set1.
function Set1_Callback(hObject, eventdata, handles)
% hObject    handle to Set1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Set1
load Maxes
if (get(hObject,'Value') == get(hObject,'Max'))
    set(CoAxes1,'Visible','on')
else
    set(CoAxes1,'Visible','off')
end

% --- Executes on button press in Set2.
function Set2_Callback(hObject, eventdata, handles)
% hObject    handle to Set2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Set2

load Maxes
if (get(hObject,'Value') == get(hObject,'Max'))
    set(CoAxes2,'Visible','on')
else
    set(CoAxes2,'Visible','off')
end


% --- Executes on button press in Set3.
function Set3_Callback(hObject, eventdata, handles)
% hObject    handle to Set3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Set3

load Maxes
if (get(hObject,'Value') == get(hObject,'Max'))
    set(CoAxes3,'Visible','on')
else
    set(CoAxes3,'Visible','off')
end


% --- Executes on selection change in ChooseAxis.
function ChooseAxis_Callback(hObject, eventdata, handles)
% hObject    handle to ChooseAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ChooseAxis contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ChooseAxis



% --- Executes during object creation, after setting all properties.
function ChooseAxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChooseAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ChooseAngle.
function ChooseAngle_Callback(hObject, eventdata, handles)
% hObject    handle to ChooseAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ChooseAngle contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ChooseAngle


% --- Executes during object creation, after setting all properties.
function ChooseAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChooseAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in RotateView.
function Rotate_Callback(hObject, eventdata, handles)
% hObject    handle to RotateView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

save HANDLESFILE handles
CAngle = get(handles.ChooseAngle,'Value')*10*pi/180;

load Maxes
load Trans


count=count+1;

ChAxis = get(handles.ChooseAxis,'Value');



if ROT(1)==ChAxis | ROT(2)==ChAxis
    
    m1='    Repeated Sequences ( XYX, XZX, YXY, YZY, ZXZ, ZYZ ) are not allowed !  ';
    m2='                                                                           ';
    m3='             Try Sequences like : XYZ, XZY,YZX, YXZ, ZXY, ZYX              ';
    m4='                                                                           ';
    m5='    Press Yes to RESET   or   No to CONTINUE to next unrepeated rotation   ';
    msg=strvcat(m1,m2,m3,m4,m5);
    button = questdlg(msg,'This Sequence is not allowed !!!');
    
    if strcmp(button,'Yes')==1
        set(handles.Rotate,'Enable','on')
        Understanding_Euler_Angles
        return
    else
        return
    end
end
 
if count==1
%     for 1:3:10
        
    CA='[CoAxes1 CoAxes2 CoAxes3]';
    set(CoAxes1,'Visible','on')
    CA1=copyobj(CoAxes1,gca);
    setangle='handles.Angle1';
    
    set(handles.POR1,'Value',1)
    set(handles.PAR1,'Value',1)
elseif count==2
    CA='[CoAxes2 CoAxes3]';
    set(CoAxes2,'Visible','on')
    CA1=copyobj(CoAxes2,gca);
    setangle='handles.Angle2';

    set(handles.POR2,'Value',1)
    set(handles.PAR2,'Value',1)    

    
elseif count==3
    CA='CoAxes3';
    set(CoAxes3,'Visible','on')
    CA1=copyobj(CoAxes3,gca);
    set(handles.Rotate,'Enable','off')
    setangle='handles.Angle3';
    
    set(handles.POR3,'Value',1) 
    set(handles.PAR3,'Value',1)

end

A1=[1       0              0      ;...
   0    cos(CAngle)  sin(CAngle) ;...
   0   -sin(CAngle)  cos(CAngle) ]';

A2=[cos(CAngle)   0     -sin(CAngle) ;...
     0           1           0      ;...
   sin(CAngle)   0      cos(CAngle) ]';

A3=[ cos(CAngle) sin(CAngle)  0  ;...
  -sin(CAngle) cos(CAngle)  0  ;...
     0         0            1  ]';
    

     
cc=zeros(1,3);  
cc(count)=1;
switch ChAxis
    case 1
        Dir=1;
        
        ca='arc1';
        set(eval(ca),'Visible','on')
        
        set(RotPlane(1),'FaceColor',cc,'Edgecolor',cc)
        set(RotPlane(1),'Visible','on')

        set(eval(setangle),'String',  ['  X Axis  :  ' num2str(CAngle*180/pi)])
        
    
        set(handles.Rotate,'Enable','off')
        for i=1:CAngle*180/pi
            drawnow
            CA2=copyobj(CA1,gca);
            delete(CA1)
            rotate(CA2,Vx,1,[0 0 0])
            ARC(i,:)=copyobj(eval(ca),gca);    
            rotate(ARC(i,:),Vx,i,[0 0 0])
            CA1=copyobj(CA2,gca);
            delete(CA2)  
        end

        delete( eval(ca) )
        set(handles.Rotate,'Enable','on')  

        set(ARC,'FaceColor',cc)
        delete(CA1)
        
        rotate(eval(CA),Vx,CAngle*180/pi,[0 0 0])
  
       
        if strcmp(get(RotPlane(2),'Visible'),'off')==1
            rotate(RotPlane(2),Vx,CAngle*180/pi,[0 0 0])
            rotate(arc2,Vx,CAngle*180/pi,[0 0 0])
        end
        if strcmp(get(RotPlane(3),'Visible'),'off')==1
            rotate(RotPlane(3),Vx,CAngle*180/pi,[0 0 0])
            rotate(arc3,Vx,CAngle*180/pi,[0 0 0])
        end
   
      
        Anow=A1;
    case 2
        Dir=2;
        ca='arc2';
        set(eval(ca),'Visible','on')
        
        set(RotPlane(2),'FaceColor',cc,'EdgeColor',cc)
        set(RotPlane(2),'Visible','on')

        
        
        set(eval(setangle),'String',  ['  Y Axis  :  ' num2str(CAngle*180/pi)])
        
        set(handles.Rotate,'Enable','off')
        for i=1:CAngle*180/pi
            drawnow
            CA2=copyobj(CA1,gca);
            delete(CA1)
            rotate(CA2,Vy,1,[0 0 0])
            ARC(i,:)=copyobj(eval(ca),gca);    
            rotate(ARC(i,:),Vy,i,[0 0 0])
            CA1=copyobj(CA2,gca);
            delete(CA2)  
        end

        delete( eval(ca) )
        set(handles.Rotate,'Enable','on')  

        set(ARC,'FaceColor',cc)
        delete(CA1)

        rotate(eval(CA),Vy,CAngle*180/pi,[0 0 0])

        if strcmp(get(RotPlane(3),'Visible'),'off')==1
            rotate(RotPlane(3),Vy,CAngle*180/pi,[0 0 0])
            rotate(arc3,Vy,CAngle*180/pi,[0 0 0])
            
        end
        if strcmp(get(RotPlane(1),'Visible'),'off')==1
            rotate(RotPlane(1),Vy,CAngle*180/pi,[0 0 0])
            rotate(arc1,Vy,CAngle*180/pi,[0 0 0])
        end

               
        Anow=A2;
    case 3
        Dir=3;
        
        ca='arc3';
        
        set(eval(ca),'Visible','on')
        
        set(RotPlane(3),'FaceColor',cc,'Edgecolor',cc)
        set(RotPlane(3),'Visible','on')

        set(eval(setangle),'String',  ['  Z Axis  :  ' num2str(CAngle*180/pi)])
        
  
        set(handles.Rotate,'Enable','off')
        for i=1:CAngle*180/pi
            drawnow
            CA2=copyobj(CA1,gca);
            delete(CA1)
            rotate(CA2,Vz,1,[0 0 0])
            ARC(i,:)=copyobj(eval(ca),gca);    
            rotate(ARC(i,:),Vz,i,[0 0 0])
            CA1=copyobj(CA2,gca);
            delete(CA2)  
        end

        delete( eval(ca) )
        set(handles.Rotate,'Enable','on')  

        set(ARC,'FaceColor',cc)
        delete(CA1)
        
        rotate(eval(CA),Vz,CAngle*180/pi,[0 0 0])
        
        if strcmp(get(RotPlane(1),'Visible'),'off')==1
            rotate(RotPlane(1),Vz,CAngle*180/pi,[0 0 0])
            rotate(arc1,Vz,CAngle*180/pi,[0 0 0])
        end
        
        if strcmp(get(RotPlane(2),'Visible'),'off')==1
            rotate(RotPlane(2),Vz,CAngle*180/pi,[0 0 0])
            rotate(arc2,Vz,CAngle*180/pi,[0 0 0])
        end
        
%         if strcmp(get(RotPlane(2),'Visible'),'off')==1
%             rotate(arc2,Vz,CAngle*180/pi,[0 0 0])
%         end
        
       
        Anow=A3;
end

switch count
   case 1
       ROT(1)=Dir;
       Vx=Anow*[1;0;0];        
       Vy=Anow*[0;1;0];
       Vz=Anow*[0;0;1];
       set(CoAxes1,'Visible','on')
       set(handles.Set1,'Value',1)
       set(handles.Set1,'Enable','on')
       
   case 2
       ROT(2)=Dir;
       set(CoAxes2,'Visible','on')
       set(handles.Set2,'Value',1)
       set(handles.Set2,'Enable','on')
       
       Vx=Aprev*Anow*[1;0;0];        
       Vy=Aprev*Anow*[0;1;0];
       Vz=Aprev*Anow*[0;0;1];  
   case 3
       ROT(3)=Dir;
       set(CoAxes3,'Visible','on')
       set(handles.Set3,'Value',1) 
       set(handles.Set3,'Enable','on')
       set(handles.Rotate,'Enable','off')
%        Vx=Aprev*Anow*[1;0;0];        
%        Vy=Aprev*Anow*[0;1;0];
%        Vz=Aprev*Anow*[0;0;1];  % But Not needed Since the rotation is
%        over and no more transformation is neede.
end

Aprev=Anow;

if count==1
    ARC1=copyobj(ARC,gca);
    delete(ARC)
    set(handles.POR1,'Enable','on')
    set(handles.PAR1,'Enable','on')
elseif count==2
    ARC2=copyobj(ARC,gca);
    delete(ARC)
    set(handles.POR2,'Enable','on')
    set(handles.PAR2,'Enable','on')
elseif count==3
    ARC3=copyobj(ARC,gca);
    delete(ARC)
    set(handles.POR3,'Enable','on')
    set(handles.PAR3,'Enable','on')
end

save Trans A1 A2 A3 Aprev Vx Vy Vz count ROT ARC1 ARC2 ARC3 arc1 arc2 arc3



% --- Executes on button press in RESET.
function RESET_Callback(hObject, eventdata, handles)
% hObject    handle to RESET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Rotate,'Enable','on')
Understanding_Euler_Angles


% --- Executes on button press in POR1.
function POR1_Callback(hObject, eventdata, handles)
% hObject    handle to POR1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of POR1


load Trans
load Maxes
if (get(hObject,'Value') == get(hObject,'Max'))
    set(RotPlane(ROT(1)),'Visible','on')
else
    set(RotPlane(ROT(1)),'Visible','off')
end


% --- Executes on button press in POR2.
function POR2_Callback(hObject, eventdata, handles)
% hObject    handle to POR2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of POR2

load Trans
load Maxes
if (get(hObject,'Value') == get(hObject,'Max'))
    set(RotPlane(ROT(2)),'Visible','on')
else
    set(RotPlane(ROT(2)),'Visible','off')
end



% --- Executes on button press in POR3.
function POR3_Callback(hObject, eventdata, handles)
% hObject    handle to POR3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of POR3

load Trans
load Maxes
if (get(hObject,'Value') == get(hObject,'Max'))
    set(RotPlane(ROT(3)),'Visible','on')
else
    set(RotPlane(ROT(3)),'Visible','off')
end



% --- Executes on button press in Iso.
function Iso_Callback(hObject, eventdata, handles)
% hObject    handle to Iso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load Maxes
view([1 1 1])
camlookat(BaseSphere)
camzoom(1.5)


% --- Executes on button press in XY.
function XY_Callback(hObject, eventdata, handles)
% hObject    handle to XY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load Maxes
view(0,90)
camlookat(BaseSphere)
camzoom(1.3)



% --- Executes on button press in YZ.
function YZ_Callback(hObject, eventdata, handles)
% hObject    handle to YZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load Maxes
view(90,0)
camlookat(BaseSphere)
camzoom(1.3)



% --- Executes on button press in ZX.
function ZX_Callback(hObject, eventdata, handles)
% hObject    handle to ZX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load Maxes
view(0,0)
camlookat(BaseSphere)
camzoom(1.3)

% --- Executes on button press in RotateView.
function RotateView_Callback(hObject, eventdata, handles)
% hObject    handle to RotateView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RotateView
load Maxes
rotate3d

function Angle1_Callback(hObject, eventdata, handles)
% hObject    handle to Angle1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Angle1 as text
%        str2double(get(hObject,'String')) returns contents of Angle1 as a double


% --- Executes during object creation, after setting all properties.
function Angle1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Angle1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Angle2_Callback(hObject, eventdata, handles)
% hObject    handle to Angle2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Angle2 as text
%        str2double(get(hObject,'String')) returns contents of Angle2 as a double


% --- Executes during object creation, after setting all properties.
function Angle2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Angle2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Angle3_Callback(hObject, eventdata, handles)
% hObject    handle to Angle3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Angle3 as text
%        str2double(get(hObject,'String')) returns contents of Angle3 as a double


% --- Executes during object creation, after setting all properties.
function Angle3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Angle3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in PAR1.
function PAR1_Callback(hObject, eventdata, handles)
% hObject    handle to PAR1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PAR1

load Trans
load Maxes
if (get(hObject,'Value') == get(hObject,'Max'))
    set(ARC1,'Visible','on')
else
    set(ARC1,'Visible','off')
end



% --- Executes on button press in PAR2.
function PAR2_Callback(hObject, eventdata, handles)
% hObject    handle to PAR2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PAR2

load Trans
load Maxes
if (get(hObject,'Value') == get(hObject,'Max'))
    set(ARC2,'Visible','on')
else
    set(ARC2,'Visible','off')
end


% --- Executes on button press in PAR3.
function PAR3_Callback(hObject, eventdata, handles)
% hObject    handle to PAR3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PAR3

load Trans
load Maxes
if (get(hObject,'Value') == get(hObject,'Max'))
    set(ARC3,'Visible','on')
else
    set(ARC3,'Visible','off')
end


% --- Executes on button press in Author.
function Author_Callback(hObject, eventdata, handles)
% hObject    handle to Author (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Author

state=get(hObject,'Value');
if state==get(hObject,'Max')
    B = imread('Banner.jpg');
    set(handles.axes2,'Visible','on')
    axes(handles.axes2)
    B=image(B);
    
    save('ha','B')
%     save Banner B
%     guidata(Banner,handles)
    axis off
    axes(handles.axes1)
elseif state==get(hObject,'Min')
    load ha;
    set(B,'Visible','off')
    set(handles.axes2,'Visible','off')
    axes(handles.axes1)
    
end



function whileclosing(hObject, eventdata, handles)

clc
clear
closereq

aa=0;

save ha aa
save HANDLESFILE aa
save Maxes aa
save Trans aa

delete ha.mat HANDLESFILE.mat Maxes.mat Trans.mat

msg=['  Please Review in mathworks.com or Send your Feedbacks to author   ';...
     '                                                                    ';...
     '     j.divahar@yahoo.com / j.divahar@gmail.com                      ';...
     '                                                                    ';...
     '     HomePage: http://four.fsphost.com/jdivahar                     '];
    

button = msgbox(msg,'Thank you For Trying !');

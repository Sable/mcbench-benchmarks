function varargout = CollectiveAndCyclic(varargin)
% CollectiveAndCyclic M-file for CollectiveAndCyclic.fig
%      CollectiveAndCyclic, by itself, creates a new CollectiveAndCyclic or raises the existing
%      singleton*.
%
%      hObject = CollectiveAndCyclic returns the handle to a new CollectiveAndCyclic or the handle to
%      the existing singleton*.
%
%      CollectiveAndCyclic('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CollectiveAndCyclic.M with the given input arguments.
%
%      CollectiveAndCyclic('Property','Value',...) creates a new CollectiveAndCyclic or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CollectiveAndCyclic_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CollectiveAndCyclic_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help CollectiveAndCyclic

% Last Modified by GUIDE v2.5 22-Jul-2006 06:46:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CollectiveAndCyclic_OpeningFcn, ...
                   'gui_OutputFcn',  @CollectiveAndCyclic_OutputFcn, ...
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


% --- Executes just before CollectiveAndCyclic is made visible.
function CollectiveAndCyclic_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CollectiveAndCyclic (see VARARGIN)

% Choose default command line output for CollectiveAndCyclic
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes CollectiveAndCyclic wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = CollectiveAndCyclic_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

SS=get(0,'ScreenSize');
x=(SS(3)-1002)/2;
y=(SS(4)-691)/2;
set(handles.CollectiveAndCyclic,'Position',[ x    y   1002   691])

% --------------------------------------------------------------------
function Simulate_Callback(hObject, eventdata, handles)

a=round(15*rand(1,1));
b=[num2str(a) '.jpg'];
hold off
heli=imread(b);
axes(handles.axes1)
image(heli);

set(handles.Wait,'Visible','on')
drawnow

be = eval( get(handles.getBeta,'String' ) );
th = eval( get(handles.getTheta,'String') );
ze = eval( get(handles.getZeta,'String' ) );


hold off
Rotor(be,th,ze)

set(gcbf,'Color',[0.7 0.7 0.7])
load para
set(handles.Wait,'Visible','off')

if strcmp(get(handles.Start,'Enable'),'off')==1
    set(handles.Start,'Enable','on')
    set(handles.Stop,'Enable','on')
    set(handles.Play_Bar,'Enable','on')
    set(handles.XY_Plane,'Enable','on')
    set(handles.YZ_Plane,'Enable','on')    
    set(handles.ZX_Plane,'Enable','on')    
    set(handles.Iso_View,'Enable','on')
end
    
    

if get(handles.Rotor_Shaft,'Value')==1
    set(Rotor_Shaft,'Visible','on') 
end

if get(handles.HP,'Value')==1
    set(HP,'Visible','on')  
end

if get(handles.TPP,'Value')==1
    set(TPP,'Visible','on')  
end
    
if get(handles.NFP,'Value')==1
    set(NFP,'Visible','on')  
end

if get(handles.Rotor_Cone,'Value')==1
    set(Rotor_Cone,'Visible','on')  
end
  

% getting the selection of ref plane  

i=get(handles.Play_Bar,'Value');
if get(handles.Four_Angles,'Value')==1
	val = get(handles.Choose_Ref,'Value');
	switch val
	case 1
		handles.sel = 1;
	case 2
		handles.sel = 2;
	case 3
		handles.sel = 3;
	end
	Ref=handles.sel;
	
	indx=([1 10 19 28]);
     
	if Ref==1
        set(a_HP(indx,:),'Visible','on')
        if get(handles.Blade_Angles,'Value')==1
            set(a_HP(i,:),'Visible','on')
        end
            
    elseif Ref==2
    	set(a_TPP(indx,:),'Visible','on')        
        if get(handles.Blade_Angles,'Value')==1
            set(a_HP(i,:),'Visible','on')
        end
    elseif Ref==3
		set(a_NFP(indx,:),'Visible','on')        
        if get(handles.Blade_Angles,'Value')==1
            set(a_HP(i,:),'Visible','on')
        end
    end
elseif get(handles.Blade_Angles,'Value')==1
	val = get(handles.Choose_Ref,'Value');
	switch val
	case 1
		handles.sel = 1;
	case 2
		handles.sel = 2;
	case 3
		handles.sel = 3;
	end
	Ref=handles.sel;
	
	if Ref==1
        set(a_HP(indx,:),'Visible','on') 
    elseif Ref==2
        set(a_TPP(indx,:),'Visible','on')        
    elseif Ref==3
        set(a_NFP(indx,:),'Visible','on')        
    end
end

if get(handles.Blades,'Value')==1
    set(Blade_Disk,'Visible','on')      
end


if get(handles.Blade,'Value')==1
    set(Blade_Disk(i+1,:),'Visible','on')      
end    

if get(handles.HP_Cross,'Value')==1
    set(HP_Cross,'Visible','on')
end

if get(handles.Axes,'Value')==1
    set(XAXIS,'Visible','on')  
    set(YAXIS,'Visible','on')  
    set(ZAXIS,'Visible','on')         
    
end

[az,el] = view;

if az<0
    az=az+360;
end
if el<0
    el=el+360;
end

set(handles.Azimuth,'Value',az);
set(handles.Elevation,'Value',el);

% --------------------------------------------------------------------
function Axes_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
load para
if button_state == get(hObject,'Max')
    % toggle button is pressed
    set(XAXIS,'Visible','on')
    set(YAXIS,'Visible','on')
    set(ZAXIS,'Visible','on')    
elseif button_state == get(hObject,'Min')
    % toggle button is not pressed
    set(XAXIS,'Visible','off')
    set(YAXIS,'Visible','off')
    set(ZAXIS,'Visible','off')    
end



% --------------------------------------------------------------------
function Rotor_Shaft_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
load para
if button_state == get(hObject,'Max')
    % toggle button is pressed
    set(Rotor_Shaft,'Visible','on')
elseif button_state == get(hObject,'Min')
    % toggle button is not pressed
    set(Rotor_Shaft,'Visible','off')    
end



% --------------------------------------------------------------------
function Rotor_Cone_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
load para
if button_state == get(hObject,'Max')
    % toggle button is pressed
    set(Rotor_Cone,'Visible','on')
elseif button_state == get(hObject,'Min')
    % toggle button is not pressed
    set(Rotor_Cone,'Visible','off')    
end 



% --------------------------------------------------------------------
function Blade_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
load para
% Blade_Disk=Make_Blade(0,20,0,0);

if button_state == get(hObject,'Max')
    % toggle button is pressed
    set(Blade_Disk(1,:),'Visible','on')
elseif button_state == get(hObject,'Min')
    % toggle button is not pressed
    if get(handles.Blades,'Value')==get(handles.Blades,'Max')
        set(Blade_Disk(1,:),'Visible','off')
    else
        set(Blade_Disk,'Visible','off')
    end
end



% --------------------------------------------------------------------
function HP_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
load para
if button_state == get(hObject,'Max')
    % toggle button is pressed
    set(HP,'Visible','on')
elseif button_state == get(hObject,'Min')
    % toggle button is not pressed
    set(HP,'Visible','off')    
end



% --------------------------------------------------------------------
function TPP_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
load para
if button_state == get(hObject,'Max')
    % toggle button is pressed
    set(TPP,'Visible','on')
elseif button_state == get(hObject,'Min')
    % toggle button is not pressed
    set(TPP,'Visible','off')    
end



% --------------------------------------------------------------------
function NFP_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
load para
if button_state == get(hObject,'Max')
    % toggle button is pressed
    set(NFP,'Visible','on')
elseif button_state == get(hObject,'Min')
    % toggle button is not pressed
    set(NFP,'Visible','off') 
end



% --------------------------------------------------------------------
function HP_Cross_Callback(hObject, eventdata, handles)
button_state = get(handles.HP_Cross,'Value');
load para
if button_state == get(hObject,'Max')
    % toggle button is pressed
    set(HP_Cross,'Visible','on')
elseif button_state == get(hObject,'Min')
    % toggle button is not pressed
    set(HP_Cross,'Visible','off')
end





% --------------------------------------------------------------------
function Blade_Angles_Callback(hObject, eventdata, handles)
load para
i=round(get(handles.Play_Bar,'Value'));
val = get(handles.Choose_Ref,'Value');
switch val
case 1
	handles.sel = 1;
case 2
	handles.sel = 2;
case 3
	handles.sel = 3;
end
Ref=handles.sel;

if get(handles.Blade_Angles,'Value')==1
    if get(handles.Start,'Value')~=get(handles.Start,'Max')
		Ref=handles.sel;
		if Ref==1
            set(a_HP(i+1,:),'Visible','on') 
        elseif Ref==2
			set(a_TPP(i+1,:),'Visible','on')        
        elseif Ref==3
			set(a_NFP(i+1,:),'Visible','on')        
        end
    end
else
    set(a_HP(i+1,:),'Visible','off')        
	set(a_TPP (i+1,:),'Visible','off')                
	set(a_NFP(i+1,:),'Visible','off') 

    indx=[1 10 19 28];
    if get(handles.Four_Angles,'Value')==1
	Ref=handles.sel;
	if Ref==1
        set(a_HP(indx,:),'Visible','on') 
    elseif Ref==2
		set(a_TPP(indx,:),'Visible','on')        
    elseif Ref==3
		set(a_NFP(indx,:),'Visible','on')        
    end
    
end
    
    
end



% --------------------------------------------------------------------
function Four_Angles_Callback(hObject, eventdata, handles)
load para
val = get(handles.Choose_Ref,'Value');
i=round(get(handles.Play_Bar,'Value'));

switch val
case 1
	handles.sel = 1;
case 2
	handles.sel = 2;
case 3
	handles.sel = 3;
end
Ref=handles.sel;

indx=([1 10 19 28]);

set(a_HP,'Visible','off')        
set(a_TPP,'Visible','off')                
set(a_NFP,'Visible','off')        


if get(handles.Four_Angles,'Value')==1
	Ref=handles.sel;
	if Ref==1
        set(a_HP(indx,:),'Visible','on') 
    elseif Ref==2
		set(a_TPP(indx,:),'Visible','on')        
    elseif Ref==3
		set(a_NFP(indx,:),'Visible','on')        
    end
    
end

if get(handles.Blade_Angles,'Value')==1
	Ref=handles.sel;
	if Ref==1
        set(a_HP(i+1,:),'Visible','on') 
    elseif Ref==2
		set(a_TPP(i+1,:),'Visible','on')        
    elseif Ref==3
		set(a_NFP(i+1,:),'Visible','on')        
    end
    
end



% --------------------------------------------------------------------
function Blades_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
load para
i=get(handles.Play_Bar,'Value');
if button_state == get(hObject,'Max')
    % toggle button is pressed
    set(Blade_Disk,'Visible','on')
elseif button_state == get(hObject,'Min')
    % toggle button is not pressed
    set(Blade_Disk,'Visible','off')
    
    if get(handles.Blade,'Value')==1
        set(Blade_Disk(i+1,:),'Visible','on')      
    end  
    
end



% --------------------------------------------------------------------
function Choose_Ref_Callback(hObject, eventdata, handles)
load para   
val = get(handles.Choose_Ref,'Value');
switch val
case 1
	handles.sel = 1;
case 2
	handles.sel = 2;
case 3
	handles.sel = 3;
end
Ref=handles.sel;

indx=([1 10 19 28]);
i=round(get(handles.Play_Bar,'Value'));

set(a_HP,'Visible','off')        
set(a_TPP,'Visible','off')                
set(a_NFP,'Visible','off')        

if get(handles.Four_Angles,'Value')==1
	Ref=handles.sel;
	if Ref==1                
		set(a_TPP,'Visible','off')                
		set(a_NFP,'Visible','off')             
        set(a_HP(indx,:),'Visible','on') 
    elseif Ref==2
		set(a_HP,'Visible','off')        
		set(a_NFP,'Visible','off')             
		set(a_TPP(indx,:),'Visible','on')        
    elseif Ref==3
		set(a_HP,'Visible','off')        
		set(a_TPP,'Visible','off')                
		set(a_NFP(indx,:),'Visible','on')        
    end
end

if get(handles.Blade_Angles,'Value')==1
    Ref=handles.sel;
	if Ref==1                
		set(a_TPP,'Visible','off')                
		set(a_NFP,'Visible','off')             
        set(a_HP(i+1,:),'Visible','on') 
    elseif Ref==2
		set(a_HP,'Visible','off')        
		set(a_NFP,'Visible','off')             
		set(a_TPP(i+1,:),'Visible','on')        
    elseif Ref==3
		set(a_HP,'Visible','off')        
		set(a_TPP,'Visible','off')                
		set(a_NFP(i+1,:),'Visible','on')        
    end
end




% --------------------------------------------------------------------
function Azimuth_Callback(hObject, eventdata, handles)
[az,el] = view;
az = get(handles.Azimuth,'Value');

if az<0
    az=az+360;
end

if el<0
    el=el+360;
end

view(az,el)

if abs( get(handles.Azimuth,'Max')-get(handles.Azimuth,'Value') )<1
    set(handles.Azimuth,'Value',get(handles.Azimuth,'Min'))
elseif abs( get(handles.Azimuth,'Value')-get(handles.Azimuth,'Min'))<1
    set(handles.Azimuth,'Value',get(handles.Azimuth,'Max'))
end




% --------------------------------------------------------------------
function Elevation_Callback(hObject, eventdata, handles)

[az,el] = view;
el = get(handles.Elevation,'Value');

if az<0
    az=az+360;
end
if el<0
    el=el+360;
end

view(az,el)

if abs( get(handles.Elevation,'Value')-get(handles.Elevation,'Max') )<1
    set(handles.Elevation,'Value',get(handles.Elevation,'Min'))
elseif abs( get(handles.Elevation,'Value')-get(handles.Elevation,'Min') )<1
    set(handles.Elevation,'Value',get(handles.Elevation,'Max'))
end




% ############################################ Views function Call Sets
% --------------------------------------------------------------------
function XY_Plane_Callback(hObject, eventdata, handles)
handles = guidata(gcbo);

view(0,90)


[az,el] = view;

if az<0
    az=az+360;
end
if el<0
    el=el+360;
end

set(handles.Azimuth,'Value',az);
set(handles.Elevation,'Value',el);

% --------------------------------------------------------------------
function YZ_Plane_Callback(hObject, eventdata, handles)
handles = guidata(gcbo);
view(90,0)
[az,el] = view;

if az<0
    az=az+360;
end
if el<0
    el=el+360;
end

set(handles.Azimuth,'Value',az);
set(handles.Elevation,'Value',el);


% --------------------------------------------------------------------
function ZX_Plane_Callback(hObject, eventdata, handles)
handles = guidata(gcbo);
view(0,0)
[az,el] = view;

if az<0
    az=az+360;
end
if el<0
    el=el+360;
end

set(handles.Azimuth,'Value',az);
set(handles.Elevation,'Value',el);


% --------------------------------------------------------------------
function Iso_View_Callback(hObject, eventdata, handles)
handles = guidata(gcbo);
view(3)
[az,el] = view;

if az<0
    az=az+360;
end
if el<0
    el=el+360;
end

set(handles.Azimuth,'Value',az);
set(handles.Elevation,'Value',el);

% --------------------------------------------------------------------
function Play_Bar_Callback(hObject, eventdata, handles)
i=round(get(hObject,'Value'));
load para
set(Blade_Disk,'Visible','off')
set(Blade_Disk(i+1,:),'Visible','on') 

val = get(handles.Choose_Ref,'Value');
switch val
case 1
	handles.sel = 1;
case 2
	handles.sel = 2;
case 3
	handles.sel = 3;
end
Ref=handles.sel;


if get(handles.Blade_Angles,'Value')==1
	Ref=handles.sel;
	if Ref==1
		set(a_TPP,'Visible','off')                
		set(a_NFP,'Visible','off')             
		set(a_HP,'Visible','off') 
        if get(handles.Four_Angles,'Value')==get(handles.Four_Angles,'Max')
            set(a_HP(indx,:),'Visible','on')
        end
        set(a_HP(i+1,:),'Visible','on') 
    elseif Ref==2
		set(a_HP,'Visible','off')        
		set(a_NFP,'Visible','off') 
		set(a_TPP,'Visible','off') 
        if get(handles.Four_Angles,'Value')==get(handles.Four_Angles,'Max')
            set(a_TPP(indx,:),'Visible','on')
        end            
		set(a_TPP(i+1,:),'Visible','on')        
    elseif Ref==3
		set(a_HP,'Visible','off')        
		set(a_TPP,'Visible','off')  
		set(a_NFP,'Visible','off') 
        if get(handles.Four_Angles,'Value')==get(handles.Four_Angles,'Max')
            set(a_NFP(indx,:),'Visible','on')
        end            
		set(a_NFP(i+1,:),'Visible','on')        
    end
    
else
	set(a_HP,'Visible','off')        
	set(a_TPP,'Visible','off')                
	set(a_NFP,'Visible','off') 
    indx=([1 10 19 28]);   
    if get(handles.Four_Angles,'Value')==get(handles.Four_Angles,'Max')
        if Ref==1
            set(a_HP(indx,:),'Visible','on')
        elseif Ref==2
            set(a_TPP(indx,:),'Visible','on')
        elseif Ref==3
            set(a_NFP(indx,:),'Visible','on')
        end
    end            
end






% --------------------------------------------------------------------
function Start_Callback(hObject, eventdata, handles)
set(handles.Stop,'Enable','on')
set(handles.Blades,'Value',0)
set(handles.Blades,'Enable','off')
set(handles.Blade,'Value',1)    
set(handles.Blade,'Enable','off')    
set(handles.getBeta,'Enable','off')
set(handles.getTheta,'Enable','off')
set(handles.getZeta,'Enable','off')
set(handles.Simulate,'Enable','off') 
set(handles.Stop,'Value',0)

i=round(get(handles.Play_Bar,'Value'));
indx=([1 10 19 28]);
while get(hObject,'Value')==get(hObject,'Max')
    if get(handles.Stop,'Value')==get(handles.Stop,'Max')
        break
    end
 
    
    if i==36
        i=0;
    end
    
    set(handles.Play_Bar,'Value',i) 
                                                 
    load para
    set(Blade_Disk,'Visible','off')
    set(Blade_Disk(i+1,:),'Visible','on') 
  
    
    val = get(handles.Choose_Ref,'Value');
	switch val
	case 1
		handles.sel = 1;
	case 2
		handles.sel = 2;
	case 3
		handles.sel = 3;
	end
	Ref=handles.sel;
    
    
    if get(handles.Blade_Angles,'Value')==1
		Ref=handles.sel;
		if Ref==1
			set(a_TPP,'Visible','off')                
			set(a_NFP,'Visible','off')             
			set(a_HP,'Visible','off') 
            if get(handles.Four_Angles,'Value')==get(handles.Four_Angles,'Max')
                set(a_HP(indx,:),'Visible','on')
            end
            set(a_HP(i+1,:),'Visible','on') 
        elseif Ref==2
			set(a_HP,'Visible','off')        
			set(a_NFP,'Visible','off') 
			set(a_TPP,'Visible','off') 
            if get(handles.Four_Angles,'Value')==get(handles.Four_Angles,'Max')
                set(a_TPP(indx,:),'Visible','on')
            end            
			set(a_TPP(i+1,:),'Visible','on')        
        elseif Ref==3
			set(a_HP,'Visible','off')        
			set(a_TPP,'Visible','off')  
			set(a_NFP,'Visible','off') 
            if get(handles.Four_Angles,'Value')==get(handles.Four_Angles,'Max')
                set(a_NFP(indx,:),'Visible','on')
            end            
			set(a_NFP(i+1,:),'Visible','on')        
        end
        
	else
		set(a_HP,'Visible','off')        
		set(a_TPP,'Visible','off')                
		set(a_NFP,'Visible','off') 
       
        if get(handles.Four_Angles,'Value')==get(handles.Four_Angles,'Max')
            if Ref==1
                set(a_HP(indx,:),'Visible','on')
            elseif Ref==2
                set(a_TPP(indx,:),'Visible','on')
            elseif Ref==3
                set(a_NFP(indx,:),'Visible','on')
            end
        end            
    end

    drawnow
 i=i+1;     
end
    
set(handles.Four_Angles,'Enable','on')
set(handles.Blades,'Enable','on')
set(handles.Blade,'Enable','on')      
set(handles.getBeta,'Enable','on')
set(handles.getTheta,'Enable','on')
set(handles.getZeta,'Enable','on')
set(handles.Simulate,'Enable','on') 

if get(handles.Stop,'Value')==get(handles.Stop,'Max')
    set(handles.Start,'Value',0)
	set(handles.Play_Bar,'Value',0)
end


% --------------------------------------------------------------------
function Stop_Callback(hObject, eventdata, handles)
load para
set(handles.Stop,'Enable','off')
set(handles.Blades,'Value',0')
set(Blade_Disk,'Visible','off')

set(a_HP,'Visible','off')        
set(a_TPP,'Visible','off')                
set(a_NFP,'Visible','off') 
val = get(handles.Choose_Ref,'Value');
switch val
case 1
	handles.sel = 1;
case 2
	handles.sel = 2;
case 3
	handles.sel = 3;
end
Ref=handles.sel;

if get(handles.Blade_Angles,'Value')==1
	Ref=handles.sel;
	if Ref==1
        set(a_HP(1,:),'Visible','on') 
    elseif Ref==2
		set(a_TPP(1,:),'Visible','on')        
    elseif Ref==3
		set(a_NFP(1,:),'Visible','on')        
    end
end

set(handles.Start,'Value',0)
set(Blade_Disk(1,:),'Visible','on')
set(handles.Play_Bar,'Value',0)
set(handles.Play_Bar,'Value',0)


% --------------------------------------------------------------------
function Author_Callback(hObject, eventdata, handles)

state=get(hObject,'Value');
if state==get(hObject,'Max')
    B = imread('Banner.jpg');
    axes(handles.axes2)
    B=image(B);
    save('ha','B')
%     save Banner B
%     guidata(Banner,handles)
    axis off
elseif state==get(hObject,'Min')
    load ha;
    set(B,'Visible','off')
end


function whileclosing(hObject, eventdata, handles)

clc
clear
closereq

aa=0;

save para aa
save looktargetfile aa

delete para.mat looktargetfile.mat

msg=['  Please Review in mathworks.com or Send your Feedbacks to author   ';...
     '                                                                    ';...
     '     j.divahar@yahoo.com / j.divahar@gmail.com                      ';...
     '                                                                    ';...
     '     HomePage: http://four.fsphost.com/jdivahar                     '];
    

button = msgbox(msg,'Thank you For Trying !');


function varargout = Gain_Finder(varargin)
%GAIN_FINDER M-file for Gain_Finder.fig
%      GAIN_FINDER, by itself, creates a new GAIN_FINDER or raises the existing
%      singleton*.
%
%      H = GAIN_FINDER returns the handle to a new GAIN_FINDER or the handle to
%      the existing singleton*.
%
%      GAIN_FINDER('Property','Value',...) creates a new GAIN_FINDER using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to Gain_Finder_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GAIN_FINDER('CALLBACK') and GAIN_FINDER('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GAIN_FINDER.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Gain_Finder

% Last Modified by GUIDE v2.5 11-Feb-2010 14:51:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Gain_Finder_OpeningFcn, ...
    'gui_OutputFcn',  @Gain_Finder_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
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


% --- Executes just before Gain_Finder is made visible.
function Gain_Finder_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for Gain_Finder
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Gain_Finder wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Gain_Finder_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


set(handles.color_stable,'UserData',2);
set(handles.color_stable_blue,'Checked','on');

set(handles.color_boustable,'UserData',3);
set(handles.color_boustable_green,'Checked','on');

set(handles.color_unstable,'UserData',1);
set(handles.color_unstable_red,'Checked','on');
% --- Executes on selection change in tab_result.
function tab_result_Callback(hObject, eventdata, handles)
% hObject    handle to tab_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns tab_result contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tab_result


% --- Executes during object creation, after setting all properties.
function tab_result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tab_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_gedit_Callback(hObject, eventdata, handles)
% hObject    handle to input_gedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_gedit as text
%        str2double(get(hObject,'String')) returns contents of input_gedit as a double



% --- Executes during object creation, after setting all properties.
function input_gedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_gedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function start_gedit_Callback(hObject, eventdata, handles)
% hObject    handle to start_gedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_gedit as text
%        str2double(get(hObject,'String')) returns contents of start_gedit as a double


% --- Executes during object creation, after setting all properties.
function start_gedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_gedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function to_gedit_Callback(hObject, eventdata, handles)
% hObject    handle to to_gedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of to_gedit as text
%        str2double(get(hObject,'String')) returns contents of to_gedit as a double


% --- Executes during object creation, after setting all properties.
function to_gedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to to_gedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function intv_gedit_Callback(hObject, eventdata, handles)
% hObject    handle to intv_gedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of intv_gedit as text
%        str2double(get(hObject,'String')) returns contents of intv_gedit as a double


% --- Executes during object creation, after setting all properties.
function intv_gedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intv_gedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in find.
function find_Callback(hObject, eventdata, handles)
% hObject    handle to find (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%============specify color for stable system================
switch get(handles.color_stable,'UserData')
    case 1
        stacol='red';
    case 2
        stacol='blue';
    case 3
        stacol='green';
    case 4
        stacol='yellow';
    case 5
        stacol='gray';
end
%===========================================================

%=========specify color for boundary stable system==========
switch get(handles.color_boustable,'UserData')
    case 1
        boustacol='red';
    case 2
        boustacol='blue';
    case 3
        boustacol='green';
    case 4
        boustacol='yellow';
    case 5
        boustacol='gray';
end
%===========================================================

%===========specify color for unstable system===============
switch get(handles.color_unstable,'UserData')
    case 1
        unstacol='red';
    case 2
        unstacol='blue';
    case 3
        unstacol='green';
    case 4
        unstacol='yellow';
    case 5
        unstacol='gray';
end
%===========================================================

set(handles.tab_result,'String','');

pstr=get(handles.input_gedit,'String');

if isempty(get(handles.input_gedit,'String'))
    errordlg('Equation not found','Equation Error');
    return
elseif isempty(findstr(pstr,'k'))
    errordlg('Variable of gain(k) is''nt exist','Equation Error');
    return
elseif isempty(get(handles.start_gedit,'String'))
    errordlg('Start gain value not found','Input Error');
    return

elseif isempty(get(handles.to_gedit,'String'))
    errordlg('End gain value not found','Input Error');
    return

elseif isempty(get(handles.intv_gedit,'String'))
    errordlg('Interval not found','Input Error');
    return

end

hwait=waitbar(0,'please wait...','CreateCancelBtn','cancel_exe');
setappdata(hwait,'abort',false);
syms k;
psym=sym(pstr);

start=str2double(get(handles.start_gedit,'String'));
interval=str2double(get(handles.intv_gedit,'String'));
to=str2double(get(handles.to_gedit,'String'));

res='';
b=1;

for i=start:interval:to
    if getappdata(hwait,'abort')
        waitbar(to,hwait,'caceling... 100%');
        delete(hwait);
        return;
    end
    pol=subs(psym,k,i);
    rot=fixz(double(solve(poly2strs(pol,'s'))),7);
    [num rep]=repeatv(rot);
    len=length(num);
    rhp=0;
    njw=0;
    nrjw=0;
    cen=0;
    for j=1:len
        if real(num(j))>0
            rhp=rhp+rep(j);
        elseif real(num(j))==0 && imag(num(j))~=0
            njw=njw+rep(j);
            if rep(j)>=2
                nrjw=nrjw+rep(j);
            end
        elseif num(j)==0
            cen=cen+rep(j);
        end
    end
    nrjw=nrjw/2;
    if rhp~=0 || nrjw>=2 || cen~=0
        res{b}=['<HTML><FONT color=' sprintf('"%s">',unstacol)...
            sprintf('k=%g',i) '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'...
            'system is unstable' '</Font></html>'];
        b=b+1;
    elseif rhp==0 && nrjw==0 && cen==0 && njw~=0
        res{b}=['<HTML><FONT color=' sprintf('"%s">',boustacol)...
            sprintf('k=%g',i) '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'...
            'system is boundary stable' '</Font></html>'];
        b=b+1;
    else
        res{b}=['<HTML><FONT color=' sprintf('"%s">',stacol)...
            sprintf('k=%g',i) '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'...
            'system is stable' '</Font></html>'];
        b=b+1;
    end
    
    if i>0
        waitbar(i/to,hwait,sprintf('please wait... %d%%',round((i/to)*100)));
    end
end
res{b}=' ';
set(handles.tab_result,'Enable','inactive');
set(handles.tab_result,'String',res);
set(handles.tab_result,'Value',b);
delete(hwait);


% --------------------------------------------------------------------
function color_Callback(hObject, eventdata, handles)
% hObject    handle to color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function color_default_Callback(hObject, eventdata, handles)
% hObject    handle to color_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.color_stable_red,'Checked','off');
set(handles.color_stable_blue,'Checked','off');
set(handles.color_stable_green,'Checked','off');
set(handles.color_stable_yellow,'Checked','off');
set(handles.color_stable_gray,'Checked','off');

set(handles.color_boustable_red,'Checked','off');
set(handles.color_boustable_blue,'Checked','off');
set(handles.color_boustable_green,'Checked','off');
set(handles.color_boustable_yellow,'Checked','off');
set(handles.color_boustable_gray,'Checked','off');

set(handles.color_unstable_red,'Checked','off');
set(handles.color_unstable_blue,'Checked','off');
set(handles.color_unstable_green,'Checked','off');
set(handles.color_unstable_yellow,'Checked','off');
set(handles.color_unstable_gray,'Checked','off');


set(handles.color_stable,'UserData',2);
set(handles.color_stable_blue,'Checked','on');

set(handles.color_boustable,'UserData',3);
set(handles.color_boustable_green,'Checked','on');

set(handles.color_unstable,'UserData',1);
set(handles.color_unstable_red,'Checked','on');
% --------------------------------------------------------------------
function color_stable_Callback(hObject, eventdata, handles)
% hObject    handle to color_stable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function color_unstable_Callback(hObject, eventdata, handles)
% hObject    handle to color_unstable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function color_boustable_Callback(hObject, eventdata, handles)
% hObject    handle to color_boustable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function color_stable_red_Callback(hObject, eventdata, handles)
% hObject    handle to color_stable_red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.color_stable_red,'Checked','off');
set(handles.color_stable_blue,'Checked','off');
set(handles.color_stable_green,'Checked','off');
set(handles.color_stable_yellow,'Checked','off');
set(handles.color_stable_gray,'Checked','off');

set(handles.color_stable,'UserData',1);
set(handles.color_stable_red,'Checked','on');

% --------------------------------------------------------------------
function color_stable_blue_Callback(hObject, eventdata, handles)
% hObject    handle to color_stable_blue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.color_stable_red,'Checked','off');
set(handles.color_stable_blue,'Checked','off');
set(handles.color_stable_green,'Checked','off');
set(handles.color_stable_yellow,'Checked','off');
set(handles.color_stable_gray,'Checked','off');

set(handles.color_stable,'UserData',2);
set(handles.color_stable_blue,'Checked','on');

% --------------------------------------------------------------------
function color_stable_green_Callback(hObject, eventdata, handles)
% hObject    handle to color_stable_green (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.color_stable_red,'Checked','off');
set(handles.color_stable_blue,'Checked','off');
set(handles.color_stable_green,'Checked','off');
set(handles.color_stable_yellow,'Checked','off');
set(handles.color_stable_gray,'Checked','off');

set(handles.color_stable,'UserData',3);
set(handles.color_stable_green,'Checked','on');

% --------------------------------------------------------------------
function color_stable_yellow_Callback(hObject, eventdata, handles)
% hObject    handle to color_stable_yellow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.color_stable_red,'Checked','off');
set(handles.color_stable_blue,'Checked','off');
set(handles.color_stable_green,'Checked','off');
set(handles.color_stable_yellow,'Checked','off');
set(handles.color_stable_gray,'Checked','off');

set(handles.color_stable,'UserData',4);
set(handles.color_stable_yellow,'Checked','on');

% --------------------------------------------------------------------
function color_stable_gray_Callback(hObject, eventdata, handles)
% hObject    handle to color_stable_gray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.color_stable_red,'Checked','off');
set(handles.color_stable_blue,'Checked','off');
set(handles.color_stable_green,'Checked','off');
set(handles.color_stable_yellow,'Checked','off');
set(handles.color_stable_gray,'Checked','off');

set(handles.color_stable,'UserData',5);
set(handles.color_stable_gray,'Checked','on');


% --------------------------------------------------------------------
function color_boustable_red_Callback(hObject, eventdata, handles)
% hObject    handle to color_boustable_red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.color_boustable_red,'Checked','off');
set(handles.color_boustable_blue,'Checked','off');
set(handles.color_boustable_green,'Checked','off');
set(handles.color_boustable_yellow,'Checked','off');
set(handles.color_boustable_gray,'Checked','off');

set(handles.color_boustable,'UserData',1);
set(handles.color_boustable_red,'Checked','on');

% --------------------------------------------------------------------
function color_boustable_blue_Callback(hObject, eventdata, handles)
% hObject    handle to color_boustable_blue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.color_boustable_red,'Checked','off');
set(handles.color_boustable_blue,'Checked','off');
set(handles.color_boustable_green,'Checked','off');
set(handles.color_boustable_yellow,'Checked','off');
set(handles.color_boustable_gray,'Checked','off');

set(handles.color_boustable,'UserData',2);
set(handles.color_boustable_blue,'Checked','on');


% --------------------------------------------------------------------
function color_boustable_green_Callback(hObject, eventdata, handles)
% hObject    handle to color_boustable_green (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.color_boustable_red,'Checked','off');
set(handles.color_boustable_blue,'Checked','off');
set(handles.color_boustable_green,'Checked','off');
set(handles.color_boustable_yellow,'Checked','off');
set(handles.color_boustable_gray,'Checked','off');

set(handles.color_boustable,'UserData',3);
set(handles.color_boustable_green,'Checked','on');


% --------------------------------------------------------------------
function color_boustable_yellow_Callback(hObject, eventdata, handles)
% hObject    handle to color_boustable_yellow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.color_boustable_red,'Checked','off');
set(handles.color_boustable_blue,'Checked','off');
set(handles.color_boustable_green,'Checked','off');
set(handles.color_boustable_yellow,'Checked','off');
set(handles.color_boustable_gray,'Checked','off');

set(handles.color_boustable,'UserData',4);
set(handles.color_boustable_yellow,'Checked','on');


% --------------------------------------------------------------------
function color_boustable_gray_Callback(hObject, eventdata, handles)
% hObject    handle to color_boustable_gray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.color_boustable_red,'Checked','off');
set(handles.color_boustable_blue,'Checked','off');
set(handles.color_boustable_green,'Checked','off');
set(handles.color_boustable_yellow,'Checked','off');
set(handles.color_boustable_gray,'Checked','off');

set(handles.color_boustable,'UserData',5);
set(handles.color_boustable_gray,'Checked','on');


% --------------------------------------------------------------------
function color_unstable_red_Callback(hObject, eventdata, handles)
% hObject    handle to color_unstable_red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.color_unstable_red,'Checked','off');
set(handles.color_unstable_blue,'Checked','off');
set(handles.color_unstable_green,'Checked','off');
set(handles.color_unstable_yellow,'Checked','off');
set(handles.color_unstable_gray,'Checked','off');

set(handles.color_unstable,'UserData',1);
set(handles.color_unstable_red,'Checked','on');


% --------------------------------------------------------------------
function color_unstable_blue_Callback(hObject, eventdata, handles)
% hObject    handle to color_unstable_blue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.color_unstable_red,'Checked','off');
set(handles.color_unstable_blue,'Checked','off');
set(handles.color_unstable_green,'Checked','off');
set(handles.color_unstable_yellow,'Checked','off');
set(handles.color_unstable_gray,'Checked','off');

set(handles.color_unstable,'UserData',2);
set(handles.color_unstable_blue,'Checked','on');



% --------------------------------------------------------------------
function color_unstable_green_Callback(hObject, eventdata, handles)
% hObject    handle to color_unstable_green (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.color_unstable_red,'Checked','off');
set(handles.color_unstable_blue,'Checked','off');
set(handles.color_unstable_green,'Checked','off');
set(handles.color_unstable_yellow,'Checked','off');
set(handles.color_unstable_gray,'Checked','off');

set(handles.color_unstable,'UserData',3);
set(handles.color_unstable_green,'Checked','on');


% --------------------------------------------------------------------
function color_unstable_yellow_Callback(hObject, eventdata, handles)
% hObject    handle to color_unstable_yellow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.color_unstable_red,'Checked','off');
set(handles.color_unstable_blue,'Checked','off');
set(handles.color_unstable_green,'Checked','off');
set(handles.color_unstable_yellow,'Checked','off');
set(handles.color_unstable_gray,'Checked','off');

set(handles.color_unstable,'UserData',4);
set(handles.color_unstable_yellow,'Checked','on');


% --------------------------------------------------------------------
function color_unstable_gray_Callback(hObject, eventdata, handles)
% hObject    handle to color_unstable_gray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.color_unstable_red,'Checked','off');
set(handles.color_unstable_blue,'Checked','off');
set(handles.color_unstable_green,'Checked','off');
set(handles.color_unstable_yellow,'Checked','off');
set(handles.color_unstable_gray,'Checked','off');

set(handles.color_unstable,'UserData',5);
set(handles.color_unstable_gray,'Checked','on');


% --------------------------------------------------------------------
function help_help_Callback(hObject, eventdata, handles)
% hObject    handle to help_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hlpl1=sprintf('you can input Equation only poly(Coefficient of Equation(s)=0)');
hlpl2=sprintf('\n with variable ''k''(Gain)');
hlpl3=sprintf('\n---for example : [1 3 3 2 k]--- or [1 3*k 2 1 2*k 1]---');
hlpl4=sprintf('\ncaution : variable of Gain is lowercase(k) & not uppercase(K)');
hlpl5=sprintf('\nif input(poly equation) haven''t variable of Gain(k) then');
hlpl6=sprintf('\ngui give error message');
hlpl7=sprintf('\ndecrease interval==increase precision==long time process');
hlpt=strvcat(hlpl1,hlpl2,hlpl3,hlpl4,hlpl5,hlpl6,hlpl7);
helpdlg(hlpt,'Help:Input');


% --------------------------------------------------------------------
function help_demo_Callback(hObject, eventdata, handles)
% hObject    handle to help_demo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_demo_ex1_Callback(hObject, eventdata, handles)
% hObject    handle to help_demo_ex1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_demo_ex2_Callback(hObject, eventdata, handles)
% hObject    handle to help_demo_ex2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_demo_ex3_Callback(hObject, eventdata, handles)
% hObject    handle to help_demo_ex3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_demo_ex4_Callback(hObject, eventdata, handles)
% hObject    handle to help_demo_ex4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_demo_ex1_step1_Callback(hObject, eventdata, handles)
% hObject    handle to help_demo_ex1_step1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.input_gedit,'String','[1 3 3 2 k]');
set(handles.start_gedit,'String','-10');
set(handles.to_gedit,'String','10');
set(handles.intv_gedit,'String','1');

% --------------------------------------------------------------------
function help_demo_ex1_step2_Callback(hObject, eventdata, handles)
% hObject    handle to help_demo_ex1_step2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.input_gedit,'String','[1 3 3 2 k]');
set(handles.start_gedit,'String','0');
set(handles.to_gedit,'String','2');
set(handles.intv_gedit,'String','0.01');

% --------------------------------------------------------------------
function help_demo_ex2_step1_Callback(hObject, eventdata, handles)
% hObject    handle to help_demo_ex2_step1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.input_gedit,'String','[1 3*k 6 4 1]');
set(handles.start_gedit,'String','-10');
set(handles.to_gedit,'String','10');
set(handles.intv_gedit,'String','1');

% --------------------------------------------------------------------
function help_demo_ex2_step2_Callback(hObject, eventdata, handles)
% hObject    handle to help_demo_ex2_step2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.input_gedit,'String','[1 3*k 6 4 1]');
set(handles.start_gedit,'String','0');
set(handles.to_gedit,'String','8');
set(handles.intv_gedit,'String','0.1');


% --------------------------------------------------------------------
function help_demo_ex3_step1_Callback(hObject, eventdata, handles)
% hObject    handle to help_demo_ex3_step1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.input_gedit,'String','[1 0 5 0 k]');
set(handles.start_gedit,'String','-10');
set(handles.to_gedit,'String','10');
set(handles.intv_gedit,'String','1');

% --------------------------------------------------------------------
function help_demo_ex3_step2_Callback(hObject, eventdata, handles)
% hObject    handle to help_demo_ex3_step2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.input_gedit,'String','[1 0 5 0 k]');
set(handles.start_gedit,'String','0');
set(handles.to_gedit,'String','7');
set(handles.intv_gedit,'String','0.1');

% --------------------------------------------------------------------
function help_demo_ex4_step1_Callback(hObject, eventdata, handles)
% hObject    handle to help_demo_ex4_step1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.input_gedit,'String','[1 0 6 0 9 0 k]');
set(handles.start_gedit,'String','-10');
set(handles.to_gedit,'String','10');
set(handles.intv_gedit,'String','1');

% --------------------------------------------------------------------
function help_demo_ex4_step2_Callback(hObject, eventdata, handles)
% hObject    handle to help_demo_ex4_step2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.input_gedit,'String','[1 0 6 0 9 0 k]');
set(handles.start_gedit,'String','0');
set(handles.to_gedit,'String','4');
set(handles.intv_gedit,'String','0.1');


% --- Executes on button press in close_gain.
function close_gain_Callback(hObject, eventdata, handles)
% hObject    handle to close_gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.gain)


% --------------------------------------------------------------------
function cgmenuin_Callback(hObject, eventdata, handles)
% hObject    handle to cgmenuin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function cgmenuin_copy_Callback(hObject, eventdata, handles)
% hObject    handle to cgmenuin_copy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clipboard('copy',get(handles.input_gedit,'String'));

% --------------------------------------------------------------------
function cgmenuin_paste_Callback(hObject, eventdata, handles)
% hObject    handle to cgmenuin_paste (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.input_gedit,'String',clipboard('paste'));


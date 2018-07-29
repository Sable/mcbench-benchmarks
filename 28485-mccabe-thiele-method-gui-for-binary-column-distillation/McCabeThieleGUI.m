function varargout = McCabeThieleGUI(varargin)
% MCCABETHIELEGUI M-file for McCabeThieleGUI.fig
%      MCCABETHIELEGUI, by itself, creates a new MCCABETHIELEGUI or raises the existing
%      singleton*.
%
%      H = MCCABETHIELEGUI returns the handle to a new MCCABETHIELEGUI or the handle to
%      the existing singleton*.
%
%      MCCABETHIELEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MCCABETHIELEGUI.M with the given input arguments.
%
%      MCCABETHIELEGUI('Property','Value',...) creates a new MCCABETHIELEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before McCabeThieleGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to McCabeThieleGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Last Modified by GUIDE v2.5 06-Jul-2010 12:55:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @McCabeThieleGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @McCabeThieleGUI_OutputFcn, ...
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


% --- Executes just before McCabeThieleGUI is made visible.
function McCabeThieleGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to McCabeThieleGUI (see VARARGIN)

set(handles.mixturepanel_buttongroup,'SelectionChangeFcn',@mixturepanel_buttongroup_SelectionChangeFcn);

% Choose default command line output for McCabeThieleGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes McCabeThieleGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = McCabeThieleGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%% Mixture Panel

function mixturepanel_buttongroup_SelectionChangeFcn(hObject, eventdata)
 

handles = guidata(hObject); 
 
switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
    case 'methanolwater_radiobutton'
        %equilibrium data
        xMW = '[0    0.0200    0.0400    0.0600    0.0800    0.1000    0.1500    0.2000    0.3000    0.4000    0.5000    0.6000    0.7000    0.8000    0.9000    0.9500    1.0000]';
        yMW = '[0    0.1340    0.2300    0.3040    0.3650    0.4180    0.5170    0.5790    0.6650    0.7290    0.7790    0.8250    0.8700    0.9150    0.9580    0.9790    1.0000]';
        set(handles.userdefined_input,'Enable','Off')
        set(handles.userdefined_input2,'Enable','Off')
        set(handles.userdefined_input,'String',xMW)
        set(handles.userdefined_input2,'String',yMW)
        %hold off        
        %methanol-water mixture
        %polynomial regression and plot of equilibrium data
        %p = polyfit(xMW,yMW,6);
        %x = 0:.1:100;
        %y = polyval(p,x);
        %plot(xMW,yMW)
        %hold on
        %axis([0 1 0 1])
        %plot(x,y)
        %plot(x,x)
        %xlabel('Liquid Mole Fraction of Methanol')
        %ylabel('Vapor Mole Fraction of Methanol')
        %title('McCabe-Thiele Diagram for Methanol-Water')
 
    case 'ethanolwater_radiobutton'
        %equilibrium data
        xEW = '[0    0.0190    0.0721    0.0966    0.1238    0.1661    0.2337    0.2608    0.3273    0.3965    0.5198    0.5732    0.6763    0.7472    0.8943    1.0000]';
        yEW = '[0    0.1700    0.3891    0.4375    0.4704    0.5089    0.5445    0.5580    0.5826    0.6122    0.6599    0.6841    0.7385    0.7815    0.8943    1.0000]';
        xeq = num2str(xEW);
        yeq = num2str(yEW);
        set(handles.userdefined_input,'Enable','Off')
        set(handles.userdefined_input2,'Enable','Off')
        set(handles.userdefined_input,'String',xeq)
        set(handles.userdefined_input2,'String',yeq)
        %hold off
        %ethanol-water mixture
        %polynomial regression and plot of equilibrium data
        %p = polyfit(xEW,yEW,8);
        %x = 0:.1:100;
        %y = polyval(p,x);
        %plot(x,y)
        %plot(xEW,yEW)
        %hold on
        %axis([0 1 0 1])
        %plot(x,x)
        %xlabel('Liquid Mole Fraction of Ethanol')
        %ylabel('Vapor Mole Fraction of Ethanol')
        %title('McCabe-Thiele Diagram for Ethanol-Water')
 
    case 'acetonethanol_radiobutton'
        %equilibrium data
        xAE = '[0    0.1000    0.1500    0.2000    0.2500    0.3000    0.3500    0.4000    0.5000    0.6000    0.7000    0.8000    0.9000    1.0000]';
        yAE = '[0    0.2620    0.3480    0.4170    0.4780    0.5240    0.5660    0.6050    0.6740    0.7390    0.8020    0.8650    0.9290    1.0000]';       
        set(handles.userdefined_input,'Enable','Off')
        set(handles.userdefined_input2,'Enable','Off')
        set(handles.userdefined_input,'String',xAE)
        set(handles.userdefined_input2,'String',yAE)
        %hold off
        %acetone-ethanol mixture
        %polynomial regression and plot of equilibrium data
        %p = polyfit(xAE,yAE,6);
        %x = 0:.1:100;
        %y = polyval(p,x);
        %plot(xAE,yAE)
        %hold on
        %plot(x,y)
        %plot(x,x)
        %axis([0 1 0 1])
        %xlabel('Liquid Mole Fraction of Acetone')
        %ylabel('Vapor Mole Fraction of Acetone')
        %title('McCabe-Thiele Diagram for Acetone-Ethanol')      
        
    case 'userdefined_radiobutton'
        hold off
       %User Defined Input
        choice = menu('Input Equilibrium Data as a Row Vector or as a Relative Volatility (alpha)','Vector','Alpha');
        switch choice
            case 1
                set(handles.userdefined_input,'Enable','On')
                set(handles.userdefined_input2,'Enable','On')
                set(handles.userdefined_input,'String','[Liquid Mole Fractions]')
                set(handles.userdefined_input2,'String','[Vapor Mole Fractions]')
                warndlg('Enlose your vectors with brackets and single quotes', 'Warning');
                %disp('You must enter your own equilibrium data in vector form ')
                %MVC = input('Enter the name of the more volatile component ','s');
                %LVC = input('Enter the name of the less volatile component ','s');
                %xU = input('Enter liquid mole fraction data as a row vector (use brackets) \n');
                %a = length(xU);
                %fprintf('You have entered %1.0f "x" data points, you must enter an equal number of y data points \n',a)
                %yU = input('Enter vapor phase mole fraction data as a row vector (use brackets) \n');
                %b = length(yU);
                %if a == b
                    %plot(xU,yU,'o')
                    %hold on
                    %p = polyfit(xU,yU,6);
                    %x = 0:.1:100;
                    %y = polyval(p,x);
                    %plot(x,y)
                    %plot(x,x)
                    %x_label = sprintf('Liquid Phase Mole Fraction of %s',MVC);
                    %y_label = sprintf('Vapor Phase Mole Fraction of %s',MVC);
                    %t_itle = sprintf('McCabe-Thiele Diagram for %s-%s',MVC,LVC);
                    %xlabel(x_label)
                    %ylabel(y_label)
                    %title(t_itle)                    
                %else
                    %disp('Equilibrium data does not match, vectors must be equal lengths')
                %end
            case 2 
                set(handles.userdefined_input,'Enable','On')
                set(handles.userdefined_input2,'String','[]')
                set(handles.userdefined_input,'String','<Enter Relative Volatility>')             
        end
end
%updates the handles structure
guidata(hObject, handles);
function userdefined_input_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function userdefined_input_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function userdefined_input2_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function userdefined_input2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Column Pressure Checkbox

%Column Pressure Input
function pressureinput_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of pressureinput as text
%        str2double(get(hObject,'String')) returns contents of pressureinput as a double

% --- Executes during object creation, after setting all properties.
function pressureinput_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function columnpressure_checkbox_Callback(hObject, eventdata, handles)



checkbox1_Status = get(handles.columnpressure_checkbox,'Value');
if checkbox1_Status == 0
    set(handles.pressureinput,'String',' ')
else
    set(handles.pressureinput,'Enable','On')
    set(handles.pressureinput,'String','<Enter Column Pressure>')
end


%% Feed
%% Feed Flow Rate
%Feed Flow Rate Input
function feedflowinput_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function feedflowinput_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    end

%Feed Flow Rate Checkbox
function feedflowrate_checkbox_Callback(hObject, eventdata, handles)

checkbox2_Status = get(handles.feedflowrate_checkbox,'Value');

if checkbox2_Status == 0
    set(handles.feedflowinput,'Enable','Off')
    set(handles.feedflowinput,'String',' ');
else 
    set(handles.feedflowinput,'Enable','On')
    set(handles.feedflowinput,'String','<Enter Feed Flow Rate>')
end


%% Feed Composition of the Volatile Component Input
function feedcompvolatile_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function feedcompvolatile_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Feed Composition of the Less Volatile Component Input
function feedcomplessvolatile_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function feedcomplessvolatile_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Feed Composition Checkbox
function feedcomposition_checkbox_Callback(hObject, eventdata, handles)

checkbox3_Status = get(handles.feedcomposition_checkbox,'Value');

if checkbox3_Status == 0
    set(handles.feedcompvolatile,'Enable','Off')
    set(handles.feedcomplessvolatile,'Enable','Off')
    set(handles.feedcompvolatile,'String',' ')
    set(handles.feedcomplessvolatile,'String',' ')
else
    set(handles.feedcompvolatile,'Enable','On')
    set(handles.feedcomplessvolatile,'Enable','On')
    set(handles.feedcompvolatile,'String','<Volatile>')
    set(handles.feedcomplessvolatile,'String','<Non-Volatile>')
end

%% Feed Enthalpy 
%Feed Enthalpy Input
function feedenthalpyinput_Callback(hObject, eventdata, handles)
function feedenthalpyinput_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Feed Enthalpy Checkbox
function feedenthalpy_Callback(hObject, eventdata, handles)

checkbox4_Status = get(handles.feedenthalpy,'Value');

if checkbox4_Status == 0
    set(handles.feedenthalpyinput,'Enable','Off')
    set(handles.feedenthalpyinput,'String',' ')
else
    set(handles.feedenthalpyinput,'Enable','On')
    set(handles.feedenthalpyinput,'String','<Feed Enthalpy>')
end



%Reboiler Duty Input
function reboilerdutyinput_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function reboilerdutyinput_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Reboiler Duty Checkbox
function reboilerdutycheckbox_Callback(hObject, eventdata, handles)

checkbox7_Status = get(handles.reboilerdutycheckbox,'Value');
if checkbox7_Status == 0
    set(handles.reboilerdutyinput,'Enable','Off')
    set(handles.reboilerdutyinput,'String',' ')
else
    set(handles.reboilerdutyinput,'Enable','On')
    set(handles.reboilerdutyinput,'String','<Reboiler Duty>')
end




%% Distillate composition

%Distillate Composition, Volatile Component Input
function distcompvolatile_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function distcompvolatile_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Distillate Composition of the less Volatile Component Input
function distcomplessvolatile_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function distcomplessvolatile_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Distillate composition checkbox
function distillatecomposition_checkbox_Callback(hObject, eventdata, handles)

checkbox9_Status = get(handles.distillatecomposition_checkbox,'Value');

if checkbox9_Status == 0
    set(handles.distcompvolatile,'Enable','Off')
    set(handles.distcomplessvolatile,'Enable','Off')
    set(handles.distcompvolatile,'String',' ')
    set(handles.distcomplessvolatile,'String',' ')
else
    set(handles.distcompvolatile,'Enable','On')
    set(handles.distcomplessvolatile,'Enable','On')
    set(handles.distcompvolatile,'String','<Volatile>')
    set(handles.distcomplessvolatile,'String','<Non-Volatile>')
end


%% Reflux Ratio
%Reflux Ratio Input
function refluxratio_input_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function refluxratio_input_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function minimumrefluxinput_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function minimumrefluxinput_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Reflux Ratio Checkbox
function refluxratio_checkbox_Callback(hObject, eventdata, handles)

checkbox11_Status = get(handles.refluxratio_checkbox,'Value');

if checkbox11_Status == 0 
    set(handles.refluxratio_input,'Enable','Off')
    set(handles.refluxratio_input,'String',' ')
    set(handles.minimumrefluxinput,'Enable','Off')
    set(handles.minimumrefluxinput,'String',' ')
elseif checkbox11_Status == 1
    choice = menu('Are you specifying minimum reflux or actual reflux','Actual','Minumum');
    switch choice
        case 1
            set(handles.refluxratio_input,'Enable','On')
            set(handles.refluxratio_input,'String','<Reflux Ratio>')
            set(handles.minimumrefluxinput,'Enable','Off')
            set(handles.minimumrefluxinput,'String',' ')
        case 2
            Rmin = str2double(get(handles.minimumrefluxinput,'String'));
            if isnan(Rmin) == 1
                set(handles.refluxratio_input,'Enable','On')
                set(handles.refluxratio_input,'String','<Operating Factor>')
                set(handles.minimumrefluxinput,'Enable','On')
                set(handles.minimumrefluxinput,'String','<Minumum Reflux>')
            elseif isnan(Rmin) == 0
                set(handles.refluxratio_input,'Enable','On')
                set(handles.refluxratio_input,'String','<Operating Factor>')
                set(handles.minimumrefluxinput,'Enable','Off')
            end
    end

end

%% Bottoms Composition
%Bottoms Composition of the Less Volatile Component Input
function botcomplessvolatile_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function botcomplessvolatile_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Bottoms Composition of the Volatile Component Input
function botcompvolatile_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function botcompvolatile_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Bottoms Composition Checkbox
function bottomscomposition_checkbox_Callback(hObject, eventdata, handles)

checkbox10_Status = get(handles.bottomscomposition_checkbox,'Value');

if checkbox10_Status == 0 
    set(handles.botcomplessvolatile,'Enable','Off')
    set(handles.botcompvolatile,'Enable','Off')
    set(handles.botcomplessvolatile,'String',' ')
    set(handles.botcompvolatile,'String',' ')
elseif checkbox10_Status == 1
    set(handles.botcomplessvolatile,'Enable','On')
    set(handles.botcompvolatile,'Enable','On')
    set(handles.botcompvolatile,'String','<Volatile>')
    set(handles.botcomplessvolatile,'String','<Non-Volatile>')
end

%% Optimum Feed Plate 
%Optimum Feed Plate Checkbox
function optimumfeedplate_Callback(hObject, eventdata, handles)

%% Distillate Flow Rate
%Distillate Flow Rate Input
function distillateflowrateinput_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function distillateflowrateinput_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Distillate Flow Rate Checkbox
function distillateflowrate_checkbox_Callback(hObject, eventdata, handles)
checkbox14_Status = get(handles.distillateflowrate_checkbox,'Value');

if checkbox14_Status == 0
    set(handles.distillateflowrateinput,'Enable','Off')
    set(handles.distillateflowrateinput,'String',' ')
else
    set(handles.distillateflowrateinput,'Enable','On')
    set(handles.distillateflowrateinput,'String','<Enter Distillate Flow Rate>')
end

%% Fractional Recoveries

%Fractional Recovery of the Volatile Component in the Distillate Input
function fracrecoveryvolatile_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function fracrecoveryvolatile_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Fractional Recovery of the Less Volatile Component in the Bottoms Input
function fracrecoverylessvolatile_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function fracrecoverylessvolatile_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Fractional Recoveries Checkbox
function fractionalrecoveries_checkbox_Callback(hObject, eventdata, handles)

checkbox12_Status = get(handles.fractionalrecoveries_checkbox,'Value');

if checkbox12_Status == 0 
    set(handles.fracrecoveryvolatile,'Enable','Off')
    set(handles.fracrecoverylessvolatile,'Enable','Off')
    set(handles.fracrecoveryvolatile,'String','0')
    set(handles.fracrecoverylessvolatile,'String','0')
else
    set(handles.fracrecoveryvolatile,'Enable','On')
    set(handles.fracrecoverylessvolatile,'Enable','On')
    set(handles.fracrecoveryvolatile,'String','<Volatile>')
    set(handles.fracrecoverylessvolatile,'String','<Non-Volatile>')
end

%% Bottoms Flow Rate 
function bottomsflowrateinput_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function bottomsflowrateinput_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Bottoms Flow Rate Checkbox
function bottomsflowrate_checkbox_Callback(hObject, eventdata, handles)
checkbox15_Status = get(handles.bottomsflowrate_checkbox,'Value');
if checkbox15_Status == 0
    set(handles.bottomsflowrateinput,'Enable','Off')
    set(handles.bottomsflowrateinput,'String',' ')
else
    set(handles.bottomsflowrateinput,'Enable','On')
    set(handles.bottomsflowrateinput,'String','<Enter Bottoms Flow Rate>')
end


%% Boilup Ratio Checkbox

%Boilup Ratio Input
function boilupratioinput_Callback(hObject, eventdata, handles)

function boilupratioinput_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function boilupratio_checkbox_Callback(hObject, eventdata, handles)

checkbox15_Status = get(handles.boilupratio_checkbox,'Value');

if checkbox15_Status == 0 
    set(handles.boilupratioinput,'Enable','Off')
    set(handles.boilupratioinput,'String',' ')
elseif checkbox15_Status == 1
    set(handles.boilupratioinput,'Enable','On')
    set(handles.boilupratioinput,'String','<Enter Boilup Ratio>')
elseif checkbox15_Status == 0 && checkbox11_Status == 1 && checkbox6_Status == 1 && checkbox9_Status == 1
    set(handles.boilupratioinput,'Enable','Off')
    set(handles.boilupratioinput,'String',' ')
    xi = (-(Q-1)*(1-R/(R+1))*xd-zf)/((Q-1)*R/(R+1)-Q);
    yi = (zf+xd*Q/R)/(1+Q/R);
    xs = linspace(xb,xi);
    ys = linspace(xb,yi);
    plot(xs,ys)
    hold on
end


%% Feed Quality

%Feed Quality Input
function feedqualityinput_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function feedqualityinput_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Feed Quality Checkbox
function feedquality_checkbox_Callback(hObject, eventdata, handles)

checkbox6_Status = get(handles.feedquality_checkbox,'Value');

if checkbox6_Status == 0 
    set(handles.feedqualityinput,'Enable','Off')
    set(handles.feedqualityinput,'String',' ')
else
    set(handles.feedqualityinput,'Enable','On')
    set(handles.feedqualityinput,'String','<Enter Feed Quality>')
end


%Condenser Duty Input
function condenserdutyinput_Callback(hObject, eventdata, handles)
function condenserdutyinput_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Condenser Duty Checkbox
function condenserdutycheckbox_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function condenserdutycheckbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

checkbox5_Status = get(handles.condenserdutycheckbox,'Value');
if checkbox5_Status == 0 
    set(handles.condenserdutyinput,'Enable','Off')
    set(handles.condenserdutyinput,'String',' ')
else
    set(handles.condenserdutyinput,'Enable','On')
    set(handles.condenserdutyinput,'String','<Enter Condenser Duty>')
end


%Reflux Enthalpy Input
function refluxenthalpyinput_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function refluxenthalpyinput_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%Reflux Enthalpy Checkbox
function refluxenthalpy_Callback(hObject, eventdata, handles)

checkbox8_Status = get(handles.refluxenthalpy,'Value');
if checkbox8_Status == 0
    set(handles.refluxenthalpyinput,'Enable','Off')
    set(handles.refluxenthalpyinput,'String',' ')
else
    set(handles.refluxenthalpyinput,'Enable','On')
    set(handles.refluxenthalpyinput,'String','<Reflux Enthalpy>')
end

%Boilup Enthalpy Input
function boilupenthalpyinput_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function boilupenthalpyinput_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Boilup Enthalpy Checkbox
function boilupenthalpycheckbox_Callback(hObject, eventdata, handles)
checkbox20_Status = get(handles.boilupenthalpycheckbox,'Value');
if checkbox20_Status == 0
    set(handles.boilupenthalpyinput,'Enable','Off')
    set(handles.boilupenthalpyinput,'String',' ')
else
    set(handles.boilupenthalpyinput,'Enable','On')
    set(handles.boilupenthalpyinput,'String','<Boilup Enthalpy>')
end

%Distillate Enthalpy 
function distillateenthalpyinput_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function distillateenthalpyinput_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in distillateenthalpycheckbox.
function distillateenthalpycheckbox_Callback(hObject, eventdata, handles)
checkbox21_Status = get(handles.distillateenthalpycheckbox,'Value');
if checkbox21_Status == 0
    set(handles.distillateenthalpyinput,'Enable','Off')
    set(handles.distillateenthalpyinput,'String',' ')
else
    set(handles.distillateenthalpyinput,'Enable','On')
    set(handles.distillateenthalpyinput,'String','<Distillate Enthalpy>')
end

%Bottoms enthalpy
function bottomsenthalpyinput_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function bottomsenthalpyinput_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in bottomsenthalpycheckbox.
function bottomsenthalpycheckbox_Callback(hObject, eventdata, handles)
checkbox22_Status = get(handles.bottomsenthalpycheckbox,'Value');
if checkbox22_Status == 0
    set(handles.bottomsenthalpyinput,'Enable','Off')
    set(handles.bottomsenthalpyinput,'String',' ')
else
    set(handles.bottomsenthalpyinput,'Enable','On')
    set(handles.bottomsenthalpyinput,'String','<Bottoms Enthalpy>')
end


% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, eventdata, handles)

% Get Values

Alpha = str2double(get(handles.userdefined_input,'String'));

P = str2double(get(handles.pressureinput,'String'));
F = str2double(get(handles.feedflowinput,'String'));
zf = str2double(get(handles.feedcompvolatile,'String'));
zfnv = str2double(get(handles.feedcomplessvolatile,'String'));
xd = str2double(get(handles.distcompvolatile,'String'));
xdnv = str2double(get(handles.distcomplessvolatile,'String'));
xb = str2double(get(handles.botcompvolatile,'String'));
xbnv = str2double(get(handles.botcomplessvolatile,'String'));
D = str2double(get(handles.distillateflowrateinput,'String'));
fv = str2double(get(handles.fracrecoveryvolatile,'String'));
fnv = str2double(get(handles.fracrecoverylessvolatile,'String'));
B = str2double(get(handles.bottomsflowrateinput,'String'));
S = str2double(get(handles.boilupratioinput,'String'));
Q = str2double(get(handles.feedqualityinput,'String'));
R = str2double(get(handles.refluxratio_input,'String'));
Rmin = str2double(get(handles.minimumrefluxinput,'String'));
hf = str2double(get(handles.feedenthalpyinput,'String'));
hD = str2double(get(handles.refluxenthalpyinput,'String'));
hB = str2double(get(handles.boilupenthalpyinput,'String'));
Qc = str2double(get(handles.condenserdutyinput,'String'));
Qr = str2double(get(handles.reboilerdutyinput,'String'));
HD = str2double(get(handles.distillateenthalpyinput,'String'));
HB = str2double(get(handles.bottomsenthalpyinput,'String'));

%xie = 1/2*(-Q+zf*Alpha+Q*Alpha-zf-Alpha+(2*Q*Alpha^2*zf+Q^2-2*Q*zf+2*zf*Alpha-2*zf^2*Alpha+zf^2*Alpha^2-2*zf*Alpha^2+zf^2+2*Q*Alpha-2*Q^2*Alpha+Alpha^2+Q^2*Alpha^2-2*Q*Alpha^2)^(1/2))/Q/(-1+Alpha);
%yie = xie*Alpha/(1-xie+xie*Alpha);
xi = (-(Q-1)*(1-R/(R+1))*xd-zf)/((Q-1)*R/(R+1)-Q);
yi = (zf+xd*Q/R)/(1+Q/R);

%Error Tests

%Feed Quality & Feed Line
checkbox6_Status = get(handles.feedquality_checkbox,'Value');
if checkbox6_Status == 0 
    errordlg('Feed quality must be specified')
    return
elseif checkbox6_Status == 1 && isnan(Q) == 1
    errordlg('Feed quality must be specified')
    return
elseif checkbox6_Status == 1 && isnan(Q) == 0
    ye = 0:.001:1;
    if Q > -inf && Q <1
            xf = 0:.001:1;
    elseif Q > 1
            xf = zf:.001:1;
    end 
    if Q ~= 1
        yf = yfeed(xf,Q,zf);
    elseif Q == 1
        yf = 0:.001:1;
        xf = zf*ones(length(yf));
    end 
end

%Equilibrium Data
if any(isnan(Alpha)) == 1
    xeq = str2num(get(handles.userdefined_input,'String'));
    yeq = str2num(get(handles.userdefined_input2,'String'));
    %Error Test on Equilibrium Vector Length
    if length(yeq) ~= length(xeq) && isempty(yeq) == 1 && length(xeq) > 1
        errordlg('Equilibrium data does not match')
        return
    elseif length(yeq) == length(xeq) && length(xeq) < 10
        errordlg('Too few data points will give a poor equilibrium curve')
    else
        k = 1; %k is a constant, metric for stepping off equilibrium stages
    end
elseif isnan(Alpha) == 0 && length(Alpha) == 1
    yeq = [];
    if Alpha <= 1
        errordlg('Relative volatility must be greater than 1')
        return
    elseif Alpha > 1
        k = 2;
    end
end
if k == 1
    xx = 0:.001:1;
    yy = spline(xeq,yeq,xx);
    if Q == 0
        xx = .001:.001:1.001;
        yy = spline(xeq,yeq,xx);
        diffe = abs(yy-zf);
        [a b] = min(diffe) ;      
        xie = xx(b);
        yie = zf;
    elseif Q == 1
        yie = spline(xeq,yeq,zf);
        xie = zf;
    elseif Q~=0 && Q~=1 
        diffe = abs(yy-yf);
        [a b] = min(diffe);
        xie = xx(b);
        yie = yy(b);
    end
elseif k == 2 
    xie = 1/2*(-Q+zf*Alpha+Q*Alpha-zf-Alpha+(2*Q*Alpha^2*zf+Q^2-2*Q*zf+2*zf*Alpha-2*zf^2*Alpha+zf^2*Alpha^2-2*zf*Alpha^2+zf^2+2*Q*Alpha-2*Q^2*Alpha+Alpha^2+Q^2*Alpha^2-2*Q*Alpha^2)^(1/2))/Q/(-1+Alpha);
    yie = xie*Alpha/(1-xie+xie*Alpha);
end

%Overall Mass Balance
checkbox2_Status = get(handles.feedflowrate_checkbox,'Value');
checkbox17_Status = get(handles.distillateflowrate_checkbox,'Value');
checkbox18_Status = get(handles.bottomsflowrate_checkbox,'Value');
l = [checkbox2_Status checkbox17_Status checkbox18_Status]; %l is a status vector for mass flow streams
if any([F D B]< 0) 
    errordlg('Mass flow rates must be greater than zero')
    return
elseif sum(l) == 3 && D + B ~= F
    errordlg('The mass balance is incorrect')
    return 
elseif sum(l) == 2
    if isnan(F) == 0 
        if isnan(B) == 0
            D = F - B;
            Ds = num2str(D);
            set(handles.distillateflowrateinput,'String',Ds)
        elseif isnan(D) == 0
            B = F - D;
            Bs = num2str(B);
            set(handles.bottomsflowrateinput,'String',Bs)
        end
    elseif isnan(F) == 1
        F = B + D;
        Fs = num2str(F);
        set(handles.feedflowinput,'String',Fs)
    end
end

%Feed Composition
checkbox3_Status = get(handles.feedcomposition_checkbox,'Value');
if checkbox3_Status == 1
    if isnan(zf) == 1 && isnan(zfnv) == 1
        errordlg('Feed composition must be a real number')
        return
    elseif isnan(zf) == 0 && isnan(zfnv) == 1
        zfnv = 1 - zf;
        zfnv = num2str(zfnv);
        set(handles.feedcomplessvolatile,'String',zfnv)
    elseif isnan(zf) == 1 && isnan(zfnv) == 0
        zf = 1 - zfnv;
        zf = num2str(zf);
        set(handles.feedcompvolatile,'String',zf)
    elseif isnan(zf) == 0 && isnan(zfnv) == 0 
        if zf + zfnv ~= 1
            errordlg('Mole fractions must add up to 1')
            return          
        elseif zf < 0 || zf > 1 || zfnv < 0 || zfnv > 1
            errordlg('Mole fractions must be between 0 and 1')
            return
        end
    end
end

%Distillate Composition
checkbox9_Status = get(handles.distillatecomposition_checkbox,'Value');
if checkbox9_Status == 1 
    if isnan(xd) && isnan(xdnv)
        errordlg('Distillate composition must be a real number')
        return
    elseif isnan(xd) == 0 && isnan(xdnv) == 1
        xdnv = 1 - xd;
        xdnvs = num2str(xdnv);
        set(handles.distcomplessvolatile,'String',xdnvs)
    elseif isnan(xd) == 1 && isnan(xdnv) == 0
        xd = 1 - xdnv;
        xds = num2str(xd);
        set(handles.distcompvolatile,'String',xds)
    elseif isnan(xd) == 0 && isnan(xdnv) == 0 
        if xd + xdnv ~= 1
            errordlg('Mole fractions must add up to 1')
            return            
        elseif xd < 0 || xd > 1 || xdnv < 0 || xdnv > 1
            errordlg('Mole fractions must be between 0 and 1')
            return
        end
    end        
end

%Bottoms Composition
checkbox10_Status = get(handles.bottomscomposition_checkbox,'Value');
if checkbox10_Status == 1 
    if isnan(xb) == 1 && isnan(xbnv) == 1
        errordlg('Bottoms composition must be a real number')
        return
    elseif isnan(xb) == 0 && isnan(xbnv) == 1
        xbnv = 1 - xb;
        xbnvs = num2str(xbnv);
        set(handles.botcomplessvolatile,'String',xbnvs)
    elseif isnan(xb) == 1 && isnan(xbnv) == 0
        xb = 1 - xbnv;
        xbs = num2str(xb);
        set(handles.botcompvolatile,'String',xbs)
    elseif isnan(xb) == 0 && isnan(xbnv) == 0 
        if xb + xbnv ~= 1
            errordlg('Mole fractions must add up to 1')
            return
        elseif xb < 0 || xb > 1 || xbnv < 0 || xbnv > 1
            errordlg('Mole fractions must be between 0 and 1')
            return
        end
    end
end


%Test to see if the mass balance has converged
%lk is a status vector for feed stream compositions
lk = [checkbox3_Status checkbox9_Status checkbox10_Status];
if sum(lk) == 3
    if sum(l) == 1
        if isnan(F) == 0
            if isnan(D) == 1 && isnan(B) == 1
                D = F*(zf-xb)/(xd-xb);
                Ds = num2str(D);
                set(handles.distillateflowrateinput,'String',Ds)
                B = F - D;
                Bs = num2str(B);
                set(handles.bottomsflowrateinput,'String',Bs)
                fv = D*xd/F/zf;
                fvs = num2str(fv);
                set(handles.fracrecoveryvolatile,'String',fvs)
                fnv = B*(1-xb)/F/(1-zf);
                fnvs = num2str(fnv);
                set(handles.fracrecoverylessvolatile,'String',fnvs)
            end
        end
    elseif sum(l) == 2
        if isnan(F) == 0
            if isnan(D) == 0
                Dk = F*(zf-xb)/(xd-xb);
                Bk = F - Dk;
                if D ~= Dk
                    Ds = num2str(Dk);
                    set(handles.distillateflowrateinput,'String',Ds)
                    Bk = F-Dk;
                    Bs = num2str(Bk);
                    set(handles.bottomsflowrateinput,'String',Bs)
                    fv = D*xd/F/zf;
                    fvs = num2str(fv);
                    set(handles.fracrecoveryvolatile,'String',fvs)
                    fnv = B*(1-xb)/F/(1-zf);
                    fnvs = num2str(fnv);
                    set(handles.fracrecoverylessvolatile,'String',fnvs)
                end
                if B ~= Bk
                    Bs = num2str(Bk);
                    set(handles.bottomsflowrateinput,'String',Bs)
                    Dk = F-Bk;
                    Ds = num2str(Dk);
                    set(handles.distillateflowrateinput,'String',Ds)
                    fv = D*xd/F/zf;
                    fvs = num2str(fv);
                    set(handles.fracrecoveryvolatile,'String',fvs)
                    fnv = B*(1-xb)/F/(1-zf);
                    fnvs = num2str(fnv);
                    set(handles.fracrecoverylessvolatile,'String',fnvs)
                end
            end
        end
    end
elseif sum(lk) == 1 && isnan(zf) == 0
checkbox12_Status = get(handles.fractionalrecoveries_checkbox,'Value');
    if sum(l) == 2 || sum(l) == 3
        %Fractional Recoveries
        if  checkbox12_Status == 1
            if any(isnan([fv fnv])) == 1
                errordlg('Fractional recovery must be a real number')
                return
            elseif any([fv fnv]>=1) || any([fv fnv]<0)
                errordlg('Fractional recovery must be between 0 and 1')
                return
            elseif any([fv fnv]==1)
                errordlg('100 percent recovery is physically impossible, try a different value')
                return
            else
                xd = fv/D*F*zf; 
                xds = num2str(xd);
                set(handles.distcompvolatile,'String',xds)
                xb = 1-fnv/(F-D)*F*(1-zf);
                xbs = num2str(xb);
                set(handles.botcompvolatile,'String',xbs)
            end
        end
    elseif checkbox12_Status == 0
        errordlg('The system is underspecified')
        return
    end
end

%Fractional Recoveries
checkbox12_Status = get(handles.fractionalrecoveries_checkbox,'Value');
if checkbox12_Status == 0
    if all(isnan([F D B zf xd xb])) == 0
        fv = D*xd/F/zf;
        fvs = num2str(fv);
        set(handles.fracrecoveryvolatile,'String',fvs)
        fnv = B*(1-xb)/F/(1-zf);
        fnvs = num2str(fnv);
        set(handles.fracrecoverylessvolatile,'String',fnvs)
    end
end



%Feed Enthalpy
checkbox4_Status = get(handles.feedenthalpy,'Value');
if checkbox4_Status == 1 && isnan(hf) == 1
    errordlg('Feed enthalpy must be a real number')
    return
end

%Condenser Duty
checkbox5_Status = get(handles.condenserdutycheckbox,'Value');
if checkbox5_Status == 1 && isnan(Qc) == 1
    errordlg('Condenser duty must be a real number')
    return
end



%Reboiler Duty
checkbox7_Status = get(handles.reboilerdutycheckbox,'Value');
if checkbox7_Status == 1 && isnan(Qr) == 1
    errordlg('Reboiler duty must be a real number')
    return
end

%Reflux Enthalpy
checkbox8_Status = get(handles.refluxenthalpy,'Value');
if checkbox8_Status == 1 && isnan(hD) == 1
    errordlg('Reflux enthalpy must be a real number')
    return
end

%Reflux Ratio
checkbox11_Status = get(handles.refluxratio_checkbox,'Value');
if checkbox11_Status == 1 
    if isnan(R) == 1 && isnan(Rmin) == 1
        errordlg('Reflux ratio must be a real number')
        return
    elseif R < 0
        errordlg('Reflux ratio must be greater than 0')
        return
    elseif Rmin < 0
        errordlg('Minumum reflux must be greater than 0')
        return
    elseif isnan(Rmin) == 0 && isnan(R) == 1
        errordlg('You must specify an operating factor')
        return
    end
elseif checkbox11_Status == 0
    if isnan(xd) == 1 && isnan(Q) == 1
        errordlg('You must specify feed quality and distillate composition')
        return
    elseif isnan(xd) == 0 && isnan(Q) == 1
        errordlg('You must specify feed quality')
        return
    elseif isnan(xd) == 1 && isnan(Q) == 0
        errordlg('You must specify distillate composition')
        return
    elseif isnan(Rmin) == 1 && isnan(Q) == 0 && isnan(xd) == 0 
        if isnan(Alpha) == 0
            if isnan(R) == 1
                Emin = (xd-yie)/(xd-xie);
                Rmin = Emin/(1-Emin);
                Rmins = num2str(Rmin);
                set(handles.minimumrefluxinput,'String',Rmins)
                errordlg('Minimum reflux has been calculated and returned but you must specify an operating factor')
                return
            elseif isnan(R) == 0
                Emin = (xd-yie)/(xd-xie);
                Rmin = Emin/(1-Emin);
                Rmins = num2str(Rmin);
                R = R*Rmin;
                Rs = num2str(R);
                set(handles.minimumrefluxinput,'String',Rmins)
                set(handles.refluxratio_input,'String',Rs)
            elseif isnan(Rmin) == 0 && isnan(R) == 1
                errordlg('You must specify an operating factor')
                return
            end
        elseif isnan(Alpha) == 1 && k ==1
            if isnan(R) == 1
                Emin = (xd-yie)/(xd-xie);
                Rmin = Emin/(1-Emin);
                Rmins = num2str(Rmin);
                set(handles.minimumrefluxinput,'String',Rmins)
                errordlg('Minimum reflux has been calculated and returned but you must specify an operating factor')
                return
            elseif isnan(R) == 0
                Emin = (xd-yie)/(xd-xie);
                Rmin = Emin/(1-Emin);
                Rmins = num2str(Rmin);
                R = R*Rmin;
                Rs = num2str(R);
                set(handles.minimumrefluxinput,'String',Rmins)
                set(handles.refluxratio_input,'String',Rs)
            elseif isnan(Rmin) == 0 && isnan(R) == 1
                errordlg('You must specify an operating factor')
                return
            end
        end
    end
end

%Optimum Feed Plate
checkbox12_Status = get(handles.optimumfeedplate,'Value');
if checkbox12_Status == 0
    errordlg('This version does not support non-optimum feed plate')
    return
end

%Boilup Ratio
if S < 0
    errordlg('Boilup ratio must be greater than 0')
    return
end

%Boilup Enthalpy
checkbox20_Status = get(handles.boilupenthalpycheckbox,'Value');
if checkbox20_Status == 1 && isnan(hB) == 1
    errordlg('Boilup enthalpy must be a real number')
    return
end

%Pressure
if P < 0
    errordlg('Pressure must be greater than 0')
end    

%Energy Balance
%checkbox4_Status = get(handles.feedenthalpy,'Value');
%checkbox5_Status = get(handles.condenserdutycheckbox,'Value');
%checkbox7_Status = get(handles.reboilerdutycheckbox,'Value');
%checkbox8_Status = get(handles.refluxenthalpy,'Value');
%checkbox20_Status = get(handles.boilupenthalpycheckbox,'Value');
%checkbox21_Status = get(handles.distillateenthalpycheckbox,'Value');
%checkbox22_Status = get(handles.bottomsenthalpycheckbox,'Value');
%jkl = [checkbox4_Status checkbox5_Status checkbox7_Status checkbox8_Status checkbox20_Status checkbox21_Status checkbox22_Status]; %Status vector
%Condenser Energy Balance
if isnan(Qc) == 0 
    if isnan(hD) == 1
        hD = Qc/D/(R+1)*3600;
        hDs = num2str(hD);
        set(handles.refluxenthalpyinput,'String',hDs)
    end
elseif isnan(hD) == 0
    if isnan(Qc) == 1
        Qc = hB*D*(R+1)/3600;
        Qcs = num2str(Qc);
        set(handles.condenserdutyinput,'String',Qcs)
    end
end
%Reboiler Energy Balance
if isnan(Qr) == 0 
    if isnan(hB) == 1
        hB = Qr/B/S*3600;
        hBs = num2str(hB);
        set(handles.boilupenthalpyinput,'String',hBs)
    end
elseif isnan(hB) == 0
    if isnan(Qr) == 1
        Qr = B*S*hB/3600;
        Qrs = num2str(Qr);
        set(handles.reboilerdutyinput,'String',Qrs)
    end
end
%jklm = [isnan(F) isnan(hf) isnan(Qc) isnan(Qr) isnan(B) isnan(HB) isnan(D) isnan(HD)];
%if sum(jklm) == 0   
%    if F*hf + Qc + Qr - B*HB - D*HD >= 100 
%        errordlg('The energy balance is not correct')
%        return
%    end
%end

%Equilibrium Curves
if k ==1 %Vector
    xx = 0:.001:1;
    yy = spline(xeq,yeq,xx);
    hold off
    plot(xx,yy)
    axis([0 1 0 1])
    hold on
    plot(xx,xx)
elseif k == 2 %Alpha
    ye = 0:.001:1;
    xe = equilib(ye,Alpha);
    hold off
    plot(xe,ye)
    axis([0 1 0 1])
    hold on
    plot(ye,ye) 
end

%Plotting the Operating Lines
ytopop = ytop(ye,R,xd);
ybotop = ybot(ye,S,xb);
plot(xf,yf);
plot(ye,ytopop)
plot(ye,ybotop)
plot(ye,ye)
plot(xb,xb,'o')
text(xb+.025,xb-.025,'x_B')
plot(xd,xd,'o')
text(xd+.025,xd-.025,'x_D')
plot(zf,zf,'o')

% Computing the intersection of feed line and operating lines
plot(xi,yi,'o')
text(xi-.1,yi+.025,'Feed Line')
text(xb-.025,xb+.05,'Stripping Line')
text(xd-.25,xd-.05,'Enriching Line')
xlabel('Liquid Phase Mole Fraction, x')
ylabel('Vapor Phase Mole Fraction, y')
title('McCabe-Thiele Diagram for Binary Column Distillation')
if k == 2
    yi2 = interp1 (xe,ye,xi);
    if yi > yi2
        errordlg ('The distillation is not possible. Try a different operating condition.')
        return
    end
elseif k == 1
    yi2 = interp1(xx,yy,xi);
    if yi > yi2
        errordlg('The distillation is not possible. Try a different operating condition.')
        return
    end
end

% Rectifying section
if k == 2 %user defined systems
    i = 1;
    xp(1) = xd;
    yp(1) = xd;
    y = xd;
    while xp (i) > xi
        xp(i+1)= equilib(y,Alpha);
        yp(i+1)= R/(R+1)*xp (i+1)+xd/(R+1);
        y = yp (i+1);
        a = linspace(xp(i),xp(i+1));
        b = yp(i)*ones(length(a));
        plot(a,b)
        text ((xp(i+1)-.025),(yp(i)+.025),num2str (i))
        if xp (i+1) > xi
            c = linspace(yp(i),yp(i+1));
            d = xp(i+1)*ones(length(c));
            plot(d,c)
        end
        i = i+1;
    end
    % Stripping section
    xs = linspace(xb,xi);
    ys = linspace(xb,yi);
    plot(xs,ys)
    ss = (yi-xb)/(xi-xb);
    S = 1/(ss-1); 
    S = num2str(S);
    set(handles.boilupratioinput,'String',S)
    yp(i) = ss*(xp(i)-xb)+xb;
    y = yp(i);
    a = linspace(yp(i-1),yp(i));
    b = xp(i)*ones(length(a));
    plot(b,a)
    while xp (i) > xb
        xp(i+1) = equilib(y,Alpha);
        yp(i+1) = ss*(xp(i+1)-xb)+xb;
        y = yp(i+1);
        a = linspace(xp(i),xp(i+1));
        b = yp(i)*ones(length(a));
        plot(a,b)
        text ((xp(i+1)-.025),(yp(i)+.025),num2str (i))
        if xp (i+1) > xb
            a = linspace(yp(i),yp(i+1));
            b = xp(i+1)*ones(length(a));
            plot(b,a)
        end
        i = i+1;
    end
    
elseif k ==1 %predefined equilibrium systems
    i = 1;
    xp(1) = xd;
    yp(1) = xd;
    y = xd;
    while xp(i) > xi
        xp(i+1)= predefeq(xeq,yeq,y);
        yp(i+1)= R/(R+1)*xp(i+1)+xd/(R+1);
        y = yp(i+1);
        a = linspace(xp(i),xp(i+1));
        b = yp(i)*ones(length(a));
        plot(a,b)
        text ((xp(i+1)-.025),(yp(i)+.025),num2str (i))
        if xp (i+1) > xi
            c = linspace(yp(i),yp(i+1));
            d = xp(i+1)*ones(length(c));
            plot(d,c)
        end
        i = i+1;
    end
    % Stripping section
    xs = linspace(xb,xi);
    ys = linspace(xb,yi);
    plot(xs,ys)
    ss = (yi-xb)/(xi-xb);
    S = 1/(ss-1); 
    S = num2str(S);
    set(handles.boilupratioinput,'String',S)
    yp(i) = ss*(xp(i)-xb)+xb;
    y = yp(i);
    a = linspace(yp(i-1),yp(i));
    b = xp(i)*ones(length(a));
    plot(b,a)
    while xp (i) > xb
        xp(i+1) = predefeq(xeq,yeq,y);
        yp(i+1) = ss*(xp(i+1)-xb)+xb;
        y = yp(i+1);
        a = linspace(xp(i),xp(i+1));
        b = yp(i)*ones(length(a));
        plot(a,b)
        text ((xp(i+1)-.025),(yp(i)+.025),num2str (i))
        if xp (i+1) > xb
            a = linspace(yp(i),yp(i+1));
            b = xp(i+1)*ones(length(a));
            plot(b,a)
        end
        i = i+1;
    end
end


% Functions called with start button: operating & equilibrium lines
function yf = yfeed(xf,Q,zf)
yf = Q/(Q-1)*xf+zf/(1-Q);

function xa = equilib(ya,Alpha)
xa = ya./(Alpha-ya*(Alpha-1));

function ybotop = ybot(x,S,xb)
ybotop = (S+1)/S*x-xb/S;

function ytopop = ytop(x,R,xd)
ytopop = R/(R+1)*x+xd/(R+1);

function backl = predefeq(xeq,yeq,val)
xx = 0:.001:1;
yy = spline(xeq,yeq,xx);
ym = val*ones(1,length(xx));
diffe = abs(yy-ym);
[a b] = min(diffe);
xk = xx(b);
backl = xk;

%System of Nonlinear Equations -- Will be functional in a later version

%User Input Vector
%L = R*D;
%V = D*(R+1);
%Vbar = S*B;
%Lbar = B*(S+1);
%Input_Vector = [F,zf,zfnv,xd,xdnv,xb,xbnv,D,fv,fnv,B,S,Q,R,Rmin,hf,hD,hB,Qc,Qr,L,V,Lbar,Vbar,xie,yie,xi,yi];
%for k = 1:20
%    if isnan(Input_Vector(k)) == 0
%        v(k) = Input_Vector(k);
%    end
%end

%v(1) = F;
%v(2) = zf;
%v(3) = zfnv;
%v(4) = xd;
%v(5) = xdnv;
%v(6) = xb;
%v(7) = xbnv;
%v(8) = D;
%v(9) = fv;
%v(10) = fnv;
%v(11) = B;
%v(12) = S;
%v(13) = Q;
%v(14) = R;
%v(15) = Rmin;
%v(16) = hf;
%v(17) = hD;
%v(18) = hB;
%v(19) = Qc;
%v(20) = Qr;
%v(21) = L;
%v(22) = V;
%v(23) = Lbar;
%v(24) = Vbar;
%v(25) = xie;
%v(26) = yie;
%v(27) = xi;
%v(28) = yi;

%F = @(v) [v(10)-v(11).*v(7)./v(1)./v(3); v(9)-v(8).*v(4)./v(1)./v(2); v(11)+v(24)-v(23); 
%    v(21)+v(8)-v(22); v(23)./v(24)-1./v(12)+1; v(22)./v(21)-1./v(14)-1; v(11)+v(8)-v(1);
%    v(11).*v(6)+v(8).*v(4)-v(1).*v(2); v(2)+v(3)-1; v(6)+v(7)-1; v(4)+v(5)-1; 
%    v(1).*v(16)+v(19)+v(20)-v(8).*v(17)-v(11).*v(18); v(15)./(1+v(15))-(v(4)-v(26))./(v(4)-v(25));
%    v(12)-1./(((v(28)-v(6))./(v(27)-v(6)))-1); v(14)./(1+v(14))-(v(4)-v(28))./(v(4)-v(27))];

%InitialGuess = [50;.5;.5;.5;.5;.5;.5;25;.75;.75;25;2;.5;3;1.5;1;1;1;1;1;1;1;1;1;.5;.5;.5;.5];
%Options = optimset('Display','iter');
%XY = fsolve(F, InitialGuess, Options);

%fnv - B*xbnv/F/zfnv
%fv - D*xd/F/zf;
%B + Vbar - Lbar;
%L + D - V;
%Lbar/Vbar - 1/S + 1;
%V/L - 1/R - 1;
%B + D - F;
%B*xb + D*xd - F*zf;
%zf + zfnv - 1;
%xb + xbnv - 1;
%xd + xdnv - 1;
%F*hf + Qc + Qr - D*hD - B*hB;
%Rmin/(1+Rmin) - (xd-yie)/(xd-xie);
%S - 1/((yi-xb)/(xi-xb)-1);
%R/(1+R)-(xd-yi)/(xd-xi);














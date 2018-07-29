%VirtualSignalGenerator was created by Tom Reid (MS Physics, CWRU, 2010)
%using MATLAB's "GUIDE" functionality... Enjoy!

%Things to keep in mind: (1) In order to manipulate (in the MATLAB Command Window) any variables you create
%using this GUI, you must first declare them global variables in the MATLAB
%Command Window (e.g. enter the command "global x;" to manipulate the variable
%"x" created using VirtualSignalGenerator.m),


function varargout = VirtualSignalGenerator(varargin)
% VIRTUALSIGNALGENERATOR M-file for VirtualSignalGenerator.fig
%      VIRTUALSIGNALGENERATOR, by itself, creates a new VIRTUALSIGNALGENERATOR or raises the existing
%      singleton*.
%
%      H = VIRTUALSIGNALGENERATOR returns the handle to a new VIRTUALSIGNALGENERATOR or the handle to
%      the existing singleton*.
%
%      VIRTUALSIGNALGENERATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIRTUALSIGNALGENERATOR.M with the given input arguments.
%
%      VIRTUALSIGNALGENERATOR('Property','Value',...) creates a new VIRTUALSIGNALGENERATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VirtualSignalGenerator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VirtualSignalGenerator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VirtualSignalGenerator

% Last Modified by GUIDE v2.5 15-Apr-2010 17:02:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VirtualSignalGenerator_OpeningFcn, ...
                   'gui_OutputFcn',  @VirtualSignalGenerator_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1}) %"if nargin" means "if nargin is nonzero"
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout %i.e. if nargout is nonzero
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before VirtualSignalGenerator is made visible.
function VirtualSignalGenerator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VirtualSignalGenerator (see VARARGIN)

% Choose default command line output for VirtualSignalGenerator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes VirtualSignalGenerator wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = VirtualSignalGenerator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes during object creation, after setting all properties.
function OutputLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutputLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on selection change in Output.
function Output_Callback(hObject, eventdata, handles)
% hObject    handle to Output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = get(handles.Output, 'Value');
string_list = get(handles.Output,'String');
val = string_list{ind};
switch val
    case 'New Signal'
        set(handles.OldXNameLabel, 'Visible', 'off');
        set(handles.OldXName, 'Visible', 'off');
        set(handles.OldYNameLabel, 'Visible', 'off');
        set(handles.OldYName, 'Visible', 'off');
    case {'Add to Existing','Multiply Existing'}
        set(handles.OldXNameLabel, 'Visible', 'on');
        set(handles.OldXName, 'Visible', 'on');
        set(handles.OldYNameLabel, 'Visible', 'on');
        set(handles.OldYName, 'Visible', 'on');
end

% --- Executes during object creation, after setting all properties.
function Output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Value', 1);%Default output is "New Signal"



% --- Executes during object creation, after setting all properties.
function OldXNameLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OldXNameLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Visible', 'off');

function OldXName_Callback(hObject, eventdata, handles)
% hObject    handle to OldXName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of OldXName as text
%        str2double(get(hObject,'String')) returns contents of OldXName as a double
val = get(hObject,'String');
if ~isempty(val)
    if ~isvarname(val)
        error('"Existing X Data" name is not a valid variable name at all.  Please choose a different name.')
    else
        comm{1} = ['global ', val];
        comm{2} = ['t = isempty(', val, ');'];
        for i=1:2
            eval(comm{i})
        end
        if t
            error('"Existing X Data" name refers to a variable that is not yet defined.  Please make sure the variable has been declared global or choose a different name.')
        end
    end
end
    
% --- Executes during object creation, after setting all properties.
function OldXName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OldXName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Visible', 'off');



% --- Executes during object creation, after setting all properties.
function OldYNameLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OldYNameLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Visible', 'off');

function OldYName_Callback(hObject, eventdata, handles)
% hObject    handle to OldYName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of OldYName as text
%        str2double(get(hObject,'String')) returns contents of OldYName as
%        a double
val = get(hObject,'String');
if ~isempty(val)
    if ~isvarname(val)
        error('"Existing Y Data" name is not a valid variable name at all.  Please choose a different name.')
    else
        comm{1} = ['global ', val];
        comm{2} = ['t = isempty(', val, ');'];
        for i=1:2
            eval(comm{i})
        end
        if t
            error('"Existing Y Data" name refers to a variable that is not yet defined.  Please make sure the variable has been declared global or choose a different name.')
        end
    end
end

% --- Executes during object creation, after setting all properties.
function OldYName_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Visible', 'off');




% --- Executes on button press in Generate.
function Generate_Callback(hObject, eventdata, handles)
% hObject    handle to Generate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Set x range
xmin = str2num(get(handles.XMin,'String'));
xmax = str2num(get(handles.XMax,'String'));

%Set sampling frequency and, if necessary, adjust x range
val = str2num(get(handles.SampFreq, 'String'));
ind = get(handles.SampFreqLabel, 'Value');
string_list = get(handles.SampFreqLabel,'String');
lab = string_list{ind};
switch lab
    case 'Number of Points'
        npts = val;
    case 'Sampling Frequency (Hz)'
        npts = ceil((xmax-xmin)*val) + 1;
        xmax = xmin + (npts-1)/val;
        set(handles.XMax, 'String', num2str(xmax))%Adjust XMax
end

%Set DC Offset
offset = str2num(get(handles.Offset,'String'));

ind1 = get(handles.Function, 'Value');
string_list1 = get(handles.Function,'String');
val1 = string_list1{ind1};
switch val1
    case 'Periodic'

        %Set signal strength
        a = str2num(get(handles.A, 'String'));
        ind = get(handles.ALabelPer, 'Value');
        string_list = get(handles.ALabelPer,'String');
        lab = string_list{ind};
        switch lab
            case 'Amp'
                A = a;
            case 'P2P'
                A = .5*a;
            case 'RMS'
                A = a*sqrt(2);
        end

        %Set signal frequency
        b = str2num(get(handles.B, 'String'));
        ind = get(handles.BLabelPerPulse, 'Value');
        string_list = get(handles.BLabelPerPulse,'String');
        lab = string_list{ind};
        switch lab
            case 'Freq (Hz)'
                B = 2*pi*b;
            case 'Ang Freq'
                B = b;
            case 'Period'
                B = 2*pi/b;
            case '# Cycles'
                B = 2*pi*b/(xmax-xmin);
        end

        %Set phase
        c = str2num(get(handles.C, 'String'));
        ind = get(handles.CLabelPerPulse, 'Value');
        string_list = get(handles.CLabelPerPulse,'String');
        lab = string_list{ind};
        switch lab
            case 'Phase (rad)'
                C = c;
            case 'Phase (deg)'
                C = (2*pi/360)*c;
            case 'Phase (%)'
                C = (2*pi/100)*c;
            case 'Phase (abs)'
                C = 2*pi*c;
        end

        %Set Gaussian noise
        val = str2num(get(handles.YNoise, 'String'));
        ind = get(handles.YNoiseLabelP, 'Value');
        string_list = get(handles.YNoiseLabelP,'String');
        lab = string_list{ind};
        switch lab
            case 'Noise (abs)'
                ynoise = val*randn(1,npts);
            case 'Noise (%)'
                ynoise = .01*val*A*randn(1,npts);
        end

        %Generate x and y data and plot signal
        ind = get(handles.Output, 'Value');
        string_list = get(handles.Output,'String');
        val = string_list{ind};
        switch val
            case 'New Signal'% Generate a new data set
                xdata = linspace(xmin, xmax, npts);% to include xnoise use + .01*xpct*((xmax-xmin)/(npts-1))*randn(1,npts)
                ind2 = get(handles.Shape, 'Value');
                string_list2 = get(handles.Shape,'String');
                val2 = string_list2{ind2};
                switch val2
                    case 'Sinusoidal'
                        ydata = A*sin(B*xdata + C) + offset + ynoise;
                    case 'Triangle'
                        for i = 1:npts
                            if mod(B*xdata(i)+C, 2*pi) <= pi/2
                                ydata(i) = (A/(pi/2))*mod(B*xdata(i)+C, 2*pi) + offset + ynoise(i);
                            elseif pi/2 < mod(B*xdata(i)+C, 2*pi) && mod(B*xdata(i)+C, 2*pi) <= 3*pi/2 
                                ydata(i) = 2*A - (A/(pi/2))*mod(B*xdata(i)+C, 2*pi) + offset + ynoise(i);
                            else
                                ydata(i) = -4*A + (A/(pi/2))*mod(B*xdata(i)+C, 2*pi) + offset + ynoise(i);
                            end
                        end
                    case 'Sawtooth'
                        for i = 1:npts
                            if mod(B*xdata(i)+C, 2*pi) <= pi
                                ydata(i) = (A/pi)*mod(B*xdata(i)+C, 2*pi) + offset + ynoise(i);
                            else
                                ydata(i) = -A + (A/pi)*mod(B*xdata(i)+C, 2*pi) + offset + ynoise(i);
                            end
                        end
                    case 'Square'
                        for i = 1:npts
                            if mod(B*xdata(i)+C, 2*pi)<=pi
                                ydata(i) = A + offset + ynoise(i);
                            else
                                ydata(i) = -A + offset + ynoise(i);
                            end
                        end
                end
                xname = get(handles.XName, 'String');
                yname = get(handles.YName, 'String');
                comm{1} = ['global ', xname, ';'];%Build (string) commands that will be used to define a global variable with the desired name that contains xdata, thus enabling user to manipulate it from MATLAB command prompt
                comm{2} = [xname, ' = xdata;'];
                comm{3} = ['global ', yname, ';'];
                comm{4} = [yname, ' = ydata;'];
                %Execute above commands
                for i = 1:4
                    eval(comm{i});
                end
            case 'Add to Existing'%Add new data to an existing data set
                oldxname = get(handles.OldXName, 'String');%Retrieve existing data to which we will add xdata
                oldyname = get(handles.OldYName, 'String');
                comm{1} = ['global ', oldxname, ';'];%Match current xdata to existing xdata
                comm{2} = ['global ', oldyname, ';'];
                comm{3} = ['xdata = ', oldxname, ';'];
                for i = 1:3
                    eval(comm{i});
                end
                ind2 = get(handles.Shape, 'Value');
                string_list2 = get(handles.Shape,'String');
                val2 = string_list2{ind2};
                switch val2
                    case 'Sinusoidal'
                        ydata = A*sin(B*xdata + C) + offset + ynoise;
                    case 'Triangle'
                        for i = 1:npts
                            if mod(B*xdata(i)+C, 2*pi) <= pi/2
                                ydata(i) = (A/(pi/2))*mod(B*xdata(i)+C, 2*pi) + offset + ynoise(i);
                            elseif pi/2 < mod(B*xdata(i)+C, 2*pi) && mod(B*xdata(i)+C, 2*pi) <= 3*pi/2 
                                ydata(i) = 2*A - (A/(pi/2))*mod(B*xdata(i)+C, 2*pi) + offset + ynoise(i);
                            else
                                ydata(i) = -4*A + (A/(pi/2))*mod(B*xdata(i)+C, 2*pi) + offset + ynoise(i);
                            end
                        end
                    case 'Sawtooth'
                        for i = 1:npts
                            if mod(B*xdata(i)+C, 2*pi) <= pi
                                ydata(i) = (A/pi)*mod(B*xdata(i)+C, 2*pi) + offset + ynoise(i);
                            else
                                ydata(i) = -A + (A/pi)*mod(B*xdata(i)+C, 2*pi) + offset + ynoise(i);
                            end
                        end
                    case 'Square'
                        for i = 1:npts
                            if mod(B*xdata(i)+C, 2*pi)<=pi
                                ydata(i) = A + offset + ynoise(i);
                            else
                                ydata(i) = -A + offset + ynoise(i);
                            end
                        end
                end
                xname = get(handles.XName, 'String');
                yname = get(handles.YName, 'String');
                comm{1} = ['global ', xname, ';'];%Build (string) commands that will be used to define a global variable with the desired name that contains xdata, thus enabling user to manipulate it from MATLAB command prompt
                comm{2} = [xname, ' = ', oldxname, ';'];
                comm{3} = ['global ', yname, ';'];
                comm{4} = [yname, ' = ', oldyname, ' + ydata;'];
                %Execute above commands
                for i = 1:4
                    eval(comm{i});
                end
            case 'Multiply Existing'%Multiply new data by an existing data set
                oldxname = get(handles.OldXName, 'String');%Retrieve existing data to which we will add xdata
                oldyname = get(handles.OldYName, 'String');
                comm{1} = ['global ', oldxname, ';'];%Match current xdata to existing xdata
                comm{2} = ['global ', oldyname, ';'];
                comm{3} = ['xdata = ', oldxname, ';'];
                for i = 1:3
                    eval(comm{i});
                end
                ind2 = get(handles.Shape, 'Value');
                string_list2 = get(handles.Shape,'String');
                val2 = string_list2{ind2};
                switch val2
                    case 'Sinusoidal'
                        ydata = A*sin(B*xdata + C) + offset + ynoise;
                    case 'Triangle'
                        for i = 1:npts
                            if mod(B*xdata(i)+C, 2*pi) <= pi/2
                                ydata(i) = (A/(pi/2))*mod(B*xdata(i)+C, 2*pi) + offset + ynoise(i);
                            elseif pi/2 < mod(B*xdata(i)+C, 2*pi) && mod(B*xdata(i)+C, 2*pi) <= 3*pi/2 
                                ydata(i) = 2*A - (A/(pi/2))*mod(B*xdata(i)+C, 2*pi) + offset + ynoise(i);
                            else
                                ydata(i) = -4*A + (A/(pi/2))*mod(B*xdata(i)+C, 2*pi) + offset + ynoise(i);
                            end
                        end
                    case 'Sawtooth'
                        for i = 1:npts
                            if mod(B*xdata(i)+C, 2*pi) <= pi
                                ydata(i) = (A/pi)*mod(B*xdata(i)+C, 2*pi) + offset + ynoise(i);
                            else
                                ydata(i) = -A + (A/pi)*mod(B*xdata(i)+C, 2*pi) + offset + ynoise(i);
                            end
                        end
                    case 'Square'
                        for i = 1:npts
                            if mod(B*xdata(i)+C, 2*pi)<=pi
                                ydata(i) = A + offset + ynoise(i);
                            else
                                ydata(i) = -A + offset + ynoise(i);
                            end
                        end
                end
                xname = get(handles.XName, 'String');
                yname = get(handles.YName, 'String');
                comm{1} = ['global ', xname, ';'];%Build (string) commands that will be used to define a global variable with the desired name that contains xdata, thus enabling user to manipulate it from MATLAB command prompt
                comm{2} = [xname, ' = ', oldxname, ';'];
                comm{3} = ['global ', yname, ';'];
                comm{4} = [yname, ' = ', oldyname, '.*ydata;'];
                %Execute above commands
                for i = 1:4
                    eval(comm{i});
                end
        end

    case 'Pulse'
        %Set signal strength
        a = str2num(get(handles.A, 'String'));
        A = a;
        
        %Set signal frequency
        b = str2num(get(handles.B, 'String'));
        ind = get(handles.BLabelPerPulse, 'Value');
        string_list = get(handles.BLabelPerPulse,'String');
        lab = string_list{ind};
        switch lab
            case 'Freq (Hz)'
                B = 2*pi*b;
            case 'Ang Freq'
                B = b;
            case 'Period'
                B = 2*pi/b;
            case '# Cycles'
                B = 2*pi*b/(xmax-xmin);
        end
        
        %Set duty cycle
        val = str2num(get(handles.Duty, 'String'));
        ind = get(handles.DutyLabel, 'Value');
        string_list = get(handles.DutyLabel,'String');
        lab = string_list{ind};
        switch lab
            case 'Duty (%)'
                duty = val;
            case 'Duty (deg)'
                duty = (100/360)*val;
            case 'Duty (rad)'
                duty = (100/2*pi)*val;
            case 'Duty (abs)'
                duty = (100/2*pi)*B*val
        end

        %Set c
        c = str2num(get(handles.C, 'String'));
        ind = get(handles.CLabelPerPulse, 'Value');
        string_list = get(handles.CLabelPerPulse,'String');
        lab = string_list{ind};
        switch lab
            case 'Phase (rad)'
                C = c;
            case 'Phase (deg)'
                C = (2*pi/360)*c;
            case 'Phase (%)'
                C = (2*pi/100)*c;
            case 'Phase (abs)'
                C = 2*pi*c;
        end

        %Set Gaussian noise
        val = str2num(get(handles.YNoise, 'String'));
        ind = get(handles.YNoiseLabelP, 'Value');
        string_list = get(handles.YNoiseLabelP,'String');
        lab = string_list{ind};
        switch lab
            case 'Noise (abs)'
                ynoise = val*randn(1,npts);
            case 'Noise (%)'
                ynoise = .01*val*A*randn(1,npts);
        end
        
        %Generate x and y data and plot signal
        ind = get(handles.Output, 'Value');
        string_list = get(handles.Output,'String');
        val = string_list{ind};
        switch val
            case 'New Signal'% Generate a new data set
                xdata = linspace(xmin, xmax, npts);% to include xnoise use + .01*xpct*((xmax-xmin)/(npts-1))*randn(1,npts)
                for i = 1:npts
                    if mod(B*xdata(i)+C, 2*pi)<=.01*duty*2*pi
                        ydata(i) = A + offset + ynoise(i);
                    else
                        ydata(i) = 0 + offset + ynoise(i);
                    end
                end
                xname = get(handles.XName, 'String');
                yname = get(handles.YName, 'String');
                comm{1} = ['global ', xname, ';'];%Build (string) commands that will be used to define a global variable with the desired name that contains xdata, thus enabling user to manipulate it from MATLAB command prompt
                comm{2} = [xname, ' = xdata;'];
                comm{3} = ['global ', yname, ';'];
                comm{4} = [yname, ' = ydata;'];
                %Execute above commands
                for i = 1:4
                    eval(comm{i});
                end
            case 'Add to Existing'%Add new data to an existing data set
                oldxname = get(handles.OldXName, 'String');%Retrieve existing data to which we will add xdata
                oldyname = get(handles.OldYName, 'String');
                comm{1} = ['global ', oldxname, ';'];%Match current xdata to existing xdata
                comm{2} = ['global ', oldyname, ';'];
                comm{3} = ['xdata = ', oldxname, ';'];
                for i = 1:3
                    eval(comm{i});
                end
                for i = 1:npts
                    if mod(B*xdata(i)+C, 2*pi)<=.01*duty*2*pi
                        ydata(i) = A + offset + ynoise(i);
                    else
                        ydata(i) = 0 + offset + ynoise(i);
                    end
                end
                xname = get(handles.XName, 'String');
                yname = get(handles.YName, 'String');
                comm{1} = ['global ', xname, ';'];%Build (string) commands that will be used to define a global variable with the desired name that contains xdata, thus enabling user to manipulate it from MATLAB command prompt
                comm{2} = [xname, ' = ', oldxname, ';'];
                comm{3} = ['global ', yname, ';'];
                comm{4} = [yname, ' = ', oldyname, ' + ydata;'];
                %Execute above commands
                for i = 1:4
                    eval(comm{i});
                end
            case 'Multiply Existing'%Multiply new data by an existing data set
                oldxname = get(handles.OldXName, 'String');%Retrieve existing data to which we will add xdata
                oldyname = get(handles.OldYName, 'String');
                comm{1} = ['global ', oldxname, ';'];%Match current xdata to existing xdata
                comm{2} = ['global ', oldyname, ';'];
                comm{3} = ['xdata = ', oldxname, ';'];
                for i = 1:3
                    eval(comm{i});
                end
                for i = 1:npts
                    if mod(B*xdata(i)+C, 2*pi)<=.01*duty*2*pi
                        ydata(i) = A + offset + ynoise(i);
                    else
                        ydata(i) = 0 + offset + ynoise(i);
                    end
                end
                xname = get(handles.XName, 'String');
                yname = get(handles.YName, 'String');
                comm{1} = ['global ', xname, ';'];%Build (string) commands that will be used to define a global variable with the desired name that contains xdata, thus enabling user to manipulate it from MATLAB command prompt
                comm{2} = [xname, ' = ', oldxname, ';'];
                comm{3} = ['global ', yname, ';'];
                comm{4} = [yname, ' = ', oldyname, '.*ydata;'];
                %Execute above commands
                for i = 1:4
                    eval(comm{i});
                end
        end

    case 'Exponential'
        %Set X Coefficient
        b = str2num(get(handles.B, 'String'));
        ind = get(handles.BLabelExp, 'Value');
        string_list = get(handles.BLabelExp,'String');
        lab = string_list{ind};
        switch lab
            case 'X Coeff'
                B = b;
            case 'Time Const'
                B = 1/b;
        end

        %Set Y coefficient
        a = str2num(get(handles.A, 'String'));
        ind = get(handles.ALabelExp, 'Value');
        string_list = get(handles.ALabelExp,'String');
        lab = string_list{ind};
        switch lab
            case 'Y Coeff'
                A = a;
            case 'Phase (abs)'
                A = exp(B*a);
        end
        
        %Set Gaussian noise
        val = str2num(get(handles.YNoise, 'String'));
        ynoise = val*randn(1,npts);
                
        %Generate x and y data and plot signal
        ind = get(handles.Output, 'Value');
        string_list = get(handles.Output,'String');
        val = string_list{ind};
        switch val
            case 'New Signal'% Generate a new data set
                xdata = linspace(xmin, xmax, npts);% to include xnoise use + .01*xpct*((xmax-xmin)/(npts-1))*randn(1,npts)
                ydata = A*exp(B*xdata) + offset + ynoise;
                xname = get(handles.XName, 'String');
                yname = get(handles.YName, 'String');
                comm{1} = ['global ', xname, ';'];%Build (string) commands that will be used to define a global variable with the desired name that contains xdata, thus enabling user to manipulate it from MATLAB command prompt
                comm{2} = [xname, ' = xdata;'];
                comm{3} = ['global ', yname, ';'];
                comm{4} = [yname, ' = ydata;'];
                %Execute above commands
                for i = 1:4
                    eval(comm{i});
                end
            case 'Add to Existing'%Add new data to an existing data set
                oldxname = get(handles.OldXName, 'String');%Retrieve existing data to which we will add xdata
                oldyname = get(handles.OldYName, 'String');
                comm{1} = ['global ', oldxname, ';'];%Match current xdata to existing xdata
                comm{2} = ['global ', oldyname, ';'];
                comm{3} = ['xdata = ', oldxname, ';'];
                for i = 1:3
                    eval(comm{i});
                end
                ydata = A*exp(B*xdata) + offset + ynoise;
                xname = get(handles.XName, 'String');
                yname = get(handles.YName, 'String');
                comm{1} = ['global ', xname, ';'];%Build (string) commands that will be used to define a global variable with the desired name that contains xdata, thus enabling user to manipulate it from MATLAB command prompt
                comm{2} = [xname, ' = ', oldxname, ';'];
                comm{3} = ['global ', yname, ';'];
                comm{4} = [yname, ' = ', oldyname, ' + ydata;'];
                %Execute above commands
                for i = 1:4
                    eval(comm{i});
                end
            case 'Multiply Existing'%Multiply new data by an existing data set
                oldxname = get(handles.OldXName, 'String');%Retrieve existing data to which we will add xdata
                oldyname = get(handles.OldYName, 'String');
                comm{1} = ['global ', oldxname, ';'];%Match current xdata to existing xdata
                comm{2} = ['global ', oldyname, ';'];
                comm{3} = ['xdata = ', oldxname, ';'];
                for i = 1:3
                    eval(comm{i});
                end
                ydata = A*exp(B*xdata) + offset + ynoise;
                xname = get(handles.XName, 'String');
                yname = get(handles.YName, 'String');
                comm{1} = ['global ', xname, ';'];%Build (string) commands that will be used to define a global variable with the desired name that contains xdata, thus enabling user to manipulate it from MATLAB command prompt
                comm{2} = [xname, ' = ', oldxname, ';'];
                comm{3} = ['global ', yname, ';'];
                comm{4} = [yname, ' = ', oldyname, '.*ydata;'];
                %Execute above commands
                for i = 1:4
                    eval(comm{i});
                end
        end
        
    case 'Gaussian'
        
        %Set width of Gaussian
        b = str2num(get(handles.B, 'String'));
        ind = get(handles.BLabelGauss, 'Value');
        string_list = get(handles.BLabelGauss,'String');
        lab = string_list{ind};
        switch lab
            case 'Std Dev'
                B = b;
            case 'FWHM'
                B = (1/(2*sqrt(2*log(2))))*b;
            case 'HWHM'
                B = (1/(4*sqrt(2*log(2))))*b;
            case 'Variance'
                B = sqrt(b);
            case 'Precision'
                B = sqrt(1/b);
        end

        %Set area under Gaussian
        a = str2num(get(handles.A, 'String'));
        ind = get(handles.ALabelGauss, 'Value');
        string_list = get(handles.ALabelGauss,'String');
        lab = string_list{ind};
        switch lab
            case 'Area Under'
                A = a;
            case 'Peak Value'
                A = sqrt(2*pi)*B*a;
        end

        %Set mean of Gaussian
        c = str2num(get(handles.C, 'String'));
        C = c;
                
        %Set Gaussian noise
        val = str2num(get(handles.YNoise, 'String'));
        ynoise = val*randn(1,npts);
                
        %Generate x and y data and plot signal
        ind = get(handles.Output, 'Value');
        string_list = get(handles.Output,'String');
        val = string_list{ind};
        switch val
            case 'New Signal'% Generate a new data set
                xdata = linspace(xmin, xmax, npts);% to include xnoise use + .01*xpct*((xmax-xmin)/(npts-1))*randn(1,npts)
                ydata = A*(1/(B*sqrt(2*pi)))*exp(-(1/2)*((xdata - C)/B).^2) + offset + ynoise;
                xname = get(handles.XName, 'String');
                yname = get(handles.YName, 'String');
                comm{1} = ['global ', xname, ';'];%Build (string) commands that will be used to define a global variable with the desired name that contains xdata, thus enabling user to manipulate it from MATLAB command prompt
                comm{2} = [xname, ' = xdata;'];
                comm{3} = ['global ', yname, ';'];
                comm{4} = [yname, ' = ydata;'];
                %Execute above commands
                for i = 1:4
                    eval(comm{i});
                end
            case 'Add to Existing'%Add new data to an existing data set
                oldxname = get(handles.OldXName, 'String');%Retrieve existing data to which we will add xdata
                oldyname = get(handles.OldYName, 'String');
                comm{1} = ['global ', oldxname, ';'];%Match current xdata to existing xdata
                comm{2} = ['global ', oldyname, ';'];
                comm{3} = ['xdata = ', oldxname, ';'];
                for i = 1:3
                    eval(comm{i});
                end
                ydata = A*(1/(B*sqrt(2*pi)))*exp(-(1/2)*((xdata - C)/B).^2) + offset + ynoise;
                xname = get(handles.XName, 'String');
                yname = get(handles.YName, 'String');
                comm{1} = ['global ', xname, ';'];%Build (string) commands that will be used to define a global variable with the desired name that contains xdata, thus enabling user to manipulate it from MATLAB command prompt
                comm{2} = [xname, ' = ', oldxname, ';'];
                comm{3} = ['global ', yname, ';'];
                comm{4} = [yname, ' = ', oldyname, ' + ydata;'];
                %Execute above commands
                for i = 1:4
                    eval(comm{i});
                end
            case 'Multiply Existing'%Multiply new data by an existing data set
                oldxname = get(handles.OldXName, 'String');%Retrieve existing data to which we will add xdata
                oldyname = get(handles.OldYName, 'String');
                comm{1} = ['global ', oldxname, ';'];%Match current xdata to existing xdata
                comm{2} = ['global ', oldyname, ';'];
                comm{3} = ['xdata = ', oldxname, ';'];
                for i = 1:3
                    eval(comm{i});
                end
                ydata = A*(1/(B*sqrt(2*pi)))*exp(-(1/2)*((xdata - C)/B)^2) + offset + ynoise;
                xname = get(handles.XName, 'String');
                yname = get(handles.YName, 'String');
                comm{1} = ['global ', xname, ';'];%Build (string) commands that will be used to define a global variable with the desired name that contains xdata, thus enabling user to manipulate it from MATLAB command prompt
                comm{2} = [xname, ' = ', oldxname, ';'];
                comm{3} = ['global ', yname, ';'];
                comm{4} = [yname, ' = ', oldyname, '.*ydata;'];
                %Execute above commands
                for i = 1:4
                    eval(comm{i});
                end
        end
        
    case 'Noise'
        %Set Gaussian noise
        val = str2num(get(handles.YNoise, 'String'));
        ynoise = val*randn(1,npts);
                
        %Generate x and y data and plot signal
        ind = get(handles.Output, 'Value');
        string_list = get(handles.Output,'String');
        val = string_list{ind};
        switch val
            case 'New Signal'% Generate a new data set
                xdata = linspace(xmin, xmax, npts);% to include xnoise use + .01*xpct*((xmax-xmin)/(npts-1))*randn(1,npts)
                ydata = ynoise + offset;
                xname = get(handles.XName, 'String');
                yname = get(handles.YName, 'String');
                comm{1} = ['global ', xname, ';'];%Build (string) commands that will be used to define a global variable with the desired name that contains xdata, thus enabling user to manipulate it from MATLAB command prompt
                comm{2} = [xname, ' = xdata;'];
                comm{3} = ['global ', yname, ';'];
                comm{4} = [yname, ' = ydata;'];
                %Execute above commands
                for i = 1:4
                    eval(comm{i});
                end
            case 'Add to Existing'%Add new data to an existing data set
                oldxname = get(handles.OldXName, 'String');%Retrieve existing data to which we will add xdata
                oldyname = get(handles.OldYName, 'String');
                comm{1} = ['global ', oldxname, ';'];%Match current xdata to existing xdata
                comm{2} = ['global ', oldyname, ';'];
                comm{3} = ['xdata = ', oldxname, ';'];
                for i = 1:3
                    eval(comm{i});
                end
                ydata = ynoise + offset;
                xname = get(handles.XName, 'String');
                yname = get(handles.YName, 'String');
                comm{1} = ['global ', xname, ';'];%Build (string) commands that will be used to define a global variable with the desired name that contains xdata, thus enabling user to manipulate it from MATLAB command prompt
                comm{2} = [xname, ' = ', oldxname, ';'];
                comm{3} = ['global ', yname, ';'];
                comm{4} = [yname, ' = ', oldyname, ' + ydata;'];
                %Execute above commands
                for i = 1:4
                    eval(comm{i});
                end
            case 'Multiply Existing'%Multiply new data by an existing data set
                oldxname = get(handles.OldXName, 'String');%Retrieve existing data to which we will add xdata
                oldyname = get(handles.OldYName, 'String');
                comm{1} = ['global ', oldxname, ';'];%Match current xdata to existing xdata
                comm{2} = ['global ', oldyname, ';'];
                comm{3} = ['xdata = ', oldxname, ';'];
                for i = 1:3
                    eval(comm{i});
                end
                ydata = ynoise + offset;
                xname = get(handles.XName, 'String');
                yname = get(handles.YName, 'String');
                comm{1} = ['global ', xname, ';'];%Build (string) commands that will be used to define a global variable with the desired name that contains xdata, thus enabling user to manipulate it from MATLAB command prompt
                comm{2} = [xname, ' = ', oldxname, ';'];
                comm{3} = ['global ', yname, ';'];
                comm{4} = [yname, ' = ', oldyname, '.*ydata;'];
                %Execute above commands
                for i = 1:4
                    eval(comm{i});
                end
        end
end

%Use handle of last plot that was created using VirtualSignalGenerator.m
%Call up a "New Figure" if this "Plot" option is selected
global plothandlevsg
ind = get(handles.Plot, 'Value');
string_list = get(handles.Plot,'String');
val = string_list{ind};
switch val
    case 'New Figure'
        figure;
        plotcomm = ['plothandlevsg = plot(', xname, ', ', yname, ');'];
    case 'Overwrite Last'
        if ishandle(plothandlevsg)
            xd = 'XData';
            yd = 'YData';
            plotcomm = ['set(plothandlevsg, xd, ', xname, ', yd, ', yname, ');'];
            fprintf('it exists!')
        else
            figure;%Call up a new figure if this is the first time the program is being run
            plotcomm = ['plothandlevsg = plot(', xname, ', ', yname, ');'];
            fprintf('it does NOT exist!')
        
        end
end
%Plot!!!
eval(plotcomm)



% --- Executes during object creation, after setting all properties.
function XNameLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XNameLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function XName_Callback(hObject, eventdata, handles)
% hObject    handle to XName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'String');
if ~isempty(val)
    if ~isvarname(val)
        error('"X data" name is not a valid variable name at all.  Please choose a different name.')
    else
        comm{1} = ['global ', val];
        comm{2} = ['t = isempty(', val, ');'];
        for i=1:2
            eval(comm{i})
        end
        if ~t
            error('"X data" name refers to a variable that already exists.  Please proceed only if you wish to overwrite the existing variable.  Otherwise, please choose a different name.')
        end
    end
end

% --- Executes during object creation, after setting all properties.
function XName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', 'x');%Default name for X Data variable is 'x'



% --- Executes during object creation, after setting all properties.
function XMinLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XMinLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function XMin_Callback(hObject, eventdata, handles)
% hObject    handle to XMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function XMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', '0')%Default value for X min is zero



% --- Executes during object creation, after setting all properties.
function XMaxLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XMaxLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function XMax_Callback(hObject, eventdata, handles)
% hObject    handle to XMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function XMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', '5')%Default value for X max is five



% --- Executes on selection change in SampFreqLabel.
function SampFreqLabel_Callback(hObject, eventdata, handles)
% hObject    handle to SampFreqLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function SampFreqLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SampFreqLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Value', 1)%Default is 'Number of Points'

function SampFreq_Callback(hObject, eventdata, handles)
% hObject    handle to SampFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject, 'String');
if ~isempty(val)
    if str2num(val)<=0
        error('Sampling frequency or number of points must be positive')
    end
end   

% --- Executes during object creation, after setting all properties.
function SampFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SampFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', '1000')%Default Number of Points is 1000



% --- Executes during object creation, after setting all properties.
function YNameLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YNameLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function YName_Callback(hObject, eventdata, handles)
% hObject    handle to YName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'String');
if ~isempty(val)
    if ~isvarname(val)
        error('"Y data" name is not a valid variable name at all.  Please choose a different name.')
    else
        comm{1} = ['global ', val];
        comm{2} = ['t = isempty(', val, ');'];
        for i=1:2
            eval(comm{i})
        end
        if ~t
            error('"Y data" name refers to a variable that already exists.  Please proceed only if you wish to overwrite the existing variable.  Otherwise, please choose a different name.')
        end
    end
end

% --- Executes during object creation, after setting all properties.
function YName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', 'y')%Default name for Y Data variable is 'y'



% --- Executes during object creation, after setting all properties.
function FunctionLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FunctionLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on selection change in Function.
function Function_Callback(hObject, eventdata, handles)
% hObject    handle to Function (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = get(handles.Function, 'Value');
string_list = get(handles.Function,'String');
val = string_list{ind};
switch val
    case 'Periodic'
        set(handles.YNoiseLabelP, 'Visible', 'on');
        set(handles.YNoiseLabel, 'Visible', 'off');
        set(handles.YNoise, 'Visible', 'on');
        set(handles.ShapeLabel, 'Visible', 'on');
        set(handles.Shape, 'Visible', 'on');
        set(handles.ALabelPer, 'Visible', 'on');
        set(handles.ALabelPulse, 'Visible', 'off');
        set(handles.ALabelExp, 'Visible', 'off');
        set(handles.ALabelGauss, 'Visible', 'off');
        set(handles.ALabel, 'Visible', 'on');
        set(handles.A, 'Visible', 'on');
        set(handles.BLabelPerPulse, 'Visible', 'on');
        set(handles.BLabelExp, 'Visible', 'off');
        set(handles.BLabelGauss, 'Visible', 'off');
        set(handles.BLabel, 'Visible', 'on');
        set(handles.B, 'Visible', 'on');
        set(handles.CLabelPerPulse, 'Visible', 'on');
        set(handles.CLabelGauss, 'Visible', 'off');
        set(handles.CLabel, 'Visible', 'on');
        set(handles.C, 'Visible', 'on');
        set(handles.DutyLabel, 'Visible', 'off');
        set(handles.Duty, 'Visible', 'off');
        %Set preview of output equation
        ind = get(handles.Shape, 'Value');
        string_list = get(handles.Shape,'String');
        val = string_list{ind};
        switch val
            case 'Sinusoidal'
                set(handles.PreviewEq, 'String', 'ydata = A*sin(B*xdata + C) + offset + ynoise');
            case 'Triangle'
                set(handles.PreviewEq, 'String', 'ydata = A*triangle(B*xdata + C) + offset + ynoise');
            case 'Sawtooth'
                set(handles.PreviewEq, 'String', 'ydata = A*sawtooth(B*xdata + C) + offset + ynoise');
            case 'Square'
                set(handles.PreviewEq, 'String', 'ydata = A*square(B*xdata + C) + offset + ynoise');
        end
        %Set form of preview variable A in terms of input a
        indA = get(handles.ALabelPer, 'Value');
        string_listA = get(handles.ALabelPer,'String');
        labA = string_listA{indA};
        switch labA
            case 'Amp'
                set(handles.PreviewA, 'Visible', 'on', 'String', 'A = a');
            case 'P2P'
                set(handles.PreviewA, 'Visible', 'on', 'String', 'A = .5*a');
            case 'RMS'
                set(handles.PreviewA, 'Visible', 'on', 'String', 'A = a*sqrt(2)');
        end
        %Set form of preview variable B in terms of input b
        indB = get(handles.BLabelPerPulse, 'Value');
        string_listB = get(handles.BLabelPerPulse,'String');
        labB = string_listB{indB};
        switch labB
            case 'Freq (Hz)'
                set(handles.PreviewB, 'Visible', 'on', 'String', 'B = 2*pi*b');
            case 'Ang Freq'
                set(handles.PreviewB, 'Visible', 'on', 'String', 'B = b');
            case 'Period'
                set(handles.PreviewB, 'Visible', 'on', 'String', 'B = 2*pi/b');
            case '# Cycles'
                set(handles.PreviewB, 'Visible', 'on', 'String', 'B = 2*pi*b/(xmax-xmin)');
        end
        %Set form of preview variable C in terms of input c
        indC = get(handles.CLabelPerPulse, 'Value');
        string_listC = get(handles.CLabelPerPulse,'String');
        labC = string_listC{indC};
        switch labC
            case 'Phase (rad)'
                set(handles.PreviewC, 'Visible', 'on', 'String', 'C = c');
            case 'Phase (deg)'
                set(handles.PreviewC, 'Visible', 'on', 'String', 'C = (2*pi/360)*c');
            case 'Phase (%)'
                set(handles.PreviewC, 'Visible', 'on', 'String', 'C = (2*pi/100)*c');
            case 'Phase (abs)'
                set(handles.PreviewC, 'Visible', 'on', 'String', 'C = 2*pi*c');
        end
    case 'Pulse'
        set(handles.YNoiseLabelP, 'Visible', 'on');
        set(handles.YNoiseLabel, 'Visible', 'off');
        set(handles.YNoise, 'Visible', 'on');
        set(handles.ShapeLabel, 'Visible', 'off');
        set(handles.Shape, 'Visible', 'off');
        set(handles.ALabelPer, 'Visible', 'off');
        set(handles.ALabelPulse, 'Visible', 'on');
        set(handles.ALabelExp, 'Visible', 'off');
        set(handles.ALabelGauss, 'Visible', 'off');
        set(handles.ALabel, 'Visible', 'on');
        set(handles.A, 'Visible', 'on');
        set(handles.BLabelPerPulse, 'Visible', 'on');
        set(handles.BLabelExp, 'Visible', 'off');
        set(handles.BLabelGauss, 'Visible', 'off');
        set(handles.BLabel, 'Visible', 'on');
        set(handles.B, 'Visible', 'on');
        set(handles.CLabelPerPulse, 'Visible', 'on');
        set(handles.CLabelGauss, 'Visible', 'off');
        set(handles.CLabel, 'Visible', 'on');
        set(handles.C, 'Visible', 'on')
        set(handles.DutyLabel, 'Visible', 'on');
        set(handles.Duty, 'Visible', 'on');
        set(handles.PreviewEq, 'String', 'ydata = A*pulse(B*xdata + C) + offset + ynoise');%Set preview of output equation
        set(handles.PreviewA, 'Visible', 'on', 'String', 'A = a');%Set form of preview variable A in terms of input a
        %Set form of preview variable B in terms of input b
        indB = get(handles.BLabelPerPulse, 'Value');
        string_listB = get(handles.BLabelPerPulse,'String');
        labB = string_listB{indB};
        switch labB
            case 'Freq (Hz)'
                set(handles.PreviewB, 'Visible', 'on', 'String', 'B = 2*pi*b');
            case 'Ang Freq'
                set(handles.PreviewB, 'Visible', 'on', 'String', 'B = b');
            case 'Period'
                set(handles.PreviewB, 'Visible', 'on', 'String', 'B = 2*pi/b');
            case '# Cycles'
                set(handles.PreviewB, 'Visible', 'on', 'String', 'B = 2*pi*b/(xmax-xmin)');
        end
        %Set form of preview variable C in terms of input c
        indC = get(handles.CLabelPerPulse, 'Value');
        string_listC = get(handles.CLabelPerPulse,'String');
        labC = string_listC{indC};
        switch labC
            case 'Phase (rad)'
                set(handles.PreviewC, 'Visible', 'on', 'String', 'C = c');
            case 'Phase (deg)'
                set(handles.PreviewC, 'Visible', 'on', 'String', 'C = (2*pi/360)*c');
            case 'Phase (%)'
                set(handles.PreviewC, 'Visible', 'on', 'String', 'C = (2*pi/100)*c');
            case 'Phase (abs)'
                set(handles.PreviewC, 'Visible', 'on', 'String', 'C = 2*pi*c');
        end
    case 'Exponential'
        set(handles.YNoiseLabelP, 'Visible', 'off');
        set(handles.YNoiseLabel, 'Visible', 'on');
        set(handles.YNoise, 'Visible', 'on');
        set(handles.ShapeLabel, 'Visible', 'off');
        set(handles.Shape, 'Visible', 'off');
        set(handles.ALabelPer, 'Visible', 'off');
        set(handles.ALabelPulse, 'Visible', 'off');
        set(handles.ALabelExp, 'Visible', 'on');
        set(handles.ALabelGauss, 'Visible', 'off');
        set(handles.ALabel, 'Visible', 'on');
        set(handles.A, 'Visible', 'on');
        set(handles.BLabelPerPulse, 'Visible', 'off');
        set(handles.BLabelExp, 'Visible', 'on');
        set(handles.BLabelGauss, 'Visible', 'off');
        set(handles.BLabel, 'Visible', 'on');
        set(handles.B, 'Visible', 'on');
        set(handles.CLabelPerPulse, 'Visible', 'off');
        set(handles.CLabelGauss, 'Visible', 'off');
        set(handles.CLabel, 'Visible', 'off');
        set(handles.C, 'Visible', 'off');
        set(handles.DutyLabel, 'Visible', 'off');
        set(handles.Duty, 'Visible', 'off');
        set(handles.PreviewEq, 'String', 'ydata = A*exp(B*xdata) + offset + ynoise');%Set preview of output equation
        %Set form of preview variable A in terms of input a
        indA = get(handles.ALabelExp, 'Value');
        string_listA = get(handles.ALabelExp,'String');
        labA = string_listA{indA};
        switch labA
            case 'Y Coeff'
                set(handles.PreviewA, 'Visible', 'on', 'String', 'A = a');
            case 'Phase (abs)'
                set(handles.PreviewA, 'Visible', 'on', 'String', 'A = exp(B*a)');
        end
        %Set form of preview variable B in terms of input b
        indB = get(handles.BLabelExp, 'Value');
        string_listB = get(handles.BLabelExp,'String');
        labB = string_listB{indB};
        switch labB
            case 'X Coeff'
                set(handles.PreviewB, 'Visible', 'on', 'String', 'B = b');
            case 'Time Const'
                set(handles.PreviewB, 'Visible', 'on', 'String', 'B = 1/b');
        end
        set(handles.PreviewC, 'Visible', 'off');%Exponential function does not require this variable
    case 'Gaussian'
        set(handles.YNoiseLabelP, 'Visible', 'off');
        set(handles.YNoiseLabel, 'Visible', 'on');
        set(handles.YNoise, 'Visible', 'on');
        set(handles.ShapeLabel, 'Visible', 'off');
        set(handles.Shape, 'Visible', 'off');
        set(handles.ALabelPer, 'Visible', 'off');
        set(handles.ALabelPulse, 'Visible', 'off');
        set(handles.ALabelExp, 'Visible', 'off');
        set(handles.ALabelGauss, 'Visible', 'on');
        set(handles.ALabel, 'Visible', 'on');
        set(handles.A, 'Visible', 'on');
        set(handles.BLabelPerPulse, 'Visible', 'off');
        set(handles.BLabelExp, 'Visible', 'off');
        set(handles.BLabelGauss, 'Visible', 'on');
        set(handles.BLabel, 'Visible', 'on');
        set(handles.B, 'Visible', 'on');
        set(handles.CLabelPerPulse, 'Visible', 'off');
        set(handles.CLabelGauss, 'Visible', 'on');
        set(handles.CLabel, 'Visible', 'on');
        set(handles.C, 'Visible', 'on');
        set(handles.DutyLabel, 'Visible', 'off');
        set(handles.Duty, 'Visible', 'off');
        set(handles.PreviewEq, 'String', 'ydata = A*(1/(B*sqrt(2*pi)))*exp(-(1/2)*((xdata - C)/B).^2) + offset + ynoise');%Set preview of output equation
        %Set form of preview variable A in terms of input a
        indA = get(handles.ALabelGauss, 'Value');
        string_listA = get(handles.ALabelGauss,'String');
        labA = string_listA{indA};
        switch labA
            case 'Area Under'
                set(handles.PreviewA, 'Visible', 'on', 'String', 'A = a');
            case 'Peak Value'
                set(handles.PreviewA, 'Visible', 'on', 'String', 'A = sqrt(2*pi)*B*a');
        end
        %Set form of preview variable B in terms of input b
        indB = get(handles.BLabelGauss, 'Value');
        string_listB = get(handles.BLabelGauss,'String');
        labB = string_listB{indB};
        switch labB
            case 'Std Dev'
                set(handles.PreviewB, 'Visible', 'on', 'String', 'B = b');
            case 'FWHM'
                set(handles.PreviewB, 'Visible', 'on', 'String', 'B = (1/(2*sqrt(2*log(2))))*b');
            case 'HWHM'
                set(handles.PreviewB, 'Visible', 'on', 'String', 'B = (1/(4*sqrt(2*log(2))))*b');
            case 'Variance'
                set(handles.PreviewB, 'Visible', 'on', 'String', 'B = sqrt(b)');
            case 'Precision'
                set(handles.PreviewB, 'Visible', 'on', 'String', 'B = sqrt(1/b)');
        end
        set(handles.PreviewC, 'Visible', 'on', 'String', 'C = c');%Set form of preview variable C in terms of input c
    case 'Noise'
        set(handles.YNoiseLabelP, 'Visible', 'off');
        set(handles.YNoiseLabel, 'Visible', 'on');
        set(handles.YNoise, 'Visible', 'on');
        set(handles.ShapeLabel, 'Visible', 'off');
        set(handles.Shape, 'Visible', 'off');
        set(handles.ALabelPer, 'Visible', 'off');
        set(handles.ALabelPulse, 'Visible', 'off');
        set(handles.ALabelExp, 'Visible', 'off');
        set(handles.ALabelGauss, 'Visible', 'off');
        set(handles.ALabel, 'Visible', 'off');
        set(handles.A, 'Visible', 'off');
        set(handles.BLabelPerPulse, 'Visible', 'off');
        set(handles.BLabelExp, 'Visible', 'off');
        set(handles.BLabelGauss, 'Visible', 'off');
        set(handles.BLabel, 'Visible', 'off');
        set(handles.B, 'Visible', 'off');
        set(handles.CLabelPerPulse, 'Visible', 'off');
        set(handles.CLabelGauss, 'Visible', 'off');
        set(handles.CLabel, 'Visible', 'off');
        set(handles.C, 'Visible', 'off');
        set(handles.DutyLabel, 'Visible', 'off');
        set(handles.Duty, 'Visible', 'off');
        set(handles.PreviewEq, 'String', 'ynoise = value*randn(1,npts)');%Set preview of output equation
        %Noise generator does not require these variables
        set(handles.PreviewA, 'Visible', 'off');
        set(handles.PreviewB, 'Visible', 'off');
        set(handles.PreviewC, 'Visible', 'off');
end

% --- Executes during object creation, after setting all properties.
function Function_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Function (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Value', 1)%Default Function type is 'Periodic'



% --- Executes during object creation, after setting all properties.
function OffsetLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OffsetLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function Offset_Callback(hObject, eventdata, handles)
% hObject    handle to Offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function Offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', '0')%Default Offset is zero


% --- Executes on selection change in YNoiseLabelP.
function YNoiseLabelP_Callback(hObject, eventdata, handles)
% hObject    handle to YNoiseLabelP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function YNoiseLabelP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YNoiseLabelP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Visible', 'on');
set(hObject, 'Value', 2)%Default for Periodic/Pulse Function is 'Noise (%)'

% --- Executes during object creation, after setting all properties.
function YNoiseLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YNoiseLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Visible', 'off');

function YNoise_Callback(hObject, eventdata, handles)
% hObject    handle to YNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function YNoise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Visible', 'on');
set(hObject, 'String', '0')%Default Y Noise is zero



% --- Executes during object creation, after setting all properties.
function ShapeLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ShapeLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Visible', 'on');

% --- Executes on selection change in Shape.
function Shape_Callback(hObject, eventdata, handles)
% hObject    handle to Shape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = get(hObject, 'Value');
string_list = get(hObject,'String');
val = string_list{ind};
switch val
    case 'Sinusoidal'
        set(handles.PreviewEq, 'String', 'ydata = A*sin(B*xdata + C) + offset + ynoise');
    case 'Triangle'
        set(handles.PreviewEq, 'String', 'ydata = A*triangle(B*xdata + C) + offset + ynoise');
    case 'Sawtooth'
        set(handles.PreviewEq, 'String', 'ydata = A*sawtooth(B*xdata + C) + offset + ynoise');
    case 'Square'
        set(handles.PreviewEq, 'String', 'ydata = A*square(B*xdata + C) + offset + ynoise');
end

% --- Executes during object creation, after setting all properties.
function Shape_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Shape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Visible', 'on');
set(hObject, 'Value', 1)%Default Shape is 'Sinusoidal'



% --- Executes on selection change in ALabelPer.
function ALabelPer_Callback(hObject, eventdata, handles)
% hObject    handle to ALabelPer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = get(handles.ALabelPer, 'Value');
string_list = get(handles.ALabelPer,'String');
lab = string_list{ind};
switch lab
    case 'Amp'
        set(handles.PreviewA, 'String', 'A = a');
    case 'P2P'
        set(handles.PreviewA, 'String', 'A = .5*a');
    case 'RMS'
        set(handles.PreviewA, 'String', 'A = a*sqrt(2)');
end

% --- Executes during object creation, after setting all properties.
function ALabelPer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ALabelPer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Visible', 'on');
set(hObject, 'Value', 1)%Default parameter A of Periodic Function is 'Amp'

% --- Executes during object creation, after setting all properties.
function ALabelPulse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ALabelPulse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Visible', 'off');

% --- Executes on selection change in ALabelExp.
function ALabelExp_Callback(hObject, eventdata, handles)
% hObject    handle to ALabelExp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = get(handles.ALabelExp, 'Value');
string_list = get(handles.ALabelExp,'String');
lab = string_list{ind};
switch lab
    case 'Y Coeff'
        set(handles.PreviewA, 'String', 'A = a');
    case 'Phase (abs)'
        set(handles.PreviewA, 'String', 'A = exp(B*a)');
end

% --- Executes during object creation, after setting all properties.
function ALabelExp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ALabelExp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Visible', 'off');
set(hObject, 'Value', 1)%Default parameter A of Exponential Function is 'Y Coeff'

% --- Executes on selection change in ALabelGauss.
function ALabelGauss_Callback(hObject, eventdata, handles)
% hObject    handle to ALabelGauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = get(handles.ALabelGauss, 'Value');
string_list = get(handles.ALabelGauss,'String');
lab = string_list{ind};
switch lab
    case 'Area Under'
        set(handles.PreviewA, 'String', 'A = a');
    case 'Peak Value'
        set(handles.PreviewA, 'String', 'A = sqrt(2*pi)*B*a');
end

% --- Executes during object creation, after setting all properties.
function ALabelGauss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ALabelGauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Visible', 'off');
set(hObject, 'Value', 1)%Default parameter A of Gaussian Function is 'Area Under'

function A_Callback(hObject, eventdata, handles)

% hObject    handle to A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Visible', 'on');
set(hObject, 'String', '1')%Default value of parameter A is 1



% --- Executes on selection change in BLabelPerPulse.
function BLabelPerPulse_Callback(hObject, eventdata, handles)
% hObject    handle to BLabelPerPulse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = get(handles.BLabelPerPulse, 'Value');
string_list = get(handles.BLabelPerPulse,'String');
lab = string_list{ind};
switch lab
    case 'Freq (Hz)'
        set(handles.PreviewB, 'String', 'B = 2*pi*b');
    case 'Ang Freq'
        set(handles.PreviewB, 'String', 'B = b');
    case 'Period'
        set(handles.PreviewB, 'String', 'B = 2*pi/b');
    case '# Cycles'
        set(handles.PreviewB, 'String', 'B = 2*pi*b/(xmax-xmin)');
end

% --- Executes during object creation, after setting all properties.
function BLabelPerPulse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BLabelPerPulse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Visible', 'on');
set(hObject, 'Value', 1)%Default parameter B of Periodic/Pulse Function is 'Freq (Hz)'

% --- Executes on selection change in BLabelExp.
function BLabelExp_Callback(hObject, eventdata, handles)
% hObject    handle to BLabelExp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = get(handles.BLabelExp, 'Value');
string_list = get(handles.BLabelExp,'String');
lab = string_list{ind};
switch lab
    case 'X Coeff'
        set(handles.PreviewB, 'String', 'B = b');
    case 'Time Const'
        set(handles.PreviewB, 'String', 'B = 1/b');
end

% --- Executes during object creation, after setting all properties.
function BLabelExp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BLabelExp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Visible', 'off');
set(hObject, 'Value', 1)%Default parameter B value of Exponential Function is 'X Coeff'

% --- Executes on selection change in BLabelGauss.
function BLabelGauss_Callback(hObject, eventdata, handles)
% hObject    handle to BLabelGauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = get(handles.BLabelGauss, 'Value');
string_list = get(handles.BLabelGauss,'String');
lab = string_list{ind};
switch lab
    case 'Std Dev'
        set(handles.PreviewB, 'String', 'B = b');
    case 'FWHM'
        set(handles.PreviewB, 'String', 'B = (1/(2*sqrt(2*log(2))))*b');
    case 'HWHM'
        set(handles.PreviewB, 'String', 'B = (1/(4*sqrt(2*log(2))))*b');
    case 'Variance'
        set(handles.PreviewB, 'String', 'B = sqrt(b)');
    case 'Precision'
        set(handles.PreviewB, 'String', 'B = sqrt(1/b)');
end

% --- Executes during object creation, after setting all properties.
function BLabelGauss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BLabelGauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Visible', 'off');
set(hObject, 'Value', 2)%Default parameter B of Gaussian Function is 'FWHM'

function B_Callback(hObject, eventdata, handles)
% hObject    handle to B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Visible', 'on');
set(hObject, 'String', '1')%Default parameter B value is 1



% --- Executes on selection change in CLabelPerPulse.
function CLabelPerPulse_Callback(hObject, eventdata, handles)
% hObject    handle to CLabelPerPulse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = get(handles.CLabelPerPulse, 'Value');
string_list = get(handles.CLabelPerPulse,'String');
lab = string_list{ind};
switch lab
    case 'Phase (rad)'
        set(handles.PreviewC, 'String', 'C = c');
    case 'Phase (deg)'
        set(handles.PreviewC, 'String', 'C = (2*pi/360)*c');
    case 'Phase (%)'
        set(handles.PreviewC, 'String', 'C = (2*pi/100)*c');
    case 'Phase (abs)'
        set(handles.PreviewC, 'String', 'C = 2*pi*c');
end

% --- Executes during object creation, after setting all properties.
function CLabelPerPulse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CLabelPerPulse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Visible', 'on');
set(hObject, 'Value', 1)%Default parameter C of Periodic/Pulse Function is 'Phase (rad)'

% --- Executes during object creation, after setting all properties.
function CLabelGauss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CLabelGauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Visible', 'off');

function C_Callback(hObject, eventdata, handles)
% hObject    handle to C (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function C_CreateFcn(hObject, eventdata, handles)
% hObject    handle to C (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Visible', 'on');
set(hObject, 'String', '0')%Default parameter C value is zero



% --- Executes on selection change in DutyLabel.
function DutyLabel_Callback(hObject, eventdata, handles)
% hObject    handle to DutyLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function DutyLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DutyLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Visible', 'off');
set(hObject, 'Value', 1)%Default for Pulse Function is 'Duty (%)'

function Duty_Callback(hObject, eventdata, handles)
% hObject    handle to Duty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = str2num(get(hObject, 'String'));
lab = get(handles.DutyLabel, 'Value');
switch lab
    case 'Duty (%)'
    case 'Duty (deg)'
    case 'Duty (rad)'
end

% --- Executes during object creation, after setting all properties.
function Duty_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Duty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 set(hObject, 'Visible', 'off');
 set(hObject, 'String', '50')%Default Duty value is 50%



function PreviewEq_Callback(hObject, eventdata, handles)
% hObject    handle to PreviewEq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PreviewEq as text
%        str2double(get(hObject,'String')) returns contents of PreviewEq as a double


% --- Executes during object creation, after setting all properties.
function PreviewEq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PreviewEq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', 'ydata = A*sin(B*xdata + C) + offset + ynoise');



function PreviewA_Callback(hObject, eventdata, handles)
% hObject    handle to PreviewA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PreviewA as text
%        str2double(get(hObject,'String')) returns contents of PreviewA as a double


% --- Executes during object creation, after setting all properties.
function PreviewA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PreviewA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', 'A = a');



function PreviewB_Callback(hObject, eventdata, handles)
% hObject    handle to PreviewB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PreviewB as text
%        str2double(get(hObject,'String')) returns contents of PreviewB as a double


% --- Executes during object creation, after setting all properties.
function PreviewB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PreviewB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', 'B = 2*pi*b');



function PreviewC_Callback(hObject, eventdata, handles)
% hObject    handle to PreviewC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PreviewC as text
%        str2double(get(hObject,'String')) returns contents of PreviewC as a double


% --- Executes during object creation, after setting all properties.
function PreviewC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PreviewC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', 'C = c');


% --- Executes on selection change in Plot.
function Plot_Callback(hObject, eventdata, handles)
% hObject    handle to Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Plot contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Plot


% --- Executes during object creation, after setting all properties.
function Plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Value', 1);%Default "Plot" setting is "New Figure"



function varargout = StabilityAnalyzerGUI(varargin)
% STABILITYANALYZERGUI MATLAB code for StabilityAnalyzerGUI.fig
%      STABILITYANALYZERGUI, by itself, creates a new STABILITYANALYZERGUI or raises the existing
%      singleton*.
%
%      H = STABILITYANALYZERGUI returns the handle to a new STABILITYANALYZERGUI or the handle to
%      the existing singleton*.
%
%      STABILITYANALYZERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STABILITYANALYZERGUI.M with the given input arguments.
%
%      STABILITYANALYZERGUI('Property','Value',...) creates a new STABILITYANALYZERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StabilityAnalyzerGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StabilityAnalyzerGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StabilityAnalyzerGUI

% Last Modified by GUIDE v2.5 16-Jul-2012 14:52:05

% Begin initialization code - DO NOT EDIT
%******************************************************************************************************************************
%To use this program refer to the User guide word document included in the
%Stability Analyzer 53230A program folder
%For questions or feedback on the program contact me at neil underscore
%forcier at agilent dot com
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StabilityAnalyzerGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @StabilityAnalyzerGUI_OutputFcn, ...
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
end

% --- Executes just before StabilityAnalyzerGUI is made visible.
function StabilityAnalyzerGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to StabilityAnalyzerGUI (see VARARGIN)

% Choose default command line output for StabilityAnalyzerGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes StabilityAnalyzerGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%code to setup plot labels
 xlabel(handles.freqVsTimePlot,'Seconds'); %x axis label
 ylabel(handles.freqVsTimePlot,'Hertz'); %y axis label
 title(handles.freqVsTimePlot,'Time vs Frequency'); %add title to plot
 title(handles.freqHisto,'Frequency Histogram'); %add title to plot
 xlabel(handles.freqHisto,'Hertz'); %x axis label
 ylabel(handles.freqHisto,'Bin Count'); %y axis label
 title(handles.devPlot,'Stability Plot'); %add title to plot
 xlabel(handles.devPlot,'Tau'); %x axis label
 ylabel(handles.devPlot,'Sigma'); %y axis label
 grid on
 
 %Csv vs 53230 parameter selection, hide and show
 if get(handles.toggleMeasSource,'Value')== get(handles.toggleMeasSource,'Min')
    set(handles.toggleMeasSource,'String','Using 53230A Counter');
    set(handles.getMeas,'String', 'IP: 555.555.555.555');
    set(handles.toggleInputZ,'Visible','On');
    set(handles.measCount,'Visible','On');
    set(handles.text9,'Visible','On');
    set(handles.text8,'String','53230A IP Address');
 else
    set(handles.toggleMeasSource,'String','Using Meas from CSV');
    set(handles.getMeas,'String', 'Enter Measurement CSV Path');
    set(handles.text8,'String','CSV File Path');
    set(handles.toggleInputZ,'Visible','Off');
    set(handles.measCount,'Visible','Off');
    set(handles.text9,'Visible','Off');
 end

 button_state = get(handles.tauToggle,'Value');
if button_state == get(handles.tauToggle,'Max')
	% Toggle button is pressed-take appropriate action
    set(handles.tauToggle,'String','Using Tau CSV');
   set(handles.tauArrayPath,'Visible','On');
    set(handles.enterStartTau,'Visible','Off');
    set(handles.enterIncrTau,'Visible','Off');
    set(handles.enterStopTau,'Visible','Off');
    set(handles.text4,'Visible','Off');
    set(handles.text5,'Visible','Off');
    set(handles.text6,'Visible','Off');
else
	% Toggle button is not pressed-take appropriate action
    set(handles.tauToggle,'String','Specify Tau Array');
    set(handles.tauArrayPath,'Visible','Off');
    set(handles.enterStartTau,'Visible','On');
    set(handles.enterIncrTau,'Visible','On');
    set(handles.enterStopTau,'Visible','On');
    set(handles.text4,'Visible','On');
    set(handles.text5,'Visible','On');
    set(handles.text6,'Visible','On');
end
 
 readStoredParameters(handles);
end


% --- Outputs from this function are returned to the command line.
function varargout = StabilityAnalyzerGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in goAnalysis.
function goAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to goAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

format long;%long format for displaying numbers

%call function for fetching readings from either CSV file or 53230A
if get(handles.toggleMeasSource,'Value')== get(handles.toggleMeasSource,'Max')
    readings = getReadings(get(handles.getMeas,'String'));
    if readings == -42881
           return;
    end
    mCount = length(readings);
    if mCount < 2 %verify there are enough measurements
        uiwait(msgbox('Not enough readings','Error Message','error'));
        return;
    end
else
    mCount = str2double(get(handles.measCount,'String'));
end

%get sample period of frequency readings
sPeriod = str2double(get(handles.enterSamplePeriod,'String'));
if sPeriod <= 0
    uiwait(msgbox('Invalid sample period','Error Message','error'));
    return;
end
    
%get tau array either from UI or stored CSV
if get(handles.tauToggle,'Value')== get(handles.tauToggle,'Max')
    tau = getCSVTauArray(get(handles.tauArrayPath,'String'));%get tau array from CSV file
       if tau == -42881
           return;
       end
else
     tau = str2double(get(handles.enterStartTau,'String')):str2double(get(handles.enterIncrTau,'String')):str2double(get(handles.enterStopTau,'String')); %create array of tau values
end

if isempty(tau)%make sure tau array is not empty
    uiwait(msgbox('Tau array is empty','Error Message','error'));
    return;
end

tMin = min(tau); %get min tau value 
if tMin < sPeriod
    uiwait(msgbox('Tau value is less than sample period','Error Message','error'));
    return;
end

tMax = max(tau);
rTime = sPeriod*mCount;
%Max Tau must be 1/2 or less than total measurement time
if tMax > (rTime/2)
    uiwait(msgbox('Max Tau value must be 1/2 or less than total measurement time','Error Message','error'));
    return;
end

 %if 53230A is being used time to connect and make measurements
 if get(handles.toggleMeasSource,'Value')== get(handles.toggleMeasSource,'Min')
        %get the set value for counter input Z
        if get(handles.toggleInputZ,'Value') == get(handles.toggleInputZ,'Max')
            Z = 50;
        else
            Z = 1e6;
        end
        
        if mCount > 1e6 || mCount < 2
            uiwait(msgbox('Measure count must be between 2 and 1e6','Error Message','error'));
            return;
        end
            %char(tauFilePath)
        iP = get(handles.getMeas,'String');
        readings =  talkTo53230A((1/str2double(get(handles.enterSamplePeriod,'String'))),mCount,iP,Z); 
        if readings == -42881 %if instr connection failed exit 
           return;
       end
 end
 
 %get ref freq from edit box or from mean of readings
 if get(handles.toggleRefFreq,'Value')== get(handles.toggleRefFreq,'Max')
     refFreq = mean(readings);
     set(handles.refFreq,'String', num2str(refFreq));
 else
     refFreq = str2double(get(handles.refFreq,'String'));
 end
 
 %store parameters in a csv to use next time
 storeParameters(str2double(get(handles.enterStartTau,'String')), str2double(get(handles.enterIncrTau,'String')), str2double(get(handles.enterStopTau,'String')), sPeriod, refFreq);
        
 %remove outliers from readings if checkbox is checked
 if get(handles.removeOutliers,'Value')== get(handles.removeOutliers,'Max')
    readings = removeOLMADx5(readings); %remove any outliers from readings
 end
 %remove offset from readings if checkbox is checked
 if get(handles.removeOffset,'Value')== get(handles.removeOffset,'Max')
    readings = removeOffset(readings,refFreq);%remove offset from array of readings
 end
 
%turn the frequency measurements into frac freq data
fFreadings = calculateFracFreq(refFreq,readings); %turn freq readings to frac freq values

%call function to determine stability calculation and execute it
stabArray = calculateStability(get(handles.listDev,'Value'),sPeriod,fFreadings,tau);
if stabArray == -42881 %if instr connection failed exit 
           return;
end
   
%call to determine noise types
alphaArray = calculateNoiseIDs(readings,tau,sPeriod); 

%call function for confidence interval calculations if checkbox is
%checked
if get(handles.showConfidenceInterval,'Value')== get(handles.showConfidenceInterval,'Max')
   [maxCI minCI] = calculateConfidenceInterval(tau, sPeriod, length(readings),alphaArray,stabArray);
else
   maxCI = 0;%if no confidence interval calculation
   minCI = 0;
end

 buildPlots(readings, stabArray, tau, handles, sPeriod,maxCI,minCI); %build the plots
end

%function to setup and build the plots
function buildPlots(readings, stabArray, tau, handles, sPeriod,maxCI,minCI)

    %build histogram plot 
    mN = min(readings); %get min value from array
    mX = max(readings);  %get max value from array
    iT = (mX-mN) / 100; %get iteration value for bin array
    bins = mN:iT:mX; %build histo bin array
    hist(handles.freqHisto,readings,bins); %create histogram
    set(handles.freqHisto,'XLim',[mN mX]); %set limit of x axis of histo
    xt = [mN (((mX-mN)/2)+mN) mX]; %array of x axis values
    set(handles.freqHisto,'XTick',xt); %add major grid ticks
    set(handles.freqHisto,'XTickLabel',num2str(xt(:),10)); %add value label for major tick
    title(handles.freqHisto,'Frequency Histogram'); %add title to plot
    xlabel(handles.freqHisto,'Hertz'); %x axis label
    ylabel(handles.freqHisto,'Bin Count'); %y axis label
    
    %variance / deviation log plot
    if maxCI(1) ~= 0 && minCI(1) ~= 0 %if confidence arrays are not empty then show them
        loglog(handles.devPlot,tau,stabArray,'-ob',tau,maxCI,'kv',tau,minCI,'k^','MarkerFaceColor','green','LineWidth',1);
    else
        loglog(handles.devPlot,tau,stabArray,'-ob','MarkerFaceColor','green','LineWidth',1);
    end
    %check if ADEV or HDEV for plot title
    if get(handles.listDev,'Value') == 1
        title(handles.devPlot,'Allan Deviation'); %add title to plot
    else
        title(handles.devPlot,'Hadamard Deviation'); %add title to plot
    end
    xlabel(handles.devPlot,'Tau'); %x axis label
    ylabel(handles.devPlot,'Sigma'); %y axis label
    grid on
    
    %build plot freq vs time
    cnt = numel(readings);
     x = sPeriod:sPeriod:(sPeriod*cnt);
    plot(handles.freqVsTimePlot,x, readings');
    title(handles.freqVsTimePlot,'Time vs Frequency'); %add title to plot
    xlabel(handles.freqVsTimePlot,'Seconds'); %x axis label
    ylabel(handles.freqVsTimePlot,'Hertz from Mean'); %y axis label
    xt(2) = mean(readings);
    set(handles.freqVsTimePlot,'YTick',xt); %add major grid ticks
    yf = [(xt(1)-xt(2)) 0 (xt(3)-xt(2))];
    set(handles.freqVsTimePlot,'YTickLabel',num2str(yf(:),5)); %add value label for major tick
end

%Used to fetch readings from csv file if fails error message
function readings = getReadings(csvPath)
    try
        readings = csvread(csvPath);
    catch exception
        uiwait(msgbox(exception.message,'Error Message','error'));
        readings = -42881; 
        rethrow(exception);
    end
end

%Used to determine selected file and fetch readings from file
function tau = getCSVTauArray(tauFilePath)
    try
        tau = csvread(char(tauFilePath)); %get data from csv file 
    catch exception
        uiwait(msgbox(exception.message,'Error Message','error'));
        tau = -42881; 
        rethrow(exception);
    end
end

%This function writes the currect parameters used including tau, sPeriod,
%ref freq to a csv file named parameters
function storeParameters(tStart, tInc, tStop, sPeriod, refFreq)
pArray = [sPeriod refFreq tStart tInc tStop]; %create parameter array
csvwrite('parameters.csv',pArray',0,0);
end

%Used to determine selected stability calculation and perform it
function stabArray = calculateStability(item,sPeriod,fFreadings,tau)
    if item == 1 %overlapping allan using phase data
         stabArray = timeADevCalculation(fFreadings, sPeriod, tau); 
    else %overlapping hadamard using phase data
       stabArray = hDevCalculation(fFreadings, sPeriod, tau); 
    end
end

function enterSamplePeriod_Callback(hObject, eventdata, handles)
% hObject    handle to enterSamplePeriod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enterSamplePeriod as text
%        str2double(get(hObject,'String')) returns contents of enterSamplePeriod as a double
end

% --- Executes during object creation, after setting all properties.
function enterSamplePeriod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enterSamplePeriod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function enterStartTau_Callback(hObject, eventdata, handles)
% hObject    handle to enterStartTau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enterStartTau as text
%        str2double(get(hObject,'String')) returns contents of enterStartTau as a double
end

% --- Executes during object creation, after setting all properties.
function enterStartTau_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enterStartTau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function enterIncrTau_Callback(hObject, eventdata, handles)
% hObject    handle to enterIncrTau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enterIncrTau as text
%        str2double(get(hObject,'String')) returns contents of enterIncrTau as a double
end

% --- Executes during object creation, after setting all properties.
function enterIncrTau_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enterIncrTau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function enterStopTau_Callback(hObject, eventdata, handles)
% hObject    handle to enterStopTau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enterStopTau as text
%        str2double(get(hObject,'String')) returns contents of enterStopTau as a double
end

% --- Executes during object creation, after setting all properties.
function enterStopTau_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enterStopTau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in tauToggle.
function tauToggle_Callback(hObject, eventdata, handles)
% hObject    handle to tauToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
	% Toggle button is pressed-take appropriate action
    set(hObject,'String','Using Tau CSV');
   set(handles.tauArrayPath,'Visible','On');
    set(handles.enterStartTau,'Visible','Off');
    set(handles.enterIncrTau,'Visible','Off');
    set(handles.enterStopTau,'Visible','Off');
    set(handles.text4,'Visible','Off');
    set(handles.text5,'Visible','Off');
    set(handles.text6,'Visible','Off');
elseif button_state == get(hObject,'Min')
	% Toggle button is not pressed-take appropriate action
    set(hObject,'String','Specify Tau Array');
    set(handles.tauArrayPath,'Visible','Off');
    set(handles.enterStartTau,'Visible','On');
    set(handles.enterIncrTau,'Visible','On');
    set(handles.enterStopTau,'Visible','On');
    set(handles.text4,'Visible','On');
    set(handles.text5,'Visible','On');
    set(handles.text6,'Visible','On');
end
% Hint: get(hObject,'Value') returns toggle state of tauToggle
end


function tauArrayPath_Callback(hObject, eventdata, handles)
% hObject    handle to tauArrayPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tauArrayPath as text
%        str2double(get(hObject,'String')) returns contents of tauArrayPath as a double
end

% --- Executes during object creation, after setting all properties.
function tauArrayPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tauArrayPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in showConfidenceInterval.
function showConfidenceInterval_Callback(hObject, eventdata, handles)
% hObject    handle to showConfidenceInterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showConfidenceInterval
end

% --- Executes on button press in removeOutliers.
function removeOutliers_Callback(hObject, eventdata, handles)
% hObject    handle to removeOutliers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of removeOutliers
end

% --- Executes on button press in removeOffset.
function removeOffset_Callback(hObject, eventdata, handles)
% hObject    handle to removeOffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of removeOffset
end


function refFreq_Callback(hObject, eventdata, handles)
% hObject    handle to refFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of refFreq as text
%        str2double(get(hObject,'String')) returns contents of refFreq as a double
end

% --- Executes during object creation, after setting all properties.
function refFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to refFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in toggleRefFreq.
function toggleRefFreq_Callback(hObject, eventdata, handles)
% hObject    handle to toggleRefFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
	% Toggle button is pressed-take appropriate action
    set(hObject,'String','Using Meas Mean');
elseif button_state == get(hObject,'Min')
	% Toggle button is not pressed-take appropriate action
    set(hObject,'String','Using Ref Freq');
end
% Hint: get(hObject,'Value') returns toggle state of toggleRefFreq
end


function getMeas_Callback(hObject, eventdata, handles)
% hObject    handle to getMeas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of getMeas as text
%        str2double(get(hObject,'String')) returns contents of getMeas as a double
end

% --- Executes during object creation, after setting all properties.
function getMeas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to getMeas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in toggleInputZ.
function toggleInputZ_Callback(hObject, eventdata, handles)
% hObject    handle to toggleInputZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
	% Toggle button is pressed-take appropriate action
    set(hObject,'String','50 Ohm');
elseif button_state == get(hObject,'Min')
	% Toggle button is not pressed-take appropriate action
    set(hObject,'String','High Z');
end
% Hint: get(hObject,'Value') returns toggle state of toggleInputZ
end


function measCount_Callback(hObject, eventdata, handles)
% hObject    handle to measCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of measCount as text
%        str2double(get(hObject,'String')) returns contents of measCount as a double
end

% --- Executes during object creation, after setting all properties.
function measCount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to measCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in toggleMeasSource.
function toggleMeasSource_Callback(hObject, eventdata, handles)
% hObject    handle to toggleMeasSource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Min')
	% Toggle button is pressed-take appropriate action
    set(hObject,'String','Using 53230A Counter');
    set(handles.getMeas,'String', 'IP: 555.555.555.555');
    set(handles.toggleInputZ,'Visible','On');
    set(handles.measCount,'Visible','On');
    set(handles.text9,'Visible','On');
    set(handles.text8,'String','53230A IP Address');
else
	% Toggle button is not pressed-take appropriate action
    set(hObject,'String','Using Meas from CSV');
    set(handles.getMeas,'String', 'Enter Measurement CSV Path');
    set(handles.text8,'String','CSV File Path');
    set(handles.toggleInputZ,'Visible','Off');
    set(handles.measCount,'Visible','Off');
    set(handles.text9,'Visible','Off');
end
% Hint: get(hObject,'Value') returns toggle state of toggleMeasSource
end


% --- Executes on selection change in listDev.
function listDev_Callback(hObject, eventdata, handles)
% hObject    handle to listDev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listDev contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listDev
end

% --- Executes during object creation, after setting all properties.
function listDev_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listDev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%This function reads the previous used parameters from csv parameters and
%stores them in the proper text field
function readStoredParameters(handles)
fail = 0;

try %try to read the csv file if fail then do no other reads
    sPeriod = csvread('parameters.csv',0,0,[0 0 0 0]);
catch exception
    sPeriod = .01;
    fail = 1;
end

if fail == 0 %if first csv read did not fail then try the rest
    try
        rFreq = csvread('parameters.csv',1,0,[1 0 1 0]);
    catch exception
        rFreq = 10e6;
    end

    try
        startTau = csvread('parameters.csv',2,0,[2 0 2 0]);
    catch exception
        startTau = .01;
    end

    try
        incrTau = csvread('parameters.csv',3,0,[3 0 3 0]);
    catch exception
        incrTau = .01;
    end

    try
        stopTau = csvread('parameters.csv',4,0,[4 0 4 0]);
    catch exception
        stopTau = 1;
    end
else %no csv file so set to defaults
    rFreq = 10e6;
    startTau = .01;
    incrTau = .01;
     stopTau = 1;
end
%the following set functions add the parameters to the UI edit text boxes
set(handles.enterSamplePeriod,'String', num2str(sPeriod));
set(handles.refFreq,'String', num2str(rFreq));
set(handles.enterStartTau,'String', num2str(startTau));
set(handles.enterIncrTau,'String', num2str(incrTau));
set(handles.enterStopTau,'String', num2str(stopTau));

end

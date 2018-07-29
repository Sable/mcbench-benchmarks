function varargout = optionpricegui2(varargin)
% OPTIONPRICEGUI2 M-file for optionpricegui2.fig
%      OPTIONPRICEGUI2, by itself, creates a new OPTIONPRICEGUI2 or raises the existing
%      singleton*.
%
%      H = OPTIONPRICEGUI2 returns the handle to a new OPTIONPRICEGUI2 or the handle to
%      the existing singleton*.
%
%      OPTIONPRICEGUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPTIONPRICEGUI2.M with the given input arguments.
%
%      OPTIONPRICEGUI2('Property','Value',...) creates a new OPTIONPRICEGUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before optionpricegui2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to optionpricegui2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help optionpricegui2

% Last Modified by GUIDE v2.5 14-Aug-2008 14:18:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @optionpricegui2_OpeningFcn, ...
    'gui_OutputFcn',  @optionpricegui2_OutputFcn, ...
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
end
% End initialization code - DO NOT EDIT


% --- Executes just before optionpricegui2 is made visible.
function optionpricegui2_OpeningFcn(hObject, eventdata, handles, varargin)%#ok
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to optionpricegui2 (see VARARGIN)

% Choose default command line output for optionpricegui2
handles.output = hObject;

set(handles.editStart, 'String', datestr(today, 2))
set(handles.editEnd, 'String', datestr(today + 91, 2))

handles = runSimulation(handles);

% This is an awkward place to put the rotate3d command.  If you place it in
% the runSimulation function, however, it tends to toggle rotate3d on and
% off after each simulation.  Here, it gets set to "on" once and stays that
% way.
rotate3d(handles.surfAxes)

% Update handles structure
guidata(hObject, handles);
end

% UIWAIT makes optionpricegui2 wait for user response (see UIRESUME)
% uiwait(handles.mainFigure);


% --- Outputs from this function are returned to the command line.
function varargout = optionpricegui2_OutputFcn(hObject, eventdata, handles) %#ok
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end



function editSpot_Callback(hObject, eventdata, handles)%#ok
% hObject    handle to editSpot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSpot as text
%        str2double(get(hObject,'String')) returns contents of editSpot as a double
end

% --- Executes during object creation, after setting all properties.
function editSpot_CreateFcn(hObject, eventdata, handles)%#ok
% hObject    handle to editSpot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editStrike_Callback(hObject, eventdata, handles)%#ok
% hObject    handle to editStrike (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStrike as text
%        str2double(get(hObject,'String')) returns contents of editStrike as a double
end

% --- Executes during object creation, after setting all properties.
function editStrike_CreateFcn(hObject, eventdata, handles)%#ok
% hObject    handle to editStrike (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editRFR_Callback(hObject, eventdata, handles)%#ok
% hObject    handle to editRFR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRFR as text
%        str2double(get(hObject,'String')) returns contents of editRFR as a double
end

% --- Executes during object creation, after setting all properties.
function editRFR_CreateFcn(hObject, eventdata, handles)%#ok
% hObject    handle to editRFR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editStart_Callback(hObject, eventdata, handles)%#ok
% hObject    handle to editStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStart as text
%        str2double(get(hObject,'String')) returns contents of editStart as a double
end

% --- Executes during object creation, after setting all properties.
function editStart_CreateFcn(hObject, eventdata, handles)%#ok
% hObject    handle to editStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editEnd_Callback(hObject, eventdata, handles)%#ok
% hObject    handle to editEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editEnd as text
%        str2double(get(hObject,'String')) returns contents of editEnd as a double
end

% --- Executes during object creation, after setting all properties.
function editEnd_CreateFcn(hObject, eventdata, handles)%#ok
% hObject    handle to editEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editVol_Callback(hObject, eventdata, handles)%#ok
% hObject    handle to editVol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editVol as text
%        str2double(get(hObject,'String')) returns contents of editVol as a double
end

% --- Executes during object creation, after setting all properties.
function editVol_CreateFcn(hObject, eventdata, handles)%#ok
% hObject    handle to editVol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editYield_Callback(hObject, eventdata, handles)%#ok
% hObject    handle to editYield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editYield as text
%        str2double(get(hObject,'String')) returns contents of editYield as a double
end

% --- Executes during object creation, after setting all properties.
function editYield_CreateFcn(hObject, eventdata, handles)%#ok
% hObject    handle to editYield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function editIter_Callback(hObject, eventdata, handles)%#ok
% hObject    handle to editIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editIter as text
%        str2double(get(hObject,'String')) returns contents of editIter as a double
end

% --- Executes during object creation, after setting all properties.
function editIter_CreateFcn(hObject, eventdata, handles)%#ok
% hObject    handle to editIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function editValue_Callback(hObject, eventdata, handles)%#ok
% hObject    handle to editValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editValue as text
%        str2double(get(hObject,'String')) returns contents of editValue as a double
end

% --- Executes during object creation, after setting all properties.
function editValue_CreateFcn(hObject, eventdata, handles)%#ok
% hObject    handle to editValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)%#ok
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

% Some options only require a single strike price; others, two.  The
% butterfly option requires one strike price and a spread.
contents = get(hObject,'String');
switch contents{get(hObject,'Value')}
    case {'Call' 'Put' 'Straddle'}
        handles = oneStrike(handles);
    case {'Strangle' 'Bull Spread' 'Bear Spread'}
        handles = twoStrikes(handles);
    case {'Butterfly'}
        handles = butterfly(handles);
end
guidata(hObject, handles);
end
% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)%#ok
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editStrike1_Callback(hObject, eventdata, handles)%#ok
% hObject    handle to editStrike1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStrike1 as text
%        str2double(get(hObject,'String')) returns contents of editStrike1 as a double
end

% --- Executes during object creation, after setting all properties.
function editStrike1_CreateFcn(hObject, eventdata, handles)%#ok
% hObject    handle to editStrike1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editStrike2_Callback(hObject, eventdata, handles)%#ok
% hObject    handle to editStrike2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStrike2 as text
%        str2double(get(hObject,'String')) returns contents of editStrike2 as a double
end

% --- Executes during object creation, after setting all properties.
function editStrike2_CreateFcn(hObject, eventdata, handles)%#ok
% hObject    handle to editStrike2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function editSpread_Callback(hObject, eventdata, handles)%#ok
% hObject    handle to editSpread (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSpread as text
%        str2double(get(hObject,'String')) returns contents of editSpread as a double
end

% --- Executes during object creation, after setting all properties.
function editSpread_CreateFcn(hObject, eventdata, handles)%#ok
% hObject    handle to editSpread (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in buttonRun.
function buttonRun_Callback(hObject, eventdata, handles)%#ok
% hObject    handle to buttonRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = runSimulation(handles);
guidata(hObject, handles);
end


% --- Helper functions follow ---
% --- oneStrike, twoStrikes: toggle between displaying one and two strike
% prices in the UI panel ---
function handles = oneStrike(handles)
set(handles.text3, 'String', 'Strike Price')
set(handles.editStrike, 'Visible', 'on')
set(handles.editStrike1, 'Visible', 'off')
set(handles.editStrike2, 'Visible', 'off')
set(handles.editSpread, 'Visible', 'off')
set(handles.text11, 'Visible', 'off')
end

function handles = twoStrikes(handles)
set(handles.text3, 'String', 'Strike Prices')
set(handles.editStrike, 'Visible', 'off')
set(handles.editStrike1, 'Visible', 'on')
set(handles.editStrike2, 'Visible', 'on')
set(handles.editSpread, 'Visible', 'off')
set(handles.text11, 'Visible', 'off')
end

function handles = butterfly(handles)
set(handles.text3, 'String', 'Strike Price')
set(handles.editStrike, 'Visible', 'on')
set(handles.editStrike1, 'Visible', 'off')
set(handles.editStrike2, 'Visible', 'off')
set(handles.editSpread, 'Visible', 'on')
set(handles.text11, 'Visible', 'on')
end

%--- runSimulation: the main control program for the code ---
function handles = runSimulation(handles)
% This function has four steps:
% Step 1: Collect inputs and find option value
% Step 2: Plot the option value surface
% Step 3: Run a Monte Carlo simulation
% Step 4: Plot the Monte Carlo simulation
%
% In addition, there are two nested functions that allow you to incorporate
% a WindowButtonMotionFcn and a WindowButtonDownFcn on the Monte Carlo
% Paths axes.

% Step 1: Collect inputs and find option value
try
    spot = str2double(get(handles.editSpot, 'String'));
    rate = str2double(get(handles.editRFR, 'String'));
    vol  = str2double(get(handles.editVol, 'String'));
    yield= str2double(get(handles.editYield, 'String'));
    type = get(handles.popupmenu1,'String');
    type = type{get(handles.popupmenu1,'Value')};

    % No harm in getting Strike2 and Spread, even if they aren't used.
    strike2 = str2double(get(handles.editStrike2, 'String'));
    spread  = str2double(get(handles.editSpread, 'String'));

    startDate = get(handles.editStart, 'String');
    endDate = get(handles.editEnd, 'String');
    % I only include this extra TRY/CATCH loop in order to provide a better
    % error message if the invalid dates are applied: YEARFRAC itself will
    % do all of the appropriate error checking.
    try
        time = yearfrac(startDate, endDate);
    catch %#ok<CTCH>
        error('optionPriceGui:InvalidDates', ...
            'Dates must be in a valid format')
    end

    iter = str2double(get(handles.editIter, 'String'));
    if int32(iter) ~= iter || iter <= 0
        error('optionPriceGui:InvalidIterations',...
            'Iteration count must be a positive integer.')
    end

    switch type
        case {'Call' 'Put' 'Straddle' 'Butterfly'}
            strike = str2double(get(handles.editStrike, 'String'));
        case {'Strangle' 'Bull Spread' 'Bear Spread'}
            strike = str2double(get(handles.editStrike1, 'String'));
    end

    value = optPriceVal(type, spot, strike, rate, time, vol, yield, strike2, spread);
    set(handles.editValue, 'String', num2str(value,'%4.3f'))

catch ME
    errordlg(ME.message, 'Invalid Input', 'modal')
    set(handles.editValue, 'String', 'error')
    return
end

% Step 2: Now that we have all the data we need, let's plot the option
% value surface.

% A 51x51 surface plot should look nice and not be too taxing on the
% graphics processor, but you can adjust that here.
xPoints = 51;
yPoints = 51;

T = linspace(0, time, xPoints);

% The spot price axis span is a little tricky to determine in advance.  We
% will go with +/- 10% from the strike price in the case of a put, call, or
% straddle option, +/- 50% of the strike prices' span in the case of a
% strangle, bull spread, or bear spread option, and +/- 40% of the spread
% from a butterfly option.  Of course, we will truncate if these go below a
% price of 0.
switch type
    case {'Call' 'Put' 'Straddle'}
        lPrice = 0.9 * strike;
        uPrice = 1.1 * strike;
    case {'Strangle' 'Bull Spread' 'Bear Spread'}
        span = abs(strike2 - strike);
        if strike2 > strike
            lPrice = strike - 0.5 * span;
            uPrice = strike2+ 0.5 * span;
        else
            lPrice = strike2- 0.5 * span;
            uPrice = strike + 0.5 * span;
        end
    case 'Butterfly'
        lPrice = (1 - 1.4 * spread) * strike;
        uPrice = (1 + 1.4 * spread) * strike;
end
lPrice(lPrice < 0) = 0;
S = linspace(lPrice, uPrice, yPoints);
[S,T] = meshgrid(S,T);

% Get the option value for the surface
V = optPriceVal(type, S, strike, rate, T, vol, yield, strike2, spread);

% Plot the 3D surface of changing option value with spot price and time
surf(handles.surfAxes, S, T, V);
box(handles.surfAxes, 'on')
shading(handles.surfAxes, 'interp')
axis(handles.surfAxes, 'tight')
xlabel(handles.surfAxes, 'Underlying ($)','fontweight','bold')
ylabel(handles.surfAxes, 'Time to Expiry (Years)','fontweight','bold')
zlabel(handles.surfAxes, 'Option Value ($)','fontweight','bold')

% Step 3: Let's now run a Monte Carlo simulation
% We will run a single step of the simulation per day-- this is fairly
% coarse-grained, but it gets the message across.

% Assume geometric Brownian motion and apply Ito's lemma to simplify the
% Monte Carlo equation. (see: eqn T6.9 of Kevin Dowd's _An Introduction to
% Market Risk Measurement_, p. 224)
numDays = daysact(startDate, endDate);
TT = sqrt(time/numDays) * ones(numDays, iter);
rNum = randn(numDays, iter);

BT = TT.*rNum;
% And we pad this by an initial row of zeros to handle the initial point at
% day 0.
TT = [zeros(1, iter); TT];
BT = [zeros(1, iter); BT];

ST = spot * exp(cumsum((rate - 0.5 * vol^2) * TT + vol * BT));

% Step 4: Plot the Monte Carlo simulation
% Create line/bar object for histogram of monte-carlo price distributions
set(handles.axesHist,'yaxislocation','right','xaxislocation','top',...
    'xtick',[],'xlimmode','auto')

% Only pick at most 1000 lines from the Monte-Carlo simulation for plotting
% purposes; all data is still used for the underlying math, however.
if size(ST,2)>1000
    ind = randperm(size(ST,2))';
    STplot = ST(:,ind(1:1000));
else
    STplot = ST;
end

% Plot the monte-carlo underlying price paths
handles.pricePaths = plot(handles.axesMonte, (0:numDays), STplot,...
    'color', [.7,.7,.7]);

% Create the tracking line.  Rather, create an object to hold the tracking
% line as it is generated by the windowbuttonmotion function.
handles.trackLine = line('XData', NaN, 'YData', NaN,...
    'Parent', handles.axesMonte, 'erasemode', 'xor', 'Color', 'b', 'LineWidth', 2);
handles.trackText = text('parent', handles.axesMonte, 'erasemode','xor','edgecolor','k',...
    'background',[1,1,.87],'verticalalign','bot','fontsize',14, 'visible', 'off');
% handles.pdfLine = line('XData', NaN, 'YData', NaN,...
%     'Parent', handles.axesHist, 'erasemode', 'xor', 'Color', 'r');

% Plot the mean of the underlying monte-carlo prices paths.
STmean = mean(ST,2);
handles.meanLine = line('XData', (0:numDays), 'YData', STmean, ...
    'Parent', handles.axesMonte, 'Marker', '.' ,'MarkerSize', 10, 'Color', 'r');


% Annotate the monte-carlo plots
xlabel(handles.axesMonte, 'Time (Days)','fontweight','bold')
ylabel(handles.axesMonte, 'Underlying ($)','fontweight','bold')
axis(handles.axesMonte, 'tight')
grid(handles.axesMonte, 'on')
legend(handles.axesMonte, ...
    {'$$S_{t+dt} = S_te^{(r-\frac{{\sigma^2}}{2})dt+\sigma\epsilon\sqrt{dt}}$$'}, ...
    'fontsize',14,'interpreter','latex', 'Location', 'NorthWest');

set(handles.mainFigure,'windowbuttonmotionfcn',@wbm)

% Nested function: WBM for the window button motion function
    function wbm(src, event)
        drawnow
        ylimit = get(handles.axesMonte, 'ylim');
        xlimit = get(handles.axesMonte, 'xlim');
        pos =  get(handles.axesMonte, 'currentpoint');
        x = pos(1,1);
        y = pos(1,2);
        % check if the mouse is out of bounds of the axes
        if x < xlimit(1) || x > xlimit(2) || y < ylimit(1) || y>ylimit(2)
            return
        end

        % create a histogram of the underlying price paths at the current point
        binsC = linspace(ylimit(1), ylimit(2)+eps(ylimit(2)), 21);
        n = histc(ST(round(x)+1, :), binsC);
        n = n./max(n);
        barh(handles.axesHist, binsC, n, 'histc')
        set(handles.axesHist, 'ylim', ylimit)
        set(handles.axesHist,'YTick',[])
        set(handles.axesHist,'XTick',[])
        set(handles.trackLine,'xdata',[x,x],'ydata',ylim)

        % Create a maximum likelihood estimate of the histogram, assuming a
        % lognormal distribution.
        params = lognfit(ST(round(x)+1, :));
        pdfPts = ylimit(1) : ylimit(2);
        pdfVals = lognpdf(pdfPts, params(1), params(2));
        line('Parent', handles.axesHist, ...
            'XData', pdfVals./max(pdfVals), 'YData', pdfPts,...
            'erasemode', 'xor', 'color', 'b')

        % get the current datestr and mean value of the mouse position
        currentDate = datestr(round(x + datenum(startDate)), 2);
        currentMean = STmean(round(x)+1);

        str = sprintf(['Date: ' currentDate '\nAvg Price: $%.2f'], currentMean);
        set(handles.trackText,...
            'position',[x + diff(xlimit)*.02, y + diff(ylimit)*.02, 0],...
            'string', str, 'visible', 'on')

    end
end




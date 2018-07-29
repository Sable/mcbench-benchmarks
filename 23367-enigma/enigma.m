function varargout = enigma(varargin)
% ENIGMA - a GUI that runs a simulation of the WWII-era German Enigma Machine.
%
% Use:
% enigma (just type 'enigma' into the command line).
%
% Details
% - One can select "Load Text" to encrypt *.txt files
% - Click the "Edit Parameters" toggle button to switch or add rotors,
%   change the initial rotor positions, or edit the plugboard settings
%
% For details on the functioning of the enigma machine, refer to:
% http://en.wikipedia.org/wiki/Enigma_machine
%
% James Roberts
% 2009

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @enigma_OpeningFcn, ...
    'gui_OutputFcn',  @enigma_OutputFcn, ...
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


function enigma_OpeningFcn(hObject, eventdata, handles, varargin)

% Initialize the paramters for running enigma
handles.params.characterList = ...
    sprintf('ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789,<.>/?;:"[{]}`~!@#$%^&*()-_=+\\|');
handles.params.nRotors = 8;

% Initialize the paramter GUI controls
tmp = length(handles.params.characterList);
fillMenu = cell(length(handles.params.characterList),1);
for iA = 1:length(fillMenu);
    fillMenu{iA} = handles.params.characterList(iA);
end
set(handles.slider1,'SliderStep',[1/(tmp-1), 5/(tmp-1)],'Min',1,'Max',tmp,'Value',1)
set(handles.slider2,'SliderStep',[1/(tmp-1), 5/(tmp-1)],'Min',1,'Max',tmp,'Value',1)
set(handles.slider3,'SliderStep',[1/(tmp-1), 5/(tmp-1)],'Min',1,'Max',tmp,'Value',1)
set(handles.slider4,'SliderStep',[1/(tmp-1), 5/(tmp-1)],'Min',1,'Max',tmp,'Value',1)
set(handles.slider5,'SliderStep',[1/(tmp-1), 5/(tmp-1)],'Min',1,'Max',tmp,'Value',1)
set(handles.slider6,'SliderStep',[1/(tmp-1), 5/(tmp-1)],'Min',1,'Max',tmp,'Value',1)
set(handles.slider7,'SliderStep',[1/(tmp-1), 5/(tmp-1)],'Min',1,'Max',tmp,'Value',1)
set(handles.slider8,'SliderStep',[1/(tmp-1), 5/(tmp-1)],'Min',1,'Max',tmp,'Value',1)
set(handles.edit1,'String',handles.params.characterList(1));
set(handles.edit2,'String',handles.params.characterList(1));
set(handles.edit3,'String',handles.params.characterList(1));
set(handles.edit4,'String',handles.params.characterList(1));
set(handles.edit5,'String',handles.params.characterList(1));
set(handles.edit6,'String',handles.params.characterList(1));
set(handles.edit7,'String',handles.params.characterList(1));
set(handles.edit8,'String',handles.params.characterList(1));
set(handles.checkbox1,'Value',1);
set(handles.checkbox2,'Value',1);
set(handles.checkbox3,'Value',1);
set(handles.checkbox4,'Value',1);
set(handles.checkbox5,'Value',1);
set(handles.checkbox6,'Value',0);
set(handles.checkbox7,'Value',0);
set(handles.checkbox8,'Value',0);
set(handles.popupmenu1a,'String',fillMenu);
set(handles.popupmenu1b,'String',fillMenu);
set(handles.popupmenu2a,'String',fillMenu);
set(handles.popupmenu2b,'String',fillMenu);
set(handles.popupmenu3a,'String',fillMenu);
set(handles.popupmenu3b,'String',fillMenu);
set(handles.popupmenu4a,'String',fillMenu);
set(handles.popupmenu4b,'String',fillMenu);
set(handles.popupmenu5a,'String',fillMenu);
set(handles.popupmenu5b,'String',fillMenu);

guidata(hObject, handles);
uiwait(handles.figure1);


function varargout = enigma_OutputFcn(hObject, eventdata, handles)

% i don't really have any outputs at the moment.
if ~isempty(handles)
    close(handles.figure1)
end


function inputText_Callback(hObject, eventdata, handles)


function inputText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function outputText_Callback(hObject, eventdata, handles)


function outputText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function runButton_Callback(hObject, eventdata, handles)


% Update handles structure
handles = guidata(hObject);

inputText = get(handles.inputText,'String');
if ~isempty(inputText);

    handles.params = getParams(handles);

    if sum(handles.params.rotorUse) > 0
        if sum(sum(handles.params.plugboard ~= 0)) < length(unique(handles.params.plugboard(:)))
            outputText = runEnigma(inputText,handles.params);
            set(handles.outputText,'String',outputText);
        else
            set(handles.outputText,...
                'String','Plugboard Must Not Use The Same Letter More Than Once');
        end
    else
        set(handles.outputText,'String','Must Select At Least 1 Rotor');
    end
else
    set(handles.outputText,'String','Input Text Must Not Be Empty');
end
guidata(hObject, handles);



function loadButton_Callback(hObject, eventdata, handles)
[inputFileName, inputPathName] = uigetfile('*.txt', 'Pick a Text File for Input');
if ~isequal(inputFileName,0)
    [outputFileName, outputPathName] = uiputfile('*.txt', 'Pick a Text File for Output');
    if ~isequal(outputFileName,0)

        [fidIn] = fopen(sprintf('%s%s%s',inputPathName,filesep,inputFileName),'r');
        [fidOut] = fopen(sprintf('%s%s%s',outputPathName,filesep,outputFileName),'w');

        params = getParams(handles);

        while 1
            inLine = fgetl(fidIn);
            if ~ischar(inLine)
                break
            else
                outLine = runEnigma(inLine,params);
            end
            fprintf(fidOut,'%s\n',outLine);
        end
        fclose(fidIn);
        fclose(fidOut);

        set(handles.inputText,'String','Your Text File');
        set(handles.outputText,'String','Has Been Processed');

    end
end


function paramButton_Callback(hObject, eventdata, handles)
if get(hObject,'Value') == 1;
    set(handles.uipanel1,'Visible','on');
    set(handles.uipanel2,'Visible','on');

    set(handles.inputTitle,'Visible','off');
    set(handles.outputTitle,'Visible','off');
    set(handles.inputText,'Visible','off');
    set(handles.outputText,'Visible','off');
    set(handles.runButton,'Visible','off');
    set(handles.loadButton,'Visible','off');

    set(hObject,'String','Return to Enigma');
else
    set(handles.uipanel1,'Visible','off');
    set(handles.uipanel2,'Visible','off');

    set(handles.inputTitle,'Visible','on');
    set(handles.outputTitle,'Visible','on');
    set(handles.inputText,'Visible','on');
    set(handles.outputText,'Visible','on');
    set(handles.runButton,'Visible','on');
    set(handles.loadButton,'Visible','on');

    set(hObject,'String','Edit Parameters');
end


function params = getParams(handles)
params = handles.params;

% Gather the parameters from the GUI objects
params.rotorState    = ones(params.nRotors,1);
params.rotorState(1) = get(handles.slider1,'Value');
params.rotorState(2) = get(handles.slider2,'Value');
params.rotorState(3) = get(handles.slider3,'Value');
params.rotorState(4) = get(handles.slider4,'Value');
params.rotorState(5) = get(handles.slider5,'Value');
params.rotorState(6) = get(handles.slider6,'Value');
params.rotorState(7) = get(handles.slider7,'Value');
params.rotorState(8) = get(handles.slider8,'Value');
params.rotorState    = round(params.rotorState);
params.rotorUse(1)   = get(handles.checkbox1,'Value');
params.rotorUse(2)   = get(handles.checkbox2,'Value');
params.rotorUse(3)   = get(handles.checkbox3,'Value');
params.rotorUse(4)   = get(handles.checkbox4,'Value');
params.rotorUse(5)   = get(handles.checkbox5,'Value');
params.rotorUse(6)   = get(handles.checkbox6,'Value');
params.rotorUse(7)   = get(handles.checkbox7,'Value');
params.rotorUse(8)   = get(handles.checkbox8,'Value');

% Construct the plugboard object
params.plugboard = zeros(5,2);
params.plugboard(1,1) = get(handles.popupmenu1a,'Value');
params.plugboard(1,2) = get(handles.popupmenu1b,'Value');
params.plugboard(2,1) = get(handles.popupmenu2a,'Value');
params.plugboard(2,2) = get(handles.popupmenu2b,'Value');
params.plugboard(3,1) = get(handles.popupmenu3a,'Value');
params.plugboard(3,2) = get(handles.popupmenu3b,'Value');
params.plugboard(4,1) = get(handles.popupmenu4a,'Value');
params.plugboard(4,2) = get(handles.popupmenu4b,'Value');
params.plugboard(5,1) = get(handles.popupmenu5a,'Value');
params.plugboard(5,2) = get(handles.popupmenu5b,'Value');
if get(handles.checkPlug1,'Value')==0, params.plugboard(1,:) = 0; end
if get(handles.checkPlug2,'Value')==0, params.plugboard(2,:) = 0; end
if get(handles.checkPlug3,'Value')==0, params.plugboard(3,:) = 0; end
if get(handles.checkPlug4,'Value')==0, params.plugboard(4,:) = 0; end
if get(handles.checkPlug5,'Value')==0, params.plugboard(5,:) = 0; end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FROM HERE ON OUT IS THE ACTUAL GUTS OF RUNNING THE ENIGMA.  UP TO NOW HAS
% BEEN GUI RELATED STUFF.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function outMsg = runEnigma(inMsg,params)
%

% Set the random number generators.  this is crucial.  without these we
% would have to initialize the rotors by hand.
randn('seed',0);
randn('state',0);
rand('seed',0);
rand('state',0);

% Build the handles.rotors
params.rotors = buildRotors(params.nRotors,length(params.characterList),params.rotorState);

% Only use the rotors that have been selected by the checkboxes
params.rotorState = params.rotorState(logical(params.rotorUse));
params.nRotors    = length(params.rotorState);
params.rotors     = params.rotors(:,logical(params.rotorUse));

% Build the params.reflector
params.reflector = buildReflector(length(params.characterList));

% preprocess the message
procMsg = preprocess(inMsg,params.characterList);
outMsg  = '';

% loop through all of the letters of the input message and encode them
for iA = 1:length(procMsg)

    % Turn the leter into a number for passing through the params.rotors
    msgNum = strfind(params.characterList,procMsg(iA));

    % Pass the letter through the plugboard
    msgNum = runPlugboard(msgNum,params.plugboard);

    % Pass the letter through the rotors, reflector, and back through the
    % rotors
    tmpOut = passThroughRotors(msgNum,params);

    % Pass the letter through the plugboard again
    tmpOut = runPlugboard(tmpOut,params.plugboard);

    % Store the encrypted letter into the output message
    outMsg(iA) = params.characterList(tmpOut);

    % Move the rotors along 1 block.
    params = rotateRotors(params);
end


function msgOut = runPlugboard(msgIn,plugboard)
if sum(msgIn == plugboard(:,1)) == 1
    msgOut = plugboard(msgIn == plugboard(:,1),2);
elseif sum(msgIn == plugboard(:,2)) == 1
    msgOut = plugboard(msgIn == plugboard(:,2),1);
else
    msgOut = msgIn;
end


function params = rotateRotors(params)
params.nRotors = size(params.rotors,2);
exitFlag = 0;
rotorNum = 1;

while ~exitFlag
    tmp = params.rotors(:,rotorNum);
    params.rotors(:,rotorNum) = [tmp(2:end); tmp(1)];
    params.rotorState(rotorNum) = ...
        mod(params.rotorState(rotorNum),size(params.rotors,1)) + 1;

    if ~isequal(params.rotorState(rotorNum),1)
        exitFlag = 1;
    end
    rotorNum = rotorNum + 1;
    if rotorNum > params.nRotors
        exitFlag = 1;
    end
end


function letterOut = passThroughRotors(letterIn,params)
tmpOut = letterIn;

% pass the letter through the rotors
for iB = 1:size(params.rotors,2)
    tmpIn  = tmpOut;
    tmpOut = params.rotors(tmpIn,iB);
end

% pass the letter through the reflector
tmpIn = tmpOut;
tmpOut = params.reflector(tmpIn);

% pass the letter back through the rotors
for iB = size(params.rotors,2):-1:1
    tmpIn  = tmpOut;
    tmpOut = find(params.rotors(:,iB)==tmpIn);
end

letterOut = tmpOut;


function procMsg = preprocess(inMsg,characterList)
inMsg   = upper(inMsg);
procMsg = inMsg(ismember(inMsg,characterList));


function reflector = buildReflector(nCharacters)

tmp = randperm(nCharacters)';
reflector = zeros(nCharacters,1);
while ~isempty(tmp)
    fillers = tmp(1:2);
    tmp(1:2) = [];

    reflector(fillers(1)) = fillers(2);
    reflector(fillers(2)) = fillers(1);
end


function rotors = buildRotors(nRotors,nCharacters,rotorState)

% Build the rotors
rotors = zeros(nCharacters,nRotors);
for iRotor = 1:nRotors
    rotors(:,iRotor) = randperm(nCharacters)';
end

% Rotate each rotor into its proper state
for iRotor = 1:nRotors
    tmp = rotors(:,iRotor);
    if rotorState(iRotor) > 1
        tmp = [tmp(rotorState(iRotor):end); tmp(1:rotorState(iRotor)-1)];
        rotors(:,iRotor) = tmp;
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FROM HERE ON OUT IS THE MORE USELESS FUNCTION CALLS THAT NEED TO EXIST
% (EVEN THOUGH MOST ARE EMPTY) FOR THE GUI TO RUN PROPERLY.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function slider1_Callback(hObject, eventdata, handles)
set(handles.edit1,'String',handles.params.characterList(round(get(hObject,'Value'))));


function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider2_Callback(hObject, eventdata, handles)
set(handles.edit2,'String',handles.params.characterList(round(get(hObject,'Value'))));


function slider2_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider3_Callback(hObject, eventdata, handles)
set(handles.edit3,'String',handles.params.characterList(round(get(hObject,'Value'))));


function slider3_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider4_Callback(hObject, eventdata, handles)
set(handles.edit4,'String',handles.params.characterList(round(get(hObject,'Value'))));


function slider4_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider5_Callback(hObject, eventdata, handles)
set(handles.edit5,'String',handles.params.characterList(round(get(hObject,'Value'))));


function slider5_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider6_Callback(hObject, eventdata, handles)
set(handles.edit6,'String',handles.params.characterList(round(get(hObject,'Value'))));


function slider6_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider7_Callback(hObject, eventdata, handles)
set(handles.edit7,'String',handles.params.characterList(round(get(hObject,'Value'))));


function slider7_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider8_Callback(hObject, eventdata, handles)
set(handles.edit8,'String',handles.params.characterList(round(get(hObject,'Value'))));


function slider8_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function edit1_Callback(hObject, eventdata, handles)


function edit1_CreateFcn(hObject, eventdata, handles)


function edit2_Callback(hObject, eventdata, handles)


function edit2_CreateFcn(hObject, eventdata, handles)


function edit3_Callback(hObject, eventdata, handles)


function edit3_CreateFcn(hObject, eventdata, handles)


function edit4_Callback(hObject, eventdata, handles)


function edit4_CreateFcn(hObject, eventdata, handles)


function edit5_Callback(hObject, eventdata, handles)


function edit5_CreateFcn(hObject, eventdata, handles)


function edit6_Callback(hObject, eventdata, handles)


function edit6_CreateFcn(hObject, eventdata, handles)


function edit7_Callback(hObject, eventdata, handles)


function edit7_CreateFcn(hObject, eventdata, handles)


function edit8_Callback(hObject, eventdata, handles)


function edit8_CreateFcn(hObject, eventdata, handles)


function checkbox1_Callback(hObject, eventdata, handles)


function checkbox2_Callback(hObject, eventdata, handles)


function checkbox3_Callback(hObject, eventdata, handles)


function checkbox4_Callback(hObject, eventdata, handles)


function checkbox5_Callback(hObject, eventdata, handles)


function checkbox6_Callback(hObject, eventdata, handles)


function checkbox7_Callback(hObject, eventdata, handles)


function checkbox8_Callback(hObject, eventdata, handles)


function popupmenu1a_Callback(hObject, eventdata, handles)


function popupmenu1a_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenu1b_Callback(hObject, eventdata, handles)


function popupmenu1b_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenu2a_Callback(hObject, eventdata, handles)


function popupmenu2a_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenu2b_Callback(hObject, eventdata, handles)


function popupmenu2b_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenu3a_Callback(hObject, eventdata, handles)


function popupmenu3a_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenu3b_Callback(hObject, eventdata, handles)


function popupmenu3b_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenu4a_Callback(hObject, eventdata, handles)


function popupmenu4a_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenu4b_Callback(hObject, eventdata, handles)


function popupmenu4b_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenu5a_Callback(hObject, eventdata, handles)


function popupmenu5a_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenu5b_Callback(hObject, eventdata, handles)


function popupmenu5b_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function checkPlug1_Callback(hObject, eventdata, handles)


function checkPlug2_Callback(hObject, eventdata, handles)


function checkPlug3_Callback(hObject, eventdata, handles)


function checkPlug4_Callback(hObject, eventdata, handles)


function checkPlug5_Callback(hObject, eventdata, handles)

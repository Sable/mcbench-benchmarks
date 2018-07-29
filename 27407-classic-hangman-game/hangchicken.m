%------------------------------------------------------------------
%
% Purpose   : Classic hangman(hangchicken in this case) game. This gui is
%             written as an example for the DSA lecture to explain Matlab 
%             GUI's
%
% Author    : Latif Yalcinoglu
% Date      : 26 April 2010
% Version   : 1.1
%
% (c) 2010, Lehrstuhl für Geophysik, University of Leoben, Leoben, Austria
% email     : Latif.Yalcinoglu@unileoben.ac.at


function varargout = hangchicken(varargin)
% hangchicken M-file for hangchicken.fig
%      hangchicken, by itself, creates a new hangchicken or raises the existing
%      singleton*.
%
%      H = hangchicken returns the handle to a new hangchicken or the handle to
%      the existing singleton*.
%
%      hangchicken('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in hangchicken.M with the given input arguments.
%
%      hangchicken('Property','Value',...) creates a new hangchicken or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hangchicken_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hangchicken_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
%   Galgenmännchen     - hangchicken - Adam asmaca

% Edit the above text to modify the response to help hangchicken

% Last Modified by GUIDE v2.5 27-Apr-2010 14:28:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @hangchicken_OpeningFcn, ...
    'gui_OutputFcn',  @hangchicken_OutputFcn, ...
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


% --- Executes just before hangchicken is made visible.
function hangchicken_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hangchicken (see VARARGIN)

%   set 22 text boxes strings as empty and make them invisible
for i = 1:22
    eval(sprintf('set(handles.box%d, ''Visible'', ''off'', ''String'', '''')',i));
end

%   set info text box invisible
set(handles.infoText, 'Visible', 'off');

%   set start game number zero
handles.gameStarted = 0;

%   read the chicken sound and assign to handles
[handles.chickenNormy, handles.chickenNormFs, nbits, readinfo] = wavread('pukpuk.wav');

%   read the chicken sound and assign to handles
[handles.chickenerrory, handles.chickenerrorFs, nbits, readinfo] = wavread('error.wav');

%   read the chicken sound and assign to handles
[handles.chickenstarty, handles.chickenstartFs, nbits, readinfo] = wavread('battlecry.wav');

%   Create a handles variable for pressed buttons
handles.pressedButton = '';

%   set during game info textbox
set(handles.pressedButtonList, 'Visible', 'Off', 'Enable', 'off');
set(handles.pressedButtonTextBox, 'Visible', 'Off');

%   set axes properties
set(gca,'XTickLabel','',...
    'YTickLabel','',...
    'XTick', [],...
    'YTick', [],...
    'XColor', 'w',...
    'YColor', 'w');

% Choose default command line output for hangchicken
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes hangchicken wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = hangchicken_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in listLoadPushButton.
function listLoadPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to listLoadPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%   get the file using uigetfile
[handles.fileName,handles.folderPath] = uigetfile('*.txt','Select text file');
%   save full path
handles.filePath = [handles.folderPath handles.fileName];
%   if cancelled, return 0
if handles.fileName == 0
    return;
end

%   set the file name to the static text
set(handles.text1, 'String', handles.fileName);

%   open the file, get fid for textscan
fid = fopen(handles.filePath);

%   read the text file and assign to a cell variable
wordList = textscan(fid, '%s', 'delimiter', '\n');
handles.wordList = wordList{1};

%   close the file
fclose(fid);

% Choose default command line output for hangchicken
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in startGameButton.
function startGameButton_Callback(hObject, eventdata, handles)
% hObject    handle to startGameButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%   If nothing is loaded warn and exit
if isfield(handles, 'wordList') == 0;
    warndlg({'No text file loaded!', 'Please load a text file.'}, 'Load text file');
    return;
end

%   set the start button enable off
set(handles.startGameButton, 'Enable', 'off');

%   Reset figure
reset(handles.axes1);
cla(handles.axes1);
%   set axes
set(gca,'XTickLabel','',...
    'YTickLabel','',...
    'XTick', [],...
    'YTick', [],...
    'XColor', 'w',...
    'YColor', 'w');

%   make boxes invisible, since game can play several times after it is run
for i = 1:22
    eval(sprintf('set(handles.box%d, ''Visible'', ''off'',''String'', '''')',i));
end

%   set start game number 1 and number of trials
handles.gameStarted = 1;
handles.trialNumber = 5;

%   set the pressed button listbox string
set(handles.pressedButtonList, 'String', ['N';'o';'B';'u';'t';'t';'o';'n';'P';'r';'e';'s';'s';'e';'d'], 'Visible', 'On');
set(handles.pressedButtonTextBox, 'Visible', 'On');

%   set during game info textbox
set(handles.duringGameInfo, 'String', 'Let the game begin!', 'Visible', 'On');

%   create a random value to select the word in the word list
randomSelect = round(rand() * 1000000 * length(handles.wordList));

%   get the selected word number using the number of the words in the list
%   as modular
selectedWordNumber = mod(randomSelect, length(handles.wordList));

%   assign the selected word to handles
handles.selectedWord = handles.wordList{selectedWordNumber};

%   update the indo text box and make it visible
set(handles.infoText, 'String', sprintf('Find a city-country with %d letters',...
    length(handles.selectedWord)), 'Visible', 'on');

%   assign the letters to the text boxes
for i = 1:length(handles.selectedWord)
    eval(sprintf('set(handles.box%d, ''Visible'', ''on'',''String'', '''')',i));
end

%   Create logical variable to correct find positions
handles.foundLetters = false(1, length(handles.selectedWord));

%   Activate the main figure
figure(gcf);

%   ignore the spaces
%   Check if any space is in the choosen word and put underscore(_) instead
%   of spaces
isThereSpaces = regexp(handles.selectedWord, ' ');
if isempty(isThereSpaces) ~= 1
    for j = 1:length(isThereSpaces)
        %
        eval(sprintf('set(handles.box%d, ''String'', ''_'')',isThereSpaces(j)));
        
    end
end

%   change the found letters logical variable
handles.foundLetters(isThereSpaces) = true;

% Choose default command line output for hangchicken
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

%   if game didn't started (gameStarted variable is 0), don't use keypressfcn
if handles.gameStarted == 0
    return;
end

%   set the pressed button list with the current letter
handles.pressedButton = [handles.pressedButton; eventdata.Character];
set(handles.pressedButtonList, 'String', handles.pressedButton);

%   Check if the pressed letter is in the choosen word. 'ignorecase'
%   ignoring if the letter upper or lower case
isThereLetter = regexp(handles.selectedWord, eventdata.Character, 'ignorecase');

if isempty(isThereLetter) == 1
    %   Play error sound
    sound(handles.chickenerrory, handles.chickenerrorFs);
    %   show the user how many trials left
    set(handles.duringGameInfo, 'String', sprintf('There is no "%c" in the word, %d trial left!',...
        eventdata.Character, (handles.trialNumber-1)));    
    
    %   reset axes
    reset(handles.axes1);
    %   show image
    eval(sprintf('Image1 = importdata(''chicken%d.JPG'');', handles.trialNumber));

    %   place image onto the axes
    image(Image1);
    %   remove the axis tick marks
    axis off
    %
    if handles.trialNumber == 1
        %   Game is over
        set(handles.duringGameInfo, 'String', 'Chicken is grilled');
        
        %   make the boxes invisible
        for iij = 1:length(handles.selectedWord)
            %
            eval(sprintf('set(handles.box%d, ''String'', ''%c'')',iij, handles.selectedWord(iij)));
            %
        end
        
        %   reset variables to be ready for a new game
        handles.trialNumber = 5;
        handles = rmfield(handles, 'selectedWord');
        handles.gameStarted = 0;
        %
        set(handles.infoText, 'String', 'Game is over!');
                
        %   set the start button enable off
        set(handles.startGameButton, 'Enable', 'on');        
        
        %   set the pressed button list 0
        handles.pressedButton = '';
        %   set during game info textbox
        set(handles.pressedButtonList, 'Visible', 'Off', 'Enable', 'off');
        set(handles.pressedButtonTextBox, 'Visible', 'Off');

        % Choose default command line output for hangchicken
        handles.output = hObject;

        % Update handles structure
        guidata(hObject, handles);
        return;       
        
    else
        %
        handles.trialNumber = handles.trialNumber - 1;        
    end
    
else
    %   set found letters
    handles.foundLetters(isThereLetter) = true;
    %   check if all letters found
    if sum(handles.foundLetters) == length(handles.selectedWord)
        helpdlg('WOW, you saved the chicken', 'Bravo');
                
        %   make the boxes invisible
        for ii = 1:length(handles.selectedWord)
            eval(sprintf('set(handles.box%d, ''Visible'', ''of'', ''String'', '''')',ii));
        end
        %   reset everything
        handles.trialNumber = 5;
        handles = rmfield(handles, 'selectedWord');
        handles.gameStarted = 0;
        
        set(handles.infoText, 'String', 'You saved the chicken, Bravo!');
        set(handles.duringGameInfo, 'String', sprintf('Last pressed button was "%c"', eventdata.Character))
        
        %   set the start button enable off
        set(handles.startGameButton, 'Enable', 'on');        
        
        %   set the pressed button list 0
        handles.pressedButton = '';
        %   set during game info textbox
        set(handles.pressedButtonList, 'Visible', 'Off', 'Enable', 'off');
        set(handles.pressedButtonTextBox, 'Visible', 'Off');
        %   Reset figure
        reset(handles.axes1);
        cla(handles.axes1);
        %   set axes
        set(handles.axes1,'XTickLabel','',...
            'YTickLabel','',...
            'XTick', [],...
            'YTick', [],...
            'XColor', 'w',...
            'YColor', 'w');
        
        %   Play winning sound
        sound(handles.chickenstarty, handles.chickenstartFs);
        
        % Choose default command line output for hangchicken
        handles.output = hObject;

        % Update handles structure
        guidata(hObject, handles);
        return;
        
    end
    
    %   Play pukpuk sound, means a word is correctly guessed
    sound(handles.chickenNormy, handles.chickenNormFs);
    
    %   Set the during game info text box. If there is
    if length(isThereLetter) == 1
        set(handles.duringGameInfo, 'String', sprintf('There is 1 "%c" in the word', eventdata.Character))
    else
        set(handles.duringGameInfo, 'String', sprintf('There are %d "%c" in the word', length(isThereLetter), eventdata.Character));
    end
    
    %   make the letters visible    
    for j = 1:length(isThereLetter)
        %
        eval(sprintf('set(handles.box%d, ''Visible'', ''on'', ''String'', ''%c'')',isThereLetter(j), eventdata.Character));
        %
    end
    
end

% Choose default command line output for hangchicken
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in pressedButtonList.
function pressedButtonList_Callback(hObject, eventdata, handles)
% hObject    handle to pressedButtonList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pressedButtonList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pressedButtonList


% --- Executes during object creation, after setting all properties.
function pressedButtonList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pressedButtonList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in helpButton.
function helpButton_Callback(hObject, eventdata, handles)
% hObject    handle to helpButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%   Open readme text file which is in the same folder with gui files
winopen('readme.txt')



% --- Executes on button press in exitButton.
function exitButton_Callback(hObject, eventdata, handles)
% hObject    handle to exitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%   Exit the program
delete(hangchicken);

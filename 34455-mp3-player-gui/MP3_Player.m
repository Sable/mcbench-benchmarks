function varargout = MP3_Player(varargin)
% MP3_PLAYER M-file for MP3_Player.fig
%      MP3_PLAYER, by itself, creates a new MP3_PLAYER or raises the existing
%      singleton*.
%
%      H = MP3_PLAYER returns the handle to a new MP3_PLAYER or the handle to
%      the existing singleton*.
%
%      MP3_PLAYER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MP3_PLAYER.M with the given input arguments.
%
%      MP3_PLAYER('Property','Value',...) creates a new MP3_PLAYER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MP3_Player_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MP3_Player_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MP3_Player

% Last Modified by GUIDE v2.5 08-Jan-2012 00:16:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MP3_Player_OpeningFcn, ...
                   'gui_OutputFcn',  @MP3_Player_OutputFcn, ...
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


% --- Executes just before MP3_Player is made visible.
function MP3_Player_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MP3_Player (see VARARGIN)

% Choose default command line output for MP3_Player

handles.output = hObject;
handles.playfiles = [];           % Playlist files
handles.id3metadata = cell(10,1); % MP3 meta data
albumart = imread('cdbox.png');   % Cover Art
axes(handles.albumart);
imshow(albumart);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MP3_Player wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MP3_Player_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pl stop_pl;
stop_pl = 1;
v = get (handles.playlist, 'Value');    % Get current playlist position
pause(0.1);
cfile = handles.playfiles{v};           % Get selected files's path

% s = which('mp3read.m');
% ww = findstr('mp3read.m',s);
% location = s(1:ww-2);
% [s tag_info] = dos([location,'\mp3info.exe', ' ', '"',cfile,'"']);
id3_tag=handles.id3metadata{v};         % Extract meta data from the selected file.
set(handles.id3tag, 'String', id3_tag); % Display MP3 meta data
[Y, FS] = mp3read (cfile);              % Decode selected mp3 file.

pl = audioplayer (Y, FS);               % start playback.
play (pl);

t=get(pl,'TotalSamples');
total_time = t / FS;
mins = total_time / 60;
secs = mod (total_time, 60);
set(handles.timeupdate_ttltmsc,'String',(round(secs)));
set(handles.timeupdate_ttltmmn,'String',(round(mins))); 

% Loop to find the time update
while (stop_pl == 1)
    c=get(pl,'CurrentSample');
    sliderval = c/t;
    current_tm = c / FS;
    current_tm_mins = current_tm / 60;
    current_tm_secs = mod(current_tm, 60);
    set(handles.playslider,'Value',sliderval);
    set(handles.timeupdate_ttltmsec,'String',(round(current_tm_secs)));
    set(handles.timeupdate_ttltmmin,'String',(round(current_tm_mins))); 
    guidata(hObject, handles);
    pause(.1);
end

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pl stop_pl;
stop_pl = 0;
stop (pl); % Stop mp3 playback
tmpfile = ['temp.wav'];
delete(tmpfile);

% --- Executes on selection change in playlist.
function playlist_Callback(hObject, eventdata, handles)
% hObject    handle to playlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns playlist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from playlist


% --- Executes during object creation, after setting all properties.
function playlist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to playlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pladd.
function pladd_Callback(hObject, eventdata, handles)
% hObject    handle to pladd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%persistent i;
cnt=get(handles.pladd,'UserData');              % To update the ID3 tag index
[f g]=uigetfile ('*.mp3','Choose a MP3 File','MultiSelect', 'on');  % Choose mp3 file to add to play list
p=get(handles.playlist,'String');             
p{length(p)+1}=[f];
set(handles.playlist,'String',p);               % Update the playlist display
handles.playfiles{length(handles.playfiles)+1}=[g f];
s = which('mp3read.m');
ww = findstr('mp3read.m',s);
location = s(1:ww-2);

%Exttract the mp3 tag info from the selected file
[s tag_info] = dos([location,'\mp3info.exe', ' ', '"',handles.playfiles{length(handles.playfiles)},'"']);

% Store the id3 tag infp
handles.id3metadata{cnt,:}=tag_info;

% Update id3 tag info index (cell array storage)
cnt=cnt+1;
set(handles.pladd,'UserData',cnt);
guidata(hObject,handles);


% --- Executes on slider movement.
function playslider_Callback(hObject, eventdata, handles)
% hObject    handle to playslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function playslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to playslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pl_reorder.
function pl_reorder_Callback(hObject, eventdata, handles)
% hObject    handle to pl_reorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
g_blues = get(handles.blues,'Value');
g_rock = get(handles.rock,'Value');
g_pop = get(handles.pop,'Value');
g_metal = get(handles.metal,'Value');
g_others = get(handles.others,'Value');
g_dance = get(handles.dance,'Value');
g_club = get(handles.club,'Value');
g_hiphop = get(handles.hiphop,'Value');
g_house = get(handles.house,'Value');
g_country = get(handles.country,'Value');


if g_blues == 1
    genre = 'blues';
elseif g_rock == 1
    genre = 'rock';
elseif g_pop == 1
    genre = 'pop';
elseif g_metal == 1
    genre = 'metal';
elseif g_others == 1
    genre = 'other';
elseif g_dance == 1
    genre = 'dance';
elseif g_club == 1
    genre = 'club';
elseif g_hiphop == 1
    genre = 'hip-hop';
elseif g_house == 1
    genre = 'house';
elseif g_country == 1
    genre = 'country';
end

playlist=get(handles.playlist,'String');
pl_len = length(playlist);

j = 1;
flag = 0;
for i=1:pl_len
    id3_tag_info = handles.id3metadata{i};
    pos = findstr ('Genre', id3_tag_info);
    tag_size = size(id3_tag_info);
    tag_sz = tag_size(1, 2);
    full_genre = id3_tag_info(1, (pos+7):tag_sz);
    ps=findstr('[',full_genre);
    song_genre=full_genre(1,1:(ps-2));
    
    if (strcmpi(genre,song_genre) == 1)
        new_playlist{j,1}=playlist{i,1};
        handles.playfiles{j}=handles.playfiles{i};
        handles.id3metadata{j,:}=handles.id3metadata{i,:};
        j=j+1;
        flag = 1;
    end    
end

% Update playlist only if the PL needs to be re-ordered
if (flag == 1)
    set(handles.playlist,'String',new_playlist);
    guidata(hObject,handles);
end
function varargout = GuitarTuner(varargin)
% GUITARTUNER M-file for GuitarTuner.fig
%		
%		///////////////////////////////////////////////////////////////////
%		///																///
%		///		Ryan Kinnett, January 2010								///
%		///																///
%		///////////////////////////////////////////////////////////////////
%
%
%      GUITARTUNER, by itself, creates a new GUITARTUNER or raises the existing
%      singleton*.
%
%      H = GUITARTUNER returns the handle to a new GUITARTUNER or the handle to
%      the existing singleton*.
%
%      GUITARTUNER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUITARTUNER.M with the given input arguments.
%
%      GUITARTUNER('Property','Value',...) creates a new GUITARTUNER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GuitarTuner_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GuitarTuner_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GuitarTuner

% Last Modified by GUIDE v2.5 12-Jan-2010 23:06:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GuitarTuner_OpeningFcn, ...
                   'gui_OutputFcn',  @GuitarTuner_OutputFcn, ...
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


% --- Executes just before GuitarTuner is made visible.
function GuitarTuner_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GuitarTuner (see VARARGIN)

% Choose default command line output for GuitarTuner
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

load ButtonIcons;
set(handles.playbutton1,'CData',PlayDisabled);
set(handles.recbutton1,'CData',RecDisabled);

disp('GuitarTuner, by Ryan Kinnett, Jan 2010');

% UIWAIT makes GuitarTuner wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = GuitarTuner_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




function freq1_Callback(hObject, eventdata, handles)
% hObject    handle to freq1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
% Hints: get(hObject,'String') returns contents of freq1 as text
%        str2double(get(hObject,'String')) returns contents of freq1 as a double


% --- Executes during object creation, after setting all properties.
function freq1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freq1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% ----USER DEFINED FUNCTIONS:
function outstr = getNotes(tone)
notes = {'C','C#','D','D#','E','F','F#','G','G#','A','A#','B'};
for n=1:length(tone),
	octave = floor((tone(n)-1)/12);
	note	= mod(tone(n)-1,12)+1;
	outstr{n} = [notes{note},num2str(octave)];
end;

function tune(eventdata, handles)
freq	= str2double(get(handles.freq1,'String'));
tone	= round(log(freq/440)/0.0578+58);
tones	= [tone-2:tone+2];
freqs	= 15.43379*exp(0.05776234*tones);
notes	= getNotes(tones);
	
axes(handles.calaxes1);
semilogx(freq,1,'*');
xlim([freqs(1) freqs(end)]);
set(handles.calaxes1,'YTickLabel',[],'XTick',freqs,'XTickLabel',notes,'XGrid','on');

Fs		= 96000*2;
twindow	= 0.5;
r		= audiorecorder(Fs,16,1);
data	= linspace(0,1,twindow*Fs)';

latestfit = 0;
while gcbo
	if	get(handles.recbutton1,'UserData')==0
		break;
	end;

	freq	= str2double(get(handles.freq1,'String'));
	tone	= round(log(freq/440)/0.0578+58);
	tones	= [tone-2:tone+2];
	freqs	= 15.43379*exp(0.05776234*tones);
	notes	= getNotes(tones);
% 	[B,A]	=  butter(2,[freqs(1) freqs(end)]/(Fs/2));
	
	
	record(r);
	%While recorder gathers data, process prev data:
	L = length(data);
	NFFT = 2^nextpow2(L);
	fftdata = abs(fft(data,NFFT)/L);
	fftdata = fftdata(1:floor(length(fftdata)/2));
	x		= linspace(0,Fs/2,length(fftdata))';
	indx	= and(x>freqs(1),x<freqs(end));
	npts	= sum(indx);
	xclip	= x(indx);
% 	disp(['Freq res: ',num2str(xclip(2)-xclip(1)),' Hz']);
	fftclip	= fftdata(indx);
	[mag,i]	= max(fftclip);
	
	nbrs	= 4;	%number of neighboring points to use for curve fit
	nbrs2	= 2;	%number of points on either side
% 	disp([i,npts,nbrs,mag/mean(fftclip)]);
	if i>(nbrs+1) && i<npts-(nbrs+1) && (mag/mean(fftclip))>1.5
		%fit exponential normal distribution near peak
		P=polyfit(xclip(i-nbrs2:i+nbrs2)-xclip(i),log(fftclip(i-nbrs2:i+nbrs2)),2);
		if P(1)<0	%check for inverted fit curve
			x2	= linspace(xclip(i-nbrs),xclip(i+nbrs),20)-xclip(i);
			y2	= exp(polyval(P,x2));
			fmax= -P(2)/2/P(1)+xclip(i);
			semilogx(xclip,fftclip,'b',x2+xclip(i),y2,'c',[1 1]*fmax,[0 20],'r','LineWidth',2);
			if fmax>freqs(1) && fmax<freqs(end)
				latestfit=fmax;
				
				%CHECK IF TUNED WITHIN 10 CENTITONE:
				flat	= 15.43379*exp(0.05776234*(tone-0.1));
				sharp	= 15.43379*exp(0.05776234*(tone+0.1));
				if fmax>flat && fmax<sharp
					hold on;
					semilogx([1 1]*latestfit,[0 20],'g','LineWidth',3);
					hold off;
				end;
			end;
			
		else %(inverted curve fit.. throw away)
			fpk	= xclip(i);
			semilogx(xclip,fftclip,'b');	
		end;
	else
		
	end;
	axis([freqs(1) freqs(end) 0 1.2*max(mag,0.005)]);
	set(handles.calaxes1,'YTickLabel',[],'XTick',freqs,'XTickLabel',notes,'XGrid','on');
	

	pause(twindow);

	stop(r);
	data	= getaudiodata(r,'double');
% 	data	= filtfilt(B,A,data);
	
end;



% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in playbutton1.
function playbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to playbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load ButtonIcons;
Fs			= 96000;
duration	= 1;
set(hObject,'CData',PlayEnabled);
freq		= str2double(get(handles.freq1,'String'));
t=[0:1/Fs:duration];
sig = sin(2*pi*freq*t);
soundsc(sig,Fs);
pause(duration);
set(hObject,'CData',PlayDisabled);




% --- Executes on button press in recbutton1.
function recbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to recbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load ButtonIcons;
if get(hObject,'UserData')
	%IF ALREADY ON, TURN OFF:
	set(hObject,'UserData',0);
	set(hObject,'CData',RecDisabled)
else
	%IF NOT ALREADY ON, TURN ON:
	set(hObject,'UserData',1);
	set(hObject,'CData',RecEnabled)
	tune(eventdata, handles);
end;




% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tones = [41  46  51   56  60  65 ];
selection = get(hObject,'Value');
if selection<7,
	set(handles.freq1,'String',num2str(15.43379*exp(0.05776234*tones(selection)),'%3.2f'));
	set(handles.freq1,'Enable','off');
else
	set(handles.freq1,'Enable','on');
end;




% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
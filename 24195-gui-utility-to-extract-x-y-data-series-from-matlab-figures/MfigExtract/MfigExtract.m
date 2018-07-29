%Coded by Dr. T. Gu (gu@ohio.edu). Copyright 2009.
%A Pro version is available for up to 99 equations. 
%User can import equations and export results
function varargout = MfigExtract(varargin)
% MFIGEXTRACT M-file for MfigExtract.fig
%      MFIGEXTRACT, by itself, creates a new MFIGEXTRACT or raises the existing
%      singleton*.
%
%      H = MFIGEXTRACT returns the handle to a new MFIGEXTRACT or the handle to
%      the existing singleton*.
%
%      MFIGEXTRACT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MFIGEXTRACT.M with the given input arguments.
%
%      MFIGEXTRACT('Property','Value',...) creates a new MFIGEXTRACT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MfigExtract_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MfigExtract_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MfigExtract

% Last Modified by GUIDE v2.5 23-Apr-2009 13:49:27

% Begin initialization code - DO NOT EDIT

thisver=version; %prepare to check version = R14 or above?
if isempty(strfind(thisver,'R13'))~=1 | isempty(strfind(thisver,'R12'))~=1
    disp('This software requires MATLAB R14 or above! Yours is lower. Quit.')
    return
end

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MfigExtract_OpeningFcn, ...
                   'gui_OutputFcn',  @MfigExtract_OutputFcn, ...
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

% --- Executes just before MfigExtract is made visible.
function MfigExtract_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MfigExtract (see VARARGIN)

% Choose default command line output for MfigExtract
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MfigExtract wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MfigExtract_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Let's close figure windows before opening new figure to extract
figs = findobj('Type','figure');
figs = sort(figs);
if length(figs) > 1  %if more than just GUI main
   for n = 1:(length(figs)-1) %skip last figure (GUI main)
       close(figs(n)); pause(0.0000001); %delay needed 
   end
end

extractxydata_Callback(hObject, eventdata, handles)

function extractxydata_Callback(hObject, eventdata, handles)
% hObject    handle to extractxydata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname2 filename2  %for View Excel file button

[filename1 pathname1]=uigetfile('*.fig','Select a figure file to extract x-y data');
if isequal(filename1,0) | isequal(pathname1,0); return; end %User pressed Cancel

[filename2, pathname2] = uiputfile('*.xls', 'Provide an Excel file name to save the x-y data');
if isequal(filename2,0) | isequal(pathname2,0)
    return
end %User pressed Cancel
    
if isempty(strfind(filename2,'.xls'));
    filename2=[filename2 '.xls'];
end

s = openfig(fullfile(pathname1,filename1)); % open figure and get handle to figure
delete(legend);  %legends add extra data to output. Remove legends

%get line handles
h = findobj(s,'Type','line');   %line is the type of your figure file.
	if isempty(h)
	line{1}='Your figure file does not contain x-y data.';
    line{2}='Did you accidentally load a wrong file?';
	line{3}='Your can view your figures using the File menu.';
	line{4}='Make sure you do not load a wrong file.';
	uiwait(msgbox(line, 'No x-y data in your file','warn'));
	close(s)
    return
	end

x=get(h,'xdata');
y=get(h,'ydata');
close(s) %close figure with legends removed
s=hgload(fullfile(pathname1,filename1));  %show original figure with legends

[n dummy]=size(x);  %n= number of x-y sets in the figure.

fid=fopen(fullfile(pathname2,filename2), 'wt');  
fprintf(fid,'%s %s\n', 'x, y data extracted from ', [pathname1, filename1]); 
if n==1   %because x{i} becomes invalid symbol below if n=1 
fprintf(fid,'%s\t %s\n', '      x1', '      y1'); 
fprintf(fid,'%g\t %g\n', [x;y]); 
elseif n > 1

%x{1}=x1 series, y{1} is y1 series, etc.
%find out maximum x{i} length 
maxsize=length(x{1});  
for i=2:n
    if length(x{i}) > maxsize
        maxsize=length(x{i});
    end
end

%find out whether all the x series are the same   
xseriessame=1;
for i=2:n
    if isequal(x{1},x{i})==0  %0 means not equal
        xseriessame=0;
    end
end

if xseriessame==1;  %write x y1 y2... header
fprintf(fid,'All the x series in the figure are found to be the same.\n');
fprintf(fid,'       x\t');
    for i=1:n
    fprintf(fid,'       y%g\t',i);
    end
fprintf(fid,'\n'); %carriage return for header line

%Write each x,y pair horizontally in the output file
    for j=1:maxsize
        fprintf(fid,'%g\t',x{1}(j));  %x series are the same! Write x{1} for all
        for i=1:n
            fprintf(fid,'%g\t',y{i}(j));
        end
    fprintf(fid,'\n');  %carriage return at end of each row
    end
elseif xseriessame==0

%write x, y column header
for i=1:n
       fprintf(fid,'       x%g\t        y%g\t',i,i);
end
fprintf(fid,'\n'); %carriage return for header line

%Write each x,y pair horizontally in the output file
for j=1:maxsize
        for i=1:n
            if j > length(x{i})   %the x-y pair has ended earlier than others
                fprintf(fid,'\t \t');  %mark current x, y as empty
            elseif j <= length(x{i})
                fprintf(fid,'%g\t %g\t',x{i}(j),y{i}(j));
            end
        end
fprintf(fid,'\n');  %carriage return at end of each row
end

end   %ending elseif xseriessame==0 statement
end   %ending elseif n>1 statement

fclose(fid);
message{1}='Output from last run:';
message{3}=sprintf('File = %s',filename2);
message{5}=sprintf('Directory = %s',pathname2);
set(handles.text4,'String',message);
set(handles.pushbutton2,'Visible','on')

% --------------------------------------------------------------------
function viewfigure_Callback(hObject, eventdata, handles)
% hObject    handle to viewfigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname]=uigetfile('*.fig','Select a figure file to extract x-y data');
if isequal(filename,0) | isequal(pathname,0); return; end %User pressed Cancel
s=hgload(fullfile(pathname,filename));

% --------------------------------------------------------------------
function viewExcelfile_Callback(hObject, eventdata, handles)
% hObject    handle to viewExcelfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname]=uigetfile('*.xls; *.xlsx','Select a figure file to extract x-y data');
if isequal(filename,0) | isequal(pathname,0); return; end %User pressed Cancel
winopen(fullfile(pathname,filename));


% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
message{1}='This freeware was coded by:';
message{2}='Dr. Tingyue Gu ( gu@ohio.edu )';
message{3}='Department of Chemical and Biomolecular Eng.';
message{4}='Ohio University, Athens, Ohio 45701, USA';
msgbox(message,'About MfigExtract','none');

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname2 filename2 
winopen(fullfile(pathname2,filename2))



% Author - Sandeep Sasidharan
% 
% During M.tech Program - IIT Kanpur
% 
% Contact - sandeep40@gmail.com; sasidhar.sandeep@gmail.com
% 
% Home Page - http://sandeepsasidharan.webs.com


% READS THE PUBLIC HEADER BLOCK AND VARIABLE RECORD LENGTHS OF LAS FILES


function varargout = LASreader(varargin)
% LASREADER M-file for LASreader.fig
%      LASREADER, by itself, creates a new LASREADER or raises the existing
%      singleton*.
%
%      H = LASREADER returns the handle to a new LASREADER or the handle to
%      the existing singleton*.
%
%      LASREADER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LASREADER.M with the given input arguments.
%
%      LASREADER('Property','Value',...) creates a new LASREADER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LASreader_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LASreader_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LASreader

% Last Modified by GUIDE v2.5 02-Mar-2011 00:38:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LASreader_OpeningFcn, ...
                   'gui_OutputFcn',  @LASreader_OutputFcn, ...
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


% --- Executes just before LASreader is made visible.
function LASreader_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LASreader (see VARARGIN)

% Choose default command line output for LASreader
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LASreader wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LASreader_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
clc
val=get(handles.popupmenu1,'Value');
if val ~=1
    msgbox('Please upgrade your Software','Error');
    set(handles.popupmenu1,'Value','1');
    pause(0.001);
end
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fid pid FileSignature Reserved GUIDE1 GUIDE2 GUIDE3 GUIDE4 VersionMajor VersionMinor SystemIdentifier GeneratingSoftware FlightDateJulian Year
global HeaderSize Offsettodata NoOfVariableLengthRecords PointDataRecordLength NoOfPointRecords NoOfpointsbyReturn1 NoOfpointsbyReturn2
global PointDataFormatID NoOfpointsbyReturn3 NoOfpointsbyReturn4 NoOfpointsbyReturn5 XScaleFactor YScaleFactor ZScaleFactor XOffset YOffset ZOffset MaxX MaxY MaxZ MinX MinY MinZ
global A B C D E
[F_name,F_path] = uigetfile('*.las','Select the LAS file ','multiselect','on'); 
set(handles.edit1,'String',F_path);
pause(0.001);
set(handles.text2,'ForegroundColor','Black');
set(handles.text2,'String','Loading the LAS file');
pause(0.001);
fid = fopen([F_path,F_name],'r');

% Check whether the file is valid
if fid == -1
    error('Error opening file')
end
FileSignature = fread(fid,4,'uchar');
Reserved=fread(fid,4,'uchar');
GUIDE1 = fread(fid,4);
GUIDE2 = fread(fid,4);
GUIDE3 = fread(fid,4);
GUIDE4 = fread(fid,4);
VersionMajor = fread(fid,1);
VersionMinor = fread(fid,1);
SystemIdentifier = fread(fid,32);
SystemIdentifier=char(SystemIdentifier');
GeneratingSoftware = fread(fid,32,'char');
FlightDateJulian = fread(fid,1,'short');
Year = fread(fid,1,'short');
HeaderSize = fread(fid,1,'short');
Offsettodata = fread(fid,1,'long');
NoOfVariableLengthRecords = fread(fid,1,'long');
PointDataFormatID= fread(fid,1,'uchar');
PointDataRecordLength = fread(fid,1,'short');
NoOfPointRecords = fread(fid,1,'long');
NoOfpointsbyReturn1= fread(fid,1,'long');
NoOfpointsbyReturn2= fread(fid,1,'long');
NoOfpointsbyReturn3= fread(fid,1,'long');
NoOfpointsbyReturn4= fread(fid,1,'long');
NoOfpointsbyReturn5= fread(fid,1,'long');
XScaleFactor = fread(fid,1,'double');
YScaleFactor = fread(fid,1,'double');
ZScaleFactor = fread(fid,1,'double');
XOffset = fread(fid,1,'double');
YOffset = fread(fid,1,'double');
ZOffset = fread(fid,1,'double');
MaxX= fread(fid,1,'double');
MinX= fread(fid,1,'double');
MaxY= fread(fid,1,'double');
MinY= fread(fid,1,'double');
MaxZ= fread(fid,1,'double');
MinZ= fread(fid,1,'double');
pid=fid;

for i=1:NoOfVariableLengthRecords
RecordSignature = fread(fid,1,'ushort');
A{i}=RecordSignature;
UserID = fread(fid,16,'char');
UserID=char(UserID');
B{i}=UserID;
RecordID = fread(fid,1,'ushort');
C{i}=RecordID;
RecordLengthAfterHeader = fread(fid,1,'ushort');
D{i}=RecordLengthAfterHeader;
Description = fread(fid,32,'char');
Description=char(Description');
E{i}=Description;
fseek(fid,RecordLengthAfterHeader,'cof');
end
clc
set(handles.listbox2,'String',{strcat('Record Signature = ',num2str(dec2hex(A{1}))),strcat('User ID = ',num2str(B{1})),strcat('Record ID = ',num2str(C{1})),strcat('Record Length After Header = ',num2str(D{1})),strcat('Description = ',num2str(E{1})),strcat('Record Signature = ',num2str(dec2hex(A{2}))),strcat('User ID = ',num2str(B{2})),strcat('Record ID = ',num2str(C{2})),strcat('Record Length After Header = ',num2str(D{2})),strcat('Description = ',num2str(E{2})),strcat('Record Signature = ',num2str(dec2hex(A{3}))),strcat('User ID = ',num2str(B{3})),strcat('Record ID = ',num2str(C{3})),strcat('Record Length After Header = ',num2str(D{3})),strcat('Description = ',num2str(E{3}))});%,strcat('Record Signature = ',num2str(dec2hex((A(3)))))});
set(handles.pushbutton2,'Enable','On');
set(handles.text2,'ForegroundColor','Green');
set(handles.text2,'String','LAS file loaded sucessfully');
pause(0.001);
set(handles.listbox1,'String', {strcat('File Signature =',FileSignature'),strcat('Reserved = ',num2str(Reserved')),strcat('GUID data 1 = ',num2str(GUIDE1')),strcat('GUID data 2 = ',num2str(GUIDE2')),strcat('GUID data 3 = ',num2str(GUIDE3')),strcat('GUID data 4 =',num2str(GUIDE4')),strcat('Version Major =',num2str(VersionMajor)),strcat('Version Minor = ',num2str(VersionMinor)),strcat('System Identifier = ',num2str(SystemIdentifier)),strcat('Generating Software = ',GeneratingSoftware'),strcat('Flight Date Julian = ',num2str(FlightDateJulian)),strcat('Year = ',num2str(Year)),strcat('Header Size = ',num2str(HeaderSize)),strcat('Offset to data = ',num2str(Offsettodata)),strcat('No Of Variable LengthRecords = ',num2str(NoOfVariableLengthRecords)),strcat('Point Data Format ID = ',num2str(PointDataFormatID)),strcat('Point Data Record Length = ',num2str(PointDataRecordLength)),strcat('No Of Point Records = ',num2str(NoOfPointRecords)),strcat('No Of points by Return 1 = ',num2str(NoOfpointsbyReturn1)),strcat('No Of points by Return 2 = ',num2str(NoOfpointsbyReturn2)),strcat('No Of points by Return 3 = ',num2str(NoOfpointsbyReturn3)),strcat('No Of points by Return 4 = ',num2str(NoOfpointsbyReturn4)),strcat('No Of points by Return 5 = ',num2str(NoOfpointsbyReturn5)),strcat('X Scale Factor = ',num2str(XScaleFactor)),strcat('Y Scale Factor = ',num2str(YScaleFactor)),strcat('Z Scale Factor = ',num2str(ZScaleFactor)),strcat('X Offset = ',num2str(XOffset)),strcat('Y Offset = ',num2str(YOffset)),strcat('Z Offset = ',num2str(ZOffset)),strcat('Max X = ',num2str(MaxX)),strcat('Min X = ',num2str(MinX)),strcat('Max Y = ',num2str(MaxY)),strcat('Min Y = ',num2str(MinY)),strcat('Max Z = ',num2str(MaxZ)),strcat('Min Z = ',num2str(MinZ))});

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


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


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global fid oid FileSignature Reserved GUIDE1 GUIDE2 GUIDE3 GUIDE4 VersionMajor VersionMinor SystemIdentifier GeneratingSoftware FlightDateJulian Year
global HeaderSize Offsettodata NoOfVariableLengthRecords PointDataRecordLength NoOfPointRecords NoOfpointsbyReturn1 NoOfpointsbyReturn2
global PointDataFormatID NoOfpointsbyReturn3 NoOfpointsbyReturn4 NoOfpointsbyReturn5 XScaleFactor YScaleFactor ZScaleFactor XOffset YOffset ZOffset MaxX MaxY MaxZ MinX MinY MinZ
global A B C D E
[Fname,Fpath] = uiputfile('*.txt','Save output file '); 
path=strcat(Fpath,'\',Fname);
oid=fopen(path,'w');
fprintf(oid,' %s','PUBLIC HEADER RECORDS');
fprintf(oid,'\n %s','----------------------');
fprintf(oid,'\n %s = %s ','File Signature',FileSignature);
fprintf(oid,'\n %s = %s ','Reserved',num2str(Reserved'));
fprintf(oid,'\n %s = %s ','GUID data 1',num2str(GUIDE1'));
fprintf(oid,'\n %s = %s ','GUID data 2',num2str(GUIDE2'));
fprintf(oid,'\n %s = %s ','GUID data 3',num2str(GUIDE3'));
fprintf(oid,'\n %s = %s ','GUID data 4',num2str(GUIDE4'));
fprintf(oid,'\n %s = %d ','Version Major',VersionMajor);
fprintf(oid,'\n %s = %d ','Version Minor',VersionMinor);
fprintf(oid,'\n %s = %s \n ','System Identifier',strtrim (SystemIdentifier'));
fprintf(oid,'%s %c %s','Generating Software','=',GeneratingSoftware);
fprintf(oid,'\n %s %c %hu ','Flight Date Julian','=',FlightDateJulian);
fprintf(oid,'\n %s %c %hu ','Year','=',Year);
fprintf(oid,'\n %s %c %hu ','Header Size','=',HeaderSize);
fprintf(oid,'\n %s %c %d ','Offset to data','=',Offsettodata);
fprintf(oid,'\n %s = %d ','No Of Variable LengthRecords',NoOfVariableLengthRecords);
fprintf(oid,'\n %s = %i ','Point Data Format ID',PointDataFormatID);
fprintf(oid,'\n %s = %i ','Point Data Record Length',PointDataRecordLength);
fprintf(oid,'\n %s = %d ','No Of Point Records',NoOfPointRecords);
fprintf(oid,'\n %s = %d ','No Of points by Return 1',NoOfpointsbyReturn1);
fprintf(oid,'\n %s = %d ','No Of points by Return 2',NoOfpointsbyReturn2);
fprintf(oid,'\n %s = %d ','No Of points by Return 3',NoOfpointsbyReturn3);
fprintf(oid,'\n %s = %d ','No Of points by Return 4',NoOfpointsbyReturn4);
fprintf(oid,'\n %s = %d ','No Of points by Return 5',NoOfpointsbyReturn5);
fprintf(oid,'\n %s = %f ','X Scale Factor',XScaleFactor);
fprintf(oid,'\n %s = %f ','Y Scale Factor',YScaleFactor);
fprintf(oid,'\n %s = %f ','Z Scale Factor',ZScaleFactor);
fprintf(oid,'\n %s = %f ','X Offset',XOffset);
fprintf(oid,'\n %s = %f ','Y Offset',YOffset);
fprintf(oid,'\n %s = %f ','Z Offset',ZOffset);
fprintf(oid,'\n %s = %f ','Max X',MaxX);
fprintf(oid,'\n %s = %f ','Min X',MinX);
fprintf(oid,'\n %s = %f ','Max Y',MaxY);
fprintf(oid,'\n %s = %f ','Min Y',MinY);
fprintf(oid,'\n %s = %f ','Max Z',MaxZ);
fprintf(oid,'\n %s = %f ','Min Z',MinZ);


for i=1:NoOfVariableLengthRecords
fprintf(oid,'\n \n %s','VARIABLE DATA RECORDS');
fprintf(oid,'\n %s','----------------------');
fprintf(oid,'\n %s %c %X ','Record Signature','=',A{i});
fprintf(oid,'\n %s %c %s ','User ID','=',B{i});
fprintf(oid,'\n %s %c %d ','Record ID','=',C{i});
fprintf(oid,'\n %s %c %d ','Record Length After Header','=',D{i});
fprintf(oid,'\n %s %c %s ','Description','=',strtrim(E{i}));
fseek(fid,D{i},'cof');
end
fclose(fid);
fclose(oid);

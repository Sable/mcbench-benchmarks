function varargout = mweka(varargin)
%global hLine
% MWEKA M-file for mweka.fig
%      MWEKA, by itself, creates a new MWEKA or raises the existing
%      singleton*.
%
%      H = MWEKA returns the handle to a new MWEKA or the handle to
%      the existing singleton*.
%
%      MWEKA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MWEKA.M with the given input arguments.
%
%      MWEKA('Property','Value',...) creates a new MWEKA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mweka_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mweka_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mweka

% Last Modified by GUIDE v2.5 24-Jul-2009 12:19:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mweka_OpeningFcn, ...
                   'gui_OutputFcn',  @mweka_OutputFcn, ...
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


% --- Executes just before mweka is made visible.
function mweka_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mweka (see VARARGIN)

classifiers = getclass('GenericObjectEditor.props');
set(handles.popupmenu_classifier, 'String',classifiers);

% Get preferance
% if ispref('MWEKA')
%     wekapath = getpref('MWEKA','wekapath');
%     classname = getpref('MWEKA','classname');
%     trainfile = getpref('MWEKA','trainfile');
%     testfile = getpref('MWEKA','testfile');
%     set(handles.edit_jarfile,'String',wekapath);
%     set(handles.edit_TrainFile,'String',trainfile);
%     set(handles.edit_TestFile,'String',testfile);
%     ind =findindex(classifiers,classname);
%     set(handles.popupmenu_classifier, 'Value',ind);
% end
set(handles.edit_jarfile,'String',[pwd '\weka.jar']);
set(handles.edit_TrainFile,'String',[pwd '\train.arff']);
set(handles.edit_TestFile,'String',[pwd '\test.arff']);

set(handles.axes_main,'visible','off')
set(handles.axes_left,'visible','off')
set(handles.axes_right,'visible','off')
set(handles.edit_output,'Visible','off')
set(handles.uipanel_output,'Title','');
addmemo(handles.memo,'Welcome to MWEKA');

handles.stop = false;

axes(handles.axes_gif);
[A1 map]= imread('weka3.gif') ;
image(A1)
axis off
colormap(map) 
% Choose default command line output for mweka
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mweka wait for user response (see UIRESUME)
% uiwait(handles.wekaguifig);



% --- Outputs from this function are returned to the command line.
function varargout = mweka_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%--------------------------------------------------------------------------
function ind =findindex(classifiers,classname) 
ind=1;
nlines = size(classifiers,2);
for i=1:nlines
    if strcmp(classifiers(i),classname)
        ind=i;
        break
    end
end


function edit_TrainFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TrainFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TrainFile as text
%        str2double(get(hObject,'String')) returns contents of edit_TrainFile as a double
tfile = get(hObject,'String');
fexist = exist(tfile,'file');
if fexist ~= 2
        addmemo(handles.memo,['Training file: "' tfile '" does not exist.'])
        return
end
refreshList(handles,get(handles.edit_TrainFile,'String'));


% --- Executes during object creation, after setting all properties.
function edit_TrainFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TrainFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_browse.
function pushbutton_browse_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[trainFile, PName] = uigetfile( ...
                    {'*.arff',  'ARFF-files (*.arff)'; ...
                    '*.dat','Data-files (*.dat)'; ...
                     '*.txt','Text-files (*.txt)'; ...
                    '*.mat','MAT-Files (*.mat)'; ...
                    '*.*',  'All Files (*.*)'}, ...
                    'Select a Training file');
if isequal(trainFile,0)
   %errordlg('User selected Cancel.','Open File')
else
  addmemo(handles.memo,'Please wait while loading arff file...')  
  file=fullfile(PName,trainFile);
  refreshList(handles,file);
  set(handles.edit_TrainFile,'string', file);
  set(handles.pushbutton_run,'Enable','on')
end


% --- Executes on selection change in listbox_attributes.
function listbox_attributes_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_attributes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox_attributes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_attributes
if ~isfield(handles,'ResultsData') 
    ind = get(handles.listbox_attributes,'Value')';
    all_string = get(handles.listbox_attributes,'String');
    string_selected = all_string(ind);
    hf = guidata(handles.wekaguifig);
    data = hf.data(:,ind);
    plot(handles.axes_main,data)
    xlim([0 length(data)])
    set(handles.axes_main,'visible','on')
    legend(handles.axes_main,string_selected)
    set(handles.uipanel_output,'Visible','off')
end

% --- Executes during object creation, after setting all properties.
function listbox_attributes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_attributes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_run.
function pushbutton_run_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
%try
addmemo(handles.memo,'Please wait while running weka...')
%animate(handles)


trainFile= 'filtertraindata.arff';
testFile= 'filtertestdata.arff';

% Select attributes name from Listbox
all_string = get(handles.listbox_attributes,'String');
index_selected = get(handles.listbox_attributes,'Value')';
string_selected = all_string(index_selected);
%hf = guidata(handles.wekaguifig);

% Create new arff file based on the attributes selected from the list
%[extractedData, attNameExtracted,attTypeToUsed]= extractData(string_selected',all_string',handles.data,handles.trainAttType); 
extractedData=handles.data(:,index_selected);
attTypeToUsed=handles.trainAttType(index_selected);
attNameExtracted=string_selected';

% Output attributes
index_output = get(handles.popupmenu_output,'Value')';
output_data = handles.data(:,index_output);
output_attName=all_string(index_output);
output_attType=handles.trainAttType(index_output);
handles.outputname = output_attName;

% add output to the end of data
attNameExtracted =[attNameExtracted output_attName];
attTypeToUsed = [attTypeToUsed output_attType];
extractedData = [extractedData output_data];
RelName = handles.trainRelName;

arffWrite(trainFile,RelName,attNameExtracted,attTypeToUsed,extractedData);
handles.attSelected=string_selected;
handles.nTrainData = length(output_data);

% test data read
originalTestFile = get(handles.edit_TestFile,'String');
fexist = exist(originalTestFile,'file');
if fexist ~= 2
  addmemo(handles.memo,['Test file: "' originalTestFile '" does not exist.'])
  return
end
[testRelName,testAttName, testAttType,testdata]= arffread(originalTestFile);
%[extractedTestData, attNameTestExtracted,attTestTypeToUsed]= extractData(string_selected',all_string',testdata,testAttType); 
attNameTestExtracted = testAttName(index_selected);
extractedTestDataType = testAttType(index_selected);
extractedTestData = testdata(:,index_selected);


% Output attributes
output_attName=testAttName(index_output);
output_attType=testAttType(index_output);
output_data = testdata(:,index_output);
handles.nTestData = length(output_data);

% add output to the end of data
attNameTestExtracted =[attNameTestExtracted output_attName];
extractedTestDataType = [extractedTestDataType output_attType];
extractedTestData = [extractedTestData output_data];

arffWrite(testFile,RelName,attNameTestExtracted,extractedTestDataType,extractedTestData);

%% Classifier options
% if ~isfield(handles,'ImportedWeka') 
%     %jpath = 'c:\Program Files\Weka-3-2\weka.jar';
%     javapath = get(handles.edit_jarfile,'String');
%     fexist = exist(javapath,'file');
%     if fexist ~= 2
%         addmemo(handles.memo,['Weka jar file: "' javapath '" does not exist.'])
%         return
%     end
%     import weka.*
%     javaclasspath(javapath)
%     handles.ImportedWeka = true;
% end
handles = addclasspath(handles);
if isfield(handles,'classifier') 
    classifier = handles.classifier;
else
    str = get(handles.popupmenu_classifier, 'String');
    val = get(handles.popupmenu_classifier,'Value');
    classname = str{val};
    classifier = eval(classname);
    handles.classifier=classifier;
    handles.classname=classname;
end

if isprop(classifier,'Options');
    classoption=get(classifier,'Options');
else
    classoption = '';
end
classoption=cell2str(classoption,' ');
% Provide extra space
classoption = [' ' classoption];
jcp = 'java -cp ';
% Java classpath
javapath = get(handles.edit_jarfile,'String');
javapath = [' "' javapath '"'];

%Java class name
classname=handles.classname;
classname=[' ' classname];

t = ' -t ' ;
T = ' -T ';
savemodel = ' -d "model.mod"';   % Saving the model result
loadmodel = ' -l "model.mod"';   % Loading the model result
P = ' -p 0 > ';

% Training and Test file
trainFile= [ '"' trainFile '"'];
testFile= [ '"' testFile '"'];

resTrainFile = 'res_train.arff';
resTestFile = 'res_test.arff';
classout_train = 'class_train.out';
classout_test= 'class_test.out';
out1= [' -i > ' classout_train];
out2= [' -i > ' classout_test];

% strTraining = [jcp  javapath classname classoption t trainFile  T  trainFile dmodel ' -i > m.out']
% dos(strTraining);
%strTraining = [jcp  javapath classname classoption t trainFile  T  trainFile dmodel P resTrainFile];
%strTest = [jcp  javapath classname lmodel  T  testFile P resTestFile];
strTraining = [jcp  javapath classname classoption t trainFile  T  trainFile savemodel out1];
strTest = [jcp  javapath classname loadmodel  T  testFile out2];

% Running java
dos(strTraining);
dos(strTest);

% In order to see the classifiers again we have to run the model
%strTrainingDisp = [jcp  javapath classname classoption t trainFile  T  trainFile dmodel out1];
%strTrainingDisp = [jcp  javapath classname  lmodel  T  trainFile out1];
strTrainRes = [jcp  javapath classname loadmodel T trainFile P resTrainFile];
dos(strTrainRes);
strTestRes = [jcp  javapath classname loadmodel  T  testFile P resTestFile];
dos(strTestRes);
%**************************************************************************
% Loading result file
res_train= importdata(resTrainFile); 
res_test= importdata(resTestFile); 
obs_traindata =res_train(:,end);
pred_traindata =res_train(:,end-1);

obs_testdata =res_test(:,end);
pred_testdata  =res_test(:,end-1);

% Read training out file
classresult = getclassifierout(handles,classout_train,classout_test);


%% Cofficient of Correlation
warning('off','MATLAB:dispatcher:InexactCaseMatch');
coef_train = corrcoef(obs_traindata,pred_traindata);
coef_test = corrcoef(obs_testdata,pred_testdata);
coef_train = coef_train(1,2); 
coef_test = coef_test(1,2);

handles.obs_testdata=obs_testdata;
handles.pred_testdata=pred_testdata;
handles.classoutput=classresult;

updateResultList(hObject,handles,coef_train,coef_test)
handles = guidata(handles.wekaguifig);
ResultsData = handles.ResultsData;
% Determine the maximum run number currently used.
runNumber = ResultsData(length(ResultsData)).RunNumber;
% Plotting verification data
set(handles.axes_main,'visible','on')
set(handles.axes_left,'visible','on')
set(handles.axes_right,'visible','on')
ndata = length(obs_testdata);
x=1:ndata;

myplot(handles.axes_main,x,[obs_testdata pred_testdata],'main',runNumber)
handles.plottedYData = [obs_testdata pred_testdata];
handles.plottedXData = x;
handles.runSelected = runNumber;
set(handles.ResultsList,'Value',runNumber);

% Default zoom position
ymax = max(obs_testdata);
% Left axis
if runNumber==1
    xleft(1) = 1;
    xleft(2) = floor(ndata/3);
%right axis
    xright(1) = floor(ndata*2/3);
    xright(2) = ndata;
else   % use the last xlim
    xleft=floor(get(handles.axes_left,'XLim'));
    xright=floor(get(handles.axes_right,'XLim'));
end


myplot(handles.axes_left,x,[obs_testdata pred_testdata],'zoom',[],xleft)

myplot(handles.axes_right,x,[obs_testdata pred_testdata],'zoom',[],xright)

msg{1}=['Finished... ' handles.classname ' (Run ' num2str(runNumber) ')'];
msg{2} = ['Corr. Coef on training data: ' num2str(coef_train)];
msg{3} = ['Corr. Coef. on test data: ' num2str(coef_test)];
%msgbox(msg,'Performance of Weka')

guidata(hObject,handles);
axis(handles.axes_main);
h_axes_main=handles.axes_main;
f = handles.wekaguifig;

% Event for zooming in the bottom axes
if runNumber~=1 && get(handles.radiobutton_left,'Value') ~=1
	xleft = xright;
end
hLine = line([xleft(1) xleft(1)], [0 ymax], ...
    'Parent',h_axes_main,...
    'color'    , 'red',    ...
    'linewidth', 3,'Tag','hLine');

hLineRight = line([xleft(2) xleft(2)], [0 ymax], ...
    'Parent',h_axes_main,...
    'color'    , 'red',    ...
    'linewidth', 3,'Tag','hLineRight');

set(hLine,'ButtonDownFcn',{@startDragFcn,handles,hLine,hLineRight});
set(hLineRight,'ButtonDownFcn',{@startDragFcn,handles,hLineRight,hLine});
set(f,'WindowButtonUpFcn', {@stopDragFcn,f});

% handles.hLine = hLine;
% handles.hLineRight=hLineRight;
guidata(hObject,handles);
%% Store the classifier result

%addmemo(handles.memo,classresult)
displayoutput(handles.edit_output,classresult);
set(handles.uipanel_about,'Visible','off')
set(handles.edit_output,'Visible','on')
if get(handles.radiobutton_fig,'Value')==1
    set(handles.uipanel_output,'Visible','off')
    set(handles.uipanel_fig,'Visible','on')
else
    set(handles.uipanel_output,'Visible','on');
end
% catch
%     err=lasterror;
%     status = err.message;
%     if ~isempty(status)
%         msg = status;
%     end
% end
addmemo(handles.memo,msg)
set(handles.pushbutton_view,'Enable','on')
set(handles.pushbutton_save,'Enable','on')

    
function classresult = getclassifierout(fighandles,outTrain,outTest)
cellStr = textread(outTrain,'%s','delimiter','\n','whitespace','');
nlines = size(cellStr,1);
testlocation = '=== Error on test data ===';
for i=1:nlines
    if strcmp(cellStr(i),testlocation)
        loc1=i;
        break
    end
end

cellStrTest = textread(outTest,'%s','delimiter','\n','whitespace','');
nlinesTest = size(cellStrTest,1);
testlocation = '=== Error on test data ===';
for i=1:nlinesTest
    if strcmp(cellStrTest(i),testlocation)
        loc2=i;
        break
    end
end

cellStr1 = cellStr(3:loc1);
cellStr2 = cellStrTest(loc2+1:end);
 
% Heading of the run information
nattr =length(fighandles.attSelected); 
heading{1} ='=== Run information ===';
heading{2} ='';
heading{3} =['Scheme:       ' fighandles.classname ' ' cellStr{2}];
heading{4} =['Relation:       ' fighandles.trainRelName];
heading{5} =['Instances:     ' num2str(fighandles.nTrainData)];
heading{6} =['Attributes:     ' num2str(nattr)];
for i=1:nattr
    heading{6+i} = ['                    ' fighandles.attSelected{i}];
end
heading{6+nattr+1}=  ['                    ' fighandles.outputname{1}];   
heading{6+nattr+1+1}=  ['Test mode:    user supplied test set: ' num2str(fighandles.nTestData) ' instances']; 
heading{6+nattr+1+2} ='';
heading{6+nattr+1+3} = '=== Classifier model (full training set) ===';
heading = heading';
classresult = [heading;cellStr1;cellStr2];

%% ZOOM FUNCTION
function startDragFcn(varargin) 
 Handles=varargin{3};
 hCurrent=varargin{4};
 hNext=varargin{5};
 f = Handles.wekaguifig;
 mainAxis = Handles.axes_main;
 if get(Handles.radiobutton_left,'Value') ==1
     zoomAxis = Handles.axes_left;
 else
     zoomAxis = Handles.axes_right;
 end
set(f, 'WindowButtonMotionFcn', {@draggingFcn,mainAxis,zoomAxis,hCurrent,hNext})

%% ------------------------------------------------------------------------
function draggingFcn(varargin)
aH=varargin{3};
h_left=varargin{4};
hCurrent=varargin{5};
hNext=varargin{6};
pt = get(aH, 'CurrentPoint');
set(hCurrent, 'XData', pt(1)*[1 1]);

axis(h_left);
x1=get(hNext,'XData');
if x1(1) < pt(1,1)
    newxlim=[x1(1) pt(1,1)];
    set(h_left,'XLim',newxlim);
else
    newxlim=[pt(1,1) x1(1)];
    set(h_left,'XLim',newxlim);
end

%%-------------------------------------------------------------------------
function stopDragFcn(varargin)
f=varargin{1};
set(f, 'WindowButtonMotionFcn','');


% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%hf = guidata(handles.wekaguifig);
% defaultName=handles.attSelected;
% defaultName=cell2str(defaultName,',');
ResultNum = get(handles.ResultsList,'Value')';
defaultName=handles.ResultsData(ResultNum(1)).RunName;
[filename, pathname, filterindex] = uiputfile( ...
{'*.emf', 'EMF-files (*.emf)';...
'*.tiff;','TIFF Files (*.tiff)';...
 '*.eps', 'EPS-files (*.eps)';...
 '*.fig','MATLAB Figures (*.fig)';... 
 '*.*',  'All Files (*.*)'},...
 'Save as',defaultName);
if isequal(filename,0)
    %errordlg('User selected Cancel.','Open File')
else
    figName=fullfile(pathname,filename);
    %savefig(hf.obs_testdata, hf.pred_testdata,file)
    f=viewfig(handles,'off');
    [pathstr, name, ext, versn] = fileparts(figName) ;
    switch  ext
        case '.emf'
            print(f,'-dmeta', '-r2400', figName)
        case '.fig'
            saveas(f,figName)
        case '.tiff'
            print(f,'-dtiff', '-r900', figName)
        case '.eps'
            print(f,'-depsc', '-tiff','-r1200', figName)
        otherwise
            error('does not know the figure format')
    end
end


function refreshList(myHandles,trainFile)
%trainfileedt = get(myHandles.trainFileEditTxt,'string');
fexist = exist(trainFile);
if trainFile ~= 0 & fexist == 2
  [trainRelName,trainAttName, trainAttType,data]= arffread(trainFile);
  set(myHandles.listbox_attributes, 'String', trainAttName);
  set(myHandles.listbox_attributes, 'Value', 1:length(trainAttName)-1)
  set(myHandles.popupmenu_output, 'String', trainAttName);
  set(myHandles.popupmenu_output, 'Value', length(trainAttName))
  %set(myHandles.availableVarText,'String',length(trainAttName))
  %set(myHandles.dataName,'String',trainRelName)
  %set(myHandles.memo,'string', 'Training file is loaded...');
  myHandles.trainRelName = trainRelName;
  myHandles.trainAttName = trainAttName;
  myHandles.trainAttType = trainAttType;
  myHandles.data = data;
  guidata(myHandles.wekaguifig,myHandles);
else
  errordlg(['File: ' trainFile ' does not exist'],'file not found')
end


% --- Executes on button press in pushbutton_view.
function pushbutton_view_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

f = viewfig(handles,'on');

function f = viewfig(myhandles,flag)

f = figure('PaperSize',[20.98 29.68],'Position',[50 300 600 500],'visible',flag);
%f = figure('PaperSize',[20.98 29.68]);
% Create axes
axes1 = axes('Parent',f,'Position',[0.08043 0.6038 0.875013 0.3554]);
box('on');
hold('all');

x=myhandles.plottedXData ;
Ydata = myhandles.plottedYData;
ResultNum = myhandles.runSelected;
myplot(axes1,x,Ydata,'main',ResultNum)

% Create axes
axes2 = axes('Parent',f,'Position',[0.08043 0.09201 0.4089 0.4118]);

box('on');
hold('all');
%x=myhandles.zoomleft;
x=floor(get(myhandles.axes_left,'XLim'));

x=x(1):x(end);
Ydatazoom = Ydata(x,:);
myplot(axes2,x,Ydatazoom,'zoom')

% Create multiple lines using matrix input to plot
% Create axes
axes3 = axes('Parent',f,'Position',[0.5703 0.09201 0.3835 0.4133]);

box('on');
hold('all');
%x=myhandles.zoomright;
x=floor(get(myhandles.axes_right,'XLim'));
x=x(1):x(end);
Ydatazoom = Ydata(x,:);
myplot(axes3,x,Ydatazoom,'zoom')
%f=viewfig(hf.obs_testdata, hf.pred_testdata,'on');


function memo_Callback(hObject, eventdata, handles)
% hObject    handle to memo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of memo as text
%        str2double(get(hObject,'String')) returns contents of memo as a double


% --- Executes during object creation, after setting all properties.
function memo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to memo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on memo and none of its controls.
function memo_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to memo (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

%%
function addmemo(hm,string)
memostrings = get(hm,'string');
if ~iscell(memostrings)
    memocell{1}=memostrings;
else
    memocell=memostrings;
end
printdate = '                      ';
% Allow also cell string
timeandstring{1} ='';  % to have empty line
if ~iscell(string)
    timeandstring{2} =[datestr(now)  ': > ' string];
else
    for i=1:length(string)
        if i==1
            printdate = datestr(now);
        else
            printdate = '                               ';
        end
        timeandstring{i+1} =[printdate  ': > ' string{i}];
    end
end

%timeandstring{2} =[datestr(now)  ': > ' str];
memocell = [timeandstring';memocell];
set(hm,'string',memocell)
%set(hm,'ListboxTop',length(memocell))
drawnow;   % force to write in the memo

%%-------------------------------------------------------------------------
function displayoutput(hm,string)
set(hm,'string',string)
drawnow;   % force to write in the memo

% --- Executes on selection change in ResultsList.
function ResultsList_Callback(hObject, eventdata, handles)
% hObject    handle to ResultsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ResultsList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ResultsList
warning off all
ResultNum = get(handles.ResultsList,'Value')';
Ydata(:,1)=handles.obs_testdata;   % Observed data
for i=1:length(ResultNum)
    Ydata(:,i+1)=handles.ResultsData(ResultNum(i)).predVector;
end
x=handles.plottedXData ;
myplot(handles.axes_main,x,Ydata,'main',ResultNum)
handles.plottedYData = Ydata;
handles.runSelected = ResultNum;

% Bottom left
xzoom=get(handles.axes_left,'XLim');
myplot(handles.axes_left,x,Ydata,'zoom',[],xzoom)
ymax=max(max(Ydata));

xzoomright=get(handles.axes_right,'XLim');
myplot(handles.axes_right,x,Ydata,'zoom',[],xzoomright)
guidata(hObject,handles)

if get(handles.radiobutton_left,'Value') ==1
    x1= xzoom(1);
    x2 = xzoom(end);
else
    x1= xzoomright(1);
    x2 = xzoomright(end);
end

%Event for zooming in the bottom axes
hLine = line([x1 x1], [0 ymax], ...
    'Parent',handles.axes_main,...
    'color'    , 'red',    ...
    'linewidth', 3,'Tag','hLine');
hLineRight = line([x2 x2], [0 ymax], ...
    'Parent',handles.axes_main,...
    'color'    , 'red',    ...
    'linewidth', 3,'Tag','hLineRight');


f=handles.wekaguifig;
set(hLine,'ButtonDownFcn',{@startDragFcn,handles,hLine,hLineRight});
set(hLineRight,'ButtonDownFcn',{@startDragFcn,handles,hLineRight,hLine});
set(f,'WindowButtonUpFcn', {@stopDragFcn,f});
% 
% for displaying output
classoutput = handles.ResultsData(ResultNum(1)).classoutput;
displayoutput(handles.edit_output,classoutput);

if get(handles.radiobutton_fig,'Value')==1
    set(handles.uipanel_output,'Visible','off')
    set(handles.uipanel_fig,'Visible','on')
else
    set(handles.uipanel_output,'Visible','on');
end

% --- Executes during object creation, after setting all properties.
function ResultsList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ResultsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function updateResultList(obj,myHandles,Coeff_train,Coeff_test)
% Retrieve old results data structure
%hf = guidata(myHandles.wekaguifig);
defaultName=myHandles.attSelected;
runName=cell2str(defaultName,',');

if isfield(myHandles,'ResultsData') & ...
~isempty(myHandles.ResultsData)
	ResultsData = myHandles.ResultsData;
	% Determine the maximum run number currently used.
	maxNum = ResultsData(length(ResultsData)).RunNumber;
	ResultNum = maxNum+1;
else % Set up the results data structure
	ResultsData = struct('RunName',[],'RunNumber',[],...
	              'Coeff_train',[],'Coeff_test',[],...
	              'predVector',[],'classoutput',[]);
	ResultNum = 1;
end
if isequal(ResultNum,1),
	% Enable the Plot and Remove buttons
	%set([myHandles.RemoveButton,myHandles.PlotButton],'Enable','on')
end
% Get Ki and Kf values to store with the data and put in the 
% results list.
ResultsData(ResultNum).RunName = runName;
ResultsData(ResultNum).RunNumber = ResultNum;
ResultsData(ResultNum).Coeff_train = Coeff_train;
ResultsData(ResultNum).Coeff_test = Coeff_test;
ResultsData(ResultNum).predVector = myHandles.pred_testdata;
ResultsData(ResultNum).classoutput = myHandles.classoutput;
% Build the new results list string for the listbox
ResultsStr = get(myHandles.ResultsList,'String');
if isequal(ResultNum,1)
	ResultsStr = {[datestr(now,13),': Run  ' num2str(ResultNum) ': ', runName]};
else
	ResultsStr = [ResultsStr;...
	{[datestr(now,13),': Run  ' num2str(ResultNum) ': ', runName]}];
end
set(myHandles.ResultsList,'String',ResultsStr);
% Store the new ResultsData
myHandles.ResultsData = ResultsData;
guidata(obj, myHandles)

%%
function myplot(haxis,x,Y,whichplot,runSelected,axlim)

hp1 = plot(haxis,x,Y);
set(hp1(1),'color',[0.7 0.7 0.7],'LineWidth',2)
%set(hp1(2),'color','b')
if strcmp(whichplot,'main')
    set(hp1(1),'DisplayName','Target');
    for i=1:length(hp1)-1
         set(hp1(i+1),'DisplayName',['Run ' num2str(runSelected(i))]);
    end

    xlabel(haxis,'Data index')
    ylabel(haxis,'Output')
    legend(haxis,'show','Location','Best');
end
if nargin~=6
    axlim=[x(1) x(end)];
end
xlim(haxis,axlim) 



function edit_TestFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TestFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TestFile as text
%        str2double(get(hObject,'String')) returns contents of edit_TestFile as a double


% --- Executes during object creation, after setting all properties.
function edit_TestFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TestFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_testfilebrowse.
function pushbutton_testfilebrowse_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_testfilebrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, PName] = uigetfile( ...
                    {'*.arff',  'ARFF-files (*.arff)'; ...
                    '*.dat','Data-files (*.dat)'; ...
                     '*.txt','Text-files (*.txt)'; ...
                    '*.mat','MAT-Files (*.mat)'; ...
                    '*.*',  'All Files (*.*)'}, ...
                    'Select a Training file');
if isequal(file,0)
   %errordlg('User selected Cancel.','Open File')
else
  %addmemo(handles.memo,'Please wait while loading arff file...')  
  file=fullfile(PName,file);
  %refreshList(handles,handles.listbox_attributes,file);
  set(handles.edit_TestFile,'string', file);
end

% --- Executes when selected object is changed in uipanel3.
function uipanel3_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel3 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(hObject,'Tag')   % Get Tag of selected object
    case 'radiobutton_left'
        % Code for when radiobutton1 is selected.
        %handles.whichaxis ='left';
        xzoom=get(handles.axes_left,'XLim');
        
    case 'radiobutton_right'
        % Code for when radiobutton2 is selected.
        %handles.whichaxis ='right';
        xzoom=get(handles.axes_right,'XLim');
    otherwise
        % Code for when there is no match.   
end
hLine = findobj(handles.axes_main,'Tag','hLine');
hLineRight = findobj(handles.axes_main,'Tag','hLineRight');
set(hLine,'XData',[xzoom(1) xzoom(1)])
set(hLineRight,'XData',[xzoom(2) xzoom(2)])

% --- Executes on selection change in popupmenu_classifier.
function popupmenu_classifier_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_classifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_classifier contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_classifier
% if ~isfield(handles,'ImportedWeka') 
%     %jpath = 'c:\Program Files\Weka-3-2\weka.jar';
%     javapath = get(handles.edit_jarfile,'String');
%     fexist = exist(javapath,'file');
%     if fexist ~= 2
%         addmemo(handles.memo,['Weka jar file: "' javapath '" does not exist.'])
%         return
%     end
%     import weka.*
%     javaclasspath(javapath)
%     handles.ImportedWeka = true;
% end
handles = addclasspath(handles);


str = get(hObject, 'String');
val = get(hObject,'Value');
classname = str{val};
classifier = eval(classname);
%classifier.inspect
handles.classifier=classifier;
handles.classname=classname;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_classifier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_classifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_classifier.
function pushbutton_classifier_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_classifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
legend(handles.axes_main,'hide');
%set(handles.uipanel_fig,'Visible','off')
set(handles.uipanel_output,'Visible','on')



function edit_jarfile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_jarfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_jarfile as text
%        str2double(get(hObject,'String')) returns contents of edit_jarfile as a double


% --- Executes during object creation, after setting all properties.
function edit_jarfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_jarfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_jarfile.
function pushbutton_jarfile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_jarfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, PName] = uigetfile( ...
                    {'*.jar',  'Java Jar-files (*.jar)'; ...
                    '*.*',  'All Files (*.*)'}, ...
                    'Select Java Path');
if isequal(file,0)
   %errordlg('User selected Cancel.','Open File')
else
  %addmemo(handles.memo,'Please wait while loading arff file...')  
  file=fullfile(PName,file);
  %refreshList(handles,handles.listbox_attributes,file);
  set(handles.edit_jarfile,'string', file);
end



function edit_output_Callback(hObject, eventdata, handles)
% hObject    handle to edit_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_output as text
%        str2double(get(hObject,'String')) returns contents of edit_output as a double


% --- Executes during object creation, after setting all properties.
function edit_output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel9.
function uipanel9_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel9 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(hObject,'Tag')   % Get Tag of selected object
    case 'radiobutton_fig'
        % Code for when radiobutton1 is selected.
        set(handles.uipanel_fig,'Visible','on');
        set(handles.uipanel_output,'Visible','off');
        legend(handles.axes_main,'show');
    case 'radiobutton_output'
        % Code for when radiobutton2 is selected.
        %set(handles.uipanel_fig,'Visible','off');
        set(handles.edit_output,'Visible','on')
        set(handles.uipanel_output,'Visible','on');
        set(handles.uipanel_output,'Title','Classifier Output');
        otherwise
        % Code for when there is no match.
end


% --- Executes when user attempts to close wekaguifig.
function wekaguifig_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to wekaguifig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
wekapath = get(handles.edit_jarfile,'String');
str = get(handles.popupmenu_classifier, 'String');
val = get(handles.popupmenu_classifier,'Value');
classname = str{val};
trainfile = get(handles.edit_TrainFile,'String');
testfile = get(handles.edit_TestFile,'String');
setpref('MWEKA',{'wekapath','classname','trainfile','testfile'},...
                {wekapath,classname,trainfile,testfile});
delete(hObject);


% --- Executes on button press in pushbutton_showAttributes.
function pushbutton_showAttributes_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_showAttributes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
refreshList(handles,get(handles.edit_TrainFile,'String'));
set(handles.pushbutton_run,'Enable','on')

% --- Executes on key press with focus on edit_TrainFile and none of its controls.
function edit_TrainFile_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit_TrainFile (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_about.
function pushbutton_about_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_output,'Visible','off')
set(handles.uipanel_output,'Visible','on');
set(handles.uipanel_output,'Title','');
set(handles.uipanel_about,'Visible','on')
legend(handles.axes_main,'hide');


% --- Executes on selection change in popupmenu_output.
function popupmenu_output_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_output contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_output


% --- Executes during object creation, after setting all properties.
function popupmenu_output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_options.
function pushbutton_options_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(handles.popupmenu_classifier, 'String');
val = get(handles.popupmenu_classifier,'Value');
classname = str{val};
handles = addclasspath(handles);
classifier = eval(classname);
classifier.inspect
handles.classifier=classifier;
handles.classname=classname;
guidata(hObject,handles)


function handles = addclasspath(handles)
% Add java classpath
if ~isfield(handles,'ImportedWeka') 
    %jpath = 'c:\Program Files\Weka-3-2\weka.jar';
    javapath = get(handles.edit_jarfile,'String');
    fexist = exist(javapath,'file');
    if fexist ~= 2
        addmemo(handles.memo,['Weka jar file: "' javapath '" does not exist.'])
        return
    end
    import weka.*
    javaclasspath(javapath)
    handles.ImportedWeka = true;
end

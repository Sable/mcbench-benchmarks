function varargout = DEMO(varargin)
% Last Modified by GUIDE v2.5 05-Mar-2009 14:13:52

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DEMO_OpeningFcn, ...
                   'gui_OutputFcn',  @DEMO_OutputFcn, ...
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

return

% --- Executes just before DEMO is made visible.
function DEMO_OpeningFcn(hObject, eventdata, handles, varargin)
global FSSettings StopByUser

FSSettings.ErrorEstMethod      = 'ProposedAB';
FSSettings.FSMethod            = 'SFS';
%------- Classifier Settings -------
FSSettings.GammaParam          = 0.015;
FSSettings.ConfMatSwitch       = 0; 
FSSettings.PercTest            = 10; 
%-- Sequential Selection Settings -----
FSSettings.MahalInfoLossMethod = 'on';
FSSettings.TotalNStepsThres    = 250;
FSSettings.LogViewOfIntStep    = 1;
%------------- ReliefF --------------
FSSettings.NCorePatterns  = 250;
FSSettings.NHits          = 10;
%------------------------------------

handles.output = hObject;
StopByUser = 0;
axes(handles.YelLinesAxes); set(gca, 'Visible', 'off');
handles.SliderValue = 10;
warning off all
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = DEMO_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
varargout{1} = handles.output;

% -----------------Data Load and View -----------------------------
function OpenDataFile_ClickedCallback(hObject, eventdata, handles)
handles.file = uigetfile('*.*');

global StopByUser

if handles.file~=0
    % Only for viewing purpose
    [Patterns, Targets] = DataLoadAndPreprocess(handles.file);
    handles.PatternsToRunFS = Patterns;
    handles.TargetsToRunFS  = Targets;
    StopByUser = 0;

    [NPatterns, KFeatures] = size(Patterns);
    axes(handles.FeatSelCurve);cla reset;
    axes(handles.ClassResAxes); cla reset;
    axes(handles.ClassesLegendAxes); cla reset;
    set(gca,'Visible','off');
    axes(handles.YelLinesAxes); set(gca, 'Visible', 'off');
    axis manual
    axes(handles.PatternsFeaturesAxes);cla reset;
    
    if NPatterns>KFeatures
        imagesc(1.00001*Patterns'); 
        xlabel('Patterns')
        ylabel('Features','Rotation',0,'Position',[0 0]);
    else
        imagesc(1.00001*Patterns);  
        xlabel('Features')
        ylabel('Patterns','Rotation',0,'Position',[0 0]);
    end
    title(handles.file);
    colorbar;
    
     set(findobj(gcf,'Tag','ListSelFeats'), 'String', ...
         'Press Start to select features');
    guidata(hObject, handles);
end
return

% -----------------------------------------------------------------
function RunFeatSelection_ClickedCallback(hObject, eventdata, ...
                                                           handles)
global StopByUser  FSSettings

set(findobj(gcf,'Tag','ListSelFeats'), 'String', []);
axes(handles.FeatSelCurve); cla reset;
axes(handles.YelLinesAxes); cla reset; set(gca,'Visible','off',...
                                                'YDir','reverse'); 
StopByUser = 0;
guidata(hObject, handles);

FSSettings.FSMethod

if strcmp(FSSettings.FSMethod,'SFS')|| strcmp(FSSettings.FSMethod,'SFFS')
[ResultMat, ConfMatOpt, Tlapse, handles.OptimumFeatureSet,...
      OptimumCCR]= ForwSel_main(handles.file, FSSettings, handles);
elseif strcmp(FSSettings.FSMethod,'ReliefF')
[FeatureWeightsOrdered, FeaturesIndexOrdered, ...
    handles.OptimumFeatureSet] = ReliefF(handles.file,...
                                               FSSettings,handles);
elseif strcmp(FSSettings.FSMethod,'SBS') || ...
                                 strcmp(FSSettings.FSMethod,'SFBS')
[ResultMat, ConfMatOpt, Tlapse, handles.OptimumFeatureSet,...
     OptimumCCR]= BackSel_main(handles.file, FSSettings, handles);
end
handles.OptimumFeatureSet = sort(handles.OptimumFeatureSet);
guidata(hObject, handles);                         

% -----------------------------------------------------------------
function StopFeatSelButton_ClickedCallback(hObject, eventdata,...
                                                           handles)
global StopByUser
StopByUser = 1;
guidata(hObject, handles);
return

%------------------------------------------------------------------
function ListSelFeats_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), ...
                         get(0,'defaultUicontrolBackgroundColor'));
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','None Selected yet');

%------------------------------------------------------------------
function LoadAndClassifyButton_ClickedCallback(hObject,...
                                                eventdata, handles)

handles.fileToClassify = uigetfile('*.mat');
PatternsToClassify = DataLoadAndPreprocess(handles.fileToClassify);

handles.PatternsToClassify = PatternsToClassify(:,...
                                        handles.OptimumFeatureSet);

NPatternsToClassify = size(PatternsToClassify,1);       

if NPatternsToClassify >= 10   
 set(findobj(gcf,'Tag','ClassResSlider'), ...
                 'Max', NPatternsToClassify,...
                 'Min', 10, ...
                 'Value', 10, ...
       'SliderStep',[1 1]/(NPatternsToClassify-10),'Enable', 'on');
else                                    
  set(findobj(gcf,'Tag','ClassResSlider'), 'Enable', 'off');
end
  handles.SliderValue = 10;

guidata(hObject, handles);                                    
DEMO('ClassifyAndPlot',guidata(gcbo));
guidata(hObject, handles);

%------------------------------------------------------------------
function ClassResSlider_Callback(hObject, eventdata, handles)
handles.SliderValue = get(hObject,'Value');
guidata(hObject, handles);
DEMO('ClassifyAndPlot',guidata(gcbo));
guidata(hObject, handles);

%------------------------------------------------------------------
function ClassResSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), ...
                          get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%------------------------------------------------------------------
function ClassifyAndPlot(handles)

PatternsToRunFS = handles.PatternsToRunFS(:,...
                                        handles.OptimumFeatureSet);

ProbsClass = BayesClassValidationSet(PatternsToRunFS,...
               handles.TargetsToRunFS, handles.PatternsToClassify);

NPatternsToClassify = size(ProbsClass,1);            
SumProbsClass       = sum(ProbsClass,2);
                   
for IndexPatterns = 1:NPatternsToClassify
    ProbsClass(IndexPatterns,:) = ProbsClass(IndexPatterns, :) ...
                                     /SumProbsClass(IndexPatterns);
end

[Dummy, PredictionClass] = max(ProbsClass, [], 2);
[NPatterns, CClasses]    = size(ProbsClass);
axes(handles.ClassResAxes); cla reset; 
set(gca,'YDir','reverse','Color',[.925 .914 .847]);
axis([-0.5 1.5 0.5 10.5]);

CumProbsClass = [zeros(NPatterns,1) cumsum(ProbsClass,2)];
ColorsToUse   = 'rgbycmk';
YLocat        = 0;

handles.SliderValue = 10 + NPatterns - ceil(handles.SliderValue);

for IndexPattern = (handles.SliderValue-9):handles.SliderValue
    YLocat = YLocat + 1;
    if IndexPattern <= NPatterns
        for IndexClass = 1:CClasses
            hold on
            text(-0.15, YLocat, num2str(IndexPattern),...
                                   'HorizontalAlignment', 'right');
            plot(CumProbsClass(IndexPattern, ...
                IndexClass:(IndexClass+1)), ...
                YLocat*ones(1,2), ...
                ColorsToUse(IndexClass), 'LineWidth', 5);
        end
        text(1.2, YLocat, num2str(PredictionClass(IndexPattern)));
    end
end

text(-0.9  ,0.5,'Pattern #');
text(0.2   ,0.5,'P(x|\Omega_i)');
text(1     ,0.5,'Predict');
axis([-0.5 1.5 0.5 10.5]);
set(gca,'Visible','off');
drawnow

axes(handles.ClassesLegendAxes);
for IndexClass = 1:CClasses
    text(0.1, IndexClass*0.5, ['Class ' num2str(IndexClass)],...
                          'Color', ColorsToUse(IndexClass));
end
axis([0 1.5 0.5 5])    



% ------------- Menu Functions ------------------------------------
function OpenDataMenu_Callback(hObject, eventdata, handles)
DEMO('OpenDataFile_ClickedCallback',gcbo,[],guidata(gcbo));

function RunFsMenu_Callback(hObject, eventdata, handles)
DEMO('RunFeatSelection_ClickedCallback',gcbo,[],guidata(gcbo));

function StopFSMenu_Callback(hObject, eventdata, handles)
DEMO('StopFeatSelButton_ClickedCallback',gcbo,[],guidata(gcbo));

function StandardCrossMenu_Callback(hObject, eventdata, handles)
global FSSettings
FSSettings.ErrorEstMethod = 'Standard';
set(hObject,'Checked','on');
set(findobj(gcf,'Tag','ResubMenu'),'Checked','off');
set(findobj(gcf,'Tag','ProposedACrossMenu'),'Checked','off');
set(findobj(gcf,'Tag','ProposedABCrossMenu'),'Checked','off');
guidata(hObject, handles);

function ProposedACrossMenu_Callback(hObject, eventdata, handles)
global FSSettings
FSSettings.ErrorEstMethod = 'ProposedA';
set(hObject,'Checked','on');
set(findobj(gcf,'Tag','ResubMenu'),'Checked','off');
set(findobj(gcf,'Tag','ProposedABCrossMenu'),'Checked','off');
set(findobj(gcf,'Tag','StandardCrossMenu'),'Checked','off');
guidata(hObject, handles);

function ProposedABCrossMenu_Callback(hObject, eventdata, handles)
global FSSettings
FSSettings.ErrorEstMethod = 'ProposedAB';
set(hObject,'Checked','on');
set(findobj(gcf,'Tag','ResubMenu'),'Checked','off');
set(findobj(gcf,'Tag','ProposedACrossMenu'),'Checked','off');
set(findobj(gcf,'Tag','StandardCrossMenu'),'Checked','off');
guidata(hObject, handles);

function ResubMenu_Callback(hObject, eventdata, handles)
global FSSettings
FSSettings.ErrorEstMethod = 'Resubstitution';
set(hObject,'Checked','on');
set(findobj(gcf,'Tag','ProposedABCrossMenu'),'Checked','off');
set(findobj(gcf,'Tag','ProposedACrossMenu'),'Checked','off');
set(findobj(gcf,'Tag','StandardCrossMenu'),'Checked','off');
guidata(hObject, handles);

%---------------- FS Menu Functions -------------------------------
function SFS_Callback(hObject, eventdata, handles)
global FSSettings
FSSettings.FSMethod  =  'SFS';
FS_Method_ClearAllChecks(hObject, handles)
set(hObject,'Checked','on');
guidata(hObject, handles);

function SFFS_Callback(hObject, eventdata, handles)
global FSSettings
FSSettings.FSMethod  = 'SFFS';
FS_Method_ClearAllChecks(hObject, handles)
set(hObject,'Checked','on');
guidata(hObject, handles);

function ReliefF_Callback(hObject, eventdata, handles)
global FSSettings
FSSettings.FSMethod  = 'ReliefF';           
FS_Method_ClearAllChecks(hObject, handles)
set(hObject,'Checked','on');
guidata(hObject, handles);

function SBS_Callback(hObject, eventdata, handles)
global FSSettings
FSSettings.FSMethod  =  'SBS';
FS_Method_ClearAllChecks(hObject, handles)
set(hObject,'Checked','on');
guidata(hObject, handles);

function SFBS_Callback(hObject, eventdata, handles)
global FSSettings
FSSettings.FSMethod  = 'SFBS'; 
FS_Method_ClearAllChecks(hObject, handles)
set(hObject,'Checked','on');
guidata(hObject, handles);

function FS_Method_ClearAllChecks(hObject, handles)
set(findobj(gcf,'Tag','ReliefF'),'Checked','off');
set(findobj(gcf,'Tag','SFFS'),'Checked','off');
set(findobj(gcf,'Tag','SFS'),'Checked','off');
set(findobj(gcf,'Tag','SFBS'),'Checked','off');
set(findobj(gcf,'Tag','SBS'),'Checked','off');
guidata(hObject, handles);

%------------ Help Menu -------------------------------------------
function InstructionsMenu_Callback(hObject, eventdata, handles)
web([pwd '\Help\Readme.htm'])

function PubMenu_1_Callback(hObject, eventdata, handles)
open('Help\Verver_ElsSigPro_08.pdf')

function AuthorsVerverMenu_Callback(hObject, eventdata, handles)
web([pwd '\Help\AuthorsVerveridis.htm'])

function AuthorsKotroMenu_Callback(hObject, eventdata, handles)
web(['http://poseidon.csd.auth.gr/LAB_PEOPLE/CKotropoulos.htm'])
%------------------------------------------------------------------
function SettingsMenu_Callback(hObject, eventdata, handles)
global FSSettings
FSSettings = SettingsMenuFig;




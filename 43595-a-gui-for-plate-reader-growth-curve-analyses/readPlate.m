function readPlate
handles.figure = figure('Visible','off','MenuBar','None','NumberTitle','off',...
                    'Toolbar','none','HandleVisibility','callback',...
                    'Color',get(0,'defaultuicontrolbackgroundcolor'),...
                    'name','Create Plate reader plot',...
                    'Position',[320 250 900 600]);              
handles.colors = [  0.890196078 0.101960784 0.109803922;...
                0.258823529	0.57254902	0.776470588;...
                0.650980392	0.850980392	0.415686275;...
                0.996078431	0.850980392	0.462745098;...
                0.415686275	0.239215686	0.603921569;...
                1	0.498039216	0;...
                0.870588235	0.466666667	0.682352941;...
                0.694117647	0.349019608	0.156862745;...
                0.588235294	0.588235294	0.588235294;...
                0.2	0.62745098	0.17254902;...
                0.619607843	0.792156863	0.882352941;...
                0.4	0.760784314	0.647058824;...
                0.941176471	0.007843137	0.498039216;...
                0.988235294	0.803921569	0.898039216;...
                1	1	0.6;...
                0.984313725	0.603921569	0.6;...
                0.992156863	0.749019608	0.435294118;...
                0.878431373	0.509803922	0.078431373;...
                0.792156863	0.698039216	0.839215686;...
                0.003921569	0.521568627	0.443137255;...
                0.619607843	0.003921569	0.258823529;...
                0.129411765	0.443137255	0.709803922;...
                0.101960784	0.101960784	0.101960784];
handles.markers = {'none','d','^','o','s'};
handles.emptyLayout = {'','','','','','','','','','','','';...
                         '','','','','','','','','','','','';...
                         '','','','','','','','','','','','';...
                         '','','','','','','','','','','','';...
                         '','','','','','','','','','','','';...
                         '','','','','','','','','','','','';...
                         '','','','','','','','','','','','';...
                         '','','','','','','','','','','',''};
handles.emptyLayoutGroupNames = {'A1';'A2';'A3';'A4';'A5';'A6';'A7';'A8';'A9';'A10';'A11';'A12';...
                                  'B1';'B2';'B3';'B4';'B5';'B6';'B7';'B8';'B9';'B10';'B11';'B12';...
                                  'C1';'C2';'C3';'C4';'C5';'C6';'C7';'C8';'C9';'C10';'C11';'C12';...
                                  'D1';'D2';'D3';'D4';'D5';'D6';'D7';'D8';'D9';'D10';'D11';'D12';...
                                  'E1';'E2';'E3';'E4';'E5';'E6';'E7';'E8';'E9';'E10';'E11';'E12';...
                                  'F1';'F2';'F3';'F4';'F5';'F6';'F7';'F8';'F9';'F10';'F11';'F12';...
                                  'G1';'G2';'G3';'G4';'G5';'G6';'G7';'G8';'G9';'G10';'G11';'G12';...
                                  'H1';'H2';'H3';'H4';'H5';'H6';'H7';'H8';'H9';'H10';'H11';'H12'};
handles.emptyLayoutGroupWells = cellfun(@(x) {x},handles.emptyLayoutGroupNames,'uniformoutput',false);      
handles.fileName = '';
buildfcn 
callbackassignfcn

function buildfcn
    icons = load('icons.mat'); icons = icons.icons;
    handles.bigLayout = uiextras.VBox('Parent',handles.figure,'Spacing',5);
    
    handles.chooseSession.text = uicontrol('Style','text','Parent',double(handles.bigLayout),...
                                       'String',{'Choose an .mat file with a saved session inside:'},...
                                       'HandleVisibility','callback');
    handles.chooseSession.panel = uiextras.HBox('Parent',handles.bigLayout);
    handles.chooseSession.box = uicontrol('Style','edit','Parent',double(handles.chooseSession.panel),...
                                      'BackgroundColor','white','String',' ','HorizontalAlignment','left',...
                                      'HandleVisibility','callback');
    handles.chooseSession.button = uicontrol('Style','Pushbutton','Parent',double(handles.chooseSession.panel),...
                                         'String','...',...
                                         'HandleVisibility','callback');
    set(handles.chooseSession.panel,'Sizes',[-1 30]);
    
    handles.chooseFile.text = uicontrol('Style','text','Parent',double(handles.bigLayout),...
                                       'String',{'Choose an .xls or .xlsx file with the three following sheets: ''layout'',''od'',''reporter'' :'},...
                                       'HandleVisibility','callback');
    handles.chooseFile.panel = uiextras.HBox('Parent',handles.bigLayout);
    handles.chooseFile.box = uicontrol('Style','edit','Parent',double(handles.chooseFile.panel),...
                                      'BackgroundColor','white','String',' ','HorizontalAlignment','left',...
                                      'HandleVisibility','callback');
    handles.chooseFile.button = uicontrol('Style','Pushbutton','Parent',double(handles.chooseFile.panel),...
                                         'String','...',...
                                         'HandleVisibility','callback');
    set(handles.chooseFile.panel,'Sizes',[-1 30]);

    handles.gap1 = uiextras.Panel('Parent',handles.bigLayout,'BorderType','none');

    handles.plateLayout.panel = uiextras.HBox('Parent',handles.bigLayout);
    handles.plateLayout.gap2 = uiextras.Panel('Parent',handles.plateLayout.panel,'BorderType','none');
    handles.plateLayout.button = uicontrol('Style','pushbutton','Parent',double(handles.plateLayout.panel),...
                                       'String',{'Define Plate Layout'},...
                                       'HandleVisibility','callback','Enable','off');
    handles.plateLayout.gap3 = uiextras.Panel('Parent',handles.plateLayout.panel,'BorderType','none');
    set(handles.plateLayout.panel,'Sizes',[-1 120 -1]);
    handles.gap2 = uiextras.Panel('Parent',handles.bigLayout,'BorderType','none');                               
                                   
                                   
    handles.plotModePanel = uiextras.HBox('Parent',double(handles.bigLayout),'Spacing',7);
    handles.odOrReporterPanelBig = uiextras.Panel('Parent',handles.plotModePanel);                            
    handles.odOrReporterPanel = uiextras.VBox('Parent',handles.odOrReporterPanelBig,'Spacing',5);
    handles.odOrReporterText = uicontrol('Style','text','parent',double(handles.odOrReporterPanel),...
                                 'String','Which parameter to plot:',...
                                 'HandleVisibility','callback','enable','off'); 
    handles.odOrReporter = uicontrol('Style','popupmenu','parent',double(handles.odOrReporterPanel),...
                                 'String',{'OD';'Reporter'},'BackgroundColor',[0.8706 0.9216 0.9804],...
                                 'HandleVisibility','callback','enable','off');
    handles.devReporter = uicontrol('Style','checkbox','parent',double(handles.odOrReporterPanel),...
                                    'String','Devide reporter by OD','HandleVisibility','callback','enable','off');
    handles.showEachWellPanelBig = uiextras.Panel('Parent',handles.plotModePanel);                                                             
    handles.showEachWellPanel = uiextras.VBox('Parent',handles.showEachWellPanelBig,'Spacing',5);
    handles.showEachWell = uicontrol('Style','checkbox','parent',double(handles.showEachWellPanel),...
                                     'String','Show each well','HandleVisibility','callback','enable','off');   
    handles.showEachWellName = uicontrol('Style','checkbox','parent',double(handles.showEachWellPanel),...
                                        'String','Show well number','HandleVisibility','callback','enable','off');  
    handles.hideMeanLine = uicontrol('Style','checkbox','parent',double(handles.showEachWellPanel),...
                                        'String','Hide mean line','HandleVisibility','callback','enable','off');      
    handles.showErrorbarsPanel = uiextras.Panel('Parent',handles.plotModePanel);   
    handles.showErrorbars = uicontrol('Style','checkbox','parent',double(handles.showErrorbarsPanel),...
                                     'String','Show error bars','HandleVisibility','callback','enable','off'); 
    
    handles.limitsPanelBig = uiextras.Panel('Parent',handles.plotModePanel);
    handles.limitsPanelBig2 = uiextras.VBox('Parent',handles.limitsPanelBig,'Spacing',5);
    
    handles.xlimitPanel = uiextras.HBox('Parent',handles.limitsPanelBig2,'Spacing',1); 
    handles.xlimitText = uicontrol('Style','text','parent',double(handles.xlimitPanel),...
                                    'String','X limits:','HandleVisibility','callback','enable','off');
    handles.xlimitLowPanel = uiextras.HBox('Parent',handles.xlimitPanel,'Spacing',0);                             
    handles.xlimitLow1 = uicontrol('Style','edit','parent',double(handles.xlimitLowPanel),...
                                    'String',' ','HandleVisibility','callback','enable','off');
    handles.xlimitLowText1 = uicontrol('Style','text','parent',double(handles.xlimitLowPanel),...
                                    'String',':','HandleVisibility','callback','enable','off'); 
    handles.xlimitLow2 = uicontrol('Style','edit','parent',double(handles.xlimitLowPanel),...
                                    'String',' ','HandleVisibility','callback','enable','off');
    handles.xlimitText2 = uicontrol('Style','text','parent',double(handles.xlimitPanel),...
                                    'String','   -   ','HandleVisibility','callback','enable','off');
    handles.xlimitHighPanel = uiextras.HBox('Parent',handles.xlimitPanel,'Spacing',0);                                                         
    handles.xlimitHigh1 = uicontrol('Style','edit','parent',double(handles.xlimitHighPanel),...
                                    'String',' ','HandleVisibility','callback','enable','off');
    handles.xlimitHighText1 = uicontrol('Style','text','parent',double(handles.xlimitHighPanel),...
                                    'String',':','HandleVisibility','callback','enable','off'); 
    handles.xlimitHigh2 = uicontrol('Style','edit','parent',double(handles.xlimitHighPanel),...
                                    'String',' ','HandleVisibility','callback','enable','off');
    handles.xlimitReset = uicontrol('Style','Pushbutton','Parent',double(handles.xlimitPanel),...
                                    'CData',icons.reset,'TooltipString','Reset',...
                                    'HandleVisibility','Callback','enable','off');                            
    set(handles.xlimitPanel,'Sizes',[50 -1 30 -1 15]);
    
    handles.ylimitPanel = uiextras.HBox('Parent',handles.limitsPanelBig2,'Spacing',1); 
    handles.ylimitText = uicontrol('Style','text','parent',double(handles.ylimitPanel),...
                                    'String','Y limits:','HandleVisibility','callback','enable','off');
    handles.ylimitLow = uicontrol('Style','edit','parent',double(handles.ylimitPanel),...
                                    'String',' ','HandleVisibility','callback','enable','off');                           
    handles.ylimitText2  = uicontrol('Style','text','parent',double(handles.ylimitPanel),...    
                                    'String','   -   ','HandleVisibility','callback','enable','off');
    handles.ylimitHigh = uicontrol('Style','edit','parent',double(handles.ylimitPanel),...
                                    'String',' ','HandleVisibility','callback','enable','off');
    handles.ylimitReset = uicontrol('Style','Pushbutton','Parent',double(handles.ylimitPanel),...
                                    'CData',icons.reset,'TooltipString','Reset',...
                                    'HandleVisibility','Callback','enable','off');
    set(handles.ylimitPanel,'Sizes',[50 -1 30 -1 15]);
                            
    handles.table = uitable('Parent',double(handles.bigLayout),'HandleVisibility','callback',...
                        'ColumnEditable',logical([1 1 0 1 0 1 1 1 1 1]),...
                        'ColumnFormat',{'logical','logical','char','char','char','char','numeric','char','char','char'},...
                        'ColumnName',{'Select','Include','Group name','Label','Color','Marker (+,o,*,.,x,s,d,^,v,<,>,p,h,none)','Marker Size','Line style (-,--,:,-.,none)','OD blank subtract (blank group\scalar)','Reporter blank subtract (blank group\scalar)'},...
                        'ColumnWidth',{60,60,200,200,60,60,60,60,80,80},...
                        'RowName',[],'enable','off');

    handles.underTableRow = uiextras.HBox('Parent',double(handles.bigLayout));
    handles.selectAll = uicontrol('Style','toggleButton','Parent',double(handles.underTableRow),...
                                                'String','Select All',...
                                                'HandleVisibility','callback','enable','off');
    handles.selectNone = uicontrol('Style','pushbutton','Parent',double(handles.underTableRow),...
                                    'String','Select None',...
                                    'HandleVisibility','callback','enable','off');
    handles.moveUp = uicontrol('Style','pushbutton','Parent',double(handles.underTableRow),...
                                    'CData',icons.up,'Enable','off',...
                                    'HandleVisibility','callback','TooltipString','Move up');
    handles.moveDown = uicontrol('Style','pushbutton','Parent',double(handles.underTableRow),...
                                    'CData',icons.down,'Enable','off',...
                                    'HandleVisibility','callback','TooltipString','Move down');
    handles.underTableRowSpace1 = uiextras.Empty('Parent',double(handles.underTableRow)); 
    handles.autoColor = uicontrol('Style','toggleButton','Parent',double(handles.underTableRow),...
                                  'String','Auto color',...
                                  'HandleVisibility','callback','enable','off');   
    handles.semiAutoDlg = uicontrol('Style','pushbutton','Parent',double(handles.underTableRow),...
                                      'CData',icons.gradient,'TooltipString','Set color sequence',...
                                      'HandleVisibility','callback','enable','off');   
    handles.underTableRowSpace2 = uiextras.Empty('Parent',double(handles.underTableRow)); 
    handles.loadSettings = uicontrol('Style','pushbutton','Parent',double(handles.underTableRow),...
                                      'String','Copy settings from a session',...
                                      'HandleVisibility','callback','enable','off');   
    set(handles.underTableRow,'Sizes',[100 100 22 22 100 100 22 -1 155],'Spacing',10);
    
    handles.underTableRowSpace = uiextras.HBox('Parent',double(handles.bigLayout));

    handles.underTableRow2 = uiextras.HBox('Parent',double(handles.bigLayout));
    handles.cancel = uicontrol('Style','pushbutton','Parent',double(handles.underTableRow2),...
                               'String','Cancel',...
                               'HandleVisibility','Callback'); 
    handles.text = uicontrol('Style','text','Parent',double(handles.underTableRow2),...
                               'String','Specify figure name:',...
                               'HandleVisibility','Callback');   
    handles.figureName = uicontrol('Style','edit','Parent',double(handles.underTableRow2),...
                               'String',' ','BackgroundColor','white',...
                               'HandleVisibility','Callback','HorizontalAlignment','left'); 
    handles.saveSession = uicontrol('Style','pushbutton','Parent',double(handles.underTableRow2),...
                               'String','Save session',...
                               'HandleVisibility','Callback','enable','off');
    handles.createFig = uicontrol('Style','pushbutton','Parent',double(handles.underTableRow2),...
                               'String','Create figure',...
                               'HandleVisibility','Callback','enable','off');
    set(handles.underTableRow2,'Sizes',[100 100 -1 100 100],'Spacing',5);    
    set(handles.bigLayout,'Sizes',[20 20 20 20 10 30 10 70 -1 20 30 20]);
    set(handles.figure,'Visible','on');
end
function callbackassignfcn
set([handles.chooseSession.box,handles.chooseSession.button],...
                                'Callback',             @chooseSession_callback);
set([handles.chooseFile.box,handles.chooseFile.button],...
                                'Callback',             @chooseFile_callback);
set(handles.plateLayout.button, 'Callback',             @plateLayoutFnc);                            
set([handles.odOrReporter,handles.devReporter],...
                                'Callback',             @odOrReporter_callback);
set(handles.showEachWell,       'Callback',             @showEachWell_callback);
set(handles.hideMeanLine,       'Callback',             @hideMeanLine_callback);         
set([handles.xlimitLow1,handles.xlimitLow2,handles.xlimitHigh1,handles.xlimitHigh2,handles.ylimitHigh,...
     handles.ylimitLow,handles.xlimitReset,handles.ylimitReset],...
                                'Callback',             @changeLimits_callback);
set(handles.autoColor,          'Callback',             @autoColor_callback);
set(handles.loadSettings,       'Callback',             @loadSettings_callback);
set(handles.semiAutoDlg,        'Callback',             @semiAutoColor_Callback);
set([handles.selectAll,handles.selectNone],...
                                'Callback',             @tableSelectAllOrNone_callback);
set(handles.table,              'CellEditCallback',     @tableCellEdit_callback,...
                                'CellSelectionCallback',@tableChangeColor_callback); 
set([handles.moveUp,handles.moveDown],'Callback',       @tableMoveUpDown_callback);
set(handles.cancel,             'Callback',             @(~,~) delete(handles.figure));
set(handles.createFig,          'Callback',             @createFig_callback);
set(handles.saveSession,        'Callback',             @saveSession_callback);
end

function chooseSession_callback(hObject,~)
defaultPath = get(handles.chooseFile.box,'String');
if ~isempty(defaultPath)
    [defaultPath,~,~] = fileparts(defaultPath);
else
    defaultPath = get(handles.chooseSession.box,'String');
    [defaultPath,~,~] = fileparts(defaultPath);
end
if hObject == handles.chooseSession.button
	[fileName,folderName,ok] = uigetfile({'*.mat'},'Choose .mat file',defaultPath);
    fileName = [folderName,fileName];
    if ~ok
        return;
    end
else
    fileName = get(hObject,'String');
    if ~exist(fileName,'file')
        set(handles.chooseSession.box,'String',handles.session);
        errordlg('Could not open file','Error')
        return;
    end
end    
try sessionInfo = load(fileName); catch me; errordlg(me,'Could not open file');set(handles.chooseSession.box,'String',handles.session);return; end
sessionInfo = sessionInfo.sessionInfo;
if any(~isfield(sessionInfo,{'odOrReporter','devReporter','showEachWell','showEachWellName','hideMeanLine',...
                             'showErrorbars','xlimitLow1','xlimitLow2','xlimitHigh1','xlimitHigh2','ylimitLow','ylimitHigh',...
                             'autoColor','od','headers','reporter','finalData','time','groupNames','groupWells','tableData'}))
    set(handles.chooseFile.box,'String',handles.fileName);
    errordlg({'The varaible in this file does not contain the following fields:';...
              'odOrReporter, devReporter, showEachWell, showEachWellName, hideMeanLine, showErrorbars, xlimitLow1,xlimitLow2, xlimitHigh1, xlimitHigh2, ylimitLow, ylimitHigh, autoColor, od, headers, reporter, finalData, time, groupNames, groupWells, tableData'},'Error'); 
    return;
end
set(handles.odOrReporter,'Value',sessionInfo.odOrReporter);
set(handles.devReporter,'Value',sessionInfo.devReporter);
set(handles.showEachWell,'Value',sessionInfo.showEachWell);
set(handles.showEachWellName,'Value',sessionInfo.showEachWellName);
set(handles.hideMeanLine,'Value',sessionInfo.hideMeanLine);
set(handles.showErrorbars,'Value',sessionInfo.showErrorbars);
set(handles.xlimitLow1,'String',sessionInfo.xlimitLow1,'userData',str2double(sessionInfo.xlimitLow1));
set(handles.xlimitLow2,'String',sessionInfo.xlimitLow2,'userData',str2double(sessionInfo.xlimitLow2));
set(handles.xlimitHigh1,'String',sessionInfo.xlimitHigh1,'userData',str2double(sessionInfo.xlimitHigh1));
set(handles.xlimitHigh2,'String',sessionInfo.xlimitHigh2,'userData',str2double(sessionInfo.xlimitHigh2));
set(handles.ylimitLow,'String',sessionInfo.ylimitLow,'userData',str2double(sessionInfo.ylimitLow));
set(handles.ylimitHigh,'String',sessionInfo.ylimitHigh,'userData',str2double(sessionInfo.ylimitHigh));
set(handles.autoColor,'Value',sessionInfo.autoColor,'userData',sessionInfo.autoColor);
handles.od = sessionInfo.od;
handles.headers = sessionInfo.headers;
handles.reporter = sessionInfo.reporter;
handles.finalData = sessionInfo.finalData;
handles.time = sessionInfo.time;
handles.groupNames = sessionInfo.groupNames;
handles.groupWells = sessionInfo.groupWells;
handles.layout = sessionInfo.layout;
handles.tableData = sessionInfo.tableData;
handles.tableData(:,1) = {false};
set(handles.table,'Data',handles.tableData,'Enable','on');
set([handles.odOrReporter,handles.odOrReporterText,handles.showEachWell,handles.plateLayout.button,...
    handles.xlimitLow1,handles.xlimitLow2,...
    handles.xlimitHigh1,handles.xlimitHigh2,handles.ylimitHigh,handles.ylimitLow,...
    handles.xlimitReset,handles.ylimitReset,handles.ylimitText,handles.ylimitText2,...
    handles.xlimitText,handles.xlimitText2,handles.autoColor,handles.loadSettings,...
    handles.selectAll,handles.selectNone,handles.saveSession,handles.createFig],'Enable','on');
set(handles.chooseFile.box,'String','');
handles.fileName = '';
handles.session = fileName;
set(handles.chooseSession.box,'String',fileName);
[~,name,~]= fileparts(fileName);
set(handles.figureName,'string',name);
if get(handles.odOrReporter,'Value') == 1
    set(handles.devReporter,'Enable','off');
else
    set(handles.devReporter,'Enable','on');
end
if get(handles.showEachWell,'Value')
    set([handles.showEachWellName,handles.hideMeanLine],'Enable','on');
    if get(handles.hideMeanLine,'Value')
        set(handles.showErrorbars,'Enable','off');
    end
else
	set([handles.hideMeanLine,handles.showEachWellName],'Enable','off');
    set(handles.showErrorbars,'Enable','on');
end
end
function chooseFile_callback(hObject,~)
defaultPath = get(handles.chooseFile.box,'String');
if ~isempty(defaultPath)
    [defaultPath,~,~] = fileparts(defaultPath);
else
    defaultPath = get(handles.chooseSession.box,'String');
    [defaultPath,~,~] = fileparts(defaultPath);
end
if hObject == handles.chooseFile.button
	[fileName,folderName,ok] = uigetfile({'*.xlsx';'*.xls'},'Choose excle file',defaultPath);
    fileName = [folderName,fileName];
    if ~ok
        return;
    end
else
    fileName = get(hObject,'String');
    if ~exist(fileName,'file')
        set(handles.chooseFile.box,'String',handles.fileName);
        errordlg('Could not open file','Error')
        return;
    end
end    
try [~,sheets]= xlsfinfo(fileName); catch me; errordlg(me,'Could not open file');set(handles.chooseFile.box,'String',handles.fileName);return; end
if any(~ismember({'od','reporter'},sheets))
    set(handles.chooseFile.box,'String',handles.fileName);
    errordlg({'The file does not contain the following sheets:';...
              'od';...
              'reporter'},'Error'); 
    return;
end
try [handles.od,handles.headers,~] = xlsread(fileName,'od'); catch me; errordlg(me,'Could not open file');set(handles.chooseFile.box,'String',handles.fileName);return; end
try [handles.reporter,~,~] = xlsread(fileName,'reporter'); catch me; errordlg(me,'Could not open file');set(handles.chooseFile.box,'String',handles.fileName);return; end
handles.finalData = handles.od;

time = handles.od(:,1);
hours = floor(time/0.0416666666666667);
minutes = time/(0.0416666666666667/60);
minutes = floor(minutes-(hours*60));
handles.time = [hours,minutes];
handles.time(:,1) = handles.time(:,1) - handles.time(1,1);
handles.time(:,2) = handles.time(:,2) - handles.time(1,2);
set(handles.xlimitLow1,'string',sprintf('%02d',handles.time(1,1)),'userdata',handles.time(1,1));
set(handles.xlimitLow2,'string',sprintf('%02d',handles.time(1,2)),'userdata',handles.time(1,2));
set(handles.xlimitHigh1,'string',sprintf('%02d',handles.time(end,1)),'userdata',handles.time(end,1));
set(handles.xlimitHigh2,'string',sprintf('%02d',handles.time(end,2)),'userdata',handles.time(end,2));
ymin = min(min(handles.finalData(:,3:end)));
ymax = max(max(handles.finalData(:,3:end)));
set(handles.ylimitLow,'string',num2str(ymin-(ymax-ymin)*0.05),'userdata',ymin-(ymax-ymin)*0.05);
set(handles.ylimitHigh,'string',num2str(ymax+(ymax-ymin)*0.05),'userdata',ymax+(ymax-ymin)*0.05);
minuteTime = handles.time(:,1)*60 + handles.time(:,2);
handles.finalData(:,1) = minuteTime*(0.0416666666666667/60);
handles.groupNames = handles.emptyLayoutGroupNames;
handles.groupWells = handles.emptyLayoutGroupWells;
handles.layout = handles.emptyLayout;

%'Select','Include','Group name','Label','Color','Marker','Line style','Remove blank'}
handles.tableData = cell(size(handles.groupNames,1),8);
handles.tableData(:,1) = {false};
handles.tableData(:,2) = {true};
handles.tableData(:,3) = handles.groupNames';
handles.tableData(:,4) = handles.groupNames';
for i = 1:size(handles.groupNames,1)
    colorIndex = rem(i,size(handles.colors,1));
    if colorIndex~=0
        handles.tableData(i,5) = {color2htmlStr(handles.colors(colorIndex,:))};
    else
        handles.tableData(i,5) = {color2htmlStr(handles.colors(end,:))};
    end
    markerIndex = rem(floor((i-1)/size(handles.colors,1))+1,length(handles.markers));
    if markerIndex~=0
        handles.tableData(i,6) = handles.markers(markerIndex);
    else
    	handles.tableData(i,6) = handles.markers(end);
    end
end
handles.tableData(:,7) = {3};
handles.tableData(:,8) = {'-'};
handles.tableData(:,9:10) = {''};

set(handles.table,'Data',handles.tableData,'Enable','on');
set(handles.autoColor,'Value',1,'userdata',1);
set(handles.odOrReporter,'Value',1);
set(handles.showEachWell,'Value',0);
set([handles.devReporter,handles.showEachWellName,handles.hideMeanLine],'Value',0,'Enable','off');
set([handles.odOrReporter,handles.odOrReporterText,handles.showEachWell,handles.plateLayout.button...
    handles.showErrorbars,handles.xlimitLow1,handles.xlimitLow2,...
    handles.xlimitHigh1,handles.xlimitHigh2,handles.ylimitHigh,handles.ylimitLow,...
    handles.xlimitReset,handles.ylimitReset,handles.ylimitText,handles.ylimitText2,...
    handles.xlimitText,handles.xlimitText2,handles.autoColor,handles.loadSettings,...
    handles.selectAll,handles.selectNone,handles.saveSession,handles.createFig],'Enable','on');
set(handles.chooseFile.box,'String',fileName);
[~,name,~]= fileparts(fileName);
set(handles.figureName,'string',name);
handles.fileName = fileName;
set(handles.chooseSession.box,'String','');
handles.session = '';
end
function plateLayoutFnc(~,~)
set([handles.chooseSession.box,handles.chooseSession.button,handles.chooseFile.box,handles.chooseFile.button,...
     handles.plateLayout.button,handles.odOrReporter,handles.devReporter,handles.showEachWell,handles.hideMeanLine,handles.showErrorbars,...
     handles.xlimitLow1,handles.xlimitLow2,handles.xlimitHigh1,handles.xlimitHigh2,handles.ylimitHigh,...
     handles.ylimitLow,handles.xlimitReset,handles.ylimitReset,handles.autoColor,handles.loadSettings,handles.semiAutoDlg,...
     handles.selectAll,handles.selectNone,handles.table,handles.moveUp,handles.moveDown,handles.createFig,handles.saveSession],...
     'Enable','off');
 
handlesPlateLayout.plateLayoutFigure = figure('Visible','on','MenuBar','None','NumberTitle','off',...
                                    'Toolbar','none','HandleVisibility','callback',...
                                    'Color',get(0,'defaultuicontrolbackgroundcolor'),...
                                    'name','Define Plate Layout',...
                                    'Position',[320 320 940 230],...
                                    'DeleteFcn',@plateLayoutCancelSave_callback);
handlesPlateLayout.bigPanel = uiextras.VBox('Parent',handlesPlateLayout.plateLayoutFigure);
handlesPlateLayout.table = uitable('Parent',double(handlesPlateLayout.bigPanel),'HandleVisibility','callback',...
                    'Data',handles.layout,...
                    'ColumnName',{'1','2','3','4','5','6','7','8','9','10','11','12'},...
                    'RowName',{'A','B','C','D','E','F','G','H'},...
                    'ColumnFormat',{'char'},...
                    'ColumnEditable',true);
handlesPlateLayout.buttonsPanel = uiextras.HBox('Parent',handlesPlateLayout.bigPanel);
handlesPlateLayout.cancel = uicontrol('Style','pushbutton','Parent',double(handlesPlateLayout.buttonsPanel),...
                                      'String','Cancel',...
                                      'HandleVisibility','Callback',...
                                      'Callback',@plateLayoutCancelSave_callback); 
handlesPlateLayout.gap =  uiextras.Panel('Parent',handlesPlateLayout.buttonsPanel,'BorderType','none');                
handlesPlateLayout.load = uicontrol('Style','pushbutton','Parent',double(handlesPlateLayout.buttonsPanel),...
                                      'String','Copy from another session',...
                                      'HandleVisibility','Callback',...
                                      'Callback',@plateLayoutLoad_callback);  
handlesPlateLayout.gap2 =  uiextras.Panel('Parent',handlesPlateLayout.buttonsPanel,'BorderType','none');                
handlesPlateLayout.loadFromExcel = uicontrol('Style','pushbutton','Parent',double(handlesPlateLayout.buttonsPanel),...
                                             'String','Copy from Excel sheet',...
                                              'HandleVisibility','Callback',...
                                              'Callback',@plateLayoutLoad_callback);
handlesPlateLayout.gap3 =  uiextras.Panel('Parent',handlesPlateLayout.buttonsPanel,'BorderType','none');                
handlesPlateLayout.save = uicontrol('Style','pushbutton','Parent',double(handlesPlateLayout.buttonsPanel),...
                                      'String','Save Changes',...
                                      'HandleVisibility','Callback',...
                                      'Callback',@plateLayoutCancelSave_callback);                                  
set(handlesPlateLayout.buttonsPanel,'Sizes',[150 -1 155 -1 150 -1 150],'Padding',10);                                  
set(handlesPlateLayout.bigPanel,'Sizes',[-1,50]);
function plateLayoutCancelSave_callback(hObject,~)
    if hObject == handlesPlateLayout.save 
        newLayout = get(handlesPlateLayout.table,'Data');
        newGroups = unique(newLayout);
        newGroups(cellfun('isempty',newGroups)) = [];
        if ~all(all(cellfun('isempty',newLayout))) 
            handles.layout = newLayout;
            oldGroups = handles.groupNames;
            brandNewGroups = ~ismember(newGroups,oldGroups);
            if isempty(~brandNewGroups)
                handles.groupNames = newGroups;
            else
                handles.groupNames = [newGroups(~brandNewGroups);newGroups(brandNewGroups)];
            end
            handles.groupWells = cell(size(handles.groupNames));
            rows = {'A','B','C','D','E','F','G','H'};
            for i = 1:length(handles.groupNames)
                [row,column] = find(strcmp(newLayout,handles.groupNames{i}));
                row = rows(row);
                column = cellstr(num2str(column));
                handles.groupWells{i}= arrayfun(@(x) [strtrim(row{x}),strtrim(column{x})],1:length(row),'uniformoutput',0);
            end
        else
            handles.groupNames = handles.emptyLayoutGroupNames;
            handles.groupWells = handles.emptyLayoutGroupWells;
            handles.layout = handles.emptyLayout;
        end  
        if length(handles.groupNames) > size(handles.tableData,1)
            oldTableEnd = size(handles.tableData,1);
            gap = length(handles.groupNames) - oldTableEnd;
            handles.tableData(oldTableEnd+1:oldTableEnd+gap,:) = {''};
            handles.tableData(oldTableEnd+1:oldTableEnd+gap,1) = {false};
            handles.tableData(oldTableEnd+1:oldTableEnd+gap,2) = {true};
            handles.tableData(oldTableEnd+1:oldTableEnd+gap,7) = {3};
            handles.tableData(oldTableEnd+1:oldTableEnd+gap,8) = {'-'};
            if get(handles.autoColor,'userData')
                for i = 1:size(handles.groupNames,1)
                    colorIndex = rem(i,size(handles.colors,1));
                    if colorIndex~=0
                        handles.tableData(i,5) = {color2htmlStr(handles.colors(colorIndex,:))};
                    else
                        handles.tableData(i,5) = {color2htmlStr(handles.colors(end,:))};
                    end
                    markerIndex = rem(floor((i-1)/size(handles.colors,1))+1,length(handles.markers));
                    if markerIndex~=0
                        handles.tableData(i,6) = handles.markers(markerIndex);
                    else
                        handles.tableData(i,6) = handles.markers(end);
                    end
                end
            else
                for i = oldTableEnd+1:size(handles.tableData,1)
                    colorIndex = rem(i-oldTableEnd,size(handles.colors,1));
                    if colorIndex~=0
                        handles.tableData(i,5) = {color2htmlStr(handles.colors(colorIndex,:))};
                    else
                        handles.tableData(i,5) = {color2htmlStr(handles.colors(end,:))};
                    end
                    markerIndex = rem(floor((i-oldTableEnd-1)/size(handles.colors,1))+1,length(handles.markers));
                    if markerIndex~=0
                        handles.tableData(i,6) = handles.markers(markerIndex);
                    else
                        handles.tableData(i,6) = handles.markers(end);
                    end
                end
            end
            
        elseif length(handles.groupNames) < size(handles.tableData,1)
            oldTableEnd = size(handles.tableData,1);
            gap = oldTableEnd - length(handles.groupNames);
            handles.tableData(oldTableEnd-gap+1:end,:) = [];
        end
        handles.tableData(:,3) = handles.groupNames';
        handles.tableData(:,4) = handles.groupNames';
        handles.tableData(:,9:10) = {''};
        set(handles.table,'Data',handles.tableData);
        makeFinalDataAndResetYlimits;            
    end
    delete(handlesPlateLayout.plateLayoutFigure);
    set([handles.chooseSession.box,handles.chooseSession.button,handles.chooseFile.box,handles.chooseFile.button,...
         handles.plateLayout.button,handles.odOrReporter,handles.showEachWell,handles.selectAll,handles.selectNone,...
         handles.xlimitLow1,handles.xlimitLow2,handles.xlimitHigh1,handles.xlimitHigh2,handles.ylimitHigh,...
         handles.ylimitLow,handles.xlimitReset,handles.ylimitReset,handles.autoColor,handles.loadSettings,...
         handles.table,handles.createFig,handles.saveSession],'Enable','on');
    if get(handles.odOrReporter,'Value') == 1
        set(handles.devReporter,'Enable','off');
    else
        set(handles.devReporter,'Enable','on');
    end
    if get(handles.showEachWell,'Value')
        set([handles.showEachWellName,handles.hideMeanLine],'Enable','on');
        if get(handles.hideMeanLine,'Value')
            set(handles.showErrorbars,'Enable','off');
        end
    else
        set([handles.hideMeanLine,handles.showEachWellName],'Enable','off');
        set(handles.showErrorbars,'Enable','on');
    end
    if length(find(cell2mat(handles.tableData(:,1)))) == size(handles.tableData,1)
        set(handles.selectAll,'Value',1,'userData',1);
        set(handles.semiAutoDlg,'Enable','on');
    elseif isempty(find(cell2mat(handles.tableData(:,1)),1))
        set([handles.moveUp,handles.moveDown,handles.semiAutoDlg],'Enable','off');
    else
        set([handles.moveUp,handles.moveDown,handles.semiAutoDlg],'Enable','on');
    end
end 
function plateLayoutLoad_callback(hObject,~)
defaultPath = get(handles.chooseFile.box,'String');
if ~isempty(defaultPath)
    [defaultPath,~,~] = fileparts(defaultPath);
else
    defaultPath = get(handles.chooseSession.box,'String');
    [defaultPath,~,~] = fileparts(defaultPath);
end
switch hObject
    case handlesPlateLayout.load
         [fileName,folderName,ok] = uigetfile({'*.mat'},'Choose .mat file of session from which you want to copy the settings',defaultPath);
    case handlesPlateLayout.loadFromExcel
         [fileName,folderName,ok] = uigetfile({'*.xlsx';'*.xls'},'Choose .mat file of session from which you want to copy the settings',defaultPath);
end
fileName = [folderName,fileName];
if ~ok
    return;
end
switch hObject
    case handlesPlateLayout.load
         try sessionInfo = load(fileName); catch me; errordlg(me,'Could not open file');return; end
             sessionInfo = sessionInfo.sessionInfo;
             set(handlesPlateLayout.table,'Data',sessionInfo.layout);
    case handlesPlateLayout.loadFromExcel
        try [~,sheets]= xlsfinfo(fileName); catch me; errordlg(me,'Could not open file');set(handles.chooseFile.box,'String',handles.fileName);return; end
            [selection,ok] = listdlg('ListString',sheets,'SelectionMode','single','Name','Select from which sheet to copy');
            if ~ok
                return;
            end
            try [~,~,txt] = xlsread(fileName,sheets{selection}); catch me; errordlg(me,'Could not open file');set(handles.chooseFile.box,'String',handles.fileName);return; end
            if  ~isequal(txt(2:9,1)',{'A','B','C','D','E','F','G','H'}) || ...
                ~isequal(txt(1,2:13),{1,2,3,4,5,6,7,8,9,10,11,12})
                errordlg('This sheet does not contain a layout in the right format','Error','replace');
                return;
            end
            set(handlesPlateLayout.table,'Data',txt(2:9,2:13));
end
end
end
function odOrReporter_callback(hObject,~)
if hObject == handles.odOrReporter
    if get(hObject,'Value') == 1
        set(handles.devReporter,'Enable','off');
    else
        set(handles.devReporter,'Enable','on');
    end
end
makeFinalDataAndResetYlimits;
end
function showEachWell_callback(hObject,~)
if get(hObject,'Value')
    set([handles.showEachWellName,handles.hideMeanLine],'Enable','on');
    if get(handles.hideMeanLine,'Value')
        set(handles.showErrorbars,'Enable','off');
    end
else
	set([handles.hideMeanLine,handles.showEachWellName],'Enable','off');
    set(handles.showErrorbars,'Enable','on');
end
end
function hideMeanLine_callback(hObject,~)
if get(hObject,'Value')
	set(handles.showErrorbars,'Enable','off');    
else
	set(handles.showErrorbars,'Enable','on');
end
end
function changeLimits_callback(hObject,~)
    if ismember(hObject,[handles.xlimitLow1,handles.xlimitLow2,handles.xlimitHigh1,handles.xlimitHigh2,handles.ylimitLow,handles.ylimitHigh])
        newLim = str2double(get(hObject,'String'));
        if isnan(newLim)
            if ismember(hObject,[handles.xlimitLow1,handles.xlimitLow2,handles.xlimitHigh1,handles.xlimitHigh2])
                set(hObject,'String',sprintf('%02d',get(hObject,'userData')));
            else
                set(hObject,'String',num2str(get(hObject,'userData')));
            end
            return;
        end
    end
switch hObject
    case handles.xlimitLow1
        if newLim < 0 || newLim*60+get(handles.xlimitLow2,'userdata') >= get(handles.xlimitHigh1,'userdata')*60+get(handles.xlimitHigh2,'userdata')
        	set(hObject,'String',sprintf('%02d',get(hObject,'userData')));
            return;
        else 
            set(hObject,'String',sprintf('%02d',newLim),'userData',newLim);
        end
    case handles.xlimitLow2
        if newLim < 0 || newLim > 59
            set(hObject,'String',sprintf('%02d',get(hObject,'userData')));
            return;
        else 
            if newLim+get(handles.xlimitLow1,'userdata')*60 >= get(handles.xlimitHigh1,'userdata')*60+get(handles.xlimitHigh2,'userdata')
                set(hObject,'String',sprintf('%02d',get(hObject,'userData')));
                return;
            else
            	set(hObject,'String',sprintf('%02d',newLim),'userData',newLim);
            end
        end
    case handles.xlimitHigh1
        if newLim < 0 || newLim*60+get(handles.xlimitHigh2,'userdata') <= get(handles.xlimitLow1,'userdata')*60+get(handles.xlimitLow2,'userdata')
        	set(hObject,'String',sprintf('%02d',get(hObject,'userData')));
            return;
        else 
            set(hObject,'String',sprintf('%02d',newLim),'userData',newLim);
        end
    case handles.xlimitHigh2
        if newLim < 0 || newLim > 59
            set(hObject,'String',sprintf('%02d',get(hObject,'userData')));
            return;
        else
            if newLim+get(handles.xlimitHigh1,'userdata')*60 <= get(handles.xlimitLow1,'userdata')*60+get(handles.xlimitLow2,'userdata')
                set(hObject,'String',sprintf('%02d',get(hObject,'userData')));
                return;
            else
            	set(hObject,'string',sprintf('%02d',newLim),'userData',newLim);
            end
        end
    case handles.ylimitLow
        if newLim >	get(handles.ylimitHigh,'userData')
        	set(hObject,'String',num2str(get(hObject,'userData')));
            return;
        else
        	set(hObject,'String',num2str(newLim),'userData',newLim);
        end
    case handles.ylimitHigh
        if newLim <	get(handles.ylimitLow,'userData')
        	set(hObject,'String',num2str(get(hObject,'userData')));
            return;
        else
        	set(hObject,'String',num2str(newLim),'userData',newLim);
        end
    case handles.xlimitReset
        set(handles.xlimitLow1,'string',sprintf('%02d',handles.time(1,1)),'userdata',handles.time(1,1));
        set(handles.xlimitLow2,'string',sprintf('%02d',handles.time(1,2)),'userdata',handles.time(1,2));
        set(handles.xlimitHigh1,'string',sprintf('%02d',handles.time(end,1)),'userdata',handles.time(end,1));
        set(handles.xlimitHigh2,'string',sprintf('%02d',handles.time(end,2)),'userdata',handles.time(end,2));
end
if ismember(hObject,[handles.xlimitLow1,handles.xlimitLow2,handles.xlimitHigh1,handles.xlimitHigh2,handles.xlimitReset,handles.ylimitReset])
    makeFinalDataAndResetYlimits;
end
end
function autoColor_callback(hObject,~)
if get(hObject,'userData')
    set(hObject,'value',1);
    return;
else
   choise = questdlg('This will earase all previous settings, are you sure?','Warning','Yes','Cancel','Cancel');
   if isempty(choise) || strcmp(choise,'Cancel')
       set(hObject,'value',0);
       return;
   else
       set(hObject,'UserData',1);
       for i = 1:size(handles.groupNames,1)
            colorIndex = rem(i,size(handles.colors,1));
            if colorIndex~=0
                handles.tableData(i,5) = {color2htmlStr(handles.colors(colorIndex,:))};
            else
                handles.tableData(i,5) = {color2htmlStr(handles.colors(end,:))};
            end
            markerIndex = rem(floor((i-1)/size(handles.colors,1))+1,length(handles.markers));
            if markerIndex~=0
                handles.tableData(i,6) = handles.markers(markerIndex);
            else
                handles.tableData(i,6) = handles.markers(end);
            end
       end
       set(handles.table,'Data',handles.tableData);
   end
end
end
function semiAutoColor_Callback(~,~)
selectedRows = find(cell2mat(handles.tableData(:,1)));
if isempty(selectedRows)
    return;
end
color = uisetcolor; 
if ~isequal(color,0)
    hslColor = rgb2hsl(color);
    colorAdd = linspace(hslColor(3),0.95,length(selectedRows));
    for i = 1:length(selectedRows)
        specColor = hsl2rgb([hslColor(1:2),colorAdd(i)]);
        handles.tableData(selectedRows(i),5) = {color2htmlStr(specColor)};
    end
    set(handles.table,'Data',handles.tableData);
    set(handles.autoColor,'value',0,'userdata',0);
end
end
function loadSettings_callback(~,~)
defaultPath = get(handles.chooseFile.box,'String');
if ~isempty(defaultPath)
    [defaultPath,~,~] = fileparts(defaultPath);
else
    defaultPath = get(handles.chooseSession.box,'String');
    [defaultPath,~,~] = fileparts(defaultPath);
end
[fileName,folderName,ok] = uigetfile({'*.mat'},'Choose .mat file of session from which you want to copy the settings',defaultPath);
fileName = [folderName,fileName];
if ~ok
    return;
end
try sessionInfo = load(fileName); catch me; errordlg(me,'Could not open file');return; end
sessionInfo = sessionInfo.sessionInfo;
sizeOfInputTable = size(sessionInfo.tableData,1);
if sizeOfInputTable == size(handles.tableData,1)
    handles.tableData(:,5) = sessionInfo.tableData(:,5);
    handles.tableData(:,6) = sessionInfo.tableData(:,6);
    handles.tableData(:,7) = sessionInfo.tableData(:,7);
    handles.tableData(:,8) = sessionInfo.tableData(:,8);
elseif sizeOfInputTable < size(handles.tableData,1)
    handles.tableData(1:sizeOfInputTable,5) = sessionInfo.tableData(:,5);
    handles.tableData(1:sizeOfInputTable,6) = sessionInfo.tableData(:,6);
    handles.tableData(1:sizeOfInputTable,7) = sessionInfo.tableData(:,7);
    handles.tableData(1:sizeOfInputTable,8) = sessionInfo.tableData(:,8);
elseif sizeOfInputTable > size(handles.tableData,1)
    handles.tableData(:,5) = sessionInfo.tableData(1:length(handles.groupNames),5);
    handles.tableData(:,6) = sessionInfo.tableData(1:length(handles.groupNames),6);
    handles.tableData(:,7) = sessionInfo.tableData(1:length(handles.groupNames),7);
    handles.tableData(:,8) = sessionInfo.tableData(1:length(handles.groupNames),8);
end
set(handles.table,'Data',handles.tableData);
set(handles.autoColor,'value',0,'userdata',0);
end
function tableSelectAllOrNone_callback(hObject,~)
    switch hObject
        case handles.selectAll
            if get(hObject,'userData')
                set(hObject,'value',1);
                return;
            else
                set(hObject,'UserData',1);
                set([handles.moveUp,handles.moveDown,handles.semiAutoDlg],'Enable','on');
                handles.tableData(:,1) = {true};
            end
        case handles.selectNone
        	handles.tableData(:,1) = {false};
            set(handles.selectAll,'Value',0','userData',0);
            set([handles.moveUp,handles.moveDown,handles.semiAutoDlg],'Enable','off');
    end
    set(handles.table,'data',handles.tableData);
end
function tableCellEdit_callback(hObject,eventdata)
%1-'Select',2-'Include',3-'Group name',4-'Label',5-'Color',6-'Marker',7-'Marker Size',8-'Line style',9-'OD sub. blank',10 - 'reporter sub. blank'}
if ~isempty(eventdata.Indices)
    row = eventdata.Indices(1,1);
    column = eventdata.Indices(1,2);
    selectedRows =  find(cell2mat(handles.tableData(:,1)));
    switch column 
        case 1
            handles.tableData(row,column) = {eventdata.NewData};
            if length(find(cell2mat(handles.tableData(:,1)))) == size(handles.tableData,1)
                set(handles.selectAll,'Value',1,'userData',1);
                set(handles.semiAutoDlg,'Enable','on');
            elseif isempty(find(cell2mat(handles.tableData(:,1)),1))
                set([handles.moveUp,handles.moveDown,handles.semiAutoDlg],'Enable','off');
            else
                set([handles.moveUp,handles.moveDown,handles.semiAutoDlg],'Enable','on');
            end
            return;
        case 4
            if isempty(eventdata.NewData)
                set(hObject,'data',handles.tableData);
                return;
            end
        case 6
            if ~ismember(eventdata.NewData,{'+','o','*','.','x','s','square','diamond','d','^','v','<','>','pentagram','p','hexagram','h','none'})
               set(hObject,'data',handles.tableData);
               return;
            end
            set(handles.autoColor,'value',0,'userdata',0);
        case 7
            if isnan(eventdata.NewData)
                set(hObject,'data',handles.tableData);
                return;
            end
        case 8
            if ~ismember(eventdata.NewData,{'-','--',':','-.','none'})
               set(hObject,'data',handles.tableData);
               return;
            end
        case {9,10}
            if ~isempty(eventdata.NewData) && ~ismember(eventdata.NewData,handles.groupNames) && isnan(str2double(eventdata.NewData))
                set(hObject,'data',handles.tableData);
                return;
            end
    end
    if ~isempty(selectedRows) && ismember(row,selectedRows)
        handles.tableData(selectedRows,column) = {eventdata.NewData};
    else
        handles.tableData(row,column) = {eventdata.NewData};
    end
    if column == 2 || column == 9 || column == 10
        makeFinalDataAndResetYlimits;
    end
    set(hObject,'data',handles.tableData);
end
end
function tableChangeColor_callback(hObject,eventdata)
%'Select','Include','Group name','Label','Color','Marker','Line style','Remove blank','Blank group'}
if ~isempty(eventdata.Indices)
    row = eventdata.Indices(1,1);
    column = eventdata.Indices(1,2);
    if column == 5
        color = uisetcolor;
        if ~isequal(color,0)
            color = color2htmlStr(color);
            selectedRows =  find(cell2mat(handles.tableData(:,1)));
            if ~isempty(selectedRows) && ismember(row,selectedRows)
                handles.tableData(selectedRows,column) = {color};
            else
                handles.tableData(row,column) = {color};                 
            end
            set(handles.autoColor,'value',0,'userdata',0);
            set(hObject,'Data',handles.tableData);   
        end
    end
end
end
function tableMoveUpDown_callback(hObject,~)
selectedRows =  find(cell2mat(handles.tableData(:,1)))';
notSelectedRows = find(~ismember(1:size(handles.tableData,1),selectedRows));
switch hObject
    case handles.moveUp
        if selectedRows(1) == 1
            handles.tableData = handles.tableData([selectedRows,notSelectedRows],:);
        else
            handles.tableData = handles.tableData([notSelectedRows(notSelectedRows<selectedRows(1)-1),selectedRows,notSelectedRows(notSelectedRows>=selectedRows(1)-1)],:);
        end
    case handles.moveDown
        if selectedRows(end) == size(handles.tableData,1)
            handles.tableData = handles.tableData([notSelectedRows,selectedRows],:);
        else
            handles.tableData = handles.tableData([notSelectedRows(notSelectedRows<=selectedRows(end)+1),selectedRows,notSelectedRows(notSelectedRows>selectedRows(end)+1)],:);
        end
end
set(handles.table,'Data',handles.tableData); 
set(handles.autoColor,'Value',0,'UserData',0);
end
function saveSession_callback(~,~)
defaultPath = get(handles.chooseFile.box,'String');
if ~isempty(defaultPath)
    [defaultPath,~,~] = fileparts(defaultPath);
else
    defaultPath = get(handles.chooseSession.box,'String');
    [defaultPath,~,~] = fileparts(defaultPath);
end
defaultName = [defaultPath,'\',get(handles.figureName,'String')];
[fileName,pathName,~] = uiputfile('.mat','Choose destination',defaultName);
if ~isempty(fileName) && ~isequal(fileName,0)
    sessionInfo.odOrReporter = get(handles.odOrReporter,'Value');
    sessionInfo.devReporter = get(handles.devReporter,'Value');
    sessionInfo.showEachWell = get(handles.showEachWell,'Value');
    sessionInfo.showEachWellName = get(handles.showEachWellName,'Value');
    sessionInfo.hideMeanLine = get(handles.hideMeanLine,'Value');
    sessionInfo.showErrorbars = get(handles.showErrorbars,'Value');
    sessionInfo.xlimitLow1 = get(handles.xlimitLow1,'String');
    sessionInfo.xlimitLow2 = get(handles.xlimitLow2,'String');
    sessionInfo.xlimitHigh1 = get(handles.xlimitHigh1,'String');
    sessionInfo.xlimitHigh2 = get(handles.xlimitHigh2,'String');
    sessionInfo.ylimitLow = get(handles.ylimitLow,'String');
    sessionInfo.ylimitHigh = get(handles.ylimitHigh,'String');
    sessionInfo.autoColor = get(handles.autoColor,'Value');
    sessionInfo.od = handles.od;
    sessionInfo.headers = handles.headers;
    sessionInfo.reporter = handles.reporter;
    sessionInfo.finalData = handles.finalData;
    sessionInfo.time = handles.time;
    sessionInfo.groupNames = handles.groupNames;
    sessionInfo.groupWells = handles.groupWells;
    sessionInfo.layout = handles.layout;    
    sessionInfo.tableData = handles.tableData;
    save([pathName,fileName],'sessionInfo');
    msgbox('Session saved!','Done','help'); 
end
end
function createFig_callback(~,~)
figure,
includedRows =  find(cell2mat(handles.tableData(:,2)));
for i = 1:length(includedRows)
    groupNo = strcmp(handles.tableData{includedRows(i),3},handles.groupNames);
    color = cell2mat(htmlstr2rgb(handles.tableData{includedRows(i),5}));
    marker = handles.tableData{includedRows(i),6};
    markerSize = handles.tableData{includedRows(i),7};
    lineStyle = handles.tableData{includedRows(i),8};
    if  get(handles.showEachWell,'Value')
            hslColor = rgb2hsl(color);
            hslColor(3) = 0.85;
            brightColor = hsl2rgb(hslColor);
        for j = 1:length(handles.groupWells{groupNo})
            wellReads = handles.finalData(:,ismember(handles.headers,handles.groupWells{groupNo}{j}));
            h = plot(handles.finalData(:,1),wellReads,'Color',brightColor,'LineStyle',lineStyle);
            if ~(j == 1 && get(handles.hideMeanLine,'value'))
                hasbehavior(h,'legend',false);
            end
            hold on;
            if get(handles.showEachWellName,'Value')
                text(handles.finalData(end,1),wellReads(end),handles.groupWells{groupNo}{j},'fontsize',10,'Color',brightColor);
            end
        end
    end
    if (get(handles.showEachWell,'Value') && ~get(handles.hideMeanLine,'value')) || ~get(handles.showEachWell,'Value') 
        groupReads = handles.finalData(:,ismember(handles.headers,handles.groupWells{groupNo}));
        meanReads = mean(groupReads,2);
        plot(handles.finalData(:,1),meanReads,'Color',color,'LineWidth',3,'LineStyle',lineStyle,'Marker',marker,'MarkerSize',markerSize);
        hold on;
    end
    if ~(get(handles.showEachWell,'Value') && get(handles.hideMeanLine,'value')) && get(handles.showErrorbars,'Value')
        h = errorbar(handles.finalData(:,1),meanReads,std(groupReads,[],2),'Color',color,'LineWidth',1);
        hasbehavior(h,'legend',false);
    end
end
xLimLow = (get(handles.xlimitLow1,'UserData')*60+get(handles.xlimitLow2,'UserData'))*(0.0416666666666667/60);
xLimHigh = (get(handles.xlimitHigh1,'UserData')*60+get(handles.xlimitHigh2,'UserData'))*(0.0416666666666667/60);
yLimLow = get(handles.ylimitLow,'UserData');
yLimHigh = get(handles.ylimitHigh,'UserData');
set(gca,'Xlim',[xLimLow,xLimHigh],'Ylim',[yLimLow,yLimHigh]);
if rem((get(handles.xlimitLow1,'UserData')*60+get(handles.xlimitLow2,'UserData')),60) ~= 0
    minTick = ceil((get(handles.xlimitLow1,'UserData')*60+get(handles.xlimitLow2,'UserData'))/60);
    minTick = minTick*0.0416666666666667;
else
    minTick = xLimLow;
end
if rem((get(handles.xlimitHigh1,'UserData')*60+get(handles.xlimitHigh2,'UserData')),60) ~= 0
    maxTick = floor((get(handles.xlimitHigh1,'UserData')*60+get(handles.xlimitHigh2,'UserData'))/60);
    maxTick = maxTick*0.0416666666666667;
else
    maxTick = xLimHigh;
end    
set(gca,'Xtick',minTick:0.0416666666666667:maxTick,'XtickLabel',(minTick:0.0416666666666667:maxTick)./(0.0416666666666667),'TickDir','out');

legend(handles.tableData(includedRows,4));
set(gca,'FontName','Calibri');
xlabel('Time (hours)','FontWeight','bold');
end
function makeFinalDataAndResetYlimits
finalDataOD = handles.od;
finalDataReporter = handles.reporter;
for i = 1:size(handles.tableData,1)
    odBlank = handles.tableData{i,9};
    reporterBlank = handles.tableData{i,10};
    if ~isempty(odBlank)
        groupWellCols = find(ismember(handles.headers,handles.groupWells{strcmp(handles.tableData{i,3},handles.groupNames)}));
        if isnan(str2double(odBlank))
            blankWellCols = ismember(handles.headers,handles.groupWells{strcmp(odBlank,handles.groupNames)});
            meanBlankWellOD = mean(handles.od(:,blankWellCols),2);
        else
        	meanBlankWellOD = str2double(odBlank);
        end
        for j = 1:length(groupWellCols)
        	finalDataOD(:,groupWellCols(j)) = handles.od(:,groupWellCols(j))-meanBlankWellOD;
        end
    end
    if ~isempty(reporterBlank)
        groupWellCols = find(ismember(handles.headers,handles.groupWells{strcmp(handles.tableData{i,3},handles.groupNames)}));
        if isnan(str2double(reporterBlank))
            blankWellCols = ismember(handles.headers,handles.groupWells{strcmp(reporterBlank,handles.groupNames)});
            meanBlankWellReporter = mean(handles.reporter(:,blankWellCols),2);
        else
            meanBlankWellReporter = str2double(reporterBlank);
        end
        for j = 1:length(groupWellCols)
            finalDataReporter(:,groupWellCols(j)) = handles.reporter(:,groupWellCols(j))-meanBlankWellReporter;
        end
    end
end    
if get(handles.odOrReporter,'Value') == 1
    finalData = finalDataOD;
else
    if get(handles.devReporter,'Value')
        finalData = finalDataReporter;
        finalData(:,3:end) = finalDataReporter(:,3:end)./finalDataOD(:,3:end);
    else
        finalData = finalDataReporter;
    end
end
minuteTime = handles.time(:,1)*60+handles.time(:,2);
finalData(:,1) = minuteTime.*(0.0416666666666667/60);
firstX = find(minuteTime >= get(handles.xlimitLow1,'userData')*60+get(handles.xlimitLow2,'userData'),1);
lastX = find(minuteTime <= get(handles.xlimitHigh1,'userData')*60+get(handles.xlimitHigh2,'userData') ,1,'last'); 
finalData = finalData(firstX:lastX,:);

notIncludedRows = find(~cell2mat(handles.tableData(:,2)));
for i = 1:length(notIncludedRows)
    groupNo = strcmp(handles.tableData{notIncludedRows(i),3},handles.groupNames);
    finalData(:,ismember(handles.headers,handles.groupWells{groupNo})) = NaN;
end
handles.finalData = finalData;
ymin = min(min(handles.finalData(:,3:end)));
ymax = max(max(handles.finalData(:,3:end)));
set(handles.ylimitLow,'string',num2str(ymin-(ymax-ymin)*0.05),'userdata',ymin-(ymax-ymin)*0.05);
set(handles.ylimitHigh,'string',num2str(ymax+(ymax-ymin)*0.05),'userdata',ymax+(ymax-ymin)*0.05);
end
end
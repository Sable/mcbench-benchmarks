function varargout = StrainMeasurement(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StrainMeasurement_OpeningFcn, ...
                   'gui_OutputFcn',  @StrainMeasurement_OutputFcn, ...
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


function StrainMeasurement_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
guidata(hObject, handles);

global Status Parameters Files

%ENTER DEFAULT DIRECTORY:
Files.DefaultDir = 'C:\';

Files.OldDir = cd;


Status.Loop = 2;
while Status.Loop ~= 0
    if Status.Loop == 2
        Files.AFile = 0;
        Files.APath = 0;
        Files.ZFile = 0;
        Files.ZPath = 0;
        Status.InPar(1:5)=[0 0 0 0 0]; 
        Status.Analysis = 0;
        cla(handles.Axes_Image)
        cla(handles.Axes_Intensity)
        xlabel(handles.Axes_Intensity, 'pixel  [-]', 'Color', 'w')
        ylabel(handles.Axes_Intensity, 'intensity  [-]', 'Color', 'w')
        set(handles.Button_FileChange, 'Enable', 'off')
        set(handles.Button_TBSet, 'Enable', 'off')
        set(handles.Button_LRSet, 'Enable', 'off')
        set(handles.Button_Initialize, 'Enable', 'off')
        set(handles.Text_FileA, 'String', '- no data selected -', 'ForegroundColor', [1 0 0])
        set(handles.Text_FileZ, 'String', '- no data selected -', 'ForegroundColor', [1 0 0])
        set(handles.Text_TBound, 'String', '---', 'ForegroundColor', [1 0 0])
        set(handles.Text_BBound, 'String', '---', 'ForegroundColor', [1 0 0])
        set(handles.Text_LBound, 'String', '---', 'ForegroundColor', [1 0 0])
        set(handles.Text_RBound, 'String', '---', 'ForegroundColor', [1 0 0])
        set(handles.Text_CurrentFile, 'String', '- - -', 'ForegroundColor', [1 1 0])
        Files.CurrentDir = Files.DefaultDir;
        cd (Files.CurrentDir);

    end
    if (Status.InPar - 1) == zeros
        set(handles.Button_Start, 'Enable', 'on')
    else
        set(handles.Button_Start, 'Enable', 'off')
    end
    if Status.InPar(5) == 0
        set(handles.Text_Status, 'String', '-  N O T   I N I T I A L I Z E D  -', 'ForegroundColor', [1 0 0])
    else
        set(handles.Text_Status, 'String', '-  R E A D Y  -', 'ForegroundColor', [0 1 0])
    end        
    Status.Loop = 0;
    figure(handles.Main)
    uiwait(handles.Main)
end


close all
cd (Files.OldDir);



function varargout = StrainMeasurement_OutputFcn(hObject, eventdata, handles) 
%varargout{1} = handles.output;



function Button_FileALoad_Callback(hObject, eventdata, handles)
    global Status Parameters Files
    Status.Loop = 1;
    [Files.AFile, Files.APath] = uigetfile({'*.bmp;*.tif;*.jpg;*.TIF;*.BMP;*.JPG','image files (*.bmp,*.tif,*.jpg)';'*.*',  'all files (*.*)'}, 'SELECT FIRST IMAGE', Files.CurrentDir);
    if Files.APath ~= 0
        set(handles.Text_FileA, 'String', Files.AFile, 'ForegroundColor', [0 1 0])
        Files.CurrentDir = Files.APath;
        Status.InPar(1) = 1;
        [Files.ZFile, Files.ZPath] = uigetfile({'*.bmp;*.tif;*.jpg;*.TIF;*.BMP;*.JPG','image files (*.bmp,*.tif,*.jpg)';'*.*',  'all files (*.*)'}, 'SELECT LAST FILE', Files.CurrentDir);
        if Files.ZPath ~= 0
            set(handles.Text_FileZ, 'String', Files.ZFile, 'ForegroundColor', [0 1 0])
            Files.CurrentDir = Files.ZPath;
            Status.InPar(2) = 1;
        end
    end
    if Status.InPar(1:2)-1 == 0
        CreateFilelist(handles)
    end
    uiresume


function Button_FileChange_Callback(hObject, eventdata, handles)
    global Status Parameters Files
    Status.Loop = 1;
    set(handles.Panel_ChangeFile, 'Visible', 'on')
    set(handles.Listbox_File, 'String', Files.Filelist)


function Button_TBSet_Callback(hObject, eventdata, handles)
    global Status Parameters Files
    Status.Loop = 1;
    set(handles.Text_Status, 'String', sprintf('Click TOP and BOTTOM of the integration range \nin the UPPER IMAGE.'), 'ForegroundColor', [1 1 0])
    axes(handles.Axes_Image)
    Input = ginput(2);
    Input = sort(Input, 1, 'ascend');
    Parameters.TB = round(Input(1, 2));
    Parameters.BB = round(Input(2, 2));
    Status.InPar(3) = 1;
    DisplayImage(handles, Files.ActualFile)
    uiresume



function Button_LRSet_Callback(hObject, eventdata, handles)
    global Status Parameters Files
    Status.Loop = 1;
    set(handles.Text_Status, 'String', sprintf('Click LEFT BORDER and RIGHT BORDER \nof the integration range.'), 'ForegroundColor', [1 1 0])
    axes(handles.Axes_Intensity)
    Input = ginput(2);
    Input = sort(Input,1, 'ascend');
    Parameters.LB = round(Input(1, 1));
    Parameters.RB = round(Input(2, 1));
    Status.InPar(4) = 1;
    DisplayImage(handles, Files.ActualFile)
    uiresume

    
function Checkbox_IIP_Callback(hObject, eventdata, handles)


function Button_Start_Callback(hObject, eventdata, handles)
    global Status Parameters Files
    set(handles.Button_FileALoad, 'Enable', 'off')
    set(handles.Button_FileChange, 'Enable', 'off')
    set(handles.Button_TBSet, 'Enable', 'off')
    set(handles.Button_LRSet, 'Enable', 'off')
    set(handles.Button_Start, 'Enable', 'off')
    set(handles.Button_Initialize, 'Enable', 'off')
    Status.Loop = 1;
    FileCount = 0;
    AnalysisLoop = 1;
    Status.Analysis = 1;
    Parameters.VAR = get(handles.Checkbox_VAR, 'Value');
    Parameters.ICB = get(handles.Checkbox_ICB, 'Value');
    xtest = [1 : Parameters.ImageSize(1)];

    while AnalysisLoop == 1
        FileCount = FileCount + 1;
        DisplayImage(handles, Files.Filelist(FileCount, :))
        xdata = Parameters.IntegratedIntensity(:,1);
        ydata = Parameters.IntegratedIntensity(:,2);
        axes(handles.Axes_Intensity)
        hold on
        % data fit with two error functions, fixed at y(x0) = y(x1) = 0
        if FileCount == 1
            FitGuess = [max(ydata)/2, 0.1, Parameters.InitialGuess(1), 0.1, Parameters.InitialGuess(2)];
        end
        if Parameters.ICB == 1
            %data correction
            MaxLeft = 2/FitGuess(2)+FitGuess(3);
            MaxRight = FitGuess(5) - 2/FitGuess(4);
            Range = [0,0];
            i = 0;
            while Range(1) == 0
                i = i + 1;
                if xdata(i) >= MaxLeft
                	Range(1) = i;
                end
            end
            while Range(2) == 0
            	i = i + 1;
                if xdata(i) >= MaxRight
                	Range(2) = i-1;
                end
            end
            ydata(Range(1):Range(2)) = Parameters.UpperValue;
            FitGuess(1) = Parameters.UpperValue/2;
            plot(xdata(Range(1):Range(2)), ydata(Range(1):Range(2)), 'g-')
        end
        Exitflag = 0;
        LineHandle = 0;
        j = 0;
        while Exitflag == 0
            j = j + 1;
            [FitData, Resnom, Residual, Exitflag] = lsqcurvefit(@(FitData, xdata)  FitData(1)*(erf(FitData(2)*(xdata-FitData(3)))-erf(FitData(4)*(xdata-FitData(5)))), FitGuess, xdata, ydata);
            ytest = FitData(1)*(erf(FitData(2)*(xtest-FitData(3)))-erf(FitData(4)*(xtest-FitData(5))));
            if LineHandle ~= 0
                delete(LineHandle)
            end
            LineHandle = plot (xtest, ytest, 'y-');
            FitGuess = FitData;
            if j == 10
                Exitflag = 1;
            end
        end
        clear xdata ydata ytest
        if FileCount == 1
            RelAnalysisRange = [Parameters.LB - FitData(3), Parameters.RB - FitData(5)];
        end
        if Parameters.VAR == 1
            Parameters.LB = round(FitData(3) + RelAnalysisRange(1));
            Parameters.RB = round(FitData(5) + RelAnalysisRange(2));
            if Parameters.LB < 1
                Parameters.LB = 1;
            end
            if Parameters.RB > Parameters.ImageSize(1)
                Parameters.RB = Parameters.ImageSize(1);
            end
        end
        MarkerPosition(FileCount, 1:2) = [FitData(3), FitData(5)];
        if FileCount == (size(Files.Filelist, 1))
            AnalysisLoop = 0;
        end
        Completed = round(FileCount/size(Files.Filelist, 1) * 100);
        set(handles.Text_Status, 'String', ['A N A L Y S I S   R U N N I N G   -   ', num2str(Completed), '%   C O M P L E T E D'], 'ForegroundColor', [1 0 0])

    end
    Status.Analysis = 0;
    ImgNo(:,1) = [1:FileCount];
    MarkerDistance(:,1) = MarkerPosition(:,2) - MarkerPosition(:,1);
    Strain(:,1) = MarkerDistance(:,1)/MarkerDistance(1,1)-1;
    OutData(:, 1) = ImgNo(:,1);
    OutData(:, 2) = MarkerPosition(:,1);
    OutData(:, 3) = MarkerPosition(:,2);
    OutData(:, 4) = MarkerDistance(:,1);
    OutData(:, 5) = Strain(:,1);
    save([Files.Path, 'StrainMeasurement.dat'], 'OutData', '-ascii', '-tabs')
    save([Files.Path, 'StrainX.dat'], 'Strain', '-ascii', '-tabs')
    PlotHandle = figure;
    plot(ImgNo(:,1), Strain(:,1), 'bo')
    ylabel('strain  [-]')
    xlabel('image no.  [-]')
    set(gca, 'Box', 'on')
    saveas(PlotHandle, [Files.Path, '\StrainX.fig'])
    figure(handles.Main)
    set(handles.Button_FileALoad, 'Enable', 'on')
    set(handles.Button_FileChange, 'Enable', 'on')
    set(handles.Button_TBSet, 'Enable', 'on')
    set(handles.Button_LRSet, 'Enable', 'on')
    set(handles.Button_Start, 'Enable', 'on')
    set(handles.Button_Initialize, 'Enable', 'on')
    set(handles.Text_Status, 'String', '-  A N A L Y S I S   C O M P L E T E D  -', 'ForegroundColor', [0 1 0])
    clear xtest MarkerPosition ImgNo MarkerDistance Strain OutData
    DisplayImage(handles, Files.Filelist(1,:))
    
    uiresume


function Button_Initialize_Callback(hObject, eventdata, handles)
    global Status Parameters Files
    Status.Loop = 1;
    set(handles.Text_Status, 'String', sprintf('Click CENTER of the LEFT SLOPE \nand CENTER of the RIGHT SLOPE \nin the LOWER GRAPH.'), 'ForegroundColor', [1 1 0])
    axes(handles.Axes_Intensity)
    Input = ginput(2);
    Input = sort(Input,1, 'ascend');
    Parameters.InitialGuess(1:2) = Input(1:2, 1);
    Status.InPar(5) = 1;
    uiresume



function CreateFilelist(handles)
    global Status Parameters Files
    String = get(handles.Text_Status, 'String');
    set(handles.Text_Status, 'String', 'WAIT.....')
    Files.Filelist = [];
    FileLength(1) = size(Files.AFile,2);
    FileLength(2) = size(Files.ZFile,2);
    FileType(1,:) = Files.AFile((FileLength(1)-3):FileLength(1));
    FileType(2,:) = Files.ZFile((FileLength(2)-3):FileLength(2));
    FileStart = str2num(Files.AFile((FileLength(1)-6):(FileLength(1)-4)));
    FileEnd = str2num(Files.ZFile((FileLength(2)-6):(FileLength(2)-4)));
    FileLabel(1,:) = Files.AFile(1:(FileLength(1)-7));
    FileLabel(2,:) = Files.ZFile(1:(FileLength(2)-7));

    if FileType(1,:) ~= FileType(2,:)
        fprintf('CRITICAL FILENAME ERROR - SCRIPT TERMINATED \n');
        uiresume
    end
    if FileLabel(1,:) ~= FileLabel(2,:)
        fprintf('CRITICAL FILENAME ERROR - SCRIPT TERMINATED \n');
        uiresume
    end
    if Files.APath ~= Files.ZPath
        fprintf('CRITICAL FILENAME ERROR - SCRIPT TERMINATED \n');
        uiresume
    end

    j = 0;
    for i = FileStart:FileEnd
        j = j + 1;
        FileNo = num2str(i + 1000);    
        Filename(j,:) = [FileLabel(1,:), FileNo(:,2:4), FileType(1,:)];
    end
    Files.Filelist = Filename;
    Parameters.FileType = FileType(1,:);
    Parameters.FileLabel = FileLabel(1,:);
    Files.Path = Files.APath;
    clear Filename FileLength FileType FileLabel

    Files.ActualFile = Files.Filelist(1,:);
    DisplayImage(handles, Files.ActualFile)
    
    set(handles.Button_FileChange, 'Enable', 'on')
    set(handles.Button_TBSet, 'Enable', 'on')
    set(handles.Button_LRSet, 'Enable', 'on')
    Status.InPar(3:5) = [0 0 0];
    
    set(handles.Button_Initialize, 'Enable', 'on')
    
function DisplayImage(handles, Filename)
    global Status Parameters Files

    set(handles.Text_CurrentFile, 'String', Filename)
    TempData = imread([Files.Path, Filename]);
    ImageData = mean(double(TempData), 3);
    Parameters.ImageSize = [size(ImageData, 2) size(ImageData, 1)];
    clear TempData
    
    axes(handles.Axes_Image)
    cla(handles.Axes_Image)
    axis ij
    hold on
    imagesc(ImageData);
    if Status.InPar(3) == 0
        Parameters.TB = 1;
        Parameters.BB = size(ImageData, 1);
    else
        plot([1 Parameters.ImageSize(1)], [Parameters.TB Parameters.TB], 'w-')        
        plot([1 Parameters.ImageSize(1)], [Parameters.BB Parameters.BB], 'w-')
    end
    if Status.InPar(4) == 0
        Parameters.LB = 1;
        Parameters.RB = size(ImageData, 2);
    else
        plot([Parameters.LB Parameters.LB], [1 Parameters.ImageSize(2)], 'w-')        
        plot([Parameters.RB Parameters.RB], [1 Parameters.ImageSize(2)], 'w-')        
    end
    set(handles.Axes_Image, 'Box', 'on', 'XColor', 'w', 'YColor', 'w', 'XTickLabelMode', 'manual', 'XTickLabel', [], 'XTickMode', 'manual', 'XTick', [],'YTickLabelMode', 'manual', 'YTickLabel', [], 'YTickMode', 'manual', 'YTick', [], 'XLim', [1 Parameters.ImageSize(1)], 'YLim', [1 Parameters.ImageSize(2)])
    set(handles.Text_TBound, 'String', Parameters.TB, 'ForegroundColor', [0 1 0])
    set(handles.Text_BBound, 'String', Parameters.BB, 'ForegroundColor', [0 1 0])
    set(handles.Text_LBound, 'String', Parameters.LB, 'ForegroundColor', [0 1 0])
    set(handles.Text_RBound, 'String', Parameters.RB, 'ForegroundColor', [0 1 0])
    Status.InPar(3:4) = [1 1];
    Status.InPar(5) = 0;
    
    IntegratedIntensity = [];
    Parameters.IntegratedIntensity = [];
    Parameters.UpperValue = 0;
    IntegratedIntensity(1:(Parameters.RB-Parameters.LB+1), 1:2) = zeros;
    IntegratedIntensity(1:(Parameters.RB-Parameters.LB+1), 1) = [Parameters.LB:Parameters.RB];
    for i = Parameters.TB:Parameters.BB
        TempData(:,1) = ImageData(i, Parameters.LB:Parameters.RB);
        IntegratedIntensity(:,2) = IntegratedIntensity(:,2) + TempData;
        if Status.Analysis == 1 & Parameters.ICB == 1
        	TempData = sort(TempData, 'descend');
            Parameters.UpperValue = Parameters.UpperValue + mean(TempData(1:round(0.1*size(TempData, 1)), 1));
        end
    end
    axes(handles.Axes_Intensity)
    hold off
    plot(IntegratedIntensity(:,1), IntegratedIntensity(:,2), 'g.')
    set(handles.Axes_Intensity, 'Color', [0 0 0], 'Box', 'on', 'XColor', 'w', 'YColor', 'w', 'XLim', [1, Parameters.ImageSize(1)])
    xlabel(handles.Axes_Intensity, 'pixel  [-]', 'Color', 'w')
    ylabel(handles.Axes_Intensity, 'intensity  [-]', 'Color', 'w')

    Parameters.IntegratedIntensity = IntegratedIntensity;
    clear IntegratedIntensity TempData UpperValueTemp
    
    


function Listbox_File_Callback(hObject, eventdata, handles)
    global Status Parameters Files
    FileNo = get(handles.Listbox_File, 'Value');
    Files.ActualFile = Files.Filelist(FileNo, :);
    set(handles.Panel_ChangeFile, 'Visible', 'off')
    DisplayImage(handles, Files.ActualFile)
    
    uiresume



function Button_Reset_Callback(hObject, eventdata, handles)
    global Status Parameters Files
    Status.Loop = 2;
    Files.Filelist = [];
    
    uiresume
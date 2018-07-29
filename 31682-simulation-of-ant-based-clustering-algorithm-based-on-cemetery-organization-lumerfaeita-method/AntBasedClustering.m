function varargout = AntBasedClustering(varargin)

% Simulation of Ant-Based Clustering Algorithm based on cemetery organization
% Lumer&Faeita Algorithm
% Last update : June 05, 2011
% (C) Heidar Rastiveis
% Department of Geomatics Eng.
% School of Engineering
% University of Tehran
% e-mail: h.rasti@gmail.com

%{
Firstly, generate a sample data and after setting the parameters press the "RUN" botton.
Note:
    1. After each stop, press any key to continue. It's better to not press the space button.
    2. This is just a simulation code. However, it is easy to change the code for your application.
    3. I would be thankful if you let me know about your comments and ideas
%}

%% Last Change June 05, 2011

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @AntBasedClustering_OpeningFcn, ...
    'gui_OutputFcn',  @AntBasedClustering_OutputFcn, ...
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


% --- Executes just before AntBasedClustering is made visible.
function AntBasedClustering_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AntBasedClustering (see VARARGIN)

% Choose default command line output for AntBasedClustering
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AntBasedClustering wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AntBasedClustering_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in generateBtn.
function generateBtn_Callback(hObject, eventdata, handles)
numPatterns = eval(get(handles.patternsNumberTxt,'String'));
strCluster = get(handles.clustersNumberPopup,'String');
numClusters = eval(strCluster{get(handles.clustersNumberPopup,'Value')});
numFeatures = eval(get(handles.featuresNumberTxt,'String'));
warning('Off')

n = round(numPatterns/numClusters);
numPatterns = n * numClusters;
% numFeatures = 3;
patternsMarker(1:n) = 'o'; patternsColor(1:n) = 'r';
patternsMarker(n+1:2*n) = '*'; patternsColor(n+1:2*n) = 'b';
patternsMarker(2*n+1:3*n) = 's'; patternsColor(2*n+1:3*n) = 'm';
patternsMarker(3*n+1:4*n) = 'h'; patternsColor(3*n+1:4*n) = 'g';
patternsMarker(4*n+1:5*n) = '+'; patternsColor(4*n+1:5*n) = 'c';

patterns = [];
for i = 1:numClusters
    patterns1 = randsrc(n,numFeatures,[(2*i-1)*10:(2*i)*10+10]);
    patterns = [patterns; patterns1]; %#ok<AGROW>
end


% patterns2 = randsrc(n,3,[50:60]); patterns2(:,4) = 2;
% patterns3 = randsrc(n,3,[30:40]); patterns3(:,4) = 3;
% patterns = [patterns1;patterns2;patterns3];

distanceMatrix = ones(numPatterns) - eye(numPatterns);

%% Calc DistanceMatrix
for k = 1:(numPatterns-1)
    pattern = patterns(k, :);
    for l= (k+1):numPatterns
        patternpririm = patterns(l, :);
        dist = norm(pattern-patternpririm);
        distanceMatrix(l, k) = dist;
        distanceMatrix(k, l) = dist;
    end;
end;

% Find Dmaximum
maxDistance = max(distanceMatrix(:));
distanceMatrix = ((distanceMatrix)-(min(distanceMatrix(:))))/((max(distanceMatrix(:)))-(min(distanceMatrix(:))));
%% Create Lattice
numberOfPatterns = size(patterns,1);
latticeSize = round( 3*sqrt(numberOfPatterns)+1);

latticeSample.pattern = [];
% latticeSample.patternsList.featureVector = [];
lattice(1:latticeSize,1:latticeSize) = latticeSample;

%% Scatter Data on the Lattice
B = zeros(size(lattice,1));
for  i = 1:numPatterns
    condition = true;
    while condition
        position = randsrc(1,2,2:size(lattice,1)-1);
        x = position(1);
        y = position(2);
        if ~B(x,y)
            lattice(x,y).pattern = i;
            %             lattice(x,y).patternsList.featureVector = patterns(i,:);
            condition = false;
            B(x,y) = 1;
        end
    end
end


%%%%%%% Plot Patterns on Lattice
if get(handles.plotSampleChk,'Value')
         set(handles.axes1,'XTickLabel',' ')
         set(handles.axes1,'YTickLabel',' ')
         axes(handles.axes1)
         cla
         axis on
         set(gca,'XTick',(-.5:1:size(lattice,1)+1.5)')
         set(gca,'YTick',(-.5:1:size(lattice,1)+1.5)')
         grid on
         axis([0 size(lattice,1)+.5 0 size(lattice,1)+.5] )
         hold on
         for i = 1:size(lattice,1)
             for j = 1:size(lattice,2)
                 if ~isempty(lattice(i,j).pattern)
                     pNum = lattice(i,j).pattern;
                     plot(i,j,[patternsColor(pNum) patternsMarker(pNum)], 'MarkerSize',7)
                 end
             end
         end
         axis([1.5 size(lattice,1)-.5 1.5 size(lattice,1)-.5] )
end
set(handles.runBtn,'Enable','On')
handles.lattice = lattice;
handles.patternsMarker = patternsMarker;
handles.patternsColor = patternsColor;
handles.numPatterns = numPatterns;
handles.numClusters = numClusters;
handles.numFeatures = numFeatures;
handles.patterns = patterns;
handles.distanceMatrix = distanceMatrix;
handles.maxDistance = maxDistance;
handles.ants = [];
guidata(hObject,handles)

% --- Executes on button press in plotSampleChk.
function plotSampleChk_Callback(hObject, eventdata, handles)
% hObject    handle to plotSampleChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotSampleChk



function patternsNumberTxt_Callback(hObject, eventdata, handles)
% hObject    handle to patternsNumberTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of patternsNumberTxt as text
%        str2double(get(hObject,'String')) returns contents of patternsNumberTxt as a double


% --- Executes during object creation, after setting all properties.
function patternsNumberTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to patternsNumberTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function clustersNumberPopup_Callback(hObject, eventdata, handles)
% hObject    handle to clustersNumberPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of clustersNumberPopup as text
%        str2double(get(hObject,'String')) returns contents of clustersNumberPopup as a double


% --- Executes during object creation, after setting all properties.
function clustersNumberPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clustersNumberPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function featuresNumberTxt_Callback(hObject, eventdata, handles)
% hObject    handle to featuresNumberTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of featuresNumberTxt as text
%        str2double(get(hObject,'String')) returns contents of featuresNumberTxt as a double


% --- Executes during object creation, after setting all properties.
function featuresNumberTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to featuresNumberTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alphaTxt_Callback(hObject, eventdata, handles)
% hObject    handle to alphaTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alphaTxt as text
%        str2double(get(hObject,'String')) returns contents of alphaTxt as a double


% --- Executes during object creation, after setting all properties.
function alphaTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphaTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function antsNumberTxt_Callback(hObject, eventdata, handles)
% hObject    handle to antsNumberTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of antsNumberTxt as text
%        str2double(get(hObject,'String')) returns contents of antsNumberTxt as a double


% --- Executes during object creation, after setting all properties.
function antsNumberTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to antsNumberTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gammaPickTxt_Callback(hObject, eventdata, handles)
% hObject    handle to gammaPickTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gammaPickTxt as text
%        str2double(get(hObject,'String')) returns contents of gammaPickTxt as a double


% --- Executes during object creation, after setting all properties.
function gammaPickTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gammaPickTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gammaDropTxt_Callback(hObject, eventdata, handles)
% hObject    handle to gammaDropTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gammaDropTxt as text
%        str2double(get(hObject,'String')) returns contents of gammaDropTxt as a double


% --- Executes during object creation, after setting all properties.
function gammaDropTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gammaDropTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxIterTxt_Callback(hObject, eventdata, handles)
% hObject    handle to maxIterTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxIterTxt as text
%        str2double(get(hObject,'String')) returns contents of maxIterTxt as a double


% --- Executes during object creation, after setting all properties.
function maxIterTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxIterTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in runBtn.
function runBtn_Callback(hObject, eventdata, handles)
lattice = handles.lattice; latticeSize = size(lattice,1);
patternsMarker = handles.patternsMarker;
patternsColor = handles.patternsColor;
numPatterns = handles.numPatterns;
numClusters = handles.numClusters;
numFeatures = handles.numFeatures;
patterns = handles.patterns;
distanceMatrix = handles.distanceMatrix;
maxDistance = handles.maxDistance;
alpha = eval(get(handles.alphaTxt,'String'));
gamaPick = eval(get(handles.gammaPickTxt,'String'));
gamaDrop = eval(get(handles.gammaDropTxt,'String'));
maxIteration = eval(get(handles.maxIterTxt,'String'));
directionProbability = eval(get(handles.directionProbabilityTxt,'String'));
stepSize = eval(get(handles.stepSizeTxt,'String'));
neighborSize = eval(get(handles.neighborSizeTxt,'String'));
directionsStep = stepSize*[-1 -1; 0 -1; 1 -1; -1 1; 0 1; 1 1;-1 0; 1 0];
% pickupProbability = 1;
dropProbability = .5;
%% Ant Initialization
numberOfAnts = round(eval(get(handles.antsNumberTxt,'String')));
for antNum = 1:numberOfAnts
    ants(antNum).direction = randsrc(1,1,8:-1:1);
    ants(antNum).patternLoad = [];
    ants(antNum).location  = randsrc(1,2,2:size(lattice,1)-1);
end

% PlotMap(lattice,ant,numPatterns,plotPatternsOnLattice,showAntLocation,plotAntNeighor,patternsMarker,patternsColor,figureID);

idleCount = 0;

%% Start Clustering
for iterNumber = 1:maxIteration
    for antNum = 1:numberOfAnts
        %% Move Ant in a specific direction
        direction = ants(antNum).direction;
        randNumber = rand();
        nextLocation =  ants(antNum).location + directionsStep(ants(antNum).direction,:);
        if (nextLocation(1) < latticeSize )&&(nextLocation(2) < latticeSize)&&...
                (nextLocation(1) > 1 )&&(nextLocation(2) > 1)&&(randNumber<directionProbability)
            ants(antNum).location = nextLocation;
        else
            condition = true;
            while condition
                direction = randsrc(1,1,1:8);
                randNumber = rand();
                if ants(antNum).direction ~= direction
                    newLocation = ants(antNum).location + directionsStep(direction,:);

                    if (newLocation(1) < latticeSize - 1 )&&(newLocation(2) < latticeSize -1)&&...
                            (newLocation(1) > 1 )&&(newLocation(2) > 1)&&(randNumber<directionProbability)
                        ants(antNum).location  =newLocation;
                        ants(antNum).direction = direction;
                        condition = false;
                    else
                        condition = true;
                    end
                end
            end
            %     else
        end

        %         ants(antNum).location = newLocation;%ants(antNum).location + directionsStep(ants(antNum).direction,:);
        neighborSizeHalf=fix(neighborSize/2);
        nn = 0;
        for nx = -neighborSizeHalf:neighborSizeHalf
            for ny = -neighborSizeHalf:neighborSizeHalf
                nn = nn + 1;
                neighborsLocation(nn,1) = ants(antNum).location(1) + nx;
                neighborsLocation(nn,2) = ants(antNum).location(2) + ny;
            end
        end
        neighborsLocation(fix(nn/2)+1,:) = [];

        ants(antNum).neighborsLocation = neighborsLocation;

        t = 0;
        for n = 1:nn-1
            if (neighborsLocation(n,1) < latticeSize-1)&&(neighborsLocation(n,2) < latticeSize-1)&&...
                    (neighborsLocation(n,1) > 1 )&&(neighborsLocation(n,2)  >  1)

                if ~isempty( lattice(neighborsLocation(n,1),neighborsLocation(n,2)).pattern)
                    t = t + 1;
                    antNeighbors(t) = lattice(neighborsLocation(n,1),neighborsLocation(n,2)).pattern; %#ok<AGROW>
                end
            end
        end

        if isempty(ants(antNum).patternLoad)

            if (~isempty(lattice(ants(antNum).location(1) , ants(antNum).location(2)).pattern))&&(t==0)
                ants(antNum).patternLoad =lattice(ants(antNum).location(1) , ants(antNum).location(2)).pattern;
                lattice(ants(antNum).location(1) , ants(antNum).location(2)).pattern = [];

            elseif (~isempty(lattice(ants(antNum).location(1) , ants(antNum).location(2)).pattern))&&(t>0)
                %                             pickupP = 1-(length(find(patternsMarker(antNeighbors(:))==patternsMarker(lattice(ants(antNum).location(1) , ants(antNum).location(2)).pattern))))/t;
                %
                d = 0;
                for nD = 1:t
                    d(nD) = distanceMatrix(lattice(ants(antNum).location(1) , ants(antNum).location(2)).pattern,antNeighbors(nD));
                end
                %                        pickupP = 1-mean(d)/max(d);

                lambda = max(0,(1/t)*sum((1 - d/alpha)));
                lambdaPick(iterNumber,antNum) = lambda;
                pickupP = (gamaPick/(gamaPick + lambda))^2;
                pickupPAnt(iterNumber,antNum)  = pickupP;
                randNumber = rand;
                if randNumber < pickupP
                    ants(antNum).patternLoad =lattice(ants(antNum).location(1) , ants(antNum).location(2)).pattern;
                    lattice(ants(antNum).location(1) , ants(antNum).location(2)).pattern = [];
                end
            end
        else
            if (isempty(lattice(ants(antNum).location(1) , ants(antNum).location(2)).pattern))&&(t==0)&&(randNumber<dropProbability)
                lattice(ants(antNum).location(1) , ants(antNum).location(2)).pattern = ants(antNum).patternLoad;
                ants(antNum).patternLoad =[];
            elseif (isempty(lattice(ants(antNum).location(1) , ants(antNum).location(2)).pattern))&&(t>0)
                %                             dropP =  (length(find(patternsMarker(antNeighbors(:))==patternsMarker(ants(antNum).patternLoad))))/t;

                d = 0;
                for nD = 1:t
                    d(nD) = distanceMatrix(ants(antNum).patternLoad,antNeighbors(nD));
                end
                %                 dropP = mean(d)/max(d);
                lambda = max(0,(1/t)*sum(1 - d/alpha));
                lambdaDrop(iterNumber,antNum)  = lambda;
                if lambda < gamaDrop
                    dropP = 2*lambda;
                else
                    dropP = 1;
                end
                randNumber = rand;
                if randNumber < dropP
                    lattice(ants(antNum).location(1) , ants(antNum).location(2)).pattern = ants(antNum).patternLoad;
                    ants(antNum).patternLoad =[];
                end
                dropPAnt(iterNumber,antNum)  = dropP;
            end
        end
        %     PlotMap(lattice,ants,numPatterns,plotPatternsOnLattice,showAntLocation,plotAntNeighor,patternsMarker,patternsColor,iterNumber+2);
        % figureID = iterNumber;
        %% Plot
    end
    if iterNumber == maxIteration
        for antNum = 1:numberOfAnts
            lattice(ants(antNum).location(1) , ants(antNum).location(2)).pattern = ants(antNum).patternLoad;
            ants(antNum).patternLoad =[];
        end
    end

    if ~(get(handles.plotPatternsChk, 'Value')||get(handles.plotAntsChk, 'Value')||get(handles.plotGridChk, 'Value'))
        cla
        axis off
    else
        axes(handles.axes1)
        cla
        axis on
        set(handles.axes1,'XTickLabel',' ')
        set(handles.axes1,'YTickLabel',' ')
        hold on
    end
    if get(handles.plotGridChk, 'Value')
        grid on
        set(gca,'XTick',(-.5:1:size(lattice,1)+1.5)')
        set(gca,'YTick',(-.5:1:size(lattice,1)+1.5)')
        axis([1.5 size(lattice,1)-.5 1.5 size(lattice,1)-.5] )
    else
        grid off
    end
    if get(handles.plotPatternsChk,'Value')
        for i = 1:size(lattice,1)
            for j = 1:size(lattice,2)
                if ~isempty(lattice(i,j).pattern)
                    pNum = lattice(i,j).pattern;
                    plot(i,j,[patternsColor(pNum) patternsMarker(pNum)], 'MarkerSize',7)
                end
            end
        end
    end

    % plot ant location
    if get(handles.plotAntsChk,'Value')
        for antNum = 1:numberOfAnts
            %                 plot(ants(antNum).location(1),ants(antNum).location(2),'d','MarkerEdgeColor','k','MarkerFaceColor','k', 'MarkerSize',12)
            plot(ants(antNum).location(1),ants(antNum).location(2),'d','MarkerEdgeColor','k','LineWidth',2,'MarkerSize',12)
            if get(handles.plotNeighborsChk,'Value')
                plot(ants(antNum).neighborsLocation(:,1),ants(antNum).neighborsLocation(:,2),'>','MarkerEdgeColor','k', 'MarkerSize',4)
                %         end
            end
        end
        %         if plotAntNeighor
    end

    set(handles.iterNumberTxt,'String',['Iteration: ' num2str(iterNumber)]);
    pause(1/1000000)

end% iteration

handles. lattice = lattice;
handles.ants = ants;
guidata(hObject,handles)


% --- Executes on button press in plotAntsChk.
function plotAntsChk_Callback(hObject, eventdata, handles)
% hObject    handle to plotAntsChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotAntsChk



function directionProbabilityTxt_Callback(hObject, eventdata, handles)
% hObject    handle to directionProbabilityTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of directionProbabilityTxt as text
%        str2double(get(hObject,'String')) returns contents of directionProbabilityTxt as a double


% --- Executes during object creation, after setting all properties.
function directionProbabilityTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to directionProbabilityTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stepSizeTxt_Callback(hObject, eventdata, handles)
% hObject    handle to stepSizeTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stepSizeTxt as text
%        str2double(get(hObject,'String')) returns contents of stepSizeTxt as a double


% --- Executes during object creation, after setting all properties.
function stepSizeTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepSizeTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pasueBtn.
function pasueBtn_Callback(hObject, eventdata, handles)
pause on
pause


% --- Executes on button press in continueBtn.
function continueBtn_Callback(hObject, eventdata, handles)


% --- Executes on button press in plotNeighborsChk.
function plotNeighborsChk_Callback(hObject, eventdata, handles)
% hObject    handle to plotNeighborsChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotNeighborsChk



function neighborSizeTxt_Callback(hObject, eventdata, handles)
% hObject    handle to neighborSizeTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of neighborSizeTxt as text
%        str2double(get(hObject,'String')) returns contents of neighborSizeTxt as a double


% --- Executes during object creation, after setting all properties.
function neighborSizeTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neighborSizeTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotPatternsChk.
function plotPatternsChk_Callback(hObject, eventdata, handles)
% hObject    handle to plotPatternsChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotPatternsChk


% --- Executes on button press in plotGridChk.
function plotGridChk_Callback(hObject, eventdata, handles)
% hObject    handle to plotGridChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotGridChk

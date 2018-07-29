function simon(varargin)
%SIMON Do what Simon Says...
%   SIMON starts the standard game.
%   SIMON(N) starts the game with N keys.
%
%   Instructions:
%   - Press the start button (the green triangle pointing to the right) to
%     start the game. 
%   - Look and listen to what Simon says and repeat it. 
%   - Press the stop button (the red square) to stop the game. 
%   - Press the up and down buttons (the yellow triangles pointing up and 
%     down) to change the number of buttons.
%   - The numbers in the middle give the current score, the high score and
%     the numbers of buttons.
%
%   Example:
%     simon    start the standard game with four buttons.
%     simon(6) start the game with six buttons.

%   Eduard van der Zwan, 21-Jan-2007

%handle input
if nargin==0
    numberOfButtons=4;
elseif nargin==1 
    numberOfButtons=varargin{1};
    if ~isnumeric(numberOfButtons)||rem(numberOfButtons,1)~=0||numberOfButtons<=1
        error('Input must be an integer larger then 1.')
    end
else
    error('Too many input arguments.')
end

%load high score file
highScoreFile=[fileparts(which(mfilename)) filesep 'simonHighScore.mat'];
if exist(highScoreFile,'file')
    load(highScoreFile)
    if length(highScore)<numberOfButtons
        %we started with a high number of buttons
        highScore(numberOfButtons)=0;
    end
else
    highScore=zeros(numberOfButtons,1);
end
%create figure
h.figure=figure(...
    'Name','Simon',...
    'NumberTitle','off',....
    'Color','k',...
    'Toolbar','none',...
    'MenuBar','none',...
    'CloseRequestFcn',@closeRequest);

%user data
g=struct(...
    'buttonTime',0.2,...seconds
    'intervalTime',0.3,...seconds
    'sampleFrequency',10000,...Hz
    'dimRatio',0.5,...ratio between lid and dimmed button color
    'innerRadius',1.2,...of the big buttons
    'outerRadius',3,...of the big buttons
    'buttonStepRatio',0.1,...ratio between gap and button size
    'startButtonColor',[0 1 0],...green
    'stopButtonColor',[1 0 0],...red
    'upDownButtonColor',[1 1 0],...yellow
    'buttonRadius',0.2,...of the small button
    'oldPosition',get(h.figure,'Position'),...
    'numberOfButtons',numberOfButtons,...
    'highScore',highScore,...
    'highScoreFile',highScoreFile,...
    'userSequence',[],...
    'simonSequence',[],...
    'playUserSequence',false);

set(h.figure,'UserData',g);

%create axes
h.axes=axes(...
    'DataAspectRatio',[1 1 1],...
    'NextPlot','add',...
    'Visible','off',...
    'Parent',h.figure);

%create small buttons
%location of buttuns relative to origin
xButton=[-2 -2 2 2]*g.buttonRadius;
yButton=[2 -2 2 -2]*g.buttonRadius;

%create start button
angle=linspace(0,2*pi,4);
x=xButton(1)+cos(angle)*g.buttonRadius;
y=yButton(1)+sin(angle)*g.buttonRadius;
h.startButton=patch(...
    x,y,g.startButtonColor,...
    'EdgeColor','none',...
    'Parent',h.axes,...
    'BusyAction','cancel',...
    'Interruptible','off');

%create stop button
angle=linspace(0.25*pi,2.25*pi,5);
x=xButton(2)+cos(angle)*g.buttonRadius;
y=yButton(2)+sin(angle)*g.buttonRadius;
h.stopButton=patch(...
    x,y,g.stopButtonColor*g.dimRatio,...
    'EdgeColor','none',...
    'Parent',h.axes,...
    'BusyAction','cancel',...
    'Interruptible','off');

%create up button
angle=linspace(0.5*pi,2.5*pi,4);
x=xButton(3)+cos(angle)*g.buttonRadius;
y=yButton(3)+sin(angle)*g.buttonRadius;
h.upButton=patch(...
    x,y,g.upDownButtonColor,...
    'EdgeColor','none',...
    'Parent',h.axes,...
    'BusyAction','cancel',...
    'Interruptible','off');

%create down button
angle=linspace(1.5*pi,3.5*pi,4);
x=xButton(4)+cos(angle)*g.buttonRadius;
y=yButton(4)+sin(angle)*g.buttonRadius;
h.downButton=patch(...
    x,y,g.upDownButtonColor,...
    'EdgeColor','none',...
    'Parent',h.axes,...
    'BusyAction','cancel',...
    'Interruptible','off');

%create score text
h.score=text(...
    'Parent',h.axes,...
    'HorizontalAlignment','Center',...
    'VerticalAlignment','Middle',...
    'FontSize',18,...
    'FontWeight','Bold',...
    'Color','w');
setScore(h)

%create buttons in circle
createButtons(h)


function createButtons(h)
%create buttons in the circle
g=get(h.figure,'UserData');

%determine colors and sounds
%about sounds:
%   the 'A' has a frequency of 440 Hz. All other frequncies of the piano
%   keys can be be determined with:
%       keyFrequency=440*2^(keyNumber/12) 
%   in which keyNumber is the number of the key relative to the 'A' key;
%   with 'A' being 0, left of that key minus numbers, and right of that key
%   plus numbers
if g.numberOfButtons==4 
    %original colors and sounds
    buttonCollor=[1 0 0;0 1 0;1 1 0;0 0 1]*g.dimRatio;
    %red = [1 0 0], green = [0 1 0], yellow = [1 1 0] and blue = [0 0 1]
    buttonFrequency=440*2.^([0 12 10 5]/12);
    %A = 0, a = 12, G = 10 and D = 5
else
    buttonCollor=hsv(g.numberOfButtons)*g.dimRatio;
    buttonFrequency=440*2.^((0:g.numberOfButtons-1)/12);
end

buttonWidthAngle=2*pi/g.numberOfButtons;
outerAngleStep=buttonWidthAngle*g.buttonStepRatio;
innerAngleStep=outerAngleStep*g.outerRadius/g.innerRadius;

h.button=[];
for buttonNumber=1:g.numberOfButtons
    %user data for button
    signalVector=sin(linspace(0,buttonFrequency(buttonNumber)*g.buttonTime*2*pi,g.sampleFrequency*g.buttonTime));
    b=struct(...
        'signalVector',signalVector,...
        'buttonNumber',buttonNumber);
    %draw button
    buttonAngle=(buttonNumber-1)*buttonWidthAngle;
    innerArc=linspace(buttonAngle,buttonAngle+buttonWidthAngle-innerAngleStep,20)+innerAngleStep/2;
    outerArc=linspace(buttonAngle,buttonAngle+buttonWidthAngle-outerAngleStep,40)+outerAngleStep/2;
    x=[g.innerRadius*cos(innerArc) g.outerRadius*cos(fliplr(outerArc))];
    y=[g.innerRadius*sin(innerArc) g.outerRadius*sin(fliplr(outerArc))];
    h.button(buttonNumber)=patch(...
        x,y,buttonCollor(buttonNumber,:),...
        'EdgeColor','none',...
        'Parent',h.axes,...
        'UserData',b,...
        'BusyAction','cancel',...
        'Interruptible','off');
end

%set object functions including the handles to above buttons
for buttonNumber=1:g.numberOfButtons
    set(h.button(buttonNumber),'ButtonDownFcn',{@buttonDown,h})
end
set(h.startButton,'ButtonDownFcn',{@startButtonDown,h});
set(h.stopButton,'ButtonDownFcn',{@stopButtonDown,h});
set(h.upButton,'ButtonDownFcn',{@upButtonDown,h});
set(h.downButton,'ButtonDownFcn',{@downButtonDown,h});
set(h.figure,'ResizeFcn',{@resize,h})


function startButtonDown(hStartButton,eventdata,h)
%start button is pressed
g=get(h.figure,'UserData');
startButtonColor=get(hStartButton,'FaceColor');
if isequal(startButtonColor,g.startButtonColor)
    %make buttons inactive
    set(hStartButton,'FaceColor',g.startButtonColor*g.dimRatio)
    set(h.upButton,'FaceColor',g.upDownButtonColor*g.dimRatio)
    set(h.downButton,'FaceColor',g.upDownButtonColor*g.dimRatio)
    %make stop button active
    set(h.stopButton,'FaceColor',g.stopButtonColor)
    playSimonSequence(h)
end


function stopButtonDown(hStopButton,eventdata,h)
%stop button is pressed
g=get(h.figure,'UserData');
stopButtonColor=get(hStopButton,'FaceColor');
if isequal(stopButtonColor,g.stopButtonColor)
    %make stop button inactive
    set(hStopButton,'FaceColor',g.stopButtonColor*g.dimRatio)
    %make buttons active
    set(h.startButton,'FaceColor',g.startButtonColor)
    set(h.upButton,'FaceColor',g.upDownButtonColor)
    set(h.downButton,'FaceColor',g.upDownButtonColor)
    %reset data
    g.userSequence=[];
    g.simonSequence=[];
    g.playUserSequence=false;
    set(h.figure,'UserData',g)
end


function upButtonDown(hUpButton,eventdata,h)
%up button is pressed
g=get(h.figure,'UserData');
upButtonColor=get(hUpButton,'FaceColor');
if isequal(upButtonColor,g.upDownButtonColor)
    g.numberOfButtons=g.numberOfButtons+1;
    %expand high score
    if length(g.highScore)<g.numberOfButtons
        g.highScore(g.numberOfButtons)=0;
    end
    set(h.figure,'UserData',g)
    setScore(h)
    delete(h.button)
    %create buttons in circle
    createButtons(h)
end


function downButtonDown(hDownButton,eventdata,h)
%down button is pressed
g=get(h.figure,'UserData');
downButtonColor=get(hDownButton,'FaceColor');
if isequal(downButtonColor,g.upDownButtonColor) && g.numberOfButtons>2
    g.numberOfButtons=g.numberOfButtons-1;
    set(h.figure,'UserData',g)
    setScore(h)
    delete(h.button)
    %create buttons in circle
    createButtons(h)
end


function buttonDown(hButton,eventdata,h)
%a button in the circle is pressed
g=get(h.figure,'UserData');
b=get(hButton,'UserData');

dimColor=get(hButton,'FaceColor');
litColor=dimColor/g.dimRatio;
%lid button and play sound
set(hButton,'FaceColor',litColor)
sound(b.signalVector,g.sampleFrequency)
pause(g.buttonTime)
set(hButton,'FaceColor',dimColor)
if g.playUserSequence
    %button is pressed by user
    g.userSequence(end+1)=b.buttonNumber;
    set(h.figure,'UserData',g);
    if isequal(g.userSequence,g.simonSequence)
        %user repeated Simon correctly
        playSimonSequence(h)
    elseif ~isequal(g.userSequence,g.simonSequence(1:length(g.userSequence)))
        %user made mistake
        stopButtonDown(h.stopButton,[],h)    
        %play rest of Simons sequence
        restSequence=g.simonSequence(length(g.userSequence):end);
        for counter=1:length(restSequence)
            pause(g.intervalTime)
            hButton=h.button(restSequence(counter));
            buttonDown(hButton,[],h);
        end
    end
end

function closeRequest(hFigure,eventdata)
%figure is closed 
g=get(hFigure,'UserData');
%save high score
highScore=g.highScore;
save(g.highScoreFile,'highScore')
%and delete figure 
%error if a sequence is played
delete(hFigure)

function resize(hFigure,eventdata,h)
%figure is resized
g=get(hFigure,'UserData');
%change font of score text
newPosition=get(hFigure,'Position');
newFontSize=get(h.score,'FontSize')*min(newPosition(3:4))/min(g.oldPosition(3:4));
set(h.score,'FontSize',newFontSize)
g.oldPosition=newPosition;
set(hFigure,'UserData',g);


function playSimonSequence(h)
%Simon playes his sequence
g=get(h.figure,'UserData');
%change high score
if length(g.simonSequence)>g.highScore(g.numberOfButtons)
    g.highScore(g.numberOfButtons)=length(g.simonSequence);
end
set(h.figure,'UserData',g)
setScore(h)
%expand Simons sequence
g.simonSequence(end+1)=ceil(rand*g.numberOfButtons);
g.userSequence=[];
g.playUserSequence=false;
set(h.figure,'UserData',g)
%play sequence
for counter=1:length(g.simonSequence)
    pause(g.intervalTime)
    hButton=h.button(g.simonSequence(counter));
    buttonDown(hButton,[],h);
end
g.playUserSequence=true;
set(h.figure,'UserData',g);


function setScore(h)
%reset score text
g=get(h.figure,'UserData');
score=int2str(length(g.simonSequence));
highScore=int2str(g.highScore(g.numberOfButtons));
numberOfButtons=int2str(g.numberOfButtons);
set(h.score,'String',[score ' ' highScore ' ' numberOfButtons])

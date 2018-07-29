function let(action,ODEfunction,DATA,AxisRange)
%LET   Lyapunov Exponents Toolbox
%
%      To run the program, enter LET in MATLAB command window.
%      Details of the program can be obtained by pressing
%      the "Information" button in the startup window. The
%      program information can also be found in files README.M,
%      LETHELP.M and SETHELP.M.

%      by Steve Wai Kam SIU, July 5, 1998.

if nargin<1
   clear;	%Clear all variables initially
   clc;		%Clear the command window
   action='Initialization'; 
else
   %If it is a callback action, obtain  the handles of the
   %GUI components stored in'UserData' of the main window.
   MainHandles=get(gcf,'UserData');
end

switch action
case 'Initialization'
   startlet;	%Show a startup window
   
case 'runLET'
   %Default axis range
   if nargin<4
      AxisRange=[0,1000,-25,25];
   end
   %Font size of UI components
   FontSize=8;
   %Setup a GUI window and obtain the handles of GUI components
   MainHandles=maingui(AxisRange,FontSize);
   %Store the handles in "UserData" of the figure such that
   %it can be accessed anywhere by using the "get" command.
   set(gcf,'UserData',MainHandles);
   
   %If no specified parameters are supplied, use default values.
   if nargin<2
      
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Default Parameters for setting window
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     	
      OutputFile='data.out';      %Default output file: data.out
      output=0;                   %Don't check "Output File": 1="on", 0="off"
      LEout=1;                    %Check "Lyapunov Exponents"
      LDout=1;                    %Check "Lyapunov Dimension"
      LEprecision=1;              %Precision of output values of the 
      LDprecision=1;              %  Lyapunov exponents and dimension  
                                  % are set to 1 (4 floating points).
                                  % 2 means %.6f, 3 means %.8f, ...
      ODEfunction='';     %No default ODE function
      IntMethod=2;        %Integration method: 1=Discrete map, 2=ODE45, 3=ODE23
	                       % 4=ODE113, 5=ODE23S, 6=ODE15S
      InitalTime=0;       %Default initial time: 0
      FinalTime=1000;     %Default final time: 1000
      TimeStep=0.01;      %Default time step: 0.01
      RelTol=1e-5;        %Default relative tolerance: 1E-5
      AbsTol=1e-5;        %Default absolute tolerance: 1E-5
      IC=[];              %No default initial coniditions
      LODEnum=[];         %No. of linearized equation (default: none )
   
      %PLOTTING OPTIONS:  Only one of them can be set "on" (i.e. 1)
      plot1=1;            %Update the plot imediately
      plot2=0;            %Update the plot every ... iterations
      ItrNum=10;          %No. of iterations for updating the plot
   
      %Line Colors
      Blue=1; Black=2; Green=3; Red=4; Yellow=5; Magenta=6; Cyan=7;
      LineColor=Blue;     %Default line color: Blue
      Discard=100;        %Default transient iterations to be discarded: 100
      UpdateSteps=10;     %Update the LEs every 10 time steps
    
      %Save the default values and upload them onto the 
      %'UserData' of the "Setting" button
      DATA=[output,       LEout, LEprecision,    LDout, LDprecision, ... 
         IntMethod,  InitalTime,   FinalTime, TimeStep, RelTol, ...
            AbsTol,       plot1,       plot2,   ItrNum, LineColor, ...
           Discard, UpdateSteps,     LODEnum,       IC];
   else
      %No specified output file for demo
      OutputFile='';
   end
   set(MainHandles(4),'UserData',DATA);
   %Upload the output file and ODE function names
   NAMES=char(OutputFile,ODEfunction);
   set(MainHandles(2),'UserData',NAMES);
case 'stop'
   %If "Stop" button is pressed,disable the button itself 
   %and enable the others.
   set(MainHandles([2,4,13,15]),'Enable','On');
   set(MainHandles(3),'Enable','Off');
   
   %Set a flag to indicate "Stop" action is requested so 
   %that the program FINDLYAP knows during calculation 
   %and stops the process imediately. 
   set(MainHandles(3),'UserData',1);
   %Note: FINDLYAP checks whether the "Stop" button is pressed
   %before each iteration
case 'setting'
   %Load the setting window
   setting;
case {'OnPressed','OffPressed'}
   %If "On" is checked, uncheck "Off" and vice versa.
   %MainHandles(5) is the handle of "On" radio button
   %MainHandles(6) is the handle of "Off" radio button
   OnIsOn=get(MainHandles(5),'Value');
   OffIsOn=get(MainHandles(6),'Value');
   
   if ( (strcmp(action,'OnPressed') & OnIsOn)| ...
        (strcmp(action,'OffPressed') & ~OffIsOn) )
      check(MainHandles(5),MainHandles(6));	%Check "On" and uncheck "Off"
      grid on;											%Show grid lines
   else
      check(MainHandles(6),MainHandles(5));	%Check "Off" and uncheck "On"
      grid off;										%Remove grid lines
   end
case 'changeAxis'
   %MainHandles(7) is the handle of the "X :" edit box
   %MainHandles(8) is the handle of the "Y :" edit box
   %Get values input by user
   xRange=str2num(get(MainHandles(7),'String'));
   yRange=str2num(get(MainHandles(8),'String'));
   
   %Check whether the input values are in correct format
   if ( all(size(xRange)==[1,2]) & all(size(yRange)==[1,2]) ...
      	& xRange(1)<xRange(2) & yRange(1)<yRange(2) ...
      	& xRange(1)~=xRange(2) & yRange(1)~=yRange(2))
      axis([xRange,yRange]);		%Re-arrange the axis range.
      %Save the data for restoring previous values if error occurs
      set(MainHandles(7),'UserData',xRange);
      set(MainHandles(8),'UserData',yRange);
      axis('manual');				%Freeze the current axis-limits
   else
      %If error occurs, restore the original values
      xRange=get(MainHandles(7),'UserData');
   	yRange=get(MainHandles(8),'UserData');
      set(MainHandles(7),'String',[num2str(xRange(1)) ', ' num2str(xRange(2))]);
      set(MainHandles(8),'String',[num2str(yRange(1)) ', ' num2str(yRange(2))]);
      msg=['Input must be a 1 x 2 numeric matrix'...
            ' with format [minValue, maxValue], where'...
            ' minValue < maxValue.'];
      errordlg(msg,'ERROR','replace');
   end
case 'drawLine'
   %MainHandles(9) is the handle of the "Draw line at" edit box
   str=get(MainHandles(9),'String');   
   y=str2num(str);  [ry,cy]=size(y);
   LinesHandles=get(MainHandles(9),'UserData');
   L=length(LinesHandles);
   del=strcmp(lower(rmspace(str)),'del');
   delall=strcmp(lower(rmspace(str)),'del*');
   %Check whether the input values are in correct format
   if (~isempty(y) & ry==1)
      Y=[1;1]*y;
      xRange=get(gca,'XLim');
      X=xRange(:)*ones(1,length(y));
      hold on; h=plot(X,Y,'k');
      %Force MATLAB to draw imediately even if calculation is in progress
      drawnow;					      							
      %Add the new line handle(s), store them, and
      %clear the string in the edit box.
      newLinesHandles=[LinesHandles,h];
      set(MainHandles(9),'UserData',newLinesHandles,'String','');
   elseif ( L>=1 & del)
      %Delete the previous drawn line
      delete(LinesHandles(L));
      
      %Remove the line handle stored in 'UserData', and
      %clear the string in the edit box.
      if L>1
         set(MainHandles(9),'UserData',LinesHandles(1:L-1),'String','');
      else
         set(MainHandles(9),'UserData',[],'String','');
      end
   elseif ( L>=1 & delall)
      % Delete all drawn lines
      delete(LinesHandles);
      set(MainHandles(9),'UserData',[],'String','');
   elseif ( L<1 & (del | delall) )
      msg='No more line can be deleted.';
      errordlg(msg,'ERROR','replace');
   else
      msg=['Input must be a numeric number or row vector!'...
            ' Use DEL to delete the previous drawn line or DEL*'...
            ' to delete all drawn lines.'];
      errordlg(msg,'ERROR','replace');
   end
case 'plot'
   %Get the line handles stored in 'UserData' of the 
   %"New Plot" button
   LineHandles=get(MainHandles(13),'UserData');
   [rL,cL]=size(LineHandles);
   if ~isempty(LineHandles)
   	%Get the current axis labels and title
   	xLabel=get(get(gca,'xlabel'),'String');
   	yLabel=get(get(gca,'ylabel'),'String');
   	Title=get(get(gca,'Title'),'String');

   	%Get the line color
   	DATA=get(MainHandles(4),'UserData');
   	Color=DATA(15);
   	%Construct a look-up table for the line colors
      COLORS='bkgrymc';
      %Map the "Line color" pop-up menu position to the look-up table
      LineColor=COLORS(Color); 

   	figure('Units','Normalized','Color',[1 1 1],'Name','Lyapunov Exponents Spectrum', ...
   	'NumberTitle','off','Position',[0.1 0.1 0.8 0.8],'Tag','newplot');
   	xlabel(xLabel); ylabel(yLabel); title(Title);
        for i=1:rL
           for j=1:cL
              xData=get(LineHandles(i,j),'xData');
              yData=get(LineHandles(i,j),'yData');
              plot(xData,yData,LineColor);
              hold on;
           end
        end
        hold off;
   else
      errordlg('No data is available!','ERROR','replace');
   end
case 'help'
   helpwin('lethelp','LET Help Window');
case 'start'
   %When "Start" button is pressed, disable the "Start", 
   %"Setting", "Exit" and "New Plot" buttons, and 
   %enable the "Stop" button.
   set(MainHandles([2,4,13,15]),'Enable','Off');
   set(MainHandles(3),'Enable','On');
   set(gca,'UserData',0);
   %Reset the state of "Stop" button to zero (i.e. not pressed)
   set(MainHandles(3),'UserData', 0);
   msg='Errors in "findlyap".';
   Warn=['errordlg(msg,''ERROR'',''replace'');',...
        'set(MainHandles([2,4,13,15]),''Enable'',''On'');',...
        'set(MainHandles(3),''Enable'',''Off'');',...
        'findlyap(MainHandles)'];
  %eval('findlyap(MainHandles)',Warn);
  LineHandles=findlyap(MainHandles);
  %Store the line handles in the 'Userdata' of the "New Plot" button.
  set(MainHandles(13),'UserData',LineHandles);
otherwise
   error('Incorrect input argument!');
end

%--------------------------Subroutines---------------------------

function MainHandles=maingui(AxisRange,FontSize)
%MAINGUI   Function accompanied with LET
%          MAINGUI creates a graphical user interface (GUI)window.

%          by Steve Wai Kam SIU, Feb. 19, 1998.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Default parameters for main window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--Grid Lines--
gOn=0;				%Grid on: initial set 0 (i.e. off)
gOff=1;				%Grid off: initial set 1 (i.e. on)
%--Plot Range--
%1st element is the min. value, 2nd is the max. value
xRange=AxisRange(1:2);	%Plot range of X-Axis
yRange=AxisRange(3:4);	%Plot range of Y-Axis
%--Draw line at--
y=[];                           %No value is displayed initially
%--Current Time--
ct=0;                           %Current time (initial displayed value)
%--Final Time--
ft=0;                           %Final time (initial displayed value)
%--Time Used--
ut=0;                           %Time counted from starting calculation
%--Bottom text--
bttmText='';                    %Nothing is displayed initially
%X-Axis Label
xLabel='Time';
%Y-Axis Label
yLabel='Lyapunov Exponents';
%Title
Title='';                       %No default title
%%%%%%%%%%%%%%%%%%%%%%%%%
%	GUI window setup
%%%%%%%%%%%%%%%%%%%%%%%%%
WinWidth=0.95;		%Window width
WinHeight=0.78;         %Window height
BtnWidth=0.12;		%Button width
BtnHeight=0.05;         %Button height
xPos=0.865;             %X-position of buttons
%Window
a=figure('Units','Normalized','Color',[1 1 1],'BackingStore','Off',...
        'Name','LET Main Program','NumberTitle','off', ...
        'Position',[0.02 0.1 WinWidth WinHeight],'Visible','Off','Tag','Fig1');
%Right frame
uicontrol('Parent',a,'Units','normalized','BackgroundColor',[0.513725 0.6 0.694118], ...
        'Position',[0.85 0 0.15 1],'Style','frame','Tag','Frame2');
%Bottom frame
uicontrol('Parent',a,'Units','normalized','BackgroundColor',[0.513725 0.6 0.694118], ...
        'Position',[0 0 0.85 0.0676],'Style','frame','Tag','Frame1');
%Bottom text display for showing the calculated
%Lyapunov exponents at each iteration.
btmDisplay=uicontrol('Parent',a,'Units','normalized','BackgroundColor',[1 1 1], ...
        'ForegroundColor',[0 0 1],'Position',[0.0057 0.01 0.835 0.045], ...
        'String',bttmText,'FontSize', FontSize,'Style','text','Tag','StaticText9');
%"Start" button
startBtn=uicontrol('Parent',a,'Units','normalized','Callback','let(''start'')', ...
        'FontSize', FontSize,'FontWeight','bold','Position',[xPos 0.94 BtnWidth BtnHeight], ...
        'String','Start','Interruptible','on','Tag','Pushbutton1');
%"Stop" button : initial set disable
stopBtn=uicontrol('Parent',a,'Units','normalized','Callback','let(''stop'')', ...
        'FontSize', FontSize,'FontWeight','bold','Position',[xPos 0.88 BtnWidth BtnHeight], ...
        'String','Stop','UserData',0,'Enable','off','Tag','Pushbutton2');
%"Setting" button
settingBtn=uicontrol('Parent',a,'Units','normalized','Callback','let(''setting'')', ...
        'FontSize', FontSize,'FontWeight','bold','Position',[xPos 0.82 BtnWidth BtnHeight], ...
        'String','Setting','Tag','Pushbutton3');
%Label: "Grid Lines"
uicontrol('Parent',a,'Units','normalized','BackgroundColor',[0.513725 0.6 0.694118], ...
        'FontSize', FontSize,'FontWeight','bold','Position',[0.86 0.72 0.07 0.08], ...
        'String','Grid Lines','Style','text','Tag','StaticText1');
%Grid Lines "On" radio button
gOnRadio=uicontrol('Parent',a,'Units','normalized','BackgroundColor',[0.513725 0.6 0.694118], ...
   'Position',[0.925 0.765 0.07 0.043],'Callback','let(''OnPressed'')','FontSize',FontSize, ...
   'String','On','Value',gOn,'Style','radiobutton','Tag','Radiobutton1');
%Grid Lines "Off" Radio Button
gOffRadio=uicontrol('Parent',a,'Units','normalized','BackgroundColor',[0.513725 0.6 0.694118], ...
        'Position',[0.925 0.723 0.07 0.043],'Callback','let(''OffPressed'')','FontSize',FontSize,...
        'String','Off','Style','radiobutton','Tag','Radiobutton2','Value',gOff);
%Label: "Plot Range"
uicontrol('Parent',a,'Units','normalized','BackgroundColor',[0.513725 0.6 0.694118], ...
        'FontSize', FontSize,'FontWeight','bold','Position',[0.86 0.68 0.135 0.035], ...
        'String','Plot Range','Style','text','Tag','StaticText10');
%Label: "X :" (X-Axis)
uicontrol('Parent',a,'Units','normalized','BackgroundColor',[0.513725 0.6 0.694118], ...
        'FontSize', FontSize,'Position',[0.855 0.625 0.0365 0.037], ...
        'String','X :','Style','text','Tag','StaticText11');
%Edit text box for "X :"
xRangeEdt=uicontrol('Parent',a,'Units','normalized','BackgroundColor',[1 1 1], ...
   'ForegroundColor',[0 0 1],'Position',[0.89 0.62 0.1 0.045], ...
   'String',[num2str(xRange(1)) ', ' num2str(xRange(2))],'FontSize', FontSize, ...
   'Callback','let(''changeAxis'')','UserData', xRange,'Style','edit','Tag','EditText2');
%Label: "Y :" (Y-Axis)
uicontrol('Parent',a,'Units','normalized','BackgroundColor',[0.513725 0.6 0.694118], ...
        'Position',[0.855 0.56 0.0365 0.037],'String','Y :','Style','text','Tag','StaticText12');
%Edit text box for "Y :"
yRangeEdt=uicontrol('Parent',a,'Units','normalized','BackgroundColor',[1 1 1], ...
        'ForegroundColor',[0 0 1],'Position',[0.89 0.555 0.1 0.045],'FontSize', FontSize,...
        'String',[num2str(yRange(1)) ', ' num2str(yRange(2))],'UserData',yRange, ...
        'Callback','let(''changeAxis'')','Style','edit','Tag','EditText3');
%Label: "Draw line at"
uicontrol('Parent',a,'Units','normalized','BackgroundColor',[0.513725 0.6 0.694118], ...
        'FontSize', FontSize,'Position',[0.865 0.51 0.12 0.035],'String','Draw line at', ...
        'Style','text','Tag','StaticText2');
%Edit box for "Draw Line at"
drawEdt=uicontrol('Parent',a,'Units','normalized','BackgroundColor',[1 1 1], ...
        'ForegroundColor',[0 0 1],'Position',[0.86 0.46 0.13 0.045],'FontSize', FontSize,...
        'String',num2str(y),'Callback','let(''drawLine'')','Style','edit','Tag','EditText1');
%Label: "Current Time"
uicontrol('Parent',a,'Units','normalized','BackgroundColor',[0.513725 0.6 0.694118], ...
        'FontSize', FontSize,'Position',[0.865 0.415 0.12 0.035], ...
        'String','Current Time','Style','text','Tag','StaticText3');
%Display of "Current Time"
ctDisplay=uicontrol('Parent',a,'Units','normalized','BackgroundColor',[1 1 1], ...
        'ForegroundColor',[0 0 1],'Position',[0.86 0.38 0.13 0.035],'FontSize', FontSize,...
        'String',num2str(ct),'Style','text','Tag','StaticText4');
%Label: "Final Time"
uicontrol('Parent',a,'Units','normalized','BackgroundColor',[0.513725 0.6 0.694118], ...
        'FontSize', FontSize,'Position',[0.865 0.33 0.12 0.035],...
        'String','Final Time','Style','text','Tag','StaticText5');
%Display of "Final Time"
ftDisplay=uicontrol('Parent',a,'Units','normalized','BackgroundColor',[1 1 1], ...
        'ForegroundColor',[0 0 1],'Position',[0.86 0.295 0.13 0.035], ...
        'String',num2str(ft),'Style','text','FontSize', FontSize,'Tag','StaticText6');
%Label: "Time Used"
        uicontrol('Parent',a,'Units','normalized','BackgroundColor',[0.513725 0.6 0.694118], ...
        'FontSize', FontSize,'Position',[0.865 0.245 0.12 0.035], ...
        'String','Time Used','Style','text','Tag','StaticText7');
%Display text of "Time Used"
utDisplay=uicontrol('Parent',a,'Units','normalized','BackgroundColor',[1 1 1], ...
        'ForegroundColor',[0 0 1],'Position',[0.86 0.21 0.13 0.035], ...
        'String',num2str(ut),'FontSize', FontSize,'Style','text','Tag','StaticText8');
%"New Plot" button
plotBtn=uicontrol('Parent',a,'Units','normalized','Callback','let(''plot'')', ...
        'FontSize', FontSize,'FontWeight','bold','Position',[xPos 0.14 BtnWidth BtnHeight], ...
        'String','New Plot','Enable','Off','Tag','Pushbutton4');
%"Help" button
helpBtn=uicontrol('Parent',a,'Units','normalized','Callback','let(''help'')', ...
        'FontSize', FontSize,'FontWeight','bold','Position',[xPos 0.08 BtnWidth BtnHeight], ...
        'String','Help','Tag','Pushbutton5');
%"Exit" button
exitBtn=uicontrol('Parent',a,'Units','normalized','Callback','close(gcf)', ...
        'FontSize', FontSize,'FontWeight','bold','Position',[xPos 0.02 BtnWidth BtnHeight], ...
        'String','Exit','Tag','Pushbutton6');
%Define the active region on the figure for plotting
set(gca,'Position',[0.1 0.1776 0.7024 0.7474]);
%Setup Axes using default ranges
axis(AxisRange);
%Create axis box
box;
%Add X-axis label, Y-axis label and  title
xlabel(xLabel); ylabel(yLabel); title(Title);
%Freeze axes
axis('manual');
%Output the handles (or addresses) of the GUI elements
%which will be used later
MainHandles=[btmDisplay,  startBtn,   stopBtn, settingBtn, ...
               gOnRadio, gOffRadio, xRangeEdt,  yRangeEdt, ...
                drawEdt, ctDisplay, ftDisplay,  utDisplay, ...
                plotBtn,   helpBtn,  exitBtn];
%Uncover the figure when setup is finished
set(a,'Visible','On');

%------------------------------------------------------------

function check(checkList,uncheckList)

%CHECK  Check function for check box or radio button
%			
%       CHECK(CHECKLIST) checks the radio buttons or 
%       check boxes with handles in CHECKLIST.
%
%       CHECK(CHECKLIST,UNCHECKLIST) checks the radio 
%       buttons or check boxes with handles in CHECKLIST
%       and unchecks the ones with handles in UNCHECKLIST.
%
%       CHECK([],UNCHECKLIST) unchecks the radio buttons
%       or check boxes with handles in CHECKLIST.

%       by Steve Wai Kam SIU, Feb. 19, 1998.

if nargin<2
   uncheckList=[];
end
if ~isempty(checkList)
   set(checkList,'Value',1);
end
if ~isempty(uncheckList)
   set(uncheckList,'Value',0);
end

%------------------------------------------------------------------------

function outStr=rmspace(inStr)
%RMSPACE  Function for removing the beginning and ending
%         spaces of a string

%Remove spaces at the end of the string
outStr=strcat(inStr);
%Delete spaces at the beginning of the string
if ~isempty(outStr)
   while isspace(outStr(1))
   	outStr=outStr(2:length(outStr));
   end
end

function setting(action)
%SETTING    GUI window for users to input parameters
%
%           See also: LET, README, SETHELP, LETHELP, STARTLET

%           by Steve W. K. SIU, July 5, 1998.

if nargin<1
   action='initilization';
   %Obtain the handles of all GUI components of
   %the main window for later use
   MainHandles=get(gcf,'UserData');
else
   %Get the handles of GUI components of
   %the Setting window.
   HandlesList=get(gcf,'UserData');
end
action=lower(action);
switch action
case 'initilization'
   %Font Size
   FontSize=8;
   %%%%%%%%%%%%%%%%%%%%%%%%%%
   %% 	INITIALIZATION
   %%%%%%%%%%%%%%%%%%%%%%%%%%
   %Restore the (default) DATA
   DATA=get(MainHandles(4),'UserData');
   %Create a GUI Setting Window
   %Before creating the setting window, get current axes' handles
   AxesHandle=gca;
   %Get the data stored in 'UserData' of the "Setting" button
   %MainHandles(4) is the handle of "Setting" button
   DATA=get(MainHandles(4),'UserData');
   %Get the output file and ODE function names stored in
   %'UserData' of the "Start" button.
   %MainHandles(2) is the handle of "Start" button
   NAMES=get(MainHandles(2),'UserData');
   OutputFile=rmspace(NAMES(1,:));
   odeFunction=rmspace(NAMES(2,:));
   %%%%%%%%%%%%%%%%%%%%%%%%%%%
   %      Setting Window
   %%%%%%%%%%%%%%%%%%%%%%%%%%%
   a=figure('Units','Normalized','Color',[0.513725 0.6 0.694118], ...
        'Name','Setting','NumberTitle','off',...
        'Position',[0.085 0.065 0.85 0.8],'MenuBar','None', ...
        'Resize','on','Visible','Off','Tag','Fig1');
   %Label: "OUTPUT OPTIONS"
   uicontrol('Parent',a,'Units','normalized','Tag','StaticText10',...
        'HorizontalAlignment','left',...   
        'BackgroundColor',[0.513725 0.6 0.694118],'String','OUTPUT OPTIONS',...
        'FontSize', FontSize,'FontWeight','bold','Style','text',...
        'Position',[0.05 0.9 0.3 0.04]);
   %Check box for "Output File"
   opChk=uicontrol('Parent',a,'Units','normalized','Tag','Checkbox1', ...
        'HorizontalAlignment','left',...   
        'BackgroundColor',[0.513725 0.6 0.694118],'FontSize', FontSize, ...
        'Position',[0.05 0.84 0.15 0.0527859],...
        'String','Output File :','Style','checkbox','Value',DATA(1));
   %Edit box for "Output File"
   opEdt=uicontrol('Parent',a,'Units','normalized','Tag','EditText8',...
        'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 1],'Style','edit', ...
        'Position',[0.2 0.84 0.234 0.0557185],'FontSize', FontSize,'String',OutputFile);
   %Label: "Precision"
   uicontrol('Parent',a,'Units','normalized', ...
        'BackgroundColor',[0.513725 0.6 0.694118], ...
        'FontSize', FontSize,'Position',[0.28 0.78 0.12 0.04], ...
        'String','Precision','Style','text','Tag','StaticText11');
   %Check box for "Lyapunov Exponents"
   leChk=uicontrol('Parent',a,'Units','normalized', ...
      'BackgroundColor',[0.513725 0.6 0.694118],'Tag','Checkbox2', ...
      'HorizontalAlignment','left',...   
      'FontSize', FontSize,'Position',[0.05 0.71261 0.226415 0.058651], ...
      'String','Lyapunov Exponents','Style','checkbox','Value',DATA(2));
   %Check box for "Lyapunov Dimension"
   ldChk=uicontrol('Parent',a,'Units','normalized','Tag','Checkbox3', ...
      'BackgroundColor',[0.513725 0.6 0.694118],'FontSize', FontSize, ...
      'HorizontalAlignment','left',...   
      'Position',[0.05 0.648094 0.226415 0.058651], ...
      'String','Lyapunov Dimension','Style','checkbox','Value',DATA(4));
   %Pop-up menu for precision of "Lyapunov Exponents"
   lePop=uicontrol('Parent',a,'Units','normalized', ...
      'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 1], ...
      'Position',[0.285 0.715543 0.115 0.058651],'FontSize', FontSize, ...
      'String',char('%.4f','%.6f','%.8f','%.10f','%.12f'), ...
      'Style','popupmenu','Tag','PopupMenu2','Value',DATA(3));

   %Pop-up menu for precision of Lyapunov dimension
   ldPop=uicontrol('Parent',a,'Units','normalized', ...
      'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 1], ...
      'Position',[0.285 0.65 0.115 0.058],'FontSize', FontSize, ...
      'String',char('%.4f','%.6f','%.8f','%.10f','%.12f'), ...
      'Style','popupmenu','Tag','PopupMenu3','Value',DATA(5));
   %Label: "INTEGRATION PARAMETERS"
   uicontrol('Parent',a,'Units','normalized','FontSize', FontSize,...
        'BackgroundColor',[0.513725 0.6 0.694118],'FontWeight','bold',...
        'HorizontalAlignment','left',...   
        'Position',[0.05 0.557185 0.333962 0.04],'Style','text',...
        'String','INTEGRATION PARAMETERS','Tag','StaticText1');
   %Label: "ODE Function"
   uicontrol('Parent',a,'Units','normalized','FontSize', FontSize,...
        'BackgroundColor',[0.513725 0.6 0.694118],'Style','text',...
        'HorizontalAlignment','left',...   
        'Position',[0.05 0.5 0.15 0.04],...
        'String','ODE Function :','Tag','StaticText2');
   %Label: "Integration Method" 
   uicontrol('Parent',a,'Units','normalized','FontSize', FontSize, ...
        'BackgroundColor',[0.513725 0.6 0.694118],'Style','text',...
        'Position',[0.05 0.44 0.186 0.04],...
        'HorizontalAlignment','left',...   
        'String','Integration Method :','Tag','StaticText3');

   %Label: "Initial Time"
   uicontrol('Parent',a,'Units','normalized','FontSize', FontSize,...
        'BackgroundColor',[0.513725 0.6 0.694118],'Style','text',...
        'HorizontalAlignment','left',...   
        'Position',[0.05 0.377 0.115 0.04], ...
        'String','Initial Time :','Tag','StaticText4');
   %Label: "Final Time"
   uicontrol('Parent',a,'Units','normalized','FontSize', FontSize,...
        'BackgroundColor',[0.513725 0.6 0.694118],'Style','text',...
        'HorizontalAlignment','left',...   
        'Position',[0.05 0.32 0.113 0.04], ...
        'String','Final Time :','Tag','StaticText5');
   %Label "Time Step"
   uicontrol('Parent',a,'Units','normalized','FontSize', FontSize,...
	     'BackgroundColor',[0.513725 0.6 0.694118],'Style','text',...
        'HorizontalAlignment','left',...   
        'Position',[0.05 0.27 0.11 0.04], ...
        'String','Time Step :','Tag','StaticText6');
   %Label: "Relative Tolerance"
   uicontrol('Parent',a,'Style','text','Units','normalized','FontSize', FontSize, ...
        'HorizontalAlignment','left',...   
        'BackgroundColor',[0.513725 0.6 0.694118],'String','Relative Tolerance :', ...
        'Position',[0.05 0.21 0.18 0.04],'Tag','StaticText7');
   %Label: "Absolution Tolerance"
   uicontrol('Parent',a,'Units','normalized','FontSize', FontSize,...
	     'BackgroundColor',[0.513725 0.6 0.694118],'Style','text',...
        'HorizontalAlignment','left',...   
        'String','Absolute Tolerance :','Tag','StaticText8',...
        'Position',[0.05 0.154 0.18 0.04]);
   %Label: "Initial Conditions"
   uicontrol('Parent',a,'Units','normalized','FontSize', FontSize,...
        'BackgroundColor',[0.513725 0.6 0.694118],'Style','text',...
        'HorizontalAlignment','left',...   
        'Position',[0.05 0.095 0.18 0.04],...
        'String','Initial Condition(s) :','Tag','StaticText9');
   %Edit box for "ODE Function"
   odeEdt=uicontrol('Parent',a,'Units','normalized','Style','edit',...
        'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 1],'Tag','EditText2', ...
        'Position',[0.2 0.5 0.2 0.055],'FontSize', FontSize,'String',odeFunction);
   %Edit box for "Final Time"
   ftEdt=uicontrol('Parent',a,'Units','normalized','Tag','EditText4','FontSize', FontSize, ...
        'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 1],'Style','edit',...
        'Position',[0.166 0.325513 0.234 0.05],'String',num2str(DATA(8)));
   %Edit box for "Time Step"
   tsEdt=uicontrol('Parent',a,'Units','normalized','Tag','EditText5','FontSize', FontSize, ...
        'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 1],'Style','edit', ...
        'Position',[0.166 0.272727 0.234 0.05],'String',num2str(DATA(9)));
   %Edit box for "Relative Tolerance"
   rtolEdt=uicontrol('Parent',a,'Units','normalized','Tag','EditText6','FontSize', FontSize,...
        'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 1],'Style','edit',...
        'Position',[0.25 0.214076 0.15 0.05],'String',num2str(DATA(10)));
   %Edit box for "Absolute Tolerance"
   atolEdt=uicontrol('Parent',a,'Units','normalized','Tag','EditText7','FontSize', FontSize,...
        'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 1],'Style','edit',...
        'Position',[0.25 0.158358 0.15 0.05],'String',num2str(DATA(11)));
     
   %Pop-up menu for "Integration method"
   Methods=char('Discrete map', 'ODE45','ODE23','ODE113','ODE23S','ODE15S');
   intPop=uicontrol('Parent',a,'Units','normalized','FontSize', FontSize,...
        'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 1],'Value',DATA(6),...
        'Position',[0.25 0.43 0.15 0.0557185],'Tag','PopupMenu1',...
        'String',Methods,'Style','popupmenu',...
        'callback','setting(''changeMethod'')');
   
   %Edit box for "Initial Time"
   itEdt=uicontrol('Parent',a,'Units','normalized','Tag','EditText3','FontSize', FontSize,...
        'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 1],'Style','edit',...
        'Position',[0.166 0.381232 0.234 0.05],'String',num2str(DATA(7)));
   %Edit Box for "Initial Coniditions"
   if length(DATA)>=19
   	icStr=num2str(DATA(19:length(DATA)));
   else
   	icStr='';
   end
   icEdt=uicontrol('Parent',a,'Units','normalized','Tag','EditText1',...
        'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 1],'Style','edit',...
        'Position',[0.25 0.1 0.74 0.055],'String',icStr,'FontSize', FontSize);
        
        
   %Label: "PLOTTING OPTIONS"
   uicontrol('Parent',a,'Units','normalized','Tag','StaticText12',...
        'BackgroundColor',[0.513725 0.6 0.694118],'Style','text',...
        'FontWeight','bold','String','PLOTTING OPTIONS',...
        'HorizontalAlignment','left',...   
        'Position',[0.5 0.909091 0.24 0.0498534],'FontSize', FontSize);
    %Radio button: "Update the plot imediately"
   PlotImedRadio=uicontrol('Parent',a,'Units','normalized', ...
        'BackgroundColor',[0.513725 0.6 0.694118], ...
        'FontSize', FontSize,'Position',[0.5 0.835777 0.28 0.058], ...
        'HorizontalAlignment','left',...   
        'String','Update the plot immediately','Callback','setting(1)', ...
        'Style','radiobutton','Tag','Radiobutton1','Value',DATA(12));
   %Radio button: "Update the plot every"
   PlotStepRadio=uicontrol('Parent',a,'Units','normalized', ...
        'BackgroundColor',[0.513725 0.6 0.694118],'FontSize', FontSize,...
        'Position',[0.5 0.75 0.23 0.058],'Value',DATA(13),...
        'HorizontalAlignment','left',...   
        'String','Update the plot every','Callback','setting(2)',...
        'Style','radiobutton','Tag','Radiobutton2');
   %Edit box: no. of iterations for updating the plot
   PlotStepEdt=uicontrol('Parent',a,'Units','normalized','FontSize', FontSize,...
        'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 1], ...
        'Position',[0.74 0.75 0.1 0.052],'String',num2str(DATA(14)),...
        'Style','Edit','Tag','EditText15');
   %Label: "iterations"
   uicontrol('Parent',a,'Units','normalized','FontSize', FontSize,'Style','text',...
        'BackgroundColor',[0.513725 0.6 0.694118],'String','iterations',...
        'HorizontalAlignment','left',...   
        'Position',[0.87 0.73 0.12 0.058],'Tag','StaticText22');

   %Label: "Line Color"
   uicontrol('Parent',a,'Units','normalized','FontSize', FontSize,'Tag','StaticText16',...
        'BackgroundColor',[0.513725 0.6 0.694118],'Style','text', ...
        'HorizontalAlignment','left',...   
        'Position',[0.5 0.65 0.12 0.0498534],'String','Line Color :');
   %HandlesList(19) is the handle of "Line Color" pop-up menu
   c=DATA(15);
   %Look-up tables for background and foreground colors
   Back='bkgrymc';
   Fore='wwkwkwk';
   Background=Back(c);
   Foreground=Fore(c);
   colorPop=uicontrol('Parent',a,'Units','normalized','Style','popupmenu',...
        'BackgroundColor',Background,'ForegroundColor',Foreground,'FontSize', FontSize,...
        'Position',[0.64 0.656891 0.125 0.0527859],'Value',DATA(15),...
        'String',char('Blue','Black','Green','Red','Yellow','Magenta','Cyan'), ...
        'Tag','PopupMenu4','Callback','setting(''ChangeColor'')');
   %Label: "X-Axis Label"
   uicontrol('Parent',a,'Units','normalized','FontSize', FontSize,...
        'BackgroundColor',[0.513725 0.6 0.694118], ...
        'HorizontalAlignment','left',...   
        'Position',[0.5 0.565 0.134 0.0469208], ...
        'String','X-Axis Label :','Style','text','Tag','StaticText17');
   %Lable: "Y-Axis Label"
   uicontrol('Parent',a,'Units','normalized', ...
        'HorizontalAlignment','left',...   
        'BackgroundColor',[0.513725 0.6 0.694118], ...
        'FontSize', FontSize,'Position',[0.5 0.5 0.134 0.0498534], ...
        'String','Y-Axis Label :','Style','text','Tag','StaticText18');
   %Edit box for "X-Axis Label"
   xlabel=get(get(AxesHandle,'xlabel'),'String');
   xlabelEdt=uicontrol('Parent',a,'Units','normalized',...
        'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 1], ...
        'Position',[0.64 0.571848 0.35 0.058651],'FontSize', FontSize, ...
        'String',xlabel,'Style','edit','Tag','EditText10');
   %Edit box for "Y-Axis Label"
   ylabel=get(get(AxesHandle,'ylabel'),'String');
   ylabelEdt=uicontrol('Parent',a,'Units','normalized', ...
        'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 1], ...
        'Position',[0.64 0.510264 0.35 0.058651],'FontSize', FontSize, ...
        'String',ylabel,'Style','edit','Tag','EditText11');
   %Label: "Title"
   uicontrol('Parent',a,'Units','normalized', ...
        'BackgroundColor',[0.513725 0.6 0.694118], ...
        'HorizontalAlignment','left',...   
        'FontSize', FontSize,'Position',[0.5 0.425 0.0641509 0.05], ...
        'String','Title :','Style','text','Tag','StaticText19');
   %Edit box for "Title"
	Title=get(get(AxesHandle,'title'),'String');
	titleEdt=uicontrol('Parent',a,'Units','normalized','FontSize', FontSize, ...
        'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 1], ...
        'Position',[0.57 0.435 0.42 0.058651], ...
        'Style','edit','String',Title,'Tag','EditText12');

   %Label: "ITERATION PARAMETERS"
   uicontrol('Parent',a,'Units','normalized','FontSize', FontSize,...
        'BackgroundColor',[0.513725 0.6 0.694118],'FontWeight','bold',...
        'HorizontalAlignment','left',...   
        'Position',[0.5 0.34 0.3 0.0469208],'Style','text',...
        'String','ITERATION PARAMETERS','Tag','StaticText13');
  %Label: "No. of transient iterations to be discarded ..."
   Str=['No. of transient iterations to be', sprintf('\n'),...
        'discarded before calculation :'];
   uicontrol('Parent',a,'Units','normalized', ...
        'BackgroundColor',[0.513725 0.6 0.694118], ...
        'HorizontalAlignment','left',...   
        'FontSize', FontSize,'Position',[0.5 0.24 0.3 0.08], ...
        'String',Str,'Style','text','Tag','StaticText20');
   %Edit box for "No. of transient iterations to be discarded ..."
   discardEdt=uicontrol('Parent',a,'Units','normalized', ...
        'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 1], ...
        'Position',[0.8 0.265 0.12 0.05],'FontSize', FontSize, ...
        'String',num2str(DATA(16)),'Style','edit','Tag','EditText13');

   %Label: "Update the Lyapunov exponents every"
   pos=[0.5 0.16 0.2 0.08];
   Str=['Update the Lyapunov',sprintf('\n'), 'exponent(s) every '];
   uicontrol('Parent',a,'Units','normalized','FontSize', FontSize,...
        'HorizontalAlignment','left',...   
        'BackgroundColor',[0.513725 0.6 0.694118],'Style','text',...
        'Position',pos,'Tag','StaticText14','String',Str);

   %Edit box for updating step
   pos=[0.72 0.185 0.12 0.05];
   upEdt=uicontrol('Parent',a,'Units','normalized','Tag','EditText9','FontSize', FontSize, ...
        'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 1],'Style','edit',...
        'Position',pos,'String',num2str(DATA(17)));
   %Label: "time step(s)"
   pos=[0.86 0.175 0.12 0.05];
   uicontrol('Parent',a,'Units','normalized','Tag','StaticText15',...
        'HorizontalAlignment','left',...   
        'BackgroundColor',[0.513725 0.6 0.694118],'Style','text', ...
        'FontSize', FontSize,'Position',pos,'String','time step(s)');

   %Label: "No. of linearized ODEs "
   uicontrol('Parent',a,'Units','normalized','Tag','StaticText21',...
       'BackgroundColor',[0.513725 0.6 0.694118], ...
       'HorizontalAlignment','left',...   
       'FontSize', FontSize,'Position',[0.05 0.015 0.23 0.05], ...
       'String','No. of linearized ODEs :','Style','text');
   %Edit box for "No. of linearized"
   if length(DATA)>=18
      linStr=num2str(DATA(18));
   else
      linStr='';
   end
   linEdt=uicontrol('Parent',a,'Units','normalized', ...
      'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 1], ...
      'Position',[0.3 0.03 0.1 0.05],'FontSize', FontSize, ...
      'Style','edit','String',linStr,'Tag','EditText14');
   %"OK" pushbutton
   okBtn=uicontrol('Parent',a,'Units','normalized', ...
        'FontSize', FontSize,'FontWeight','bold','Position',[0.5 0.02 0.1 0.065],'String','OK',...
        'CallBack','setting(''checking'')','Tag','Pushbutton1');
   %"Help" pushbutton
   cancelBtn=uicontrol('Parent',a,'Units','normalized', ...
        'FontSize', FontSize,'FontWeight','bold','String','Cancel',...
        'Position',[0.65 0.02 0.1 0.065],'Callback','close(gcf)','Tag','Pushbutton2');
   %"Help" pushbutton
   helpBtn=uicontrol('Parent',a,'Units','normalized','FontSize', FontSize,...
        'FontWeight','bold','String','Help','Position',[0.8 0.02 0.1 0.065],...
        'Callback','setting(''help'')','Tag','Pushbutton3');

   %If "Integration method" is "discrete map", fix the time step to 1 
   %and initial time to 0, disable the "Absolute Tolerance" and 
   %"Relative Tolerance" edit boxes
   IntMethod=DATA(6);
   if IntMethod==1
      set(tsEdt,'String','1','Enable','off');
      set(itEdt,'String','0','Enable','off');
      set([atolEdt,rtolEdt],'String','0','Enable','off');
   end
   
   %Store the handles of the main window in 'UserData' of 
   %the "OK" button in the setting window
   set(okBtn,'UserData',MainHandles);

   %Store all the handles of the setting window in 'UserData' of the window
   HandlesList=[opChk, opEdt, leChk, ldChk, lePop,...
               ldPop, odeEdt, ftEdt, tsEdt, rtolEdt,...
               atolEdt, intPop, itEdt, icEdt, PlotImedRadio,...
               PlotStepRadio, PlotStepEdt, upEdt, colorPop, xlabelEdt,...
               ylabelEdt, titleEdt, discardEdt, okBtn, cancelBtn,...
               helpBtn, linEdt];
   set(a,'UserData',HandlesList,'Visible','On');
   %Do not show any axis on the setting window
   set(gca,'visible','Off');
case {1,2}
   %One of the radio buttons was chosen
   %Uncheck the other one radio button
   %HandlesList(15) is the handle of radio button 1
   %HandlesList(16) is the handle of radio button 2

   if action==1
      %Radio button 1: "Update plot imediately" was chosen
      check(HandlesList(15),HandlesList(16));
   else
      %Radio button 2: "Update plot every ... iterations" was chosen
      check(HandlesList(16),HandlesList(15));
   end
case 'changecolor'
   %HandlesList(19) is the handle of "Line Color" pop-up menu
   c=get(HandlesList(19),'Value');
   %Look-up tables for background and foreground colors
   Back='bkgrymc';	Fore='wwkwkwk';
   set(HandlesList(19),'BackgroundColor',Back(c),'ForegroundColor',Fore(c));
case 'changemethod'
   %HandlesList(12) is the handle of "Integration Method" pop-up menu
   %HandlesList(9) is the handle of "Time Step" edit box
   %HandlesList(13) is the handle of "Initial Time" edit box
   %HandlesList(10) is the handle of "Relative Tolerance" edit box
   %HandlesList(11) is the handle of "Absolute Tolerance" edit box
   IntMethod=get(HandlesList(12),'Value');
   %If the user select "Discrete map", set the time step to 1 and initial time
   %to 0, and don't allow the user to change them.
   if IntMethod==1
      set(HandlesList(9),'String','1','Enable','off');
      set(HandlesList(13),'String','0','Enable','off');
      set([HandlesList(10),HandlesList(11)],'String','0','Enable','off');
   else
      set(HandlesList(9),'Enable','on');
      set(HandlesList(13),'Enable','on');
      set([HandlesList(10),HandlesList(11)],'String','1e-5','Enable','on');
   end
case 'checking'
   %Get the data input by the user and
   %then check the data
   checking(HandlesList);
case 'help'
   helpwin('sethelp','Setting Help Window');
otherwise
   error('Invalid switch!');
end

%------------------Subroutines----------------------------

function checking(HandlesList)
%CHECKING    Checks data input by the user and
%            stores the data if no erors are found.

%Get the data input by the user
OutputFile=get(HandlesList(2),'String');	%output file
xLabel=get(HandlesList(20),'String');		%X-Axis label
yLabel=get(HandlesList(21),'String');		%Y-Axis label
Title=get(HandlesList(22),'String');		%Title
output=get(HandlesList(1),'Value');             %Output checkbox: on/off
LEout=get(HandlesList(3),'Value');              %Checkbox: "Lyapunov Exponents"
LDout=get(HandlesList(4),'Value');              %Checkbox: "Lyapunov Dimension"
LEprecision=get(HandlesList(5),'Value');	%Precision of LEs
LDprecision=get(HandlesList(6),'Value');        %Precsion of Lyapunov Dimension
ODEfunction=get(HandlesList(7),'String');	%ODE function
IntMethod=get(HandlesList(12),'Value');         %Integration method

InitialTime=str2num(get(HandlesList(13),'String'));	%Initial time
FinalTime=str2num(get(HandlesList(8),'String'));	%Final time
TimeStep=str2num(get(HandlesList(9),'String'));		%Time step
RelTol=str2num(get(HandlesList(10),'String'));		%Relative tolerance
AbsTol=str2num(get(HandlesList(11),'String'));		%Absolute tolerance
ic=str2num(get(HandlesList(14),'String'));              %Initial coniditions
linODEnum=str2num(get(HandlesList(27),'String'));       %No. of linearized ODEs 
   
%PLOTTING OPTIONS: 	
plot1=get(HandlesList(15),'Value');             %Plot imediately
plot2=get(HandlesList(16),'Value');             %Update the plot every ... iterations
ItrNum=str2num(get(HandlesList(17),'string'));	%Update every   ItrNum  iterations
  
%Line Colors
LineColor=get(HandlesList(19),'Value');		%Line color
   
%Transient iterations to be discarded
Discard=str2num(get(HandlesList(23),'String'));	
%Steps for updating the LEs
UpdateStep=str2num(get(HandlesList(18),'String'));
%One iteration
Iteration=UpdateStep*TimeStep;
%Min. time for one iteration
minT=Iteration*(Discard+1);
%Total number of iterations
TotalItr=fix(FinalTime/Iteration);
%Max. buffer size for storing the plotting data (10000 data)
buffersize=10000;
N=TotalItr-Discard;  
maxItr=min(N,buffersize);

%%%%%%%%%%%%%%%%
%   CHECKING
%%%%%%%%%%%%%%%%
%Remove spaces at the beginning and end
odefun=rmspace(ODEfunction);
OutputFile=rmspace(OutputFile);
%Dimension of the linearized ODE;
m=sqrt(linODEnum);
n=fix(m);
errCount=0;
Missing='';
if isempty(odefun)
   Missing=[sprintf(Missing) '"ODE function"' blanks(5)];
   errCount=errCount+1;
end
if ( output & isempty(OutputFile) )
   Missing=[sprintf(Missing) '"Output File"' blanks(5)];
   errCount=errCount+1;
end
if isempty(InitialTime)
   Missing=[sprintf(Missing) '"Initial Time"' blanks(5)];
   errCount=errCount+1;
end
if isempty(FinalTime)
   Missing=[sprintf(Missing) '"Final Time"' blanks(5)];
   errCount=errCount+1;
end
if isempty(TimeStep)
   Missing=[sprintf(Missing) '"Time Step"' blanks(5)];
   errCount=errCount+1;
end
if isempty(RelTol)
   Missing=[sprintf(Missing) '"Relative Tolerance"' blanks(5)];
   errCount=errCount+1;
end
if isempty(AbsTol)
   Missing=[sprintf(Missing) '"Absolute Tolerance"' blanks(5)];
   errCount=errCount+1;
end
if isempty(Discard)
   Missing=[sprintf(Missing) '"Iterations to be discarded"' blanks(5)];
   errCount=errCount+1;
end
if isempty(UpdateStep)
   Missing=[sprintf(Missing) '"LEs updating step size"' blanks(5)];
   errCount=errCount+1;
end
if isempty(ic)
   Missing=[sprintf(Missing) '"Initial condition(s)"' blanks(5)];
   errCount=errCount+1;
end
if isempty(linODEnum)
   Missing=[sprintf(Missing) '"No. of linearized ODEs"' blanks(5)];
   errCount=errCount+1;
end
if plot2 & isempty(ItrNum)
   Missing=[sprintf(Missing) '"No. of iterations for updating the plot"' blanks(2)];
   errCount=errCount+1;
elseif (plot1 & isempty(ItrNum))
   ItrNum=1;
end

if errCount>0
   if errCount>1
      isare='parameters are';
   else
	   isare='parameter is';
   end
   msg=['The following ' sprintf(isare) ' not specified or '...
        'not in correct format:' sprintf('\n\n') ...
         sprintf(Missing)];
   errordlg(msg,'ERROR','replace');
elseif exist(odefun)~=2
   msg=['Your ODE function ' '"' sprintf(odefun) '" '...
        'does not exist!'];
  errordlg(msg,'ERROR','replace');
elseif InitialTime>FinalTime
   msg='The initial time cannot be greater than the final time!';
   errordlg(msg,'ERROR','replace');
elseif InitialTime<0
   msg='Initial time cannot be negative!';
   errordlg(msg,'ERROR','replace');
elseif (FinalTime<=0 | TimeStep<=0)
   msg='Time step and final time cannot be zero or negative!';
   errordlg(msg,'ERROR','replace');
elseif ( IntMethod==1 & FinalTime~=round(FinalTime) )
   msg='For a discrete map, the final time must be an integer.';
   errordlg(msg,'ERROR','replace');
elseif TimeStep>(FinalTime-InitialTime)
   errordlg('The time step is too large!','ERROR','replace');
elseif m~=n
  	msg=['The number of linearized ODEs must be the square of'...
       ' an integer (i.e. 1, 4, 9, 16, 25, ..., n^2).'];
 	errordlg(msg,'ERROR','replace');
elseif ( Discard<0 | Discard~=round(Discard))
    msg='The number of discarded iteration(s) can only be a positive integer or zero.';
    errordlg(msg,'ERROR','replace');
elseif (UpdateStep<=0 | UpdateStep~=round(UpdateStep) )
    msg=['The number of step(s) for updating the Lyapunov exponents must'...
         ' be a positive integer.'];
    errordlg(msg,'ERROR','replace');
elseif (minT>FinalTime)
   msg=['The number of time step(s) for updating the Lyapunov exponents or'...
         ' the number of discarded transient iterations is too large.'];
   errordlg(msg,'ERROR','replace');
else
  	Q0=eye(m);
   IC=[ic(:);Q0(:)];
   if IntMethod>1
      commandStr=['f0=feval(odefun,InitialTime,IC);',...
            'problem=0;IClength=length(f0)-m*m;'];
   else
      commandStr=['f0=feval(odefun,IC);',...
            'problem=0;IClength=length(f0)-m*m;'];  
   end
         
   eval(commandStr,'problem=1;');

   if problem
      msg=['Problem in ODE function "' sprintf(odefun) '" or ',...
           'the no. of linearized ODEs you entered does not ',...
           'match with that in the ODE function!'];
      errordlg(msg,'ERROR','replace');
      eval(commandStr);
   elseif IClength<1
      msg=['No. of linearized ODEs you entered is more than '...
           'that in the ODE function "' sprintf(odefun) '".'];
      errordlg(msg,'ERROR','replace');
   elseif  length(f0)~=length(IC)
      msg=['Solving "' sprintf(odefun) '" requires ',...
      sprintf('an initial condition vector of length %d.',...
      IClength)];
      errordlg(msg,'ERROR','replace');
   elseif (plot2 & ItrNum<1 | ItrNum~=round(ItrNum))
      msg=['The number of iterations for updating the plot must be'...
       	  ' a positive integer.'];
      errordlg(msg,'ERROR','replace');
   elseif (plot2 & ItrNum>maxItr)
   	msg=['The number of iterations for updating the plot is too large.'...
            ' For your case, the maximum number is ' sprintf(num2str(maxItr)) '.'...
            ' If you do not want to change this number, you can reduce the'...
            ' number of discarded transient iterations or the number of time'...
         	' steps for updating the Lyapunov exponents.'];
      errordlg(msg,'ERROR','replace');
   else
      pass=1;
      if (output & exist(OutputFile)==2)
   		%If the output file has already existed, warn the user.
   		msg=['The file "' sprintf(OutputFile) '" has already existed.'...
        	'  Overwrite it?'];
     		decision=questdlg(msg,'Make a decision','Yes','No','Yes');
     		if strcmp(decision,'No'), pass=0; end
      end
        
      if pass
         %If no errors found, save the data and upload them onto the 
         %'UserData' of the "Setting" button on the main window
          DATA=[  output,       LEout, LEprecision,    LDout, LDprecision, ...
               IntMethod, InitialTime,   FinalTime, TimeStep, RelTol, ...
                  AbsTol,       plot1,       plot2,   ItrNum, LineColor, ...
                 Discard,  UpdateStep,   linODEnum,       ic];
         
        MainHandles=get(HandlesList(24),'UserData');
      	set(MainHandles(4),'UserData',DATA);
      
        %Upload the output file and ODE function names
        %onto the 'UserData' of the "Start" button
        NAMES=char(OutputFile,ODEfunction);
        set(MainHandles(2),'UserData',NAMES);
      	%Close the setting window
      	close(gcf);
      	%Label the axes and add a title with given strings
      	xlabel(xLabel);
      	ylabel(yLabel);
        title(Title);
        %Set axis ranges
        yRange=str2num(get(MainHandles(8),'String'));
        axis([InitialTime,FinalTime,yRange(1),yRange(2)]);
        set(MainHandles(7),'String',num2str([InitialTime,FinalTime]));
      end
   end
end	%End of CHECKING

%--------------------------------------------------------------------

function outStr=rmspace(inStr)
%RMSPACE    Function for removing the beginning and ending
%           spaces of a string
%				
%           OUTSTRING=RMSPACE(INSTRING) removes the spaces
%           at the beginning and end of the string INSTRING.

%           by Steve Wai Kam SIU, Feb. 23, 1998.

%Remove spaces at the end of the string
outStr=strcat(inStr);
%Delete spaces at the beginning of the string
if ~isempty(outStr)
   while isspace(outStr(1))
   	outStr=outStr(2:length(outStr));
   end
end

%-------------------------------------------------------------------
function check(checkList,uncheckList)

%CHECK	Check function for check box or radio button
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

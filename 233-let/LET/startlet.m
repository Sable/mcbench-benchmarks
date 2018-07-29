function startlet(action)
%STARTLET creates a GUI startup window
%
%        See also README, LETHELP, SETHELP, LET and SETTING

%        by Steve W. K. SIU, July 5, 1998.

if nargin<1
   action='Initialization';
else
   Handles=get(gcf,'UserData');
end
%Systems corresponding the demos list
demosList=char('Logistic map','Henon map','Duffing''s equation',...
          'Lorenz equation','Rossler equation','Van Der Pol equation',...
          'Stewart-McCumber model');
%ODE functions corresponding to the demos list
ODEfunList=char('logistic','henon','duffing','lorenzeq','rossler',...
           'vderpol', 'stewart');

switch action
case 'Initialization';
      %Font size for description text
      FontSize1=9;
      %Font size for other UI components
      FontSize2=8;
      
      %Default demo:
      defaultDemo=2;	% 1="Logistic map", 2="Henon map", etc
      
      defaultFile=strcat(ODEfunList(defaultDemo,:));
      %Text to be displayed in the list box
      DisplayStr=helptext(defaultFile);
      %FigPos=[0.1675,0.1950,0.6650,0.7033];
      FigPos=[0.1,0.15,0.75,0.75];
      menuFig = figure('Units','normalized','BackingStore','off', ...
      'Color',[0 0 1],'MenuBar','none','NumberTitle','off', ...
      'Position',FigPos,'Tag','startmenu',...
      'Name','Lyapunov Exponents Toolbox','Visible','off');
   
      %Create a background image
      a=[0:0.01:2.5];
      b=ones(50,1).*[0.51:0.01:1]';
      c=b*a;
      d=0.1*randn(220,length(a));
      IMG=[c;d];
      imagesc(IMG);
      axis off;
      axis equal;
      set(gca,'Units','Normalized','Position',[0,0,1,1]);
      %Create a header "Lyapunov Exponents Toolbox"
      xpos=0.5;
      ypos=0.96;
      h=text(xpos,ypos,'Lyapunov Exponents Toolbox','color','k','fontsize',18,...
           'Units','Normalized','HorizontalAlignment','center');
   
      uicontrol('Parent',menuFig,'Units','normalized', ...
		     'BackgroundColor',[1 1 1],'FontWeight','Bold',...
		     'FontSize',FontSize2,'Position',[0.06 0.84 0.48 0.055], ...
		     'String','Select a system for demonstration:', ...
           'Style','text','Tag','StaticText1');
   
      demosListPop= uicontrol('Parent',menuFig,'Units','normalized', ...
           'BackgroundColor',[1 1 1],'FontSize',FontSize2, ...
           'Position',[0.56 0.85 0.39 0.05],'Value',defaultDemo,...
           'callback','startlet(''changeDemo'')',...
           'String',demosList,'Style','popupmenu','Tag','PopupMenu1');
   
      %Always highlight the 1st row of the listbox
      CallbackStr='h=get(gcf,''UserData'');set(h(1),''Value'',1)';
		listBox= uicontrol('Parent',menuFig,'Units','Normalized','Tag','Listbox1',...
           'BackgroundColor',[1 1 1],'String',DisplayStr,'Value',1, ...
           'Position',[0.06,0.15,0.89,0.65],'Style','listbox',...
           'FontSize', FontSize1, 'callback',CallbackStr);
   
      demoPush=uicontrol('Parent',menuFig,'Units','normalized', ...
           'Position',[0.06 0.05 0.17 0.06],'FontSize',FontSize2,...
           'String','Start demo','Tag','Pushbutton1',...
           'callback','startlet(''demo'')','FontWeight','bold');
  
      letPush=uicontrol('Parent',menuFig,'Units','normalized',...
           'FontSize',FontSize2,'String','Run LET main program',...
           'Position',[0.27 0.05 0.29 0.06],'Tag','Pushbutton2',...
           'callback','let(''runLET'')','FontWeight','bold');
   
      infoPush=uicontrol('Parent',menuFig,'Units','normalized','FontWeight','bold',...
           'FontSize',FontSize2,'String','Information','Tag','Pushbutton3',...
           'Position',[0.6 0.05 0.16 0.06],'callback','startlet(''showInfo'')');
   
      exitPush=uicontrol('Parent',menuFig,'Units','normalized','FontWeight','bold',...
          'Position',[0.8 0.05 0.15 0.06],'callback','close(gcf)', ...
          'String','Exit','Tag','Pushbutton4','FontSize',FontSize2);
   
      %Uncover the figure
      set(menuFig,'visible','on');
      Handles=[listBox,demosListPop,letPush,infoPush,exitPush,h];
      set(menuFig,'UserData',Handles);
  case 'changeDemo'
      d=get(gcbo,'Value');
      %Display help text  
      helpfile=strcat(ODEfunList(d,:));
      DisplayStr=helptext(helpfile);  
      set(Handles(1),'String',DisplayStr);
  case 'demo'
      %Get the position of the selected demo
      d=get(Handles(2),'Value');
      system=strcat(demosList(d,:));
      ODEfun=strcat(ODEfunList(d,:));
      %Obtain the default parameters for the chosen system
      [DATA,AxisRange]=demoparm(system);
      %Start LET main program
      let('runLET',ODEfun,DATA,AxisRange);
      if d<3
         xlabel('Number of Iterations');
      else
         xlabel('Time (sec)');
      end
      title(system);
      %Display a message
      msg=['Press the "Start" button to calculate the Lyapunov'...
           ' exponent(s) and dimension of the ' sprintf(system) ' .'...
           ' Press the "Setting" button to change parameters.'...
           ' The calculation may take a very long time. You can'...
           ' interrupt the calculation any time by pressing the'...
           ' "Stop" button.'];
      msgbox(msg,'DEMONSTRATION');
  case 'showInfo'
  		helpwin('readme','Information');    
  otherwise
      error('Invalid input argument.')
 end
 
function HelpStr=helptext(helpFile)
%HELPTEXT  returns the help text of an M-file in string
%          array format.

HelpStr=help(helpFile);
CR=sprintf('\n');
CR_Pos = find(HelpStr==CR);
if CR_Pos
    ind=find(HelpStr == '|');
    HelpStr(ind) = '!';
    HelpStr(CR_Pos) = '|';
end

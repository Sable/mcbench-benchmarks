function PotentialFlow2DSim_GUI

%--------------------------------------------------------------------------
%PotentialFlowSim_GUI
%Version 1.00
%Created by Stepen
%Created 31 March 2011
%--------------------------------------------------------------------------
%PotentialFlowSim_GUI starts a GUI program for PotentialFlow2DSim.m
%--------------------------------------------------------------------------
%How to use PotentialFlowSim_GUI:
%Input your elementary potential flow in the 'Flow Control' panel to
%generate the quiver plot of your potential flow's velocity field. Use
%'PlotControl' panel to pan or zoom your plot. If your quiver plot looks
%poorly scaled, use 'Switch Plot' button to switch to quiver plot of
%velocity direction and contour plot of velocity magnitude to get better
%plot for your flow. If you want to save your velocity field data, use
%'Save' button.
%--------------------------------------------------------------------------

%CodeStart-----------------------------------------------------------------
%Preparing MATLAB environment
    close all
    clear all
%Declaring global variable
    ScreenSize=get(0,'ScreenSize');
    global x y u v un vn V
    elmnflow=zeros(0,5);
    elmnflowcount=0;
    indexview=1;
    xpos=0;
    ypos=0;
    zoomstate=1;
    resolution=10;
    plottype=1;
%Preparing GUI
    mainwindow=figure('Name','PotentialFlow2DSim',...
                      'NumberTitle','Off',...
                      'Menubar','none',...
                      'Resize','off',...
                      'Units','pixels',...
                      'Position',[0.5*(ScreenSize(3)-1000),...
                                  0.5*(ScreenSize(4)-600),...
                                  1000,600]);
    axes('Parent',mainwindow,...
         'Units','pixels',...
         'Position',[25,25,550,550]);
    uicontrol('Parent',mainwindow,...
              'Style','pushbutton',...
              'String','Switch Plot',...
              'Units','pixels',...
              'Position',[0.775 0.05 0.1 0.05],...
              'Callback',@switchplotfcn);
    uicontrol('Parent',mainwindow,...
              'Style','pushbutton',...
              'String','Save Data',...
              'Units','pixels',...
              'Position',[0.775 0.125 0.1 0.05],...
              'Callback',@savedatafcn);
    flowcontrolpanel=uipanel('Parent',mainwindow,...
                             'Title','FlowControl',...
                             'BackgroundColor',[0.8,0.8,0.8],...
                             'Units','pixels',...
                             'Position',[590,250,380,325]);
    uicontrol('Parent',flowcontrolpanel,...
              'Style','text',...
              'String','U:',...
              'HorizontalAlignment','left',...
              'BackgroundColor',[0.8,0.8,0.8],...
              'Units','pixels',...
              'Position',[30,275,25,20]);
    uedit=uicontrol('Parent',flowcontrolpanel,...
                    'Style','edit',...
                    'String','0',...
                    'Units','pixels',...
                    'Position',[55,275,40,25],...
                    'Callback',@updateplotfcn);
    uicontrol('Parent',flowcontrolpanel,...
              'Style','pushbutton',...
              'Units','pixels',...
              'Position',[95,288,20,12],...
              'Callback',@uplusfcn);
    uicontrol('Parent',flowcontrolpanel,...
              'Style','pushbutton',...
              'Units','pixels',...
              'Position',[95,275,20,12],...
              'Callback',@uminfcn);
    uicontrol('Parent',flowcontrolpanel,...
              'Style','text',...
              'String','V:',...
              'HorizontalAlignment','left',...
              'BackgroundColor',[0.8,0.8,0.8],...
              'Units','pixels',...
              'Position',[150,275,25,20]);
    vedit=uicontrol('Parent',flowcontrolpanel,...
                    'Style','edit',...
                    'String','0',...
                    'Units','pixels',...
                    'Position',[175,275,40,25],...
                    'Callback',@updateplotfcn);
    uicontrol('Parent',flowcontrolpanel,...
              'Style','pushbutton',...
              'Units','pixels',...
              'Position',[215,288,20,12],...
              'Callback',@vplusfcn);
    uicontrol('Parent',flowcontrolpanel,...
              'Style','pushbutton',...
              'Units','pixels',...
              'Position',[215,275,20,12],...
              'Callback',@vminfcn);
    uicontrol('Parent',flowcontrolpanel,...
              'Style','text',...
              'String','Elementary Flow',...
              'HorizontalAlignment','center',...
              'BackgroundColor',[0.8,0.8,0.8],...
              'Units','pixels',...
              'Position',[30,235,60,30]);
    uicontrol('Parent',flowcontrolpanel,...
              'Style','text',...
              'String','Strength',...
              'HorizontalAlignment','center',...
              'BackgroundColor',[0.8,0.8,0.8],...
              'Units','pixels',...
              'Position',[100,242.5,50,15]);
    uicontrol('Parent',flowcontrolpanel,...
              'Style','text',...
              'String','Center Location',...
              'HorizontalAlignment','center',...
              'BackgroundColor',[0.8,0.8,0.8],...
              'Units','pixels',...
              'Position',[160,242.5,120,15]);
    uicontrol('Parent',flowcontrolpanel,...
              'Style','text',...
              'String','Rotation',...
              'HorizontalAlignment','center',...
              'BackgroundColor',[0.8,0.8,0.8],...
              'Units','pixels',...
              'Position',[290,242.5,50,15]);
    moveelmnflowupbutton=uicontrol('Parent',flowcontrolpanel,...
                                   'Style','pushbutton',...
                                   'String','',...
                                   'HorizontalAlignment','center',...
                                   'Enable','off',...
                                   'Units','pixels',...
                                   'Position',[2,235,21,10],...
                                   'Callback',@moveelmnflowupfcn);
    moveelmnflowdownbutton=uicontrol('Parent',flowcontrolpanel,...
                                       'Style','pushbutton',...
                                       'String','',...
                                       'HorizontalAlignment','center',...
                                       'Enable','off',...
                                       'Units','pixels',...
                                       'Position',[2,25,21,10],...
                                       'Callback',@moveelmnflowdownfcn);
    uicontrol('Parent',flowcontrolpanel,...
              'Style','pushbutton',...
              'String','Add Elementary Flow',...
              'HorizontalAlignment','center',...
              'Units','pixels',...
              'Position',[250,5,120,20],...
              'Callback',@addelmnflowfcn);
    elmnindextext=zeros(8,1);
    elmnflowpopup=zeros(8,1);
    strengthedit=zeros(8,1);
    strengthplusbutton=zeros(8,1);
    strengthminbutton=zeros(8,1);
    xcedit=zeros(8,1);
    xcplusbutton=zeros(8,1);
    xcminbutton=zeros(8,1);
    ycedit=zeros(8,1);
    ycplusbutton=zeros(8,1);
    ycminbutton=zeros(8,1);
    selectcenterbutton=zeros(8,1);
    thetaedit=zeros(8,1);
    thetaplusbutton=zeros(8,1);
    thetaminbutton=zeros(8,1);
    rmvelmnflowbutton=zeros(8,1);
    for i=1:8
        elmnindextext(i)=uicontrol('Parent',flowcontrolpanel,...
                                   'Style','text',...
                                   'String','0',...
                                   'HorizontalAlignment','center',...
                                   'BackgroundColor',[0.8,0.8,0.8],...
                                   'Visible','off',...
                                   'Enable','on',...
                                   'Units','pixels',...
                                   'Position',[2,235-(i*25),21,20],...
                                   'Callback',@updateplotfcn);
        elmnflowpopup(i)=uicontrol('Parent',flowcontrolpanel,...
                                   'Style','popup',...
                                   'String',{'Source',...
                                             'Doublet',...
                                             'Vortex'},...
                                   'Enable','off',...
                                   'Units','pixels',...
                                   'Position',[30,235-(i*25),60,25],...
                                   'Callback',@updateplotfcn);
        strengthedit(i)=uicontrol('Parent',flowcontrolpanel,...
                                  'Style','edit',...
                                  'String','',...
                                  'Enable','off',...
                                  'Units','pixels',...
                                  'Position',[100,239-(i*25),30,20],...
                                  'Callback',@updateplotfcn);
        strengthplusbutton(i)=uicontrol('Parent',flowcontrolpanel,...
                                        'Style','pushbutton',...
                                        'String','',...
                                        'Enable','off',...
                                        'Units','pixels',...
                                        'Position',[130,249-(i*25),20,10]);
        strengthminbutton(i)=uicontrol('Parent',flowcontrolpanel,...
                                       'Style','pushbutton',...
                                       'String','',...
                                       'Enable','off',...
                                       'Units','pixels',...
                                       'Position',[130,239-(i*25),20,10]);
        xcedit(i)=uicontrol('Parent',flowcontrolpanel,...
                            'Style','edit',...
                            'String','',...
                            'Enable','off',...
                            'Units','pixels',...
                            'Position',[160,239-(i*25),30,20],...
                            'Callback',@updateplotfcn);
        xcplusbutton(i)=uicontrol('Parent',flowcontrolpanel,...
                                  'Style','pushbutton',...
                                  'String','',...
                                  'Enable','off',...
                                  'Units','pixels',...
                                  'Position',[190,249-(i*25),20,10]);
        xcminbutton(i)=uicontrol('Parent',flowcontrolpanel,...
                                 'Style','pushbutton',...
                                 'String','',...
                                 'Enable','off',...
                                 'Units','pixels',...
                                 'Position',[190,239-(i*25),20,10]);
        ycedit(i)=uicontrol('Parent',flowcontrolpanel,...
                            'Style','edit',...
                            'String','',...
                            'Enable','off',...
                            'Units','pixels',...
                            'Position',[215,239-(i*25),30,20],...
                            'Callback',@updateplotfcn);
        ycplusbutton(i)=uicontrol('Parent',flowcontrolpanel,...
                                  'Style','pushbutton',...
                                  'String','',...
                                  'Enable','off',...
                                  'Units','pixels',...
                                  'Position',[245,249-(i*25),20,10]);
        ycminbutton(i)=uicontrol('Parent',flowcontrolpanel,...
                                 'Style','pushbutton',...
                                 'String','',...
                                 'Enable','off',...
                                 'Units','pixels',...
                                 'Position',[245,239-(i*25),20,10]);
        selectcenterbutton(i)=uicontrol('Parent',flowcontrolpanel,...
                                        'Style','pushbutton',...
                                        'String','',...
                                        'Enable','off',...
                                        'Units','pixels',...
                                        'Position',[270,239-(i*25),10,20]);
        thetaedit(i)=uicontrol('Parent',flowcontrolpanel,...
                               'Style','edit',...
                               'String','',...
                               'Enable','off',...
                               'Units','pixels',...
                               'Position',[290,239-(i*25),30,20],...
                               'Callback',@updateplotfcn);
        thetaplusbutton(i)=uicontrol('Parent',flowcontrolpanel,...
                                     'Style','pushbutton',...
                                     'String','',...
                                     'Enable','off',...
                                     'Units','pixels',...
                                     'Position',[320,249-(i*25),20,10]);
        thetaminbutton(i)=uicontrol('Parent',flowcontrolpanel,...
                                    'Style','pushbutton',...
                                    'String','',...
                                    'Enable','off',...
                                    'Units','pixels',...
                                    'Position',[320,239-(i*25),20,10]);
        rmvelmnflowbutton(i)=uicontrol('Parent',flowcontrolpanel,...
                                       'Style','pushbutton',...
                                       'String','X',...
                                       'HorizontalAlignment','center',...
                                       'Enable','off',...
                                       'Units','pixels',...
                                       'Position',[350,239-(i*25),...
                                                   25,20]);
    end
    set(strengthplusbutton(1),'Callback',@strength1plusfcn)
    set(strengthplusbutton(2),'Callback',@strength2plusfcn)
    set(strengthplusbutton(3),'Callback',@strength3plusfcn)
    set(strengthplusbutton(4),'Callback',@strength4plusfcn)
    set(strengthplusbutton(5),'Callback',@strength5plusfcn)
    set(strengthplusbutton(6),'Callback',@strength6plusfcn)
    set(strengthplusbutton(7),'Callback',@strength7plusfcn)
    set(strengthplusbutton(8),'Callback',@strength8plusfcn)
    set(strengthminbutton(1),'Callback',@strength1minfcn)
    set(strengthminbutton(2),'Callback',@strength2minfcn)
    set(strengthminbutton(3),'Callback',@strength3minfcn)
    set(strengthminbutton(4),'Callback',@strength4minfcn)
    set(strengthminbutton(5),'Callback',@strength5minfcn)
    set(strengthminbutton(6),'Callback',@strength6minfcn)
    set(strengthminbutton(7),'Callback',@strength7minfcn)
    set(strengthminbutton(8),'Callback',@strength8minfcn)
    set(xcplusbutton(1),'Callback',@xc1plusfcn)
    set(xcplusbutton(2),'Callback',@xc2plusfcn)
    set(xcplusbutton(3),'Callback',@xc3plusfcn)
    set(xcplusbutton(4),'Callback',@xc4plusfcn)
    set(xcplusbutton(5),'Callback',@xc5plusfcn)
    set(xcplusbutton(6),'Callback',@xc6plusfcn)
    set(xcplusbutton(7),'Callback',@xc7plusfcn)
    set(xcplusbutton(8),'Callback',@xc8plusfcn)
    set(xcminbutton(1),'Callback',@xc1minfcn)
    set(xcminbutton(2),'Callback',@xc2minfcn)
    set(xcminbutton(3),'Callback',@xc3minfcn)
    set(xcminbutton(4),'Callback',@xc4minfcn)
    set(xcminbutton(5),'Callback',@xc5minfcn)
    set(xcminbutton(6),'Callback',@xc6minfcn)
    set(xcminbutton(7),'Callback',@xc7minfcn)
    set(xcminbutton(8),'Callback',@xc8minfcn)
    set(ycplusbutton(1),'Callback',@yc1plusfcn)
    set(ycplusbutton(2),'Callback',@yc2plusfcn)
    set(ycplusbutton(3),'Callback',@yc3plusfcn)
    set(ycplusbutton(4),'Callback',@yc4plusfcn)
    set(ycplusbutton(5),'Callback',@yc5plusfcn)
    set(ycplusbutton(6),'Callback',@yc6plusfcn)
    set(ycplusbutton(7),'Callback',@yc7plusfcn)
    set(ycplusbutton(8),'Callback',@yc8plusfcn)
    set(ycminbutton(1),'Callback',@yc1minfcn)
    set(ycminbutton(2),'Callback',@yc2minfcn)
    set(ycminbutton(3),'Callback',@yc3minfcn)
    set(ycminbutton(4),'Callback',@yc4minfcn)
    set(ycminbutton(5),'Callback',@yc5minfcn)
    set(ycminbutton(6),'Callback',@yc6minfcn)
    set(ycminbutton(7),'Callback',@yc7minfcn)
    set(ycminbutton(8),'Callback',@yc8minfcn)
    set(selectcenterbutton(1),'Callback',@selectcenter1fcn)
    set(selectcenterbutton(2),'Callback',@selectcenter2fcn)
    set(selectcenterbutton(3),'Callback',@selectcenter3fcn)
    set(selectcenterbutton(4),'Callback',@selectcenter4fcn)
    set(selectcenterbutton(5),'Callback',@selectcenter5fcn)
    set(selectcenterbutton(6),'Callback',@selectcenter6fcn)
    set(selectcenterbutton(7),'Callback',@selectcenter7fcn)
    set(selectcenterbutton(8),'Callback',@selectcenter8fcn)
    set(thetaplusbutton(1),'Callback',@theta1plusfcn)
    set(thetaplusbutton(2),'Callback',@theta2plusfcn)
    set(thetaplusbutton(3),'Callback',@theta3plusfcn)
    set(thetaplusbutton(4),'Callback',@theta4plusfcn)
    set(thetaplusbutton(5),'Callback',@theta5plusfcn)
    set(thetaplusbutton(6),'Callback',@theta6plusfcn)
    set(thetaplusbutton(7),'Callback',@theta7plusfcn)
    set(thetaplusbutton(8),'Callback',@theta8plusfcn)
    set(thetaminbutton(1),'Callback',@theta1minfcn)
    set(thetaminbutton(2),'Callback',@theta2minfcn)
    set(thetaminbutton(3),'Callback',@theta3minfcn)
    set(thetaminbutton(4),'Callback',@theta4minfcn)
    set(thetaminbutton(5),'Callback',@theta5minfcn)
    set(thetaminbutton(6),'Callback',@theta6minfcn)
    set(thetaminbutton(7),'Callback',@theta7minfcn)
    set(thetaminbutton(8),'Callback',@theta8minfcn)
    set(rmvelmnflowbutton(1),'Callback',@rmvelmnflow1fcn)
    set(rmvelmnflowbutton(2),'Callback',@rmvelmnflow2fcn)
    set(rmvelmnflowbutton(3),'Callback',@rmvelmnflow3fcn)
    set(rmvelmnflowbutton(4),'Callback',@rmvelmnflow4fcn)
    set(rmvelmnflowbutton(5),'Callback',@rmvelmnflow5fcn)
    set(rmvelmnflowbutton(6),'Callback',@rmvelmnflow6fcn)
    set(rmvelmnflowbutton(7),'Callback',@rmvelmnflow7fcn)
    set(rmvelmnflowbutton(8),'Callback',@rmvelmnflow8fcn)
    flowvisualizationpanel=uipanel('Parent',mainwindow,...
                                   'Title','FlowVisualization',...
                                   'BackgroundColor',[0.8,0.8,0.8],...
                                   'Units','pixels',...
                                   'Position',[590,140,185,100]);
    uicontrol('Parent',flowvisualizationpanel,...
              'Style','pushbutton',...
              'String','Distribute particles',...
              'Units','pixels',...
              'Position',[42.5,10,100,20],...
              'Callback',@flowvisfcn)
    uicontrol('Parent',flowvisualizationpanel,...
              'Style','pushbutton',...
              'String','Place particles',...
              'Units','pixels',...
              'Position',[42.5,60,100,20],...
              'Callback',@flowviscustomfcn)
    plotcontrolpanel=uipanel('Parent',mainwindow,...
                             'Title','PlotControl',...
                             'BackgroundColor',[0.8,0.8,0.8],...
                             'Units','pixels',...
                             'Position',[785,140,185,100]);
    uicontrol('Parent',plotcontrolpanel,...
              'Style','pushbutton',...
              'String','+',...
              'Units','pixels',...
              'Position',[45 45 20 20],...
              'Callback',@increaseresolutionfcn);
    uicontrol('Parent',plotcontrolpanel,...
              'Style','pushbutton',...
              'String','-',...
              'Units','pixels',...
              'Position',[65 45 20 20],...
              'Callback',@decreaseresolutionfcn);
    uicontrol('Parent',plotcontrolpanel,...
              'Style','pushbutton',...
              'String','Left',...
              'Units','pixels',...
              'Position',[5 45 40 20],...
              'Callback',@panleftfcn);
    uicontrol('Parent',plotcontrolpanel,...
              'Style','pushbutton',...
              'String','Up',...
              'Units','pixels',...
              'Position',[45 65 40 20],...
              'Callback',@panupfcn);
    uicontrol('Parent',plotcontrolpanel,...
              'Style','pushbutton',...
              'String','Down',...
              'Units','pixels',...
              'Position',[45 25 40 20],...
              'Callback',@pandownfcn);
    uicontrol('Parent',plotcontrolpanel,...
              'Style','pushbutton',...
              'String','Right',...
              'Units','pixels',...
              'Position',[85 45 40 20],...
              'Callback',@panrightfcn);
    uicontrol('Parent',plotcontrolpanel,...
              'Style','pushbutton',...
              'String','Zoom in',...
              'Units','pixels',...
              'Position',[125 55 50 20],...
              'Callback',@zoominfcn);
    uicontrol('Parent',plotcontrolpanel,...
              'Style','pushbutton',...
              'String','Zoom out',...
              'Units','pixels',...
              'Position',[125 35 50 20],...
              'Callback',@zoomoutfcn);
    uicontrol('Parent',plotcontrolpanel,...
              'Style','pushbutton',...
              'String','Switch View',...
              'Units','pixels',...
              'Position',[15 5 155 20],...
              'Callback',@switchviewfcn);
    uicontrol('Parent',mainwindow',...
              'Style','pushbutton',...
              'String','Save Data',...
              'Units','pixels',...
              'Position',[590 100 380 25],...
              'Callback',@savedatafcn)
    uicontrol('Parent',mainwindow',...
              'Style','pushbutton',...
              'String','Save Plot',...
              'Units','pixels',...
              'Position',[590 75 380 25],...
              'Callback',@saveplotfcn)
    msgpanel=uipanel('Parent',mainwindow,...
                     'Title','Message Box',...
                     'BackgroundColor',[0.8,0.8,0.8],...
                     'Units','pixels',...
                     'Position',[590 25 380 40]);
    msgtext=uicontrol('Parent',msgpanel,...
                      'Style','text',...
                      'String',['Start creating your potential flow',...
                                ' by modifying FlowControl panel...'],...
                      'HorizontalAlignment','left',...
                      'BackgroundColor',[0.8,0.8,0.8],...
                      'Units','pixels',...
                      'Position',[5 5 370 15]);
%Listing local function
    %Start of updateplot
    function updateplot
        %Creating plot grid
        xmin=xpos-0.5*zoomstate;
        xmax=xpos+0.5*zoomstate;
        ymin=ypos-0.5*zoomstate;
        ymax=ypos+0.5*zoomstate;
        delta=zoomstate/resolution;
        [x,y]=meshgrid(xmin:delta:xmax,ymin:delta:ymax);
        x=round(x/delta)*delta;
        y=round(y/delta)*delta;
        %Reading flow properties
        readpanel;
        %Simulating flow
        [u,v,un,vn,V]=PotentialFlow2DSim(elmnflow,x,y);
        %Updating plot
        cla
        hold on
        if plottype==2
            contourf(x,y,V,20,'LineStyle','none')
        end
        if plottype==1
            quiver(x,y,u,v,'k')
        elseif plottype==2
            quiver(x,y,un,vn,'k')
        end
        axis equal
        axis ([xmin xmax ymin ymax])
        %Displaying message
        set(msgtext,'String','Plot updated!')
    end
    %End of updateplot
    %Start of readpanel
    function readpanel
        %Reading uniform flow panel
        elmnflow(1,1)=1;
        temp=str2double(get(uedit,'String'));
        if ~isnan(temp)
            elmnflow(1,2)=temp;
        end
        temp=str2double(get(vedit,'String'));
        if ~isnan(temp)
            elmnflow(1,3)=temp;
        end
        %Reading elementary flow data
        maxview=min(8,elmnflowcount);
        for panel=1:maxview
            for stat=1:5
                if stat==1
                    temp=get(elmnflowpopup(panel),'Value')+1;
                elseif stat==4
                    temp=str2double(get(strengthedit(panel),'String'));
                elseif stat==2
                    temp=str2double(get(xcedit(panel),'String'));
                elseif stat==3
                    temp=str2double(get(ycedit(panel),'String'));
                elseif stat==5
                    temp=str2double(get(thetaedit(panel),'String'));
                end
                if ~isnan(temp)
                    elmnflow(panel+indexview,stat)=temp;
                else
                    elmnflow(panel+indexview,stat)=0;
                end
            end
        end
    end
    %End of readpanel
    %Start of updatepanel
    function updatepanel
        %Updating uniform flow edit boxes
        set(uedit,'String',elmnflow(1,2))
        set(vedit,'String',elmnflow(1,3))
        %Updating view changer button
        if elmnflowcount<=8
            set(moveelmnflowupbutton,'Enable','off')
            set(moveelmnflowdownbutton,'Enable','off')
        else
            set(moveelmnflowupbutton,'Enable','on')
            set(moveelmnflowdownbutton,'Enable','on')
        end
        %Resetting elementary flow edit boxes
        set(elmnindextext,'Visible','off')
        set(elmnflowpopup,'Enable','off')
        set(strengthedit,'String','')
        set(strengthedit,'Enable','off')
        set(strengthplusbutton,'Enable','off')
        set(strengthminbutton,'Enable','off')
        set(xcedit,'String','')
        set(xcedit,'Enable','off')
        set(xcplusbutton,'Enable','off')
        set(xcminbutton,'Enable','off')
        set(ycedit,'String','')
        set(ycedit,'Enable','off')
        set(ycplusbutton,'Enable','off')
        set(ycminbutton,'Enable','off')
        set(selectcenterbutton,'Enable','off')
        set(thetaedit,'String','')
        set(thetaedit,'Enable','off')
        set(thetaplusbutton,'Enable','off')
        set(thetaminbutton,'Enable','off')
        set(rmvelmnflowbutton,'Enable','off')
        %Updating elementary flow edit boxes
        maxview=min(8,elmnflowcount);
        for panel=1:maxview
            set(elmnindextext(panel),'String',num2str(indexview+panel-1))
            set(elmnindextext(panel),'Visible','on')
            set(elmnflowpopup(panel),'Value',elmnflow(indexview+panel,1)-1)
            set(elmnflowpopup(panel),'Enable','on')
            set(strengthedit(panel),'String',elmnflow(indexview+panel,4))
            set(strengthedit(panel),'Enable','on')
            set(strengthplusbutton(panel),'Enable','on')
            set(strengthminbutton(panel),'Enable','on')
            set(xcedit(panel),'String',elmnflow(indexview+panel,2))
            set(xcedit(panel),'Enable','on')
            set(xcplusbutton(panel),'Enable','on')
            set(xcminbutton(panel),'Enable','on')
            set(ycedit(panel),'String',elmnflow(indexview+panel,3))
            set(ycedit(panel),'Enable','on')
            set(ycplusbutton(panel),'Enable','on')
            set(ycminbutton(panel),'Enable','on')
            set(selectcenterbutton(panel),'Enable','on')
            set(thetaedit(panel),'String',elmnflow(indexview+panel,5))
            set(thetaedit(panel),'Enable','on')
            set(thetaplusbutton(panel),'Enable','on')
            set(thetaminbutton(panel),'Enable','on')
            set(rmvelmnflowbutton(panel),'Enable','on')
        end
    end
    %End of updatepanel
%Listing callback function
    %Start of panleftfcn
    function panleftfcn(~,~)
        xpos=xpos-0.1*zoomstate;
        updateplot
    end
    %End of panleftfcn
    %Start of panupfcn
    function panupfcn(~,~)
        ypos=ypos+0.1*zoomstate;
        updateplot
    end
    %End of panupfcn
    %Start of pandownfcn
    function pandownfcn(~,~)
        ypos=ypos-0.1*zoomstate;
        updateplot
    end
    %End of pandownfcn
    %Start of panrightfcn
    function panrightfcn(~,~)
        xpos=xpos+0.1*zoomstate;
        updateplot
    end
    %End of panrightfcn
    %Start of zoominfcn
    function zoominfcn(~,~)
        zoomstate=zoomstate/2;
        updateplot
    end
    %End of zoominfcn
    %Start of zoomoutfcn
    function zoomoutfcn(~,~)
        zoomstate=zoomstate*2;
        updateplot
    end
    %End of zoomoutfcn
    %Start of increaseresolutionfcn
    function increaseresolutionfcn(~,~)
        resolution=resolution*2;
        updateplot
    end
    %End of increaseresolutionfcn
    %Start of decreaseresolutionfcn
    function decreaseresolutionfcn(~,~)
        resolution=resolution/2;
        updateplot
    end
    %End of decreaseresolutionfcn
    %Start of updateplotfcn
    function updateplotfcn(~,~)
        readpanel
        updateplot
    end
    %End of updateplotfcn
    %Start of moveelmnflowupfcn
    function moveelmnflowupfcn(~,~)
        if indexview>1
            indexview=indexview-1;
            updatepanel
        end
    end
    %End of moveelmnflowupfcn
    %Start of moveelmnflowdownfcn
    function moveelmnflowdownfcn(~,~)
        if indexview+7<elmnflowcount
            indexview=indexview+1;
            updatepanel
        end
    end
    %End of moveelmnflowdownfcn
    %Start of uplusfcn
    function uplusfcn(~,~)
        set(uedit,'String',num2str(str2double(get(uedit,'String'))+0.1))
        readpanel
        updateplot
    end
    %End of uplusfcn
    %Start of vplusfcn
    function vplusfcn(~,~)
        set(vedit,'String',num2str(str2double(get(vedit,'String'))+0.1))
        readpanel
        updateplot
    end
    %End of vplusfcn
    %Start of strengthplus1button
    function strength1plusfcn(~,~)
        set(strengthedit(1),...
            'String',...
            num2str(str2double(get(strengthedit(1),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of strengthplus1button
    %Start of strengthplus2button
    function strength2plusfcn(~,~)
        set(strengthedit(2),...
            'String',...
            num2str(str2double(get(strengthedit(2),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of strengthplus2button
    %Start of strengthplus3button
    function strength3plusfcn(~,~)
        set(strengthedit(3),...
            'String',...
            num2str(str2double(get(strengthedit(3),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of strengthplus3button
    %Start of strengthplus4button
    function strength4plusfcn(~,~)
        set(strengthedit(4),...
            'String',...
            num2str(str2double(get(strengthedit(4),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of strengthplus4button
    %Start of strengthplus5button
    function strength5plusfcn(~,~)
        set(strengthedit(5),...
            'String',...
            num2str(str2double(get(strengthedit(5),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of strengthplus5button
    %Start of strengthplus6button
    function strength6plusfcn(~,~)
        set(strengthedit(6),...
            'String',...
            num2str(str2double(get(strengthedit(6),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of strengthplus6button
    %Start of strengthplus7button
    function strength7plusfcn(~,~)
        set(strengthedit(7),...
            'String',...
            num2str(str2double(get(strengthedit(7),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of strengthplus7button
    %Start of strengthplus8button
    function strength8plusfcn(~,~)
        set(strengthedit(8),...
            'String',...
            num2str(str2double(get(strengthedit(8),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of strengthplus8button
    %Start of xc1plusfcn
    function xc1plusfcn(~,~)
        set(xcedit(1),...
            'String',num2str(str2double(get(xcedit(1),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of xc1plusfcn
    %Start of xc2plusfcn
    function xc2plusfcn(~,~)
        set(xcedit(2),...
            'String',num2str(str2double(get(xcedit(2),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of xc2plusfcn
    %Start of xc3plusfcn
    function xc3plusfcn(~,~)
        set(xcedit(3),...
            'String',num2str(str2double(get(xcedit(3),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of xc3plusfcn
    %Start of xc4plusfcn
    function xc4plusfcn(~,~)
        set(xcedit(4),...
            'String',num2str(str2double(get(xcedit(4),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of xc4plusfcn
    %Start of xc5plusfcn
    function xc5plusfcn(~,~)
        set(xcedit(5),...
            'String',num2str(str2double(get(xcedit(5),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of xc5plusfcn
    %Start of xc6plusfcn
    function xc6plusfcn(~,~)
        set(xcedit(6),...
            'String',num2str(str2double(get(xcedit(6),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of xc6plusfcn
    %Start of xc7plusfcn
    function xc7plusfcn(~,~)
        set(xcedit(7),...
            'String',num2str(str2double(get(xcedit(7),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of xc7plusfcn
    %Start of xc8plusfcn
    function xc8plusfcn(~,~)
        set(xcedit(8),...
            'String',num2str(str2double(get(xcedit(8),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of xc8plusfcn
    %Start of yc1plusfcn
    function yc1plusfcn(~,~)
        set(ycedit(1),...
            'String',num2str(str2double(get(ycedit(1),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of yc1plusfcn
    %Start of yc2plusfcn
    function yc2plusfcn(~,~)
        set(ycedit(2),...
            'String',num2str(str2double(get(ycedit(2),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of yc2plusfcn
    %Start of yc3plusfcn
    function yc3plusfcn(~,~)
        set(ycedit(3),...
            'String',num2str(str2double(get(ycedit(3),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of yc3plusfcn
    %Start of yc4plusfcn
    function yc4plusfcn(~,~)
        set(ycedit(4),...
            'String',num2str(str2double(get(ycedit(4),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of yc4plusfcn
    %Start of yc5plusfcn
    function yc5plusfcn(~,~)
        set(ycedit(5),...
            'String',num2str(str2double(get(ycedit(5),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of yc5plusfcn
    %Start of yc6plusfcn
    function yc6plusfcn(~,~)
        set(ycedit(6),...
            'String',num2str(str2double(get(ycedit(6),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of yc6plusfcn
    %Start of yc7plusfcn
    function yc7plusfcn(~,~)
        set(ycedit(7),...
            'String',num2str(str2double(get(ycedit(7),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of yc7plusfcn
    %Start of yc8plusfcn
    function yc8plusfcn(~,~)
        set(ycedit(8),...
            'String',num2str(str2double(get(ycedit(8),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of yc8plusfcn
    %Start of theta1plusfcn
    function theta1plusfcn(~,~)
        set(thetaedit(1),...
            'String',num2str(str2double(get(thetaedit(1),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of theta1plusfcn
    %Start of theta2plusfcn
    function theta2plusfcn(~,~)
        set(thetaedit(2),...
            'String',num2str(str2double(get(thetaedit(2),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of theta2plusfcn
    %Start of theta3plusfcn
    function theta3plusfcn(~,~)
        set(thetaedit(3),...
            'String',num2str(str2double(get(thetaedit(3),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of theta3plusfcn
    %Start of theta4plusfcn
    function theta4plusfcn(~,~)
        set(thetaedit(4),...
            'String',num2str(str2double(get(thetaedit(4),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of theta4plusfcn
    %Start of theta5plusfcn
    function theta5plusfcn(~,~)
        set(thetaedit(5),...
            'String',num2str(str2double(get(thetaedit(5),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of theta5plusfcn
    %Start of theta6plusfcn
    function theta6plusfcn(~,~)
        set(thetaedit(6),...
            'String',num2str(str2double(get(thetaedit(6),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of theta6plusfcn
    %Start of theta7plusfcn
    function theta7plusfcn(~,~)
        set(thetaedit(7),...
            'String',num2str(str2double(get(thetaedit(7),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of theta7plusfcn
    %Start of theta8plusfcn
    function theta8plusfcn(~,~)
        set(thetaedit(8),...
            'String',num2str(str2double(get(thetaedit(8),'String'))+0.1))
        readpanel
        updateplot
    end
    %End of theta8plusfcn
    %Start of uminfcn
    function uminfcn(~,~)
        set(uedit,'String',num2str(str2double(get(uedit,'String'))-0.1))
        readpanel
        updateplot
    end
    %End of uminfcn
    %Start of vminfcn
    function vminfcn(~,~)
        set(vedit,'String',num2str(str2double(get(vedit,'String'))-0.1))
        readpanel
        updateplot
    end
    %End of vminfcn
    %Start of strengthmin1button
    function strength1minfcn(~,~)
        set(strengthedit(1),...
            'String',...
            num2str(str2double(get(strengthedit(1),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of strengthmin1button
    %Start of strengthmin2button
    function strength2minfcn(~,~)
        set(strengthedit(2),...
            'String',...
            num2str(str2double(get(strengthedit(2),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of strengthmin2button
    %Start of strengthmin3button
    function strength3minfcn(~,~)
        set(strengthedit(3),...
            'String',...
            num2str(str2double(get(strengthedit(3),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of strengthmin3button
    %Start of strengthmin4button
    function strength4minfcn(~,~)
        set(strengthedit(4),...
            'String',...
            num2str(str2double(get(strengthedit(4),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of strengthmin4button
    %Start of strengthmin5button
    function strength5minfcn(~,~)
        set(strengthedit(5),...
            'String',...
            num2str(str2double(get(strengthedit(5),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of strengthmin5button
    %Start of strengthmin6button
    function strength6minfcn(~,~)
        set(strengthedit(6),...
            'String',...
            num2str(str2double(get(strengthedit(6),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of strengthmin6button
    %Start of strengthmin7button
    function strength7minfcn(~,~)
        set(strengthedit(7),...
            'String',...
            num2str(str2double(get(strengthedit(7),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of strengthmin7button
    %Start of strengthmin8button
    function strength8minfcn(~,~)
        set(strengthedit(8),...
            'String',...
            num2str(str2double(get(strengthedit(8),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of strengthmin8button
    %Start of xc1minfcn
    function xc1minfcn(~,~)
        set(xcedit(1),...
            'String',num2str(str2double(get(xcedit(1),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of xc1minfcn
    %Start of xc2minfcn
    function xc2minfcn(~,~)
        set(xcedit(2),...
            'String',num2str(str2double(get(xcedit(2),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of xc2minfcn
    %Start of xc3minfcn
    function xc3minfcn(~,~)
        set(xcedit(3),...
            'String',num2str(str2double(get(xcedit(3),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of xc3minfcn
    %Start of xc4minfcn
    function xc4minfcn(~,~)
        set(xcedit(4),...
            'String',num2str(str2double(get(xcedit(4),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of xc4minfcn
    %Start of xc5minfcn
    function xc5minfcn(~,~)
        set(xcedit(5),...
            'String',num2str(str2double(get(xcedit(5),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of xc5minfcn
    %Start of xc6minfcn
    function xc6minfcn(~,~)
        set(xcedit(6),...
            'String',num2str(str2double(get(xcedit(6),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of xc6minfcn
    %Start of xc7minfcn
    function xc7minfcn(~,~)
        set(xcedit(7),...
            'String',num2str(str2double(get(xcedit(7),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of xc7minfcn
    %Start of xc8minfcn
    function xc8minfcn(~,~)
        set(xcedit(8),...
            'String',num2str(str2double(get(xcedit(8),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of xc8minfcn
    %Start of yc1minfcn
    function yc1minfcn(~,~)
        set(ycedit(1),...
            'String',num2str(str2double(get(ycedit(1),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of yc1minfcn
    %Start of yc2minfcn
    function yc2minfcn(~,~)
        set(ycedit(2),...
            'String',num2str(str2double(get(ycedit(2),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of yc2minfcn
    %Start of yc3minfcn
    function yc3minfcn(~,~)
        set(ycedit(3),...
            'String',num2str(str2double(get(ycedit(3),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of yc3minfcn
    %Start of yc4minfcn
    function yc4minfcn(~,~)
        set(ycedit(4),...
            'String',num2str(str2double(get(ycedit(4),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of yc4minfcn
    %Start of yc5minfcn
    function yc5minfcn(~,~)
        set(ycedit(5),...
            'String',num2str(str2double(get(ycedit(5),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of yc5minfcn
    %Start of yc6minfcn
    function yc6minfcn(~,~)
        set(ycedit(6),...
            'String',num2str(str2double(get(ycedit(6),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of yc6minfcn
    %Start of yc7minfcn
    function yc7minfcn(~,~)
        set(ycedit(7),...
            'String',num2str(str2double(get(ycedit(7),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of yc7minfcn
    %Start of yc8minfcn
    function yc8minfcn(~,~)
        set(ycedit(8),...
            'String',num2str(str2double(get(ycedit(8),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of yc8minfcn
    %Start of theta1minfcn
    function theta1minfcn(~,~)
        set(thetaedit(1),...
            'String',num2str(str2double(get(thetaedit(1),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of theta1minfcn
    %Start of theta2minfcn
    function theta2minfcn(~,~)
        set(thetaedit(2),...
            'String',num2str(str2double(get(thetaedit(2),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of theta2minfcn
    %Start of theta3minfcn
    function theta3minfcn(~,~)
        set(thetaedit(3),...
            'String',num2str(str2double(get(thetaedit(3),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of theta3minfcn
    %Start of theta4minfcn
    function theta4minfcn(~,~)
        set(thetaedit(4),...
            'String',num2str(str2double(get(thetaedit(4),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of theta4minfcn
    %Start of theta5minfcn
    function theta5minfcn(~,~)
        set(thetaedit(5),...
            'String',num2str(str2double(get(thetaedit(5),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of theta5minfcn
    %Start of theta6minfcn
    function theta6minfcn(~,~)
        set(thetaedit(6),...
            'String',num2str(str2double(get(thetaedit(6),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of theta6minfcn
    %Start of theta7minfcn
    function theta7minfcn(~,~)
        set(thetaedit(7),...
            'String',num2str(str2double(get(thetaedit(7),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of theta7minfcn
    %Start of theta8minfcn
    function theta8minfcn(~,~)
        set(thetaedit(8),...
            'String',num2str(str2double(get(thetaedit(8),'String'))-0.1))
        readpanel
        updateplot
    end
    %End of theta8minfcn
    %Start of selectcenter1fcn
    function selectcenter1fcn(~,~)
        %Displaying message
        set(msgtext,...
            'String',['Select a point on plot to move',...
                     ' the center of elementary flow no 1 to...'])
        %Prompting user input
        [xp,yp]=getpts;
        %Applying changes
        set(xcedit(1),'String',num2str(xp(1)))
        set(ycedit(1),'String',num2str(yp(1)))
        %Updating plot
        readpanel
        updateplot
    end
    %End of selectcenter1fcn
    %Start of selectcenter2fcn
    function selectcenter2fcn(~,~)
        %Displaying message
        set(msgtext,...
            'String',['Select a point on plot to move',...
                     ' the center of elementary flow no 2 to...'])
        %Prompting user input
        [xp,yp]=getpts;
        %Applying changes
        set(xcedit(2),'String',num2str(xp(1)))
        set(ycedit(2),'String',num2str(yp(1)))
        %Updating plot
        readpanel
        updateplot
    end
    %End of selectcenter2fcn
    %Start of selectcenter3fcn
    function selectcenter3fcn(~,~)
        %Displaying message
        set(msgtext,...
            'String',['Select a point on plot to move',...
                     ' the center of elementary flow no 3 to...'])
        %Prompting user input
        [xp,yp]=getpts;
        %Applying changes
        set(xcedit(3),'String',num2str(xp(1)))
        set(ycedit(3),'String',num2str(yp(1)))
        %Updating plot
        readpanel
        updateplot
    end
    %End of selectcenter3fcn
    %Start of selectcenter4fcn
    function selectcenter4fcn(~,~)
        %Displaying message
        set(msgtext,...
            'String',['Select a point on plot to move',...
                     ' the center of elementary flow no 4 to...'])
        %Prompting user input
        [xp,yp]=getpts;
        %Applying changes
        set(xcedit(4),'String',num2str(xp(1)))
        set(ycedit(4),'String',num2str(yp(1)))
        %Updating plot
        readpanel
        updateplot
    end
    %End of selectcenter4fcn
    %Start of selectcenter5fcn
    function selectcenter5fcn(~,~)
        %Displaying message
        set(msgtext,...
            'String',['Select a point on plot to move',...
                     ' the center of elementary flow no 5 to...'])
        %Prompting user input
        [xp,yp]=getpts;
        %Applying changes
        set(xcedit(5),'String',num2str(xp(1)))
        set(ycedit(5),'String',num2str(yp(1)))
        %Updating plot
        readpanel
        updateplot
    end
    %End of selectcenter5fcn
    %Start of selectcenter6fcn
    function selectcenter6fcn(~,~)
        %Displaying message
        set(msgtext,...
            'String',['Select a point on plot to move',...
                     ' the center of elementary flow no 6 to...'])
        %Prompting user input
        [xp,yp]=getpts;
        %Applying changes
        set(xcedit(6),'String',num2str(xp(1)))
        set(ycedit(6),'String',num2str(yp(1)))
        %Updating plot
        readpanel
        updateplot
    end
    %End of selectcenter6fcn
    %Start of selectcenter7fcn
    function selectcenter7fcn(~,~)
        %Displaying message
        set(msgtext,...
            'String',['Select a point on plot to move',...
                     ' the center of elementary flow no 7 to...'])
        %Prompting user input
        [xp,yp]=getpts;
        %Applying changes
        set(xcedit(7),'String',num2str(xp(1)))
        set(ycedit(7),'String',num2str(yp(1)))
        %Updating plot
        readpanel
        updateplot
    end
    %End of selectcenter7fcn
    %Start of selectcenter8fcn
    function selectcenter8fcn(~,~)
        %Displaying message
        set(msgtext,...
            'String',['Select a point on plot to move',...
                     ' the center of elementary flow no 8 to...'])
        %Prompting user input
        [xp,yp]=getpts;
        %Applying changes
        set(xcedit(8),'String',num2str(xp(1)))
        set(ycedit(8),'String',num2str(yp(1)))
        %Updating plot
        readpanel
        updateplot
    end
    %End of selectcenter8fcn
    %Start of addelmnflowfcn
    function addelmnflowfcn(~,~)
        %Adding new elementary flow
        if elmnflowcount>=8
            indexview=elmnflowcount-6;
        end
        elmnflowcount=elmnflowcount+1;
        elmnflow(elmnflowcount+1,:)=[2,0,0,1,0];
        updatepanel
        updateplot
        %Displaying message
        set(msgtext,'String','New element flow has been added!')
    end
    %End of addelmndflowfcn
    %Start of rmvelmnflow1fcn
    function rmvelmnflow1fcn(~,~)
        %Deleting elementary flow
        elmnflowcount=elmnflowcount-1;
        elmnflow(indexview+1,:)=[];
        if (indexview+7>elmnflowcount)&&(indexview>1)
            indexview=indexview-1;
        end
        %Updating panel
        updatepanel
        updateplot
        %Displaying message
        set(msgtext,'String',['Elementary flow no ',...
                              num2str(indexview),...
                              ' deleted!'])
    end
    %End of rmvelmnflow1fcn
    %Start of rmvelmnflow2fcn
    function rmvelmnflow2fcn(~,~)
        %Deleting elementary flow
        elmnflowcount=elmnflowcount-1;
        elmnflow(indexview+2,:)=[];
        if (indexview+7>elmnflowcount)&&(indexview>1)
            indexview=indexview-1;
        end
        %Updating panel
        updatepanel
        updateplot
        %Displaying message
        set(msgtext,'String',['Elementary flow no ',...
                              num2str(indexview+1),...
                              ' deleted!'])
    end
    %End of rmvelmnflow2fcn
    %Start of rmvelmnflow3fcn
    function rmvelmnflow3fcn(~,~)
        %Deleting elementary flow
        elmnflowcount=elmnflowcount-1;
        elmnflow(indexview+3,:)=[];
        if (indexview+7>elmnflowcount)&&(indexview>1)
            indexview=indexview-1;
        end
        %Updating panel
        updatepanel
        updateplot
        %Displaying message
        set(msgtext,'String',['Elementary flow no ',...
                              num2str(indexview+2),...
                              ' deleted!'])
    end
    %End of rmvelmnflow3fcn
    %Start of rmvelmnflow4fcn
    function rmvelmnflow4fcn(~,~)
        %Deleting elementary flow
        elmnflowcount=elmnflowcount-1;
        elmnflow(indexview+4,:)=[];
        if (indexview+7>elmnflowcount)&&(indexview>1)
            indexview=indexview-1;
        end
        %Updating panel
        updatepanel
        updateplot
        %Displaying message
        set(msgtext,'String',['Elementary flow no ',...
                              num2str(indexview+3),...
                              ' deleted!'])
    end
    %End of rmvelmnflow4fcn
    %Start of rmvelmnflow5fcn
    function rmvelmnflow5fcn(~,~)
        %Deleting elementary flow
        elmnflowcount=elmnflowcount-1;
        elmnflow(indexview+5,:)=[];
        if (indexview+7>elmnflowcount)&&(indexview>1)
            indexview=indexview-1;
        end
        %Updating panel
        updatepanel
        updateplot
        %Displaying message
        set(msgtext,'String',['Elementary flow no ',...
                              num2str(indexview+4),...
                              ' deleted!'])
    end
    %End of rmvelmnflow5fcn
    %Start of rmvelmnflow6fcn
    function rmvelmnflow6fcn(~,~)
        %Deleting elementary flow
        elmnflowcount=elmnflowcount-1;
        elmnflow(indexview+6,:)=[];
        if (indexview+7>elmnflowcount)&&(indexview>1)
            indexview=indexview-1;
        end
        %Updating panel
        updatepanel
        updateplot
        %Displaying message
        set(msgtext,'String',['Elementary flow no ',...
                              num2str(indexview+5),...
                              ' deleted!'])
    end
    %End of rmvelmnflow6fcn
    %Start of rmvelmnflow7fcn
    function rmvelmnflow7fcn(~,~)
        %Deleting elementary flow
        elmnflowcount=elmnflowcount-1;
        elmnflow(indexview+7,:)=[];
        if (indexview+7>elmnflowcount)&&(indexview>1)
            indexview=indexview-1;
        end
        %Updating panel
        updatepanel
        updateplot
        %Displaying message
        set(msgtext,'String',['Elementary flow no ',...
                              num2str(indexview+6),...
                              ' deleted!'])
    end
    %End of rmvelmnflow7fcn
    %Start of rmvelmnflow8fcn
    function rmvelmnflow8fcn(~,~)
        %Deleting elementary flow
        elmnflowcount=elmnflowcount-1;
        elmnflow(indexview+8,:)=[];
        if (indexview+7>elmnflowcount)&&(indexview>1)
            indexview=indexview-1;
        end
        %Updating panel
        updatepanel
        updateplot
        %Displaying message
        set(msgtext,'String',['Elementary flow no ',...
                              num2str(indexview+7),...
                              ' deleted!'])
    end
    %End of rmvelmnflow8fcn
    %Start of flowvisfcn
    function flowvisfcn(~,~)
        xp=[x(:,1);x(:,end);x(1,:)';x(end,:)'];
        yp=[y(:,1);y(:,end);y(1,:)';y(end,:)'];
        %Initiating particle scatter
        pscatter=scatter(xp,yp,'filled','k');
        %Displaying message
        set(msgtext,'String','Performing flow visualization...')
        %Visualizing particle movement
        for timestep=1:1000
            %Finding particle speed
            up=interp2(x,y,u,xp,yp);
            vp=interp2(x,y,v,xp,yp);
            xp=xp+up*0.05*zoomstate;
            yp=yp+vp*0.05*zoomstate;
            %Deleting out-of-bounds particles
            xnan=find(isnan(xp));
            xp(xnan)=[];
            yp(xnan)=[];
            ynan=find(isnan(yp));
            xp(ynan)=[];
            yp(ynan)=[];
            %Deleting stagnation point particles
            stag=(up==0)&(vp==0);
            xp(stag)=[];
            yp(stag)=[];
            %Plotting particle movement
            set(pscatter,'XData',xp)
            set(pscatter,'YData',yp)
            pause(0.001)
            %Anticipating lost of all particles
            if isempty(xp)
                break
            end
        end
        clear pscatter
        %Displaying message
        set(msgtext,'String','Flow visualization finished!')
    end
    %End of flowvisfcn
    %Start of flowviscustomfcn
    function flowviscustomfcn(~,~)
        %Displaying message
        set(msgtext,...
            'String','Select multiple points on plot to place particle...')
        %Prompting user input
        [xp,yp]=getpts;
        %Initiating particle scatter
        pscatter=scatter(xp,yp,'filled','k');
        %Displaying message
        set(msgtext,'String','Performing flow visualization')
        %Visualizing particle movement
        for timestep=1:1000
            %Finding particle speed
            up=interp2(x,y,u,xp,yp);
            vp=interp2(x,y,v,xp,yp);
            xp=xp+up*0.01;
            yp=yp+vp*0.01;
            %Deleting out-of-bounds particles
            xnan=find(isnan(xp));
            xp(xnan)=[];
            yp(xnan)=[];
            ynan=find(isnan(yp));
            xp(ynan)=[];
            yp(ynan)=[];
            %Deleting stagnation point particles
            stag=(up==0)&(vp==0);
            xp(stag)=[];
            yp(stag)=[];
            %Plotting particle movement
            set(pscatter,'XData',xp)
            set(pscatter,'YData',yp)
            pause(0.001)
            %Anticipating lost of all particles
            if isempty(xp)
                break
            end
        end
        set(pscatter,'XData',[])
        set(pscatter,'YData',[])
        clear pscatter
        %Displaying message
        set(msgtext,'String','Flow visualization finished!')
    end
    %End of flowviscustomfcn
    %Start of switchviewfcn
    function switchviewfcn(~,~)
        %Switching view
        plottype=3-plottype;
        updateplot
        %Displaying message
        if plottype==1
            set(msgtext,'String','Switching to absolute plot!')
        else
            set(msgtext,'String','Switching to normalized plot!')
        end
    end
    %End of switchviewfcn
    %Start of savedatafcn
    function savedatafcn(~,~)
        %Saving plot data
        save('PotentialFlowSimData.mat','x','y','u','v','V');
        %Displaying message
        set(msgtext,'String',['Data successfully saved to',...
                              ' PotentialFlowSimData.mat!'])
    end
    %End of savedatafcn
    %Start of saveplotfcn
    function saveplotfcn(~,~)
        %Generating dummy axes
        tempfig=figure();
        tempaxes=axes('Parent',tempfig);
        readpanel
        updateplot
        %Saving plot figure
        saveas(tempaxes,'PotentialFlowSim.fig')
        %Deleting dummy axes
        close(tempfig)
        %Displaying message
        set(msgtext,'String',['Data successfully saved to',...
                              ' PotentialFlowSim.fig!'])
    end
    %End of saveplotfcn
%CodeEnd-------------------------------------------------------------------

end
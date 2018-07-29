function varargout = Airfoil_Analyzer(varargin)
% Airfoil_Analyzer M-file for Airfoil_Analyzer.fig
%      Airfoil_Analyzer, by itself, creates a new Airfoil_Analyzer or raises the existing
%      singleton*.
%
%      H = Airfoil_Analyzer returns the handle to a new Airfoil_Analyzer or the handle to
%      the existing singleton*.
%
%      Airfoil_Analyzer('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Airfoil_Analyzer.M with the given input arguments.
%
%      Airfoil_Analyzer('Property','Value',...) creates a new Airfoil_Analyzer or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Airfoil_Analyzer_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Airfoil_Analyzer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help Airfoil_Analyzer

% Last Modified by GUIDE v2.5 05-Nov-2006 04:21:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Airfoil_Analyzer_OpeningFcn, ...
                   'gui_OutputFcn',  @Airfoil_Analyzer_OutputFcn, ...
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


% --- Executes just before Airfoil_Analyzer is made visible.
function Airfoil_Analyzer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Airfoil_Analyzer (see VARARGIN)

% Choose default command line output for Airfoil_Analyzer
handles.output = hObject;

handles.folder=[pwd '\Airfoil_Coordinate_Files\NACA Airfoils\'];
d = dir([handles.folder '*.dat']);
aflist=char(d.name);
if isempty(aflist)==1
    set(handles.af_list,'String','Folder is Empty')
else
    set(handles.af_list,'String',aflist)
    set(handles.figure1,'Name',['Airfoil Analyzer' '     ( ' num2str(length(aflist)) ' - Aifoil Data Files in Current Folder )'])
end

handles.color=[0 0 1];

width=0.5:0.5:4;
i=get(handles.line_width,'Value');
handles.width=width(i);

LineStyle={'-','--',':','-.','none'};
i=get(handles.line_style,'Value');
handles.LineStyle=LineStyle(i);

Marker={'none','+','o','*','.','x','s','d','^','v','>','<','p','h'};
i=get(handles.marker,'Value');
handles.Marker=Marker(i);

axes(handles.axes2)
x=[0.05 0.32 0.7 0.8 0.95];
handles.sample=plot( x,zeros(size(x)),'Color',handles.color,'LineWidth',handles.width,...
    'LineStyle',char(handles.LineStyle),'Marker',char(handles.Marker) );

set(gca,'Xtick',[],'Color',[0.7255    0.7765    0.7843]);
set(gca,'Ytick',[]);
set(gca,'Ztick',[]);

axes(handles.axes1)
hh=plot(0,0,'r*');
set(gca,'XTick',[0:0.05:1]*100,'Color',[0.7255    0.7765    0.7843])
set(gca,'YTick',[-0.3:0.05:0.3]*100)
axis equal
axis([-0.01 1.01 -0.3 0.3]*100)
cla



grid on
box on

handles.count=0;

handles.name1='Airfoil 1';
handles.name2='Airfoil 2';
handles.name3='Airfoil 3';

handles.af=[];
handles.afcamber=[];
handles.maxThick=[];
handles.cusp=[];

handles.waschecked=0;
handles.waschecked_1=0;

handles.multi=1;
handles.lcircle_view=[-0.01 1.01 -0.3 0.3]*100;

handles.sizecount='min';

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Airfoil_Analyzer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on selection change in af_list.
function af_list_Callback(hObject, eventdata, handles)
% hObject    handle to af_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns af_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from af_list
handles = guidata(gcbo);
d = dir([ handles.folder '*.dat']);
aflist=char(d.name);

axes(handles.axes1)
if isempty(aflist)==1

else

    n=get(hObject,'Value');

    width=0.5:0.5:4;
    i=get(handles.line_width,'Value');
    handles.width=width(i);

    LineStyle={'-','--',':','-.','none'};
    i=get(handles.line_style,'Value');
    handles.LineStyle=LineStyle(i);

    Marker={'none','+','o','*','.','x','s','d','^','v','>','<','p','h'};
    i=get(handles.marker,'Value');
    handles.Marker=Marker(i);

    if get(handles.hold_on,'Value')==get(handles.hold_on,'Max')
        hold on
        handles.count=handles.count+1;
    else
        hold off
        handles.count=1;
    end

    if handles.count>3
        handles.legends=legend(handles.af([1 2 3]),char(handles.name1),char(handles.name2),char(handles.name3),...
            'Location','Best');
        set(handles.legends,'Color','w')

        msg=['Only 3 plots are allowed together         ';...
             '                                          ';...
             'Clear the existing and plot this Airfoil ?'];

        button = questdlg(msg,'Too many Airfoils in Plot Area','Ok','Cancel','Ok');
        handles.count=1;

        if msg~=0
            hold off
            handles.afcamber=[];
            handles.maxThick=[];
            handles.af=0;
            
        else
%             clc
            return
            
        end
              

    end

    handles.FileName=[handles.folder d(n).name];
    fid = fopen(handles.FileName, 'r');
    xycell = textscan(fid, '%f %f','headerlines', 1);
    xy=cell2mat(xycell);
    afname=textread(handles.FileName,'%s',1,'delimiter','\n');
    x=xy(:,1)*100;
    y=xy(:,2)*100;

    handles.af(handles.count)=plot( x,y,'Color',handles.color,'LineWidth',handles.width,...
        'LineStyle',char(handles.LineStyle),'Marker',char(handles.Marker) );
  


    switch handles.count
        case 1
            handles.name1=afname;
            handles.legends=legend(handles.af(1),char(handles.name1),'Location','Best');
            set(handles.legends,'Color','w')   
            textloc=28;
        case 2
            handles.name2=afname;
            handles.legends=legend(handles.af([1 2]),char(handles.name1),char(handles.name2),'Location','Best');
            set(handles.legends,'Color','w')        
            textloc=24;
        case 3
            handles.name3=afname;
            handles.legends=legend(handles.af([1 2 3]),char(handles.name1),char(handles.name2),char(handles.name3),...
                'Location','Best');
            set(handles.legends,'Color','w')
            textloc=20;
    end
    
      
    fclose(fid);

    indx1=1:min( find(x==min(x)) );
    indx2=min( find(x==min(x)) ):length(x);
    
    x1=x(indx1);
    y1=y(indx1);
    
    x2=x(indx2);
    y2=y(indx2);
    

    theta1=atan2( (y1(2)-y1(1) ),( x1(2)-x1(1) ) );
    theta2=atan2( (y2(end-1)-y2(end) ),( x2(end-1)-x2(end) ) ) ;
    
    if theta1<0
        theta1=theta1+2*pi;
    end

    if theta2<0
        theta2=theta2+2*pi;
    end
    
    cuspangle=(theta2-theta1)*180/pi;

  hold on

    handles.cusp_triangle(1)=plot([x1(1) x1(2) x2(end-1) x2(end)],[y1(1) y1(2) y2(end-1) y2(end)],'Color',fliplr(handles.color),'Marker','*','LineStyle','none'); 
    handles.cusp_triangle(2)=fill( [x1(1) x1(2) x2(end-1) x2(end)],[y1(1) y1(2) y2(end-1) y2(end)],1-handles.color);
    
    xvlim1=min([x1(1) x1(2) x2(end-1) x2(end)]) -0.2*( max([x1(1) x1(2) x2(end-1) x2(end)])-min([x1(1) x1(2) x2(end-1) x2(end)]) );
    xvlim2=max([x1(1) x1(2) x2(end-1) x2(end)]) +0.2*( max([x1(1) x1(2) x2(end-1) x2(end)])-min([x1(1) x1(2) x2(end-1) x2(end)]) );
    
    yvlim1=min([y1(1) y1(2) y2(end-1) y2(end)]) -2*( max([y1(1) y1(2) y2(end-1) y2(end)])-min([y1(1) y1(2) y2(end-1) y2(end)]) );
    yvlim2=max([y1(1) y1(2) y2(end-1) y2(end)]) +2*( max([y1(1) y1(2) y2(end-1) y2(end)])-min([y1(1) y1(2) y2(end-1) y2(end)]) );
    
    Xcentre=(xvlim1+xvlim2)/2;
    Ycentre=(yvlim1+yvlim2)/2;
    
    xspan=(yvlim2-yvlim1)/0.6;
    
    xvlim1=Xcentre-xspan/2;
    xvlim2=Xcentre+xspan/2;
    
    yvlim=1.5*max( abs([y1(1) y1(2) y2(end-1) y2(end)]) );
    
    handles.cusp_view=[xvlim1 xvlim2 yvlim1 yvlim2 ];
    
    handles.cusp_triangle(3)=text(Xcentre,0.8*yvlim2,['TE Cusp Angle = ' num2str(cuspangle) ' degree' ],...
        'FontSize',14,'BackgroundColor',[0.7255    0.7765    0.7843],'EdgeColor','k','Color',handles.color );
        
    X1=linspace( min( min(x1), min(x2) ), max( max(x1), max(x2) ),20);
    Y1=spline(x1,y1,X1);
    Y2=spline(x2,y2,X1);
    
    Thick=Y1-Y2;

    handles.maxThick(handles.count,1)=plot([X1(find(Thick==max(Thick))) X1(find(Thick==max(Thick)))] ,[Y1(find(Thick==max(Thick))) Y2(find(Thick==max(Thick)))],'Color',handles.color,'LineWidth',10,...
        'LineStyle','-');
    
    handles.maxThick(handles.count,2)=plot([X1(find(Thick==max(Thick))) X1(find(Thick==max(Thick)))] ,[Y2(find(Thick==max(Thick))) -(textloc-2) ],'Color',handles.color,'LineWidth',2,...
        'LineStyle','-');
    handles.maxThick(handles.count,3)=text( 0.6*X1(find(Thick==max(Thick))),-textloc,['Max Thick = ' num2str(max(Thick)) ' % of C  at x = ' num2str( X1(find(Thick==max(Thick))) ) ' % of C'],...
        'FontSize',14,'BackgroundColor',[0.7255    0.7765    0.7843],'EdgeColor','k','Color',handles.color);

    Y1=(Y1+Y2)/2;

    if max(Y1)==0
        handles.afcamber(handles.count,1)=text( 35,textloc,'Camber = 0 ( Symmetric Airfoil )','FontSize',14,...
            'BackgroundColor',[0.7255    0.7765    0.7843],'EdgeColor','k','Color',handles.color );
        handles.afcamber(handles.count,[2,3])=0;
    else
        handles.afcamber(handles.count,1)=text( 0.5*X1( find(Y1==max(Y1)) ),textloc,['Camber = ' num2str(max(Y1)) ' % of C  at x = ' num2str( X1( find(Y1==max(Y1)) ) ) ' % of C'],...
            'FontSize',14,'BackgroundColor',[0.7255    0.7765    0.7843],'EdgeColor','k','Color',handles.color );
        
        handles.afcamber(handles.count,2)=plot([X1( find(Y1==max(Y1)) ) X1( find(Y1==max(Y1)) )] ,[0 max(Y1)],'Color',(handles.color),'LineWidth',4.5,...
        'LineStyle','-');
    
        handles.afcamber(handles.count,3)=plot([X1( find(Y1==max(Y1)) ) X1( find(Y1==max(Y1)) )] ,[max(Y1) (textloc-2)],'Color',(handles.color),'LineWidth',2,...
        'LineStyle','-');
    end
    
    handles.afcamber(handles.count,4)=plot(X1,Y1,'Color',(handles.color),'LineWidth',3,...
    'LineStyle','--');


    if get(handles.view_camber,'Value')==get(handles.view_camber,'Max')
        set(handles.afcamber,'Visible','on')
    else
        set(handles.afcamber,'Visible','off')
    end
    
    if get(handles.view_thick,'Value')==get(handles.view_thick,'Max')
        set(handles.maxThick,'Visible','on')
    else
        set(handles.maxThick,'Visible','off')
    end
    
        
    X=[ x1(end-1) x1(end) x2(2)];
    Y=[ y1(end-1) y1(end) y2(2)];
    circ=FitCircle(X,Y);
    
   
    if circ(1)>max(X)
        
    
        theta1=atan2( (Y(1)-circ(2) ),( X(1)-circ(1) ) );
        theta2=atan2( (Y(3)-circ(2) ),( X(3)-circ(1) ) );


        if theta1<0
            theta1=theta1+2*pi;
        end

        if theta2<0
            theta2=theta2+2*pi;
        end

        handles.lcircle(1)=plot([X circ(1)],[Y circ(2)],'Color',fliplr(handles.color),'Marker','*','LineStyle','none'); 
        handles.lcircle([2 3])=arrow2d([circ(1) circ(2)],[X(1) Y(1)],1-handles.color);
        handles.lcircle(4)=text( (X(1)+circ(1))/2,(Y(1)+circ(2))/2,['R = ' num2str(circ(3)) ' % of C'],...
            'FontSize',14,'BackgroundColor',[0.7255    0.7765    0.7843],'EdgeColor','k','Color',handles.color);

        theta=linspace(0,2*pi,35);

        xlc=circ(1)+circ(3)*cos(theta);
        ylc=circ(2)+circ(3)*sin(theta);

        handles.lcircle(5)=plot(xlc,ylc,'Linewidth',2,'Color',1-handles.color,'LineStyle','--');
        
               
        yvlim=[ min( min(1.5*ylc),circ(2) ) max( max(1.5*ylc),circ(2) ) ];
        
        xvlim2=( yvlim(2)-yvlim(1)+0.6*( circ(1)-2*circ(3) ) )/0.6;
        
        handles.lcircle_view=[circ(1)-2*circ(3) xvlim2 yvlim(1) yvlim(2) ];

    else
        handles.lcircle=text(1,max(y)+5,['Radius can not be calculated :                  ';...
                                   'The Coordinates are very sparse at Leading Edge '],...
                                   'FontSize',14,'BackgroundColor',[0.7255    0.7765    0.7843],'EdgeColor','k','Color',handles.color);
        handles.lcircle_view=[-0.01 1.01 -0.3 0.3]*100;
        
    end
                      
       
        
    if get(handles.hold_on,'Value')==get(handles.hold_on,'Max')
        hold on
    else
        hold off
    end

    if get(handles.axis_on,'Value')==get(handles.hold_on,'Max')
        axis on
    else
        axis off
    end

    if get(handles.grid_on,'Value')==get(handles.hold_on,'Max')
        grid on
    else
        grid off
    end

    
    if get(handles.view_af,'Value')==get(handles.view_af,'Max')
        set(handles.af(handles.count),'Visible','on')
    else
        set(handles.af(handles.count),'Visible','off')
    end
    
    if get(handles.view_thick,'Value')==get(handles.view_thick,'Max')
        set(handles.maxThick,'Visible','on')
    else
        set(handles.maxThick,'Visible','off')
    end
       
       
    if strcmp( get(handles.f_lcircle,'Checked'),'on')==1 & handles.multi==0
        set(handles.lcircle,'Visible','on')
        handles.waschecked=1;
    else
        set(handles.lcircle,'Visible','off')
        handles.waschecked=0;
    end
    
    if strcmp( get(handles.f_tecusp,'Checked'),'on')==1 & handles.multi==0
        set(handles.cusp_triangle,'Visible','on')
        handles.waschecked_1=1;
    else
        set(handles.cusp_triangle,'Visible','off')
        handles.waschecked_1=0;
    end

    set(gca,'Color',[0.7255    0.7765    0.7843])
    set(gca,'XTick',[0:0.05:1]*100)
    set(gca,'YTick',[-0.3:0.05:0.3]*100)
    axis equal
    axis([-0.01 1.01 -0.3 0.3]*100)
    
    if strcmp( get(handles.f_af,'Checked'),'on' )==1
                
        set(gca,'XTick',[0:0.05:1]*100)
        set(gca,'YTick',[-0.3:0.05:0.3]*100)
        axis equal
        axis([-0.01 1.01 -0.3 0.3]*100)
        
    elseif strcmp( get(handles.f_lcircle,'Checked'),'on' )==1

        axis(handles.lcircle_view)
        if handles.lcircle_view~=[-0.01 1.01 -0.3 0.3]*100;
            set(gca,'XTickMode','auto')
            set(gca,'YTickMode','auto')
        end
        zoom reset        
        
    else
        axis(handles.cusp_view)
        set(gca,'XTickMode','auto')
        set(gca,'YTickMode','auto')
        zoom reset
    end
    
    if get(handles.hold_on,'Value')~=get(handles.hold_on,'Max')
        set(handles.view_radius,'Enable','on')
        set(handles.view_cusp,'Enable','on')
        handles.multi=0;
    else
        handles.multi=1;
    end
       
end

if handles.multi==1
    set([handles.f_tecusp handles.f_lcircle],'Enable','off','Checked','off')
    set(handles.f_af,'Checked','on')
else
    set([handles.f_tecusp handles.f_lcircle],'Enable','on')
end

set(handles.clr,'Enable','on')
set(handles.hold_on,'Enable','on')

guidata(gcbo,handles)   


% --- Executes during object creation, after setting all properties.
function af_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to af_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in line_style.
function line_style_Callback(hObject, eventdata, handles)
% hObject    handle to line_style (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns line_style contents as cell array
%        contents{get(hObject,'Value')} returns selected item from line_style

handles=guidata(gcbo);

LineStyle={'-','--',':','-.','none'};
i=get(handles.line_style,'Value');
handles.LineStyle=LineStyle(i);
set( handles.sample,'LineStyle',char(handles.LineStyle) )

guidata(gcbo,handles)


% --- Executes during object creation, after setting all properties.
function line_style_CreateFcn(hObject, eventdata, handles)
% hObject    handle to line_style (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set_color.
function set_color_Callback(hObject, eventdata, handles)
% hObject    handle to set_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(gcbo);

color=uisetcolor();
if length(color)==3
    handles.color=color;
end

set(handles.sample,'Color',handles.color)

guidata(gcbo,handles)

% --- Executes on selection change in line_width.
function line_width_Callback(hObject, eventdata, handles)
% hObject    handle to line_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns line_width contents as cell array
%        contents{get(hObject,'Value')} returns selected item from line_width

handles=guidata(gcbo);

width=0.5:0.5:4;
i=get(handles.line_width,'Value');
handles.width=width(i);
set(handles.sample,'LineWidth',handles.width )

guidata(gcbo,handles)



% --- Executes during object creation, after setting all properties.
function line_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to line_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in marker.
function marker_Callback(hObject, eventdata, handles)
% hObject    handle to marker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns marker contents as cell array
%        contents{get(hObject,'Value')} returns selected item from marker

handles=guidata(gcbo);

Marker={'none','+','o','*','.','x','s','d','^','v','>','<','p','h'};
i=get(handles.marker,'Value');
handles.Marker=Marker(i);
set(handles.sample,'Marker',char(handles.Marker) )

guidata(gcbo,handles)

% --- Executes during object creation, after setting all properties.
function marker_CreateFcn(hObject, eventdata, handles)
% hObject    handle to marker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% TTTTTTTTTTTTTTTTTTT  ------ All the Tool Bar Button's Create Fcn's (Mapping image on the Buttons)

% --- Executes during object creation, after setting all properties.
function Tpan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tpan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    ccm - handles not created until after all CreateFcns called

handles = guidata(gcbo);
load alltools
set(hObject,'CData',Tpan1)
guidata(gcbo,handles)

% --- Executes during object creation, after setting all properties.
function Tpanzoom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tpanzoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    ccm - handles not created until after all CreateFcns called
handles = guidata(gcbo);
load alltools
set(hObject,'CData',Tpanzoom)
guidata(gcbo,handles)

% --- Executes during object creation, after setting all properties.
function Tdatacursor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tdatacursor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    ccm - handles not created until after all CreateFcns called
handles = guidata(gcbo);
load alltools
set(hObject,'CData',Tdatacursor)
guidata(gcbo,handles)


% --- Executes during object creation, after setting all properties.
function Tzoom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tzoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    ccm - handles not created until after all CreateFcns called
handles = guidata(gcbo);
load alltools
set(hObject,'CData',Tzoom)
guidata(gcbo,handles)

% TTTTTTTTTTTTTTTTTT Tool bar --- Executes during object creation, after setting all properties.
function Tfolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tfolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

handles = guidata(gcbo);
load alltools
set(hObject,'CData',Tfolder)
guidata(gcbo,handles)

% TTTTTTTTTTTTTTTTTT Tool bar --- Executes during object creation, after setting all properties.
function Author_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Author (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    ccm - handles not created until after all CreateFcns called
handles = guidata(gcbo);
load alltools
set(hObject,'CData',Banner)
guidata(gcbo,handles)


% --- Executes on button press in Tzoom.
function Tzoom_Callback(hObject, eventdata, handles)
% hObject    handle to Tzoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pan off
panzoom off
zoom;

% --- Executes on button press in Tpan.
function Tpan_Callback(hObject, eventdata, handles)
% hObject    handle to Tpan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom off
panzoom off
pan;

% --- Executes on button press in Tpanzoom.
function Tpanzoom_Callback(hObject, eventdata, handles)
% hObject    handle to Tpanzoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pan off
zoom off
panzoom;

% --- Executes on button press in Tdatacursor.
function Tdatacursor_Callback(hObject, eventdata, handles)
% hObject    handle to Tdatacursor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datacursormode;


% ####################### --------------- >>>>  Menu (File ->Exit)
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to file_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcbo);
delete(handles.figure1);
% clc
a=0;
save Extra.dat a
delete('Extra.dat')
clear
closereq
load alltools
msg=['  Please Review in mathworks.com or Send your Feedbacks to author   ';...
     '                                                                    ';...
     '     j.divahar@yahoo.com / j.divahar@gmail.com                      ';...
     '     HomePage: http://jdivahar.ipdz.com/                            '];
    

button = msgbox(msg,'Thank you For Trying !','custom',Tvanakam,Tcolormap);


% --- Executes on button press in authors_information.
function authors_information_Callback(hObject, eventdata, handles)
% hObject    handle to authors_information (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'Value')==get(hObject,'Max')
    set(handles.Author,'Visible','on')
else
    set(handles.Author,'Visible','off')
end



% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

web('about.htm','-helpbrowser')


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function focus_Callback(hObject, eventdata, handles)
% hObject    handle to focus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function f_af_Callback(hObject, eventdata, handles)
% hObject    handle to f_af (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles=guidata(gcbo);

if handles.af~=0
    
    set([ handles.f_lcircle handles.f_tecusp],'Checked','off')
    set([ handles.view_radius handles.view_cusp],'Value',0)
    set(handles.cusp_triangle,'Visible','off')
    set(handles.lcircle,'Visible','off')

    set(handles.f_af,'Checked','on')

    if handles.af~=0
        set(gca,'XTick',[0:0.05:1]*100,'Color',[0.7255    0.7765    0.7843])
        set(gca,'YTick',[-0.3:0.05:0.3]*100)
        axis equal
        axis([-0.01 1.01 -0.3 0.3]*100)
        zoom reset
    end
    
end
guidata(gcbo,handles)


% --------------------------------------------------------------------
function f_lcircle_Callback(hObject, eventdata, handles)
% hObject    handle to f_lcircle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=guidata(gcbo);
set([ handles.f_af handles.f_tecusp],'Checked','off')
set(handles.f_lcircle,'Checked','on')
   
if handles.af~=0
    
    set(handles.cusp_triangle,'Visible','off')
    set(handles.view_cusp,'Value',0)
    handles.waschecked_1=0;
    
    if handles.multi==0
        set(handles.view_radius,'Value',1)
        set(handles.lcircle,'Visible','on')
        handles.waschecked=1;
    end

    axis(handles.lcircle_view)
    if handles.lcircle_view~=[-0.01 1.01 -0.3 0.3]*100;
        set(gca,'XTickMode','auto')
        set(gca,'YTickMode','auto')
    end
    zoom reset
end

guidata(gcbo,handles)

% --------------------------------------------------------------------
function f_tecusp_Callback(hObject, eventdata, handles)
% hObject    handle to f_tecusp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=guidata(gcbo);
set([ handles.f_af handles.f_lcircle],'Checked','off')
set(handles.f_tecusp,'Checked','on')

if handles.af~=0
  
    set(handles.lcircle,'Visible','off')
    set(handles.view_radius,'Value',0)
    handles.waschecked=0;
    
    if handles.multi==0
        set(handles.view_cusp,'Value',1)
        set(handles.cusp_triangle,'Visible','on')
        handles.waschecked_1=1;
    end
    
    axis(handles.cusp_view)

    set(gca,'XTickMode','auto')
    set(gca,'YTickMode','auto')
    zoom reset
end
guidata(gcbo,handles)


% --- Executes on button press in view_af.
function view_af_Callback(hObject, eventdata, handles)
% hObject    handle to focus_af (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of focus_af

handles=guidata(gcbo);
if handles.af~=0
    if get(handles.view_af,'Value')==get(handles.view_af,'Max')
        set(handles.af,'Visible','on')
    else
        set(handles.af,'Visible','off')
    end
end
    
guidata(gcbo,handles)
    
% --- Executes on button press in focus_camber.
function view_camber_Callback(hObject, eventdata, handles)
% hObject    handle to focus_camber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of focus_camber

handles=guidata(gcbo);
% axes(handles.axes1)

if handles.af~=0
    if get(handles.view_camber,'Value')==get(handles.view_camber,'Max')
        set(handles.afcamber,'Visible','on')
    else
        set(handles.afcamber,'Visible','off')
    end
end
guidata(gcbo,handles)

% --- Executes on button press in focus_cusp.
function view_cusp_Callback(hObject, eventdata, handles)
% hObject    handle to focus_cusp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of focus_cusp
handles=guidata(gcbo);

if handles.af~=0
    if get(handles.view_cusp,'Value')==get(handles.view_cusp,'Max') 
        
        set(handles.lcircle,'Visible','off')
        set(handles.view_radius,'Value',0)
        handles.waschecked=0;
        
        set(handles.cusp_triangle,'Visible','on')
        handles.waschecked_1=1;
        
        set([ handles.f_af handles.f_lcircle],'Checked','off')
        set(handles.f_tecusp,'Checked','on')

        axis(handles.cusp_view)
        set(gca,'XTickMode','auto')
        set(gca,'YTickMode','auto')
        zoom reset
    else
        set(handles.cusp_triangle,'Visible','off')
        handles.waschecked_1=0;
        
        set([ handles.f_lcircle handles.f_tecusp],'Checked','off')
        set(handles.f_af,'Checked','on')

        set(gca,'XTick',[0:0.05:1]*100)
        set(gca,'YTick',[-0.3:0.05:0.3]*100)
        axis equal
        axis([-0.01 1.01 -0.3 0.3]*100)
        zoom reset        
        
    end
end

guidata(gcbo,handles)

% --- Executes on button press in focus_radius.
function view_radius_Callback(hObject, eventdata, handles)
% hObject    handle to focus_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of focus_radius

handles=guidata(gcbo);
if handles.af~=0
   
    if get(handles.view_radius,'Value')==get(handles.view_radius,'Max')
        
        set(handles.cusp_triangle,'Visible','off')
        set(handles.view_cusp,'Value',0)
        handles.waschecked_1=0;
        
        set(handles.lcircle,'Visible','on')
        handles.waschecked=1;
        
        set([ handles.f_af handles.f_tecusp],'Checked','off')
        set(handles.f_lcircle,'Checked','on')

        axis(handles.lcircle_view)
        if handles.lcircle_view~=[-0.01 1.01 -0.3 0.3]*100;
            set(gca,'XTickMode','auto')
            set(gca,'YTickMode','auto')
        end
        zoom reset
    else
        set(handles.lcircle,'Visible','off')
        handles.waschecked=0;
        
        set([ handles.f_lcircle handles.f_tecusp],'Checked','off')
        set(handles.f_af,'Checked','on')

        set(gca,'XTick',[0:0.05:1]*100)
        set(gca,'YTick',[-0.3:0.05:0.3]*100)
        axis equal
        axis([-0.01 1.01 -0.3 0.3]*100)
        zoom reset
    end
   
end




guidata(gcbo,handles)

% --- Executes on button press in Tfolder.
function Tfolder_Callback(hObject, eventdata, handles)
% hObject    handle to Tfolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(gcbo);

temp=[ uigetdir(handles.folder,'Change MATLAB Root Directory')];

if temp~=0
    set(handles.af_list,'Value',1)
    handles.folder=[temp '\'];
    ddir=handles.folder;
    if get(handles.hold_on,'Value')==get(handles.hold_on,'Min')
        legend off
        cla
    end
end

d = dir([handles.folder '*.dat']);

aflist=char(d.name);


% 
if isempty(aflist)==1
    set(handles.af_list,'String','Folder is Empty')
else
    set(handles.af_list,'String',char(d.name))
    set(handles.figure1,'Name',['Airfoil Analyzer' '     ( ' num2str(length(aflist)) ' - Aifoil Data Files in Current Folder )'])
end

if handles.multi~=1 & temp~=0
    set(handles.hold_on,'Enable','off')
    set(handles.clr,'Enable','off')
end

guidata(gcbo,handles)



% --- Executes on button press in hold_on.
function hold_on_Callback(hObject, eventdata, handles)
% hObject    handle to hold_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hold_on
handle=guidata(gcbo);

if handles.af~=0
    
    if get(handles.hold_on,'Value')==get(handles.hold_on,'Max')
        set(handles.view_radius,'Enable','off')
        set(handles.view_radius,'Value',0)
        handles.waschecked=1;
        set(handles.view_cusp,'Enable','off')
        set(handles.view_cusp,'Value',0)
        handles.waschecked_1=1;
        
    else
        handles.afcamber=[];
        handles.maxThick=[];
        handles.af=[];
        if handles.multi==0
            set(handles.view_radius,'Enable','on')
            set(handles.view_cusp,'Enable','on')
        end
        
        
    end

    set([ handles.f_lcircle handles.f_tecusp],'Checked','off')
    set(handles.f_af,'Checked','on')

    set(gca,'XTick',[0:0.05:1]*100)
    set(gca,'YTick',[-0.3:0.05:0.3]*100)
    axis equal
    axis([-0.01 1.01 -0.3 0.3]*100)
    zoom reset

    set([ handles.lcircle handles.cusp_triangle],'Visible','off')
end

        
guidata(gcbo,handles)

% --- Executes on button press in axis_on.
function axis_on_Callback(hObject, eventdata, handles)
% hObject    handle to axis_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of axis_on
handle=guidata(gcbo);

if get(handles.axis_on,'Value')==get(handles.axis_on,'Max')
    axis on
    set(handles.grid_on,'Enable','on')
else
    axis off
    set(handles.grid_on,'Enable','off')
end
    
guidata(gcbo,handles)



% --- Executes on button press in grid_on.
function grid_on_Callback(hObject, eventdata, handles)
% hObject    handle to grid_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of grid_on
handle=guidata(gcbo);

if get(handles.grid_on,'Value')==get(handles.grid_on,'Max')
    grid on
else
    grid off
end
    

guidata(gcbo,handles)


% --- Executes on button press in view_thick.
function view_thick_Callback(hObject, eventdata, handles)
% hObject    handle to view_thick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of view_thick

handles=guidata(gcbo);
% axes(handles.axes1)

if handles.af~=0
    if get(handles.view_thick,'Value')==get(handles.view_thick,'Max')
        set(handles.maxThick,'Visible','on')
    else
        set(handles.maxThick,'Visible','off')
    end
end
guidata(gcbo,handles)

% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(gcbo);

if handles.sizecount=='min'
    set(handles.Author,'Position',[74   219   873    70])
    
    handles.sizecount='max';
else
    set(handles.Author,'Position',[32   205   873    70])

    handles.sizecount='min';
end
guidata(gcbo, handles);


% --- Executes on button press in clr.
function clr_Callback(hObject, eventdata, handles)
% hObject    handle to clr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(gca,'Units','normalized')
tempsize=get(handles.figure1,'Position');
Airfoil_Analyzer
set(handles.figure1,'Position',tempsize)
set(handles.hold_on,'Enable','off')
set(handles.clr,'Enable','off')


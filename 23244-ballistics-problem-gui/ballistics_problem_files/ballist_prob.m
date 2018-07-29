function varargout = ballist_prob(varargin)
% BALLIST_PROB M-file for ballist_prob.fig
%      BALLIST_PROB, by itself, creates a new BALLIST_PROB or raises the existing
%      singleton*.
%
%      H = BALLIST_PROB returns the handle to a new BALLIST_PROB or the handle to
%      the existing singleton*.
%
%      BALLIST_PROB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BALLIST_PROB.M with the given input arguments.
%
%      BALLIST_PROB('Property','Value',...) creates a new BALLIST_PROB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ballist_prob_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ballist_prob_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ballist_prob

% Last Modified by GUIDE v2.5 09-Jul-2008 15:46:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ballist_prob_OpeningFcn, ...
                   'gui_OutputFcn',  @ballist_prob_OutputFcn, ...
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


% --- Executes just before ballist_prob is made visible.
function ballist_prob_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ballist_prob (see VARARGIN)

% Choose default command line output for ballist_prob
handles.output = hObject;

ax2pos=get(handles.axes2,'position');
ax2x=ax2pos(1);
ax2w=ax2pos(3);
alpos=get(handles.alpha,'position');
% text('position',[(alpos(1)-ax2x)/ax2w alpos(2)+alpos(4)/2],'string','\alpha = ',...
%     'parent',handles.axes2,'VerticalAlignment','middle','HorizontalAlignment','right',...
%     'units','normalized','FontUnits','normalized','FontSize',0.0286,'interpreter','tex');



htal=text('position',[(alpos(1)-ax2x)/ax2w alpos(2)+alpos(4)/2],'string','$\alpha =\;$',...
    'parent',handles.axes2,'VerticalAlignment','middle','HorizontalAlignment','right',...
    'units','normalized','interpreter','latex','FontSize',10);

%get(htal,'FontSize')
%get(handles.figure1,'position')

vpos=get(handles.v,'position');

htv=text('position',[(vpos(1)-ax2x)/ax2w vpos(2)+vpos(4)/2],'string','$|\overrightarrow{V_0}| =\;$',...
    'parent',handles.axes2,'VerticalAlignment','middle','HorizontalAlignment','right',...
    'units','normalized','interpreter','latex','FontSize',10);

afpos=get(handles.af,'position');

htfl=text('position',[0.5 afpos(2)-alpos(4)],'string','$\overrightarrow{F_{fr}}=-p(\overrightarrow{V})$',...
    'parent',handles.axes2,'VerticalAlignment','middle','HorizontalAlignment','center',...
    'units','normalized','interpreter','latex','FontSize',10);

vwpos=get(handles.vw,'position');

htvw=text('position',[(vwpos(1)-ax2x)/ax2w vwpos(2)+vwpos(4)/2],'string','$V_w =\;$',...
    'parent',handles.axes2,'VerticalAlignment','middle','HorizontalAlignment','right',...
    'units','normalized','interpreter','latex','FontSize',10);

fud={{htal,htv,htfl,htvw}};

set(handles.figure1,'UserData',fud);

set(htfl,'visible','off');
set(handles.text3,'visible','off');
set(handles.p,'visible','off');
set(handles.text4,'visible','off');
set(handles.text13,'visible','off');
set(handles.m,'visible','off');
set(handles.text14,'visible','off');
set(handles.aw,'visible','off');
set(htvw,'visible','off');
set(handles.vw,'visible','off');
set(handles.text5,'visible','off');
set(handles.text7,'visible','off');

set(handles.axes1,'NextPlot','add');

hbd=plot(0,0,'ob','parent',handles.axes1,'MarkerSize',7); %body



xlabel(handles.axes1,'x, m');
ylabel(handles.axes1,'y, m');

als=get(handles.alpha,'string');
if get(handles.rad,'value')
    al=str2num(als);
else
    al=pi*str2num(als)/180;
end
V=str2num(get(handles.v,'string'));
g=str2num(get(handles.g,'string'));

S=V^2*sin(2*al)/g;
H=V^2*(sin(al))^2/(2*g);
m=max([abs(H) abs(S)]);

if cos(al)>=0
    gr=plot([-m*0.2 m*1.2],[0 0],'-k','parent',handles.axes1);
    set(handles.axes1,'Xlim',[-m*0.1 m*1.1],'Ylim',[-m*0.1 m*1.1]);
else
    gr=plot([-m*1.2 m*0.2],[0 0],'-k','parent',handles.axes1);
    set(handles.axes1,'Xlim',[-m*1.1 m*0.1],'Ylim',[-m*0.1 m*1.1]);
end

pth=plot(0,0,'r-','parent',handles.axes1);
set(pth,'visible','off');

set(handles.axes1,'UserData',{hbd,gr,pth});

% set axes equal
set(handles.axes1,'DataAspectRatio',[1 1 1],'DataAspectRatioMode','manual',...
    'PlotBoxAspectRatio',[3 4 4],'PlotBoxAspectRatioMode','manual');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ballist_prob wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ballist_prob_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function alpha_Callback(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha as text
%        str2double(get(hObject,'String')) returns contents of alpha as a double


% --- Executes during object creation, after setting all properties.
function alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function V_Callback(hObject, eventdata, handles)
% hObject    handle to V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of V as text
%        str2double(get(hObject,'String')) returns contents of V as a double


% --- Executes during object creation, after setting all properties.
function V_CreateFcn(hObject, eventdata, handles)
% hObject    handle to V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in af.
function af_Callback(hObject, eventdata, handles)
fud=get(handles.figure1,'UserData');
ths=fud{1}; % latex text handles
htfl=ths{3};
htvw=ths{4};
if get(hObject,'Value')
    set(htfl,'visible','on');
    set(handles.text3,'visible','on');
    set(handles.p,'visible','on');
    set(handles.text4,'visible','on');
    set(handles.text13,'visible','on');
    set(handles.m,'visible','on');
    set(handles.text14,'visible','on');
    set(handles.aw,'visible','on');
    if get(handles.aw,'Value')
        set(htvw,'visible','on');
        set(handles.vw,'visible','on');
        set(handles.text5,'visible','on');
        set(handles.text7,'visible','on');
    end
else
    set(htfl,'visible','off');
    set(handles.text3,'visible','off');
    set(handles.p,'visible','off');
    set(handles.text4,'visible','off');
    set(handles.text13,'visible','off');
    set(handles.m,'visible','off');
    set(handles.text14,'visible','off');
    set(handles.aw,'visible','off');
    set(htvw,'visible','off');
    set(handles.vw,'visible','off');
    set(handles.text5,'visible','off');
    set(handles.text7,'visible','off');
end



function p_Callback(hObject, eventdata, handles)
% hObject    handle to p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p as text
%        str2double(get(hObject,'String')) returns contents of p as a double


% --- Executes during object creation, after setting all properties.
function p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in aw.
function aw_Callback(hObject, eventdata, handles)
fud=get(handles.figure1,'UserData');
ths=fud{1}; % latex text handles
htfl=ths{3};
htvw=ths{4};
if get(hObject,'Value')
    set(htvw,'visible','on');
    set(handles.vw,'visible','on');
    set(handles.text5,'visible','on');
    set(handles.text7,'visible','on');
    set(htfl,'string','$\overrightarrow{F_{fr}}=-p(\overrightarrow{V}-\overrightarrow{V_w})$');
else
    set(htvw,'visible','off');
    set(handles.vw,'visible','off');
    set(handles.text5,'visible','off');
    set(handles.text7,'visible','off');
    set(htfl,'string','$\overrightarrow{F_{fr}}=-p(\overrightarrow{V})$');
end



function vw_Callback(hObject, eventdata, handles)
% hObject    handle to vw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vw as text
%        str2double(get(hObject,'String')) returns contents of vw as a double


% --- Executes during object creation, after setting all properties.
function vw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rt.
function rt_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    set(handles.uipanel3,'visible','off');
    set(handles.text6,'visible','off');
    set(handles.ac,'visible','off');
    set(handles.text11,'visible','off');
    set(handles.tst,'visible','off');
    set(handles.text12,'visible','off');
else
    set(handles.uipanel3,'visible','on');
    set(handles.text6,'visible','on');
    set(handles.ac,'visible','on');
        set(handles.text11,'visible','on');
    set(handles.tst,'visible','on');
    set(handles.text12,'visible','on');
end



function ac_Callback(hObject, eventdata, handles)
% hObject    handle to ac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ac as text
%        str2double(get(hObject,'String')) returns contents of ac as a double


% --- Executes during object creation, after setting all properties.
function ac_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
set(hObject,'Enable','off');
ax1ud=get(handles.axes1,'UserData');
hbd=ax1ud{1};
gr=ax1ud{2};
pth=ax1ud{3};
if get(handles.ap,'value')
    set(pth,'visible','on');
else
    set(pth,'visible','off','Xdata',0,'Ydata',0);
end
als=get(handles.alpha,'string');
if get(handles.rad,'value')
    al=str2num(als);
else
    al=pi*str2num(als)/180;
end
V=str2num(get(handles.v,'string'));
g=str2num(get(handles.g,'string'));
vc=V*cos(al);
vs=V*sin(al);
x=0;
y=0;
vx=vc;
vy=vs;

S=V^2*sin(2*al)/g;
H=V^2*(sin(al))^2/(2*g);
m=max([abs(H) abs(S)]);



if cos(al)>=0
    set(handles.axes1,'Xlim',[-m*0.1 m*1.1],'Ylim',[-m*0.1 m*1.1]);
    set(gr,'Xdata',[-m*0.2 m*1.2]);
else
    set(handles.axes1,'Xlim',[-m*1.1 m*0.1],'Ylim',[-m*0.1 m*1.1]);
    set(gr,'Xdata',[-m*1.2 m*0.2]);
end
isaf=get(handles.af,'value');
if isaf
    p=str2num(get(handles.p,'string'));
    m=str2num(get(handles.m,'string'));
    if get(handles.aw,'value')
        vw=str2num(get(handles.vw,'string'));
        afx=@(v) -p*(v-vw)/m;
        afy=@(v) -p*(v)/m;
    else
        afx=@(v) -p*v/m;
        afy=@(v) -p*v/m;
    end
else
    afx=@(v) 0;
    afy=@(v) 0;
end


dt=1e-5;
tfl=2*vs/g; % fly time
tr=0; % real time 
% toc - is computer time
% preliminary calculation if wind for axes limits
maxx=0;
minx=0;
maxy=0;
if isaf&&get(handles.aw,'value')
    dt=tfl/50;
    while 1
        vx=vx+afx(vx)*dt;
        x=x+vx*dt;
        if x>maxx
            maxx=x;
        end
        if x<minx
            minx=x;
        end
        if y>maxy
            maxy=y;
        end
        vy=vy+(afy(vy)-g)*dt;
        y=y+vy*dt;
        if y<=0
            break
        end
        % tr=tr+dt;
        % dt=-(tr-ac*toc);
    end
    m=max([abs(H) abs(S)]);
    % set(handles.axes1,'Xlim',[-m*0.1 m*1.1],'Ylim',[-m*0.1 m*1.1]);
    xl=get(handles.axes1,'Xlim');
    yl=get(handles.axes1,'Ylim');
%     if minx<0
%         set(handles.axes1,'Xlim',[minx-m*0.1 xl(2)]);
%         set(gr,'Xdata',[minx-m*0.2 xl(2)+m*0.1]);
%     end
%     if maxx>xl(2)
%         set(handles.axes1,'Xlim',[xl(1) maxx+m*0.1]);
%         set(gr,'Xdata',[xl(1)-m*0.1 maxx+m*0.2]);
%     end
%     if maxy>yl(2)
%         set(handles.axes1,'Ylim',[yl(1) maxy+m*0.1]);
%     end

    if (minx<0)||(maxx>xl(2))||(maxy>yl(2))
        m=max([maxy maxx-minx yl(2) xl(2)-xl(1)]);
        mmaxx=max([maxx xl(2)]);
        mminx=min([minx xl(1)]);
        mmaxy=max([maxy yl(2)]);
        meanx=mean([mmaxx mminx]);
        set(handles.axes1,'Xlim',[meanx-0.7*m meanx+0.7*m]);
        set(gr,'Xdata',[meanx-0.8*m meanx+0.8*m]);
        set(handles.axes1,'Ylim',[-0.2*m 1.2*m]);
    end
    
    
    
end



%return to inital state
x=0;
y=0;
vx=vc;
vy=vs;
dt=1e-5;

set(hbd,'Xdata',x,'Ydata',y);
drawnow;

if sin(al)>0
    gap=get(handles.ap,'value');
    if gap
        xa=0;
        ya=0;
    end
    if get(handles.rt,'value')
        tic;
        while 1
            if isaf
                vx=vx+afx(vx)*dt;
            end
            x=x+vx*dt;
            vy=vy+(afy(vy)-g)*dt;
            y=y+vy*dt;
            set(hbd,'Xdata',x,'Ydata',y);
            if gap
                xa=[xa x];
                ya=[ya y];
                set(pth,'Xdata',xa,'Ydata',ya);
            end
            drawnow;
            if y<=0
                break
            end
            tr=tr+dt;
            dt=-(tr-toc);
            
            
            
        end
    else
        if get(handles.t,'value')
            ac=str2num(get(handles.ac,'string'));
            tic;
            while 1
                if isaf
                    vx=vx+afx(vx)*dt;
                end
                x=x+vx*dt;
                vy=vy+(afy(vy)-g)*dt;
                y=y+vy*dt;
                set(hbd,'Xdata',x,'Ydata',y);
                if gap
                    xa=[xa x];
                    ya=[ya y];
                    set(pth,'Xdata',xa,'Ydata',ya);
                end
                drawnow;
                if y<=0
                    break
                end
                tr=tr+dt;
                dt=-(tr-ac*toc);
            end
        else
            dt=str2num(get(handles.tst,'string'));
            while 1
                if isaf
                    vx=vx+afx(vx)*dt;
                end
                x=x+vx*dt;
                vy=vy+(afy(vy)-g)*dt;
                y=y+vy*dt;
                set(hbd,'Xdata',x,'Ydata',y);
                if gap
                    xa=[xa x];
                    ya=[ya y];
                    set(pth,'Xdata',xa,'Ydata',ya);
                end
                drawnow;
                if y<=0
                    break
                end
                % tr=tr+dt;
                % dt=-(tr-ac*toc);
            end
        end
    end

end

set(hObject,'Enable','on');
    


% --- Executes on button press in bw.
function bw_Callback(hObject, eventdata, handles)
% hObject    handle to bw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in fw.
function fw_Callback(hObject, eventdata, handles)
% hObject    handle to fw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
if isstruct(handles)
    fud=get(handles.figure1,'UserData');
    if iscell(fud) % at intializition of the gui fud can be empty
        ths=fud{1}; % latex text handles
        fdp=[223   148   767   562]; % figure default position
        for thsc=1:length(ths)
            fp=get(handles.figure1,'position');
            set(ths{thsc},'FontSize',10*fp(4)/fdp(4));
        end
    end
end





function v_Callback(hObject, eventdata, handles)
% hObject    handle to v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v as text
%        str2double(get(hObject,'String')) returns contents of v as a double


% --- Executes during object creation, after setting all properties.
function v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function g_Callback(hObject, eventdata, handles)
% hObject    handle to g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g as text
%        str2double(get(hObject,'String')) returns contents of g as a double


% --- Executes during object creation, after setting all properties.
function g_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --------------------------------------------------------------------
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
als=get(handles.alpha,'string');
al=str2num(als);
if get(handles.rad,'value')
    al=pi*al/180;
else
    al=180*al/pi;
end
set(handles.alpha,'string',num2str(al));




% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





function tst_Callback(hObject, eventdata, handles)
% hObject    handle to tst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tst as text
%        str2double(get(hObject,'String')) returns contents of tst as a double


% --- Executes during object creation, after setting all properties.
function tst_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --------------------------------------------------------------------
function uipanel3_SelectionChangeFcn(hObject, eventdata, handles)
c=[0.4 0.4 0.4];
if get(handles.t,'value')
    set(handles.text6,'ForegroundColor',[0 0 0]);
    set(handles.ac,'Enable','on');
    set(handles.text11,'ForegroundColor',c);
    set(handles.tst,'Enable','off');
    set(handles.text12,'ForegroundColor',c);
else
    set(handles.text6,'ForegroundColor',c);
    set(handles.ac,'Enable','off');
    set(handles.text11,'ForegroundColor',[0 0 0]);
    set(handles.tst,'Enable','on');
    set(handles.text12,'ForegroundColor',[0 0 0]);
end




function m_Callback(hObject, eventdata, handles)
% hObject    handle to m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m as text
%        str2double(get(hObject,'String')) returns contents of m as a double


% --- Executes during object creation, after setting all properties.
function m_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in ap.
function ap_Callback(hObject, eventdata, handles)
% hObject    handle to ap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ap



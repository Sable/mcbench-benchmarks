function varargout = HidroMatik(varargin)
% HIDROMATIK for calculation of hydrostatic and GZ curve for ship stability
%
%      Input data of ship can be input using Microsoft Excel
%      Line 1 = Main dimensions, [ LOA  LPP  B  H  T ]
%      Line 2 - end : [ z   y   x ]
%      Coloum 1 = z , station number
%      Coloum 2 = y , ordinate of bodyplan
%      Coloum 3 = x , abscess of bodyplan
%      
%      This is may a simple program, you can develop for detail.
%
%      Baharuddin Ali
%      Jl. Rambutan 106, Cerme, Grogol, Kediri, 64151 INDONESIA
%      + 62-354-777290, b4li313@yahoo.com

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HidroMatik_OpeningFcn, ...
                   'gui_OutputFcn',  @HidroMatik_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before HidroMatik is made visible.
function HidroMatik_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HidroMatik (see VARARGIN)

% Choose default command line output for HidroMatik
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HidroMatik wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HidroMatik_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbBodyplan.
function pbBodyplan_Callback(hObject, eventdata, handles)
% hObject    handle to pbBodyplan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb3D.
function pb3D_Callback(hObject, eventdata, handles)
% hObject    handle to pb3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pbHidros.
function pbHidros_Callback(hObject, eventdata, handles)
% hObject    handle to pbHidros (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pbProses.
function pbProses_Callback(hObject, eventdata, handles)
% hObject    handle to pbProses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global A UK KG Phideg GZ pilih

ttk   = A(2:end,1:3);
k     = diff(ttk(:,1));
k2    = find(k ~= 0);
k2(length(k2) +1)   = length(ttk);
JumST = length(k2);
z = ttk(:,1); y = ttk(:,2); x = ttk(:,3);
h = UK(2)/10; 
d1 = linspace(0.15*UK(5),UK(5),20);

popup_sel_index = get(handles.popProses, 'Value');
switch popup_sel_index
    case 1
        pilih = 1;
    case 2
        pilih = 2;
    case 3
        pilih = 3; 
end

if pilih == 3
    KG = str2double(get(handles.eKG,'string')); % isilah KG yang diinginkan
    if KG <= 0
        errordlg('KG SHOULD BE > 0','Warning');
        return
    end
    StabGZ;
end

for k=1:length(d1)
    d=d1(k);j=0;
    for i = 1: JumST
        x1 = x(find(z == z(k2(i)))); % mencari data tiap station
        y1 = y(find(z == z(k2(i))));
        z1 = z(find(z == z(k2(i))));
        %------------------------------ Gambar body plan -------
        if pilih == 1
            figure(1);
            if (z(k2(i)) <=5)
                plot(-x1,y1); hold on
            else
                plot(x1,y1); hold on
            end
        end
        %-------------------------------------------------------
        y2 = y1(find(y1 <= d));
        x2 = x1(find(y1 <= d));
        z2 = z1(find(y1 <= d));
    
        if length(y2) > 1  % hanya titik yang di bawah sarat
            if y2(end) == d
                x2 = x2; y2 = y2; z2= z2;
            else
                y1f=diff(y1);
                y1p=find(y1f==0);
                for p = 1:length(y1p)
                    y1(y1p(p)+1)=y1(y1p(p))+0.001;
                end
            
                xn = interp1(y1,x1,d);      
                x2(end+1) = xn;            
                y2(end+1) = d;
                z2(end+1) = z2(1);
            end
        
            if pilih == 1
                if (z2(1) <= 5)
                    plot(-x2,y2,'r'); hold on
                else
                    plot(x2,y2,'r'); hold on
                end
            end
        
            z3=z2;y3=y2;x3=x2;
        else
            z3=z1(i);y3=0;x3=0;
        end
        if pilih == 2 & length(y3) > 1 % hanya station yang punya dua titik atau lebih
            j=j+1;
            x31 = -sort(-x3);
            y31 = -sort(-y3);
            X   = [x31;-x3(2:end)];
            Y   = [y31;y3(2:end)];
     
            xa  = [-x3(end) x3(end) X'];
            ya  = [d d Y'];
            Area1   = TtkBerat( xa,ya );
            LuasST(j)  = Area1(1);
            KbST(j)    = Area1(3);
            PanjGirthST(j) = Area1(4)-( 2*x3(end) );
            NoST(j)    = z3(1);
            Xb(j)      = x3(end);
       
            %plot(xa,ya,Area1(2),Area1(3),'or');
        end
    end
    
    if pilih == 1
        axis equal
        plot([-max(x)*1.2,max(x)*1.2],[UK(5),UK(5)],'--r');
    elseif pilih == 2
        NXLP = [NoST',Xb',LuasST',PanjGirthST',KbST'];
        Bd      = 2*NXLP( find(NXLP(:,1)==5),2);          % Lebar midship 
        Amd     = NXLP( find(NXLP(:,1)==5),3);            % Luasan midship
        Vold    = trapz(NoST*h,LuasST);                   % Volume carene


        Displd  = 1.025 * Vold;                          % Displacement 
        Awld    = 2 * trapz(NoST*h,Xb);                  % Luasan WL
        TPCd    = 1.025*Awld/100;                        % TPC

        xNoST   = [NoST*h,-sort(-NoST(1:end-1)*h)];
        yXb     = [Xb,-Xb(end-1:-1:1)];
        xNoSTa  = [NoST(1)*h NoST(1)*h xNoST];
        yXba    = [-Xb(1) Xb(1) yXb];
        [Area2,Area3] = TtkBerat(xNoSTa,yXba);
        
        yLuasST = [LuasST,-LuasST(end-1:-1:1)];
        yLuasSTa= [-LuasST(1) LuasST(1) yLuasST];
        [Area4,Area5] = TtkBerat(xNoSTa,yLuasSTa);
        
        %plot(xNoSTa,yXba,Area2(2),Area2(3),'or');
        KBd     = trapz(NoST*h,KbST.*LuasST)/Vold;        % KB
        Fmd     = Area2(2)-5*h;                           % F ke midship (- dibelakang midship)
        Bmd     = Area4(2)-5*h;                           % B ke midship (- dibelakang midship)
        BMd     = Area3(4)/Vold;                          % BM
        BMLd    = Area3(5)/Vold;                          % BML

        Wsad    = trapz(NoST*h,PanjGirthST);             % WSA 
        Lwld    = ( NoST(end)-NoST(1) )* h;              % Panjang LWL
        MTCd    = Displd * BMLd / (Lwld*100);            % MTC
        Cbd     = Vold / ( Lwld * Bd * d);               % Cb 
        Cmd     = Amd / ( Bd * d);                       % Cm 
        Cwd     = Awld / ( Lwld * Bd );                  % Cw 
        Cpd     = Vold / ( Lwld * Amd );                 % Cp

        Cb(k) = Cbd;
        Cm(k) = Cmd;
        Cw(k) = Cwd;
        Cp(k) = Cpd;
        Wsa(k)= Wsad;
        Vol(k)= Vold;
        Displ(k)= Displd;
        Awl(k) = Awld;
        TPC(k) = TPCd;
        KB(k)  = KBd;
        BM(k)  = BMd;
        KM(k)  = KBd+BMd;
        BML(k) = BMLd;
        KML(k) = KBd+BMLd;
        Fm(k)  = Fmd;
        MTC(k) = MTCd;
        Bm(k)  = Bmd;
    end
end

if pilih == 2
    clc;
    d_Cb_Cm_Cw_Cp=[d1',Cb',Cm',Cw',Cp'];
    d_Wsa_Awl_Vol_Disp_TPC=[d1',Wsa',Awl',Vol',Displ',TPC'];
    d_KB_BM_KM_BML_KML_Fm=[d1',KB',BM',KM',BML',KML',Fm'];
    
    
    d2  = linspace(0.01,d1(end),30);
    Cb2 = interp1(d1,Cb,d2,'linear','extrap');
    Cm2 = interp1(d1,Cm,d2,'linear','extrap');
    Cw2 = interp1(d1,Cw,d2,'linear','extrap');
    Cp2 = interp1(d1,Cp,d2,'linear','extrap');

    Wsa2 = interp1(d1,Wsa,d2,'linear','extrap');
    Awl2 = interp1(d1,Awl,d2,'linear','extrap');
    Vol2 = interp1(d1,Vol,d2,'linear','extrap');
    Disp2= interp1(d1,Displ,d2,'linear','extrap');


    KB2 = interp1(d1,KB,d2,'linear','extrap');
    BM2 = interp1(d1,BM,d2,'linear','extrap');
    KM2 = interp1(d1,KM,d2,'linear','extrap');
    BML2 = interp1(d1,BML,d2,'linear','extrap');
    KML2 = interp1(d1,KML,d2,'linear','extrap');
    TPC2 = interp1(d1,TPC,d2,'linear','extrap');
    MTC2 = interp1(d1,MTC,d2,'linear','extrap');

    Fm2 = interp1(d1,Fm,d2,'linear','extrap');
    Bm2 = interp1(d1,Bm,d2,'linear','extrap');

    figure(2);

    plot(Cb2,d2,'k');grid
    text(max(Cb2),max(d2)*0.95,'Cb','FontSize',8);
    cfig = get(gcf,'color');
    ax(1)=gca;
    pos = [0.12 0.45 0.75 0.5];
    offset = pos(4)/5.4;
    set(ax(1),'Position',pos,'FontSize',8)
    line(Cm2,d2,'Color','k','Parent',ax(1));text(max(Cm2),max(d2)*0.93,'Cm','FontSize',8);
    line(Cw2,d2,'Color','k','Parent',ax(1));text(max(Cw2),max(d2)*0.91,'Cw','FontSize',8);
    line(Cp2,d2,'Color','k','Parent',ax(1));text(max(Cp2),max(d2)*0.89,'Cp','FontSize',8);
    xlabel('Cb, Cm, Cw, Cp');ylabel('d (m)');

    pos2 = [pos(1) pos(2)-offset pos(3) pos(4)+offset];
    pos3 = [pos(1) pos(2)-2*offset pos(3) pos(4)+2*offset];
    pos4 = [pos(1) pos(2)-3*offset pos(3) pos(4)+3*offset];
    pos5 = [pos(1) pos(2)-4*offset pos(3) pos(4)+4*offset];

    scale2 = pos2(4)/pos(4);
    scale3 = pos3(4)/pos(4);
    scale4 = pos4(4)/pos(4);
    scale5 = pos5(4)/pos(4);
    limy1 = get(ax(1),'ylim');
    limy2 = [limy1(2)-scale2*(limy1(2)-limy1(1)) limy1(2)];
    limy3 = [limy1(2)-scale3*(limy1(2)-limy1(1)) limy1(2)];
    limy4 = [limy1(2)-scale4*(limy1(2)-limy1(1)) limy1(2)];
    limy5 = [limy1(2)-scale5*(limy1(2)-limy1(1)) limy1(2)];

    ax(2)=axes('Position',pos2,'Box','off',...
        'Color','none','YColor',cfig,...
        'XColor','r','Ytick',[],'Ylim',limy2,'Xlim',[0 inf],...
        'XAxisLocation','bottom','FontSize',8);
    lokWsa = interp1(d2,Wsa2,max(d2)*0.9);
    lokAwl = interp1(d2,Awl2,max(d2)*0.6);
    lokVol = interp1(d2,Vol2,max(d2)*0.95);
    lokDisp = interp1(d2,Disp2,max(d2)*0.8);
    line(Wsa2,d2,'Color','r','Parent',ax(2));text(lokWsa,max(d2)*0.9,'Wsa','FontSize',8,'Color','r');
    line(Awl2,d2,'Color','r','Parent',ax(2));text(lokAwl,max(d2)*0.6,'Awl','FontSize',8,'Color','r');
    line(Vol2,d2,'Color','r','Parent',ax(2));text(lokVol,max(d2)*0.95,'\nabla','FontSize',8,'Color','r');
    line(Disp2,d2,'Color','r','Parent',ax(2));text(lokDisp,max(d2)*0.8,'\Delta','FontSize',8,'Color','r');
    xlabel('Wsa ( m^2 ), Awl ( m^2 ), \nabla ( m^3 ), \Delta ( ton )');

    ax(3)=axes('Position',pos3,'Box','off',...
        'Color','none','YColor',cfig,...
        'XColor','b','Ytick',[],'Ylim',limy3,...
        'XAxisLocation','bottom','FontSize',8);
    lokKB = interp1(d2,KB2,max(d2)*0.9);
    lokBM = interp1(d2,BM2,max(d2)*0.85);
    lokKM = interp1(d2,KM2,max(d2)*0.6);
    lokTPC = interp1(d2,TPC2,max(d2)*0.75);
    lokMTC = interp1(d2,MTC2,max(d2)*0.4);
    line(KB2,d2,'Color','b','Parent',ax(3));text(lokKB,max(d2)*0.9,'KB','FontSize',8,'Color','b');
    line(BM2,d2,'Color','b','Parent',ax(3));text(lokBM,max(d2)*0.85,'BM','FontSize',8,'Color','b');
    line(KM2,d2,'Color','b','Parent',ax(3));text(lokKM,max(d2)*0.6,'KM','FontSize',8,'Color','b');
    line(TPC2,d2,'Color','b','Parent',ax(3));text(lokTPC,max(d2)*0.75,'TPC','FontSize',8,'Color','b');
    line(MTC2,d2,'Color','b','Parent',ax(3));text(lokMTC,max(d2)*0.4,'MTC','FontSize',8,'Color','b');
    xlabel('KB ( m ), BM ( m ), KM ( m ), TPC ( ton ), MTC ( ton.m )');

    ax(4)=axes('Position',pos4,'Box','off',...
        'Color','none','YColor',cfig,...
        'XColor','m','Ytick',[],'Ylim',limy4,...
        'XAxisLocation','bottom','FontSize',8);
    lokBML = interp1(d2,BML2,max(d2)*0.8);
    lokKML = interp1(d2,KML2,max(d2)*0.6);
    line(BML2,d2,'Color','m','Parent',ax(4));text(lokBML,max(d2)*0.8,'BML','FontSize',8,'Color','m');
    line(KML2,d2,'Color','m','Parent',ax(4));text(lokKML,max(d2)*0.6,'KML','FontSize',8,'Color','m');
    xlabel('BML ( m ), KML ( m )');

    warna = [ 0.502 0.000 1.000 ];
    ax(5)=axes('Position',pos5,'Box','off',...
        'Color','none','YColor',cfig,...
        'XColor',warna,'Ytick',[],'Ylim',limy5,'Xlim',[-5*h 5*h],...
        'XAxisLocation','bottom','FontSize',8);
    lokFm = interp1(d2,Fm2,max(d2)*0.4);
    lokBm = interp1(d2,Bm2,max(d2)*0.7);
    line(Fm2,d2,'Color',warna,'Parent',ax(5)); text(lokFm+0.5,max(d2)*0.4,'Fm','FontSize',8,'Color',warna);
    line(Bm2,d2,'Color',warna,'Parent',ax(5)); text(lokBm+0.5,max(d2)*0.7,'Bm','FontSize',8,'Color',warna);
    line([-5*h -5*h],[0 25],'Color','k','Parent',ax(5));
    xlabel('Fm ( m ), Bm ( m )');     
end


% --- Executes on button press in pbFile.
function pbFile_Callback(hObject, eventdata, handles)
% hObject    handle to pbFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global A UK

NamaFile = uigetfile('*.xls');
A    = xlsread(NamaFile);
UK  = A(1,:);

NamaFile = NamaFile(1:length(NamaFile)-4);
set(handles.text2,'String',NamaFile);
fclose('all');
set(handles.edit1,'String',strvcat(['Main Dimensions'],'-------------------------',...
    ['Loa (m) = ',blanks(3),num2str(UK(1))],...
    ['Lpp (m) = ',blanks(3),num2str(UK(2))],['B     (m) = ',blanks(3),num2str(UK(3))],...
    ['H     (m) = ',blanks(3),num2str(UK(4))],['T     (m) = ',blanks(3),num2str(UK(5))]));

% --- Executes on button press in pbHapus.
function pbHapus_Callback(hObject, eventdata, handles)
global Phideg pilih
% hObject    handle to pbHapus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%if pilih == 3
%    for i= 1:length(Phideg)
%        close (figure(i));
%    end
%end
close (figure(1));close (figure(2));close (figure(3));
% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function popProses_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popProses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popProses.
function popProses_Callback(hObject, eventdata, handles)
% hObject    handle to popProses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popProses contents as cell array

%        contents{get(hObject,'Value')} returns selected item from popProses

function [ geom, iner, cpmo ] = TtkBerat( x, y ) 

[ x, ns ] = shiftdim( x );
[ y, ns ] = shiftdim( y );
[ n, c ] = size( x );

xm = mean(x);
ym = mean(y);
x = x - xm*ones(n,1);
y = y - ym*ones(n,1);


dx = x( [ 2:n 1 ] ) - x;
dy = y( [ 2:n 1 ] ) - y;


A = sum( y.*dx - x.*dy )/2;
Axc = sum( 6*x.*y.*dx -3*x.*x.*dy +3*y.*dx.*dx +dx.*dx.*dy )/12;
Ayc = sum( 3*y.*y.*dx -6*x.*y.*dy -3*x.*dy.*dy -dx.*dy.*dy )/12;
Ixx = sum( 2*y.*y.*y.*dx -6*x.*y.*y.*dy -6*x.*y.*dy.*dy ...
          -2*x.*dy.*dy.*dy -2*y.*dx.*dy.*dy -dx.*dy.*dy.*dy )/12;
Iyy = sum( 6*x.*x.*y.*dx -2*x.*x.*x.*dy +6*x.*y.*dx.*dx ...
          +2*y.*dx.*dx.*dx +2*x.*dx.*dx.*dy +dx.*dx.*dx.*dy )/12;
Ixy = sum( 6*x.*y.*y.*dx -6*x.*x.*y.*dy +3*y.*y.*dx.*dx ...
          -3*x.*x.*dy.*dy +2*y.*dx.*dx.*dy -2*x.*dx.*dy.*dy )/24;
P = sum( sqrt( dx.*dx +dy.*dy ) );

if A < 0,
  A = -A;
  Axc = -Axc;
  Ayc = -Ayc;
  Ixx = -Ixx;
  Iyy = -Iyy;
  Ixy = -Ixy;
end

xc = Axc / A;
yc = Ayc / A;
Iuu = Ixx - A*yc*yc;
Ivv = Iyy - A*xc*xc;
Iuv = Ixy - A*xc*yc;
J = Iuu + Ivv;

x_cen = xc + xm;
y_cen = yc + ym;
Ixx = Iuu + A*y_cen*y_cen;
Iyy = Ivv + A*x_cen*x_cen;
Ixy = Iuv + A*x_cen*y_cen;

I = [ Iuu  -Iuv ;
     -Iuv   Ivv ];
[ eig_vec, eig_val ] = eig(I);
I1 = eig_val(1,1);
I2 = eig_val(2,2);
ang1 = atan2( eig_vec(2,1), eig_vec(1,1) );
ang2 = atan2( eig_vec(2,2), eig_vec(1,2) );

geom = [ A  x_cen  y_cen  P ];
iner = [ Ixx  Iyy  Ixy  Iuu  Ivv  Iuv ];
cpmo = [ I1  ang1  I2  ang2  J ];


% --- Executes during object creation, after setting all properties.
function eKG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eKG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function eKG_Callback(hObject, eventdata, handles)
% hObject    handle to eKG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eKG as text
%        str2double(get(hObject,'String')) returns contents of eKG as a double

function StabGZ
global A UK Phideg KG GZ

ttk  = A(2:end,1:3);
k    = diff(ttk(:,1));
k2   = find(k ~= 0);
k2(length(k2) +1)   = length(ttk);
JumST   = length(k2);
z  = ttk(:,1); y = ttk(:,2); x = ttk(:,3);
h  = UK(2)/10;
d  = UK(5);

Phideg=linspace(-0.01,-89.9,19);

for pp = 1:length(Phideg)
j=0;
Phi= Phideg(pp)*pi/180;%figure(pp);
for i = 1: JumST
    x1 = x(find(z == z(k2(i)))); % mencari data tiap station
    y1 = y(find(z == z(k2(i))));
    z1 = z(find(z == z(k2(i))));
    
    y1(end+1) = y1(end) + 0.1;   % membuat chamber tiap station
    x1(end+1) = 0;
    z1(end+1) = z1(1);
    
    x2=x1(-sort(-find(x1(1:end-1)))); % mengurutkan data
    y2=-sort(-y1(2:end-1));
    
    x3=[x1(end);x2;x1(1);-x1(2:end)]; % data kanan dan kiri
    y3=[y1(end);y2;y1];
    z3=[z1(1)*ones(length(y3),1)];
    
    y6=-1:UK(4)*1.2;
    x6=zeros(1,length(y6));
    
    R = [cos(Phi),-sin(Phi),0; % data diputar
         sin(Phi),cos(Phi),0;
         0,0,1];
    x4=R(1,1)*x3+R(1,2)*(y3-d);
    y4=R(2,1)*x3+R(2,2)*(y3-d)+d;
    
    x7=R(1,1)*x6+R(1,2)*(y6-d);
    y7=R(2,1)*x6+R(2,2)*(y6-d)+d;
    
    x9=R(1,1)*0+R(1,2)*(KG-d);
    y9=R(2,1)*0+R(2,2)*(KG-d)+d;
    
    x51 = x4(find(y4 <= d));
    y51 = y4(find(y4 <= d));
    z51 = z3(find(y4 <= d));
    
    x5  = zeros(length(x51)+2,1);
    y5  = zeros(length(y51)+2,1);
    z5  = ones (length(z51)+2,1);
    
    lenky4 = length(y4);       % mencari perpotongan data ke garis air
    if Phideg == 90|Phideg == -90
        x31 = [x3(1);x3(find(x3 >= 0 & x3 ~= x3(end)))];
        y31 = [y3(1);y3(find(x3 >= 0 & x3 ~= x3(end)))];
        ny41 = x31(1);
        ny42 = x31(end);
    else     
        ny41    = find( (y4(1:lenky4-1) > d) & (y4(2:lenky4) < d) );
        ny42    = find( (y4(1:lenky4-1) < d) & (y4(2:lenky4) > d) );
    end
    ny=[ny41,ny42];
    if  ~isempty(ny)
        if Phideg == 90
            nx51 = find( (y4 == d) & (x4 ~= x4(1)) & (x4 ~= x4(end)));
            x5  = x4(nx51:end);
            y5  = y4(nx51:end);z5=z5*z51(1);
        elseif Phideg == -90
            nx51 = find( (y4 == d) & (x4 ~= x4(1)) & (x4 ~= x4(end)));
            x5  = x4(1:nx51);
            y5  = y4(1:nx51);z5=z5*z51(1);
        else
            xn1 = interp1(y4(ny41:ny41+1),x4(ny41:ny41+1),d);
            xn2 = interp1(y4(ny42:ny42+1),x4(ny42:ny42+1),d);
            x5(1)   = xn1; y5(1)   = d;
            x5(end) = xn2; y5(end) = d;z5=z5*z51(1);
            x5(2:end-1) = x51; y5(2:end-1) = y51;
        end
        
        %plot(x4,y4,x7,y7,'r'); hold on
        %[x5,y5]
        %plot(x5,y5,'r');hold on
    end
    
    if (length(y5) > 2 & length(x5) > 2) % hanya station yang punya dua titik atau lebih
        j=j+1;
        Area1   = TtkBerat( x5,y5 );
        LuasST(j)  = Area1(1);
        BxST(j)    = Area1(2);
        ByST(j)    = Area1(3);
        NoST(j)    = z5(1);
    end
    
end
%axis equal
%plot([-UK(3)*0.6,UK(3)*0.6],[UK(5),UK(5)],'--r');

Vold    = trapz(NoST*h,LuasST);                   % Volume carene
Bxd     = trapz(NoST*h,BxST.*LuasST)/Vold;  
Byd     = trapz(NoST*h,ByST.*LuasST)/Vold;
M       = interp1(x7,y7,Bxd);

%plot(x9,y9,'og',Bxd,y9,'ob'); hold on;            % Titik GZ
%plot(x6+Bxd,y6,'k',Bxd,Byd,'ob',Bxd,M,'or');      

%text(Bxd+0.1,Byd,'B1','FontSize',8,'Color','b');
%text(Bxd+0.1,M,'M','FontSize',8,'Color','r');

%text(x9+0.1,y9,'G','FontSize',8,'Color','g');
%text(Bxd+0.1,y9,'Z','FontSize',8,'Color','b');
GZ(pp) = Bxd - x9;
end
m=(GZ(2)-GZ(1))/(-Phideg(2));
xm = linspace(0,180/pi,20);
ym = m*xm;
figure(3);
plot(-Phideg,GZ,'-o',[0 90],[0 0],'k',xm,ym,'r',...
    [180/pi 180/pi],[0 m*180/pi],'r',180/pi,m*180/pi,'or');grid;
text(180/pi+ 3,m*180/pi,['GM = ',sprintf('%5.3f',m*180/pi),' m'],'FontSize',8,'Color','r');
pbaspect([2 1 1]);
xlabel('\phi ( deg )');
ylabel('GZ ( m )');
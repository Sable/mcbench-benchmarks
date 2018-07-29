function varargout = contact_ellipse_calculator(varargin)
% CONTACT_ELLIPSE_CALCULATOR M-file for contact_ellipse_calculator.fig
%      CONTACT_ELLIPSE_CALCULATOR, by itself, creates a new CONTACT_ELLIPSE_CALCULATOR or raises the existing
%      singleton*.
%
%      H = CONTACT_ELLIPSE_CALCULATOR returns the handle to a new CONTACT_ELLIPSE_CALCULATOR or the handle to
%      the existing singleton*.
%
%      CONTACT_ELLIPSE_CALCULATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONTACT_ELLIPSE_CALCULATOR.M with the given input arguments.
%
%      CONTACT_ELLIPSE_CALCULATOR('Property','Value',...) creates a new CONTACT_ELLIPSE_CALCULATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before contact_ellipse_calculator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to contact_ellipse_calculator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help contact_ellipse_calculator

% Last Modified by GUIDE v2.5 04-Oct-2011 12:53:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @contact_ellipse_calculator_OpeningFcn, ...
                   'gui_OutputFcn',  @contact_ellipse_calculator_OutputFcn, ...
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


% --- Executes just before contact_ellipse_calculator is made visible.
function contact_ellipse_calculator_OpeningFcn(hObject,eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to contact_ellipse_calculator (see VARARGIN)
global ptnum 
global ptnum_R1
global ptnum_R1pr
global ptnum_R2
global ptnum_R2pr
global ptnum_Sw
global ptnum_Sr
global ptnum_Ew
global ptnum_Er 
global ptnum_m
global ptnum_n 
global ptnum_Phi
global nn
nn = 1;



% Choose default command line output for contact_ellipse_calculator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
ptnum      = get(handles.Screen_N,'string');
ptnum_R1   = get(handles.Screen_R1,'string');
ptnum_R1pr = get(handles.Screen_R1pr,'string');
ptnum_R2   = get(handles.Screen_R2,'string');
ptnum_R2pr = get(handles.Screen_R2pr,'string');
ptnum_Sw   = get(handles.Screen_Sw,'string');
ptnum_Sr   = get(handles.Screen_Sr,'string');
ptnum_Ew   = get(handles.Screen_Ew,'string');
ptnum_Er   = get(handles.Screen_Er,'string');
ptnum_n    = get(handles.Screen_nn,'string');
ptnum_m    = get(handles.Screen_mm,'string');
ptnum_Phi  = get(handles.Screen_Phi,'string');

ptnum      = str2double(ptnum);
ptnum_R1   = str2double(ptnum_R1);
ptnum_R1pr = str2double(ptnum_R1pr);
ptnum_R2   = str2double(ptnum_R2);
ptnum_R2pr = str2double(ptnum_R2pr);
ptnum_Sw   = str2double(ptnum_Sw);
ptnum_Sr   = str2double(ptnum_Sr);
ptnum_Ew   = str2double(ptnum_Ew)*10^6;
ptnum_Er   = str2double(ptnum_Er)*10^6;
ptnum_n    = str2double(ptnum_n);
ptnum_m    = str2double(ptnum_m);
ptnum_Phi  = str2double(ptnum_Phi);


% Greek letters diplay
set(handles.text23,'String','x','FontName','symbol');
set(handles.text26,'String','x','FontName','symbol');
set(handles.text27,'String','x','FontName','symbol');
set(handles.text31,'String','x','FontName','symbol');
set(handles.text35,'String','h','FontName','symbol');
set(handles.text40,'String','t','FontName','symbol');
set(handles.text46,'String','s','FontName','symbol');
set(handles.text50,'String','j','FontName','symbol');
set(handles.text52,'String','y1','FontName','symbol');
set(handles.Phi,'String','Y :','FontName','symbol');

% set(handles.text53,'String','abcdefg hijklmnop qrstuv wxyz','FontName','symbol');


 

% UIWAIT makes contact_ellipse_calculator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = contact_ellipse_calculator_OutputFcn(hObject,eventdata,handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject,eventdata,handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ptnum 
    global ptnum_R1
    global ptnum_R1pr
    global ptnum_R2
    global ptnum_R2pr
    global ptnum_Sw
    global ptnum_Sr
    global ptnum_Ew
    global ptnum_Er 
    global ptnum_Phi

    
    ptnum      = get(handles.Screen_N,'string');
    ptnum_R1   = get(handles.Screen_R1,'string');
    ptnum_R1pr = get(handles.Screen_R1pr,'string');
    ptnum_R2   = get(handles.Screen_R2,'string');
    ptnum_R2pr = get(handles.Screen_R2pr,'string');
    ptnum_Sw   = get(handles.Screen_Sw,'string');
    ptnum_Sr   = get(handles.Screen_Sr,'string');
    ptnum_Ew   = get(handles.Screen_Ew,'string');
    ptnum_Er   = get(handles.Screen_Er,'string');
    ptnum_Phi  = get(handles.Screen_Phi,'string');


    ptnum      = str2double(ptnum);
    ptnum_R1   = str2double(ptnum_R1);
    ptnum_R1pr = str2double(ptnum_R1pr);
    ptnum_R2   = str2double(ptnum_R2);
    ptnum_R2pr = str2double(ptnum_R2pr);
    ptnum_Sw   = str2double(ptnum_Sw);
    ptnum_Sr   = str2double(ptnum_Sr);
    ptnum_Ew   = str2double(ptnum_Ew)*10^6;
    ptnum_Er   = str2double(ptnum_Er)*10^6;
    ptnum_Phi  = str2double(ptnum_Phi);
   

   
    
    N   = ptnum; 
    R1  = ptnum_R1;  R1pr = ptnum_R1pr;
    R2  = ptnum_R2;  R2pr = ptnum_R2pr;
    Sw  = ptnum_Sw;  Sr   = ptnum_Sr;
    Ew  = ptnum_Ew;  Er   = ptnum_Er;
    Phi = ptnum_Phi;
       
   
    K1 = (1-Sw^2)/(pi*Ew);
    K2 = (1-Sr^2)/(pi*Er);
    K3 = 0.5*(1/R1 + 1/R1pr + 1/R2 + 1/R2pr);
    K4 = 0.5*((1/R1 + 1/R1pr)^2 + (1/R2 + 1/R2pr)^2 + 2*(1/R1 - 1/R1pr)*(1/R2 - 1/R2pr)*cos(2*Phi))^(1/2);
     
    Theta = acos(K4/K3)*180/pi;
    % Automatically calculate m, n
%     Calculate_MN(Theta, hObject, eventdata, handles)
    
    dp_Theta = sprintf('%4.1f',Theta);
    dp_K1    = sprintf('%4.5f',K1);
    dp_K2    = sprintf('%4.5f',K2);
    dp_K3    = sprintf('%4.5f',K3);
    dp_K4    = sprintf('%4.5f',K4);
    set(handles.Screen_Theta,'string',dp_Theta);
    set(handles.Screen_K1,'string',dp_K1);
    set(handles.Screen_K2,'string',dp_K2);
    set(handles.Screen_K3,'string',dp_K3);
    set(handles.Screen_K4,'string',dp_K4);
%     set(handles.Screen_mm,'string','1.006');
%     set(handles.Screen_nn,'string','0.9944');

    
    ptnum = N; 
    ptnum_R1  = R1;  ptnum_R1pr = R1pr;
    ptnum_R2  = R2;  ptnum_R2pr = R2pr ;
    ptnum_Sw  = Sw;  ptnum_Sr = Sr;
    ptnum_Ew  = Ew;  ptnum_Er = Er;
    ptnum_Phi = Phi;



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject,eventdata,handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global ptnum 
    global ptnum_R1
    global ptnum_R1pr
    global ptnum_R2
    global ptnum_R2pr
    global ptnum_Sw
    global ptnum_Sr
    global ptnum_Ew
    global ptnum_Er 
    global ptnum_Phi
    global ptnum_m
    global ptnum_n
    global a
    global b nn 
    
    ptnum      = get(handles.Screen_N,'string');
    ptnum_R1   = get(handles.Screen_R1,'string');
    ptnum_R1pr = get(handles.Screen_R1pr,'string');
    ptnum_R2   = get(handles.Screen_R2,'string');
    ptnum_R2pr = get(handles.Screen_R2pr,'string');
    ptnum_Sw   = get(handles.Screen_Sw,'string');
    ptnum_Sr   = get(handles.Screen_Sr,'string');
    ptnum_Ew   = get(handles.Screen_Ew,'string');
    ptnum_Er   = get(handles.Screen_Er,'string');
    ptnum_Phi  = get(handles.Screen_Phi,'string');
    ptnum_n    = get(handles.Screen_nn,'string');
    ptnum_m    = get(handles.Screen_mm,'string');

    ptnum      = str2double(ptnum);
    ptnum_R1   = str2double(ptnum_R1);
    ptnum_R1pr = str2double(ptnum_R1pr);
    ptnum_R2   = str2double(ptnum_R2);
    ptnum_R2pr = str2double(ptnum_R2pr);
    ptnum_Sw   = str2double(ptnum_Sw);
    ptnum_Sr   = str2double(ptnum_Sr);
    ptnum_Ew   = str2double(ptnum_Ew)*10^6;
    ptnum_Er   = str2double(ptnum_Er)*10^6;
    ptnum_Phi  = str2double(ptnum_Phi);
    ptnum_n    = str2double(ptnum_n);
    ptnum_m    = str2double(ptnum_m);


    clc, 
    N   = ptnum; 
    R1  = ptnum_R1;  R1pr = ptnum_R1pr;
    R2  = ptnum_R2;  R2pr = ptnum_R2pr;
    Sw  = ptnum_Sw;  Sr   = ptnum_Sr;
    Ew  = ptnum_Ew;  Er   = ptnum_Er;
    n   = ptnum_n;   m    = ptnum_m;
    Phi = ptnum_Phi;
       
    
    K1 = (1-Sw^2)/(pi*Ew);
    K2 = (1-Sr^2)/(pi*Er);
    K3 = 0.5*(1/R1 + 1/R1pr + 1/R2 + 1/R2pr);
    K4 = 0.5*((1/R1 + 1/R1pr)^2 + (1/R2 + 1/R2pr)^2 + 2*(1/R1 - 1/R1pr)*(1/R2 - 1/R2pr)*cos(2*Phi))^(1/2);
%     Theta = acos(K4/K3)*180/pi;
    
    a = m*(3*pi*N*(K1+K2)/(4*K3))^(1/3);
    b = n*(3*pi*N*(K1+K2)/(4*K3))^(1/3);

    dp_a    = sprintf('%4.2f',a);
    dp_b    = sprintf('%4.2f',b);

    set(handles.Screen_aa,'string',dp_a);
    set(handles.Screen_bb,'string',dp_b);
    
    
   
    theta = linspace(0,2*pi,100);
 
    x = a/2*cos(theta);  
    y = b/2*sin(theta); 
 
 
    a = a/2; b= b/2;
    xx = linspace(-a,a,100);
    yy = linspace(-b,b,100);
    z1 = zeros(length(xx), length(yy));
    z  = z1;
    for i = 1 : length(xx) 
        for j = 1: length(yy) 
            z1(i,j) = 1 - (xx(i)^2/a^2) - (yy(j)^2/b^2);        
            if z1(i,j) < 0
                z1(i,j) = 0;
            end    
            z(i,j) = (3*N)/(2*pi*a*b)*sqrt((z1(i,j)));        
        end
    end
    mesh(handles.axes1,xx,yy,z)
    
        xlabel(handles.axes1,'Longitidinal');
        ylabel(handles.axes1,'Lateral');
        zlabel(handles.axes1,'Contact Pressure');
        axis(handles.axes1,'square');
        colorbar('peer',handles.axes1,'EastOutside');

  hold(handles.axes2,'on')

Ccolor=['b';'r';'k';'g';'y';'b';'r';'k';'g';'y';'b';'r';'k';'g';'y'];

    plot(handles.axes2,x',y',Ccolor(nn));
        xlabel(handles.axes2,'Longitidinal');
        ylabel(handles.axes2,'Lateral'); 
        axis(handles.axes2,'equal')

%             as = sprintf('%4.2f',2*a);
%             bs = sprintf('%4.2f',2*b);
%         legend(handles.axes2,['a = ',as],['b = ',bs]);
hold(handles.axes2,'off')

nn = nn+1;
  


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject,eventdata,handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global ptnum 
    global ptnum_R1
    global ptnum_R1pr
    global ptnum_R2
    global ptnum_R2pr
    global ptnum_Sw
    global ptnum_Sr
    global ptnum_Ew
    global ptnum_Er 
    global ptnum_Phi
    global ptnum_m
    global ptnum_n nn X Y
    

    ptnum       = 0;   set(handles.Screen_N,'string',ptnum);
    ptnum_R1    = 0;   set(handles.Screen_R1,'string',ptnum_R1);
    ptnum_R1pr  = 0;   set(handles.Screen_R1pr,'string',ptnum_R1pr);
    ptnum_R2    = 0;   set(handles.Screen_R2,'string',ptnum_R2);
    ptnum_R2pr  = 0;   set(handles.Screen_R2pr,'string',ptnum_R2pr);
    ptnum_Sw    = 0;   set(handles.Screen_Sw,'string',ptnum_Sw);
    ptnum_Sr    = 0;   set(handles.Screen_Sr,'string',ptnum_Sr);
    ptnum_Ew    = 0;   set(handles.Screen_Ew,'string',ptnum_Ew);
    ptnum_Er    = 0;   set(handles.Screen_Er,'string',ptnum_Er);
    ptnum_Phi   = 0;   set(handles.Screen_Phi,'string',ptnum_Phi);
    ptnum_m     = 0;   set(handles.Screen_mm,'string',ptnum_m);
    ptnum_n     = 0;   set(handles.Screen_nn,'string',ptnum_n);
    
    ptnum       = 0;   set(handles.Screen_K1,'string',ptnum);
    ptnum       = 0;   set(handles.Screen_K2,'string',ptnum);
    ptnum       = 0;   set(handles.Screen_K3,'string',ptnum);
    ptnum       = 0;   set(handles.Screen_K4,'string',ptnum);
    ptnum       = 0;   set(handles.Screen_Theta,'string',ptnum);
    ptnum       = 0;   set(handles.Screen_aa,'string',ptnum);
    ptnum       = 0;   set(handles.Screen_bb,'string',ptnum);
    
    nn = 1 ; X = zeros(1,100); Y = zeros(1,100);

cla(handles.axes1,'reset')
cla(handles.axes2,'reset')
    

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject,eventdata,handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% contact ellipse
global a
global b
global ptnum

% Johnson & Vermeulen's Theory
global Kuxi_x
global Kuxi_y
global Kuxi_sp
global f
global Gw
global Gr
global Kuxi1
global Kuxi2
global Kuxi3
global FfN1
global COMPARE

% DATA acqisition
    ptnum    = get(handles.Screen_N,'string');
    Kuxi_x   = get(handles.Screen_Kuxi_X,'string');
    Kuxi_y   = get(handles.Screen_Kuxi_Y,'string');
    Kuxi_sp  = get(handles.Screen_Kuxi_SP,'string');
    f        = get(handles.Screen_f,'string');
    Gw       = get(handles.Screen_Gw,'string');
    Gr       = get(handles.Screen_Gr,'string');
    Phi1     = get(handles.Screen_Phi1,'string');
    Phi2     = get(handles.Screen_Phi2,'string');

    ptnum   = str2double(ptnum); N   = ptnum; 
    Kuxi_x  = str2double(Kuxi_x);
    Kuxi_y  = str2double(Kuxi_y);
    Kuxi_sp = str2double(Kuxi_sp);
    f       = str2double(f);
    Gw      = str2double(Gw)*10^6;
    Gr      = str2double(Gr)*10^6;
    Phi1    = str2double(Phi1);
    Phi2    = str2double(Phi2);
    
    clc
[N,a,b,Gw,Gr,f,Kuxi_x,Kuxi_y]';
% claculation

    Kuxi_xv = linspace(0,Kuxi_x,100);
    Kuxi_yv = linspace(0,Kuxi_y,100);
    Kuxi_sp = linspace(0,Kuxi_sp,100);
    G       = 2*Gw*Gr /(Gw + Gr);
    Kuxi1   = pi*a*b*G*Kuxi_xv / (f*N*Phi1) ;    % phi =3
    Kuxi2   = pi*a*b*G*Kuxi_yv / (f*N*Phi2) ;    % phi =3
    Kuxi3   = sqrt(Kuxi1.^2 + Kuxi2.^2);

TT = Kuxi3;
for i = 1 : length(Kuxi_xv)
    if TT(i) < 3
         for j = 1 : length(Kuxi_yv)
            FfN1(i,j) = (1/TT(i))*((1 - TT(i)/3)^3 - 1)*(Kuxi1(i)+Kuxi2(j));
         end   
    else
         for j = 1 : length(Kuxi_yv)
            FfN1(i,j) = (-1/TT(i))*(Kuxi1(i)+Kuxi2(j));
        end
    end
end  
FfN1 = -FfN1;
% set the DATA on the screen
    Kuxi1f    = sprintf('%4.2f',Kuxi1(100));
    Kuxi2f    = sprintf('%4.2f',Kuxi2(100));
    Kuxi3f    = sprintf('%4.2f',Kuxi3(100));
    FfN1f      = sprintf('%4.3f',FfN1(100,100));

    set(handles.Screen_Kuxi1,'string',Kuxi1f);
    set(handles.Screen_Kuxi2,'string',Kuxi2f);
    set(handles.Screen_Kuxi3,'string',Kuxi3f);
    set(handles.Screen_Formul,'string',FfN1f);

    
% Plot
mesh(handles.axes5,Kuxi_xv, Kuxi_yv, FfN1')
    
   xlabel(handles.axes5,'\xi_x');
   ylabel(handles.axes5,'\xi_y');
   zlabel(handles.axes5,'F/fN');
   colorbar('peer',handles.axes5,'EastOutside')

    

plot(handles.axes4,Kuxi_xv,FfN1(:,1),Kuxi_xv,FfN1(:,100),'-r')
   xlabel(handles.axes4,'\xi_x')
   ylabel(handles.axes4,'F/fN')
   legend(handles.axes4,'\xi_y= 0',['\xi_y= ',num2str(Kuxi_y)],4);
   
   COMPARE.a =[FfN1(:,1) FfN1(:,100)];
  
   

 

  


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject,eventdata,handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% contact ellipse
global a
global b
global ptnum_Sw
global ptnum_Sr
global ptnum

% Johnson & Vermeulen's Theory
global Kuxi_x Kuxi_xv
global Kuxi_y
global Kuxi_sp
global f
global Gw
global Gr
global Kuxi1
global Kuxi2
global Kuxi3
global FfN2
global COMPARE

% DATA acqisition
    ptnum    = get(handles.Screen_N,'string');
    Kuxi_x   = get(handles.Screen_Kuxi_X,'string');
    Kuxi_y   = get(handles.Screen_Kuxi_Y,'string');
    Kuxi_sp  = get(handles.Screen_Kuxi_SP,'string');
    f        = get(handles.Screen_f,'string');
    Gw       = get(handles.Screen_Gw,'string');
    Gr       = get(handles.Screen_Gr,'string');
    ptnum_Sw = get(handles.Screen_Sw,'string');
    ptnum_Sr = get(handles.Screen_Sr,'string');
    Phi1     = get(handles.Screen_Phi1,'string');
    Phi2     = get(handles.Screen_Phi2,'string');

    ptnum    = str2double(ptnum);   N   = ptnum; 
    Kuxi_x   = str2double(Kuxi_x);
    Kuxi_y   = str2double(Kuxi_y);
    Kuxi_sp  = str2double(Kuxi_sp);
    f        = str2double(f);
    Gw       = str2double(Gw)*10^6;
    Gr       = str2double(Gr)*10^6;
    ptnum_Sw = str2double(ptnum_Sw); Sw = ptnum_Sw;
    ptnum_Sr = str2double(ptnum_Sr); Sr = ptnum_Sr;
    Phi1     = str2double(Phi1);
    Phi2     = str2double(Phi2);
    
    
% calculation    
    Kuxi_xv = linspace(0,Kuxi_x,100);
    Kuxi_yv = linspace(0,Kuxi_y,100);
    Kuxi_spv = linspace(0,Kuxi_sp,100);
    
    G       = 2*Gw*Gr /(Gw + Gr);
%     Sig     = G*(Gw*Sr + Gr*Sw)/(2*Gw*Gr);
    
    
    Kuxi1   = pi*a*b*G*Kuxi_xv / (f*N*3*Phi1) ;   
    Kuxi2   = pi*a*b*G*Kuxi_yv / (f*N*3*Phi2) ;    
    Kuxi3   = sqrt(Kuxi1.^2 + Kuxi2.^2);
    
    c11 = 3.2893 +0.975/(b/a) - 0.012/(b/a)^2;
    c22 = 2.4014 + 1.3179/(b/a) - 0.02/(b/a)^2;
    c23 = 0.4147 + 1.0184/(b/a) + 0.0565/(b/a)^2 - 0.0013/(b/a)^3;
    c33 = 0.7; %as assume
    
    f33 = a*b*G*c11;
    f11 = a*b*G*c22;
    f12 = ((a*b)^(3/2))*G*c23;
    f22 = ((a/b)^2)*G*c33;
    
    Fx = -f33*Kuxi_xv;
    Fy = -f11*Kuxi_yv - f12*Kuxi_spv;
    Mz = f12*Kuxi_yv - f22*Kuxi_spv;
    
    TT = Kuxi3;
    % preallocation
    E1  = zeros(length(Kuxi_xv), length(Kuxi_yv));
    E2  = E1;
    FF1 = E1;
    FF2 = E1;
      for i = 1 : length(Kuxi_xv)
        if TT(i) < 1  
            for j = 1 : length(Kuxi_yv)
                E1(i,j)  = (Kuxi1(i) + Kuxi2(j))/TT(i);
                E2(i,j)  = (Kuxi_xv(i) + Kuxi_yv(j))/sqrt(Kuxi_xv(i)^2 + Kuxi_yv(j)^2);
                FF1(i,j) = (3/2)*TT(i)*acos(TT(i));
                FF2(i,j) = 1-(1+0.5*TT(i)^2)*sqrt(1-TT(i)^2);
                
                FfN2(i,j) = FF1(i,j)*E1(i,j) + FF2(i,j)*E2(i,j);                
            end     
        else
            for j = 1 : length(Kuxi_yv)
                E2(i,j)  = (Kuxi_xv(i) + Kuxi_yv(j))/sqrt(Kuxi_xv(i)^2 + Kuxi_yv(j)^2);
                FfN2(i,j) = E2(i,j);
            end
        end
      end  
%     FfN2;
    
    Kuxi1f    = sprintf('%4.2f',Kuxi1(100));
    Kuxi2f    = sprintf('%4.2f',Kuxi2(100));
    Kuxi3f    = sprintf('%4.2f',Kuxi3(100));
    FfN2f      = sprintf('%4.3f',FfN2(100,100));

    set(handles.Screen_Kuxi1,'string',Kuxi1f);
    set(handles.Screen_Kuxi2,'string',Kuxi2f);
    set(handles.Screen_Kuxi3,'string',Kuxi3f);
    set(handles.Screen_Formul,'string',FfN2f);
    

% plot
mesh(handles.axes5,Kuxi_xv, Kuxi_yv, FfN2')
   xlabel(handles.axes5,'\xi_x');
   ylabel(handles.axes5,'\xi_y');
   zlabel(handles.axes5,'F/fN');
    colorbar('peer',handles.axes5,'EastOutside')
   
    

plot(handles.axes4,Kuxi_xv,FfN2(:,1),Kuxi_xv,FfN2(:,100),'r-')
   xlabel(handles.axes4,'\xi_x')
   ylabel(handles.axes4,'F/fN')
   legend(handles.axes4,'\xi_y= 0',['\xi_y= ',num2str(Kuxi_y)],4);

   COMPARE.b =[FfN2(:,1)  FfN2(:,100)];
 



% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject,eventdata,handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global a
    global b
    global ptnum_Sw
    global ptnum_Sr
    global Gw
    global Gr

    Gw       = get(handles.Screen_Gw,'string');
    Gr       = get(handles.Screen_Gr,'string');
    ptnum_Sw = get(handles.Screen_Sw,'string');
    ptnum_Sr = get(handles.Screen_Sr,'string');
    
    Gw       = str2double(Gw)*10^6;
    Gr       = str2double(Gr)*10^6;
    ptnum_Sw = str2double(ptnum_Sw); Sw = ptnum_Sw;
    ptnum_Sr = str2double(ptnum_Sr); Sr = ptnum_Sr;
    
    G       = 2*Gw*Gr /(Gw + Gr);
    Sig     = G*(Gw*Sr + Gr*Sw)/(2*Gw*Gr);
    Ratio = a/b;
        if Ratio > 1
            Ratio = b/a;
            set(handles.Scre,'string','b/a');
        else
            Ratio = a/b;
            set(handles.Scre,'string','a/b');
        end
    
    Ratio    = sprintf('%4.1f',Ratio);
    Sig      = sprintf('%4.2f',Sig);
    
    set(handles.Screen_Ratio,'string',Ratio);
    set(handles.Screen_Sigma2,'string',Sig);
    

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject,eventdata,handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Kuxi_x
global Kuxi_y
global Kuxi_sp
global f
global Gw
global Gr
global Kuxi1
global Kuxi2
global Kuxi3



    Kuxi_x   = 0;   set(handles.Screen_Kuxi_X,'string',Kuxi_x);
    Kuxi_y   = 0;   set(handles.Screen_Kuxi_Y,'string',Kuxi_y);
    Kuxi_sp  = 0;   set(handles.Screen_Kuxi_SP,'string',Kuxi_sp);
    f        = 0;   set(handles.Screen_f,'string',f);
    Gw       = 0;   set(handles.Screen_Gw,'string',Gw);
    Gr       = 0;   set(handles.Screen_Gr,'string',Gr);
    Kuxi1    = 0;   set(handles.Screen_Kuxi1,'string',Kuxi1);
    Kuxi2    = 0;   set(handles.Screen_Kuxi2,'string',Kuxi2);
    Kuxi3    = 0;   set(handles.Screen_Kuxi3,'string',Kuxi3);
    FfN1     = 0;   set(handles.Screen_Formul,'string',FfN1);
    FfN2     = 0;   set(handles.Screen_Formul,'string',FfN2);
    Ratio    = 0;   set(handles.Screen_Ratio,'string',Ratio);
    Sig      = 0;   set(handles.Screen_Sigma2,'string',Sig);
    Phi1     = 0;   set(handles.Screen_Phi1,'string',Phi1);
    Phi2     = 0;   set(handles.Screen_Phi2,'string',Phi2);  

cla(handles.axes4,'reset')
cla(handles.axes5,'reset')


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject,eventdata,handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global ptnum 
    global ptnum_R1
    global ptnum_R1pr
    global ptnum_R2
    global ptnum_R2pr
    global ptnum_Sw
    global ptnum_Sr
    global ptnum_Ew
    global ptnum_Er 
    global ptnum_Phi
    
    global Kuxi_x
    global Kuxi_y
    global Kuxi_sp
    global f
    global Gw
    global Gr

    ptnum       = 40000;   set(handles.Screen_N,'string',ptnum);
    ptnum_R1    = 0.460;   set(handles.Screen_R1,'string',ptnum_R1);
    ptnum_R1pr  = 0.330;   set(handles.Screen_R1pr,'string',ptnum_R1pr);
    ptnum_R2    = 10000000000;   set(handles.Screen_R2,'string',ptnum_R2);
    ptnum_R2pr  = 0.254;   set(handles.Screen_R2pr,'string',ptnum_R2pr);
    ptnum_Sw    = 0.27;   set(handles.Screen_Sw,'string',ptnum_Sw);
    ptnum_Sr    = 0.3;   set(handles.Screen_Sr,'string',ptnum_Sr);
    ptnum_Ew    = 200;   set(handles.Screen_Ew,'string',ptnum_Ew);
    ptnum_Er    = 200;   set(handles.Screen_Er,'string',ptnum_Er);
    ptnum_Phi   = 2.862;   set(handles.Screen_Phi,'string',ptnum_Phi);
    
    Kuxi_x   = 0.90;   set(handles.Screen_Kuxi_X,'string',Kuxi_x);
    Kuxi_y   = 0.02;   set(handles.Screen_Kuxi_Y,'string',Kuxi_y);
    Kuxi_sp  = 0.001;   set(handles.Screen_Kuxi_SP,'string',Kuxi_sp);
    f        = 0.78;   % 0.05 ~ 0.78 range
                       set(handles.Screen_f,'string',f);
    Gw       = 79.3;   set(handles.Screen_Gw,'string',Gw);
    Gr       = 79.3;   set(handles.Screen_Gr,'string',Gr);
   


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject,eventdata,handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global COMPARE Kuxi3

f = str2double(get(handles.Screen_f,'string'));
TT = Kuxi3;

plot(handles.axes4,TT,COMPARE.a(:,1)',TT,COMPARE.b(:,1)','r-');
legend(handles.axes4,'Johnson & Vermeulen','Kalker',4);
axis(handles.axes4,[0, Kuxi3(:,100),0, 1.2*max(COMPARE.a(:,1))]);
xlabel(handles.axes4, '\xi_x');
ylabel(handles.axes4, 'F/fN');

plot(handles.axes5,TT,COMPARE.a(:,1)'.*f,TT,COMPARE.b(:,1)'.*f,'r-');
legend(handles.axes5,'Johnson & Vermeulen','Kalker',4);
axis(handles.axes5,[0, Kuxi3(:,100),0, 1.2*max(COMPARE.a(:,1))]);
xlabel(handles.axes5, '\xi_x');
ylabel(handles.axes5, 'F/N');



function Screen_Ratio_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_Ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_Ratio as text
%        str2double(get(hObject,'String')) returns contents of Screen_Ratio as a double


% --- Executes during object creation, after setting all properties.
function Screen_Ratio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_Ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_Sigma2_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_Sigma2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_Sigma2 as text
%        str2double(get(hObject,'String')) returns contents of Screen_Sigma2 as a double


% --- Executes during object creation, after setting all properties.
function Screen_Sigma2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_Sigma2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_Phi1_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_Phi1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_Phi1 as text
%        str2double(get(hObject,'String')) returns contents of Screen_Phi1 as a double


% --- Executes during object creation, after setting all properties.
function Screen_Phi1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_Phi1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_Phi2_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_Phi2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_Phi2 as text
%        str2double(get(hObject,'String')) returns contents of Screen_Phi2 as a double


% --- Executes during object creation, after setting all properties.
function Screen_Phi2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_Phi2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Screen_K1_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_K1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_K1 as text
%        str2double(get(hObject,'String')) returns contents of Screen_K1 as a double


% --- Executes during object creation, after setting all properties.
function Screen_K1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_K1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_K2_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_K2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_K2 as text
%        str2double(get(hObject,'String')) returns contents of Screen_K2 as a double


% --- Executes during object creation, after setting all properties.
function Screen_K2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_K2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_K3_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_K3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_K3 as text
%        str2double(get(hObject,'String')) returns contents of Screen_K3 as a double


% --- Executes during object creation, after setting all properties.
function Screen_K3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_K3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_K4_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_K4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_K4 as text
%        str2double(get(hObject,'String')) returns contents of Screen_K4 as a double


% --- Executes during object creation, after setting all properties.
function Screen_K4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_K4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_Theta_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_Theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_Theta as text
%        str2double(get(hObject,'String')) returns contents of Screen_Theta as a double


% --- Executes during object creation, after setting all properties.
function Screen_Theta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_Theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_aa_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_aa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_aa as text
%        str2double(get(hObject,'String')) returns contents of Screen_aa as a double


% --- Executes during object creation, after setting all properties.
function Screen_aa_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_aa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_bb_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_bb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_bb as text
%        str2double(get(hObject,'String')) returns contents of Screen_bb as a double


% --- Executes during object creation, after setting all properties.
function Screen_bb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_bb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_Kuxi_X_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_Kuxi_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_Kuxi_X as text
%        str2double(get(hObject,'String')) returns contents of Screen_Kuxi_X as a double


% --- Executes during object creation, after setting all properties.
function Screen_Kuxi_X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_Kuxi_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_Kuxi_Y_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_Kuxi_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_Kuxi_Y as text
%        str2double(get(hObject,'String')) returns contents of Screen_Kuxi_Y as a double


% --- Executes during object creation, after setting all properties.
function Screen_Kuxi_Y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_Kuxi_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_Kuxi_SP_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_Kuxi_SP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_Kuxi_SP as text
%        str2double(get(hObject,'String')) returns contents of Screen_Kuxi_SP as a double


% --- Executes during object creation, after setting all properties.
function Screen_Kuxi_SP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_Kuxi_SP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_f_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_f as text
%        str2double(get(hObject,'String')) returns contents of Screen_f as a double


% --- Executes during object creation, after setting all properties.
function Screen_f_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_Gw_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_Gw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_Gw as text
%        str2double(get(hObject,'String')) returns contents of Screen_Gw as a double


% --- Executes during object creation, after setting all properties.
function Screen_Gw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_Gw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_Gr_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_Gr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_Gr as text
%        str2double(get(hObject,'String')) returns contents of Screen_Gr as a double


% --- Executes during object creation, after setting all properties.
function Screen_Gr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_Gr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_Kuxi1_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_Kuxi1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_Kuxi1 as text
%        str2double(get(hObject,'String')) returns contents of Screen_Kuxi1 as a double


% --- Executes during object creation, after setting all properties.
function Screen_Kuxi1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_Kuxi1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_Kuxi2_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_Kuxi2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_Kuxi2 as text
%        str2double(get(hObject,'String')) returns contents of Screen_Kuxi2 as a double


% --- Executes during object creation, after setting all properties.
function Screen_Kuxi2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_Kuxi2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Screen_Formul_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_Formul (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_Formul as text
%        str2double(get(hObject,'String')) returns contents of Screen_Formul as a double


% --- Executes during object creation, after setting all properties.
function Screen_Formul_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_Formul (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_Kuxi3_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_Kuxi3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_Kuxi3 as text
%        str2double(get(hObject,'String')) returns contents of Screen_Kuxi3 as a double


% --- Executes during object creation, after setting all properties.
function Screen_Kuxi3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_Kuxi3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Screen_mm_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_mm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_mm as text
%        str2double(get(hObject,'String')) returns contents of Screen_mm as a double


% --- Executes during object creation, after setting all properties.
function Screen_mm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_mm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_nn_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_nn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_nn as text
%        str2double(get(hObject,'String')) returns contents of Screen_nn as a double


% --- Executes during object creation, after setting all properties.
function Screen_nn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_nn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_N_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_N as text
%        str2double(get(hObject,'String')) returns contents of Screen_N as a double


% --- Executes during object creation, after setting all properties.
function Screen_N_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_R1_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_R1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_R1 as text
%        str2double(get(hObject,'String')) returns contents of Screen_R1 as a double


% --- Executes during object creation, after setting all properties.
function Screen_R1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_R1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_R1pr_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_R1pr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_R1pr as text
%        str2double(get(hObject,'String')) returns contents of Screen_R1pr as a double


% --- Executes during object creation, after setting all properties.
function Screen_R1pr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_R1pr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_R2_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_R2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_R2 as text
%        str2double(get(hObject,'String')) returns contents of Screen_R2 as a double


% --- Executes during object creation, after setting all properties.
function Screen_R2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_R2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_R2pr_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_R2pr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_R2pr as text
%        str2double(get(hObject,'String')) returns contents of Screen_R2pr as a double


% --- Executes during object creation, after setting all properties.
function Screen_R2pr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_R2pr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_Sw_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_Sw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_Sw as text
%        str2double(get(hObject,'String')) returns contents of Screen_Sw as a double


% --- Executes during object creation, after setting all properties.
function Screen_Sw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_Sw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_Sr_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_Sr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_Sr as text
%        str2double(get(hObject,'String')) returns contents of Screen_Sr as a double


% --- Executes during object creation, after setting all properties.
function Screen_Sr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_Sr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_Ew_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_Ew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_Ew as text
%        str2double(get(hObject,'String')) returns contents of Screen_Ew as a double


% --- Executes during object creation, after setting all properties.
function Screen_Ew_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_Ew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_Er_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_Er (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_Er as text
%        str2double(get(hObject,'String')) returns contents of Screen_Er as a double


% --- Executes during object creation, after setting all properties.
function Screen_Er_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_Er (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Screen_Phi_Callback(hObject, eventdata, handles)
% hObject    handle to Screen_Phi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Screen_Phi as text
%        str2double(get(hObject,'String')) returns contents of Screen_Phi as a double


% --- Executes during object creation, after setting all properties.
function Screen_Phi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Screen_Phi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function varargout = PlotPaths(varargin)

% Begin initialization code 
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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
% End initialization code 


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
kappa=2;
theta=1;
sigma=.4;
X0=1;
n=1000;
m=7;
W=randn(n,m);
X=zeros(n,m);
X(1,:)=X0;

t=[0:1/n:1];

for j=1:m
    for i=1:n
        X(i+1,j)=X(i,j)+kappa*(theta-X(i,j))/n+sigma*W(i,j)/sqrt(n);
    end
end
plot(t,X)
xlabel('$t$','interpreter','latex','FontSize',14)
ylabel('$r_t$','interpreter','latex','FontSize',14)
title('$Some~Vasicek~Paths~:~~dr_{t}=\kappa(\theta-r_{t})dt+\sigma dW_{t}$','interpreter','latex','FontSize',14)
axis([0 1 0 2])


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
kappa=2;
theta=1;
sigma=.4;
X0=1;
n=1000;
m=7;
W=randn(n,m);
X=zeros(n,m);
X(1,:)=X0;
t=[0:1/n:1];
for j=1:m
    for i=1:n
        X(i+1,j)=X(i,j)+kappa*(theta-X(i,j))/n+sigma*sqrt(X(i,j))*W(i,j)/sqrt(n);
    end
end
plot(t,X)
xlabel('$t$','interpreter','latex','FontSize',14)
ylabel('$r_t$','interpreter','latex','FontSize',14)
title('$Some~Cox.Ingersoll.Ross~Paths~:~~dr_t=\kappa(\theta-r_t)dt+\zeta \sqrt{r_t} dW_t$','interpreter','latex','FontSize',14)
axis([0 1 0 2])


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

n=1000;
m=50;
X0=ones(1,m);
r=0.35;
sigma=.25;
X=[X0;1+r/n+sigma*sqrt(1/n)*randn(n,m)];
t=[0:1/n:1];
Xt=cumprod(X);
plot(t,Xt)
xlabel('$t$','interpreter','latex','FontSize',13)
ylabel('$X_t$','interpreter','latex','FontSize',13)
title('$Geometric ~Brownian ~Motion~:~~dX_t=r X_t dt+ \sigma X_t dW_t$','interpreter','latex','FontSize',13)
axis([0 1 0 3])


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

n=1000;
m=50;
X0=zeros(1,m);
r=0.05;
sigma=.2;
X=[X0;r/n+sigma*sqrt(1/n)*randn(n,m)];
Xt=cumsum(X);
t=[0:1/n:1];
plot(t,Xt)
xlabel('$t$','interpreter','latex','FontSize',13)
ylabel('$X_t$','interpreter','latex','FontSize',13)
title('$Arithmetic ~Brownian ~Motion~:~~dX_t=r dt+ \sigma dW_t$','interpreter','latex','FontSize',13)
axis([0 1 -1 1])


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

n=1000;
m=20;
X0=zeros(1,m);
sigma=.35;
X=[X0;sigma*sqrt(1/n)*randn(n,m)];
Xt=cumsum(X);
Y=[X0;repmat(Xt(n+1,:),n,1)/n];
Yt=cumsum(Y);
Z=Xt-Yt;
t=[0:1/n:1];
plot(t,Z)
xlabel('$t$','interpreter','latex','FontSize',13)
ylabel('$B_t$','interpreter','latex','FontSize',13)
title('$~Brownian ~Bridge~:~~B(t)=W(t)- \frac{t}{T} W(T)$','interpreter','latex','FontSize',13)
axis([0 1 -1 1])


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

n=1000;
m=5;
X0=zeros(1,m);
sigma=.3;
X=[X0;sigma*sqrt(1/n)*randn(n,m)];
Y=[X0;sigma*sqrt(1/n)*randn(n,m)];
Xt=cumsum(X);
Yt=cumsum(Y);
t=[0:1/n:1];
plot(Xt,Yt)
xlabel('$W_x(t)$','interpreter','latex','FontSize',13)
ylabel('$W_y(t)$','interpreter','latex','FontSize',13)
title('$2~Dimension ~Brownian ~Motion~:~~\vec{W}(t)=(W_x(t)~~W_y(t))$','interpreter','latex','FontSize',13)
axis([-1 1 -1 1])


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

n=1000;
m=5;
X0=zeros(1,m);
sigma=.4;
X=[X0;sigma*sqrt(1/n)*randn(n,m)];
Y=[X0;sigma*sqrt(1/n)*randn(n,m)];
Z=[X0;sigma*sqrt(1/n)*randn(n,m)];
Xt=cumsum(X);
Yt=cumsum(Y);
Zt=cumsum(Z);
t=[0:1/n:1];
plot3(Xt,Yt,Zt)
grid on
xlabel('$W_x(t)$','interpreter','latex','FontSize',13)
ylabel('$W_y(t)$','interpreter','latex','FontSize',13)
zlabel('$W_z(t)$','interpreter','latex','FontSize',13)
title('$3~Dimension ~Brownian ~Motion~:~~\vec{W}(t)=(W_x(t)~~W_y(t)~~W_z(t))$','interpreter','latex','FontSize',13)
axis([-1 1 -1 1 -1 1])


% Rodolphe Sitter

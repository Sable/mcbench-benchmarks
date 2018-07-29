function varargout = PlateVib(varargin)
% The following code was made in 2007 for a class project. It was based on 
% a letter written by J. P. Arenas for the editor of Journal of Sound and 
% Vibration (2003), which has the title: “On the vibration analysis of 
% rectangular clamped plates using the virtual work principle.” 
%
% Before using the code for calculating plate transverse displacement, 
% there are several basic assumptions that should be considered:
% 1. The plate is rectangular, thin, and perfectly flat.
% 2. The plate is isotropic and undamped. 
% 3. The plate is subjected to a harmonic point excitation at (x,y). 
% 4. All of the plate sides are clamped.
%
% As usual, I am using a very plain way in writing the code. Comments are
% given here and there for making code easy to understand. I will try to  
% provide more explanation on the equations and the code later. 
%
% Anyhow, my simple wish is that someone could find the code useful :)
%
%
% Thank you.
%
% Developed by Agustinus Oey <oeyaugust@gmail.com>                        
% Center of Noise and Vibration Control (NoViC)                           
% Department of Mechanical Engineering                                    
% Korea Advanced Institute of Science and Technology (KAIST)              
% Daejeon, South Korea 


% ===== The following part is GUI initialization, DO NOT EDIT =============
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PlateVib_OpeningFcn, ...
                   'gui_OutputFcn',  @PlateVib_OutputFcn, ...
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
% ===== End of GUI initialization, DO NOT EDIT ============================



% ===== Matlab executes it just before PlateVib is made visible ===========
function PlateVib_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for PlateVib
handles.output = hObject;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% part of the code (1/2) %%%%%%%%%%%%%%
% Get initial data
handles.a = str2double(get(handles.edit1, 'String')); %plate width
handles.b = str2double(get(handles.edit2, 'String')); %plate length
h = str2double(get(handles.edit3, 'String'));         %plate thickness
p = str2double(get(handles.edit4, 'String'));         %volume mass density
handles.ps= h*p;                                      %surface mass density
E = str2double(get(handles.edit5, 'String'));         %Young's modulus
V = str2double(get(handles.edit6, 'String'));         %Poisson ratio
handles.B = E*h^3/(1-V^2)/12;                         %bending stifness
handles.F = str2double(get(handles.edit7, 'String')); %force amplitude
handles.x = str2double(get(handles.edit8, 'String')); %x; excitation point  
handles.y = str2double(get(handles.edit9, 'String')); %y; excitation point
handles.f = str2double(get(handles.edit10,'String')); %excitation frequency
handles.ud= 20;                                       %tilting angle  
handles.lr= 40;                                       %panning angle

% Calculate plate vibration
[handles.xs, handles.ys, handles.en]=get_vib(handles);

% Draw plate vibration
plot_vib(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end of this part (1/2) %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update handles structure
guidata(hObject, handles);


% ===== Another generic function assigned by Matlab ========================
function varargout = PlateVib_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;


% ==== Function for creating and handling callback from object edit1 ======
function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ==== Function for creating and handling callback from object edit2 ======
function edit2_Callback(hObject, eventdata, handles)

function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ==== Function for creating and handling callback from object edit3 ======
function edit3_Callback(hObject, eventdata, handles)

function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ==== Function for creating and handling callback from object edit4 ======
function edit4_Callback(hObject, eventdata, handles)

function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ==== Function for creating and handling callback from object edit5 ======
function edit5_Callback(hObject, eventdata, handles)

function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ==== Function for creating and handling callback from object edit6 ======
function edit6_Callback(hObject, eventdata, handles)

function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ==== Function for creating and handling callback from object edit7 ======
function edit7_Callback(hObject, eventdata, handles)

function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ==== Function for creating and handling callback from object edit8 ======
function edit8_Callback(hObject, eventdata, handles)

function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ==== Function for creating and handling callback from object edit9 ======
function edit9_Callback(hObject, eventdata, handles)

function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ==== Function for creating and handling callback from object edit10 =====
function edit10_Callback(hObject, eventdata, handles)

function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ==== Function for creating and handling callback from object listbox1 ===
function listbox1_Callback(hObject, eventdata, handles)

function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% part of the code (2/2) %%%%%%%%%%%%%%
% ==== Function for moving plot orientation ===============================
function pushbutton1_Callback(hObject, eventdata, handles)
% Change the panning angle
if handles.ud < 180
    handles.lr = handles.lr+2;
end
% Fixing the graph
view([handles.lr handles.ud])
axis tight
% Update handles structure
guidata(hObject, handles);


% ==== Function for moving plot orientation ==============================
function pushbutton2_Callback(hObject, eventdata, handles)
% Change the panning angle
if handles.lr > -180
    handles.lr = handles.lr-2;
end
% Fixing the graph
view([handles.lr handles.ud])
axis tight
% Update handles structure
guidata(hObject, handles);


% ==== Function for moving plot orientation ==============================
function pushbutton3_Callback(hObject, eventdata, handles)
% Change the tilting angle
if handles.lr > -90
    handles.ud = handles.ud-2;
end
% fFixing the graph
view([handles.lr handles.ud])
axis tight
% Update handles structure
guidata(hObject, handles);


% ==== Function for moving plot orientation ==============================
function pushbutton4_Callback(hObject, eventdata, handles)
% Change the tilting angle
if handles.ud < 90
    handles.ud = handles.ud+2;
end
% Fixing the graph
view([handles.lr handles.ud])
axis tight
% Update handles structure
guidata(hObject, handles);


% ==== Function for updating calculation data ==============================
function pushbutton5_Callback(hObject, eventdata, handles)
% Get new data
handles.a = str2double(get(handles.edit1, 'String')); %width
handles.b = str2double(get(handles.edit2, 'String')); %length
h = str2double(get(handles.edit3, 'String'));         %thickness
p = str2double(get(handles.edit4, 'String'));         %volume mass density
handles.ps= h*p;                                      %surface mass density
E = str2double(get(handles.edit5, 'String'));         %Young's modulus
V = str2double(get(handles.edit6, 'String'));         %Poisson ratio
handles.B = E*h^3/(1-V^2)/12;                         %bending stifness
handles.F = str2double(get(handles.edit7, 'String')); %force amplitude
handles.x = str2double(get(handles.edit8, 'String')); %x; excitation point  
handles.y = str2double(get(handles.edit9, 'String')); %y; excitation point
handles.f = str2double(get(handles.edit10,'String')); %excitation frequency

% Recalculate plate vibration
[handles.xs, handles.ys, handles.en]=get_vib(handles);

% Redraw plate vibration
plot_vib(handles)

% Update handles structure
guidata(hObject, handles);


% ==== Function for ending the program ====================================
function pushbutton6_Callback(hObject, eventdata, handles)
delete(handles.figure1);


% ==== Function for changing the plot style
function uipanel4_SelectionChangeFcn(hObject, eventdata, handles)
plot_vib(handles)


% ==== Main function for calculating plate vibration ======================
function [xs, ys, en] =get_vib(handles)
% Define Betha
Bi=[4.73004074486270
    7.85320462409584
    10.99560783800167
    14.13716549125746
    17.27875965739948
    20.42035224562606];

% Note that betha is the roots of cosh(betha)*cos(betha)=0. Due to the data 
% precision, only the first six roots are given here.  

% Discritize the plate
if handles.a < handles.b,
    xs = linspace(0,handles.a,17);
    ys = linspace(0,handles.b,round(handles.b/handles.a*11));
else
    ys = linspace(0,handles.b,17);
    xs = linspace(0,handles.a,round(handles.a/handles.b*11));
end
xn=length(xs);           %number of discrete nodes, horizontal
yn=length(ys);           %number of discrete nodes, vertical

% Set some buffer and start the iteration
en=zeros(xn,yn);         %plate normal displacement
Wo=char(ones(40,35)*32); %list of non-dimensional frequency parameters
for m=1:6,               %vibration mode, horizontal, max. 6
    for n=1:6,           %vibration mode, vertical, max. 6
        % Calculate shape function corresponds to the excitation force
        tmp=Bi(m)*handles.x/handles.a;
        Vm=Jfun(tmp)-Jfun(Bi(m))*Hfun(tmp)/Hfun(Bi(m));
        tmp=Bi(n)*handles.y/handles.b;
        Tn=Jfun(tmp)-Jfun(Bi(n))*Hfun(tmp)/Hfun(Bi(n));
        Wf=Vm*Tn;

        % Calculate shape function corresponds to the excited node
        dum=zeros(xn,yn);
        for xx=1:xn,     %discrete node, horizontal
            for yy=1:yn, %discrete node, vertical
                tmp=Bi(m)*xs(xx)/handles.a;
                Vm=Jfun(tmp)-Jfun(Bi(m))*Hfun(tmp)/Hfun(Bi(m));
                tmp=Bi(n)*ys(yy)/handles.b;
                Tn=Jfun(tmp)-Jfun(Bi(n))*Hfun(tmp)/Hfun(Bi(n));
                dum(xx,yy)=Vm*Tn;
            end
        end
        
        % Calculate intermediate functions        
        Lm=Lfun(Bi(m));
        Rm=Rfun(Bi(m));        
        Ln=Lfun(Bi(n));
        Rn=Rfun(Bi(n));
        
        % Calculate denominator functions        
        I3I4 = Bi(m)*Bi(n)*Rm*Rn/handles.a/handles.b;
        I2I6 = handles.a*handles.b*Lm*Ln/Bi(m)/Bi(n);
        I1I2 = I2I6*(Bi(m)/handles.a)^4;
        I5I6 = I2I6*(Bi(n)/handles.b)^4;
        
        % Calculate denominator
        tmp=I1I2 + 2*I3I4 + I5I6;
        denum=handles.B*tmp - (2*pi*handles.f)^2*handles.ps*I2I6;
        
        % Calculate displacement
        en=en+dum*Wf/denum;

        % Calculate and list the dimensionless frequency parameters
        tmp=num2str(sqrt(tmp/I2I6)*handles.a^2,'%1.2f');
        Wo(m*6+n-2,6 ) = num2str(m);
        Wo(m*6+n-2,12) = num2str(n);
        Wo(m*6+n-2,30-length(tmp):29) = tmp;
    end
end
en=handles.F*en.';

% Put a header on the list
Wo(1,:)='Non-dimensional frequency parameter';
Wo(3,:)='    m     n      calculated value  ';
Wo(4,:)='-----------------------------------';

% Show the list
set(handles.listbox1,'String',Wo)


% ==== The following 4 functions are belong to function get_vib ===========
function out=Jfun(in)
out=cosh(in)-cos(in);


function out=Hfun(in)
out=sinh(in)-sin(in);


function out=Lfun(in)
Di=Jfun(in)/Hfun(in);
out=(1+Di*Di)*sinh(2*in)/4 + sinh(in)*(2*Di*sin(in)-(1-Di*Di)*cos(in)) ...
    - (1+Di*Di)*sin(in)*cosh(in) + (1-Di*Di)*sin(in)*cos(in)/2 + in ...
    - Di*(1+cosh(2*in))/2 + Di*cos(in)*cos(in);


function out=Rfun(in)
Di=Jfun(in)/Hfun(in);
out=(1+Di*Di)*sinh(2*in)/4 - Di*cosh(2*in)/2 - (1-Di*Di)*sin(in)*cos(in)/2 ...
    - Di*cos(in)*cos(in) - Di*Di*in + 3*Di/2;


% ==== Function for showing calculation result ============================
function plot_vib(handles)
% Check plot style
if get(handles.radiobutton2,'Value'),
    mesh(handles.xs, handles.ys, handles.en)
elseif get(handles.radiobutton3,'Value'),
    surfl(handles.xs, handles.ys, handles.en)
elseif get(handles.radiobutton4,'Value'),
    meshc(handles.xs, handles.ys, handles.en)
else    
    surf(handles.xs, handles.ys, handles.en)
end
    
% Decorate with labels
xlabel('x (m)')
ylabel('y (m)')
zlabel('displacement (m)')

% Fixing the plot
view([handles.lr handles.ud])
axis tight
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end of this part (2/2) %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
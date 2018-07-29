function varargout = ALLMORTGAGEF(varargin)
% ALLMORTGAGEF M-file for ALLMORTGAGEF.fig
%      ALLMORTGAGEF, by itself, creates a new ALLMORTGAGEF or raises the existing
%      singleton*.
%
%      H = ALLMORTGAGEF returns the handle to a new ALLMORTGAGEF or the handle to
%      the existing singleton*.
%
%      ALLMORTGAGEF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ALLMORTGAGEF.M with the given input arguments.
%
%      ALLMORTGAGEF('Property','Value',...) creates a new ALLMORTGAGEF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ALLMORTGAGEF_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ALLMORTGAGEF_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help ALLMORTGAGEF

% Last Modified by GUIDE v2.5 11-Jul-2005 10:50:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ALLMORTGAGEF_OpeningFcn, ...
                   'gui_OutputFcn',  @ALLMORTGAGEF_OutputFcn, ...
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


% --- Executes just before ALLMORTGAGEF is made visible.
function ALLMORTGAGEF_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ALLMORTGAGEF (see VARARGIN)

% Choose default command line output for ALLMORTGAGEF
handles.output = hObject;

guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes ALLMORTGAGEF wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ALLMORTGAGEF_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function Purchase_Price_Callback(hObject, eventdata, handles)
% hObject    handle to Purchase_Price (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Purchase_Price as text
%        str2double(get(hObject,'String')) returns contents of Purchase_Price as a double

handles.Data.Purchase_Price = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Purchase_Price_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Purchase_Price (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Down_Payment_Callback(hObject, eventdata, handles)
% hObject    handle to Down_Payment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Down_Payment as text
%        str2double(get(hObject,'String')) returns contents of Down_Payment as a double

handles.Data.Down_Payment = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Down_Payment_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Down_Payment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Interest_Rate_Callback(hObject, eventdata, handles)
% hObject    handle to Interest_Rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Interest_Rate as text
%        str2double(get(hObject,'String')) returns contents of Interest_Rate as a double

handles.Data.Interest_Rate = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Interest_Rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Interest_Rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Loan_Period_Callback(hObject, eventdata, handles)
% hObject    handle to Loan_Period (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Loan_Period as text
%        str2double(get(hObject,'String')) returns contents of Loan_Period as a double

handles.Data.Loan_Period = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Loan_Period_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Loan_Period (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Monthly_Payment_Callback(hObject, eventdata, handles)
% hObject    handle to Monthly_Payment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Monthly_Payment as text
%        str2double(get(hObject,'String')) returns contents of Monthly_Payment as a double

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Main Calculation Code%%%%%%%%%%%%%%%%%%%%%%%
InterestRate = handles.Data.Interest_Rate;
DownPay = str2double(get(handles.Down_Payment,'String'));
Loan_Amount = handles.Data.Purchase_Price - DownPay;
Loan_Period = handles.Data.Loan_Period;

J = InterestRate ./(12*100);            % interest in decimal
N = 12 * Loan_Period;                   % number of months
M = Loan_Amount * (J./(1-(1+J).^(-N)));	% initial month payment
set(handles.Monthly_Payment,'String',num2str(M));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%Different Interest Rates Code%%%%%%%%%%%%%%%%%%
k = InterestRate:-0.20:(InterestRate-1);
J1 = k ./(12*100);            % interest in decimal
N1 = 12 * Loan_Period;                   % number of months
M1 = Loan_Amount * (J1./(1-(1+J1).^(-N1)));	% initial month payment
  
set(handles.text6,'String',num2str(M1(1)));set(handles.IR1,'String',num2str(InterestRate));
set(handles.text7,'String',num2str(M1(2)));set(handles.IR2,'String',num2str(InterestRate - 0.2));
set(handles.text8,'String',num2str(M1(3)));set(handles.IR3,'String',num2str(InterestRate - 0.4));
set(handles.text9,'String',num2str(M1(4)));set(handles.IR4,'String',num2str(InterestRate - 0.6));
set(handles.text10,'String',num2str(M1(5)));set(handles.IR5,'String',num2str(InterestRate - 0.8));
set(handles.text11,'String',num2str(M1(6)));set(handles.IR6,'String',num2str(InterestRate - 1.0));

k2 = InterestRate:0.20:(InterestRate+1);
J2 = k2 ./(12*100);                             % interest in decimal
N2 = 12 * Loan_Period;                          % number of months
M2 = Loan_Amount * (J2./(1-(1+J2).^(-N2))); 	% initial month payment
   
set(handles.text12,'String',num2str(M2(1)));set(handles.IR7,'String',num2str(InterestRate));
set(handles.text13,'String',num2str(M2(2)));set(handles.IR8,'String',num2str(InterestRate + 0.2));
set(handles.text14,'String',num2str(M2(3)));set(handles.IR9,'String',num2str(InterestRate +0.4));
set(handles.text15,'String',num2str(M2(4)));set(handles.IR10,'String',num2str(InterestRate + 0.6));
set(handles.text16,'String',num2str(M2(5)));set(handles.IR11,'String',num2str(InterestRate + 0.8));
set(handles.text17,'String',num2str(M2(6)));set(handles.IR12,'String',num2str(InterestRate + 1.0));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Full Mortgage Schedule Code%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dummy = Loan_Amount;
for i = 1:N
  H = dummy*J;  	% Current Monthly Interest
  C = M-H;          % Monthly payment towards principal
  Q = dummy-C;      % Balance
 
	dummy = Q;

  index_loan(i) = dummy;
  index_interest(i) = H;
  index_principal(i) = C;
  index_balance(i) = Q;
  reduced_balance(i) = Loan_Amount - index_balance(i);
end

total_interest = sum(index_interest);
set(handles.TIV,'String',num2str(total_interest));
total_principal = sum(index_principal);
set(handles.TPV,'String',num2str(total_principal));
total = total_interest + total_principal;
set(handles.TOT,'String',num2str(total));

set(handles.edit10,'String',num2str(index_balance(12)));set(handles.edit12,'String',num2str(index_balance(12*3)));
set(handles.edit14,'String',num2str(index_balance(12*5)));set(handles.edit37,'String',num2str(index_balance(12*10)));
set(handles.edit23,'String',num2str(index_balance(12*15)));set(handles.edit38,'String',num2str(index_balance(12*20)));
set(handles.edit32,'String',num2str(index_balance(12*25)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%UITABLE Code%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[kl,mn]= size(index_loan);
MonthlyPayment = repmat(M,kl,mn);
IndPayments = [MonthlyPayment' index_interest' index_principal' index_balance' reduced_balance'];
ColNames = {'MonthlyPayment','Interest','Principal','Balance','Reduced Balance'};
t = uitable(IndPayments,ColNames,'Position',[10 20 450 250]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%Axes Plot Code%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cla;
hold on;
color_map = ['rbgrbmbrgr'];
z1 = 0;
z2 = 0;

while (z1 == 0) | (z1 > 9) | (z2 == 0) | (z2 > 9)

  z1 = fix(rand(1)*10);
  z2 = fix(rand(1)*10);

% What are the chances of get the same random number twice!? 
  if (z1 == z2)
    z1 = fix(rand(1)*10);
    z2 = fix(rand(1)*10);
  end
end
z1 = color_map(z1);
z2 = color_map(z2);
grid on;
plot(index_interest, 'color', z1);
plot(index_principal, 'color', z2);
legend('Interest Payments', 'Principal Payments');
title('Principal and Interest Curve');
xlabel('Month');
ylabel('Dollars ($)');
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
guidata(hObject, handles);







% --- Executes during object creation, after setting all properties.
function Monthly_Payment_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Monthly_Payment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton1.
function pushbutton1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)








function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function TPV_Callback(hObject, eventdata, handles)
% hObject    handle to TPV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TPV as text
%        str2double(get(hObject,'String')) returns contents of TPV as a double


% --- Executes during object creation, after setting all properties.
function TPV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TPV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TOT_Callback(hObject, eventdata, handles)
% hObject    handle to TOT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TOT as text
%        str2double(get(hObject,'String')) returns contents of TOT as a double


% --- Executes during object creation, after setting all properties.
function TOT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TOT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in Refresh.
function Refresh_Callback(hObject, eventdata, handles)
% hObject    handle to Refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initialize_gui(gcbf, handles, true);

function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit37_Callback(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit37 as text
%        str2double(get(hObject,'String')) returns contents of edit37 as a double


% --- Executes during object creation, after setting all properties.
function edit37_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit38_Callback(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit38 as text
%        str2double(get(hObject,'String')) returns contents of edit38 as a double


% --- Executes during object creation, after setting all properties.
function edit38_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'Data') && ~isreset
    return;
end
%Initialize handles String data
set(handles.Purchase_Price, 'String', 0);
set(handles.Down_Payment, 'String', 0);
set(handles.Interest_Rate, 'String', 0);
set(handles.Loan_Period, 'String', 0);
set(handles.Monthly_Payment, 'String', 0);

set(handles.text6,'String',0);set(handles.IR1,'String',0);
set(handles.text7,'String',0);set(handles.IR2,'String',0);
set(handles.text8,'String',0);set(handles.IR3,'String',0);
set(handles.text9,'String',0);set(handles.IR4,'String',0);
set(handles.text10,'String',0);set(handles.IR5,'String',0);
set(handles.text11,'String',0);set(handles.IR6,'String',0);

set(handles.text12,'String',0);set(handles.IR7,'String',0);
set(handles.text13,'String',0);set(handles.IR8,'String',0);
set(handles.text14,'String',0);set(handles.IR9,'String',0);
set(handles.text15,'String',0);set(handles.IR10,'String',0);
set(handles.text16,'String',0);set(handles.IR11,'String',0);
set(handles.text17,'String',0);set(handles.IR12,'String',0);

set(handles.edit10,'String',0);set(handles.edit12,'String',0);
set(handles.edit14,'String',0);set(handles.edit37,'String',0);
set(handles.edit23,'String',0);set(handles.edit38,'String',0);
set(handles.edit32,'String',0);

set(handles.TIV,'String',0);
set(handles.TPV,'String',0);
set(handles.TOT,'String',0);

%Initialize handles Data
handles.Data.Purchase_Price = 0;
handles.Data.Down_Payment = 0;
handles.Data.Interest_Rate = 0;
handles.Data.Loan_Period = 30;

%percents = {'0','3','5','10','15','20','25','30'};
%set(handles.listbox1,'String',percents);
t = uitable(360, 10,'Position',[10 20 450 250]);
cla;
% Update handles structure
%guidata(hObject, handles);
guidata(handles.figure1, handles);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1
        set(handles.Down_Payment,'String',0 * handles.Data.Purchase_Price);
    case 2
        set(handles.Down_Payment,'String',(3 * handles.Data.Purchase_Price) /100);
    case 3
        set(handles.Down_Payment,'String',(5 * handles.Data.Purchase_Price) /100);
    case 4
        set(handles.Down_Payment,'String',(10 * handles.Data.Purchase_Price) /100);
    case 5
        set(handles.Down_Payment,'String',(15 * handles.Data.Purchase_Price) /100);
    case 6
        set(handles.Down_Payment,'String',(20 * handles.Data.Purchase_Price) /100);
    case 7
        set(handles.Down_Payment,'String',(25 * handles.Data.Purchase_Price) /100);
    case 8
        set(handles.Down_Payment,'String',(30 * handles.Data.Purchase_Price) /100);
    case 9
        set(handles.Down_Payment,'String',(50 * handles.Data.Purchase_Price) /100);
 end
guidata(handles.figure1, handles);
% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'0%','3%','5%','10%','15%','20%','25%','30%','50%'});


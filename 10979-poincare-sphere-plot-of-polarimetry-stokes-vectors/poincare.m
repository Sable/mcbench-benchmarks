function varargout = poincare(varargin)
% poincare Application M-file for poincare.fig
%    FIG = poincare launch poincare GUI.
%    poincare('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 03-Nov-2005 19:19:12
% Author: J.M. Roth, MIT Lincoln Laboratory, jroth@ll.mit.edu

% This script plots the polarization Stokes vectors (S1, S2, S3) on a Poincare
% sphere.
% Type "poincare" at the Matlab prompt and a graphical window should pop up.
% Enter an input data file in the GUI, then click "Plot".  You can also save
% the output graph to a .jpg file.
%
% The input data file format can be modified to your instrument's output.
% Currently the format is compatible with the ThorLabs PA-430 Polarimeter.
% This data file format conforms to that produced by the above polarimeter's
% data logger application, which is part of the "polar4.exe" software provided
% for this instrument.  This software is running on a Win95 machine 
% with a Keithley DAS-1700 PCI board controlling the polarimeter.

% This plot routine uses shading to indicate where on the 3-D surface the
% data lies.  That is, if the data is on the back-side of the sphere, then
% it should be shaded; otherwise it is not shaded.  The routine behaves in
% this manner in the figure window on the screen, however, unfortunately
% there is a bug regarding this shading algorithm if the figure is printed
% (directly to a printer) or if the figure is saved to a graphical file.
% Matlab suggested that this is due to a bug in the OpenGL graphics
% renderer.  They have confirmed this bug in both Matlab 7.1 and Matlab
% 7.2.  So far I have not found a suitable workaround.  Matlab suggested
% the following items below, which I did not find to correct the problem:
% 
% "1. Use the ZBUFFER renderer to display your figure.  You can change the 
% renderer by entering the following code at the MATLAB Command Prompt:
%
% set(gcf,'Renderer','Zbuffer');
%
% This code changes the renderer for the current figure; if you have 
% multiple figures open, you can make a figure current by maximizing it and 
% then maximizing the MATLAB Command Window.
%
% 2. Nudge the magenta circle's position off the face of the sphere.  It 
% appears that the OpenGL renderer treats the circle as if it is inside 
% the surface of the sphere.  We have corrected the improper shading by 
% moving the circle away from the sphere's surface.
%
% [THREAD ID: 1-2R3S71]",
% Zach Carwile, Application Support Engineer, Technical Support Department,
% The MathWorks, Inc., Phone: (508) 647-7000 option 5 
% 
% Another way I have found to get around this problem is to use a line instead
% of a dot to plot the data; however, this joins together all the data which
% can look disjointed.



if nargin == 0  % LAUNCH GUI
%    close all
    fig = openfig(mfilename,'reuse');

    % Generate a structure of handles to pass to callbacks, and store it.
    handles = guihandles(fig);
    guidata(fig, handles);

    if nargout > 0
        varargout{1} = fig;
    end
% Generate default filename using format: YYYY-MM-DD_HHMMSS
    cl = fix(clock);
savegraph_filename = strcat('fig_poincare_',num2str(cl(1)),'-',num2str(cl(2)),'-',num2str(cl(3)),'_',num2str(cl(4)),num2str(cl(5)),num2str(cl(6)));
    savegraph_filepath = strcat('/home/jroth/',savegraph_filename);
    set(handles.edit21,'string',savegraph_filename)  % write variable to edit21
    set(handles.edit22,'string',savegraph_filepath)   % filename including path

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

    try
        if (nargout)
            [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
        else
            feval(varargin{:}); % FEVAL switchyard
        end
    catch
        disp(lasterr);
    end

end
end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and
%| sets objects' callback properties to call them through the FEVAL
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.


% --------------------------------------------------------------------
function varargout = pushbutton1_Callback(h, eventdata, handles, varargin)
format long
% Default input file
def_input_file = get(handles.edit12,'string');  % default input data filename plus path
% Specify input file
[filename1, pathname1]=uigetfile({'*.*','All files (*.*)'},'Import data [must conform to correct format]',def_input_file);
% opens dialog in present working directory (pwd)
myfile1=fullfile(pathname1, filename1);
handles.filename1 = filename1;  % filename only
handles.myfile1 = myfile1;  % filename plus path
set(handles.edit11,'string',...
    [handles.filename1])  % filename only
guidata(gcbo,handles) % store the changes
set(handles.edit12,'string',...
    [handles.myfile1])  % filename including path
guidata(gcbo,handles) % store the changes
end

% --------------------------------------------------------------------
% Specify output file name to save graph
function varargout = pushbutton2_Callback(h, eventdata, handles, varargin)
% Default output file
def_output_file = get(handles.edit22,'string');  % default input data filename plus path
% Do not include .jpg extension for now; added below in plotting function
[filename2, pathname2]=uiputfile({'*','JPEG files'},'Specify filename for plot [do not include .jpg extension]',def_output_file);
myfile2=fullfile(pathname2, filename2);
pathname2;
%     handles.filename3 = filename3;
%     set(handles.edit8,'string',...
%     [handles.filename3])
%     guidata(gcbo,handles) % store the changes

handles.filename2 = filename2;  % filename only
handles.myfile2 = myfile2;  % filename plus path
set(handles.edit21,'string',...
    [handles.filename2])  % filename only
set(handles.edit22,'string',...
    [handles.myfile2])  % filename including path
guidata(gcbo,handles) % store the changes
end

% --------------------------------------------------------------------
% Check box button to enable output file saving
% This is a boolean operation that toggles file save option
function varargout = checkbox1_Callback(h, eventdata, handles, varargin)
cur_save_val = get(handles.edit1,'string');  % get current value in edit1
if cur_save_val == 'N'
    set(handles.edit1,'string','Y')  % write variable to edit1
elseif cur_save_val == 'Y'
    set(handles.edit1,'string','N')  % write variable to edit1
end
% "Y" >> save file
% "N" = do not save file
guidata(gcbo,handles) % store the changes
end

% --------------------------------------------------------------------
% Exit button
function varargout = pushbutton4_Callback(h, eventdata, handles, varargin)
close;
end

% --------------------------------------------------------------------
% Run button
function varargout = pushbutton3_Callback(h, eventdata, handles, varargin)
format long

% Sample data taken using ThorLabs PA-430 Polarimeter
% Data file format conforms to output data file from polarimeter's data logger
% Polarimeter controlled by polar4.exe software on Win95 machine 
% using Keithley DAS-1700 PCI board
% retrieve filenames
input_filename = get(handles.edit11,'string');  % input data filename
input_file = get(handles.edit12,'string');  % input data filename plus path
savegraph_filename = get(handles.edit21,'string');  % output plot filename
savegraph_file = get(handles.edit22,'string');  % output plot filename plus path


% load data from file
M = csvread(input_file);
% Extract data from file
dat_t = M(:,1);  % time, units?
dat_0 = M(:,2);  % Stokes vector S0? ("power")
dat_1 = M(:,3);  % Stokes vector S1
dat_2 = M(:,4);  % Stokes vector S2
dat_3 = M(:,5);  % Stokes vector S3
dat_4 = M(:,6);  % DOP

% process data
%% Eliminate spurious Stokes vectors if |S|>1;
%% round off polarimeter errors to |1|
%% for ii = 1:length(dat_1)
%%     if abs(dat_1(ii))>1
%%         dat_1(ii) = round(dat_1(ii));
%%     end
%%     if abs(dat_2(ii))>1
%%         dat_2(ii) = round(dat_2(ii));
%%     end
%%     if abs(dat_3(ii))>1
%%         dat_3(ii) = round(dat_3(ii));
%%     end
%%     if abs(dat_4(ii))>1
%%         dat_4(ii) = round(dat_4(ii));
%%     end
%% end
% Stokes vectors transform to cartesian x, y, z in a simple manner:
x = dat_1;
y = dat_2;
z = dat_3;

% plot data
figure('Position',[183 70 500 600]);
%hold on;
%[X,Y,Z] = ellipsoid(0,0,0,0.95,0.95,0.95,20);  % create nearly-unit 3-D sphere with 20x20 grid; can also use "sphere(20)"
[X,Y,Z] = sphere(20);
X = X;
Y = Y;
Z = Z;
Hs = mesh(X,Y,Z,'facecolor','w','edgecolor',[0.5 0.5 0.5]);  % set grid facecolor to white
caxis([1.0 1.01]);  % set grid to appear like all one color
alpha(0.70);  % set opacity of sphere to 70%
axis equal;  % make the three axes equal so the ellipsoid looks like a sphere
set(gcf,'Renderer','opengl');
hold on;
% Draw x- and y- and z-axes
Hx = plot3([-1.5 1.5], [0 0], [0 0],'k-');
set(Hx,'linewidth',2,'linestyle','-','color','k');
ht_x = text(1.75,0,0,'+S_1','fontweight','bold','fontsize',12,'fontname','arial');
Hy = plot3([0 0], [-1.5 1.5], [0 0],'k-');
set(Hy,'linewidth',2,'linestyle','-','color','k');
ht_y = text(0.1,1.6,0,'+S_2','fontweight','bold','fontsize',12,'fontname','arial');
Hz = plot3([0 0], [0 0], [-1.5 1.5],'k-');
set(Hz,'linewidth',2,'linestyle','-','color','k');
ht_z = text(-0.05,0,1.35,'+S_3','fontweight','bold','fontsize',12,'fontname','arial');
ht_lcp = text(-0.05,0.0,1.1,'RCP','fontweight','bold','fontsize',12,'fontname','arial','color','k');
% Draw a bold circle about the equator (2*epsilon = 0)
x_e = (-1:.01:1);
for i = 1:length(x_e)
z_e(i) = 0;
y_e_p(i) = +sqrt(1 - x_e(i)^2);
y_e_n(i) = -sqrt(1 - x_e(i)^2);
end
He = plot3(x_e,y_e_p,z_e,'k-',x_e,y_e_n,z_e,'k-');
set(He,'linewidth',2,'color','k');
% Draw a bold circle about the prime meridian (2*theta = 0, 180)
y_pm = (-1:.01:1);
for i = 1:length(x_e)
x_pm(i) = 0;
z_pm_p(i) = +sqrt(1 - y_pm(i)^2);
z_pm_n(i) = -sqrt(1 - y_pm(i)^2);
end
Hpm = plot3(x_pm,y_pm,z_pm_p,'k-',x_pm,y_pm,z_pm_n,'k-');
set(Hpm,'linewidth',2,'color','k');

% Now plot the polarimetry data
H = plot3(x,y,z,'m.');
set(gca,'fontweight','bold','fontsize',12,'fontname','arial');
set(H,'markersize',15,'markeredgecolor','m','markerfacecolor','m','color','m','linewidth',0.1);
%H = plot3(x(100:120),y(100:120),z(100:120),'m-.');
%set(gca,'fontweight','bold','fontsize',12,'fontname','arial');
%set(H,'markersize',12,'markeredgecolor','m','markerfacecolor','m','color','m','linewidth',2);
view(135,20);  % change the view angle
%alpha(0.70);  % set opacity of sphere to 70%
%ylim(gca,[0 120]);
%xlabel('S1');
%ylabel('S2');
%zlabel('S3');
line_1 = 'Plot of Poincare Sphere';
line_2_1 = '(input filename: "';
line_2_2 = '")';
line_2 = [line_2_1 strrep(input_filename,'_','\_') line_2_2];
title({line_1; line_2});

%legend('data');
%line width of legend
h = findobj('type', 'axes');  % Find all sets of axes
set(h(1), 'linewidth',2)  % Making the vertical lines blend in with the background
set(h(1), 'linewidth',2)  % Making the horizontal lines blend in with the background
%set(H,'markersize',8,'color','m');

% Get info for plotting text boxes on screen
x_rng = xlim;   % range of horizontal axis
y_rng = ylim;  % range of initial right vertical axis
delta_x = x_rng(2) - x_rng(1);
delta_y = y_rng(2) - y_rng(1);

% Get start/end details
time_i = dat_t(1);
time_f = dat_t(length(dat_t));
today = datestr(date,26);  % produces format 2006/04/12
substr_1 = strcat(today,{'  '},num2str(time_i),{' (Data start)\newline'});
substr_2 = strcat(today,{'  '},num2str(time_f),{' (End)'});
dates_str = [substr_1 substr_2];
% Timestamp plot with start and stop times
ht_d = text(1.5,-1.0,-1.6, dates_str,'fontweight','bold','fontsize',10,'fontname','arial','BackgroundColor',[.7 .9 .7]);

% Save plot if user selected that option
% Default is not to save plot ('N')
cur_save_val = get(handles.edit1,'string');  % get current value in edit1
% Prevent clipping by increasing paperposition dimension
pp = get(gcf,'paperposition');
pp(4) = pp(4) + 1;
%pp(2) = pp(2) - 2.5;
set(gcf,'paperposition',pp);
if cur_save_val == 'Y'
    save_plot = [savegraph_file(1:length(savegraph_file)),'.jpg'];
    %% Save data plot to .jpg file and attach extension
    saveas(gcf,save_plot);
% Reset to N (helps prevents overwriting graph files)
    set(handles.edit1,'string','N')  % write variable to edit1
    set(handles.checkbox1,'value',0.0)  % write variable to edit1end
    guidata(gcbo,handles) % store the changes
end

end





function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double
end

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double
end

% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
end

function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


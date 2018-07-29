function varargout = StructBrowser_gui_g(varargin)
% STRUCTBROWSER_GUI_G M-file for StructBrowser_gui_g.fig
%      STRUCTBROWSER_GUI_G, by itself, creates a new STRUCTBROWSER_GUI_G or raises the existing
%      singleton*.
%
%      H = STRUCTBROWSER_GUI_G returns the handle to a new STRUCTBROWSER_GUI_G or the handle to
%      the existing singleton*.
%
%      STRUCTBROWSER_GUI_G('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STRUCTBROWSER_GUI_G.M with the given input arguments.
%
%      STRUCTBROWSER_GUI_G('Property','Value',...) creates a new STRUCTBROWSER_GUI_G or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StructBrowser_gui_g_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StructBrowser_gui_g_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% StructBrowser_gui v1.1: GUI to be called by the srcipt StructBrowser_g to
% browse all the structures in the worlspace.

% Last Modified by GUIDE v2.5 16-May-2003 16:46:00

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% H.Lahdili,(hassan.lahdili@crc.ca)
% Communications Research Centre (CRC) | Advanced Audio Systems (AAS)
% www.crc.ca | www.crc.ca/aas
% Ottawa. Canada
%
% CRC Advanced Audio Systems - Ottawa © 2002-2003
% 30/04/2003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StructBrowser_gui_g_OpeningFcn, ...
                   'gui_OutputFcn',  @StructBrowser_gui_g_OutputFcn, ...
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


% --- Executes just before StructBrowser_gui_g is made visible.
function StructBrowser_gui_g_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to StructBrowser_gui_g (see VARARGIN)

% Choose default command line output for StructBrowser_gui_g
handles.output = hObject;

% copy varargin contents to figure's handles
sz_argin = size(varargin{:},2);

struct_names = {};
struct_values = {};
for I = 1:sz_argin
    struct_names{I} = varargin{:}{1, I};
    struct_values{I} = varargin{:}{2, I};
    if isstruct(struct_values{I})
        struct_names{I} = strcat('+', struct_names{I});
    end
end
% Populate the Structure listbox
set(handles.listbox1,'string',struct_names)

% save structures names and values to handles
handles.struct_names = struct_names';
handles.struct_values = struct_values';
set(handles.figure1, 'Name', 'CRC StructBrowser')
logo = load ('Stbrowser');
image(logo.A, 'Parent', handles.logo_axes);
set(handles.logo_axes, 'Visible', 'off')
% Update handles structure
guidata(hObject, handles);

% update_listbox(handles)
set(handles.listbox1,'Value',[])
set(handles.disp_struct_listbox,'Value',[])
% UIWAIT makes StructBrowser_gui_g wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = StructBrowser_gui_g_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
% list_struct = get(hObject,'String');
index_struct = get(hObject,'Value');
struct_names = handles.struct_names;
struct_values = handles.struct_values; 

indent = '       ';

if size(index_struct,2) == 1   %%%%% % If one item is selected in the listbox %%%%%%%%%%%%%
    set(handles.subplot_radiobutton, 'Enable', 'off')
    set(handles.holdon_radiobutton, 'Enable', 'off')
    set(handles.disp_struct_listbox, 'Enable', 'on')

    root_1 = struct_names{index_struct};
    is_indent = strfind(root_1, indent);
    if isempty(is_indent)
        set(handles.figure1, 'Name', ['CRC StructBrowser: ' struct_names{index_struct}(2:end)])
        level = 0;
    else
        level = (is_indent(end) - 1)/7 + 1;
    end
    
        
    struct_val = struct_values{index_struct};
    %%%%%%
    struct_size = size(struct_val);
    
    if isstruct(struct_val)
        fields =  fieldnames(struct_val);
        for i = 1:length(fields)
            if isstruct(getfield(struct_val(1), fields{i}))
                fields{i} = strcat('+', fields{i});
            end
        end
        set(handles.disp_struct_listbox,'String',fields)
    end
    
    info_value = whos('struct_val');
    if (isnumeric(struct_val) & (size(struct_val,1) * size(struct_val,2) )< 4096 )
        if (size(struct_val,1) == 1 & size(struct_val,2) > 20)
            struct_val = struct_val';
        end
        str_out = num2str(struct_val);
        set(handles.disp_struct_listbox,'String',str_out)
    elseif ischar(struct_val)
        set(handles.disp_struct_listbox,'String',struct_val)
    elseif(islogical(struct_val))
        set(handles.disp_struct_listbox,'String',num2str(struct_val))
    elseif(~isstruct(struct_val))
        set(handles.disp_struct_listbox,'String','value is not a numeric value or too big !!' )
    end
  
    sz1 = num2str(info_value.size(1));
    sz2 = num2str(info_value.size(2));
    btes = num2str(info_value.bytes);
    L1 = length(sz1);
    L2 = length(sz2);
    L3 = length(btes);
    
    string_info = [space(7,0), sz1, 'x',sz2, space(31,L1+L2+1),btes, space(30,L3) , info_value.class];
    set(handles.info_struc_text, 'string', string_info)
    
    % If double-click, and is struct, expand structure, and show fields
    if (strcmp(get(handles.figure1, 'SelectionType'), 'open')) % if double click
        idxP = strfind(struct_names{ index_struct}, '+');
        idxM = strfind(struct_names{ index_struct}, '-');
        if ~isempty(idxP)
            [struct_names, struct_values] = expand_struct(struct_names, struct_values, ...
                index_struct, fields, level, idxP);
        elseif  ~isempty(idxM)
            [struct_names, struct_values] = shrink_struct(struct_names, struct_values, ...
                index_struct, fields, level, idxM);
        end
        set(handles.listbox1,'String',struct_names);
        handles.struct_names = struct_names;
        handles.struct_values = struct_values;
    end
    set(handles.info_struc_text, 'Enable', 'on')
    %%%%%%%%%%%%%%%%%%%%%%%%%% End of one item selection %%%%%%%%%%%%%
else % If more than one item is selected in the list box
    set(handles.subplot_radiobutton, 'Enable', 'on')
    set(handles.holdon_radiobutton, 'Enable', 'on')
    set(handles.disp_struct_listbox, 'Enable', 'off')
    set(handles.info_struc_text, 'Enable', 'off')
end

is_indent = [];
for k = 1:length(struct_names)
    struct_name = struct_names{k};
    is_indent = [is_indent strfind(struct_name, indent)];
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function info_struc_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to info_struc_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in info_struc_text.
function info_struc_text_Callback(hObject, eventdata, handles)
% hObject    handle to info_struc_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns info_struc_text contents as cell array
%        contents{get(hObject,'Value')} returns selected item from info_struc_text


% --- Executes during object creation, after setting all properties.
function disp_struct_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disp_struct_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in disp_struct_listbox.
function disp_struct_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to disp_struct_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns disp_struct_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from disp_struct_listbox

% check if cell elements are of class struct
function cell_array = check_if_struct(cell_array);

for i = 1:length(cell_array)
    is_struct =  evalin('base',['isstruct(',cell_array{i},')']);
    if is_struct
        cell_array(i) = strcat('+   ', cell_array(i));
    end
end



function cell_array =  indent_cell(cell_array, level)

indent = '       ';
indent_app = [];
for k = 1:level+1
    indent_app = [indent_app indent];
end
for i=1:length(cell_array)
    cell_array{i} = [indent_app cell_array{i}];
end

% expand structure if '+' is double-clicked and update the structure tree
function [struct_names, struct_values] = expand_struct(struct_names, struct_values, ...
                                                          idx, fields, level, idxP)

size_val = size(struct_values{idx});
if size_val(1) ~= 1
    struct_values{idx} = (struct_values{idx})';
end
N = size_val(2);
if N == 1 % if the structure is of size 1 x 1
    names_be = struct_names(1:idx);
    names_af = struct_names(idx + 1:length(struct_names));
    names_app = indent_cell(fields, level);
    values_be = struct_values(1:idx);
    values_af = struct_values(idx + 1:length(struct_names));
    for i = 1:length(fields)
        if (fields{i}(1) == '+' |fields{i} == '-')
            fields{i} = fields{i}(2:end);
        end
        values_app{i} = getfield(struct_values{idx}, fields{i});
    end
    
    struct_names = [names_be; names_app; names_af];
    struct_values = [values_be; values_app'; values_af];
    struct_names{idx}(idxP) = '-';
else% if the structure is of size 1 x N
    names_be = struct_names(1:idx);
    names_af = struct_names(idx + 1:length(struct_names));
    names_app = cell(N,1);
    values_app = cell(N,1);
    struct_name = struct_names{idx};
    struct_name = remove_indent2(struct_name);
    for j = 1:N
        names_app(j) = indent_cell(cellstr(strcat(struct_name,'(', num2str(j),')')), level);
    end
    values_be = struct_values(1:idx);
    values_af = struct_values(idx + 1:length(struct_names));
    for j = 1:N
        values_app{j} = struct_values{idx}(j) ;
    end
    struct_names = [names_be; names_app; names_af];
    struct_values = [values_be; values_app; values_af];
    struct_names{idx}(idxP) = '-';
end
% shrink structure if '-' is double-clicked
function [struct_names, struct_values] = shrink_struct(struct_names, struct_values,...
                                                          idx, fields, level, idxM)
struct_names{idx}(idxM) = '+';
indent = '       ';
if ((idxM-1)/7 - level) == 0
    num_steps = 0;
    is_indent_select = strfind(struct_names{idx}, indent);
    if ~isempty(is_indent_select)
        for k = idx+1 : length(struct_names)
            is_indent = strfind(struct_names{k}, indent);
            if (isempty(is_indent) | is_indent(end) - is_indent_select(end) <= 0)
                break;
            end
            num_steps = num_steps + 1;
        end
    else
        for k = idx+1 : length(struct_names)
            is_indent = strfind(struct_names{k}, indent);
            if isempty(is_indent)
                break;
            end
            num_steps = num_steps + 1;
        end
    end
else
    num_steps = length(fields);
end
names_be = struct_names(1:idx);
names_app = struct_names(idx+num_steps+1:length(struct_names));
values_be = struct_values(1:idx);
values_app = struct_values(idx+num_steps+1:length(struct_names));
struct_names = [names_be; names_app];
struct_values = [values_be; values_app];

% remove indent and '+' or '-' if exist before reading variable
function str1 = remove_indent(str0);

c = find(isspace(str0));
if ~isempty(c)
    str1 = str0(max(c)+1:end);
else
    str1 = str0;
end

if (str1(1) == '+' | str1(1) == '-')
    str1 = str1(2:end);
end

% remove indent keeping '+' and '-'
function str1 = remove_indent2(str0);

c = find(isspace(str0));
if ~isempty(c)
    str1 = str0(max(c)+1:end);
else
    str1 = str0;
end


% generate space for information text
function spc = space(L, prev_str);
spc1 = ' ';
spc = [];
for i=1:L- prev_str
    spc = [spc, spc1];
end





% --- Executes on button press in plot_pushbutton.
function plot_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to plot_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

struct_names = handles.struct_names;
struct_values = handles.struct_values;
index_struct = get(handles.listbox1,'Value');
cl_fgr_flag = get(handles.clr_fgr_radiobutton,'Value');
holdon_flag = get(handles.holdon_radiobutton,'Value');

L =  length(index_struct);
if L == 1
    value = struct_values{index_struct};
    if isnumeric(value)
        if cl_fgr_flag
            figure(10), clf,   plot(value), title(remove_indent(struct_names{index_struct}))
        else
            figure, plot(value), title(remove_indent(struct_names{index_struct}))
        end
    else
        errordlg('Not a numeric value !!', 'Plot Error')
    end
elseif L > 1
    txt = ' ';
    if cl_fgr_flag
        figure(10), clf
        if ~holdon_flag
            for j = 1:L
                figure(10), subplot(L,1,j), plot(struct_values{index_struct(j)}),...
                    ylabel(remove_indent(struct_names{index_struct(j)}))
            end
        else
            legend_list = {};
            for j = 1:L
                legend_list{j} = remove_indent(struct_names{index_struct(j)});
                figure(10), hold on, plot(struct_values{index_struct(j)}, 'color', rand(1,3))
            end
            legend(legend_list{:})
        end
    else
        figure
         if ~holdon_flag
            for j = 1:L
                subplot(L,1,j), plot(struct_values{index_struct(j)}),...
                    ylabel(remove_indent(struct_names{index_struct(j)}))
            end
        else
             legend_list = {};
            for j = 1:L
                legend_list{j} = remove_indent(struct_names{index_struct(j)});
                hold on, plot(struct_values{index_struct(j)}, 'color', rand(1,3))
            end
            legend(legend_list{:})
        end
    end
        
    
else
    errordlg(' Check your selection !!', 'Plot Error')
end


% --- Executes on button press in subplot_radiobutton.
function subplot_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to subplot_radiobutton (see GCBO)
% Hint: get(hObject,'Value') returns toggle state of subplot_radiobutton

if get(handles.holdon_radiobutton,'Value')
    set(handles.holdon_radiobutton,'Value', 0)
else
    set(hObject,'Value', 1)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in holdon_radiobutton.
function holdon_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to holdon_radiobutton (see GCBO)
% Hint: get(hObject,'Value') returns toggle state of holdon_radiobutton

if get(handles.subplot_radiobutton,'Value')
    set(handles.subplot_radiobutton,'Value', 0)
else
    set(hObject,'Value', 1)
end

% --- Executes on button press in clr_fgr_radiobutton.
function clr_fgr_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to clr_fgr_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.new_fgr_radiobutton,'Value')
    set(handles.new_fgr_radiobutton,'Value', 0)
else
    set(hObject,'Value', 1)
end

% --- Executes on button press in new_fgr_radiobutton.
function new_fgr_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to new_fgr_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.clr_fgr_radiobutton,'Value')
    set(handles.clr_fgr_radiobutton,'Value', 0)
else
    set(hObject,'Value', 1)
end


% --- Executes on button press in close_all_pushbutton.
function close_all_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to close_all_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all


% --------------------------------------------------------------------
function plot_select_menu_Callback(hObject, eventdata, handles)
% hObject    handle to plot_select_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function plot_selected_menu_Callback(hObject, eventdata, handles)
% hObject    handle to plot_selected_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_pushbutton_Callback(handles.plot_pushbutton,[], handles)

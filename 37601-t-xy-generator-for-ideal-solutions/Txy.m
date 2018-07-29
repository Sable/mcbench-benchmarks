function varargout = Txy(varargin)
% TXY MATLAB code for Txy.fig
% Owned by David H Hagan 
% v1.0 -> Original release July 22,2012
% This GUI allows the user to choose two compounds from the listbox and
% populate the fields.  After Pressure and Temperature ranges are input,
% the user can plot the Txy Diagram.  This entire program assumes the
% Raoult's law is valid, so choose the compound pairs wisely.
%

    % Updates:
        % (1) October 26, 2012 -> Fixed errors associated with database
        %                         connection

    % Last Modified by GUIDE v2.5 22-Jul-2012 15:36:41

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @Txy_OpeningFcn, ...
                       'gui_OutputFcn',  @Txy_OutputFcn, ...
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
end

% --- Executes just before Txy is made visible.
function Txy_OpeningFcn(hObject, eventdata, handles, varargin)
    load_listbox(hObject,handles);
        
%     set(handles.mmHg,'Value',1);        % sets the default pressure unit to mm Hg
%         set(handles.atm,'Value',0);
%         set(handles.MPa,'Value',0);
%      set(handles.celcius,'Value',1);
%         set(handles.kelvin,'Value',0);
%     
    set(handles.compound1,'Value',1);
        set(handles.compound2,'Value',0);
    handles.cmpd = '1';
    
    
    handles.output = hObject;
    guidata(hObject, handles);

end

% --- Outputs from this function are returned to the command line.
function varargout = Txy_OutputFcn(hObject, eventdata, handles) 
        varargout{1} = handles.output;
end

% --- Executes on button press in plot.
function plot_Callback(hObject, eventdata, handles)

    try
        if (handles.Tb1 < handles.Tb2)  % set low boiler to compound 1
            set(handles.lowBoil1,'Value',1);
            set(handles.lowBoil2,'Value',0);
            Name = char(get(handles.compoundName1,'String'));
            Name2 = char(get(handles.compoundName2,'String'));
                set(handles.lowName,'String',Name);
                set(handles.highName,'String',Name2);
            A_low = str2num(get(handles.A1,'String'));
            B_low = str2num(get(handles.B1,'String'));
            C_low = str2num(get(handles.C1,'String'));
            A_high = str2num(get(handles.A2,'String'));
            B_high = str2num(get(handles.B2,'String'));
            C_high = str2num(get(handles.C2,'String'));
            
        elseif (handles.Tb1 > handles.Tb2)  % set the low boiler to cmpd 2
            set(handles.lowBoil1,'Value',0);
            set(handles.lowBoil2,'Value',1);
            Name = char(get(handles.compoundName2,'String'));
            Name2 = char(get(handles.compoundName1,'String'));
                set(handles.lowName,'String',Name);
                set(handles.highName,'String',Name2);
            A_low = str2num(get(handles.A2,'String'));
            B_low = str2num(get(handles.B2,'String'));
            C_low = str2num(get(handles.C2,'String'));
            A_high = str2num(get(handles.A1,'String'));
            B_high = str2num(get(handles.B1,'String'));
            C_high = str2num(get(handles.C1,'String'));
        end
        
        
        P = handles.ptot;
        switch handles.Punit
            case 'mmHg'
                P  = P;
            case 'MPa'
                P = P * 760 / 1.01325;
            case 'atm'
                P = P * 760;
        end
        
        
        switch handles.Tunit
            case 'K'
                Tmin = handles.Tmin - 273.15;
                Tmax = handles.Tmax - 273.15;
            case 'C'
                Tmin = handles.Tmin;
                Tmax = handles.Tmax;
        end
        
        i = 1;
        for j=Tmin:.01:Tmax
            pvap_l(i)   = antoine(A_low,B_low,C_low,j);
            pvap_h(i)   = antoine(A_high,B_high,C_high,j);
            x_a(i)      = (P - pvap_h(i)) / (pvap_l(i) - pvap_h(i));
            y_a(i)      = (pvap_l(i) / P) * x_a(i);
            i = i + 1;
        end
        
        
        switch handles.Tunit
            case 'K'
                Tmin = handles.Tmin;
                Tmax = handles.Tmax;
                j = Tmin:.01:Tmax;
            case 'C'
                Tmin = handles.Tmin;
                Tmax = handles.Tmax;
                j = Tmin:.01:Tmax;
        end
        
        handles.x_a = x_a;
        handles.y_a = y_a;
        handles.j = j;
        
        hold on
        title('T-xy Diagram');
        xlabel(['x-y ',Name]);
        ylabel(['Temperature (',handles.Tunit,')']);
        xlim([0 1]);
        ylim([Tmin Tmax]);
        plot(x_a,j,'b');
        plot(y_a,j,'r');
        legend('x','y','Location','Best');
        hold off
        
        if (length(handles.Tsplit) > 0)
            calcSplits(handles, hObject);
        else
            length(handles.Tsplit);
        end
        
    catch
        errordlg('Something is not set correctly.  Please correct and try again.');
    end
    
    handles.output = hObject;
    guidata(hObject, handles);
end

% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
    cla
end


function Ptot_Callback(hObject, eventdata, handles)
    ptot = str2num(get(hObject,'String'));
    handles.ptot = ptot;
    
    handles.output = hObject;
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function Ptot_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on button press in mmHg.
function mmHg_Callback(hObject, eventdata, handles)
    if (get(hObject,'Value') == 1)
        handles.Punit = 'mmHg';
        set(handles.MPa,'Value',0);
        set(handles.atm,'Value',0);
    end
    
    handles.output = hObject;
    guidata(hObject, handles);

end

% --- Executes on button press in MPa.
function MPa_Callback(hObject, eventdata, handles)
    if (get(hObject,'Value') == 1)
        handles.Punit = 'MPa';
        set(handles.mmHg,'Value',0);
        set(handles.atm,'Value',0);
    end
    
    handles.output = hObject;
    guidata(hObject, handles);

end

% --- Executes on button press in atm.
function atm_Callback(hObject, eventdata, handles)
    if (get(hObject,'Value') == 1)
        handles.Punit = 'atm';
        set(handles.mmHg,'Value',0);
        set(handles.MPa,'Value',0);
    end
    
    handles.output = hObject;
    guidata(hObject, handles);

end


function Tmin_Callback(hObject, eventdata, handles)
    Tmin = str2num(get(hObject,'String'));
    handles.Tmin = Tmin;
    
    handles.output = hObject;
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function Tmin_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function Tmax_Callback(hObject, eventdata, handles)
    Tmax = str2num(get(hObject,'String'));
    handles.Tmax = Tmax;
    
    handles.output = hObject;
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function Tmax_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on button press in kelvin.
function kelvin_Callback(hObject, eventdata, handles)
    if (get(hObject,'Value') == 1)
        handles.Tunit = 'K';
        set(handles.celcius,'Value',0);
    end
    
    handles.output = hObject;
    guidata(hObject, handles);

end

% --- Executes on button press in celcius.
function celcius_Callback(hObject, eventdata, handles)
    if (get(hObject,'Value') == 1)
        handles.Tunit = 'C';
        set(handles.kelvin,'Value',0);
    end
    
    handles.output = hObject;
    guidata(hObject, handles);

end

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
    index_selected = get(hObject,'Value');
    list = get(hObject,'String');
    realID = getRealID(index_selected);
    [name,A,B,C,Tmin,Tmax,Tb] = grabData(realID,hObject,handles);
    
    try
        if (handles.cmpd == '1')
            set(handles.compoundName1,'String',name);
            set(handles.A1,'String',num2str(A));
            set(handles.B1,'String',num2str(B));
            set(handles.C1,'String',num2str(C));
            handles.Tb1 = Tb;
        elseif (handles.cmpd == '2')
            set(handles.compoundName2,'String',num2str(name));
            set(handles.A2,'String',num2str(A));
            set(handles.B2,'String',num2str(B));
            set(handles.C2,'String',num2str(C));
            handles.Tb2 = Tb;
        end
        
    catch
        errordlg('Please select either Compound 1 or Compound 2. ');
    end
   
        
    handles.output = hObject;       % load_listbox(handles);
    guidata(hObject, handles);      % Update handles structure

end

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on button press in compoundName1.
function compound1_Callback(hObject, eventdata, handles)
    if (get(hObject,'Value') == 1)
        set(handles.compound2,'Value',0);
        handles.cmpd = '1';
    end   
    handles.output = hObject;
    guidata(hObject, handles);
end

% --- Executes on button press in compound2.
function compound2_Callback(hObject, eventdata, handles)
    if (get(hObject,'Value') == 1)
        set(handles.compound1,'Value',0);
        handles.cmpd = '2';
    end   
    handles.output = hObject;
    guidata(hObject, handles);
end


function compoundName1_Callback(hObject, eventdata, handles)
    Name1 = char(get(hObject,'String'));
    handles.compoundName1 = Name1;
    
    handles.output = hObject;
    guidata(hObject, handles);
    
end

% --- Executes during object creation, after setting all properties.
function compoundName1_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function compoundName2_Callback(hObject, eventdata, handles)
    Name2 = char(get(hObject,'String'));
    handles.compoundName2 = Name2;
    
    handles.output = hObject;
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function compoundName2_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function A1_Callback(hObject, eventdata, handles)
    A1 = get(hObject,'String');
    handles.A1 = A1;
    
    handles.output = hObject;
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function A1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function A2_Callback(hObject, eventdata, handles)
    A2 = get(hObject,'String');
    handles.A2 = A2;
    
    handles.output = hObject;
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function A2_CreateFcn(hObject, eventdata, handles)
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function B1_Callback(hObject, eventdata, handles)
    B1 = get(hObject,'String');
    handles.B1 = B1;
    
    handles.output = hObject;
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function B1_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function B2_Callback(hObject, eventdata, handles)
    B2 = get(hObject,'String');
    handles.B2 = B2;
    
    handles.output = hObject;
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function B2_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function C1_Callback(hObject, eventdata, handles)
    C1 = get(hObject,'String');
    handles.C1 = C1;
    
    handles.output = hObject;
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function C1_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function C2_Callback(hObject, eventdata, handles)
    C2 = get(hObject,'String');
    handles.C2 = C2;
    
    handles.output = hObject;
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function C2_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes during object creation, after setting all properties.
function compound1_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function load_listbox(hObject,handles) 
      
        conn = database('Txy_db','','');
        setdbprefs('datareturnformat','structure'); %sets the db preferences to a structure
        query = 'SELECT ALL ID,Name FROM Txy_data ORDER BY Name';
        result = fetch(conn,query);
        close(conn);
        %The following creates a structure containing the names and ID's
        %of everything in the database
        
        data = struct([]);
        for i=1:length(result.ID)
            data(i).id =   result.ID(i);
            data(i).name = (result.Name(i));        %this is a cell
            names(i) = data(i).name;
        end
        
        handles.compounds = names;
        set(handles.listbox1,'String',handles.compounds,'Value',1); %sets the listbox text to names
        
        handles.output = hObject;
        guidata(hObject, handles);         % Update handles structure
        
end

%-- This function takes the listID and finds its correct ID in the db
function [realID] = getRealID(listID) 
 
        conn = database('Txy_db','','');
        setdbprefs('datareturnformat','structure'); %sets the db preferences to a structure
        query = 'SELECT ALL ID,Name FROM Txy_data ORDER BY Name';
        result = fetch(conn,query);
        close(conn);
        %The following creates a structure containing the names and ID's
        %of everything in the database
        
        data = struct([]);
        for i=1:length(result.ID)
            data(i).id =   result.ID(i);
            data(i).name = (result.Name(i));        %this is a cell
            names(i) = data(i).name;
        end
        
        realID = data(listID).id;
end

% -- grabData is executed once an option is chosen in the listbox
function [name,A,B,C,Tmin,Tmax,Tb] = grabData(ID,hObject,handles)
    conn = database('Txy_db','','');
    setdbprefs('datareturnformat','structure'); %sets the db preferences to a structure
    query = ['SELECT Name,A,B,C,Tmin,Tmax,Tb FROM Txy_data WHERE  ID=' num2str(ID)];  % num2str(ID)
    
    result = fetch(conn,query);         %fieldnames(result)
    close(conn);
    
    %formula = char(result.Formula);
    name = char(result.Name);
    A = result.A;
    B = result.B;
    C = result.C;
    Tmin = result.Tmin;
    Tmax = result.Tmax;
    Tb = result.Tb;
    
    
    handles.output = hObject;
    guidata(hObject, handles);  % Update handles structure
     
end


%-- This is the function that defines the Antoine equation
function [VP] = antoine(A,B,C,T)
        VP = 10.^(A - B./(T + C));
end



function Tsplit_Callback(hObject, eventdata, handles)
    Tsplit = str2num(get(hObject,'String'));
    handles.Tsplit = Tsplit;

    handles.output = hObject;
    guidata(hObject, handles);
    

end

% --- Executes during object creation, after setting all properties.
function Tsplit_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

end
% --- Executes on button press in lowBoil1.
function lowBoil1_Callback(hObject, eventdata, handles)

end

% --- Executes on button press in lowBoil2.
function lowBoil2_Callback(hObject, eventdata, handles)

end



function highName_Callback(hObject, eventdata, handles)

end

% --- Executes during object creation, after setting all properties.
function highName_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

end

function x_low_Callback(hObject, eventdata, handles)

end

% --- Executes during object creation, after setting all properties.
function x_low_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function x_high_Callback(hObject, eventdata, handles)

end
% --- Executes during object creation, after setting all properties.
function x_high_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function y_low_Callback(hObject, eventdata, handles)

end

% --- Executes during object creation, after setting all properties.
function y_low_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

end

function y_high_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function y_high_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function lowName_Callback(hObject, eventdata, handles)

end
% --- Executes during object creation, after setting all properties.
function lowName_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function calcSplits(handles, hObject)
    T = handles.Tsplit;
    xa = interp1(handles.j,handles.x_a,T);
    xb = 1 - xa;
    ya = interp1(handles.j,handles.y_a,T);
    yb = 1 - ya;
    
    set(handles.x_low,'String',xa);
    set(handles.x_high,'String',xb);
    set(handles.y_low,'String',ya);
    set(handles.y_high,'String',yb);

end

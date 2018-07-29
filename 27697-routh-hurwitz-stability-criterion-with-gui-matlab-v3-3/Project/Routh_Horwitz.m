function varargout = Routh_Horwitz(varargin)
% ROUTH_HORWITZ M-file for Routh_Horwitz.fig
%      ROUTH_HORWITZ, by itself, creates a new ROUTH_HORWITZ or raises the existing
%      singleton*.
%
%      H = ROUTH_HORWITZ returns the handle to a new ROUTH_HORWITZ or the handle to
%      the existing singleton*.
%
%      ROUTH_HORWITZ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROUTH_HORWITZ.M with the given input arguments.
%
%      ROUTH_HORWITZ('Property','Value',...) creates a new ROUTH_HORWITZ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Routh_Horwitz_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Routh_Horwitz_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Routh_Horwitz

% Last Modified by GUIDE v2.5 05-Feb-2010 14:32:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Routh_Horwitz_OpeningFcn, ...
    'gui_OutputFcn',  @Routh_Horwitz_OutputFcn, ...
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


% --- Executes just before Routh_Horwitz is made visible.
function Routh_Horwitz_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Routh_Horwitz (see VARARGIN)

% Choose default command line output for Routh_Horwitz
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Routh_Horwitz wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Routh_Horwitz_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


set(handles.input_edit,'Value',2);
set(handles.menu_help_language,'UserData',1);
set(handles.menu_file_precision,'UserData',2);

set(handles.menu_file_dispcolor_fez,'UserData',2);
set(handles.menu_file_dispcolor_fez_blue,'Checked','on');
set(handles.menu_file_dispcolor_aez,'UserData',1);
set(handles.menu_file_dispcolor_aez_red,'Checked','on');

set(handles.operation,'String','Ready');
function input_edit_Callback(hObject, eventdata, handles)
% hObject    handle to input_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_edit as text
%        str2double(get(hObject,'String')) returns contents of input_edit as a double
if get(handles.menu_help_language,'UserData')==1;
    set(handles.operation,'String','Busy...');
elseif get(handles.menu_help_language,'UserData')==2
    set(handles.operation,'String','„‘€Ê·...');
end
run cls
equstr=get(handles.input_edit,'String');
if isempty(get(handles.input_edit,'String'))
    if get(handles.menu_help_language,'UserData')==1
        errordlg('Equation not found','Equation Error');
    elseif get(handles.menu_help_language,'UserData')==2
        errordlg('„⁄«œ·Â «Ì Ì«›  ‰‘œ','Œÿ«Ì „⁄«œ·Â');
    end
    set(handles.operation,'String','');
    return
end

syms s e;

if equstr(1,1)=='['
    c=str2num(equstr);
    set(handles.input_edit,'String',poly2strs(c,'s'));
elseif equstr(1,1)~='('
    equ=sym(equstr);
    c=sym2poly(equ);
elseif isempty(findstr(equstr,'j'))==0 && equstr(1,1)=='('
    equstr=j2sq(equstr);
    equ=sym(equstr);
    c=sym2poly(equ);
    set(handles.input_edit,'String',poly2strs(c,'s'));
elseif isempty(findstr(equstr,'j')) && equstr(1,1)=='('
    equ=sym(equstr);
    c=sym2poly(equ);
    set(handles.input_edit,'String',poly2strs(c,'s'));
end

hwait=waitbar(0,'please wait...','CreateCancelBtn','cancel_exe');
setappdata(hwait,'abort',false);

n=length(c);
%recognize number of s=0 roots
n0jw=0;
nru=0;
for pun=n:-1:1
    if c(1,pun)~=0
        break;
    end
    if c(1,pun)==0
        n0jw=n0jw+1;
        c(pun)=[];
    end
    nru=nru+1;
end
if nru~=0
    set(handles.input_edit,'String',poly2strs(c,'s'));
    set(handles.factor_text,'String',sprintf('◊s^%d',nru));
end
set(handles.factor_text,'UserData',n0jw);
%end of recognize number of s=0 roots

n=length(c);
if n<=2
    if get(handles.menu_help_language,'UserData')==1
        errordlg('Equation is very simple','Equation Error');
        delete(hwait);
    elseif get(handles.menu_help_language,'UserData')==2
        errordlg('„⁄«œ·Â Ê«—œ ‘œÂ »”Ì«— ”«œÂ «” ','Œÿ«Ì „⁄«œ·Â');
        delete(hwait);
    end
    set(handles.operation,'String','');
    return
end

tab(1,:)=codd(c);
tab(2,:)=match(ceven(c),tab(1,:));
tabe=num2cell(tab);

st=1;
enable=0;
uns=0;
bou=0;
nijw=0;
nrijw=0;
w=3;

row_all_zero=[];
row_first_zero=[];
rowaz=1;
rowfz=1;
for i=2:n
    %if user click cancel button in waitbar then full it and delete then
    %return
    if getappdata(hwait,'abort')
        waitbar(n,hwait,'caceling... 100%');
        delete(hwait);
        if get(handles.menu_help_language,'UserData')==1
            set(handles.operation,'String','Canceled');
        elseif get(handles.menu_help_language,'UserData')==2
            set(handles.operation,'String','·€Ê ‘œ');
        end        
        return;
    end
    waitbar(i/n,hwait,sprintf('please wait... %d%%',round((i/n)*100)));
    %---------------------if all element of a row is zero----------------------
    if tab(i,:)==0
        row_all_zero(rowaz)=i;
        browz=clelz(csz(tab(i-1,:)));
        ebrowz=poly2sym(browz,s);
        %st is a variable for run one time
        if st==1
            %recognize number of jw roots
            rebrowz=fixz(double(solve(ebrowz)),7);
            for cun=1:length(rebrowz)
                if real(rebrowz(cun,1))==0 && imag(rebrowz(cun,1))~=0
                    nijw=nijw+1;
                end
            end
            %end of recognize number of jw roots

            %recognize number of repeated jw roots
            [numb,tek]=repeatv(rebrowz);
            zig=0;
            for sun=1:length(tek)
                if tek(1,sun)>=2 && real(numb(1,sun))==0 && imag(numb(1,sun))~=0
                    zig=zig+tek(1,sun);
                end
            end
            nrijw=zig/2;
            if samev(tek(1,:),1)==0
                uns=1;
            elseif samev(tek(1,:),1)==1
                bou=1;
            else
                uns=0;
                bou=0;
            end
            %end of recognize number of repeated jw roots
            st=2;
        end
        diffebrowz=diff(ebrowz);
        cdiffebrowz=sym2poly(diffebrowz);
        tab(i,:)=match(codd(cdiffebrowz),tab(i,:));
        rowaz=rowaz+1;
    end
    %--------------------end of all element of a row is zero-------------------

    %--------------------if the first element of a row is zero-----------------
    if tab(i,1)==0 && sum(tab(i,:))~=0
        row_first_zero(rowfz)=i;
        tabe{i,1}=e;
        q=i+1;
        for ii=i:n
            if q~=ii
                tabe(q,:)=num2cell(routh(tabe(ii-1,:),tabe(ii,:)));
            end
            tab(ii,:)=subsv(tabe(ii,:),e,0);
            if q~=n
                q=q+1;
            end
        end
        enable=1;
        rowfz=rowfz+1;
    end
    %--------------------end of first element of a row is zero-----------------

    %----------------calculate next row of table routh horwitz-----------------
    if enable==0
        if w~=i
            tab(w,:)=routh(tab(i-1,:),tab(i,:));
        end
        if w~=n
            w=w+1;
        end
        tab=fixz(tab,5);
        tabe=num2cell(tab);
    end
    %-------------end of calculate next row of table routh horwitz-------------
    if tab(i,:)==0
        enable=0;
    end
end

%-------------------recognize change sign for RHP Roots--------------------
sig=sign(tab(:,1));
for i=1:n
    if sig(i,1)==0
        sig(i,1)=1;
    end
end
w=2;
nrhp=0;
for i=1:n
    if w~=i
        sig(i,2)=sig(i,1)*sig(w,1);
        if sig(i,2)==-1
            nrhp=nrhp+1;
        end
        if  w~=n
            w=w+1;
        end
    end
end
%----------------end of recognize change sign for RHP Roots----------------


%----------------------recognize jw and LHP Roots--------------------------
%recognize number of repeated s=0 roots
nr0jw=0;
if n0jw>1
    nr0jw=n0jw;
end
%end of recognize number of repeated s=0 roots
if nru~=0
    nt=n+nru-1;
else
    nt=n-1;
end

nlhp=nt-nijw-nrhp-n0jw;
%-------------------end of recognize jw and LHP Roots----------------------
set(handles.table_ras,'UserData',tab);
delete(hwait)

%---------------------display table & number of Roots----------------------
run textl;

set(handles.alhp,'String',num2str(nlhp));
set(handles.ajw,'String',num2str(nijw));
set(handles.arhp,'String',num2str(nrhp));
set(handles.arjw,'String',num2str(nrijw));
set(handles.ac,'String',num2str(n0jw));
set(handles.arc,'String',num2str(nr0jw));
%-----------------end of display table & number of Roots-------------------

%---------------------------display Result---------------------------------
if nrhp~=0 || n0jw~=0 || uns
    if get(handles.menu_help_language,'UserData')==1
        set(handles.result,'String','system is unstable');
    elseif get(handles.menu_help_language,'UserData')==2
        set(handles.result,'String','”Ì” „ ‰«Å«Ìœ«— «” ');
    end
elseif bou
    if get(handles.menu_help_language,'UserData')==1
        set(handles.result,'String','system is boundary stable');
    elseif get(handles.menu_help_language,'UserData')==2
        set(handles.result,'String','”Ì” „ Å«Ìœ«— „—“Ì «” ');
    end
else
    if get(handles.menu_help_language,'UserData')==1
        set(handles.result,'String','system is stable');
    elseif get(handles.menu_help_language,'UserData')==2
        set(handles.result,'String','”Ì” „ Å«Ìœ«— «” ');
    end
end
%-------------------------end of display Result----------------------------
set(handles.operation,'String','');

% --- Executes during object creation, after setting all properties.

function input_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menu_file_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_help_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_file_save_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(get(handles.table_ras,'String'))
    if get(handles.menu_help_language,'UserData')==1
        errordlg('Table not found','Table Error');
    elseif get(handles.menu_help_language,'UserData')==2
        errordlg('ÃœÊ·Ì Ì«›  ‰‘œ','Œÿ«Ì ÃœÊ·');
    end
    return
end
table_routh_hurwitz=get(handles.table_ras,'UserData');
uisave('table_routh_hurwitz');


% --------------------------------------------------------------------
function menu_help_about_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.menu_help_language,'UserData')==1
    abu1='Created by: amin heidari';
    abu2=sprintf('\nIslamic Azad University Of Mahshahr');
    abu3=sprintf('\nEmail: amin_heidari66@yahoo.com');
    abu4=sprintf('\nLocation: IRAN_Khoozestan_Mahshahr');
    abu5=sprintf('\nOnly For " MIR HOSSEIN MOUSSAVI "');
    abu6=sprintf('\nWHAT NOWRUZ(PERSIAN NEW YEAR)?');
    abu7=sprintf('more information : http://www.bestirantravel.com/culture/newyear/newyear.html');
    abu8=sprintf('\nV 3.3');
    abu9=sprintf('\nSpecial Thanks :\nYair Altman  Email: altmany@gmail.com');
    abu10=sprintf('\nCopyright With Specify Name Of Resource Is Free.');
    abut=strvcat(abu1,abu2,abu3,abu4,abu5,abu6,abu7,abu8,abu9,abu10);
    msgbox(abut,'About','help');
elseif get(handles.menu_help_language,'UserData')==2
    abu1='”«“‰œÂ: «„Ì‰ ÕÌœ—Ì';
    abu2=sprintf('\nœ«‰‘ê«Â ¬“«œ «”·«„Ì Ê«Õœ „«Â‘Â—');
    abu3=sprintf('\n«Ì„Ì·: amin_heidari66@yahoo.com');
    abu4=sprintf('\n¬œ—” : «Ì—«‰_ŒÊ“” «‰_„«Â‘Â—');
    abu5=sprintf('\n›ﬁÿ »Â ⁄‘ﬁ „Ì— Õ”Ì‰ „Ê”ÊÌ');
    abu6=sprintf('\nÊ—é‰ 3.3');
    abu7=sprintf('\n ‘ﬂ— „Œ’Ê’ :\nYair Altman  Email: altmany@gmail.com');
    abu8=sprintf('\nﬂÅÌ »—œ«—Ì »« –ﬂ— „‰»⁄ »·«„«‰⁄ «” ');
    abut=strvcat(abu1,abu2,abu3,abu4,abu5,abu6,abu7,abu8);
    msgbox(abut,'œ—»«—Â','help');
end

% --------------------------------------------------------------------
function menu_file_exit_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.menu_help_language,'UserData')==1
    button=questdlg('Do you want to exit?','Exit','Yes','No','No');
    switch button
        case{'No'}
            return
        case 'Yes'
            delete(gcf);
    end
elseif get(handles.menu_help_language,'UserData')==2
    button=questdlg('„Ì ŒÊ«ÂÌœ «“ »—‰«„Â Œ«—Ã ‘ÊÌœø','Œ—ÊÃ','»·Â','ŒÌ—','ŒÌ—');
    switch button
        case{'ŒÌ—'}
            return
        case '»·Â'
            delete(gcf);
    end
end

% --------------------------------------------------------------------
function menu_file_precision_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_precision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.menu_help_language,'UserData')==1
    prompt = {'Enter precision:'};
    dlg_title = 'Set Precision';
elseif get(handles.menu_help_language,'UserData')==2
    prompt = {'Enter precision:'};
    dlg_title = ' €ÌÌ— œﬁ ';
end
num_lines = 1;
def = {num2str(get(handles.menu_file_precision,'UserData'))};
answer = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer)
    %if user click cancel button: no operation
else
    if isempty(answer{1,1})
        if get(handles.menu_help_language,'UserData')==1
            errordlg('Input not found','Input Error');
        elseif get(handles.menu_help_language,'UserData')==2
            errordlg('Ê—ÊœÌ Ì«›  ‰‘œ','Œÿ«Ì Ê—ÊœÌ');
        end
        return
    end
    set(handles.input_edit,'Value',str2num(answer{1,1}));
    set(handles.menu_file_precision,'UserData',str2num(answer{1,1}));
end

% --------------------------------------------------------------------
function menu_help_language_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help_language (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.menu_help_language,'UserData')==1
    [select,ok]=listdlg('PromptString','Select Language',...
        'SelectionMode','single',...
        'ListString',{'English','Farsi'},...
        'Name','Language Setting',...
        'ListSize',[180 40]);
elseif get(handles.menu_help_language,'UserData')==2
    [select,ok]=listdlg('PromptString','«‰ Œ«» “»«‰',...
        'SelectionMode','single',...
        'ListString',{'English','›«—”Ì'},...
        'Name',' ‰ŸÌ„«  “»«‰',...
        'ListSize',[180 40]);
end

if ok==1
    if select==1
        set(handles.menu_help_language,'UserData',1);
        %---------------change uimenu label------------------
        set(handles.menu_file,'Label','File');
        set(handles.menu_help,'Label','Help');
        set(handles.menu_tools,'Label','Tools');
        set(handles.menu_file_save,'Label','Save Table of Routh');
        set(handles.menu_file_precision,'Label','Set Precision');
        set(handles.menu_file_dispcolor,'Label','Display Row Color');
        set(handles.menu_file_dispcolor_default,'Label','Default...');

        set(handles.menu_file_dispcolor_fez,'Label','First Element Zero');
        set(handles.menu_file_dispcolor_fez_red,'Label','Red');
        set(handles.menu_file_dispcolor_fez_blue,'Label','Blue');
        set(handles.menu_file_dispcolor_fez_green,'Label','Green');
        set(handles.menu_file_dispcolor_fez_yellow,'Label','Yellow');
        set(handles.menu_file_dispcolor_fez_gray,'Label','Gray');

        set(handles.menu_file_dispcolor_aez,'Label','All Elements Zero');
        set(handles.menu_file_dispcolor_aez_red,'Label','Red');
        set(handles.menu_file_dispcolor_aez_blue,'Label','Blue');
        set(handles.menu_file_dispcolor_aez_green,'Label','Green');
        set(handles.menu_file_dispcolor_aez_yellow,'Label','Yellow');
        set(handles.menu_file_dispcolor_aez_gray,'Label','Gray');

        set(handles.menu_file_color,'Label','Color Scheme');
        set(handles.menu_file_color_blue,'Label','Blue Sky');
        set(handles.menu_file_color_nature,'Label','Nature');
        set(handles.menu_file_color_vista,'Label','Vista');
        set(handles.menu_file_color_sun,'Label','Sun');
        set(handles.menu_file_exit,'Label','Exit');

        set(handles.menu_tools_gain,'Label','Gain Finder');
        set(handles.menu_tools_solve,'Label','Solve Equation');
        set(handles.menu_tools_ltiview,'Label','LTI Viewer');
        set(handles.menu_tools_response,'Label','Response');
        set(handles.menu_tools_response_step,'Label','Step');
        set(handles.menu_tools_response_impulse,'Label','Impulse');
        set(handles.menu_tools_diagram,'Label','Diagram');
        set(handles.menu_tools_diagram_zplane,'Label','Z_plane');
        set(handles.menu_tools_diagram_rlocus,'Label','Root Locus');
        set(handles.menu_tools_diagram_nyquist,'Label','Nyquist');
        set(handles.menu_tools_diagram_bode,'Label','Bode');
        set(handles.menu_tools_diagram_nichols,'Label','Nichols');
        set(handles.menu_tools_diagram_sigma,'Label','Singular Value');


        set(handles.menu_help_help,'Label','Help');
        set(handles.menu_help_demo,'Label','Guide');
        set(handles.menu_help_demo_ex1,'Label','example 1');
        set(handles.menu_help_demo_ex2,'Label','example 2');
        set(handles.menu_help_demo_ex3,'Label','example 3');
        set(handles.menu_help_demo_ex4,'Label','example 4');
        set(handles.menu_help_language,'Label','Change Language');
        set(handles.menu_help_about,'Label','About');

        set(handles.cmenu_copy_input_edit,'Label','Copy');
        set(handles.cmenu_paste_input_edit,'Label','Paste');
        set(handles.cmenu_help_input_edit,'Label','Help');
        set(handles.cmenu_help_table_ras,'Label','Help');
        %------------end of change uimenu label--------------

        %--------------change children String----------------
        set(handles.input_text,'String','Input Equation:');
        set(handles.input_edit,'TooltipString','Equation(s)=0 or poly=>[coefficient of equation(s)=0]');
        set(handles.factor_text,'TooltipString','factor s=0 roots');
        set(handles.panel_ras,'Title','Table of Routh Hurwitz');
        set(handles.panel_root,'Title','Number Of Roots');

        set(handles.rjw,'String','Repeat jw');
        set(handles.arjw,'TooltipString','number of repeated roots on jw axis');

        set(handles.lhp,'String','LHP');
        set(handles.alhp,'TooltipString','Number of left half plane roots');

        set(handles.jw,'String','jw');
        set(handles.ajw,'TooltipString','Number of roots on jw axis');

        set(handles.rhp,'String','RHP');
        set(handles.arhp,'TooltipString','Number of right half plane roots');

        set(handles.center,'String','Center');
        set(handles.ac,'TooltipString','Number of s=0 roots');

        set(handles.rcenter,'String','Repeat Center');
        set(handles.arc,'TooltipString','Number of repeated s=0 roots');

        set(handles.panel_result,'Title','Result');
        set(handles.close,'String','Close',...
            'FontSize',8);
        %-----------end of change children String------------
    elseif select==2
        set(handles.menu_help_language,'UserData',2);
        %---------------change uimenu label------------------
        set(handles.menu_file,'Label','›«Ì·');
        set(handles.menu_help,'Label','ò„ò');
        set(handles.menu_tools,'Label','«»“«—');
        set(handles.menu_file_save,'Label','–ŒÌ—Â ¬—«ÌÂ —«À');
        set(handles.menu_file_precision,'Label',' €ÌÌ— œﬁ ');
        set(handles.menu_file_dispcolor,'Label','—‰ê ‰„«Ì‘ ”ÿ—');
        set(handles.menu_file_dispcolor_default,'Label','ÅÌ‘ ›—÷...');

        set(handles.menu_file_dispcolor_fez,'Label','«·„«‰ ﬂ·ÌœÌ ’›—');
        set(handles.menu_file_dispcolor_fez_red,'Label','ﬁ—„“');
        set(handles.menu_file_dispcolor_fez_blue,'Label','¬»Ì');
        set(handles.menu_file_dispcolor_fez_green,'Label','”»“');
        set(handles.menu_file_dispcolor_fez_yellow,'Label','“—œ');
        set(handles.menu_file_dispcolor_fez_gray,'Label','Œ«ﬂ” —Ì');

        set(handles.menu_file_dispcolor_aez,'Label','”ÿ— ﬂ«„·« ’›—');
        set(handles.menu_file_dispcolor_aez_red,'Label','ﬁ—„“');
        set(handles.menu_file_dispcolor_aez_blue,'Label','¬»Ì');
        set(handles.menu_file_dispcolor_aez_green,'Label','”»“');
        set(handles.menu_file_dispcolor_aez_yellow,'Label','“—œ');
        set(handles.menu_file_dispcolor_aez_gray,'Label','Œ«ﬂ” —Ì');

        set(handles.menu_file_color,'Label','—‰ê »‰œÌ');
        set(handles.menu_file_color_blue,'Label','¬»Ì ¬”„«‰Ì');
        set(handles.menu_file_color_nature,'Label','”»“ ÿ»Ì⁄Ì');
        set(handles.menu_file_color_vista,'Label','ÊÌ‰œÊ“ ÊÌ” «');
        set(handles.menu_file_color_sun,'Label','“—œ ŒÊ—‘ÌœÌ');
        set(handles.menu_file_exit,'Label','Œ—ÊÃ');

        set(handles.menu_tools_gain,'Label','Ã” ÃÊÌ êÌ‰');
        set(handles.menu_tools_solve,'Label','Õ· „⁄«œ·Â');
        set(handles.menu_tools_ltiview,'Label','‰„«Ì‘ Â«Ì ŒÿÌ');
        set(handles.menu_tools_response,'Label','Å«”Œ');
        set(handles.menu_tools_response_step,'Label','Å·Â');
        set(handles.menu_tools_response_impulse,'Label','÷—»Â');
        set(handles.menu_tools_diagram,'Label','‰„Êœ«—');
        set(handles.menu_tools_diagram_zplane,'Label','’›ÕÂ Z');
        set(handles.menu_tools_diagram_rlocus,'Label','„ﬂ«‰ Â‰œ”Ì');
        set(handles.menu_tools_diagram_nyquist,'Label','‰«ÌﬂÊÌ” ');
        set(handles.menu_tools_diagram_bode,'Label','»Êœ');
        set(handles.menu_tools_diagram_nichols,'Label','‰ÌﬂÊ·“');
        set(handles.menu_tools_diagram_sigma,'Label','„ﬁœ«— „‰›—œ');

        set(handles.menu_help_help,'Label','ò„ò');
        set(handles.menu_help_demo,'Label','—«Â‰„«');
        set(handles.menu_help_demo_ex1,'Label','„À«· 1');
        set(handles.menu_help_demo_ex2,'Label','„À«· 2');
        set(handles.menu_help_demo_ex3,'Label','„À«· 3');
        set(handles.menu_help_demo_ex4,'Label','„À«· 4');
        set(handles.menu_help_language,'Label',' €ÌÌ— “»«‰');
        set(handles.menu_help_about,'Label','œ—»«—Â');
        set(handles.cmenu_copy_input_edit,'Label','òÅÌ');
        set(handles.cmenu_paste_input_edit,'Label','ç”»«‰œ‰');
        set(handles.cmenu_help_input_edit,'Label','ò„ò');
        set(handles.cmenu_help_table_ras,'Label','ò„ò');
        %------------end of change uimenu label--------------

        %--------------change children String----------------
        set(handles.input_text,'String',': „⁄«œ·Â Ê—ÊœÌ');
        set(handles.input_edit,'TooltipString','„⁄«œ·Â ò«„·(s) Ì« „⁄«œ·Â ÅÊ·Ì(÷—«Ì» s)');
        set(handles.factor_text,'TooltipString','›«ò Ê— —Ì‘Â Â«Ì ’›—(s=0)');
        set(handles.panel_ras,'Title','ÃœÊ· ¬—«ÌÂ —«À');
        set(handles.panel_root,'Title',' ⁄œ«œ —Ì‘Â Â«');

        set(handles.rjw,'String','„ò—— jw');
        set(handles.arjw,'TooltipString',' ⁄œ«œ —Ì‘Â Â«Ì „ò—— —ÊÌ „ÕÊ— jw');

        set(handles.lhp,'String','”„  çÅ jw');
        set(handles.alhp,'TooltipString',' ⁄œ«œ —Ì‘Â Â«Ì ”„  çÅ „ÕÊ— jw');

        set(handles.jw,'String','—ÊÌ jw');
        set(handles.ajw,'TooltipString',' ⁄œ«œ —Ì‘Â Â«Ì —ÊÌ „ÕÊ— jw');

        set(handles.rhp,'String','”„  —«” jw');
        set(handles.arhp,'TooltipString',' ⁄œ«œ —Ì‘Â Â«Ì ”„  —«”  „ÕÊ— jw');

        set(handles.center,'String','—ÊÌ „—ò“');
        set(handles.ac,'TooltipString',' ⁄œ«œ —Ì‘Â Â«Ì ’›— s=0');

        set(handles.rcenter,'String','„ò—— œ— „—ò“');
        set(handles.arc,'TooltipString',' ⁄œ«œ —Ì‘Â Â«Ì „ò—— ’›— s=0 œ— „—ò“');

        set(handles.panel_result,'Title','‰ ÌÃÂ');
        set(handles.close,'String','»” ‰',...
            'FontSize',10);
        %-----------end of change children String------------
    end
end

% --------------------------------------------------------------------
function menu_help_help_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.menu_help_language,'UserData')==1;
    set(handles.operation,'String','Busy...');
elseif get(handles.menu_help_language,'UserData')==2
    set(handles.operation,'String','„‘€Ê·...');
end
open('Help_Main.html');
set(handles.operation,'String','');
% --------------------------------------------------------------------
function menu_file_color_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_file_color_blue_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_color_blue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'Color',[0.592156862745098 0.768627450980392 0.945098039215686]);
set(handles.operation,'BackgroundColor',[0.592156862745098 0.768627450980392 0.945098039215686]);
set(handles.operation,'ForegroundColor',[1 0 0]);
set(handles.input_text,'BackgroundColor',[0.882352941176471 0.956862745098039 0.945098039215686]);
set(handles.input_text,'ForegroundColor',[0 0 0]);
set(handles.panel_ras,'BackgroundColor',[0.882352941176471 0.956862745098039 0.945098039215686]);
set(handles.panel_ras,'ForegroundColor',[0 0 0]);
set(handles.panel_ras,'ShadowColor',[0.772549019607843 0.945098039215686 0.945098039215686]);
set(handles.panel_root,'BackgroundColor',[0.882352941176471 0.956862745098039 0.945098039215686]);
set(handles.panel_root,'ShadowColor',[0.772549019607843 0.945098039215686 0.945098039215686]);
set(handles.panel_result,'BackgroundColor',[0.882352941176471 0.956862745098039 0.945098039215686]);
set(handles.panel_result,'ShadowColor',[0.772549019607843 0.945098039215686 0.945098039215686]);
set(handles.rjw,'BackgroundColor',[0.8 1 0.945098039215686]);
set(handles.lhp,'BackgroundColor',[0.8 1 0.945098039215686]);
set(handles.jw,'BackgroundColor',[0.8 1 0.945098039215686]);
set(handles.rhp,'BackgroundColor',[0.8 1 0.945098039215686]);
set(handles.center,'BackgroundColor',[0.8 1 0.945098039215686]);
set(handles.rcenter,'BackgroundColor',[0.8 1 0.945098039215686]);
set(handles.close,'BackgroundColor',[1 0.1843 0.3373]);
set(handles.close,'ForegroundColor',[1 1 1]);

% --------------------------------------------------------------------
function menu_file_color_nature_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_color_nature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'Color',[0.7725 0.9843 0.3255]);
set(handles.operation,'BackgroundColor',[0.7725 0.9843 0.3255]);
set(handles.operation,'ForegroundColor',[1 0 0]);
set(handles.input_text,'BackgroundColor',[0.6 1 0.8]);
set(handles.input_text,'ForegroundColor',[0 0 0]);
set(handles.panel_ras,'BackgroundColor',[0.6 1 0.8]);
set(handles.panel_ras,'ForegroundColor',[0 0 0]);
set(handles.panel_ras,'ShadowColor',[0.772549019607843 0.945098039215686 0.945098039215686]);
set(handles.panel_root,'BackgroundColor',[0.6 1 0.8]);
set(handles.panel_root,'ShadowColor',[0.772549019607843 0.945098039215686 0.945098039215686]);
set(handles.panel_result,'BackgroundColor',[0.6 1 0.8]);
set(handles.panel_result,'ShadowColor',[0.772549019607843 0.945098039215686 0.945098039215686]);
set(handles.rjw,'BackgroundColor',[1 1 0.2]);
set(handles.lhp,'BackgroundColor',[1 1 0.2]);
set(handles.jw,'BackgroundColor',[1 1 0.2]);
set(handles.rhp,'BackgroundColor',[1 1 0.2]);
set(handles.center,'BackgroundColor',[1 1 0.2]);
set(handles.rcenter,'BackgroundColor',[1 1 0.2]);
set(handles.close,'BackgroundColor',[1 0.1843 0.3373]);
set(handles.close,'ForegroundColor',[1 1 1]);

% --------------------------------------------------------------------
function menu_file_color_vista_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_color_vista (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'Color',[0 0 0]);
set(handles.operation,'BackgroundColor',[0 0 0]);
set(handles.operation,'ForegroundColor',[1 1 1]);
set(handles.input_text,'BackgroundColor',[0.9765 0.6706 0.6]);
set(handles.input_text,'ForegroundColor',[0 0 0]);
set(handles.panel_ras,'BackgroundColor',[0.9765 0.6706 0.6]);
set(handles.panel_ras,'ForegroundColor',[0 0 0]);
set(handles.panel_ras,'ShadowColor',[1 0.6941 0.3922]);
set(handles.panel_root,'BackgroundColor',[0.9765 0.6706 0.6]);
set(handles.panel_root,'ShadowColor',[1 0.6941 0.3922]);
set(handles.panel_result,'BackgroundColor',[0.9765 0.6706 0.6]);
set(handles.panel_result,'ShadowColor',[1 0.6941 0.3922]);
set(handles.rjw,'BackgroundColor',[0.9765 0.6706 0.6]);
set(handles.lhp,'BackgroundColor',[0.9765 0.6706 0.6]);
set(handles.jw,'BackgroundColor',[0.9765 0.6706 0.6]);
set(handles.rhp,'BackgroundColor',[0.9765 0.6706 0.6]);
set(handles.center,'BackgroundColor',[0.9765 0.6706 0.6]);
set(handles.rcenter,'BackgroundColor',[0.9765 0.6706 0.6]);
set(handles.close,'BackgroundColor',[0.2 1 0]);
set(handles.close,'ForegroundColor',[0 0 0]);

% --------------------------------------------------------------------
function menu_file_color_sun_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_color_sun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(gcf,'Color',[0.9843 0.9843 0.4884]);
set(handles.operation,'BackgroundColor',[0.9843 0.9843 0.4884]);
set(handles.operation,'ForegroundColor',[1 0 0]);
set(handles.input_text,'BackgroundColor',[0.5843 0.949 0.949]);
set(handles.input_text,'ForegroundColor',[0 0 0]);
set(handles.panel_ras,'BackgroundColor',[0.5843 0.949 0.949]);
set(handles.panel_ras,'ForegroundColor',[0 0 0]);
set(handles.panel_ras,'ShadowColor',[0 1 0]);
set(handles.panel_root,'BackgroundColor',[0.5843 0.949 0.949]);
set(handles.panel_root,'ShadowColor',[0 1 0]);
set(handles.panel_result,'BackgroundColor',[0.5843 0.949 0.949]);
set(handles.panel_result,'ShadowColor',[0 1 0]);
set(handles.rjw,'BackgroundColor',[0.5843 0.949 0.949]);
set(handles.lhp,'BackgroundColor',[0.5843 0.949 0.949]);
set(handles.jw,'BackgroundColor',[0.5843 0.949 0.949]);
set(handles.rhp,'BackgroundColor',[0.5843 0.949 0.949]);
set(handles.center,'BackgroundColor',[0.5843 0.949 0.949]);
set(handles.rcenter,'BackgroundColor',[0.5843 0.949 0.949]);
set(handles.close,'BackgroundColor',[1 0.1843 0.3373]);
set(handles.close,'ForegroundColor',[1 1 1]);

% --------------------------------------------------------------------
function cmenuin_Callback(hObject, eventdata, handles)
% hObject    handle to cmenuin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function cmenu_help_input_edit_Callback(hObject, eventdata, handles)
% hObject    handle to cmenu_help_input_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hlpl1='input your Equation(s)=0---for example:s^5+s^4+5*s^3+5*s^2+4*s+4---';
hlpl2=sprintf('\nyou can input Equation so poly(Coefficient of Equation(s)=0)');
hlpl3=sprintf('\n---for example:[1 1 5 5 4 4]---equal with s^5+s^4+5*s^3+5*s^2+4*s+4');
hlpl4=sprintf('\nin the poly state after press Enter; poly convert to Equation(s)=0');
hlpl5=sprintf('\nand display');
hlpl6=sprintf('\nyou can input Equation so roots; maybe used for easy test project');
hlpl7=sprintf('\n---for example:(s-j)*(s+j)*(s+2j)*(s-2j)*(s+1)---');
hlpl8=sprintf('\nin the roots state if missed * before j ==> no problem');
hlpl9=sprintf('\n---for example:(s-2j)*(s+2j)---equal with (s-2*j)*(s+2*j)');
hlpl10=sprintf('\nin the roots state after press Enter roots convert to Equation(s)=0');
hlpl11=sprintf('\nand display');

hlpt=strvcat(hlpl1,hlpl2,hlpl3,hlpl4,hlpl5,hlpl6,hlpl7,hlpl8,hlpl9,hlpl10...
    ,hlpl11);
helpdlg(hlpt,'Help:Input');

% --------------------------------------------------------------------
function cmenu_copy_input_edit_Callback(hObject, eventdata, handles)
% hObject    handle to cmenu_copy_input_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clipboard('copy',get(handles.input_edit,'String'));


% --------------------------------------------------------------------
function cmenu_paste_input_edit_Callback(hObject, eventdata, handles)
% hObject    handle to cmenu_paste_input_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.input_edit,'String',clipboard('paste'));

% --------------------------------------------------------------------
function cmenutab_Callback(hObject, eventdata, handles)
% hObject    handle to cmenutab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function cmenu_help_table_ras_Callback(hObject, eventdata, handles)
% hObject    handle to cmenu_help_table_ras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hlpl1='this box display table of Routh Hurwitz_Red color means all element';
hlpl2=sprintf('of row is zero & Blue color means first element of row iz zero');
hlpl3=sprintf('you can save this table in .mat format for this action: goto');
hlpl4=sprintf('File\\Save Table of Routh');
hlpl5=sprintf('then in the Save Workspace Variables window write your wish name');
hlpl6=sprintf('and click Save button');
hlpl7=sprintf('\nyou can too change mathematic precision');
hlpl8=sprintf('for this action: follow under address');
hlpl9=sprintf('File\\Set Precision');
hlpl10=sprintf('then in the Set Precision window write your wish positive integer');
hlpl11=sprintf('default Precision is 2');
hlpl12=sprintf('\nyou can change color scheme. for this action : follow under address');
hlpl13=sprintf('File\\Color Scheme  and select one of the "Blue Sky" or "Nature"');
hlpl14=sprintf('or "Vista" or "Sun"');
hlpl15=sprintf('\nyou can obtain roots of input equation. for this action goto :');
hlpl16=sprintf('Tools\\Solve Equation');
hlpl17=sprintf('\nyou can plot step and impulse response of input equation for this actions:');
hlpl18=sprintf('Tools\\Response\\Step(or Impulse) after this you should input numerator &');
hlpl19=sprintf('denominator of transfer function. default numerator is [1] &');
hlpl20=sprintf('default denominator is poly state of input equation');
hlpl21=sprintf('warning: you can only input your equation in poly state in this windows');
hlpl22=sprintf('\nyou can too see Z_plane(complex plane) & Root Locus &');
hlpl23=sprintf('Nyquist & Bode & Nichols & Singular Vlue Diagram');
hlpl24=sprintf('for this action goto : Tools\\Diagram\\Z_plane(or Root Locus or');
hlpl25=sprintf(' Nyquist or Bode or Nichols or Singular Vlue)');
hlpl26=sprintf('continue be similar to plot step or impulse response');
hlpl27=sprintf('in Z_plane if you have repeated poles then its show with diamond');
hlpl28=sprintf('& if you have repeated zeros then its show with star');
hlpl29=sprintf('\nyou can see example to learn how work with this gui for this goto:');
hlpl30=sprintf('Help\\Demo\\example 1(or 2 or 3 or 4)');
hlpl31=sprintf('\nyou can too change language of this gui to farsi or english. goto:');
hlpl32=sprintf('Help\\Change Language  and select one of them');

hlpt=strvcat(hlpl1,hlpl2,hlpl3,hlpl4,hlpl5,hlpl6,hlpl7,hlpl8,hlpl9,hlpl10,...
    hlpl11,hlpl12,hlpl13,hlpl14,hlpl15,hlpl16,hlpl17,hlpl18,hlpl19,hlpl20,...
    hlpl21,hlpl22,hlpl23,hlpl24,hlpl25,hlpl26,hlpl27,hlpl28,hlpl29,hlpl30,...
    hlpl31,hlpl32);
helpdlg(hlpt,'Help:Table Routh Hurwitz');

%--------------------------------------------------------------------------

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if get(handles.menu_help_language,'UserData')==1
    button=questdlg('Do you want to exit?','Exit','Yes','No','No');
    switch button
        case{'No'}
            return
        case 'Yes'
            delete(gcf);
    end
elseif get(handles.menu_help_language,'UserData')==2
    button=questdlg('„Ì ŒÊ«ÂÌœ «“ »—‰«„Â Œ«—Ã ‘ÊÌœø','Œ—ÊÃ','»·Â','ŒÌ—','ŒÌ—');
    switch button
        case{'ŒÌ—'}
            return
        case '»·Â'
            delete(gcf);
    end
end

% -------------------------------------------------------------------------

% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.menu_help_language,'UserData')==1
    button=questdlg('Do you want to exit?','Exit','Yes','No','No');
    switch button
        case{'No'}
            return
        case 'Yes'
            delete(gcf);
    end
elseif get(handles.menu_help_language,'UserData')==2
    button=questdlg('„Ì ŒÊ«ÂÌœ «“ »—‰«„Â Œ«—Ã ‘ÊÌœø','Œ—ÊÃ','»·Â','ŒÌ—','ŒÌ—');
    switch button
        case{'ŒÌ—'}
            return
        case '»·Â'
            delete(gcf);
    end
end

%--------------------------------------------------------------------------


% --------------------------------------------------------------------
function menu_tools_response_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools_response (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_tools_response_step_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools_response_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(get(handles.input_edit,'String'))
    if get(handles.menu_help_language,'UserData')==1
        errordlg('Equation not found','Equation Error');
    elseif get(handles.menu_help_language,'UserData')==2
        errordlg('„⁄«œ·Â «Ì Ì«›  ‰‘œ','Œÿ«Ì „⁄«œ·Â');
    end
    return
end
n0jw=get(handles.factor_text,'UserData');
syms s
equstrd=get(handles.input_edit,'String');
equd=sym(equstrd);
cd=sym2poly(equd);
cd=addlz(cd,n0jw);

if get(handles.menu_help_language,'UserData')==1
    prompt = {'Enter numerator:','Enter denominator:'};
    dlg_title = 'Step';
elseif get(handles.menu_help_language,'UserData')==2
    prompt = {'Enter numerator:','Enter denominator:'};
    dlg_title = 'Å·Â';
end
num_lines = 1;
def = {'[1]',strcat('[',num2str(cd),']')};
answer = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer)
    %if user click cancel button: no operation
    return
else
    if isempty(answer{1,1}) || isempty(answer{2,1})
        if get(handles.menu_help_language,'UserData')==1
            errordlg('Input not found','Input Error');
        elseif get(handles.menu_help_language,'UserData')==2
            errordlg('Ê—ÊœÌ Ì«›  ‰‘œ','Œÿ«Ì Ê—ÊœÌ');
        end
        return
    end
end
equstrn=answer{1,1};
cn=str2num(equstrn);

equstrd=answer{2,1};
cd=str2num(equstrd);
if length(cn)>length(cd)
    if get(handles.menu_help_language,'UserData')==1
        errordlg('Not supported for models with more zeros than poles.','Input Error');
    elseif get(handles.menu_help_language,'UserData')==2
        errordlg('’›—Â« »Ì‘ — «“ ﬁÿ» Â« «” ','Œÿ«Ì Ê—ÊœÌ');
    end
    return
end

if get(handles.menu_help_language,'UserData')==1;
    set(handles.operation,'String','Busy...');
elseif get(handles.menu_help_language,'UserData')==2
    set(handles.operation,'String','„‘€Ê·...');
end

tru_func=tf(cn,cd);
figure;
step(tru_func);
title(['Step Response Of (',titgen(poly2strs(cn,'s')),...
    ')/(',titgen(poly2strs(cd,'s')),')']);
set(handles.operation,'String','');
% --------------------------------------------------------------------
function menu_tools_response_impulse_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools_response_impulse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(get(handles.input_edit,'String'))
    if get(handles.menu_help_language,'UserData')==1
        errordlg('Equation not found','Equation Error');
    elseif get(handles.menu_help_language,'UserData')==2
        errordlg('„⁄«œ·Â «Ì Ì«›  ‰‘œ','Œÿ«Ì „⁄«œ·Â');
    end
    return
end
n0jw=get(handles.factor_text,'UserData');
syms s
equstrd=get(handles.input_edit,'String');
equd=sym(equstrd);
cd=sym2poly(equd);
cd=addlz(cd,n0jw);

if get(handles.menu_help_language,'UserData')==1
    prompt = {'Enter numerator:','Enter denominator:'};
    dlg_title = 'Impulse';
elseif get(handles.menu_help_language,'UserData')==2
    prompt = {'Enter numerator:','Enter denominator:'};
    dlg_title = '÷—»Â';
end
num_lines = 1;
def = {'[1]',strcat('[',num2str(cd),']')};
answer = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer)
    %if user click cancel button: no operation
    return
else
    if isempty(answer{1,1}) || isempty(answer{2,1})
        if get(handles.menu_help_language,'UserData')==1
            errordlg('Input not found','Input Error');
        elseif get(handles.menu_help_language,'UserData')==2
            errordlg('Ê—ÊœÌ Ì«›  ‰‘œ','Œÿ«Ì Ê—ÊœÌ');
        end
        return
    end
end
equstrn=answer{1,1};
cn=str2num(equstrn);

equstrd=answer{2,1};
cd=str2num(equstrd);
if length(cn)>length(cd)
    if get(handles.menu_help_language,'UserData')==1
        errordlg('Not supported for models with more zeros than poles.','Input Error');
    elseif get(handles.menu_help_language,'UserData')==2
        errordlg('’›—Â« »Ì‘ — «“ ﬁÿ» Â« «” ','Œÿ«Ì Ê—ÊœÌ');
    end
    return
end

if get(handles.menu_help_language,'UserData')==1;
    set(handles.operation,'String','Busy...');
elseif get(handles.menu_help_language,'UserData')==2
    set(handles.operation,'String','„‘€Ê·...');
end

tru_func=tf(cn,cd);
figure;
impulse(tru_func);
title(['Impulse Response Of (',titgen(poly2strs(cn,'s')),...
    ')/(',titgen(poly2strs(cd,'s')),')']);
set(handles.operation,'String','');

% --------------------------------------------------------------------
function menu_tools_gain_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools_gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hgain=guidata(Gain_Finder);
if get(handles.menu_help_language,'UserData')==1;
    set(hgain.color,'Label','Change Color');
    set(hgain.color_default,'Label','Default...');

    set(hgain.color_stable,'Label','Stable Color');
    set(hgain.color_stable_red,'Label','Red');
    set(hgain.color_stable_blue,'Label','Blue');
    set(hgain.color_stable_green,'Label','Green');
    set(hgain.color_stable_yellow,'Label','Yellow');
    set(hgain.color_stable_gray,'Label','Gray');
    
    set(hgain.color_boustable,'Label','Boundary Stable Color');
    set(hgain.color_boustable_red,'Label','Red');
    set(hgain.color_boustable_blue,'Label','Blue');
    set(hgain.color_boustable_green,'Label','Green');
    set(hgain.color_boustable_yellow,'Label','Yellow');
    set(hgain.color_boustable_gray,'Label','Gray');

    set(hgain.color_unstable,'Label','Unstable Color');
    set(hgain.color_unstable_red,'Label','Red');
    set(hgain.color_unstable_blue,'Label','Blue');
    set(hgain.color_unstable_green,'Label','Green');
    set(hgain.color_unstable_yellow,'Label','Yellow');
    set(hgain.color_unstable_gray,'Label','Gray');

    set(hgain.help,'Label','Help');
    set(hgain.help_help,'Label','Help');
    set(hgain.help_demo,'Label','Demo');
    set(hgain.help_demo_ex1,'Label','example 1');
    set(hgain.help_demo_ex1_step1,'Label','Step 1');
    set(hgain.help_demo_ex1_step2,'Label','Step 2');

    set(hgain.help_demo_ex2,'Label','example 2');
    set(hgain.help_demo_ex2_step1,'Label','Step 1');
    set(hgain.help_demo_ex2_step2,'Label','Step 2');
    
    set(hgain.help_demo_ex3,'Label','example 3');
    set(hgain.help_demo_ex3_step1,'Label','Step 1');
    set(hgain.help_demo_ex3_step2,'Label','Step 2');

    set(hgain.help_demo_ex4,'Label','example 4');
    set(hgain.help_demo_ex4_step1,'Label','Step 1');
    set(hgain.help_demo_ex4_step2,'Label','Step 2');

    %-----------------------------------------------------------
    
    set(hgain.input_gtext,'String','Input Equation :');
    set(hgain.input_gedit,'TooltipString','only poly=>[coefficient of equation(s)=0 with k variable]');
    set(hgain.start_gtext,'String','Start Gain(k) From :');
    set(hgain.to_gtext,'String','To :');
    set(hgain.intv_gtext,'String','With Interval :');
    
    set(hgain.pan_result,'Title','Result');
    set(hgain.find,'String','Find');
    set(hgain.close_gain,'String','Close');

elseif get(handles.menu_help_language,'UserData')==2
    set(hgain.color,'Label',' €ÌÌ— —‰ê');
    set(hgain.color_default,'Label','ÅÌ‘ ›—÷...');

    set(hgain.color_stable,'Label','—‰ê Å«Ìœ«—Ì');
    set(hgain.color_stable_red,'Label','ﬁ—„“');
    set(hgain.color_stable_blue,'Label','¬»Ì');
    set(hgain.color_stable_green,'Label','”»“');
    set(hgain.color_stable_yellow,'Label','“—œ');
    set(hgain.color_stable_gray,'Label','Œ«ﬂ” —Ì');
    
    set(hgain.color_boustable,'Label','—‰ê Å«Ìœ«—Ì „—“Ì');
    set(hgain.color_boustable_red,'Label','ﬁ—„“');
    set(hgain.color_boustable_blue,'Label','¬»Ì');
    set(hgain.color_boustable_green,'Label','”»“');
    set(hgain.color_boustable_yellow,'Label','“—œ');
    set(hgain.color_boustable_gray,'Label','Œ«ﬂ” —Ì');

    set(hgain.color_unstable,'Label','—‰ê ‰«Å«Ìœ«—Ì');
    set(hgain.color_unstable_red,'Label','ﬁ—„“');
    set(hgain.color_unstable_blue,'Label','¬»Ì');
    set(hgain.color_unstable_green,'Label','”»“');
    set(hgain.color_unstable_yellow,'Label','“—œ');
    set(hgain.color_unstable_gray,'Label','Œ«ﬂ” —Ì');

    set(hgain.help,'Label','ﬂ„ﬂ');
    set(hgain.help_help,'Label','ﬂ„ﬂ');
    set(hgain.help_demo,'Label','—«Â‰„«');
    set(hgain.help_demo_ex1,'Label','„À«· 1');
    set(hgain.help_demo_ex1_step1,'Label','„—Õ·Â 1');
    set(hgain.help_demo_ex1_step2,'Label','„—Õ·Â 2');

    set(hgain.help_demo_ex2,'Label','„À«· 2');
    set(hgain.help_demo_ex2_step1,'Label','„—Õ·Â 1');
    set(hgain.help_demo_ex2_step2,'Label','„—Õ·Â 2');
    
    set(hgain.help_demo_ex3,'Label','„À«· 3');
    set(hgain.help_demo_ex3_step1,'Label','„—Õ·Â 1');
    set(hgain.help_demo_ex3_step2,'Label','„—Õ·Â 2');

    set(hgain.help_demo_ex4,'Label','„À«· 4');
    set(hgain.help_demo_ex4_step1,'Label','„—Õ·Â 1');
    set(hgain.help_demo_ex4_step2,'Label','„—Õ·Â 2');
    %-----------------------------------------------------------
    
    set(hgain.input_gtext,'String',': „⁄«œ·Â Ê—ÊœÌ');
    set(hgain.input_gedit,'TooltipString','›ﬁÿ »Â ’Ê—  ÅÊ·Ì(÷—«Ì» „⁄«œ·Â(s)Â„—«Â »« „ €Ì— êÌ‰(k) )');
    set(hgain.start_gtext,'String',': ‘—Ê⁄ „ﬁœ«— êÌ‰(k)«“');
    set(hgain.to_gtext,'String',':  «');
    set(hgain.intv_gtext,'String',': »« ›«’·Â');
    
    set(hgain.pan_result,'Title','‰ ÌÃÂ');
    set(hgain.find,'String','Ã” ÃÊ');
    set(hgain.close_gain,'String','»” ‰');
end
% --------------------------------------------------------------------
function menu_tools_solve_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools_solve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.menu_help_language,'UserData')==1;
    set(handles.operation,'String','Busy...');
elseif get(handles.menu_help_language,'UserData')==2
    set(handles.operation,'String','„‘€Ê·...');
end

n0jw=get(handles.factor_text,'UserData');
if isempty(get(handles.input_edit,'String'))
    if get(handles.menu_help_language,'UserData')==1
        errordlg('Equation not found','Equation Error');
    elseif get(handles.menu_help_language,'UserData')==2
        errordlg('„⁄«œ·Â «Ì Ì«›  ‰‘œ','Œÿ«Ì „⁄«œ·Â');
    end
    set(handles.operation,'String','');
    return
end
equstr=get(handles.input_edit,'String');
equ=sym(equstr);
c=sym2poly(equ);
c=addlz(c,n0jw);
c=poly2sym(c,'s');
rebrowz=fixz(double(solve(c)),7);
rebrowz_str=num2str(rebrowz,'%g');
if get(handles.menu_help_language,'UserData')==1
    msg1=sprintf('Roots Of Equation :');
    msg2=sprintf('\n');
    msgt=strvcat(msg1,msg2,rebrowz_str);
    msgbox(msgt,'Solve Equation','help');
elseif get(handles.menu_help_language,'UserData')==2
    msg1=sprintf('—Ì‘Â Â«Ì „⁄«œ·Â :');
    msg2=sprintf('\n');
    msgt=strvcat(msg1,msg2,rebrowz_str);
    msgbox(msgt,'Õ· „⁄«œ·Â','help');
end

set(handles.operation,'String','');


% --------------------------------------------------------------------
function menu_tools_ltiview_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools_ltiview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(get(handles.input_edit,'String'))
    if get(handles.menu_help_language,'UserData')==1
        errordlg('Equation not found','Equation Error');
    elseif get(handles.menu_help_language,'UserData')==2
        errordlg('„⁄«œ·Â «Ì Ì«›  ‰‘œ','Œÿ«Ì „⁄«œ·Â');
    end
    return
end
n0jw=get(handles.factor_text,'UserData');
syms s
equstrd=get(handles.input_edit,'String');
equd=sym(equstrd);
cd=sym2poly(equd);
cd=addlz(cd,n0jw);

if get(handles.menu_help_language,'UserData')==1
    prompt = {'Enter numerator:','Enter denominator:'};
    dlg_title = 'LTI Viewer';
elseif get(handles.menu_help_language,'UserData')==2
    prompt = {'Enter numerator:','Enter denominator:'};
    dlg_title = '”Ì” „ Â«Ì ŒÿÌ';
end
num_lines = 1;
def = {'[1]',strcat('[',num2str(cd),']')};
answer = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer)
    %if user click cancel button: no operation
    return
else
    if isempty(answer{1,1}) || isempty(answer{2,1})
        if get(handles.menu_help_language,'UserData')==1
            errordlg('Input not found','Input Error');
        elseif get(handles.menu_help_language,'UserData')==2
            errordlg('Ê—ÊœÌ Ì«›  ‰‘œ','Œÿ«Ì Ê—ÊœÌ');
        end
        return
    end
end
equstrn=answer{1,1};
cn=str2num(equstrn);

equstrd=answer{2,1};
cd=str2num(equstrd);
if get(handles.menu_help_language,'UserData')==1;
    set(handles.operation,'String','Busy...');
elseif get(handles.menu_help_language,'UserData')==2
    set(handles.operation,'String','„‘€Ê·...');
end

tru_func=tf(cn,cd);
ltiview({'step';'impulse'},tru_func);
set(handles.operation,'String','');


% --------------------------------------------------------------------
function menu_tools_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_tools_diagram_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools_diagram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_tools_diagram_nyquist_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools_diagram_nyquist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(get(handles.input_edit,'String'))
    if get(handles.menu_help_language,'UserData')==1
        errordlg('Equation not found','Equation Error');
    elseif get(handles.menu_help_language,'UserData')==2
        errordlg('„⁄«œ·Â «Ì Ì«›  ‰‘œ','Œÿ«Ì „⁄«œ·Â');
    end
    return
end
n0jw=get(handles.factor_text,'UserData');
syms s
equstrd=get(handles.input_edit,'String');
equd=sym(equstrd);
cd=sym2poly(equd);
cd=addlz(cd,n0jw);

if get(handles.menu_help_language,'UserData')==1
    prompt = {'Enter numerator:','Enter denominator:'};
    dlg_title = 'Nyquist';
elseif get(handles.menu_help_language,'UserData')==2
    prompt = {'Enter numerator:','Enter denominator:'};
    dlg_title = '‰«ÌﬂÊÌ” ';
end
num_lines = 1;
def = {'[1]',strcat('[',num2str(cd),']')};
answer = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer)
    %if user click cancel button: no operation
    return
else
    if isempty(answer{1,1}) || isempty(answer{2,1})
        if get(handles.menu_help_language,'UserData')==1
            errordlg('Input not found','Input Error');
        elseif get(handles.menu_help_language,'UserData')==2
            errordlg('Ê—ÊœÌ Ì«›  ‰‘œ','Œÿ«Ì Ê—ÊœÌ');
        end
        return
    end
end
equstrn=answer{1,1};
cn=str2num(equstrn);

equstrd=answer{2,1};
cd=str2num(equstrd);
if get(handles.menu_help_language,'UserData')==1;
    set(handles.operation,'String','Busy...');
elseif get(handles.menu_help_language,'UserData')==2
    set(handles.operation,'String','„‘€Ê·...');
end

tru_func=tf(cn,cd);
figure;
nyquist(tru_func);
title(['Nyquist Diagram Of (',titgen(poly2strs(cn,'s')),...
    ')/(',titgen(poly2strs(cd,'s')),')']);
set(handles.operation,'String','');

% --------------------------------------------------------------------
function menu_tools_diagram_rlocus_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools_diagram_rlocus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(get(handles.input_edit,'String'))
    if get(handles.menu_help_language,'UserData')==1
        errordlg('Equation not found','Equation Error');
    elseif get(handles.menu_help_language,'UserData')==2
        errordlg('„⁄«œ·Â «Ì Ì«›  ‰‘œ','Œÿ«Ì „⁄«œ·Â');
    end
    return
end
n0jw=get(handles.factor_text,'UserData');
syms s
equstrd=get(handles.input_edit,'String');
equd=sym(equstrd);
cd=sym2poly(equd);
cd=addlz(cd,n0jw);

if get(handles.menu_help_language,'UserData')==1
    prompt = {'Enter numerator:','Enter denominator:'};
    dlg_title = 'Root Locus';
elseif get(handles.menu_help_language,'UserData')==2
    prompt = {'Enter numerator:','Enter denominator:'};
    dlg_title = '„ﬂ«‰ Â‰œ”Ì';
end
num_lines = 1;
def = {'[1]',strcat('[',num2str(cd),']')};
answer = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer)
    %if user click cancel button: no operation
    return
else
    if isempty(answer{1,1}) || isempty(answer{2,1})
        if get(handles.menu_help_language,'UserData')==1
            errordlg('Input not found','Input Error');
        elseif get(handles.menu_help_language,'UserData')==2
            errordlg('Ê—ÊœÌ Ì«›  ‰‘œ','Œÿ«Ì Ê—ÊœÌ');
        end
        return
    end
end
equstrn=answer{1,1};
cn=str2num(equstrn);

equstrd=answer{2,1};
cd=str2num(equstrd);
if get(handles.menu_help_language,'UserData')==1;
    set(handles.operation,'String','Busy...');
elseif get(handles.menu_help_language,'UserData')==2
    set(handles.operation,'String','„‘€Ê·...');
end

tru_func=tf(cn,cd);
figure;
rlocus(tru_func);
title(['Root Locus Of (',titgen(poly2strs(cn,'s')),...
    ')/(',titgen(poly2strs(cd,'s')),')']);
set(handles.operation,'String','');

% --------------------------------------------------------------------
function menu_tools_diagram_bode_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools_diagram_bode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(get(handles.input_edit,'String'))
    if get(handles.menu_help_language,'UserData')==1
        errordlg('Equation not found','Equation Error');
    elseif get(handles.menu_help_language,'UserData')==2
        errordlg('„⁄«œ·Â «Ì Ì«›  ‰‘œ','Œÿ«Ì „⁄«œ·Â');
    end
    return
end
n0jw=get(handles.factor_text,'UserData');
syms s
equstrd=get(handles.input_edit,'String');
equd=sym(equstrd);
cd=sym2poly(equd);
cd=addlz(cd,n0jw);

if get(handles.menu_help_language,'UserData')==1
    prompt = {'Enter numerator:','Enter denominator:'};
    dlg_title = 'Bode';
elseif get(handles.menu_help_language,'UserData')==2
    prompt = {'Enter numerator:','Enter denominator:'};
    dlg_title = '»Êœ';
end
num_lines = 1;
def = {'[1]',strcat('[',num2str(cd),']')};
answer = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer)
    %if user click cancel button: no operation
    return
else
    if isempty(answer{1,1}) || isempty(answer{2,1})
        if get(handles.menu_help_language,'UserData')==1
            errordlg('Input not found','Input Error');
        elseif get(handles.menu_help_language,'UserData')==2
            errordlg('Ê—ÊœÌ Ì«›  ‰‘œ','Œÿ«Ì Ê—ÊœÌ');
        end
        return
    end
end
equstrn=answer{1,1};
cn=str2num(equstrn);

equstrd=answer{2,1};
cd=str2num(equstrd);
if get(handles.menu_help_language,'UserData')==1;
    set(handles.operation,'String','Busy...');
elseif get(handles.menu_help_language,'UserData')==2
    set(handles.operation,'String','„‘€Ê·...');
end

tru_func=tf(cn,cd);
figure;
bode(tru_func);
title(['Bode Diagram Of (',titgen(poly2strs(cn,'s')),...
    ')/(',titgen(poly2strs(cd,'s')),')']);
set(handles.operation,'String','');


% --------------------------------------------------------------------
function menu_tools_diagram_zplane_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools_diagram_zplane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(get(handles.input_edit,'String'))
    if get(handles.menu_help_language,'UserData')==1
        errordlg('Equation not found','Equation Error');
    elseif get(handles.menu_help_language,'UserData')==2
        errordlg('„⁄«œ·Â «Ì Ì«›  ‰‘œ','Œÿ«Ì „⁄«œ·Â');
    end
    return
end
n0jw=get(handles.factor_text,'UserData');
syms s
equstrd=get(handles.input_edit,'String');
equd=sym(equstrd);
cd=sym2poly(equd);
cd=addlz(cd,n0jw);

if get(handles.menu_help_language,'UserData')==1
    prompt = {'Enter numerator:','Enter denominator:'};
    dlg_title = 'Z_plane';
elseif get(handles.menu_help_language,'UserData')==2
    prompt = {'Enter numerator:','Enter denominator:'};
    dlg_title = '’›ÕÂ Z';
end
num_lines = 1;
def = {'[1]',strcat('[',num2str(cd),']')};
answer = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer)
    %if user click cancel button: no operation
    return
else
    if isempty(answer{1,1}) || isempty(answer{2,1})
        if get(handles.menu_help_language,'UserData')==1
            errordlg('Input not found','Input Error');
        elseif get(handles.menu_help_language,'UserData')==2
            errordlg('Ê—ÊœÌ Ì«›  ‰‘œ','Œÿ«Ì Ê—ÊœÌ');
        end
        return
    end
end
equstrn=answer{1,1};
cn=str2num(equstrn);

equstrd=answer{2,1};
cd=str2num(equstrd);
if get(handles.menu_help_language,'UserData')==1;
    set(handles.operation,'String','Busy...');
elseif get(handles.menu_help_language,'UserData')==2
    set(handles.operation,'String','„‘€Ê·...');
end
roots_num=fixz(double(solve(poly2strs(cn,'s'))),7);
[num_n rep_n]=repeatv(roots_num);
roots_den=fixz(double(solve(poly2strs(cd,'s'))),7);
[num_d rep_d]=repeatv(roots_den);
roots_num_sep=comp2real(num_n);
roots_den_sep=comp2real(num_d);

figure;
grid on
hold on
for i=1:length(num_n)
    if rep_n(i)>=2
        plot(roots_num_sep(i,1),roots_num_sep(i,2),'O','Color',[0 0 1],...
            'MarkerSize',8,'Marker','d');
    else
        plot(roots_num_sep(i,1),roots_num_sep(i,2),'O','Color',[0 0 1],...
            'MarkerSize',8);
    end
end

for j=1:length(num_d)
    if rep_d(j)>=2
        plot(roots_den_sep(j,1),roots_den_sep(j,2),'X','Color',[1 0 0],...
            'MarkerSize',8,'Marker','*');
    else
        plot(roots_den_sep(j,1),roots_den_sep(j,2),'X','Color',[1 0 0],...
            'MarkerSize',8);
    end
end
title(['Z plane Of (',titgen(poly2strs(cn,'s')),...
    ')/(',titgen(poly2strs(cd,'s')),')']);
xlabel('Real Axis');
ylabel('Imaginary Axis');

set(handles.operation,'String','');

% --------------------------------------------------------------------
function menu_tools_diagram_nichols_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools_diagram_nichols (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(get(handles.input_edit,'String'))
    if get(handles.menu_help_language,'UserData')==1
        errordlg('Equation not found','Equation Error');
    elseif get(handles.menu_help_language,'UserData')==2
        errordlg('„⁄«œ·Â «Ì Ì«›  ‰‘œ','Œÿ«Ì „⁄«œ·Â');
    end
    return
end
n0jw=get(handles.factor_text,'UserData');
syms s
equstrd=get(handles.input_edit,'String');
equd=sym(equstrd);
cd=sym2poly(equd);
cd=addlz(cd,n0jw);

if get(handles.menu_help_language,'UserData')==1
    prompt = {'Enter numerator:','Enter denominator:'};
    dlg_title = 'Nichols';
elseif get(handles.menu_help_language,'UserData')==2
    prompt = {'Enter numerator:','Enter denominator:'};
    dlg_title = '‰ÌﬂÊ·“';
end
num_lines = 1;
def = {'[1]',strcat('[',num2str(cd),']')};
answer = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer)
    %if user click cancel button: no operation
    return
else
    if isempty(answer{1,1}) || isempty(answer{2,1})
        if get(handles.menu_help_language,'UserData')==1
            errordlg('Input not found','Input Error');
        elseif get(handles.menu_help_language,'UserData')==2
            errordlg('Ê—ÊœÌ Ì«›  ‰‘œ','Œÿ«Ì Ê—ÊœÌ');
        end
        return
    end
end
equstrn=answer{1,1};
cn=str2num(equstrn);

equstrd=answer{2,1};
cd=str2num(equstrd);
if get(handles.menu_help_language,'UserData')==1;
    set(handles.operation,'String','Busy...');
elseif get(handles.menu_help_language,'UserData')==2
    set(handles.operation,'String','„‘€Ê·...');
end

tru_func=tf(cn,cd);
figure;
nichols(tru_func);
title(['Nichols Diagram Of (',titgen(poly2strs(cn,'s')),...
    ')/(',titgen(poly2strs(cd,'s')),')']);
set(handles.operation,'String','');


% --------------------------------------------------------------------
function menu_tools_diagram_sigma_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools_diagram_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(get(handles.input_edit,'String'))
    if get(handles.menu_help_language,'UserData')==1
        errordlg('Equation not found','Equation Error');
    elseif get(handles.menu_help_language,'UserData')==2
        errordlg('„⁄«œ·Â «Ì Ì«›  ‰‘œ','Œÿ«Ì „⁄«œ·Â');
    end
    return
end
n0jw=get(handles.factor_text,'UserData');
syms s
equstrd=get(handles.input_edit,'String');
equd=sym(equstrd);
cd=sym2poly(equd);
cd=addlz(cd,n0jw);

if get(handles.menu_help_language,'UserData')==1
    prompt = {'Enter numerator:','Enter denominator:'};
    dlg_title = 'Singular Value';
elseif get(handles.menu_help_language,'UserData')==2
    prompt = {'Enter numerator:','Enter denominator:'};
    dlg_title = '„ﬁœ«— „‰›—œ';
end
num_lines = 1;
def = {'[1]',strcat('[',num2str(cd),']')};
answer = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer)
    %if user click cancel button: no operation
    return
else
    if isempty(answer{1,1}) || isempty(answer{2,1})
        if get(handles.menu_help_language,'UserData')==1
            errordlg('Input not found','Input Error');
        elseif get(handles.menu_help_language,'UserData')==2
            errordlg('Ê—ÊœÌ Ì«›  ‰‘œ','Œÿ«Ì Ê—ÊœÌ');
        end
        return
    end
end
equstrn=answer{1,1};
cn=str2num(equstrn);

equstrd=answer{2,1};
cd=str2num(equstrd);
if get(handles.menu_help_language,'UserData')==1;
    set(handles.operation,'String','Busy...');
elseif get(handles.menu_help_language,'UserData')==2
    set(handles.operation,'String','„‘€Ê·...');
end

tru_func=tf(cn,cd);
figure;
sigma(tru_func);
title(['Singular Value Of (',titgen(poly2strs(cn,'s')),...
    ')/(',titgen(poly2strs(cd,'s')),')']);
set(handles.operation,'String','');



% --------------------------------------------------------------------
function menu_help_demo_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help_demo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_help_demo_ex1_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help_demo_ex1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.input_edit,'String','[1 1 3 3 3 2 1]');

% --------------------------------------------------------------------
function menu_help_demo_ex2_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help_demo_ex2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.input_edit,'String','[1 1 3 3 3 2 1 0 0]');

% --------------------------------------------------------------------
function menu_help_demo_ex3_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help_demo_ex3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.input_edit,'String','(s-2*j)*(s+2j)*(s-j)*(s+j)*(s+1)');

% --------------------------------------------------------------------
function menu_help_demo_ex4_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help_demo_ex4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.input_edit,'String','s^4+2*s^2+1');




% --- Executes on selection change in table_ras.
function table_ras_Callback(hObject, eventdata, handles)
% hObject    handle to table_ras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns table_ras contents as cell array
%        contents{get(hObject,'Value')} returns selected item from table_ras


% --- Executes during object creation, after setting all properties.
function table_ras_CreateFcn(hObject, eventdata, handles)
% hObject    handle to table_ras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%number 1 ==> red
%number 2 ==> blue
%number 3 ==> green
%number 4 ==> yellow
%number 5 ==> gray
% --------------------------------------------------------------------
function menu_file_dispcolor_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_dispcolor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_file_dispcolor_fez_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_dispcolor_fez (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_file_dispcolor_aez_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_dispcolor_aez (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_file_dispcolor_fez_red_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_dispcolor_fez_red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.menu_file_dispcolor_fez_red,'Checked','off');
set(handles.menu_file_dispcolor_fez_blue,'Checked','off');
set(handles.menu_file_dispcolor_fez_green,'Checked','off');
set(handles.menu_file_dispcolor_fez_yellow,'Checked','off');
set(handles.menu_file_dispcolor_fez_gray,'Checked','off');

set(handles.menu_file_dispcolor_fez,'UserData',1);
set(handles.menu_file_dispcolor_fez_red,'Checked','on');

% --------------------------------------------------------------------
function menu_file_dispcolor_fez_blue_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_dispcolor_fez_blue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.menu_file_dispcolor_fez_red,'Checked','off');
set(handles.menu_file_dispcolor_fez_blue,'Checked','off');
set(handles.menu_file_dispcolor_fez_green,'Checked','off');
set(handles.menu_file_dispcolor_fez_yellow,'Checked','off');
set(handles.menu_file_dispcolor_fez_gray,'Checked','off');

set(handles.menu_file_dispcolor_fez,'UserData',2);
set(handles.menu_file_dispcolor_fez_blue,'Checked','on');

% --------------------------------------------------------------------
function menu_file_dispcolor_fez_green_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_dispcolor_fez_green (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.menu_file_dispcolor_fez_red,'Checked','off');
set(handles.menu_file_dispcolor_fez_blue,'Checked','off');
set(handles.menu_file_dispcolor_fez_green,'Checked','off');
set(handles.menu_file_dispcolor_fez_yellow,'Checked','off');
set(handles.menu_file_dispcolor_fez_gray,'Checked','off');

set(handles.menu_file_dispcolor_fez,'UserData',3);
set(handles.menu_file_dispcolor_fez_green,'Checked','on');

% --------------------------------------------------------------------
function menu_file_dispcolor_fez_yellow_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_dispcolor_fez_yellow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.menu_file_dispcolor_fez_red,'Checked','off');
set(handles.menu_file_dispcolor_fez_blue,'Checked','off');
set(handles.menu_file_dispcolor_fez_green,'Checked','off');
set(handles.menu_file_dispcolor_fez_yellow,'Checked','off');
set(handles.menu_file_dispcolor_fez_gray,'Checked','off');

set(handles.menu_file_dispcolor_fez,'UserData',4);
set(handles.menu_file_dispcolor_fez_yellow,'Checked','on');

% --------------------------------------------------------------------
function menu_file_dispcolor_fez_gray_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_dispcolor_fez_gray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.menu_file_dispcolor_fez_red,'Checked','off');
set(handles.menu_file_dispcolor_fez_blue,'Checked','off');
set(handles.menu_file_dispcolor_fez_green,'Checked','off');
set(handles.menu_file_dispcolor_fez_yellow,'Checked','off');
set(handles.menu_file_dispcolor_fez_gray,'Checked','off');

set(handles.menu_file_dispcolor_fez,'UserData',5);
set(handles.menu_file_dispcolor_fez_gray,'Checked','on');

% --------------------------------------------------------------------
function menu_file_dispcolor_aez_red_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_dispcolor_aez_red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.menu_file_dispcolor_aez_red,'Checked','off');
set(handles.menu_file_dispcolor_aez_blue,'Checked','off');
set(handles.menu_file_dispcolor_aez_green,'Checked','off');
set(handles.menu_file_dispcolor_aez_yellow,'Checked','off');
set(handles.menu_file_dispcolor_aez_gray,'Checked','off');

set(handles.menu_file_dispcolor_aez,'UserData',1);
set(handles.menu_file_dispcolor_aez_red,'Checked','on');


% --------------------------------------------------------------------
function menu_file_dispcolor_aez_blue_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_dispcolor_aez_blue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.menu_file_dispcolor_aez_red,'Checked','off');
set(handles.menu_file_dispcolor_aez_blue,'Checked','off');
set(handles.menu_file_dispcolor_aez_green,'Checked','off');
set(handles.menu_file_dispcolor_aez_yellow,'Checked','off');
set(handles.menu_file_dispcolor_aez_gray,'Checked','off');

set(handles.menu_file_dispcolor_aez,'UserData',2);
set(handles.menu_file_dispcolor_aez_blue,'Checked','on');

% --------------------------------------------------------------------
function menu_file_dispcolor_aez_green_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_dispcolor_aez_green (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.menu_file_dispcolor_aez_red,'Checked','off');
set(handles.menu_file_dispcolor_aez_blue,'Checked','off');
set(handles.menu_file_dispcolor_aez_green,'Checked','off');
set(handles.menu_file_dispcolor_aez_yellow,'Checked','off');
set(handles.menu_file_dispcolor_aez_gray,'Checked','off');

set(handles.menu_file_dispcolor_aez,'UserData',3);
set(handles.menu_file_dispcolor_aez_green,'Checked','on');

% --------------------------------------------------------------------
function menu_file_dispcolor_aez_yellow_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_dispcolor_aez_yellow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.menu_file_dispcolor_aez_red,'Checked','off');
set(handles.menu_file_dispcolor_aez_blue,'Checked','off');
set(handles.menu_file_dispcolor_aez_green,'Checked','off');
set(handles.menu_file_dispcolor_aez_yellow,'Checked','off');
set(handles.menu_file_dispcolor_aez_gray,'Checked','off');

set(handles.menu_file_dispcolor_aez,'UserData',4);
set(handles.menu_file_dispcolor_aez_yellow,'Checked','on');

% --------------------------------------------------------------------
function menu_file_dispcolor_aez_gray_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_dispcolor_aez_gray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.menu_file_dispcolor_aez_red,'Checked','off');
set(handles.menu_file_dispcolor_aez_blue,'Checked','off');
set(handles.menu_file_dispcolor_aez_green,'Checked','off');
set(handles.menu_file_dispcolor_aez_yellow,'Checked','off');
set(handles.menu_file_dispcolor_aez_gray,'Checked','off');

set(handles.menu_file_dispcolor_aez,'UserData',5);
set(handles.menu_file_dispcolor_aez_gray,'Checked','on');



% --------------------------------------------------------------------
function menu_file_dispcolor_default_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_dispcolor_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.menu_file_dispcolor_fez_red,'Checked','off');
set(handles.menu_file_dispcolor_fez_blue,'Checked','off');
set(handles.menu_file_dispcolor_fez_green,'Checked','off');
set(handles.menu_file_dispcolor_fez_yellow,'Checked','off');
set(handles.menu_file_dispcolor_fez_gray,'Checked','off');

set(handles.menu_file_dispcolor_aez_red,'Checked','off');
set(handles.menu_file_dispcolor_aez_blue,'Checked','off');
set(handles.menu_file_dispcolor_aez_green,'Checked','off');
set(handles.menu_file_dispcolor_aez_yellow,'Checked','off');
set(handles.menu_file_dispcolor_aez_gray,'Checked','off');

set(handles.menu_file_dispcolor_fez,'UserData',2);
set(handles.menu_file_dispcolor_fez_blue,'Checked','on');
set(handles.menu_file_dispcolor_aez,'UserData',1);
set(handles.menu_file_dispcolor_aez_red,'Checked','on');



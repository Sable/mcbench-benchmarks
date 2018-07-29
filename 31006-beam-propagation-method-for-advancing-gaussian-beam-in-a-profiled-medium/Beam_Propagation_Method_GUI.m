function [ varargout ] = Beam_Propagation_Method_GUI ( varargin )

%% GUI for Beam Propagation Method (BPM)
%
%%
%    Author:   Ido Schwartz (IS)            
%    April 2011 (ver. 1.0.0)
%
%% build GUI
fig = build_gui;
h   = guidata ( fig );

switch nargout      %----------------------- check nargout
    case 0
        % do nothing
    case 1                                  % return a handle to GUI
        varargout(1) = {fig};
    otherwise
        error ('Invalid number of output arguments');
end

e = exist ('data_bpm_tmp.mat','file');
if e==2
    delete('data_bpm_tmp.mat');
end

end


%% uifunctions
function fig = build_gui

setappdata(0,'UseNativeSystemDialogs',false);

fig = figure;

set (fig, 'Name', ' Beam Propagation Method GUI','NumberTitle', 'off', 'Visible','off');
set (fig, 'deleteFcn', @close_figure_callback ); %%%%%%%%%%%%%%%
set (fig, 'Color', get(0,'defaultUicontrolBackgroundColor') );

back_color = get (fig,'Color');
edit_box_back_color = [1 1 1];      % white

%% ------------------------------------ draw tools panel
tools_panel = uipanel('units', 'normalized', 'position' , [.005 .005 .99 .11] ,...  %% draw panel
    'parent' , fig,    'tag' , ' tools_panel'  , 'TitlePosition', 'righttop', ...
    'title' , 'tools');

uicontrol ('style', 'pushbutton', 'units', 'normalized', 'position', [0.003 0.1 0.12 0.8],...
    'HorizontalAlignment','center', 'FontWeight', 'bold','fontsize' , 12 ,...
    'string', 'simulation panel'  ,'tag', 'graphs_pushbutton', 'callback', @graphs_pushbutton_callback, 'parent' , tools_panel );

uicontrol ('style', 'pushbutton', 'units', 'normalized', 'position', [0.126 0.1 0.12 0.8],...
    'HorizontalAlignment','center', 'FontWeight', 'bold','fontsize' , 12 ,...
    'string', 'set parameters'  ,'tag', 'setparameters_pushbutton', 'callback', @setparameters_pushbutton_callback, 'parent' , tools_panel );

uicontrol ('style', 'pushbutton', 'units', 'normalized', 'position', [0.877 0.1 0.12 0.8],...
    'HorizontalAlignment','center', 'FontWeight', 'bold','fontsize' , 12 ,...
    'string', 'Exit'  ,'tag', 'exit_pushbutton', 'callback', @exit_pushbutton_callback, 'parent' , tools_panel );


%% ------------------------------------ draw graphs panel
graph_panel = uipanel('units', 'normalized', 'position' , [.005 .11 .99 .885] ,...  %% draw panel
    'parent' , fig,    'tag' , 'g_panel'  , 'TitlePosition', 'righttop', ...
    'title' , 'Graphs');

uicontrol ('style', 'pushbutton', 'units', 'normalized', 'position', [0.003 0.003 0.12 0.07],...
    'HorizontalAlignment','center', 'FontWeight', 'bold','fontsize' , 12 ,...
    'string', 'start'  ,'tag', 'start_pushbutton', 'callback', @start_pushbutton_callback, 'parent' , graph_panel );

uicontrol ('style', 'pushbutton', 'units', 'normalized', 'position', [0.126 0.003 0.12 0.07],...
    'HorizontalAlignment','center', 'FontWeight', 'bold','fontsize' , 12 ,'enable','off',...
    'string', 'stop'  ,'tag', 'stop_pushbutton', 'callback', @stop_pushbutton_callback, 'parent' , graph_panel );

uicontrol ('style', 'pushbutton', 'units', 'normalized', 'position', [0.875 0.003 0.12 0.07],...
    'HorizontalAlignment','center', 'FontWeight', 'bold','fontsize' , 12 ,'enable','on',...
    'string', 'save'  ,'tag', 'save_pushbutton', 'callback', @save_pushbutton_callback, 'parent' , graph_panel );

axes('parent',graph_panel,'tag','ax1','Position', [.04 .125 .58 .83]'); %define the axes space
axes('parent',graph_panel,'tag','ax2','Position',[.665 .4 .3 .5]); %define the axes space

%% ------------------------------------ draw Set Parameters panel
parameters_panel = uipanel('units', 'normalized', 'position' , [.005 .11 .99 .885] ,...  %% draw panel
    'parent' , fig,    'tag' , 'p_panel'  , 'TitlePosition', 'righttop', ...
    'title' , 'Set Parameters');
% --------------------------------------------------------- Field parameters
field_panel = uipanel('units', 'normalized', 'position' , [.005 .005 .3 .99] ,...  %% draw panel
    'parent' , parameters_panel,    'tag' , 'field_panel'  , 'TitlePosition', 'righttop', ...
    'title' , 'Field Initial Parameters');

uicontrol ('style', 'text', 'units', 'normalized', 'position', [0.05 0.9 0.9 0.1],...
    'HorizontalAlignment','left', 'FontWeight', 'bold','fontsize' , 12 ,...
    'string', 'F(r,z=0)=A*exp(-0.5*(r/w)^2)'  ,'tag', 'field_text', 'parent' , field_panel );

uicontrol ('style', 'text', 'units', 'normalized', 'position', [0.05 0.83 0.11 0.07],...
    'HorizontalAlignment','left', 'FontWeight', 'normal','fontsize' , 12 ,...
    'string', 'A = '  ,'tag', 'A_text', 'parent' , field_panel );

uicontrol ('style', 'edit', 'units', 'normalized', 'position', [0.165 0.83 0.15 0.07],...
    'HorizontalAlignment','center', 'FontWeight', 'normal','fontsize' , 12 ,...
    'string', '1' , 'backgroundcolor',[1 1 1],'tag', 'A_edit','enable','on', 'parent' , field_panel );

uicontrol ('style', 'text', 'units', 'normalized', 'position', [0.05 0.75 0.11 0.07],...
    'HorizontalAlignment','left', 'FontWeight', 'normal','fontsize' , 12 ,...
    'string', 'w = '  ,'tag', 'w_text', 'parent' , field_panel );

uicontrol ('style', 'edit', 'units', 'normalized', 'position', [0.165 0.75 0.15 0.07],...
    'HorizontalAlignment','center', 'FontWeight', 'normal','fontsize' , 12 ,...
    'string', '10' ,'backgroundcolor',[1 1 1],'tag', 'w_edit','enable','on', 'parent' , field_panel );

uicontrol ('style', 'text', 'units', 'normalized', 'position', [0.33 0.75 0.22 0.07],...
    'HorizontalAlignment','left', 'FontWeight', 'normal','fontsize' , 12 ,...
    'string', 'micrometer '  ,'tag', 'w_units_text', 'parent' , field_panel );

uicontrol ('style', 'text', 'units', 'normalized', 'position', [0.05 0.67 0.11 0.07],...
    'HorizontalAlignment','left', 'FontWeight', 'normal','fontsize' , 12 ,...
    'string', 'wave length'  ,'tag', 'lambda_text', 'parent' , field_panel );

uicontrol ('style', 'edit', 'units', 'normalized', 'position', [0.165 0.67 0.15 0.07],...
    'HorizontalAlignment','center', 'FontWeight', 'normal','fontsize' , 12 ,...
    'string', '0.5' ,'backgroundcolor',[1 1 1],'tag', 'lambda_edit','enable','on', 'parent' , field_panel );

uicontrol ('style', 'popupmenu', 'units', 'normalized', 'position', [0.33 0.67 0.3 0.07],...
    'HorizontalAlignment','left', 'FontWeight', 'normal','fontsize' , 12,'backgroundcolor',[1 1 1] ,...
    'string', {'micrometer','nanometer'} ,'tag', 'lambda_popup', 'callback', @lambda_popupmenu_callback, 'parent' , field_panel );

% --------------------------------------------------------- Medium Parameters ---
medium_panel = uipanel('units', 'normalized', 'position' , [.305 .005 .3 .99] ,...  %% draw panel
    'parent' , parameters_panel,    'tag' , 'medium_panel'  , 'TitlePosition', 'righttop', ...
    'title' , 'Medium Parameters');

tex=axes('parent',medium_panel,'tag','tex','Position', [.005 .98 .0001 .0001],'XTick',[],'YTick',[]); %define the axes space
text( 1,1, '\bfn=n_0+n_1exp(-\alphar^m/w^m)', 'parent' , tex ,'FontSize',12);

uicontrol ('style', 'popupmenu', 'units', 'normalized', 'position', [0.005 0.87 0.5 0.07],...
    'HorizontalAlignment','left', 'FontWeight', 'normal','fontsize' , 12 ,'backgroundcolor',[1 1 1],...
    'string', {'uniform','linear','quadratic','customize'} ,'tag', 'medium_popup', 'callback', @medium_popupmenu_callback, 'parent' , medium_panel );

tex=axes('parent',medium_panel,'tag','tex','Position', [.005 .8 .0001 .0001],'XTick',[],'YTick',[]); %define the axes space
text( 1,1, 'n_0 =', 'parent' , tex ,'FontSize',12);

uicontrol ('style', 'edit', 'units', 'normalized', 'position', [0.15 0.775 0.15 0.06],...
    'HorizontalAlignment','center', 'FontWeight', 'normal','fontsize' , 12 ,...
    'string', '1' ,'backgroundcolor',[1 1 1],'tag', 'n0_edit','enable','on', 'parent' , medium_panel );

tex=axes('parent',medium_panel,'tag','tex','Position', [.005 .73 .0001 .0001],'XTick',[],'YTick',[]); %define the axes space
text( 1,1, 'n_1 =', 'parent' , tex ,'FontSize',12);

uicontrol ('style', 'edit', 'units', 'normalized', 'position', [0.15 0.705 0.15 0.06],...
    'HorizontalAlignment','center', 'FontWeight', 'normal','fontsize' , 12 ,...
    'string', '0' ,'backgroundcolor',[1 1 1],'tag', 'n1_edit','enable','off', 'parent' , medium_panel );

tex=axes('parent',medium_panel,'tag','tex','Position', [.35 .74 .0001 .0001],'XTick',[],'YTick',[]); %define the axes space
text( 1,1, '*10^-^4', 'parent' , tex ,'FontSize',12);

tex=axes('parent',medium_panel,'tag','tex','Position', [.005 .66 .0001 .0001],'XTick',[],'YTick',[]); %define the axes space
text( 1,1, '\alpha =', 'parent' , tex ,'FontSize',12);

uicontrol ('style', 'edit', 'units', 'normalized', 'position', [0.15 0.635 0.15 0.06],...
    'HorizontalAlignment','center', 'FontWeight', 'normal','fontsize' , 12 ,...
    'string', '0.5' ,'backgroundcolor',[1 1 1],'tag', 'alpha_edit','enable','off', 'parent' , medium_panel );

tex=axes('parent',medium_panel,'tag','tex','Position', [.005 .59 .0001 .0001],'XTick',[],'YTick',[]); %define the axes space
text( 1,1, 'm =', 'parent' , tex ,'FontSize',12);

uicontrol ('style', 'edit', 'units', 'normalized', 'position', [0.15 0.565 0.15 0.06],...
    'HorizontalAlignment','center', 'FontWeight', 'normal','fontsize' , 12 ,...
    'string', '0' ,'backgroundcolor',[1 1 1],'tag', 'm_edit','enable','off', 'parent' , medium_panel );

uicontrol ('style', 'text', 'units', 'normalized', 'position', [0.001 0.47 0.8 0.07],...
    'HorizontalAlignment','left', 'FontWeight', 'bold','fontsize' , 12 ,...
    'string', 'max value of r = 1000*(wave length)'  ,'tag', 'r_max_text', 'parent' , medium_panel );

uicontrol ('style', 'text', 'units', 'normalized', 'position', [0.001 0.415 0.8 0.07],...
    'HorizontalAlignment','left', 'FontWeight', 'bold','fontsize' , 12 ,...
    'string', 'size of propagation step:'  ,'tag', 'dz_size_text', 'parent' , medium_panel );

uicontrol ('style', 'text', 'units', 'normalized', 'position', [0.05 0.365 0.15 0.07],...
    'HorizontalAlignment','left', 'FontWeight', 'bold','fontsize' , 12 ,...
    'string', 'dz ='  ,'tag', 'dz_text', 'parent' , medium_panel );

 uicontrol ('style', 'edit', 'units', 'normalized', 'position', [0.16 0.38 0.15 0.06],...
     'HorizontalAlignment','center', 'FontWeight', 'normal','fontsize' , 12 ,...
     'string', '5' ,'backgroundcolor',[1 1 1],'tag', 'dz_edit','enable','on', 'parent' , medium_panel );
 
 uicontrol ('style', 'text', 'units', 'normalized', 'position', [0.35 0.365 0.3 0.07],...
     'HorizontalAlignment','left', 'FontWeight', 'bold','fontsize' , 12 ,...
     'string', 'micrometer'  ,'tag', 'dz_unit_text', 'parent' , medium_panel );
 
 uicontrol ('style', 'text', 'units', 'normalized', 'position', [0.001 0.285 0.8 0.07],...
     'HorizontalAlignment','left', 'FontWeight', 'bold','fontsize' , 12 ,...
     'string', 'propagation distance:'  ,'tag', 'z_distance_text', 'parent' , medium_panel );
 
 uicontrol ('style', 'text', 'units', 'normalized', 'position', [0.05 0.235 0.15 0.07],...
     'HorizontalAlignment','left', 'FontWeight', 'bold','fontsize' , 12 ,...
     'string', 'z ='  ,'tag', 'z_text', 'parent' , medium_panel );

uicontrol ('style', 'edit', 'units', 'normalized', 'position', [0.16 0.25 0.15 0.06],...
    'HorizontalAlignment','center', 'FontWeight', 'normal','fontsize' , 12 ,...
    'string', '1000' ,'backgroundcolor',[1 1 1],'tag', 'steps_edit','enable','on', 'parent' , medium_panel );

uicontrol ('style', 'popupmenu', 'units', 'normalized', 'position', [0.35 0.237 0.28 0.07],...
    'HorizontalAlignment','left', 'FontWeight', 'normal','fontsize' , 12 ,'backgroundcolor',[1 1 1],...
    'string', {'dz steps','micrometer'} ,'tag', 'steps_popup', 'callback', @steps_popupmenu_callback, 'parent' , medium_panel );

%
%% ------------------------------------ prepare gui_handles
h = guihandles;                                                                            % get handles of uicontrols
h.fig = fig;                                                                                      % figures handle
h.object = [];                                                                                    % instrument object
h.back_color = back_color;                                                 % figure's background color
h.edit_box_back_color = edit_box_back_color;   % edit box background color
h.start_itr = 1;
h.Output = [];

h.dir_path = fileparts(mfilename('fullpath')); % path of the gui mfile
%
%% ------------------------------------ show figure
% update guidata
guidata ( fig, h );

% show figure
hide_object(parameters_panel);
show_object(graph_panel);
movegui(fig,'center');
set(gcf,'Visible','on');

% focus on uicontrol
focus_on(h.start_pushbutton);
end
%
%% ============================================== focus_on uicontrol ===
function focus_on ( hObject )
% focus on uicontrol only if figure is visible
h = guidata (hObject);
visible_fig = findobj(h.fig,'flat','Visible','on');
if ~isempty(visible_fig)
    uicontrol(hObject);
    drawnow expose;
end
end
%
%% ============================================== hide_object ===
function hide_object (hObject)
set ( hObject, 'Visible', 'off' );
end
%
%% ============================================== show_object ===
function show_object (hObject)
set ( hObject, 'Visible', 'on' );
drawnow expose;
end
%
%% ============================================== callbacks ===
%
%% ============================================== exit_pushbutton_callback ===
function exit_pushbutton_callback (hObject,eventdata)
e = exist ('data_bpm_tmp.mat','file');
if e==2
    delete('data_bpm_tmp.mat');
end
close;                                      % close GUI and all open ports
                                            % (see close_figure_callback)
end
%
%% ============================================== close_figure_callback ===
function close_figure_callback (hObject,eventdata)
stop_pushbutton_callback (hObject,eventdata);
end
%
%% ============================================== stop_pushbutton_callback ===
function stop_pushbutton_callback (hObject,eventdata)
h = guidata(hObject);
set(findobj('tag','stop_pushbutton'),'enable','off');
set(findobj('tag','start_pushbutton'),'enable','on','BackGroundColor',h.back_color,'string','start');
set(findobj('tag','setparameters_pushbutton'),'enable','on');
set(findobj('tag','graphs_pushbutton'),'enable','on');
end
%
%% ============================================== start_pushbutton_callback ===
function flag = start_pushbutton_callback (hObject,flag)
h = guidata(hObject);
get(findobj('tag','start_pushbutton'),'string');

set(findobj('tag','stop_pushbutton'),'enable','on');
set(findobj('tag','setparameters_pushbutton'),'enable','off');
set(findobj('tag','graphs_pushbutton'),'enable','off');
set(findobj('tag','start_pushbutton'),'enable','off','string','running','BackGroundColor',[0 1 0]);
% --------------------------------------------------------------------------

[A w Lam n0 deltaN alpha m dz z]=get_data_from_gui(h);
% Propagation of gaussian using BPM

NR          =     2^13;                % Numerical Resolution

%************Propagating Parameters ********%
steps=round(z/dz);                                          % max value of z-axis
%************Medium Parameters **********%
x_max=1000*Lam;                                        % maximum value of x-axis
%........................................................................%
dx = 2*x_max/(NR-1);
x = -x_max : dx : x_max;
dkx = pi/(x_max)*(NR-1)/NR;
kx = ( (-NR/2):(NR/2-1) )*dkx;
k0  = 2*pi/Lam;
%........................................................................%

%************Inpout Field  Parameters****************%

fz=A*exp(-0.5*(abs(x)/w).^2);        % initial field distribution

N=deltaN*exp(-alpha*(abs(x)/w).^m);

    start_itr = 1;
    Output = zeros(NR,steps);
    Output(:,1) = abs(fz).^2;

%%%%%%%%%%%%%%%%%%%%%%%%
%************PROPAGATION *****************%
%%%%%%%%%%%%%%%%%%%%%%%%
    Fz=ifftshift(ifft(ifftshift(fz)));
    Fz_d=Fz.*exp(1i*(kx.^2)./(2*k0*(n0+N))*dz/2);
    fz=fftshift(fft(fftshift(Fz_d)));

for itr=start_itr:steps-1
    
    fz_N=fz.*exp(-1i*N*k0*dz);
    Fz=ifftshift(ifft(ifftshift(fz_N)));
    D=exp(1i*(kx.^2)./(2*k0*(n0+N))*dz);
    Fz_D=Fz.*D;
    fz=fftshift(fft(fftshift(Fz_D)));
    
    plot(h.ax1,x,abs(fz).^2);
    axis(h.ax1,[-0.5*10^-4 0.5*10^-4 0 4*A]);
    set(get(h.ax1,'XLabel'),'String','\bfr [m]');
    set(get(h.ax1,'YLabel'),'String','\bfI [r]');
    set(get(h.ax1,'Title'),'String','\bfIntensity');
    
    Output(:,itr)=abs(fz).^2;
    
    imagesc((0:itr)*dz,x,Output(:,1:itr),'parent',h.ax2);
    colormap('hot');
    ylim(h.ax2,[-0.5*10^-4 0.5*10^-4]);
    set(get(h.ax2,'XLabel'),'String','\bfz [m]');
    set(get(h.ax2,'YLabel'),'String','\bfr [m]');
    set(get(h.ax2,'Title'),'String','\bfIntensity Map');
    drawnow;
    
    val1 = get(findobj('tag','stop_pushbutton'),'enable');
    if strcmp(val1,'off')
        break
    end
    
end

Fz=ifftshift(ifft(ifftshift(fz)));
Fz_d=Fz.*exp(1i*(kx.^2)./(2*k0*(n0+N))*dz/2);
fz=fftshift(fft(fftshift(Fz_d)));

Output(:,itr+1)=abs(fz).^2;
save('data_bpm_tmp.mat','Output');

plot(h.ax1,x,abs(fz).^2);
axis(h.ax1,[-0.5*10^-4 0.5*10^-4 0 4*A]);
set(get(h.ax1,'XLabel'),'String','\bfr [m]');
set(get(h.ax1,'YLabel'),'String','\bfI [r]');
set(get(h.ax1,'Title'),'String','\bfIntensity');

imagesc((0:itr)*dz,x,Output(:,1:itr+1),'parent',h.ax2);
colormap('hot');
ylim(h.ax2,[-0.5*10^-4 0.5*10^-4]);
set(get(h.ax2,'XLabel'),'String','\bfz [m]');
set(get(h.ax2,'YLabel'),'String','\bfr [m]');
set(get(h.ax2,'Title'),'String','\bfIntensity Map');

% ---------------------------------------------
    set(findobj('tag','start_pushbutton'),'enable','on','string','running','BackGroundColor',h.back_color,'string','start');
    set(findobj('tag','stop_pushbutton'),'enable','off');
    set(findobj('tag','setparameters_pushbutton'),'enable','on');
    set(findobj('tag','graphs_pushbutton'),'enable','on');
end
%
%% ============================================== save_pushbutton_callback ===
function save_pushbutton_callback (hObject,eventdata)
h = guidata(hObject);
e = exist ('data_bpm_tmp.mat','file');
if e==2
    load('data_bpm_tmp.mat');
else
    Output = [];
end
uisave('Output','BPM Simulation.mat');
end
%
%% ============================================== graphs_pushbutton_callback ===
function graphs_pushbutton_callback (hObject,eventdata)
h=guidata(hObject);
hide_object(h.p_panel);
show_object(h.g_panel);
end
%
%% ============================================== setparameters_pushbutton_callback ===
function setparameters_pushbutton_callback (hObject,eventdata)
h=guidata(hObject);
hide_object(h.g_panel);
show_object(h.p_panel);

% focus on uicontrol
focus_on(h.start_pushbutton);
end
%
%% ============================================== lambda_popupmenu_callback ===
function lambda_popupmenu_callback (hObject,eventdata)
h=guidata(hObject);
val=get(h.lambda_popup,'value');
lambda_edit=findobj('tag','lambda_edit');
lambda=get(lambda_edit,'string');

switch val
    case 1
        new_lambda=num2str(str2double(lambda)/1000);
        set(lambda_edit,'string',new_lambda);
    case 2
        new_lambda=num2str(str2double(lambda)*1000);
        set(lambda_edit,'string',new_lambda);
end
end
%
%% ============================================== medium_popupmenu_callback ===
function medium_popupmenu_callback (hObject,eventdata)
h=guidata(hObject);
val=get(h.medium_popup,'value');
n0=findobj('tag','n0_edit');
n1=findobj('tag','n1_edit');
alpha=findobj('tag','alpha_edit');
m=findobj('tag','m_edit');

switch val
    case 1
        set(n0,'enable','on');
        set(n1,'enable','off','string','0');
        set(alpha,'enable','off','string','0.5');
        set(m,'enable','off','string','0');
    case 2
        set(n0,'enable','on');
        set(n1,'enable','on','string','10');
        set(alpha,'enable','on');
        set(m,'enable','off','string','1');
    case 3
        set(n0,'enable','on');
        set(n1,'enable','on','string','10');
        set(alpha,'enable','on');
        set(m,'enable','off','string','2');
    case 4
        set(n0,'enable','on');
        set(n1,'enable','on');
        set(alpha,'enable','on');
        set(m,'enable','on');
end

end
%
%% ============================================== steps_popupmenu_callback ===
function steps_popupmenu_callback (hObject,eventdata)
h=guidata(hObject);
val=get(h.steps_popup,'value');
steps_edit=findobj('tag','steps_edit');
steps=get(steps_edit,'string');
dz=str2double(get(findobj('tag','dz_edit'),'string'));

switch val
    case 1
        new_steps=num2str(round(str2double(steps)/dz));
        set(steps_edit,'string',new_steps);
    case 2
        new_steps=num2str(round(str2double(steps)*dz));
        set(steps_edit,'string',new_steps);
end

end
%
%% ============================================== get_data_from_gui ===
function [A w lambda n0 n1 alpha m dz z]=get_data_from_gui(h)
A_text=get(h.A_edit,'string');
A=str2double(A_text);

w_text=get(h.w_edit,'string');
w=str2double(w_text);
w=w*10^(-6);

lambda_text=get(h.lambda_edit,'string');
lambda=str2double(lambda_text);
w_val=get(h.lambda_popup,'value');
switch w_val
    case 1
        lambda=lambda*10^(-6);
    case 2   
        lambda=lambda*10^(-9);
end

n0_text=get(h.n0_edit,'string');
n0=str2double(n0_text);

n1_text=get(h.n1_edit,'string');
n1=str2double(n1_text);
n1=n1*10^(-4);

alpha_text=get(h.alpha_edit,'string');
alpha=str2double(alpha_text);

m_text=get(h.m_edit,'string');
m=str2double(m_text);

dz_text=get(h.dz_edit,'string');
dz=str2double(dz_text);
dz=dz*10^(-6);

z_text=get(h.steps_edit,'string');
z=str2double(z_text);
z_val=get(h.steps_popup,'value');
switch z_val
    case 1
        z=z*dz;
    case 2   
        z=z*10^(-6);
end
end
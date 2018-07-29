% frap_analysis - a program for the analysis of FRAP images.
% Version 2.5 (7 June 2009)
%   The theory behind the program is presented in the article "Jönsson, P.,
%   M. P. Jonsson, J. O. Tegenfeldt, and F. Höök. 2008. A Method Improving
%   the Accuracy of Fluorescence Recovery After Photobleaching Analysis.
%   Biophys J 95:5334-5348." (doi: 10.1529/biophysj.108.134874). When using this
%   program please site the above reference.
%
%   The data needed for the analysis should be a tif-file containing:
%   1) At least one pre-bleach image (or an estimate of the pre-bleach 
%      intensity assuming a flat illumination profile).
%   2) An estimate of the dark counts (e.g. an image with the light source
%      turned off).
%   3) A series of post-bleach images, where the bleached spot in the first
%      post-bleach image should be fully contained within the image.
%   4) Information about the time between frames and the size of a pixel in
%      the images (square pixels are assumed). 
% 
%   The program calculates the parameters D1, D2, gamma2 and gamma0 from
%   the experimental data. D1 and D2 are two diffusion coefficients,
%   characterizing two diffusing components in the system, while gamma2 is
%   the fraction of the second component and gamma0 the fraction of
%   immobile molecules. If the system can be described with a single
%   diffusing component then gamma2 = 0.
%   The program also outputs D1k, which is the value of D1(k) determined
%   for each individual spatial frequency k.
%   The user can further choose to track the center of mass of the bleached
%   spot as a function of time to monitor convective motion.
%   The units in the analysis are: [k] = um^-1, [D1] = [D2] = [D1k] =
%   um^2s^-1.
%
%   For additional information about the program the user is refered to
%   "General info about FRAP and frap_analysis.pdf", which includes an
%   Appendix session which describes the individual steps in the analysis.
%
%   All code was tested using Matlab R2008b.

function frap_analysis

%  Initializes the GUI and creates one panel to the left and two panels to
%  the right

% closes the figures
close(figure(99))
close(figure(98))
close(figure(1))
close(figure(2))
close(figure(3))
close(figure(4))
close(figure(5))
close(figure(6))
close(figure(7))
close(figure(8))

f=figure(99);
clf
set(f,'Visible','off','Position',[0,0,750,500]);
leftPanel = uipanel('bordertype','etchedin',...
    'Position', [0.05*500/750 0.05 0.8*500/750 0.9],...
    'Backgroundcolor','default','Visible','on',...
    'Parent',f);
rightTopPanel = uipanel('bordertype','etchedin',...
    'Position', [0.9*500/750 0.375 1-0.85*500/750-0.1*500/750 0.575],...
    'Backgroundcolor','default','Visible','on',...
    'Parent',f);
rightBottomPanel = uipanel('bordertype','etchedin',...
    'Position', [0.9*500/750 0.125 1-0.85*500/750-0.1*500/750 0.225],...
    'Backgroundcolor','default','Visible','on',...
    'Parent',f);

% Constructs the components in the gui
sh=uicontrol(leftPanel,'Style','slider',...
    'Max',100,'Min',1,'Value',1,'Visible','off',...
    'SliderStep',[1/(100-1) 5/(100-1)],'Units','normalized',...
    'Position',[0 0 1 (1-0.8/0.9)/2],...
    'Callback',{@sh_Callback});
txt_frm=uicontrol(leftPanel,'Style','text',...
    'String','Frame:','Units','normalized','Visible','off',...
    'Position',[0 1-(1-0.8/0.9)/2 1 (1-0.8/0.9)/2],'FontSize',10,...
    'HorizontalAlignment','left','Backgroundcolor','default');

txt_pre1=uicontrol(rightTopPanel,'Style','text','String','First pre-bleach frame:',...
    'Units','normalized','FontSize',10,'HorizontalAlignment','left',...
    'Position',[0.05,0.91,0.5,0.06]);
edit_pre1=uicontrol(rightTopPanel,'Style','edit','String','1','Units','normalized',...
    'Position',[0.6,0.91,0.15,0.06],'FontSize',10,'HorizontalAlignment','center');
uicontrol(rightTopPanel,'Style','pushbutton','Units','normalized',...
    'String','Get','Position',[0.8,0.91,0.15,0.06],...
    'Callback',{@btn_pre1_Callback});
uicontrol(rightTopPanel,'Style','text','String','Last pre-bleach frame:',...
    'Units','normalized','FontSize',10,'HorizontalAlignment','left',...
    'Position',[0.05,0.84,0.5,0.06]);
edit_pre2=uicontrol(rightTopPanel,'Style','edit','String','2','Units','normalized',...
    'Position',[0.6,0.84,0.15,0.06],'FontSize',10,'HorizontalAlignment','center');
btn_pre2=uicontrol(rightTopPanel,'Style','pushbutton','Units','normalized',...
    'String','Get','Position',[0.8,0.84,0.15,0.06],...
    'Callback',{@btn_pre2_Callback});
uicontrol(rightTopPanel,'Style','text','String','Dark count value:',...
    'Units','normalized','FontSize',10,'HorizontalAlignment','left',...
    'Position',[0.05,0.77,0.5,0.06]);
edit_dc=uicontrol(rightTopPanel,'Style','edit','String','','Units','normalized',...
    'Position',[0.6,0.77,0.15,0.06],'FontSize',10,'HorizontalAlignment','center',...
    'Callback',{@edit_dc_Callback});
uicontrol(rightTopPanel,'Style','pushbutton','Units','normalized',...
    'String','Get','Position',[0.8,0.77,0.15,0.06],...
    'Callback',{@btn_dc_Callback});
uicontrol(rightTopPanel,'Style','text','String','First post-bleach frame:',...
    'Units','normalized','FontSize',10,'HorizontalAlignment','left',...
    'Position',[0.05,0.7,0.52,0.06]);
edit_pb1=uicontrol(rightTopPanel,'Style','edit','String','4','Units','normalized',...
    'Position',[0.6,0.7,0.15,0.06],'FontSize',10,'HorizontalAlignment','center');
uicontrol(rightTopPanel,'Style','pushbutton','Units','normalized',...
    'String','Get','Position',[0.8,0.7,0.15,0.06],...
    'Callback',{@btn_pb1_Callback});
uicontrol(rightTopPanel,'Style','text','String','Last post-bleach frame:',...
    'Units','normalized','FontSize',10,'HorizontalAlignment','left',...
    'Position',[0.05,0.63,0.52,0.06]);
edit_pb2=uicontrol(rightTopPanel,'Style','edit','String','','Units','normalized',...
    'Position',[0.6,0.63,0.15,0.06],'FontSize',10,'HorizontalAlignment','center');
uicontrol(rightTopPanel,'Style','pushbutton','Units','normalized',...
    'String','Get','Position',[0.8,0.63,0.15,0.06],...
    'Callback',{@btn_pb2_Callback});
uicontrol(rightTopPanel,'Style','text','String','Omit frame(s):',...
    'Units','normalized','FontSize',10,'HorizontalAlignment','left',...
    'Position',[0.05,0.56,0.32,0.06]);
edit_omit=uicontrol(rightTopPanel,'Style','edit','String','','Units','normalized',...
    'Position',[0.4,0.56,0.35,0.06],'FontSize',10,'HorizontalAlignment','left');
uicontrol(rightTopPanel,'Style','pushbutton','Units','normalized',...
    'String','Get','Position',[0.8,0.56,0.15,0.06],...
    'Callback',{@btn_omit_Callback});
uicontrol(rightTopPanel,'Style','text','String','r_max [pixels]:',...
    'Units','normalized','FontSize',10,'HorizontalAlignment','left',...
    'Position',[0.05,0.49,0.32,0.06]);
edit_rmax=uicontrol(rightTopPanel,'Style','edit','String','','Units','normalized',...
    'Position',[0.4,0.49,0.35,0.06],'FontSize',10,'HorizontalAlignment','center');
uicontrol(rightTopPanel,'Style','pushbutton','Units','normalized',...
    'String','Get','Position',[0.8,0.49,0.15,0.06],...
    'Callback',{@btn_rmax_Callback});
uicontrol(rightTopPanel,'Style','text','String','Pixelwidth [um]:',...
    'Units','normalized','FontSize',10,'HorizontalAlignment','left',...
    'Position',[0.05,0.37,0.7,0.06]);
edit_dx=uicontrol(rightTopPanel,'Style','edit','String','0.267','Units','normalized',...
    'Position',[0.65,0.37,0.3,0.06],'FontSize',10,'HorizontalAlignment','center');
txt_dt=uicontrol(rightTopPanel,'Style','text','String','Time between frames [s]:',...
    'Units','normalized','FontSize',10,'HorizontalAlignment','left',...
    'Position',[0.05,0.30,0.7,0.06]);
edit_dt=uicontrol(rightTopPanel,'Style','edit','String','2','Units','normalized',...
    'Position',[0.65,0.30,0.3,0.06],'FontSize',10,'HorizontalAlignment','center');
cbx_pre=uicontrol(rightTopPanel,'Style','checkbox',...
    'String','  Use pre-bleach frame','Units','normalized',...
    'FontSize',10,'HorizontalAlignment','left',...
    'Value',1,'Position',[0.05 0.18 0.8 0.06],'Callback',{@cbx_pre_Callback});
cbx_times=uicontrol(rightTopPanel,'Style','checkbox',...
    'String','  Define individual time points','Units','normalized',...
    'FontSize',10,'HorizontalAlignment','left',...
    'Value',0,'Position',[0.05 0.11 0.8 0.06],'Callback',{@cbx_times_Callback});
cbx_trc=uicontrol(rightTopPanel,'Style','checkbox',...
    'String','  Track the center of mass','Units','normalized',...
    'FontSize',10,'HorizontalAlignment','left',...
    'Value',0,'Position',[0.05 0.04 0.8 0.06]);

txt_imin=uicontrol(rightBottomPanel,'Style','text','String','Imin = 1',...
    'Units','normalized','FontSize',10,'HorizontalAlignment','left',...
    'Position',[0.05,0.72,0.35,0.175]);
sh_imin=uicontrol(rightBottomPanel,'Style','slider',...
    'Max',100,'Min',1,'Value',1,'Visible','on',...
    'SliderStep',[1/(100-1) 5/(100-1)],'Units','normalized',...
    'Position',[0.45 0.72 0.5 0.175],...
    'Callback',{@sh_imin_Callback});
txt_imax=uicontrol(rightBottomPanel,'Style','text','String','Imax = 10000',...
    'Units','normalized','FontSize',10,'HorizontalAlignment','left',...
    'Position',[0.05,0.44,0.35,0.175]);
sh_imax=uicontrol(rightBottomPanel,'Style','slider',...
    'Max',100,'Min',1,'Value',100,'Visible','on',...
    'SliderStep',[1/(100-1) 5/(100-1)],'Units','normalized',...
    'Position',[0.45 0.44 0.5 0.175],...
    'Callback',{@sh_imax_Callback});
uicontrol(rightBottomPanel,'Style','pushbutton','Units','normalized',...
    'String','Auto','Position',[0.75,0.12,0.2,0.2],...
    'FontSize',10,'Callback',{@btn_Iauto_Callback});

uicontrol(f,'Style','pushbutton','Units','normalized',...
    'String','Start','Position',[0.73,0.05,0.1,0.05],...
    'FontSize',10,'Callback',{@btn_start_Callback});

% Creates the menus
set(f,'MenuBar','none');
menu_file=uimenu(f,'Label','File');
uimenu(menu_file,'Label','Open','Callback',{@menu_Open_Callback},...
    'Accelerator','O');
uimenu(menu_file,'Label','Exit','Callback',{@menu_Exit_Callback},...
    'Separator','on','Accelerator','Q');

% Assigns the GUI a name to appear in the window title.
set(f,'NumberTitle','off')
set(f,'Name','frap_analysis')

% Moves the GUI to the center of the screen.
movegui(f,'center')

% Makes the GUI visible.
set(f,'Visible','on');

% Creates axes to the images to appear in
ax_f=axes('Units','pixels','Parent',leftPanel,'Units','normalized',...
    'Position',[0 (1-0.80/0.9)/2 1 0.80/0.9],'Visible','off');

% Defines variables
FileName='';    % the name of the image file   
file_in=[];     % the filename + directory of the image stack
api=[];         % API associated with the line handle used to determine rmax
frm_max=1;      % the length of the image stack
I=[];           % matrix consisting of the current image
ib_min=[];      % min intensity in the images
ib_max=[];      % max intensity in the images
Idark=[];       % dark count intensity
Ipb=[];
default_dir='D:\Filmer\FRAP\';   % Default directory for images

    % btn_pre1_Callback - gets the first pre-bleach frame from the frame number
    %   of the currently displayed image
    function btn_pre1_Callback(source,eventdata)
        if ~isempty(file_in)
            if get(cbx_pre,'Value')==0
                % the pre-bleach intensity is determined within the region
                % Bpb
                Bpb=roipoly;
                Ipb=mean(I(Bpb));
                set(edit_pre1,'String',num2str(round(Ipb)));
            else
                set(edit_pre1,'String',num2str(get(sh,'Value')));
                Ipb=[];
            end
        end
    end

    % btn_pre2_Callback - gets the last pre-bleach frame from the frame number
    %   of the currently displayed image
    function btn_pre2_Callback(source,eventdata)
        if ~isempty(file_in)
            set(edit_pre2,'String',num2str(get(sh,'Value')));
        end
    end

    % btn_dc_Callback - determines the value of the dark count intensity
    function btn_dc_Callback(source,eventdata)
        if ~isempty(file_in)
            % the dark count intensity is determined within the region Bdc
            Bdc=roipoly; 
            Idark=mean(I(Bdc));
            set(edit_dc,'String',num2str(round(Idark)));
        end
    end

    % btn_pb1_Callback - gets the first post-bleach frame from the frame number
    %   of the currently displayed image
    function btn_pb1_Callback(source,eventdata)
        if ~isempty(file_in)
            set(edit_pb1,'String',num2str(get(sh,'Value')));
        end
    end

    % btn_pb2_Callback - gets the last post-bleach frame from the frame number
    %   of the currently displayed image. Left unassigned makes the last
    %   image in the stack being also the last image in the analyzed stack.
    function btn_pb2_Callback(source,eventdata)
        if ~isempty(file_in)
            set(edit_pb2,'String',num2str(get(sh,'Value')));
        end
    end

    % btn_rmax_Callback - determines the maximum radial distance to be used
    %   in the analysis
    function btn_rmax_Callback(source,eventdata)
        if ~isempty(file_in)
            if isempty(api)
                iml=imline(ax_f,[255 255],[255 255]);
                api=iptgetapi(iml);
            end
            rp=api.getPosition();
            Rp_max=sqrt((rp(2,1)-rp(1,1))^2+(rp(2,2)-rp(1,2))^2);
            set(edit_rmax,'String',num2str(Rp_max))
        end
    end

    % btn_omit_Callback - determines which frames to omit from the analysis
    function btn_omit_Callback(source,eventdata)
        if ~isempty(file_in)
            str_omit=get(edit_omit,'String');
            if isempty(str_omit)
                set(edit_omit,'String',num2str(get(sh,'Value')));
            else
                set(edit_omit,'String',[str_omit,',',num2str(get(sh,'Value'))]);
            end
        end
    end

    % edit_dc_Callback - uppdates the value of I_dc
    function edit_dc_Callback(source,eventdata)
        str_Idc=get(edit_dc,'String');
        if isempty(str_Idc)
            Idark=[];
        else
            Idark=str2double(str_Idc);
        end
    end

    % btn_start_Callback - calls the routine calc_frap which does the
    %   analysis of the FRAP images to determine the diffusion parameters
    function btn_start_Callback(source,eventdata)
        if ~isempty(file_in)
            dx=str2double(get(edit_dx,'String'));
            
            if isempty(Idark)
                Idark2=0;
            else
                Idark2=Idark;
            end

            if get(cbx_pre,'Value')==0
                Ipre=ones(size(I))*Ipb-Idark2;
            else
                % A single pre-bleach image is obtained by averaging the pre-bleach images
                % between the first and last pre-bleach frame selected.
                ipb1=str2double(get(edit_pre1,'String'));
                ipb2=str2double(get(edit_pre2,'String'));
                Ipre=double(imread(file_in,ipb1))-Idark2;
                for i=ipb1+1:ipb2
                    Ipre=Ipre+double(imread(file_in,i))-Idark2;
                end
                Ipre=Ipre/(ipb2-ipb1+1);            
            end
            Ipre(Ipre==0)=1;
            
            istart=str2double(get(edit_pb1,'String'));
            iend=get(edit_pb2,'String');
            if isempty(iend)
                iend=length(imfinfo(file_in));
            else
                iend=str2double(iend);
            end
            
            nbr_frames=iend-istart+1;   % Number of post-bleach frames used
            if (istart+nbr_frames-1)>length(imfinfo(file_in))
                nbr_frames=length(imfinfo(file_in))-istart+1;
            end
            
            % t = frame times
            if get(cbx_times,'Value')==1
                t=str2num(get(edit_dt,'String'));
                t=t-t(1);   % automatically sets the first time to zero
                if length(t)~=nbr_frames
                    return
                end
            else
                dt=str2double(get(edit_dt,'String'));              
                t=(0:1:nbr_frames-1)*dt;
            end
            
            if get(cbx_trc,'Value')==1
                trc='y';
            else
                trc='n';
            end
            
            Rp_max=get(edit_rmax,'String');
            if ~isempty(Rp_max)
                Rp_max=str2double(Rp_max);
            else
                Rp_max=[];
            end

            nr=ones(size(t));
            omit_fr=get(edit_omit,'String');
            if ~isempty(omit_fr)
                omit_fr=str2num(omit_fr);
                for i=1:length(omit_fr)
                    nr(omit_fr(i)-istart+1)=0;
                end
            end
            calc_frap(file_in,dx,Ipre,Idark2,istart,t,trc,Rp_max,nr);
        end
    end

    % sh_Callback - determines which image to show
    function sh_Callback(source,eventdata)
        if ~isempty(file_in)
            frm=get(sh,'Value');
            set(sh,'Value',round(frm));
            frm=round(frm);
            I=double(imread(file_in,frm));
            imshow_frap(I,[ib_min,ib_max],ax_f);
            set(txt_frm,'String',[FileName,' - ',num2str(frm)])
        end
        api=[];
    end

    % sh_imin_Callback - updates the min intensity settings for the images
    %   (coupled to the imin slider)
    function sh_imin_Callback(source,eventdata)
        ib_min=round(get(sh_imin,'Value'));
        if ib_min>ib_max
            ib_min=ib_max-1;
            set(sh_imin,'Value',ib_min);
        end
        set(txt_imin,'String',['Imin = ',num2str(ib_min)]);
        if ~isempty(file_in)
            imshow_frap(I,[ib_min,ib_max],ax_f);
        end
    end

    % sh_imax_Callback - updates the max intensity settings for the images
    %   (coupled to the imax slider)
    function sh_imax_Callback(source,eventdata)
        ib_max=round(get(sh_imax,'Value'));
        if ib_max<ib_min
            ib_max=ib_min+1;
            set(sh_imax,'Value',ib_max);
        end
        set(txt_imax,'String',['Imax = ',num2str(ib_max)]);
        if ~isempty(file_in)
            imshow_frap(I,[ib_min,ib_max],ax_f);
        end
    end

    % btn_Iauto_Callback - automatically sets the min and max intensities
    % to those in the current image
    function btn_Iauto_Callback(source,eventdata)
        if ~isempty(file_in)
            ib_min=min(I(:));
            ib_max=max(I(:));
            set(txt_imin,'String',['Imin = ',num2str(ib_min)]);
            set(txt_imax,'String',['Imax = ',num2str(ib_max)]);
            set(sh_imin,'Value',ib_min);
            set(sh_imax,'Value',ib_max);
            imshow_frap(I,[ib_min,ib_max],ax_f);
        end
    end

    % cbx_pre_Callback - determines whether to use a pre-bleach frame to
    % compensate for uneven illumination or to assume a flat illumination 
    % with a user specified pre-bleach intensity
    function cbx_pre_Callback(source,eventdata)
        if get(cbx_pre,'Value')==0
            set(txt_pre1,'String','Pre-bleach intensity:');
            set(edit_pre2,'Enable','off');
            set(btn_pre2,'Enable','off');
        else
            set(txt_pre1,'String','First pre-bleach frame:');
            set(edit_pre2,'Enable','on');
            set(btn_pre2,'Enable','on');
        end
    end

    % cbx_times_Callback - determines whether to use individual values of
    % the times for all frames or just the time between frames
    function cbx_times_Callback(source,eventdata)
        if get(cbx_times,'Value')==0
            set(txt_dt,'String','Time between frames [s]:');
            set(edit_dt,'Position',[0.65,0.3,0.3,0.06],'HorizontalAlignment','center');
        else
            set(txt_dt,'String','Frame times [s]:')
            set(edit_dt,'Position',[0.45,0.3,0.5,0.06],'HorizontalAlignment','left','String','');
        end
    end

    % menu_Open_Callback - chooses the image stack to analyze
    function menu_Open_Callback(source,eventdata)
        % Displays a dialog box from where to choose the images to be analyzed
        [FileName,PathName] = uigetfile('*.tif','Select the image-file',default_dir);
        if FileName==0
            return
        end
        
        default_dir=PathName;
        file_in=strcat(PathName,FileName);
        
        if length(imfinfo(file_in))==1
            error('The FRAP data should be a TIF-stack containing atleast 2 frames')
            return
        end
        
        set(txt_frm,'String',[FileName,' - 1'],'Visible','on')
        I=double(imread(file_in,1));
        set(sh,'Value',1,'Visible','on');

        fw=500/750*size(I,2)/size(I,1);
        set(leftPanel,'Position',...
            [0.05*fw 0.05 0.8*fw 0.9],...
            'Visible','on');
        set(ax_f,'Visible','on')

        frm_max=length(imfinfo(file_in));
        set(sh,'Max',frm_max,'Min',1,...
            'SliderStep',[1/(frm_max-1) 10/(frm_max-1)]);
        axis off 
        
        set(sh_imin,'Max',max(2^14,max(I(:))),'Min',0,...
            'SliderStep',[1/max(2^14,max(I(:))) 10/max(2^14,max(I(:)))],...
            'Value',min(I(:)),'SliderStep',[1/max(2^14,max(I(:))) 50/max(2^14,max(I(:)))]);
        set(sh_imax,'Max',max(2^14,max(I(:))),'Min',0,...
            'SliderStep',[1/max(2^14,max(I(:))) 10/max(2^14,max(I(:)))],...
            'Value',max(I(:)),'SliderStep',[1/max(2^14,max(I(:))) 50/max(2^14,max(I(:)))]);
        
        ib_min=round(get(sh_imin,'Value'));
        set(txt_imin,'String',['Imin = ',num2str(ib_min)]);
        ib_max=round(get(sh_imax,'Value'));
        set(txt_imax,'String',['Imax = ',num2str(ib_max)]);
        imshow_frap(I,[ib_min,ib_max],ax_f);
        api=[];
    end

    % menu_Exit_Callback - ends the program
    function menu_Exit_Callback(source,eventdata)
        
        % closes the figures
        close(f)
        close(figure(98))
        close(figure(1))
        close(figure(2))
        close(figure(3))
        close(figure(4))
        close(figure(5))
        close(figure(6))
        close(figure(7))
        close(figure(8))

    end
end

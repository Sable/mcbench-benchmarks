function robotics(varargin)

%  this code draws 16 robot.
%  just type robotics in matlab 
%  
%  authors: 
%          Badr S. Higab       and       Abd Al-Kareem Karaman
%          eng.higab@gmail.com           kareemu674@yahoo.com
%                  from the University of Jordan
%
%
%
%
%
close all
clc


f=figure('name','Robotics','menubar','none','numbertitle',...
    'off','color',[    0.4898    0.4456    0.6463],'units',...
    'normalized','position',[.01,.05,.95,.9]);


% f2=figure('name','Robotics','menubar','none','numbertitle',...
%     'off','color',[    0.4898    0.4456    0.6463],'units',...
%     'normalized','position',[.01,.05,.95,.9]);
hint=uicontrol('sty','text','un','n','pos',[0.01 .01 0.3 0.03],'visible','off','fontsize',10,'ForegroundColor','y','BackgroundColor',[0.4898    0.4456    0.6463]);
checkbox=uicontrol('sty','checkbox','un','n','pos',[.025 .8 .011 .03],'callback',@pop,'BackgroundColor',[0.4898    0.4456    0.6463]);
uicontrol('sty','text','un','n','pos',[.036 .8 .1 .03],'visible','on','string','functions',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);
err=uicontrol('sty','text','un','n','pos',[0.01 .7 0.2 0.03],'visible','off','fontsize',15,'ForegroundColor','r','BackgroundColor',[0.4898    0.4456    0.6463]);
joint1 = uicontrol('style','popupmenu','units','normalized','position',[.9 .5 .1 .1],'string',{'prismatic';'rotation'});%,...
   % 'callback',@popp);
uicontrol('sty','text','un','n','pos',[.85 .57 .05 .03],'visible','on','string','link 1',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);
cal=uicontrol('sty','text','un','n','pos',[.2 .5 .4 .05],'visible','off','string','please wait, calculating...',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);
joint2 = uicontrol('style','popupmenu','units','normalized','position',[.9 .45 .1 .1],'string',{'prismatic';'rotation'});%,...
    %'callback',@popp);
uicontrol('sty','text','un','n','pos',[.85 .52 .05 .03],'visible','on','string','link 2',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);
joint3 = uicontrol('style','popupmenu','units','normalized','position',[.9 .4 .1 .1],'string',{'prismatic';'rotation'});%,...
    %'callback',@popp);
uicontrol('sty','text','un','n','pos',[.85 .47 .05 .03],'visible','on','string','link 3',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);
joint4 = uicontrol('style','popupmenu','units','normalized','position',[.9 .35 .1 .1],'string',{'drilling';'wellding'});%,...
    %'callback',@popp);
uicontrol('sty','text','un','n','pos',[.85 .42 .05 .03],'visible','on','string','end ef',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);
uicontrol('style','push','units','normalized','position',[.88 .2 .1 .05],'string','Go','callback',@go1)
uicontrol('style','push','units','normalized','position',[.88 .05 .05 .025],'string','Help','callback',@go3)
uicontrol('style','push','units','normalized','position',[.88 .1 .1 .05],'string','Reset','callback',@go2)

joint1_mov=uicontrol('style','edit','units','normalized','position',[.025 .3 .1 .05]);

joint1_movs=uicontrol('sty','text','un','n','pos',[.025 .35 .1 .03],'visible','on','string','joint 1 path',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);

joint2_mov=uicontrol('style','edit','units','normalized','position',[.025 .2 .1 .05]);

joint2_movs=uicontrol('sty','text','un','n','pos',[.025 .25 .1 .03],'visible','on','string','joint 2 path',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);

joint3_mov=uicontrol('style','edit','units','normalized','position',[.025 .1 .1 .05]);

joint3_movs=uicontrol('sty','text','un','n','pos',[.025 .15 .1 .03],'visible','on','string','joint 3 path',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);

Tstart=uicontrol('sty','edit','units','normalized','pos',[.025 .6 .05 0.03],'visible','off');

Tend=uicontrol('sty','edit','units','normalized','pos',[.025 .5 .05 0.03],'visible','off');

Tstart_s=uicontrol('sty','text','units','normalized','pos',[.025 .63 .05 0.03],'string','start','visible','off',...
    'BackgroundColor',[0.4898    0.4456    0.6463],'fontsize',15);

Tend_s=uicontrol('sty','text','units','normalized','pos',[.025 .53 .05 0.03],'string','end','visible','off',...
    'BackgroundColor',[0.4898    0.4456    0.6463],'fontsize',15);

    set(joint1_mov,'visible','off')
    set(joint2_mov,'visible','off')
    set(joint3_mov,'visible','off')
    set(joint1_movs,'visible','off')
    set(joint2_movs,'visible','off')
    set(joint3_movs,'visible','off')


set(joint1,'value',1)
set(joint2,'value',1)
set(joint3,'value',1)
set(joint4,'value',1)

    function pop(varargin)
if get(checkbox,'value')==0
    set(joint1_mov,'visible','off')
    set(joint2_mov,'visible','off')
    set(joint3_mov,'visible','off')
    set(joint1_movs,'visible','off')
    set(joint2_movs,'visible','off')
    set(joint3_movs,'visible','off')
    set(Tstart,'visible','off')
    set(Tend,'visible','off')
    set(Tstart_s,'visible','off')
    set(Tend_s,'visible','off')
elseif get(checkbox,'value')==1
    set(joint1_mov,'visible','on')
    set(joint2_mov,'visible','on')
    set(joint3_mov,'visible','on')
    set(joint1_movs,'visible','on')
    set(joint2_movs,'visible','on')
    set(joint3_movs,'visible','on')
    set(Tstart,'visible','on')
    set(Tend,'visible','on')
    set(Tstart_s,'visible','on')
    set(Tend_s,'visible','on')
end
    end


    function go2(varargin)
        
       jj1= get(joint1,'value');
       jj2= get(joint2,'value');
       jj3= get(joint3,'value');
       jj4= get(joint4,'value');
       chb=get(checkbox,'value');
       j1m=get(joint1_mov,'string');
       j2m=get(joint2_mov,'string');
       j3m=get(joint3_mov,'string');
       ts=get(Tstart,'string');
       ten=get(Tend,'string');
       
       clf 
       
      cal=uicontrol('sty','text','un','n','pos',[.2 .5 .4 .05],'visible','off','string','please wait, calculating...',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);
       uicontrol('style','push','units','normalized','position',[.88 .05 .05 .025],'string','Help','callback',@go3)
       
   checkbox=uicontrol('sty','checkbox','un','n','pos',[.025 .8 .011 .03],'callback',@pop,'BackgroundColor',[0.4898    0.4456    0.6463]);
uicontrol('sty','text','un','n','pos',[.036 .8 .1 .03],'visible','on','string','functions',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);
err=uicontrol('sty','text','un','n','pos',[0.01 .7 0.2 0.03],'visible','off','fontsize',15,'ForegroundColor','r','BackgroundColor',[0.4898    0.4456    0.6463]);
hint=uicontrol('sty','text','un','n','pos',[0.01 .01 0.3 0.03],'visible','off','fontsize',10,'ForegroundColor','y','BackgroundColor',[0.4898    0.4456    0.6463]);
joint1 = uicontrol('style','popupmenu','units','normalized','position',[.9 .5 .1 .1],'string',{'prismatic';'rotation'});%,...
   % 'callback',@popp);
uicontrol('sty','text','un','n','pos',[.85 .57 .05 .03],'visible','on','string','link 1',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);
joint2 = uicontrol('style','popupmenu','units','normalized','position',[.9 .45 .1 .1],'string',{'prismatic';'rotation'});%,...
    %'callback',@popp);
uicontrol('sty','text','un','n','pos',[.85 .52 .05 .03],'visible','on','string','link 2',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);
joint3 = uicontrol('style','popupmenu','units','normalized','position',[.9 .4 .1 .1],'string',{'prismatic';'rotation'});%,...
    %'callback',@popp);
uicontrol('sty','text','un','n','pos',[.85 .47 .05 .03],'visible','on','string','link 3',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);
joint4 = uicontrol('style','popupmenu','units','normalized','position',[.9 .35 .1 .1],'string',{'drilling';'wellding'});%,...
    %'callback',@popp);
uicontrol('sty','text','un','n','pos',[.85 .42 .05 .03],'visible','on','string','end ef',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);
uicontrol('style','push','units','normalized','position',[.88 .2 .1 .05],'string','Go','callback',@go1)
uicontrol('style','push','units','normalized','position',[.88 .1 .1 .05],'string','Reset','callback',@go2)

joint1_mov=uicontrol('style','edit','units','normalized','position',[.025 .3 .1 .05]);

joint1_movs=uicontrol('sty','text','un','n','pos',[.025 .35 .1 .03],'visible','on','string','joint 1 path',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);

joint2_mov=uicontrol('style','edit','units','normalized','position',[.025 .2 .1 .05]);

joint2_movs=uicontrol('sty','text','un','n','pos',[.025 .25 .1 .03],'visible','on','string','joint 2 path',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);

joint3_mov=uicontrol('style','edit','units','normalized','position',[.025 .1 .1 .05]);

joint3_movs=uicontrol('sty','text','un','n','pos',[.025 .15 .1 .03],'visible','on','string','joint 3 path',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);

Tstart=uicontrol('sty','edit','units','normalized','pos',[.025 .6 .05 0.03],'visible','off');

Tend=uicontrol('sty','edit','units','normalized','pos',[.025 .5 .05 0.03],'visible','off');

Tstart_s=uicontrol('sty','text','units','normalized','pos',[.025 .63 .05 0.03],'string','start','visible','off',...
    'BackgroundColor',[0.4898    0.4456    0.6463],'fontsize',15);

Tend_s=uicontrol('sty','text','units','normalized','pos',[.025 .53 .05 0.03],'string','end','visible','off',...
    'BackgroundColor',[0.4898    0.4456    0.6463],'fontsize',15);

    set(joint1_mov,'visible','off')
    set(joint2_mov,'visible','off')
    set(joint3_mov,'visible','off')
    set(joint1_movs,'visible','off')
    set(joint2_movs,'visible','off')
    set(joint3_movs,'visible','off')


set(joint1,'value',jj1);
set(joint2,'value',jj2);
set(joint3,'value',jj3);
set(joint4,'value',jj4);
set(checkbox,'value',chb);
pop
set(joint1_mov,'string',j1m);
set(joint2_mov,'string',j2m);
set(joint3_mov,'string',j3m);
set(Tstart,'string',ts);
set(Tend,'string',ten);
        
    end

    function go1(varargin) 
        
        
                
set(cal,'visible','on')
drawnow
        
       if get(joint4,'value')==1 
        if get(joint1,'value')==2
            if get(joint2,'value')==2
                if get(joint3,'value')==2
                    kase=1;         % rrr
                    
                elseif get(joint3,'value')==1 
                    kase=2;         %rrp
                end
            elseif get(joint2,'value')==1
                if get(joint3,'value')==2
                    kase=3;         % rpr
                    
                elseif get(joint3,'value')==1 
                    kase=4;         %rpp
                end
            end
         elseif get(joint1,'value')==1
                if get(joint2,'value')==2
                  if get(joint3,'value')==2
                    kase=5;         % prr
                    
                 elseif get(joint3,'value')==1 
                    kase=6;         %prp
                 end
            elseif get(joint2,'value')==1
                if get(joint3,'value')==2
                    kase=7;         % ppr
                    
                elseif get(joint3,'value')==1 
                    kase=8;         %ppp
                end
                
                end
        end
       elseif  get(joint4,'value')==2 
           if get(joint1,'value')==2
            if get(joint2,'value')==2
                if get(joint3,'value')==2
                    kase=9;         % rrr
                    
                elseif get(joint3,'value')==1 
                    kase=10;         %rrp
                end
            elseif get(joint2,'value')==1
                if get(joint3,'value')==2
                    kase=11;         % rpr
                    
                elseif get(joint3,'value')==1 
                    kase=12;         %rpp
                end
            end
         elseif get(joint1,'value')==1
                if get(joint2,'value')==2
                  if get(joint3,'value')==2
                    kase=13;         % prr
                    
                 elseif get(joint3,'value')==1 
                    kase=14;         %prp
                 end
            elseif get(joint2,'value')==1
                if get(joint3,'value')==2
                    kase=15;         % ppr
                    
                elseif get(joint3,'value')==1 
                    kase=16;         %ppp
                end
                
                end
        end
           
       end
        
        switch kase
            case 1
                rrrd
                
            case 2
                rrpd
            case 3
                rprd
            case 4 
                rppd
            case 5
                prrd
            case 6
                prpd
            case 7
                pprd
            case 8
                pppd
                case 9
                rrrw
            case 10
                rrpw
            case 11
                rprw
            case 12 
                rppw
            case 13
                prrw
            case 14
                prpw
            case 15
                pprw
            case 16
                pppw
        end
   
        

    end

    function go3(varargin)
        
       
        f2=figure('name','Robotics: Help','menubar','none','numbertitle',...
    'off','color',[    0.4898    0.4456    0.6463],'units',...
    'normalized','position',[.3,.4,.5,.5]);

uicontrol('sty','text','un','n','pos',[.05 .9 .1 .06],'visible','on','string','Help:',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);
uicontrol('sty','text','un','n','pos',[.055 .85 .9 .06],'visible','on','string','This code will draw a robot with joints that have been selected',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);
uicontrol('sty','text','un','n','pos',[.055 .8 .6 .06],'visible','on','string','in the link 1, link 2 and link 3 fields.',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);
uicontrol('sty','text','un','n','pos',[.05 .7 .1 .06],'visible','on','string','Note:',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);
uicontrol('sty','text','un','n','pos',[.055 .65 .9 .06],'visible','on','string','For the prismatic joints, the limits are normalized (-1 to 1)',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);
uicontrol('sty','text','un','n','pos',[.055 .6 .9 .06],'visible','on','string','1: fully extended , -1: fully retracted',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);
uicontrol('sty','text','un','n','pos',[.05 .2 .9 .06],'visible','on','string','its made for the Robotics course in the University of Jordan',...
    'fontsize',15,'BackgroundColor',[0.4898    0.4456    0.6463]);


uicontrol('style','push','units','normalized','position',[.5 .05 .1 .05],'string','Close','callback',@go4)
        
        
    end


    function go4(varargin)
     close 'Robotics: Help'   
    end

    function rrrd(varargin)
        
        
        set(joint1_movs,'string','joint1 angle')
        set(joint2_movs,'string','joint2 angle')
        set(joint3_movs,'string','joint3 angle')
        
        fj1=inline(get(joint1_mov,'string'));
        fj2=inline(get(joint2_mov,'string'));
        fj3=inline(get(joint3_mov,'string'));
        err1=0;
        direction=1;
     
        if str2double(get(Tstart,'string')) > str2double(get(Tend,'string'))
           direction=-1 ;
        end
        t_test= str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string')) ;
      
        
        
        if get(checkbox,'value')==1
            
        if max(fj1(t_test))> 400 || min(fj1(t_test))< -500
            set(err,'string','please check theta 1 limit','visible','on')
            set(hint,'string','use start=0, T end=90, j1=t, j2=t, j3=t ','visible','on')
            err1=1;
        end
        if max(fj2(t_test))> 180 || min(fj2(t_test))< 0
            set(err,'string','please check theta 2 limit','visible','on')
            set(hint,'string','use start=0, end=90, j1=t, j2=t, j3=t ','visible','on')
            err1=1;
        end
        if max(fj3(t_test))> 120 || min(fj3(t_test))< -120
            set(err,'string','please check theta 3 limit','visible','on')
            set(hint,'string','use start=0, end=90, j1=t, j2=t, j3=t ','visible','on')
            err1=1;
        end
        end

        if err1==1;
            return
        else
        
        [fout1, vout1, cout1] = rndread('base.slp');
        [fout2, vout2, cout2] = rndread('j1.slp');
        [fout3, vout3, cout3] = rndread('j5.slp');
        [fout4, vout4, cout4] = rndread('j6.slp');
        [fout5, vout5, cout5] = rndread('e1.slp');
        [fout6, vout6, cout6] = rndread('e2.slp');
        [fout7, vout7, cout7] = rndread('e3.slp');
        
        p1 = patch('faces', fout1, 'vertices' ,vout1);
        p2 = patch('faces', fout2, 'vertices' ,vout2);
        p3 = patch('faces', fout3, 'vertices' ,vout3);
        p4 = patch('faces', fout4, 'vertices' ,vout4);
        p5 = patch('faces', fout5, 'vertices' ,vout5);
        p6 = patch('faces', fout6, 'vertices' ,vout6);
        p7 = patch('faces', fout7, 'vertices' ,vout7);
        set(p1, 'facec', 'flat');
        set(p2, 'facec', 'flat');
        set(p3, 'facec', 'flat');
        set(p4, 'facec', 'flat');
        set(p5, 'facec', 'flat');
        set(p6, 'facec', 'flat');
        set(p7, 'facec', 'flat');
%        set(p3, 'facec', 'flat');
    
        set(p1, 'FaceVertexCData', cout1); 
        set(p2, 'FaceVertexCData', cout2); 
        set(p3, 'FaceVertexCData', cout3);
        set(p4, 'FaceVertexCData', cout4);
        set(p5, 'FaceVertexCData', cout5); 
        set(p6, 'FaceVertexCData', cout6);
        set(p7, 'FaceVertexCData', cout7);
   %  set(p3, 'FaceVertexCData', cout3); 
    
        set(p1, 'EdgeColor','none'); 
        set(p2, 'EdgeColor','none'); 
        set(p3, 'EdgeColor','none'); 
        set(p4, 'EdgeColor','none'); 
        set(p5, 'EdgeColor','none'); 
        set(p6, 'EdgeColor','none'); 
        set(p7, 'EdgeColor','none'); 
   % set(p3, 'EdgeColor','none');
    
        light                               % add a default light
        daspect([1 1 1])                    % Setting the aspect ratio
        view(3)                             % Isometric view
   % pause(5)
        xlabel('X'),ylabel('Y'),zlabel('Z')
        title(['KK  BH2 '])
        vout1 = vout1';
        vout1 = [vout1(1,:); vout1(2,:); vout1(3,:); ones(1,length(vout1))];
   
        vout2 = vout2';
        vout2 = [vout2(1,:); vout2(2,:); vout2(3,:); ones(1,length(vout2))];
    
        vout3 = vout3';
        vout3 = [vout3(1,:); vout3(2,:); vout3(3,:); ones(1,length(vout3))];
    
        vout4 = vout4';
    vout4 = [vout4(1,:); vout4(2,:); vout4(3,:); ones(1,length(vout4))];
    vout5=vout5*1.6;
    vout6=vout6*1.6;
    vout7=vout7*1.6;
     vout5 = vout5';
    vout5 = [vout5(1,:); vout5(2,:); vout5(3,:); ones(1,length(vout5))];
    
    vout6 = vout6';
    vout6 = [vout6(1,:); vout6(2,:); vout6(3,:); ones(1,length(vout6))];
    
    vout7 = vout7';
    vout7 = [vout7(1,:); vout7(2,:); vout7(3,:); ones(1,length(vout7))];
    
    
    vsize =150; % or can be changed 
    grid
    axis([-vsize vsize -vsize vsize 0 vsize]);
    hold on
    if get(checkbox,'value')==0
    set(cal,'visible','off')
     for t=0:1:90
    T1=tmat( 90,0 ,0,0);
    %T2=tmat(0,0,0,0);
    T3=tmat2(0,40,0);
    T4=rx(0)*ry(t)*rz(0);%
    T5=tmat2(-7.5,22,0);
    T6=rx(t)*ry(90)*rz(0);%
    T7=tmat2(75,0,0);
    T8=rx(0)*ry(0)*rz(t);
    %T9=tmat2(0,0,30);
    T10=tmat2(55,-2,7.5);
    T11=rx(-90)*ry(.7*t)*rz(90);
    T12=tmat2(0,-20,0);
    T13=rx(180)*ry(90)*rz(0);
    T14=tmat2(2.5,-10,0);
    T15=tmat2(0,10,0);
    T16=rx(0)*ry(500*t)*rz(0);
    T17=tmat2(0,14,0);
    
    
    %T5=tmat(90,0,40,0);
    %T6=tmat(0,0,0,0);
    nv1=T1*vout1;
   set(p1,'Vertices',nv1(1:3,:)');
   nv2=T1*T3*T4*vout2;
   set(p2,'Vertices',nv2(1:3,:)');
   nv3=T1*T3*T4*T5*T6*vout3;
   set(p3,'Vertices',nv3(1:3,:)');
   nv4=T1*T3*T4*T5*T6*T7*T8*vout4;
   set(p4,'Vertices',nv4(1:3,:)');
   nv5=T1*T3*T4*T5*T6*T7*T8*T10*T11*vout5;
   set(p5,'Vertices',nv5(1:3,:)');
   nv6=T1*T3*T4*T5*T6*T7*T8*T10*T11*T12*T13*T14*vout6;
   set(p6,'Vertices',nv6(1:3,:)');
   nv7=T1*T3*T4*T5*T6*T7*T8*T10*T11*T12*T13*T14*T15*T16*vout7;
   set(p7,'Vertices',nv7(1:3,:)');
   
   drawnow
   
   rotate3d
   TT=T1*T3*T4*T5*T6*T7*T8*T10*T11*T12*T13*T14*T15*T16*T17;
   x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
   
     end
     
     
    elseif get(checkbox,'value')==1
        
        set(cal,'visible','off')
        
            
        for t= str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string')) ;
            
    T1=tmat( 90,0 ,0,0);
    %T2=tmat(0,0,0,0);
    T3=tmat2(0,40,0);
    T4=rx(0)*ry(fj1(t))*rz(0);       %first joint
    T5=tmat2(-7.5,22,0);
    T6=rx(fj2(t))*ry(90)*rz(0);%
    T7=tmat2(75,0,0);
    T8=rx(0)*ry(0)*rz(fj3(t));           %second joint
    %T9=tmat2(0,0,30);
    T10=tmat2(55,-2,7.5);
    T11=rx(-90)*ry(.7*t)*rz(90);          %third ajoint  
    T12=tmat2(0,-20,0);
    T13=rx(180)*ry(90)*rz(0);
    T14=tmat2(2.5,-10,0);
    T15=tmat2(0,10,0);
    T16=rx(0)*ry(500*t)*rz(0);
    T17=tmat2(0,14,0);
    
    
    %T5=tmat(90,0,40,0);
    %T6=tmat(0,0,0,0);
    nv1=T1*vout1;
   set(p1,'Vertices',nv1(1:3,:)');
   nv2=T1*T3*T4*vout2;
   set(p2,'Vertices',nv2(1:3,:)');
   nv3=T1*T3*T4*T5*T6*vout3;
   set(p3,'Vertices',nv3(1:3,:)');
   nv4=T1*T3*T4*T5*T6*T7*T8*vout4;
   set(p4,'Vertices',nv4(1:3,:)');
   nv5=T1*T3*T4*T5*T6*T7*T8*T10*T11*vout5;
   set(p5,'Vertices',nv5(1:3,:)');
   nv6=T1*T3*T4*T5*T6*T7*T8*T10*T11*T12*T13*T14*vout6;
   set(p6,'Vertices',nv6(1:3,:)');
   nv7=T1*T3*T4*T5*T6*T7*T8*T10*T11*T12*T13*T14*T15*T16*vout7;
   set(p7,'Vertices',nv7(1:3,:)');
   
   drawnow
   rotate3d
   TT=T1*T3*T4*T5*T6*T7*T8*T10*T11*T12*T13*T14*T15*T16*T17;
   x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
        
        end
        end
        end
    
    end


function rrpd(varargin)
    
        set(joint1_movs,'string','joint1 angle')
        set(joint2_movs,'string','joint2 angle')
        set(joint3_movs,'string','joint3 displ.')
        
        fj1=inline(get(joint1_mov,'string'));
        fj2=inline(get(joint2_mov,'string'));
        fj3=inline(get(joint3_mov,'string'));
        err1=0;
        direction=1;
     
        if str2double(get(Tstart,'string')) > str2double(get(Tend,'string'))
           direction=-1 ;
        end
        t_test= str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string')) ;
      
        
        
        if get(checkbox,'value')==1
            
        if max(fj1(t_test))> 400 || min(fj1(t_test))< -500
            set(err,'string','please check theta 1 limit','visible','on')
           set(hint,'string','use start=0, T end=90, j1=t, j2=t, j3=sin(t/4) ','visible','on')
            err1=1;
        end
        if max(fj2(t_test))> 180 || min(fj2(t_test))< 0
            set(err,'string','please check theta 2 limit','visible','on')
             set(hint,'string','use start=0, T end=90, j1=t, j2=t, j3=sin(t/4) ','visible','on')
            err1=1;
        end
        if max(fj3(t_test))> 1 || min(fj3(t_test))< -1
            set(err,'string','please check theta 3 limit','visible','on')
          set(hint,'string','use start=0, T end=90, j1=t, j2=t, j3=sin(t/4) ','visible','on')
            err1=1;
        end
        end

        if err1==1;
            return
        else
        
        
        [fout1, vout1, cout1] = rndread('base.slp');
        [fout2, vout2, cout2] = rndread('j1.slp');
        [fout3, vout3, cout3] = rndread('j5.slp');
        [fout4, vout4, cout4] = rndread('j10.slp');
        [fout5, vout5, cout5] = rndread('j11.slp');
        [fout6, vout6, cout6] = rndread('j12.slp');
        [fout7, vout7, cout7] = rndread('e1.slp');
        [fout8, vout8, cout8] = rndread('e2.slp');
        [fout9, vout9, cout9] = rndread('e3.slp');
       
        p1 = patch('faces', fout1, 'vertices' ,vout1);
        p2 = patch('faces', fout2, 'vertices' ,vout2);
        p3 = patch('faces', fout3, 'vertices' ,vout3);
        p4 = patch('faces', fout4, 'vertices' ,vout4);
        p5 = patch('faces', fout5, 'vertices' ,vout5);
        p6 = patch('faces', fout6, 'vertices' ,vout6);
        p7 = patch('faces', fout7, 'vertices' ,vout7);
        p8 = patch('faces', fout8, 'vertices' ,vout8);
        p9 = patch('faces', fout9, 'vertices' ,vout9);
        set(p1, 'facec', 'flat');
        set(p2, 'facec', 'flat');
        set(p3, 'facec', 'flat');
        set(p4, 'facec', 'flat');
        set(p5, 'facec', 'flat');
        set(p6, 'facec', 'flat');
        set(p7, 'facec', 'flat');
        set(p8, 'facec', 'flat');
        set(p9, 'facec', 'flat');
%        set(p3, 'facec', 'flat');
    
         set(p1, 'FaceVertexCData', cout1); 
      set(p2, 'FaceVertexCData', cout2); 
      set(p3, 'FaceVertexCData', cout3);
      set(p4, 'FaceVertexCData', cout4);
      set(p5, 'FaceVertexCData', cout5);
      set(p6, 'FaceVertexCData', cout6);
      set(p7, 'FaceVertexCData', cout7);
      set(p8, 'FaceVertexCData', cout8);
      set(p9, 'FaceVertexCData', cout9);
   %  set(p3, 'FaceVertexCData', cout3); 
    
    set(p1, 'EdgeColor','none'); 
    set(p2, 'EdgeColor','none'); 
    set(p3, 'EdgeColor','none'); 
    set(p4, 'EdgeColor','none'); 
    set(p5, 'EdgeColor','none'); 
    set(p6, 'EdgeColor','none'); 
    set(p7, 'EdgeColor','none'); 
    set(p8, 'EdgeColor','none'); 
    set(p9, 'EdgeColor','none'); 
   % set(p3, 'EdgeColor','none');
    
    light                               % add a default light
    daspect([1 1 1])                    % Setting the aspect ratio
    view(3)                             % Isometric view
    xlabel('X'),ylabel('Y'),zlabel('Z')
    title(['KK  BH2 '])
    
    vout1 = vout1';
    vout1 = [vout1(1,:); vout1(2,:); vout1(3,:); ones(1,length(vout1))];
   
   vout2 = vout2';
    vout2 = [vout2(1,:); vout2(2,:); vout2(3,:); ones(1,length(vout2))];
    
    vout3 = vout3';
    vout3 = [vout3(1,:); vout3(2,:); vout3(3,:); ones(1,length(vout3))];
    vout4=vout4*1.2;
    vout4 = vout4';
    vout4 = [vout4(1,:); vout4(2,:); vout4(3,:); ones(1,length(vout4))];
    
    vout5 = vout5';
    vout5 = [vout5(1,:); vout5(2,:); vout5(3,:); ones(1,length(vout5))];
    
    vout6 = vout6';
    vout6 = [vout6(1,:); vout6(2,:); vout6(3,:); ones(1,length(vout6))];
    vout7=vout7*1.5;
    vout8=vout8*1.5;
    vout9=vout9*1.5;
    vout7 = vout7';
    vout7= [vout7(1,:); vout7(2,:); vout7(3,:); ones(1,length(vout7))];
    
    vout8 = vout8';
    vout8 = [vout8(1,:); vout8(2,:); vout8(3,:); ones(1,length(vout8))];
    
    vout9 = vout9';
    vout9 = [vout9(1,:); vout9(2,:); vout9(3,:); ones(1,length(vout9))];
    
    
    vsize =150; % or can be changed 
    grid
    axis([-vsize vsize -vsize vsize 0 vsize]);
    
    hold on
    if get(checkbox,'value')==0
        set(cal,'visible','off')
        
     for t=0:0.5:90
    T1=tmat( 90,0 ,0,0);
    T2=tmat(0,0,0,0);
    T3=tmat2(0,40,0);
    T4=rx(0)*ry(t)*rz(0);
    T5=tmat2(-7.5,22,0);
    T6=rx(t)*ry(90)*rz(0);
    T7=tmat2(75,0,0);
    T8=rx(0)*ry(0)*rz(-20);
    T9=tmat2(0,-5,-1);
    T12=rx(0)*ry(0)*rz(-70);
    T10=tmat2(0,10*sin(0.05*t)+10,7.5);
    %T10=tmat2(0,10,7.5);
    T11=tmat2(0,30,0);
    T13=rx(0)*ry(90)*rx(180);
    T14=tmat2(0,-7.5,-3);
    T19=rx(0)*ry(0)*rx(t);
    T15=tmat2(0,-7.5,2.2);
    T16=rx(180)*ry(90)*rz(0);
    T17=tmat2(0,10,0);
    T18=rx(0)*ry(100*t)*rz(0);
    T20=rx((t-40)*.7)*ry(0)*rz(0);
        T21=tmat2(0,14,0);
    
    %T5=tmat(90,0,40,0);
    %T6=tmat(0,0,0,0);
    nv1=T1*vout1;
   set(p1,'Vertices',nv1(1:3,:)');
   nv2=T1*T3*T4*vout2;
   set(p2,'Vertices',nv2(1:3,:)');
   nv3=T1*T3*T4*T5*T6*vout3;
   set(p3,'Vertices',nv3(1:3,:)');
   nv4=T1*T3*T4*T5*T6*T7*T8*T12*T9*vout4;
   set(p4,'Vertices',nv4(1:3,:)');
   nv5=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*vout5;
   set(p5,'Vertices',nv5(1:3,:)');
   nv6=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*T11*vout6;
   set(p6,'Vertices',nv6(1:3,:)');
   nv7=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*T11*T13*T14*T19*vout7;
   set(p7,'Vertices',nv7(1:3,:)');
   nv8=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*T11*T13*T14*T19*T15*T16*T20*vout8;
   set(p8,'Vertices',nv8(1:3,:)');
   nv9=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*T11*T13*T14*T19*T15*T16*T20*T17*T18*vout9;
   set(p9,'Vertices',nv9(1:3,:)');
   
   drawnow
   rotate3d
   TT=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*T11*T13*T14*T19*T15*T16*T20*T17*T18*T21;
   x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
     end
    elseif get(checkbox,'value')==1
        set(cal,'visible','off')
       
        for t=str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string'))
    T1=tmat( 90,0 ,0,0);
    T2=tmat(0,0,0,0);
    T3=tmat2(0,40,0);
    T4=rx(0)*ry(fj1(t))*rz(0);
    T5=tmat2(-7.5,22,0);
    T6=rx(fj2(t))*ry(90)*rz(0);
    T7=tmat2(75,0,0);
    T8=rx(0)*ry(0)*rz(-20);
    T9=tmat2(0,-5,-1);
    T12=rx(0)*ry(0)*rz(-70);
    T10=tmat2(0,10*fj3(t)+15,7.5);
    %T10=tmat2(0,10,7.5);
    T11=tmat2(0,30,0);
    T13=rx(0)*ry(90)*rx(180);
    T14=tmat2(0,-7.5,-3);
    T19=rx(0)*ry(0)*rx(t);
    T15=tmat2(0,-7.5,2.2);
    T16=rx(180)*ry(90)*rz(0);
    T17=tmat2(0,10,0);
    T18=rx(0)*ry(100*t)*rz(0);
    T20=rx((t-40)*.7)*ry(0)*rz(0);
    T21=tmat2(0,14,0);
    %T5=tmat(90,0,40,0);
    %T6=tmat(0,0,0,0);
    nv1=T1*vout1;
   set(p1,'Vertices',nv1(1:3,:)');
   nv2=T1*T3*T4*vout2;
   set(p2,'Vertices',nv2(1:3,:)');
   nv3=T1*T3*T4*T5*T6*vout3;
   set(p3,'Vertices',nv3(1:3,:)');
   nv4=T1*T3*T4*T5*T6*T7*T8*T12*T9*vout4;
   set(p4,'Vertices',nv4(1:3,:)');
   nv5=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*vout5;
   set(p5,'Vertices',nv5(1:3,:)');
   nv6=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*T11*vout6;
   set(p6,'Vertices',nv6(1:3,:)');
   nv7=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*T11*T13*T14*T19*vout7;
   set(p7,'Vertices',nv7(1:3,:)');
   nv8=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*T11*T13*T14*T19*T15*T16*T20*vout8;
   set(p8,'Vertices',nv8(1:3,:)');
   nv9=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*T11*T13*T14*T19*T15*T16*T20*T17*T18*vout9;
   set(p9,'Vertices',nv9(1:3,:)');
   
   drawnow
   rotate3d
   TT=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*T11*T13*T14*T19*T15*T16*T20*T17*T18*T21;
   x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
     end
    end
    
    
    end
end

    function rprd(varargin)
        set(joint1_movs,'string','joint1 angle')
        set(joint2_movs,'string','joint2 displ.')
        set(joint3_movs,'string','joint3 angle')
        
        fj1=inline(get(joint1_mov,'string'));
        fj2=inline(get(joint2_mov,'string'));
        fj3=inline(get(joint3_mov,'string'));
        err1=0;
        direction=1;
     
        if str2double(get(Tstart,'string')) > str2double(get(Tend,'string'))
           direction=-1 ;
        end
        t_test= str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string')) ;
      
        
        
        if get(checkbox,'value')==1
            
        if max(fj1(t_test))> 400 || min(fj1(t_test))< -500
            set(err,'string','please check theta 1 limit','visible','on')
           set(hint,'string','use start=0, T end=90, j1=t, j2=sin(t/4), j3=t ','visible','on')
            err1=1;
        end
        if max(fj2(t_test))>= 1 || min(fj2(t_test))<= -1
            set(err,'string','please check theta 2 limit','visible','on')
             set(hint,'string','use start=0, T end=90, j1=t, j2=sin(t/4), j3=t ','visible','on')
            err1=1;
        end
        if max(fj3(t_test))> 90 || min(fj3(t_test))< -90
            set(err,'string','please check theta 3 limit','visible','on')
          set(hint,'string','use start=0, T end=90, j1=t, j2=sin(t/4), j3=t) ','visible','on')
            err1=1;
        end
        end

        if err1==1;
            return
        else
            
        [fout1, vout1, cout1] = rndread('base.slp');
        [fout2, vout2, cout2] = rndread('j1.slp');
        [fout3, vout3, cout3] = rndread('j7.slp');
        [fout4, vout4, cout4] = rndread('j8.slp');
        [fout5, vout5, cout5] = rndread('j9.slp');
        [fout6, vout6, cout6] = rndread('j6.slp');
        [fout7, vout7, cout7] = rndread('e1.slp');
        [fout8, vout8, cout8] = rndread('e2.slp');
        [fout9, vout9, cout9] = rndread('e3.slp');
       
        p1 = patch('faces', fout1, 'vertices' ,vout1);
        p2 = patch('faces', fout2, 'vertices' ,vout2);
        p3 = patch('faces', fout3, 'vertices' ,vout3);
        p4 = patch('faces', fout4, 'vertices' ,vout4);
        p5 = patch('faces', fout5, 'vertices' ,vout5);
        p6 = patch('faces', fout6, 'vertices' ,vout6);
        p7 = patch('faces', fout7, 'vertices' ,vout7);
        p8 = patch('faces', fout8, 'vertices' ,vout8);
        p9 = patch('faces', fout9, 'vertices' ,vout9);
        set(p1, 'facec', 'flat');
        set(p2, 'facec', 'flat');
        set(p3, 'facec', 'flat');
        set(p4, 'facec', 'flat');
        set(p5, 'facec', 'flat');
        set(p6, 'facec', 'flat');
        set(p7, 'facec', 'flat');
        set(p8, 'facec', 'flat');
        set(p9, 'facec', 'flat');
%        set(p3, 'facec', 'flat');
    
         set(p1, 'FaceVertexCData', cout1); 
      set(p2, 'FaceVertexCData', cout2); 
      set(p3, 'FaceVertexCData', cout3);
      set(p4, 'FaceVertexCData', cout4);
      set(p5, 'FaceVertexCData', cout5);
      set(p6, 'FaceVertexCData', cout6);
      set(p7, 'FaceVertexCData', cout7);
      set(p8, 'FaceVertexCData', cout8);
      set(p9, 'FaceVertexCData', cout9);
   %  set(p3, 'FaceVertexCData', cout3); 
    
    set(p1, 'EdgeColor','none'); 
    set(p2, 'EdgeColor','none'); 
    set(p3, 'EdgeColor','none'); 
    set(p4, 'EdgeColor','none'); 
    set(p5, 'EdgeColor','none'); 
    set(p6, 'EdgeColor','none');
    set(p7, 'EdgeColor','none'); 
    set(p8, 'EdgeColor','none'); 
    set(p9, 'EdgeColor','none');
   % set(p3, 'EdgeColor','none');
    
    light                               % add a default light
    daspect([1 1 1])                    % Setting the aspect ratio
    view(3)                             % Isometric view
    xlabel('X'),ylabel('Y'),zlabel('Z')
    title(['KK  BH2 '])
    
    vout1 = vout1';
    vout1 = [vout1(1,:); vout1(2,:); vout1(3,:); ones(1,length(vout1))];
   
   vout2 = vout2';
    vout2 = [vout2(1,:); vout2(2,:); vout2(3,:); ones(1,length(vout2))];
    vout3=vout3*1.4;
    vout3 = vout3';
    vout3 = [vout3(1,:); vout3(2,:); vout3(3,:); ones(1,length(vout3))];
    
    vout4 = vout4';
    vout4 = [vout4(1,:); vout4(2,:); vout4(3,:); ones(1,length(vout4))];
    vout5=vout5*1.2;
    vout5 = vout5';
    vout5 = [vout5(1,:); vout5(2,:); vout5(3,:); ones(1,length(vout5))];
    
    vout6 = vout6';
    vout6 = [vout6(1,:); vout6(2,:); vout6(3,:); ones(1,length(vout6))];
    
    vout7=vout7*1.5;
    vout8=vout8*1.5;
    vout9=vout9*1.5;
    vout7 = vout7';
    vout7= [vout7(1,:); vout7(2,:); vout7(3,:); ones(1,length(vout7))];
    
    vout8 = vout8';
    vout8 = [vout8(1,:); vout8(2,:); vout8(3,:); ones(1,length(vout8))];
    
    vout9 = vout9';
    vout9 = [vout9(1,:); vout9(2,:); vout9(3,:); ones(1,length(vout9))];
        
        vsize =150; % or can be changed 
    grid
    axis([-vsize vsize -vsize vsize 0 vsize]);
    
    hold on
    if get(checkbox,'value')==0
        set(cal,'visible','off')
     for t=0:1:90
    T1=tmat( 90,0 ,0,0);
   % T2=tmat(0,0,0,0);
    T3=tmat2(0,40,0);
    T4=rx(0)*ry(t)*rz(0);
    T5=tmat2(10,0,-10);
    T6=rx(0)*ry(90)*rz(90);
    T8=rx(0)*ry(0)*rz(90);
    %T7=tmat2(20*sin(0.05*t)+65,55,-103.5);
    T7=tmat2(80+15*sin(0.2*t),10,-10);
   %T7=tmat2(70,55,-103.5);
    T9=rx(180)*ry(0)*rz(0);
    T11=tmat2(0,7.5,-7.5);
    T10=rx(0)*ry(0)*rz(0.5*t);
    T12=tmat2(53,2,7.5);
    T14=rx(90)*ry(0.5*t)*rz(90);
    T15=tmat2(0,-7.5,2.2);
    T16=rx(180)*ry(90)*rz(0);
    T19=rx(-0.2*t)*ry(0)*rz(0);
    T17=tmat2(0,10,0);
    T18=rx(0)*ry(100*t)*rz(0);
    T20=tmat2(0,14,0);
    
    
    %T5=tmat(90,0,40,0);
    %T6=tmat(0,0,0,0);
    nv1=T1*vout1;
   set(p1,'Vertices',nv1(1:3,:)');
   nv2=T1*T3*T4*vout2;
   set(p2,'Vertices',nv2(1:3,:)');
   nv3=T1*T3*T4*T6*T5*vout3;
   set(p3,'Vertices',nv3(1:3,:)');
   nv4=T1*T3*T4*T5*T6*T7*T8*vout4;
   set(p4,'Vertices',nv4(1:3,:)');
   nv5=T1*T3*T4*T5*T6*T7*T8*T9*vout5;
   set(p5,'Vertices',nv5(1:3,:)');
   nv6=T1*T3*T4*T5*T6*T7*T8*T9*T11*T10*vout6;
   set(p6,'Vertices',nv6(1:3,:)');
   nv7=T1*T3*T4*T5*T6*T7*T8*T9*T11*T10*T12*T14*vout7;
   set(p7,'Vertices',nv7(1:3,:)');
   nv8=T1*T3*T4*T5*T6*T7*T8*T9*T11*T10*T12*T14*T15*T16*T19*vout8;
   set(p8,'Vertices',nv8(1:3,:)');
   nv9=T1*T3*T4*T5*T6*T7*T8*T9*T11*T10*T12*T14*T15*T16*T19*T17*T18*vout9;
   set(p9,'Vertices',nv9(1:3,:)');
   
   
   drawnow
   rotate3d
   TT=T1*T3*T4*T5*T6*T7*T8*T9*T11*T10*T12*T14*T15*T16*T19*T17*T18*T20;
   x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
     end
elseif get(checkbox,'value')==1
        set(cal,'visible','off')
       
        for t=str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string'))
    
    T1=tmat( 90,0 ,0,0);
   % T2=tmat(0,0,0,0);
    T3=tmat2(0,40,0);
    T4=rx(0)*ry(fj1(t))*rz(0);
    T5=tmat2(10,0,-10);
    T6=rx(0)*ry(90)*rz(90);
    T8=rx(0)*ry(0)*rz(90);
    %T7=tmat2(20*sin(0.05*t)+65,55,-103.5);
    T7=tmat2(80+15*fj2(t),10,-10);
   %T7=tmat2(70,55,-103.5);
    T9=rx(180)*ry(0)*rz(0);
    T11=tmat2(0,7.5,-7.5);
    T10=rx(0)*ry(0)*rz(fj3(t));
    T12=tmat2(53,2,7.5);
    T14=rx(90)*ry(0.5*t)*rz(90);
    T15=tmat2(0,-7.5,2.2);
    T16=rx(180)*ry(90)*rz(0);
    T19=rx(-0.2*t)*ry(0)*rz(0);
    T17=tmat2(0,10,0);
    T18=rx(0)*ry(100*t)*rz(0);
    T20=tmat2(0,14,0);
    
    
    %T5=tmat(90,0,40,0);
    %T6=tmat(0,0,0,0);
    nv1=T1*vout1;
   set(p1,'Vertices',nv1(1:3,:)');
   nv2=T1*T3*T4*vout2;
   set(p2,'Vertices',nv2(1:3,:)');
   nv3=T1*T3*T4*T6*T5*vout3;
   set(p3,'Vertices',nv3(1:3,:)');
   nv4=T1*T3*T4*T5*T6*T7*T8*vout4;
   set(p4,'Vertices',nv4(1:3,:)');
   nv5=T1*T3*T4*T5*T6*T7*T8*T9*vout5;
   set(p5,'Vertices',nv5(1:3,:)');
   nv6=T1*T3*T4*T5*T6*T7*T8*T9*T11*T10*vout6;
   set(p6,'Vertices',nv6(1:3,:)');
   nv7=T1*T3*T4*T5*T6*T7*T8*T9*T11*T10*T12*T14*vout7;
   set(p7,'Vertices',nv7(1:3,:)');
   nv8=T1*T3*T4*T5*T6*T7*T8*T9*T11*T10*T12*T14*T15*T16*T19*vout8;
   set(p8,'Vertices',nv8(1:3,:)');
   nv9=T1*T3*T4*T5*T6*T7*T8*T9*T11*T10*T12*T14*T15*T16*T19*T17*T18*vout9;
   set(p9,'Vertices',nv9(1:3,:)');
   
   
   drawnow
   rotate3d
   TT=T1*T3*T4*T5*T6*T7*T8*T9*T11*T10*T12*T14*T15*T16*T19*T17*T18*T20;
   x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
        end
    end
    end
    end



    function rppd(varargin)
        
        set(joint1_movs,'string','joint1 angle')
        set(joint2_movs,'string','joint2 displ.')
        set(joint3_movs,'string','joint3 displ.')
        
        fj1=inline(get(joint1_mov,'string'));
        fj2=inline(get(joint2_mov,'string'));
        fj3=inline(get(joint3_mov,'string'));
        err1=0;
        direction=1;
     
        if str2double(get(Tstart,'string')) > str2double(get(Tend,'string'))
           direction=-1 ;
        end
        t_test= str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string')) ;
      
        
        
        if get(checkbox,'value')==1
            
        if max(fj1(t_test))> 400 || min(fj1(t_test))< -500
            set(err,'string','please check theta 1 limit','visible','on')
           set(hint,'string','use start=0, T end=90, j1=t, j2=cos(t/5), j3=sin(t/4) ','visible','on')
            err1=1;
        end
        if max(fj2(t_test))>1 || min(fj2(t_test))<-1
            set(err,'string','please check theta 2 limit','visible','on')
             set(hint,'string','use start=0, T end=90, j1=t, j2=cos(t/5), j3=sin(t/4) ','visible','on')
            err1=1;
        end
        if max(fj3(t_test))> 1 || min(fj3(t_test))< -1
            set(err,'string','please check theta 3 limit','visible','on')
          set(hint,'string','use start=0, T end=90, j1=t, j2=cos(t/5), j3=sin(t/4) ','visible','on')
            err1=1;
        end
        end

        if err1==1;
            return
        else
        
        [fout1, vout1, cout1] = rndread('base.slp');
        [fout2, vout2, cout2] = rndread('j1.slp');
        [fout3, vout3, cout3] = rndread('j7.slp');
        [fout4, vout4, cout4] = rndread('j8.slp');
%         [fout5, vout5, cout5] = rndread('j9.slp');
        [fout6, vout6, cout6] = rndread('j10.slp');
        [fout7, vout7, cout7] = rndread('j11.slp');
        [fout8, vout8, cout8] = rndread('j12.slp');
        [fout9, vout9, cout9] = rndread('e1.slp');
        [fout10, vout10, cout10] = rndread('e2.slp');
        [fout11, vout11, cout11] = rndread('e3.slp');
       
        p1 = patch('faces', fout1, 'vertices' ,vout1);
        p2 = patch('faces', fout2, 'vertices' ,vout2);
        p3 = patch('faces', fout3, 'vertices' ,vout3);
        p4 = patch('faces', fout4, 'vertices' ,vout4);
%         p5 = patch('faces', fout5, 'vertices' ,vout5);
        p6 = patch('faces', fout6, 'vertices' ,vout6);
        p7 = patch('faces', fout7, 'vertices' ,vout7);
        p8 = patch('faces', fout8, 'vertices' ,vout8);
        p9 = patch('faces', fout9, 'vertices' ,vout9);
        p10 = patch('faces', fout10, 'vertices' ,vout10);
        p11 = patch('faces', fout11, 'vertices' ,vout11);
        set(p1, 'facec', 'flat');
        set(p2, 'facec', 'flat');
        set(p3, 'facec', 'flat');
        set(p4, 'facec', 'flat');
%         set(p5, 'facec', 'flat');
        set(p6, 'facec', 'flat');
        set(p7, 'facec', 'flat');
        set(p8, 'facec', 'flat');
        set(p9, 'facec', 'flat');
        set(p10, 'facec', 'flat');
        set(p11, 'facec', 'flat');
%        set(p3, 'facec', 'flat');
    
         set(p1, 'FaceVertexCData', cout1); 
      set(p2, 'FaceVertexCData', cout2); 
      set(p3, 'FaceVertexCData', cout3);
      set(p4, 'FaceVertexCData', cout4);
%       set(p5, 'FaceVertexCData', cout5);
      set(p6, 'FaceVertexCData', cout6);
      set(p7, 'FaceVertexCData', cout7);
      set(p8, 'FaceVertexCData', cout8);
      set(p9, 'FaceVertexCData', cout9);
      set(p10, 'FaceVertexCData', cout10);
      set(p11, 'FaceVertexCData', cout11);
   %  set(p3, 'FaceVertexCData', cout3); 
    
    set(p1, 'EdgeColor','none'); 
    set(p2, 'EdgeColor','none'); 
    set(p3, 'EdgeColor','none'); 
    set(p4, 'EdgeColor','none'); 
%     set(p5, 'EdgeColor','none'); 
    set(p6, 'EdgeColor','none'); 
    set(p7, 'EdgeColor','none'); 
    set(p8, 'EdgeColor','none');
    set(p9, 'EdgeColor','none'); 
    set(p10, 'EdgeColor','none'); 
    set(p11, 'EdgeColor','none');
   % set(p3, 'EdgeColor','none');
    
    light                               % add a default light
    daspect([1 1 1])                    % Setting the aspect ratio
    view(3)                             % Isometric view
    xlabel('X'),ylabel('Y'),zlabel('Z')
    title(['KK  BH2 '])
    
    vout1 = vout1';
    vout1 = [vout1(1,:); vout1(2,:); vout1(3,:); ones(1,length(vout1))];
   
   vout2 = vout2';
    vout2 = [vout2(1,:); vout2(2,:); vout2(3,:); ones(1,length(vout2))];
    vout3=vout3*1.4;
    vout3 = vout3';
    vout3 = [vout3(1,:); vout3(2,:); vout3(3,:); ones(1,length(vout3))];
    
    vout4 = vout4';
    vout4 = [vout4(1,:); vout4(2,:); vout4(3,:); ones(1,length(vout4))];
    
%     vout5 = vout5';
%     vout5 = [vout5(1,:); vout5(2,:); vout5(3,:); ones(1,length(vout5))];
%     
    vout6 = vout6';
    vout6 = [vout6(1,:); vout6(2,:); vout6(3,:); ones(1,length(vout6))];
    
    vout7 = vout7';
    vout7 = [vout7(1,:); vout7(2,:); vout7(3,:); ones(1,length(vout7))];
    
    vout8 = vout8';
    vout8 = [vout8(1,:); vout8(2,:); vout8(3,:); ones(1,length(vout8))];
    
    vout10=vout10*1.3;
    vout11=vout11*1.3;
    vout9=vout9*1.3;
    vout9 = vout9';
    vout9 = [vout9(1,:); vout9(2,:); vout9(3,:); ones(1,length(vout9))];
    
    vout10 = vout10';
    vout10 = [vout10(1,:); vout10(2,:); vout10(3,:); ones(1,length(vout10))];
    
    vout11 = vout11';
    vout11 = [vout11(1,:); vout11(2,:); vout11(3,:); ones(1,length(vout11))];
        
    
    grid
    vsize =150; % or can be changed 
    axis([-vsize vsize -vsize vsize 0 vsize]);
    
    hold on 
    if get(checkbox,'value')==0
        set(cal,'visible','off')
     for t=0:2:180
    T1=tmat( 90,0 ,0,0);
   % T2=tmat(0,0,0,0);
    T3=tmat2(0,40,0);
    T4=rx(0)*ry(t)*rz(0);
    T5=tmat2(10,0,-10);
    T6=rx(0)*ry(90)*rz(90);
    T7=rx(0)*ry(0)*rz(90);
    T8=tmat2(0,15*sin(0.05*t)-70,10);
    T9=tmat2(0,-20,-7.5);
    T10=rx(90)*ry(0)*rz(0);
    T11=tmat2(0,-20+4.9*sin(t*.3),-10);
    T12=rx(180)*ry(0)*rz(0);
    T13=tmat2(-2,8,0);
    T14=rx(0)*ry(90)*rz(180);
    T15=tmat2(0,-7.5,2.2);
    T16=rx(180)*ry(90)*rz(0);
    T19=rx(0)*ry(0)*rz(0);
    T17=tmat2(0,7.5,0);
    T18=rx(0)*ry(100*t)*rz(0);
    T20=tmat2(0,14,0);
    
    
    %T5=tmat(90,0,40,0);
    %T6=tmat(0,0,0,0);
    nv1=T1*vout1;
   set(p1,'Vertices',nv1(1:3,:)');
   nv2=T1*T3*T4*vout2;
   set(p2,'Vertices',nv2(1:3,:)');
   nv3=T1*T3*T4*T6*T5*vout3;
   set(p3,'Vertices',nv3(1:3,:)');
   nv4=T1*T3*T4*T6*T5*T7*T8*vout4;
   set(p4,'Vertices',nv4(1:3,:)');
   nv6=T1*T3*T4*T6*T5*T7*T8*T9*vout6;
   set(p6,'Vertices',nv6(1:3,:)');
   nv7=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*vout7;
   set(p7,'Vertices',nv7(1:3,:)');
   nv8=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*T12*vout8;
   set(p8,'Vertices',nv8(1:3,:)');
   nv9=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*T12*T13*T14*vout9;
   set(p9,'Vertices',nv9(1:3,:)');
   nv10=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*vout10;
   set(p10,'Vertices',nv10(1:3,:)');
   nv11=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*T19*T17*T18*vout11;
   set(p11,'Vertices',nv11(1:3,:)');
   
   drawnow
   rotate3d
   TT=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*T19*T17*T18*T20;
   x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
     end
      elseif get(checkbox,'value')==1
          
      set(cal,'visible','off')
     for t=str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string'))
     T1=tmat( 90,0 ,0,0);
   % T2=tmat(0,0,0,0);
    T3=tmat2(0,40,0);
    T4=rx(0)*ry(fj1(t))*rz(0);
    T5=tmat2(10,0,-10);
    T6=rx(0)*ry(90)*rz(90);
    T7=rx(0)*ry(0)*rz(90);
    T8=tmat2(0,15*fj2(t)-70,10);
    T9=tmat2(0,-20,-7.5);
    T10=rx(90)*ry(0)*rz(0);
    T11=tmat2(0,-20+4.9*fj3(t),-10);
    T12=rx(180)*ry(0)*rz(0);
    T13=tmat2(-2,8,0);
    T14=rx(0)*ry(90)*rz(180);
    T15=tmat2(0,-7.5,2.2);
    T16=rx(180)*ry(90)*rz(0);
    T19=rx(0)*ry(0)*rz(0);
    T17=tmat2(0,7.5,0);
    T18=rx(0)*ry(100*t)*rz(0);
    T20=tmat2(0,14,0);
    
    
    %T5=tmat(90,0,40,0);
    %T6=tmat(0,0,0,0);
    nv1=T1*vout1;
   set(p1,'Vertices',nv1(1:3,:)');
   nv2=T1*T3*T4*vout2;
   set(p2,'Vertices',nv2(1:3,:)');
   nv3=T1*T3*T4*T6*T5*vout3;
   set(p3,'Vertices',nv3(1:3,:)');
   nv4=T1*T3*T4*T6*T5*T7*T8*vout4;
   set(p4,'Vertices',nv4(1:3,:)');
   nv6=T1*T3*T4*T6*T5*T7*T8*T9*vout6;
   set(p6,'Vertices',nv6(1:3,:)');
   nv7=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*vout7;
   set(p7,'Vertices',nv7(1:3,:)');
   nv8=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*T12*vout8;
   set(p8,'Vertices',nv8(1:3,:)');
   nv9=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*T12*T13*T14*vout9;
   set(p9,'Vertices',nv9(1:3,:)');
   nv10=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*vout10;
   set(p10,'Vertices',nv10(1:3,:)');
   nv11=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*T19*T17*T18*vout11;
   set(p11,'Vertices',nv11(1:3,:)');
   
   drawnow
   rotate3d
   TT=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*T19*T17*T18*T20;
   x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
                      
    end
    end
    end
    end


    function prrd(varargin)
        set(joint1_movs,'string','joint1 displ.')
        set(joint2_movs,'string','joint2 angle')
        set(joint3_movs,'string','joint3 angle')
        
        fj1=inline(get(joint1_mov,'string'));
        fj2=inline(get(joint2_mov,'string'));
        fj3=inline(get(joint3_mov,'string'));
        err1=0;
        direction=1;
     
        if str2double(get(Tstart,'string')) > str2double(get(Tend,'string'))
           direction=-1 ;
        end
        t_test= str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string')) ;
      
        
        
        if get(checkbox,'value')==1
            
        if max(fj1(t_test))> 1 || min(fj1(t_test))< -1
            set(err,'string','please check theta 1 limit','visible','on')
           set(hint,'string','use start=0, T end=90, j1=sin(t/5), j2=t, j3=t ','visible','on')
            err1=1;
        end
        if max(fj2(t_test))> 180 || min(fj2(t_test))< 0
            set(err,'string','please check theta 2 limit','visible','on')
             set(hint,'string','use start=0, T end=90, j1=sin(t/5), j2=t, j3=t ','visible','on')
            err1=1;
        end
        if max(fj3(t_test))> 90 || min(fj3(t_test))< -90
            set(err,'string','please check theta 3 limit','visible','on')
          set(hint,'string','use start=0, T end=90, j1=sin(t/5), j2=t, j3=t','visible','on')
            err1=1;
        end
        end

        if err1==1;
            return
        else
        
            [fout1, vout1, cout1] = rndread('base.slp');
            [fout2, vout2, cout2] = rndread('j13.slp');
            [fout3, vout3, cout3] = rndread('j14.slp');
            [fout4, vout4, cout4] = rndread('j5.slp');
            [fout5, vout5, cout5] = rndread('j6.slp');
            [fout6, vout6, cout6] = rndread('e1.slp');
            [fout7, vout7, cout7] = rndread('e2.slp');
            [fout8, vout8, cout8] = rndread('e3.slp');
            
            p1 = patch('faces', fout1, 'vertices' ,vout1);
            p2 = patch('faces', fout2, 'vertices' ,vout2);
            p3 = patch('faces', fout3, 'vertices' ,vout3);
            p4 = patch('faces', fout4, 'vertices' ,vout4);
            p5 = patch('faces', fout5, 'vertices' ,vout5);
            p6 = patch('faces', fout6, 'vertices' ,vout6);
            p7 = patch('faces', fout7, 'vertices' ,vout7);
            p8 = patch('faces', fout8, 'vertices' ,vout8);
            
            set(p1, 'facec', 'flat');
            set(p2, 'facec', 'flat');
            set(p3, 'facec', 'flat');
            set(p4, 'facec', 'flat');
            set(p5, 'facec', 'flat');
            set(p6, 'facec', 'flat');
            set(p7, 'facec', 'flat');
            set(p8, 'facec', 'flat');
        
            
            set(p1, 'FaceVertexCData', cout1); 
            set(p2, 'FaceVertexCData', cout2); 
            set(p3, 'FaceVertexCData', cout3);
            set(p4, 'FaceVertexCData', cout4);
            set(p5, 'FaceVertexCData', cout5);
            set(p6, 'FaceVertexCData', cout6);
            set(p7, 'FaceVertexCData', cout7);
            set(p8, 'FaceVertexCData', cout8);
            
            set(p1, 'EdgeColor','none'); 
            set(p2, 'EdgeColor','none'); 
            set(p3, 'EdgeColor','none'); 
            set(p4, 'EdgeColor','none'); 
            set(p5, 'EdgeColor','none'); 
            set(p6, 'EdgeColor','none'); 
            set(p7, 'EdgeColor','none'); 
            set(p8, 'EdgeColor','none');
            
            
            light                               % add a default light
            daspect([1 1 1])                    % Setting the aspect ratio
            view(3)                             
            xlabel('X'),ylabel('Y'),zlabel('Z')
            title(['KK  BH2 '])
    
            vout1 = vout1';
            vout1 = [vout1(1,:); vout1(2,:); vout1(3,:); ones(1,length(vout1))];
   
            vout2 = vout2';
            vout2 = [vout2(1,:); vout2(2,:); vout2(3,:); ones(1,length(vout2))];

            vout3 = vout3';
            vout3 = [vout3(1,:); vout3(2,:); vout3(3,:); ones(1,length(vout3))];
    
            vout4 = vout4';
            vout4 = [vout4(1,:); vout4(2,:); vout4(3,:); ones(1,length(vout4))];
    
            vout5 = vout5';
            vout5 = [vout5(1,:); vout5(2,:); vout5(3,:); ones(1,length(vout5))];
            
            vout6=vout6*1.6;
            vout7=vout7*1.5;
            vout8=vout8*1.5;
            vout6 = vout6';
            vout6 = [vout6(1,:); vout6(2,:); vout6(3,:); ones(1,length(vout6))];
    
            vout7 = vout7';
            vout7 = [vout7(1,:); vout7(2,:); vout7(3,:); ones(1,length(vout7))];
    
            vout8 = vout8';
            vout8 = [vout8(1,:); vout8(2,:); vout8(3,:); ones(1,length(vout8))];
            
            grid
            vsize =230; % or can be changed 
            axis([-100 vsize -vsize vsize 0 vsize]);
            
            hold on
            set(cal,'visible','off')
    if get(checkbox,'value')==0
            
         for t=0:1:90
               
            T1=tmat( 90,0 ,0,0);
            T2=tmat2(0,40,0);
            T3=tmat2(-50-30*sind(t),20,0);
            T4=tmat2(112.5,0,-7.5);                %change here
            T5=rx(0)*ry(0)*rz(t);
            T6=tmat2(75,0,0);
            T66=rx(0)*ry(0)*rz(t);
            T7=tmat2(52,2.5,7.50);
            T8=rx(90)*ry(-t)*rz(90);
            T9=tmat2(0,-7.5,2.2);
            T10=rx(180)*ry(90)*rz(0);
            T11=tmat2(0,10,0);
            T12=rx(0)*ry(100*t)*rz(0);
            T21=tmat2(0,14,0);
            
            nv1=T1*vout1;
            set(p1,'Vertices',nv1(1:3,:)');
            nv2=T1*T2*vout2;
            set(p2,'Vertices',nv2(1:3,:)');
            nv3=T1*T2*T3*vout3;
            set(p3,'Vertices',nv3(1:3,:)');
            nv4=T1*T2*T3*T4*T5*vout4;
            set(p4,'Vertices',nv4(1:3,:)');
            nv5=T1*T2*T3*T4*T5*T6*T66*vout5;
            set(p5,'Vertices',nv5(1:3,:)');
            nv6=T1*T2*T3*T4*T5*T6*T66*T7*T8*vout6;
            set(p6,'Vertices',nv6(1:3,:)');
            nv7=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*vout7;
            set(p7,'Vertices',nv7(1:3,:)');
            nv8=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*vout8;
            set(p8,'Vertices',nv8(1:3,:)');
            
            
            drawnow
            rotate3d
            TT=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T21;
            x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
            end
    elseif get(checkbox,'value')==1
            for t=str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string'))
            T1=tmat( 90,0 ,0,0);
            T2=tmat2(0,40,0);
            T3=tmat2(-50-30*fj1(t),20,0);
            T4=tmat2(112.5,0,-7.5);                %change here
            T5=rx(0)*ry(0)*rz(fj2(t));
            T6=tmat2(75,0,0);
            T66=rx(0)*ry(0)*rz(fj3(t));
            T7=tmat2(52,2.5,7.50);
            T8=rx(90)*ry(-t)*rz(90);
            T9=tmat2(0,-7.5,2.2);
            T10=rx(180)*ry(90)*rz(0);
            T11=tmat2(0,10,0);
            T12=rx(0)*ry(100*t)*rz(0);
            T21=tmat2(0,14,0);
            
            nv1=T1*vout1;
            set(p1,'Vertices',nv1(1:3,:)');
            nv2=T1*T2*vout2;
            set(p2,'Vertices',nv2(1:3,:)');
            nv3=T1*T2*T3*vout3;
            set(p3,'Vertices',nv3(1:3,:)');
            nv4=T1*T2*T3*T4*T5*vout4;
            set(p4,'Vertices',nv4(1:3,:)');
            nv5=T1*T2*T3*T4*T5*T6*T66*vout5;
            set(p5,'Vertices',nv5(1:3,:)');
            nv6=T1*T2*T3*T4*T5*T6*T66*T7*T8*vout6;
            set(p6,'Vertices',nv6(1:3,:)');
            nv7=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*vout7;
            set(p7,'Vertices',nv7(1:3,:)');
            nv8=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*vout8;
            set(p8,'Vertices',nv8(1:3,:)');
            
            
            drawnow
            rotate3d
            TT=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T21;
            x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
           
         end 
        end
    end
end




    function prpd(varargin)
        
        
        set(joint1_movs,'string','joint1 displ')
        set(joint2_movs,'string','joint2 angle')
        set(joint3_movs,'string','joint3 displ.')
        
        fj1=inline(get(joint1_mov,'string'));
        fj2=inline(get(joint2_mov,'string'));
        fj3=inline(get(joint3_mov,'string'));
        err1=0;
        direction=1;
     
        if str2double(get(Tstart,'string')) > str2double(get(Tend,'string'))
           direction=-1 ;
        end
        t_test= str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string')) ;
      
        
        
        if get(checkbox,'value')==1
            
        if max(fj1(t_test))> 1 || min(fj1(t_test))< -1
            set(err,'string','please check theta 1 limit','visible','on')
           set(hint,'string','use start=0, T end=90, j1=sin(t/5), j2=t, j3=sin(t) ','visible','on')
            err1=1;
        end
        if max(fj2(t_test))> 180 || min(fj2(t_test))< 0
            set(err,'string','please check theta 2 limit','visible','on')
             set(hint,'string','use start=0, T end=90,  j1=sin(t/5), j2=t, j3=sin(t) ','visible','on')
            err1=1;
        end
        if max(fj3(t_test))> 1 || min(fj3(t_test))< -1
            set(err,'string','please check theta 3 limit','visible','on')
          set(hint,'string','use start=0, T end=90, j1=sin(t/5), j2=t, j3=sin(t) ','visible','on')
            err1=1;
        end
        end

        if err1==1;
            return
        else
            [fout1, vout1, cout1] = rndread('base.slp');
            [fout2, vout2, cout2] = rndread('j13.slp');
            [fout3, vout3, cout3] = rndread('j14.slp');
            [fout4, vout4, cout4] = rndread('j5.slp');
            [fout5, vout5, cout5] = rndread('j10.slp');
            [fout6, vout6, cout6] = rndread('j11.slp');
            [fout7, vout7, cout7] = rndread('j12.slp');
            [fout8, vout8, cout8] = rndread('e1.slp');
            [fout9, vout9, cout9] = rndread('e2.slp');
            [fout10, vout10, cout10] = rndread('e3.slp');
            
            
            p1 = patch('faces', fout1, 'vertices' ,vout1);
            p2 = patch('faces', fout2, 'vertices' ,vout2);
            p3 = patch('faces', fout3, 'vertices' ,vout3);
            p4 = patch('faces', fout4, 'vertices' ,vout4);
            p5 = patch('faces', fout5, 'vertices' ,vout5);
            p6 = patch('faces', fout6, 'vertices' ,vout6);
            p7 = patch('faces', fout7, 'vertices' ,vout7);
            p8 = patch('faces', fout8, 'vertices' ,vout8);
            p9 = patch('faces', fout9, 'vertices' ,vout9);
            p10 = patch('faces', fout10, 'vertices' ,vout10);
            
            set(p1, 'facec', 'flat');
            set(p2, 'facec', 'flat');
            set(p3, 'facec', 'flat');
            set(p4, 'facec', 'flat');
            set(p5, 'facec', 'flat');
            set(p6, 'facec', 'flat');
            set(p7, 'facec', 'flat');
            set(p8, 'facec', 'flat');
            set(p9, 'facec', 'flat');
            set(p10, 'facec', 'flat');
        
            
            set(p1, 'FaceVertexCData', cout1); 
            set(p2, 'FaceVertexCData', cout2); 
            set(p3, 'FaceVertexCData', cout3);
            set(p4, 'FaceVertexCData', cout4);
            set(p5, 'FaceVertexCData', cout5);
            set(p6, 'FaceVertexCData', cout6);
            set(p7, 'FaceVertexCData', cout7);
            set(p8, 'FaceVertexCData', cout8);
            set(p9, 'FaceVertexCData', cout9);
            set(p10, 'FaceVertexCData', cout10);
            
            set(p1, 'EdgeColor','none'); 
            set(p2, 'EdgeColor','none'); 
            set(p3, 'EdgeColor','none'); 
            set(p4, 'EdgeColor','none'); 
            set(p5, 'EdgeColor','none'); 
            set(p6, 'EdgeColor','none'); 
            set(p7, 'EdgeColor','none'); 
            set(p8, 'EdgeColor','none');
            set(p9, 'EdgeColor','none'); 
            set(p10, 'EdgeColor','none');
            
            
            light                               % add a default light
            daspect([1 1 1])                    % Setting the aspect ratio
            view(3)                             
            xlabel('X'),ylabel('Y'),zlabel('Z')
            title(['KK  BH2 '])
    
            vout1 = vout1';
            vout1 = [vout1(1,:); vout1(2,:); vout1(3,:); ones(1,length(vout1))];
   
            vout2 = vout2';
            vout2 = [vout2(1,:); vout2(2,:); vout2(3,:); ones(1,length(vout2))];

            vout3 = vout3';
            vout3 = [vout3(1,:); vout3(2,:); vout3(3,:); ones(1,length(vout3))];
    
            vout4 = vout4';
            vout4 = [vout4(1,:); vout4(2,:); vout4(3,:); ones(1,length(vout4))];
            
            vout5=vout5*1.3;
            vout5 = vout5';
            vout5 = [vout5(1,:); vout5(2,:); vout5(3,:); ones(1,length(vout5))];
            
            vout9=vout9*1.5;
            vout10=vout10*1.5;
            vout8=vout8*1.2;
            vout6 = vout6';
            vout6 = [vout6(1,:); vout6(2,:); vout6(3,:); ones(1,length(vout6))];
    
            vout7 = vout7';
            vout7 = [vout7(1,:); vout7(2,:); vout7(3,:); ones(1,length(vout7))];
    
            vout8 = vout8';
            vout8 = [vout8(1,:); vout8(2,:); vout8(3,:); ones(1,length(vout8))];
            
            vout9 = vout9';
            vout9 = [vout9(1,:); vout9(2,:); vout9(3,:); ones(1,length(vout9))];
    
            vout10 = vout10';
            vout10 = [vout10(1,:); vout10(2,:); vout10(3,:); ones(1,length(vout10))];
            
            grid
            vsize =230; % or can be changed 
            axis([-100 vsize -vsize vsize 0 vsize]);
            
            hold on
            set(cal,'visible','off')
    if get(checkbox,'value')==0
        
       for t=0:1:90
               
            T1=tmat( 90,0 ,0,0);
            T2=tmat2(0,40,0);
            T3=tmat2(-50-30*sind(t),20,0);
            T4=tmat2(112.5,0,-7.5);                %change here
            T5=rx(0)*ry(0)*rz(t);
            T6=tmat2(100,0,-2);
            T66=rx(0)*ry(0)*rz(90);
            T7=tmat2(0,10,5*sin(t/8)+4);
            T8=rx(90)*ry(0)*rz(00);
            T9=tmat2(0,32.5,0);
            T10=rx(0)*ry(90)*rz(0);
            T11=tmat2(-1,10,0);
            T12=rx(180)*ry(90)*rz(0);
            T13=tmat2(0,-7.5,2.2);
            T14=rx(180)*ry(90)*rz(0);
            T15=tmat2(0,10,0);
            T16=rx(0)*ry(100*t)*rz(0);
            T17=tmat2(0,14,0);
            
            nv1=T1*vout1;
            set(p1,'Vertices',nv1(1:3,:)');
            nv2=T1*T2*vout2;
            set(p2,'Vertices',nv2(1:3,:)');
            nv3=T1*T2*T3*vout3;
            set(p3,'Vertices',nv3(1:3,:)');
            nv4=T1*T2*T3*T4*T5*vout4;
            set(p4,'Vertices',nv4(1:3,:)');
            nv5=T1*T2*T3*T4*T5*T6*T66*vout5;
            set(p5,'Vertices',nv5(1:3,:)');
            nv6=T1*T2*T3*T4*T5*T6*T66*T7*T8*vout6;
            set(p6,'Vertices',nv6(1:3,:)');
            nv7=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*vout7;
            set(p7,'Vertices',nv7(1:3,:)');
            nv8=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*vout8;
            set(p8,'Vertices',nv8(1:3,:)');
            nv9=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*vout9;
            set(p9,'Vertices',nv9(1:3,:)');
            nv10=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*vout10;
            set(p10,'Vertices',nv10(1:3,:)');
            
            
            
            drawnow
            rotate3d
             TT=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*T17;
             x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
            
            end
    elseif get(checkbox,'value')==1
                for t=str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string'))
                    
        T1=tmat( 90,0 ,0,0);
            T2=tmat2(0,40,0);
            T3=tmat2(-50-30*sin(fj1(t)),20,0);
            T4=tmat2(112.5,0,-7.5);                %change here
            T5=rx(0)*ry(0)*rz(fj2(t));
            T6=tmat2(100,0,-2);
            T66=rx(0)*ry(0)*rz(90);
            T7=tmat2(0,10,5*fj3(t)+4);
            T8=rx(90)*ry(0)*rz(00);
            T9=tmat2(0,32.5,0);
            T10=rx(0)*ry(90)*rz(0);
            T11=tmat2(-1,10,0);
            T12=rx(180)*ry(90)*rz(0);
            T13=tmat2(0,-7.5,2.2);
            T14=rx(180)*ry(90)*rz(0);
            T15=tmat2(0,10,0);
            T16=rx(0)*ry(100*t)*rz(0);
            T17=tmat2(0,14,0);
            
            
            nv1=T1*vout1;
            set(p1,'Vertices',nv1(1:3,:)');
            nv2=T1*T2*vout2;
            set(p2,'Vertices',nv2(1:3,:)');
            nv3=T1*T2*T3*vout3;
            set(p3,'Vertices',nv3(1:3,:)');
            nv4=T1*T2*T3*T4*T5*vout4;
            set(p4,'Vertices',nv4(1:3,:)');
            nv5=T1*T2*T3*T4*T5*T6*T66*vout5;
            set(p5,'Vertices',nv5(1:3,:)');
            nv6=T1*T2*T3*T4*T5*T6*T66*T7*T8*vout6;
            set(p6,'Vertices',nv6(1:3,:)');
            nv7=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*vout7;
            set(p7,'Vertices',nv7(1:3,:)');
            nv8=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*vout8;
            set(p8,'Vertices',nv8(1:3,:)');
            nv9=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*vout9;
            set(p9,'Vertices',nv9(1:3,:)');
            nv10=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*vout10;
            set(p10,'Vertices',nv10(1:3,:)');
            
            
            
            drawnow
            rotate3d
            TT=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*T17;
             x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
         end
    end
        end
    
    end



    function pprd(varargin)
            
        set(joint1_movs,'string','joint1 displ.')
        set(joint2_movs,'string','joint2 displ.')
        set(joint3_movs,'string','joint3 angle')
        
        fj1=inline(get(joint1_mov,'string'));
        fj2=inline(get(joint2_mov,'string'));
        fj3=inline(get(joint3_mov,'string'));
        err1=0;
        direction=1;
     
        if str2double(get(Tstart,'string')) > str2double(get(Tend,'string'))
           direction=-1 ;
        end
        t_test= str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string')) ;
      
        
        
        if get(checkbox,'value')==1
            
        if max(fj1(t_test))> 1 || min(fj1(t_test))< -1
            set(err,'string','please check theta 1 limit','visible','on')
           set(hint,'string','use start=0, T end=90, j1=sin(t/4), j2=cos(t/3), j3=t ','visible','on')
            err1=1;
        end
        if max(fj2(t_test))> 1 || min(fj2(t_test))< -1
            set(err,'string','please check theta 2 limit','visible','on')
             set(hint,'string','use start=0, T end=90, j1=sin(t/4), j2=cos(t/3), j3=t  ','visible','on')
            err1=1;
        end
        if max(fj3(t_test))> 200 || min(fj3(t_test))< -40
            set(err,'string','please check theta 3 limit','visible','on')
          set(hint,'string','use start=0, T end=90, j1=sin(t/4), j2=cos(t/3), j3=t  ','visible','on')
            err1=1;
        end
        end

        if err1==1;
            return
        else
        
        
            [fout1, vout1, cout1] = rndread('base.slp');
            [fout2, vout2, cout2] = rndread('j13.slp');
            [fout3, vout3, cout3] = rndread('j14.slp');
            [fout4, vout4, cout4] = rndread('j7.slp');
            [fout5, vout5, cout5] = rndread('j8.slp');
            [fout6, vout6, cout6] = rndread('j9.slp');
            [fout7, vout7, cout7] = rndread('j6.slp');
            [fout8, vout8, cout8] = rndread('e1.slp');
            [fout9, vout9, cout9] = rndread('e2.slp');
            [fout10, vout10, cout10] = rndread('e3.slp');
            
            
            p1 = patch('faces', fout1, 'vertices' ,vout1);
            p2 = patch('faces', fout2, 'vertices' ,vout2);
            p3 = patch('faces', fout3, 'vertices' ,vout3);
            p4 = patch('faces', fout4, 'vertices' ,vout4);
            p5 = patch('faces', fout5, 'vertices' ,vout5);
            p6 = patch('faces', fout6, 'vertices' ,vout6);
            p7 = patch('faces', fout7, 'vertices' ,vout7);
            p8 = patch('faces', fout8, 'vertices' ,vout8);
            p9 = patch('faces', fout9, 'vertices' ,vout9);
            p10 = patch('faces', fout10, 'vertices' ,vout10);
            
            set(p1, 'facec', 'flat');
            set(p2, 'facec', 'flat');
            set(p3, 'facec', 'flat');
            set(p4, 'facec', 'flat');
            set(p5, 'facec', 'flat');
            set(p6, 'facec', 'flat');
            set(p7, 'facec', 'flat');
            set(p8, 'facec', 'flat');
            set(p9, 'facec', 'flat');
            set(p10, 'facec', 'flat');
        
            
            set(p1, 'FaceVertexCData', cout1); 
            set(p2, 'FaceVertexCData', cout2); 
            set(p3, 'FaceVertexCData', cout3);
            set(p4, 'FaceVertexCData', cout4);
            set(p5, 'FaceVertexCData', cout5);
            set(p6, 'FaceVertexCData', cout6);
            set(p7, 'FaceVertexCData', cout7);
            set(p8, 'FaceVertexCData', cout8);
            set(p9, 'FaceVertexCData', cout9);
            set(p10, 'FaceVertexCData', cout10);
            
            set(p1, 'EdgeColor','none'); 
            set(p2, 'EdgeColor','none'); 
            set(p3, 'EdgeColor','none'); 
            set(p4, 'EdgeColor','none'); 
            set(p5, 'EdgeColor','none'); 
            set(p6, 'EdgeColor','none'); 
            set(p7, 'EdgeColor','none'); 
            set(p8, 'EdgeColor','none');
            set(p9, 'EdgeColor','none'); 
            set(p10, 'EdgeColor','none');
            
            
            light                               % add a default light
            daspect([1 1 1])                    % Setting the aspect ratio
            view(3)                             
            xlabel('X'),ylabel('Y'),zlabel('Z')
            title(['KK  BH2 '])
    
            vout1 = vout1';
            vout1 = [vout1(1,:); vout1(2,:); vout1(3,:); ones(1,length(vout1))];
   
            vout2 = vout2';
            vout2 = [vout2(1,:); vout2(2,:); vout2(3,:); ones(1,length(vout2))];

            vout3 = vout3';
            vout3 = [vout3(1,:); vout3(2,:); vout3(3,:); ones(1,length(vout3))];
    
            vout4 = vout4';
            vout4 = [vout4(1,:); vout4(2,:); vout4(3,:); ones(1,length(vout4))];
            
            
            vout5 = vout5';
            vout5 = [vout5(1,:); vout5(2,:); vout5(3,:); ones(1,length(vout5))];
            
            vout9=vout9*1.5;
            vout10=vout10*1.5;
            vout8=vout8*1.5;
            vout6 = vout6';
            vout6 = [vout6(1,:); vout6(2,:); vout6(3,:); ones(1,length(vout6))];
    
            vout7 = vout7';
            vout7 = [vout7(1,:); vout7(2,:); vout7(3,:); ones(1,length(vout7))];
    
            vout8 = vout8';
            vout8 = [vout8(1,:); vout8(2,:); vout8(3,:); ones(1,length(vout8))];
            
            vout9 = vout9';
            vout9 = [vout9(1,:); vout9(2,:); vout9(3,:); ones(1,length(vout9))];
    
            vout10 = vout10';
            vout10 = [vout10(1,:); vout10(2,:); vout10(3,:); ones(1,length(vout10))];
            
            grid
            vsize =230; % or can be changed 
            axis([-100 vsize -vsize vsize 0 vsize]);
        
            hold on
            set(cal,'visible','off')
    if get(checkbox,'value')==0
            
        for t=0:1:90
               
            T1=tmat( 90,0 ,0,0);
            T2=tmat2(0,40,0);
            T3=tmat2(-50-30*sind(t),20,0);
            T4=tmat2(112.5,0,-7.5);                %change here
            T5=rx(0)*ry(0)*rz(90);
            T6=tmat2(60+10*sin(t/8),0,7.5);
            T66=rx(0)*ry(0)*rz(90);
            T7=tmat2(0,-2,0);
            T8=rx(180)*ry(90)*rz(0);
            T9=tmat2(0,4,-7.5);
            T10=rx(0)*ry(0)*rz(t);
            T11=tmat2(50,0,7.5);
            T12=rx(180)*ry(90)*rz(0);
            T13=tmat2(0,-7.5,2.2);
            T14=rx(180)*ry(90)*rz(0);
            T15=tmat2(0,10,0);
            T16=rx(0)*ry(100*t)*rz(0);
             T17=tmat2(0,14,0);
            
            nv1=T1*vout1;
            set(p1,'Vertices',nv1(1:3,:)');
            nv2=T1*T2*vout2;
            set(p2,'Vertices',nv2(1:3,:)');
            nv3=T1*T2*T3*vout3;
            set(p3,'Vertices',nv3(1:3,:)');
            nv4=T1*T2*T3*T4*T5*vout4;
            set(p4,'Vertices',nv4(1:3,:)');
            nv5=T1*T2*T3*T4*T5*T6*T66*vout5;
            set(p5,'Vertices',nv5(1:3,:)');
            nv6=T1*T2*T3*T4*T5*T6*T66*T7*T8*vout6;
            set(p6,'Vertices',nv6(1:3,:)');
            nv7=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*vout7;
            set(p7,'Vertices',nv7(1:3,:)');
            nv8=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*vout8;
            set(p8,'Vertices',nv8(1:3,:)');
            nv9=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*vout9;
            set(p9,'Vertices',nv9(1:3,:)');
            nv10=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*vout10;
            set(p10,'Vertices',nv10(1:3,:)');
            
            
            
            drawnow
            rotate3d
            TT=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*T17;
            x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
   
             end
    elseif get(checkbox,'value')==1
                for t=str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string'))
            
                    T1=tmat( 90,0 ,0,0);
            T2=tmat2(0,40,0);
            T3=tmat2(-50-30*fj1(t),20,0);
            T4=tmat2(112.5,0,-7.5);                %change here
            T5=rx(0)*ry(0)*rz(90);
            T6=tmat2(60+10*fj2(t),0,7.5);
            T66=rx(0)*ry(0)*rz(90);
            T7=tmat2(0,-2,0);
            T8=rx(180)*ry(90)*rz(0);
            T9=tmat2(0,4,-7.5);
            T10=rx(0)*ry(0)*rz(fj3(t));
            T11=tmat2(50,0,7.5);
            T12=rx(180)*ry(90)*rz(0);
            T13=tmat2(0,-7.5,2.2);
            T14=rx(180)*ry(90)*rz(0);
            T15=tmat2(0,10,0);
            T16=rx(0)*ry(100*t)*rz(0);
             T17=tmat2(0,14,0);
            
            nv1=T1*vout1;
            set(p1,'Vertices',nv1(1:3,:)');
            nv2=T1*T2*vout2;
            set(p2,'Vertices',nv2(1:3,:)');
            nv3=T1*T2*T3*vout3;
            set(p3,'Vertices',nv3(1:3,:)');
            nv4=T1*T2*T3*T4*T5*vout4;
            set(p4,'Vertices',nv4(1:3,:)');
            nv5=T1*T2*T3*T4*T5*T6*T66*vout5;
            set(p5,'Vertices',nv5(1:3,:)');
            nv6=T1*T2*T3*T4*T5*T6*T66*T7*T8*vout6;
            set(p6,'Vertices',nv6(1:3,:)');
            nv7=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*vout7;
            set(p7,'Vertices',nv7(1:3,:)');
            nv8=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*vout8;
            set(p8,'Vertices',nv8(1:3,:)');
            nv9=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*vout9;
            set(p9,'Vertices',nv9(1:3,:)');
            nv10=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*vout10;
            set(p10,'Vertices',nv10(1:3,:)');
            
            
            
            drawnow
            rotate3d
            TT=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*T17;
            x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
            
                    
         end
    
    end
        end
        
        
    end





    function pppd(varargin)
        
        set(joint1_movs,'string','joint1 angle')
        set(joint2_movs,'string','joint2 angle')
        set(joint3_movs,'string','joint3 displ.')
        
        fj1=inline(get(joint1_mov,'string'));
        fj2=inline(get(joint2_mov,'string'));
        fj3=inline(get(joint3_mov,'string'));
        err1=0;
        direction=1;
     
        if str2double(get(Tstart,'string')) > str2double(get(Tend,'string'))
           direction=-1 ;
        end
        t_test= str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string')) ;
      
        
        
        if get(checkbox,'value')==1
            
        if max(fj1(t_test))> 1 || min(fj1(t_test))< -1
            set(err,'string','please check theta 1 limit','visible','on')
           set(hint,'string','use start=0, T end=90, j1=sin(t/10), j2=sin(t/10), j3=sin(t/10) ','visible','on')
            err1=1;
        end
        if max(fj2(t_test))> 1 || min(fj2(t_test))< -1
            set(err,'string','please check theta 2 limit','visible','on')
             set(hint,'string','use start=0, T end=90, j1=sin(t/10), j2=sin(t/10), j3=sin(t/10) ','visible','on')
            err1=1;
        end
        if max(fj3(t_test))> 1 || min(fj3(t_test))< -1
            set(err,'string','please check theta 3 limit','visible','on')
          set(hint,'string','use start=0, T end=90, j1=sin(t/10), j2=sin(t/10), j3=sin(t/10) ','visible','on')
            err1=1;
        end
        end

        if err1==1;
            return
        else
        
        
            [fout1, vout1, cout1] = rndread('base.slp');
            [fout2, vout2, cout2] = rndread('j13.slp');
            [fout3, vout3, cout3] = rndread('j14.slp');
            [fout4, vout4, cout4] = rndread('j7.slp');
            [fout5, vout5, cout5] = rndread('j8.slp');
            [fout6, vout6, cout6] = rndread('j10.slp');
            [fout7, vout7, cout7] = rndread('j11.slp');
            [fout8, vout8, cout8] = rndread('j12.slp');
            [fout9, vout9, cout9] = rndread('e1.slp');
            [fout10, vout10, cout10] = rndread('e2.slp');
            [fout11, vout11, cout11] = rndread('e3.slp');
        
            
            p1 = patch('faces', fout1, 'vertices' ,vout1);
            p2 = patch('faces', fout2, 'vertices' ,vout2);
            p3 = patch('faces', fout3, 'vertices' ,vout3);
            p4 = patch('faces', fout4, 'vertices' ,vout4);
            p5 = patch('faces', fout5, 'vertices' ,vout5);
            p6 = patch('faces', fout6, 'vertices' ,vout6);
            p7 = patch('faces', fout7, 'vertices' ,vout7);
            p8 = patch('faces', fout8, 'vertices' ,vout8);
            p9 = patch('faces', fout9, 'vertices' ,vout9);
            p10 = patch('faces', fout10, 'vertices' ,vout10);
            p11 = patch('faces', fout11, 'vertices' ,vout11);
            
            set(p1, 'facec', 'flat');
            set(p2, 'facec', 'flat');
            set(p3, 'facec', 'flat');
            set(p4, 'facec', 'flat');
            set(p5, 'facec', 'flat');
            set(p6, 'facec', 'flat');
            set(p7, 'facec', 'flat');
            set(p8, 'facec', 'flat');
            set(p9, 'facec', 'flat');
            set(p10, 'facec', 'flat');
            set(p11, 'facec', 'flat');
        
            
            set(p1, 'FaceVertexCData', cout1); 
            set(p2, 'FaceVertexCData', cout2); 
            set(p3, 'FaceVertexCData', cout3);
            set(p4, 'FaceVertexCData', cout4);
            set(p5, 'FaceVertexCData', cout5);
            set(p6, 'FaceVertexCData', cout6);
            set(p7, 'FaceVertexCData', cout7);
            set(p8, 'FaceVertexCData', cout8);
            set(p9, 'FaceVertexCData', cout9);
            set(p10, 'FaceVertexCData', cout10);
            set(p11, 'FaceVertexCData', cout11);
            
            set(p1, 'EdgeColor','none'); 
            set(p2, 'EdgeColor','none'); 
            set(p3, 'EdgeColor','none'); 
            set(p4, 'EdgeColor','none'); 
            set(p5, 'EdgeColor','none'); 
            set(p6, 'EdgeColor','none'); 
            set(p7, 'EdgeColor','none'); 
            set(p8, 'EdgeColor','none');
            set(p9, 'EdgeColor','none'); 
            set(p10, 'EdgeColor','none');
            set(p11, 'EdgeColor','none');
            
            
            light                               % add a default light
            daspect([1 1 1])                    % Setting the aspect ratio
            view(3)                             
            xlabel('X'),ylabel('Y'),zlabel('Z')
            title(['KK  BH2 '])
    
            vout1 = vout1';
            vout1 = [vout1(1,:); vout1(2,:); vout1(3,:); ones(1,length(vout1))];
   
            vout2 = vout2';
            vout2 = [vout2(1,:); vout2(2,:); vout2(3,:); ones(1,length(vout2))];

            vout3 = vout3';
            vout3 = [vout3(1,:); vout3(2,:); vout3(3,:); ones(1,length(vout3))];
    
            vout4 = vout4';
            vout4 = [vout4(1,:); vout4(2,:); vout4(3,:); ones(1,length(vout4))];
            
            
            vout5 = vout5';
            vout5 = [vout5(1,:); vout5(2,:); vout5(3,:); ones(1,length(vout5))];
            
            vout9=vout9*1.2;
            vout10=vout10*1.5;
            vout11=vout11*1.5;
            
            vout6 = vout6';
            vout6 = [vout6(1,:); vout6(2,:); vout6(3,:); ones(1,length(vout6))];
    
            vout7 = vout7';
            vout7 = [vout7(1,:); vout7(2,:); vout7(3,:); ones(1,length(vout7))];
    
            vout8 = vout8';
            vout8 = [vout8(1,:); vout8(2,:); vout8(3,:); ones(1,length(vout8))];
            
            vout9 = vout9';
            vout9 = [vout9(1,:); vout9(2,:); vout9(3,:); ones(1,length(vout9))];
    
            vout10 = vout10';
            vout10 = [vout10(1,:); vout10(2,:); vout10(3,:); ones(1,length(vout10))];
            
            vout11 = vout11';
            vout11 = [vout11(1,:); vout11(2,:); vout11(3,:); ones(1,length(vout11))];
            
            grid
            vsize =230; % or can be changed 
            axis([-100 vsize -vsize vsize 0 vsize]);
            
            
              hold on
              set(cal,'visible','off')
    if get(checkbox,'value')==0
            
            for t=0:1:90
               
            T1=tmat( 90,0 ,0,0);
            T2=tmat2(0,40,0);
            T3=tmat2(-50-30*sind(t),20,0);
            T4=tmat2(112.5,0,-7.5);                %change here
            T5=rx(0)*ry(0)*rz(90);
            T6=tmat2(60+10*sin(t/8),0,7.5);
            T66=rx(0)*ry(0)*rz(90);
            T7=tmat2(-7.5,0,0);
            T8=rx(180)*ry(90)*rz(0);
            T9=tmat2(25-5*sin(t/8),15,7.5);
            T10=rx(0)*ry(0)*rz(90);
            T11=tmat2(0,-2,0);
            T12=rx(180)*ry(90)*rz(0);
            T13=tmat2(-1,10,0);
            T14=rx(180)*ry(90)*rz(0);
            T15=tmat2(0,-7.5,2);
            T16=rx(180)*ry(90)*rz(0);
            T17=tmat2(0,10,0);
            T18=rx(0)*ry(100*t)*rz(0);
            T19=tmat2(0,14,0);
            
            nv1=T1*vout1;
            set(p1,'Vertices',nv1(1:3,:)');
            nv2=T1*T2*vout2;
            set(p2,'Vertices',nv2(1:3,:)');
            nv3=T1*T2*T3*vout3;
            set(p3,'Vertices',nv3(1:3,:)');
            nv4=T1*T2*T3*T4*T5*vout4;
            set(p4,'Vertices',nv4(1:3,:)');
            nv5=T1*T2*T3*T4*T5*T6*T66*vout5;
            set(p5,'Vertices',nv5(1:3,:)');
            nv6=T1*T2*T3*T4*T5*T6*T66*T7*T8*vout6;
            set(p6,'Vertices',nv6(1:3,:)');
            nv7=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*vout7;
            set(p7,'Vertices',nv7(1:3,:)');
            nv8=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*vout8;
            set(p8,'Vertices',nv8(1:3,:)');
            nv9=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*vout9;
            set(p9,'Vertices',nv9(1:3,:)');
            nv10=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*vout10;
            set(p10,'Vertices',nv10(1:3,:)');
            nv11=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*T17*T18*vout11;
            set(p11,'Vertices',nv11(1:3,:)');
            
            drawnow
            rotate3d
            
            TT=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*T17*T18*T19;
             x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
            drawnow
            rotate3d
            
            end
            elseif get(checkbox,'value')==1
                
            for t=str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string'))
            T1=tmat( 90,0 ,0,0);
            T2=tmat2(0,40,0);
            T3=tmat2(-50-30*fj1(t),20,0);
            T4=tmat2(112.5,0,-7.5);                %change here
            T5=rx(0)*ry(0)*rz(90);
            T6=tmat2(60+10*fj2(t),0,7.5);
            T66=rx(0)*ry(0)*rz(90);
            T7=tmat2(-7.5,0,0);
            T8=rx(180)*ry(90)*rz(0);
            T9=tmat2(25-5*fj3(t),15,7.5);
            T10=rx(0)*ry(0)*rz(90);
            T11=tmat2(0,-2,0);
            T12=rx(180)*ry(90)*rz(0);
            T13=tmat2(-1,10,0);
            T14=rx(180)*ry(90)*rz(0);
            T15=tmat2(0,-7.5,2);
            T16=rx(180)*ry(90)*rz(0);
            T17=tmat2(0,10,0);
            T18=rx(0)*ry(100*t)*rz(0);
                        T19=tmat2(0,14,0);
            
            nv1=T1*vout1;
            set(p1,'Vertices',nv1(1:3,:)');
            nv2=T1*T2*vout2;
            set(p2,'Vertices',nv2(1:3,:)');
            nv3=T1*T2*T3*vout3;
            set(p3,'Vertices',nv3(1:3,:)');
            nv4=T1*T2*T3*T4*T5*vout4;
            set(p4,'Vertices',nv4(1:3,:)');
            nv5=T1*T2*T3*T4*T5*T6*T66*vout5;
            set(p5,'Vertices',nv5(1:3,:)');
            nv6=T1*T2*T3*T4*T5*T6*T66*T7*T8*vout6;
            set(p6,'Vertices',nv6(1:3,:)');
            nv7=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*vout7;
            set(p7,'Vertices',nv7(1:3,:)');
            nv8=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*vout8;
            set(p8,'Vertices',nv8(1:3,:)');
            nv9=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*vout9;
            set(p9,'Vertices',nv9(1:3,:)');
            nv10=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*vout10;
            set(p10,'Vertices',nv10(1:3,:)');
            nv11=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*T17*T18*vout11;
            set(p11,'Vertices',nv11(1:3,:)');
            
            
            
            drawnow
            rotate3d
            
            
            TT=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*T17*T18*T19;
             x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
         end
    
    end
        end
            
        
    end




function rrrw(varargin)
        
         set(joint1_movs,'string','joint1 angle')
        set(joint2_movs,'string','joint2 angle')
        set(joint3_movs,'string','joint3 angle')
        
        fj1=inline(get(joint1_mov,'string'));
        fj2=inline(get(joint2_mov,'string'));
        fj3=inline(get(joint3_mov,'string'));
        err1=0;
        direction=1;
     
        if str2double(get(Tstart,'string')) > str2double(get(Tend,'string'))
           direction=-1 ;
        end
        t_test= str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string')) ;
      
        
        
        if get(checkbox,'value')==1
            
        if max(fj1(t_test))> 400 || min(fj1(t_test))< -500
            set(err,'string','please check theta 1 limit','visible','on')
            set(hint,'string','use start=0, T end=90, j1=t, j2=t, j3=t ','visible','on')
            err1=1;
        end
        if max(fj2(t_test))> 180 || min(fj2(t_test))< 0
            set(err,'string','please check theta 2 limit','visible','on')
            set(hint,'string','use start=0, end=90, j1=t, j2=t, j3=t ','visible','on')
            err1=1;
        end
        if max(fj3(t_test))> 120 || min(fj3(t_test))< -120
            set(err,'string','please check theta 3 limit','visible','on')
            set(hint,'string','use start=0, end=90, j1=t, j2=t, j3=t ','visible','on')
            err1=1;
        end
        end

        if err1==1;
            return
        else
        
        [fout1, vout1, cout1] = rndread('base.slp');
        [fout2, vout2, cout2] = rndread('j1.slp');
        [fout3, vout3, cout3] = rndread('j5.slp');
        [fout4, vout4, cout4] = rndread('j6.slp');
        [fout5, vout5, cout5] = rndread('e1.slp');
        [fout6, vout6, cout6] = rndread('e4.slp');
        [fout7, vout7, cout7] = rndread('e5.slp');
       
        p1 = patch('faces', fout1, 'vertices' ,vout1);
        p2 = patch('faces', fout2, 'vertices' ,vout2);
        p3 = patch('faces', fout3, 'vertices' ,vout3);
        p4 = patch('faces', fout4, 'vertices' ,vout4);
        p5 = patch('faces', fout5, 'vertices' ,vout5);
        p6 = patch('faces', fout6, 'vertices' ,vout6);
        p7 = patch('faces', fout7, 'vertices' ,vout7);
        set(p1, 'facec', 'flat');
        set(p2, 'facec', 'flat');
        set(p3, 'facec', 'flat');
        set(p4, 'facec', 'flat');
        set(p5, 'facec', 'flat');
        set(p6, 'facec', 'flat');
        set(p7, 'facec', 'flat');
%        set(p3, 'facec', 'flat');
    
         set(p1, 'FaceVertexCData', cout1); 
      set(p2, 'FaceVertexCData', cout2); 
      set(p3, 'FaceVertexCData', cout3);
      set(p4, 'FaceVertexCData', cout4);
       set(p5, 'FaceVertexCData', cout5); 
      set(p6, 'FaceVertexCData', cout6);
      set(p7, 'FaceVertexCData', cout7);
   %  set(p3, 'FaceVertexCData', cout3); 
    
    set(p1, 'EdgeColor','none'); 
    set(p2, 'EdgeColor','none'); 
    set(p3, 'EdgeColor','none'); 
    set(p4, 'EdgeColor','none'); 
    set(p5, 'EdgeColor','none'); 
    set(p6, 'EdgeColor','none'); 
    set(p7, 'EdgeColor','none'); 
   % set(p3, 'EdgeColor','none');
    
    light                               % add a default light
    daspect([1 1 1])                    % Setting the aspect ratio
    view(3)                             % Isometric view
   % pause(5)
    xlabel('X'),ylabel('Y'),zlabel('Z')
    title(['KK  BH2 '])
    vout1 = vout1';
    vout1 = [vout1(1,:); vout1(2,:); vout1(3,:); ones(1,length(vout1))];
   
   vout2 = vout2';
    vout2 = [vout2(1,:); vout2(2,:); vout2(3,:); ones(1,length(vout2))];
    
    vout3 = vout3';
    vout3 = [vout3(1,:); vout3(2,:); vout3(3,:); ones(1,length(vout3))];
    
    vout4 = vout4';
    vout4 = [vout4(1,:); vout4(2,:); vout4(3,:); ones(1,length(vout4))];
    vout5=vout5*1.6;
    vout6=vout6*5;
    vout7=vout7*40;
     vout5 = vout5';
    vout5 = [vout5(1,:); vout5(2,:); vout5(3,:); ones(1,length(vout5))];
    
    vout6 = vout6';
    vout6 = [vout6(1,:); vout6(2,:); vout6(3,:); ones(1,length(vout6))];
    
    vout7 = vout7';
    vout7 = [vout7(1,:); vout7(2,:); vout7(3,:); ones(1,length(vout7))];
    
    
    vsize =150; % or can be changed 
    grid
    axis([-vsize vsize -vsize vsize 0 vsize]);
    
     hold on
     set(cal,'visible','off')
    if get(checkbox,'value')==0
        
     for t=0:1:90
    T1=tmat( 90,0 ,0,0);
    %T2=tmat(0,0,0,0);
    T3=tmat2(0,40,0);
    T4=rx(0)*ry(t)*rz(0);%
    T5=tmat2(-7.5,22,0);
    T6=rx(t)*ry(90)*rz(0);%
    T7=tmat2(75,0,0);
    T8=rx(0)*ry(0)*rz(t);
    %T9=tmat2(0,0,30);
    T10=tmat2(55,-2,7.5);
    T11=rx(-90)*ry(.7*t)*rz(90);
    T12=tmat2(0,0,0);
    T13=rx(-90)*ry(0)*rz(0);
   % T14=tmat2(2.5,-10,0);
    T14=tmat2(0,-2.5,-5);
    T15=tmat2(0,0,-40);
    T16=rx(0)*ry(500*t)*rz(0);
    
    
    %T5=tmat(90,0,40,0);
    %T6=tmat(0,0,0,0);
    nv1=T1*vout1;
   set(p1,'Vertices',nv1(1:3,:)');
   nv2=T1*T3*T4*vout2;
   set(p2,'Vertices',nv2(1:3,:)');
   nv3=T1*T3*T4*T5*T6*vout3;
   set(p3,'Vertices',nv3(1:3,:)');
   nv4=T1*T3*T4*T5*T6*T7*T8*vout4;
   set(p4,'Vertices',nv4(1:3,:)');
   nv5=T1*T3*T4*T5*T6*T7*T8*T10*T11*vout5;
   set(p5,'Vertices',nv5(1:3,:)');
   nv6=T1*T3*T4*T5*T6*T7*T8*T10*T11*T12*T13*T14*vout6;
   set(p6,'Vertices',nv6(1:3,:)');
   nv7=T1*T3*T4*T5*T6*T7*T8*T10*T11*T12*T13*T14*T15*T16*vout7;
   if rem(t,2)==0
   set(p7,'Vertices',nv7(1:3,:)');
   elseif rem(t,2)==1
       set(p7,'Vertices',[0 0 0]);
   end
   
   drawnow
   rotate3d
   
   TT=T1*T3*T4*T5*T6*T7*T8*T10*T11*T12*T13*T14*T15*T16;
   x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
   
     end
      elseif get(checkbox,'value')==1
        
        
        
            
        for t= str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string')) ;
            
        
    T1=tmat( 90,0 ,0,0);
    %T2=tmat(0,0,0,0);
    T3=tmat2(0,40,0);
    T4=rx(0)*ry(fj1(t))*rz(0);%
    T5=tmat2(-7.5,22,0);
    T6=rx(fj2(t))*ry(90)*rz(0);%
   % T6=rx(90)*ry(90)*rz(0);%
    T7=tmat2(75,0,0);
    T8=rx(0)*ry(0)*rz(fj3(t));
    %T8=rx(0)*ry(0)*rz(0);
    %T9=tmat2(0,0,30);
    T10=tmat2(55,-2,7.5);
    T11=rx(-90)*ry(.7*t)*rz(90);
    T12=tmat2(0,0,0);
    T13=rx(-90)*ry(0)*rz(0);
   % T14=tmat2(2.5,-10,0);
    T14=tmat2(0,-2.5,-5);
    T15=tmat2(0,0,-40);
    T16=rx(0)*ry(500*t)*rz(0);
    
    
    %T5=tmat(90,0,40,0);
    %T6=tmat(0,0,0,0);
    nv1=T1*vout1;
   set(p1,'Vertices',nv1(1:3,:)');
   nv2=T1*T3*T4*vout2;
   set(p2,'Vertices',nv2(1:3,:)');
   nv3=T1*T3*T4*T5*T6*vout3;
   set(p3,'Vertices',nv3(1:3,:)');
   nv4=T1*T3*T4*T5*T6*T7*T8*vout4;
   set(p4,'Vertices',nv4(1:3,:)');
   nv5=T1*T3*T4*T5*T6*T7*T8*T10*T11*vout5;
   set(p5,'Vertices',nv5(1:3,:)');
   nv6=T1*T3*T4*T5*T6*T7*T8*T10*T11*T12*T13*T14*vout6;
   set(p6,'Vertices',nv6(1:3,:)');
   nv7=T1*T3*T4*T5*T6*T7*T8*T10*T11*T12*T13*T14*T15*T16*vout7;
   if rem(t,2)==0
   set(p7,'Vertices',nv7(1:3,:)');
   elseif rem(t,2)==1
       set(p7,'Vertices',[0 0 0]);
   end
   
   drawnow
   rotate3d
   
   TT=T1*T3*T4*T5*T6*T7*T8*T10*T11*T12*T13*T14*T15*T16;
   x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
     
    end

    end
    set(p7,'Vertices',[0 0 0]);
        end
end

function rrpw(varargin)
        
        set(joint1_movs,'string','joint1 angle')
        set(joint2_movs,'string','joint2 angle')
        set(joint3_movs,'string','joint3 displ.')
        
        fj1=inline(get(joint1_mov,'string'));
        fj2=inline(get(joint2_mov,'string'));
        fj3=inline(get(joint3_mov,'string'));
        err1=0;
        direction=1;
     
        if str2double(get(Tstart,'string')) > str2double(get(Tend,'string'))
           direction=-1 ;
        end
        t_test= str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string')) ;
      
        
        
        if get(checkbox,'value')==1
            
        if max(fj1(t_test))> 400 || min(fj1(t_test))< -500
            set(err,'string','please check theta 1 limit','visible','on')
           set(hint,'string','use start=0, T end=90, j1=t, j2=t, j3=sin(t/4) ','visible','on')
            err1=1;
        end
        if max(fj2(t_test))> 180 || min(fj2(t_test))< 0
            set(err,'string','please check theta 2 limit','visible','on')
             set(hint,'string','use start=0, T end=90, j1=t, j2=t, j3=sin(t/4) ','visible','on')
            err1=1;
        end
        if max(fj3(t_test))> 1 || min(fj3(t_test))< -1
            set(err,'string','please check theta 3 limit','visible','on')
          set(hint,'string','use start=0, T end=90, j1=t, j2=t, j3=sin(t/4) ','visible','on')
            err1=1;
        end
        end

        if err1==1;
            return
        else
        
        
        [fout1, vout1, cout1] = rndread('base.slp');
        [fout2, vout2, cout2] = rndread('j1.slp');
        [fout3, vout3, cout3] = rndread('j5.slp');
        [fout4, vout4, cout4] = rndread('j10.slp');
        [fout5, vout5, cout5] = rndread('j11.slp');
        [fout6, vout6, cout6] = rndread('j12.slp');
        [fout7, vout7, cout7] = rndread('e1.slp');
        [fout8, vout8, cout8] = rndread('e4.slp');
        [fout9, vout9, cout9] = rndread('e5.slp');
       
        p1 = patch('faces', fout1, 'vertices' ,vout1);
        p2 = patch('faces', fout2, 'vertices' ,vout2);
        p3 = patch('faces', fout3, 'vertices' ,vout3);
        p4 = patch('faces', fout4, 'vertices' ,vout4);
        p5 = patch('faces', fout5, 'vertices' ,vout5);
        p6 = patch('faces', fout6, 'vertices' ,vout6);
        p7 = patch('faces', fout7, 'vertices' ,vout7);
        p8 = patch('faces', fout8, 'vertices' ,vout8);
        p9 = patch('faces', fout9, 'vertices' ,vout9);
        set(p1, 'facec', 'flat');
        set(p2, 'facec', 'flat');
        set(p3, 'facec', 'flat');
        set(p4, 'facec', 'flat');
        set(p5, 'facec', 'flat');
        set(p6, 'facec', 'flat');
        set(p7, 'facec', 'flat');
        set(p8, 'facec', 'flat');
        set(p9, 'facec', 'flat');
%        set(p3, 'facec', 'flat');
    
         set(p1, 'FaceVertexCData', cout1); 
      set(p2, 'FaceVertexCData', cout2); 
      set(p3, 'FaceVertexCData', cout3);
      set(p4, 'FaceVertexCData', cout4);
      set(p5, 'FaceVertexCData', cout5);
      set(p6, 'FaceVertexCData', cout6);
      set(p7, 'FaceVertexCData', cout7);
      set(p8, 'FaceVertexCData', cout8);
      set(p9, 'FaceVertexCData', cout9);
   %  set(p3, 'FaceVertexCData', cout3); 
    
    set(p1, 'EdgeColor','none'); 
    set(p2, 'EdgeColor','none'); 
    set(p3, 'EdgeColor','none'); 
    set(p4, 'EdgeColor','none'); 
    set(p5, 'EdgeColor','none'); 
    set(p6, 'EdgeColor','none'); 
    set(p7, 'EdgeColor','none'); 
    set(p8, 'EdgeColor','none'); 
    set(p9, 'EdgeColor','none'); 
   % set(p3, 'EdgeColor','none');
    
    light                               % add a default light
    daspect([1 1 1])                    % Setting the aspect ratio
    view(3)                             % Isometric view
    xlabel('X'),ylabel('Y'),zlabel('Z')
    title(['KK  BH2 '])
    
    vout1 = vout1';
    vout1 = [vout1(1,:); vout1(2,:); vout1(3,:); ones(1,length(vout1))];
   
   vout2 = vout2';
    vout2 = [vout2(1,:); vout2(2,:); vout2(3,:); ones(1,length(vout2))];
    
    vout3 = vout3';
    vout3 = [vout3(1,:); vout3(2,:); vout3(3,:); ones(1,length(vout3))];
    vout4=vout4*1.2;
    vout4 = vout4';
    vout4 = [vout4(1,:); vout4(2,:); vout4(3,:); ones(1,length(vout4))];
    
    vout5 = vout5';
    vout5 = [vout5(1,:); vout5(2,:); vout5(3,:); ones(1,length(vout5))];
    
    vout6 = vout6';
    vout6 = [vout6(1,:); vout6(2,:); vout6(3,:); ones(1,length(vout6))];
    vout7=vout7*1.5;
    vout8=vout8*4;
    vout9=vout9*40;
    vout7 = vout7';
    vout7= [vout7(1,:); vout7(2,:); vout7(3,:); ones(1,length(vout7))];
    
    vout8 = vout8';
    vout8 = [vout8(1,:); vout8(2,:); vout8(3,:); ones(1,length(vout8))];
    
    vout9 = vout9';
    vout9 = [vout9(1,:); vout9(2,:); vout9(3,:); ones(1,length(vout9))];
    
    
    vsize =150; % or can be changed 
    grid
    axis([-vsize vsize -vsize vsize 0 vsize]);
    
    hold on
    set(cal,'visible','off')
    if get(checkbox,'value')==0
        
     for t=0:0.5:90
    T1=tmat( 90,0 ,0,0);
    T2=tmat(0,0,0,0);
    T3=tmat2(0,40,0);
    T4=rx(0)*ry(t)*rz(0);
    T5=tmat2(-7.5,22,0);
    T6=rx(t)*ry(90)*rz(0);
    T7=tmat2(75,0,0);
    T8=rx(0)*ry(0)*rz(-20);
    T9=tmat2(0,-5,-1);
    T12=rx(0)*ry(0)*rz(-70);
    T10=tmat2(0,10*sin(0.05*t)+10,7.5);
    %T10=tmat2(0,10,7.5);
    T11=tmat2(0,30,0);
    T13=rx(0)*ry(90)*rx(180);
    T14=tmat2(0,-7.5,-3);
    T19=rx(0)*ry(0)*rx(t);
    T15=tmat2(0,-7.5,2.2);
    T16=rx(-90)*ry(0)*rz(0);
    T17=tmat2(0,0,-35);
    T18=rx(0)*ry(100*t)*rz(0);
    T20=rx(0)*ry(0)*rz(0);
    %T5=tmat(90,0,40,0);
    %T6=tmat(0,0,0,0);
    nv1=T1*vout1;
   set(p1,'Vertices',nv1(1:3,:)');
   nv2=T1*T3*T4*vout2;
   set(p2,'Vertices',nv2(1:3,:)');
   nv3=T1*T3*T4*T5*T6*vout3;
   set(p3,'Vertices',nv3(1:3,:)');
   nv4=T1*T3*T4*T5*T6*T7*T8*T12*T9*vout4;
   set(p4,'Vertices',nv4(1:3,:)');
   nv5=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*vout5;
   set(p5,'Vertices',nv5(1:3,:)');
   nv6=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*T11*vout6;
   set(p6,'Vertices',nv6(1:3,:)');
   nv7=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*T11*T13*T14*T19*vout7;
   set(p7,'Vertices',nv7(1:3,:)');
   nv8=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*T11*T13*T14*T19*T15*T16*T20*vout8;
   set(p8,'Vertices',nv8(1:3,:)');
   nv9=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*T11*T13*T14*T19*T15*T16*T20*T17*T18*vout9;
   if rem(t,2)==0
   set(p9,'Vertices',nv9(1:3,:)');
   elseif rem(t,2)==1
       set(p9,'Vertices',[0 0 0]);
   end
   
   drawnow
   rotate3d
    TT=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*T11*T13*T14*T19*T15*T16*T20*T17*T18;
        x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
     end
    elseif get(checkbox,'value')==1
    
                for t=str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string'))
                    
        T1=tmat( 90,0 ,0,0);
    T2=tmat(0,0,0,0);
    T3=tmat2(0,40,0);
    T4=rx(0)*ry(fj1(t))*rz(0);
    T5=tmat2(-7.5,22,0);
    T6=rx(fj2(t))*ry(90)*rz(0);
    T7=tmat2(75,0,0);
    T8=rx(0)*ry(0)*rz(-20);
    T9=tmat2(0,-5,-1);
    T12=rx(0)*ry(0)*rz(-70);
    T10=tmat2(0,10*fj3(t)+10,7.5);
    %T10=tmat2(0,10,7.5);
    T11=tmat2(0,30,0);
    T13=rx(0)*ry(90)*rx(180);
    T14=tmat2(0,-7.5,-3);
    T19=rx(0)*ry(0)*rx(t);
    T15=tmat2(0,-7.5,2.2);
    T16=rx(-90)*ry(0)*rz(0);
    T17=tmat2(0,0,-35);
    T18=rx(0)*ry(100*t)*rz(0);
    T20=rx(0)*ry(0)*rz(0);
    %T5=tmat(90,0,40,0);
    %T6=tmat(0,0,0,0);
    nv1=T1*vout1;
   set(p1,'Vertices',nv1(1:3,:)');
   nv2=T1*T3*T4*vout2;
   set(p2,'Vertices',nv2(1:3,:)');
   nv3=T1*T3*T4*T5*T6*vout3;
   set(p3,'Vertices',nv3(1:3,:)');
   nv4=T1*T3*T4*T5*T6*T7*T8*T12*T9*vout4;
   set(p4,'Vertices',nv4(1:3,:)');
   nv5=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*vout5;
   set(p5,'Vertices',nv5(1:3,:)');
   nv6=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*T11*vout6;
   set(p6,'Vertices',nv6(1:3,:)');
   nv7=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*T11*T13*T14*T19*vout7;
   set(p7,'Vertices',nv7(1:3,:)');
   nv8=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*T11*T13*T14*T19*T15*T16*T20*vout8;
   set(p8,'Vertices',nv8(1:3,:)');
   nv9=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*T11*T13*T14*T19*T15*T16*T20*T17*T18*vout9;
   if rem(t,2)==0
   set(p9,'Vertices',nv9(1:3,:)');
   elseif rem(t,2)==1
       set(p9,'Vertices',[0 0 0]);
   end
   
   drawnow
   rotate3d
        TT=T1*T3*T4*T5*T6*T7*T8*T12*T9*T10*T11*T13*T14*T19*T15*T16*T20*T17*T18;
        x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
        
    end
        end
    set(p9,'Vertices',[0 0 0]);
        end
end

    function rprw(varargin)
        
        set(joint1_movs,'string','joint1 angle')
        set(joint2_movs,'string','joint2 displ.')
        set(joint3_movs,'string','joint3 angle')
        
        fj1=inline(get(joint1_mov,'string'));
        fj2=inline(get(joint2_mov,'string'));
        fj3=inline(get(joint3_mov,'string'));
        err1=0;
        direction=1;
     
        if str2double(get(Tstart,'string')) > str2double(get(Tend,'string'))
           direction=-1 ;
        end
        t_test= str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string')) ;
      
        
        
        if get(checkbox,'value')==1
            
        if max(fj1(t_test))> 400 || min(fj1(t_test))< -500
            set(err,'string','please check theta 1 limit','visible','on')
           set(hint,'string','use start=0, T end=90, j1=t, j2=sin(t/4), j3=t ','visible','on')
            err1=1;
        end
        if max(fj2(t_test))>= 1 || min(fj2(t_test))<= -1
            set(err,'string','please check theta 2 limit','visible','on')
             set(hint,'string','use start=0, T end=90, j1=t, j2=sin(t/4), j3=t ','visible','on')
            err1=1;
        end
        if max(fj3(t_test))> 90 || min(fj3(t_test))< -90
            set(err,'string','please check theta 3 limit','visible','on')
          set(hint,'string','use start=0, T end=90, j1=t, j2=sin(t/4), j3=t) ','visible','on')
            err1=1;
        end
        end

        if err1==1;
            return
        else
           
            
        
        [fout1, vout1, cout1] = rndread('base.slp');
        [fout2, vout2, cout2] = rndread('j1.slp');
        [fout3, vout3, cout3] = rndread('j7.slp');
        [fout4, vout4, cout4] = rndread('j8.slp');
        [fout5, vout5, cout5] = rndread('j9.slp');
        [fout6, vout6, cout6] = rndread('j6.slp');
        [fout7, vout7, cout7] = rndread('e1.slp');
        [fout8, vout8, cout8] = rndread('e4.slp');
        [fout9, vout9, cout9] = rndread('e5.slp');
       
        p1 = patch('faces', fout1, 'vertices' ,vout1);
        p2 = patch('faces', fout2, 'vertices' ,vout2);
        p3 = patch('faces', fout3, 'vertices' ,vout3);
        p4 = patch('faces', fout4, 'vertices' ,vout4);
        p5 = patch('faces', fout5, 'vertices' ,vout5);
        p6 = patch('faces', fout6, 'vertices' ,vout6);
        p7 = patch('faces', fout7, 'vertices' ,vout7);
        p8 = patch('faces', fout8, 'vertices' ,vout8);
        p9 = patch('faces', fout9, 'vertices' ,vout9);
        set(p1, 'facec', 'flat');
        set(p2, 'facec', 'flat');
        set(p3, 'facec', 'flat');
        set(p4, 'facec', 'flat');
        set(p5, 'facec', 'flat');
        set(p6, 'facec', 'flat');
        set(p7, 'facec', 'flat');
        set(p8, 'facec', 'flat');
        set(p9, 'facec', 'flat');
%        set(p3, 'facec', 'flat');
    
         set(p1, 'FaceVertexCData', cout1); 
      set(p2, 'FaceVertexCData', cout2); 
      set(p3, 'FaceVertexCData', cout3);
      set(p4, 'FaceVertexCData', cout4);
      set(p5, 'FaceVertexCData', cout5);
      set(p6, 'FaceVertexCData', cout6);
      set(p7, 'FaceVertexCData', cout7);
      set(p8, 'FaceVertexCData', cout8);
      set(p9, 'FaceVertexCData', cout9);
   %  set(p3, 'FaceVertexCData', cout3); 
    
    set(p1, 'EdgeColor','none'); 
    set(p2, 'EdgeColor','none'); 
    set(p3, 'EdgeColor','none'); 
    set(p4, 'EdgeColor','none'); 
    set(p5, 'EdgeColor','none'); 
    set(p6, 'EdgeColor','none');
    set(p7, 'EdgeColor','none'); 
    set(p8, 'EdgeColor','none'); 
    set(p9, 'EdgeColor','none');
   % set(p3, 'EdgeColor','none');
    
    light                               % add a default light
    daspect([1 1 1])                    % Setting the aspect ratio
    view(3)                             % Isometric view
    xlabel('X'),ylabel('Y'),zlabel('Z')
    title(['KK  BH2 '])
    
    vout1 = vout1';
    vout1 = [vout1(1,:); vout1(2,:); vout1(3,:); ones(1,length(vout1))];
   
   vout2 = vout2';
    vout2 = [vout2(1,:); vout2(2,:); vout2(3,:); ones(1,length(vout2))];
    vout3=vout3*1.4;
    vout3 = vout3';
    vout3 = [vout3(1,:); vout3(2,:); vout3(3,:); ones(1,length(vout3))];
    
    vout4 = vout4';
    vout4 = [vout4(1,:); vout4(2,:); vout4(3,:); ones(1,length(vout4))];
    vout5=vout5*1.2;
    vout5 = vout5';
    vout5 = [vout5(1,:); vout5(2,:); vout5(3,:); ones(1,length(vout5))];
    
    vout6 = vout6';
    vout6 = [vout6(1,:); vout6(2,:); vout6(3,:); ones(1,length(vout6))];
    
    vout7=vout7*1.5;
    vout8=vout8*4;
    vout9=vout9*40;
    vout7 = vout7';
    vout7= [vout7(1,:); vout7(2,:); vout7(3,:); ones(1,length(vout7))];
    
    vout8 = vout8';
    vout8 = [vout8(1,:); vout8(2,:); vout8(3,:); ones(1,length(vout8))];
    
    vout9 = vout9';
    vout9 = [vout9(1,:); vout9(2,:); vout9(3,:); ones(1,length(vout9))];
        
        vsize =150; % or can be changed 
    grid
    axis([-vsize vsize -vsize vsize 0 vsize]);
    
    hold on
    set(cal,'visible','off')
    if get(checkbox,'value')==0
        
     for t=0:1:90
    T1=tmat( 90,0 ,0,0);
   % T2=tmat(0,0,0,0);
    T3=tmat2(0,40,0);
    T4=rx(0)*ry(t)*rz(0);
    T5=tmat2(10,0,-10);
    T6=rx(0)*ry(90)*rz(90);
    T8=rx(0)*ry(0)*rz(90);
    %T7=tmat2(20*sin(0.05*t)+65,55,-103.5);
    T7=tmat2(80+15*sin(0.2*t),10,-10);
   %T7=tmat2(70,55,-103.5);
    T9=rx(180)*ry(0)*rz(0);
    T11=tmat2(0,7.5,-7.5);
    T10=rx(0)*ry(0)*rz(0.5*t);
    T12=tmat2(53,2,7.5);
    T14=rx(90)*ry(0.5*t)*rz(90);
    T15=tmat2(0,-7.5,2.2);
    T16=rx(-90)*ry(0)*rz(0);
    T19=rx(-0.2*t)*ry(0)*rz(0);
    T17=tmat2(0,0,-35);
    T18=rx(0)*ry(100*t)*rz(0);
    
    
    %T5=tmat(90,0,40,0);
    %T6=tmat(0,0,0,0);
    nv1=T1*vout1;
   set(p1,'Vertices',nv1(1:3,:)');
   nv2=T1*T3*T4*vout2;
   set(p2,'Vertices',nv2(1:3,:)');
   nv3=T1*T3*T4*T6*T5*vout3;
   set(p3,'Vertices',nv3(1:3,:)');
   nv4=T1*T3*T4*T5*T6*T7*T8*vout4;
   set(p4,'Vertices',nv4(1:3,:)');
   nv5=T1*T3*T4*T5*T6*T7*T8*T9*vout5;
   set(p5,'Vertices',nv5(1:3,:)');
   nv6=T1*T3*T4*T5*T6*T7*T8*T9*T11*T10*vout6;
   set(p6,'Vertices',nv6(1:3,:)');
   nv7=T1*T3*T4*T5*T6*T7*T8*T9*T11*T10*T12*T14*vout7;
   set(p7,'Vertices',nv7(1:3,:)');
   nv8=T1*T3*T4*T5*T6*T7*T8*T9*T11*T10*T12*T14*T15*T16*T19*vout8;
   set(p8,'Vertices',nv8(1:3,:)');
   nv9=T1*T3*T4*T5*T6*T7*T8*T9*T11*T10*T12*T14*T15*T16*T19*T17*T18*vout9;
   if rem(t,2)==0
   set(p9,'Vertices',nv9(1:3,:)');
   elseif rem(t,2)==1
       set(p9,'Vertices',[0 0 0])
   end
   
   drawnow
   rotate3d
   TT=T1*T3*T4*T5*T6*T7*T8*T9*T11*T10*T12*T14*T15*T16*T19*T17*T18;
     x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
     end
   
   elseif get(checkbox,'value')==1
       
     for t=str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string'))
       T1=tmat( 90,0 ,0,0);
   % T2=tmat(0,0,0,0);
    T3=tmat2(0,40,0);
    T4=rx(0)*ry(fj1(t))*rz(0);
    T5=tmat2(10,0,-10);
    T6=rx(0)*ry(90)*rz(90);
    T8=rx(0)*ry(0)*rz(90);
    %T7=tmat2(20*sin(0.05*t)+65,55,-103.5);
    T7=tmat2(80+15*fj2(t),10,-10);
   %T7=tmat2(70,55,-103.5);
    T9=rx(180)*ry(0)*rz(0);
    T11=tmat2(0,7.5,-7.5);
    T10=rx(0)*ry(0)*rz(fj3(t));
    T12=tmat2(53,2,7.5);
    T14=rx(90)*ry(0.5*t)*rz(90);
    T15=tmat2(0,-7.5,2.2);
    T16=rx(-90)*ry(0)*rz(0);
    T19=rx(-0.2*t)*ry(0)*rz(0);
    T17=tmat2(0,0,-35);
    T18=rx(0)*ry(100*t)*rz(0);
    
    
    %T5=tmat(90,0,40,0);
    %T6=tmat(0,0,0,0);
    nv1=T1*vout1;
   set(p1,'Vertices',nv1(1:3,:)');
   nv2=T1*T3*T4*vout2;
   set(p2,'Vertices',nv2(1:3,:)');
   nv3=T1*T3*T4*T6*T5*vout3;
   set(p3,'Vertices',nv3(1:3,:)');
   nv4=T1*T3*T4*T5*T6*T7*T8*vout4;
   set(p4,'Vertices',nv4(1:3,:)');
   nv5=T1*T3*T4*T5*T6*T7*T8*T9*vout5;
   set(p5,'Vertices',nv5(1:3,:)');
   nv6=T1*T3*T4*T5*T6*T7*T8*T9*T11*T10*vout6;
   set(p6,'Vertices',nv6(1:3,:)');
   nv7=T1*T3*T4*T5*T6*T7*T8*T9*T11*T10*T12*T14*vout7;
   set(p7,'Vertices',nv7(1:3,:)');
   nv8=T1*T3*T4*T5*T6*T7*T8*T9*T11*T10*T12*T14*T15*T16*T19*vout8;
   set(p8,'Vertices',nv8(1:3,:)');
   nv9=T1*T3*T4*T5*T6*T7*T8*T9*T11*T10*T12*T14*T15*T16*T19*T17*T18*vout9;
   if rem(t,2)==0
   set(p9,'Vertices',nv9(1:3,:)');
   elseif rem(t,2)==1
       set(p9,'Vertices',[0 0 0])
   end
   
   drawnow
   rotate3d
   TT=T1*T3*T4*T5*T6*T7*T8*T9*T11*T10*T12*T14*T15*T16*T19*T17*T18;
     x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
       
     end

    end
      set(p9,'Vertices',[0 0 0])
    end
   
    
    end

    function rppw(varargin)
        
        set(joint1_movs,'string','joint1 angle')
        set(joint2_movs,'string','joint2 displ.')
        set(joint3_movs,'string','joint3 displ.')
        
        fj1=inline(get(joint1_mov,'string'));
        fj2=inline(get(joint2_mov,'string'));
        fj3=inline(get(joint3_mov,'string'));
        err1=0;
        direction=1;
     
        if str2double(get(Tstart,'string')) > str2double(get(Tend,'string'))
           direction=-1 ;
        end
        t_test= str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string')) ;
      
        
        
        if get(checkbox,'value')==1
            
        if max(fj1(t_test))> 400 || min(fj1(t_test))< -500
            set(err,'string','please check theta 1 limit','visible','on')
           set(hint,'string','use start=0, T end=90, j1=t, j2=cos(t/5), j3=sin(t/4) ','visible','on')
            err1=1;
        end
        if max(fj2(t_test))>1 || min(fj2(t_test))<-1
            set(err,'string','please check theta 2 limit','visible','on')
             set(hint,'string','use start=0, T end=90, j1=t, j2=cos(t/5), j3=sin(t/4) ','visible','on')
            err1=1;
        end
        if max(fj3(t_test))> 1 || min(fj3(t_test))< -1
            set(err,'string','please check theta 3 limit','visible','on')
          set(hint,'string','use start=0, T end=90, j1=t, j2=cos(t/5), j3=sin(t/4) ','visible','on')
            err1=1;
        end
        end

        if err1==1;
            return
        else
            
        
        [fout1, vout1, cout1] = rndread('base.slp');
        [fout2, vout2, cout2] = rndread('j1.slp');
        [fout3, vout3, cout3] = rndread('j7.slp');
        [fout4, vout4, cout4] = rndread('j8.slp');
%         [fout5, vout5, cout5] = rndread('j9.slp');
        [fout6, vout6, cout6] = rndread('j10.slp');
        [fout7, vout7, cout7] = rndread('j11.slp');
        [fout8, vout8, cout8] = rndread('j12.slp');
        [fout9, vout9, cout9] = rndread('e1.slp');
        [fout10, vout10, cout10] = rndread('e4.slp');
        [fout11, vout11, cout11] = rndread('e5.slp');
       
        p1 = patch('faces', fout1, 'vertices' ,vout1);
        p2 = patch('faces', fout2, 'vertices' ,vout2);
        p3 = patch('faces', fout3, 'vertices' ,vout3);
        p4 = patch('faces', fout4, 'vertices' ,vout4);
%         p5 = patch('faces', fout5, 'vertices' ,vout5);
        p6 = patch('faces', fout6, 'vertices' ,vout6);
        p7 = patch('faces', fout7, 'vertices' ,vout7);
        p8 = patch('faces', fout8, 'vertices' ,vout8);
        p9 = patch('faces', fout9, 'vertices' ,vout9);
        p10 = patch('faces', fout10, 'vertices' ,vout10);
        p11 = patch('faces', fout11, 'vertices' ,vout11);
        set(p1, 'facec', 'flat');
        set(p2, 'facec', 'flat');
        set(p3, 'facec', 'flat');
        set(p4, 'facec', 'flat');
%         set(p5, 'facec', 'flat');
        set(p6, 'facec', 'flat');
        set(p7, 'facec', 'flat');
        set(p8, 'facec', 'flat');
        set(p9, 'facec', 'flat');
        set(p10, 'facec', 'flat');
        set(p11, 'facec', 'flat');
%        set(p3, 'facec', 'flat');
    
         set(p1, 'FaceVertexCData', cout1); 
      set(p2, 'FaceVertexCData', cout2); 
      set(p3, 'FaceVertexCData', cout3);
      set(p4, 'FaceVertexCData', cout4);
%       set(p5, 'FaceVertexCData', cout5);
      set(p6, 'FaceVertexCData', cout6);
      set(p7, 'FaceVertexCData', cout7);
      set(p8, 'FaceVertexCData', cout8);
      set(p9, 'FaceVertexCData', cout9);
      set(p10, 'FaceVertexCData', cout10);
      set(p11, 'FaceVertexCData', cout11);
   %  set(p3, 'FaceVertexCData', cout3); 
    
    set(p1, 'EdgeColor','none'); 
    set(p2, 'EdgeColor','none'); 
    set(p3, 'EdgeColor','none'); 
    set(p4, 'EdgeColor','none'); 
%     set(p5, 'EdgeColor','none'); 
    set(p6, 'EdgeColor','none'); 
    set(p7, 'EdgeColor','none'); 
    set(p8, 'EdgeColor','none');
    set(p9, 'EdgeColor','none'); 
    set(p10, 'EdgeColor','none'); 
    set(p11, 'EdgeColor','none');
   % set(p3, 'EdgeColor','none');
    
    light                               % add a default light
    daspect([1 1 1])                    % Setting the aspect ratio
    view(3)                             % Isometric view
    xlabel('X'),ylabel('Y'),zlabel('Z')
    title(['KK  BH2 '])
    
    vout1 = vout1';
    vout1 = [vout1(1,:); vout1(2,:); vout1(3,:); ones(1,length(vout1))];
   
   vout2 = vout2';
    vout2 = [vout2(1,:); vout2(2,:); vout2(3,:); ones(1,length(vout2))];
    vout3=vout3*1.4;
    vout3 = vout3';
    vout3 = [vout3(1,:); vout3(2,:); vout3(3,:); ones(1,length(vout3))];
    
    vout4 = vout4';
    vout4 = [vout4(1,:); vout4(2,:); vout4(3,:); ones(1,length(vout4))];
    
%     vout5 = vout5';
%     vout5 = [vout5(1,:); vout5(2,:); vout5(3,:); ones(1,length(vout5))];
%     
    vout6 = vout6';
    vout6 = [vout6(1,:); vout6(2,:); vout6(3,:); ones(1,length(vout6))];
    
    vout7 = vout7';
    vout7 = [vout7(1,:); vout7(2,:); vout7(3,:); ones(1,length(vout7))];
    
    vout8 = vout8';
    vout8 = [vout8(1,:); vout8(2,:); vout8(3,:); ones(1,length(vout8))];
    
    vout10=vout10*4;
    vout11=vout11*40;
    vout9=vout9*1.3;
    vout9 = vout9';
    vout9 = [vout9(1,:); vout9(2,:); vout9(3,:); ones(1,length(vout9))];
    
    vout10 = vout10';
    vout10 = [vout10(1,:); vout10(2,:); vout10(3,:); ones(1,length(vout10))];
    
    vout11 = vout11';
    vout11 = [vout11(1,:); vout11(2,:); vout11(3,:); ones(1,length(vout11))];
        
    
    grid
    vsize =150; % or can be changed 
    axis([-vsize vsize -vsize vsize 0 vsize]);
    
    hold on 
    set(cal,'visible','off')
    if get(checkbox,'value')==0
        
        
     for t=0:2:180
    T1=tmat( 90,0 ,0,0);
   % T2=tmat(0,0,0,0);
    T3=tmat2(0,40,0);
    T4=rx(0)*ry(t)*rz(0);
    T5=tmat2(10,0,-10);
    T6=rx(0)*ry(90)*rz(90);
    T7=rx(0)*ry(0)*rz(90);
    T8=tmat2(0,15*sin(0.05*t)-70,10);
    T9=tmat2(0,-20,-7.5);
    T10=rx(90)*ry(0)*rz(0);
    T11=tmat2(0,-20+4.9*sin(t*.3),-10);
    T12=rx(180)*ry(0)*rz(0);
    T13=tmat2(-2,8,0);
    T14=rx(0)*ry(90)*rz(180);
    T15=tmat2(0,-7.5,2.2);
    T16=rx(-90)*ry(0)*rz(0);
    T19=rx(0)*ry(0)*rz(0);
    T17=tmat2(0,0,-35);
    T18=rx(0)*ry(100*t)*rz(0);
    
    
    %T5=tmat(90,0,40,0);
    %T6=tmat(0,0,0,0);
    nv1=T1*vout1;
   set(p1,'Vertices',nv1(1:3,:)');
   nv2=T1*T3*T4*vout2;
   set(p2,'Vertices',nv2(1:3,:)');
   nv3=T1*T3*T4*T6*T5*vout3;
   set(p3,'Vertices',nv3(1:3,:)');
   nv4=T1*T3*T4*T6*T5*T7*T8*vout4;
   set(p4,'Vertices',nv4(1:3,:)');
   nv6=T1*T3*T4*T6*T5*T7*T8*T9*vout6;
   set(p6,'Vertices',nv6(1:3,:)');
   nv7=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*vout7;
   set(p7,'Vertices',nv7(1:3,:)');
   nv8=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*T12*vout8;
   set(p8,'Vertices',nv8(1:3,:)');
   nv9=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*T12*T13*T14*vout9;
   set(p9,'Vertices',nv9(1:3,:)');
   nv10=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*vout10;
   set(p10,'Vertices',nv10(1:3,:)');
   nv11=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*T19*T17*T18*vout11;
   if rem(t/2,2)==0
   set(p11,'Vertices',nv11(1:3,:)');
   elseif  rem(t/2,2)==1
       set(p11,'Vertices',[0 0 0]);
   end 
   
   drawnow
   rotate3d
   TT=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*T19*T17*T18;
   x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
     end
      elseif get(checkbox,'value')==1
          
               for t=str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string'))
          T1=tmat( 90,0 ,0,0);
   % T2=tmat(0,0,0,0);
    T3=tmat2(0,40,0);
    T4=rx(0)*ry(fj1(t))*rz(0);
    T5=tmat2(10,0,-10);
    T6=rx(0)*ry(90)*rz(90);
    T7=rx(0)*ry(0)*rz(90);
    T8=tmat2(0,15*fj2(t)-70,10);
    T9=tmat2(0,-20,-7.5);
    T10=rx(90)*ry(0)*rz(0);
    T11=tmat2(0,-20+4.9*fj3(t),-10);
    T12=rx(180)*ry(0)*rz(0);
    T13=tmat2(-2,8,0);
    T14=rx(0)*ry(90)*rz(180);
    T15=tmat2(0,-7.5,2.2);
    T16=rx(-90)*ry(0)*rz(0);
    T19=rx(0)*ry(0)*rz(0);
    T17=tmat2(0,0,-35);
    T18=rx(0)*ry(100*t)*rz(0);
    
    
    %T5=tmat(90,0,40,0);
    %T6=tmat(0,0,0,0);
    nv1=T1*vout1;
   set(p1,'Vertices',nv1(1:3,:)');
   nv2=T1*T3*T4*vout2;
   set(p2,'Vertices',nv2(1:3,:)');
   nv3=T1*T3*T4*T6*T5*vout3;
   set(p3,'Vertices',nv3(1:3,:)');
   nv4=T1*T3*T4*T6*T5*T7*T8*vout4;
   set(p4,'Vertices',nv4(1:3,:)');
   nv6=T1*T3*T4*T6*T5*T7*T8*T9*vout6;
   set(p6,'Vertices',nv6(1:3,:)');
   nv7=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*vout7;
   set(p7,'Vertices',nv7(1:3,:)');
   nv8=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*T12*vout8;
   set(p8,'Vertices',nv8(1:3,:)');
   nv9=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*T12*T13*T14*vout9;
   set(p9,'Vertices',nv9(1:3,:)');
   nv10=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*vout10;
   set(p10,'Vertices',nv10(1:3,:)');
   nv11=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*T19*T17*T18*vout11;
   if rem(t/2,2)==0
   set(p11,'Vertices',nv11(1:3,:)');
   elseif  rem(t/2,2)==1
       set(p11,'Vertices',[0 0 0]);
   end 
   
   drawnow
   rotate3d
   TT=T1*T3*T4*T6*T5*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*T19*T17*T18;
   x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
          
          
          
     end

    
    
    end
    set(p11,'Vertices',[0 0 0]);
        end
        
    end


    function prrw(varargin)
        
        
        set(joint1_movs,'string','joint1 displ.')
        set(joint2_movs,'string','joint2 angle')
        set(joint3_movs,'string','joint3 angle')
        
        fj1=inline(get(joint1_mov,'string'));
        fj2=inline(get(joint2_mov,'string'));
        fj3=inline(get(joint3_mov,'string'));
        err1=0;
        direction=1;
     
        if str2double(get(Tstart,'string')) > str2double(get(Tend,'string'))
           direction=-1 ;
        end
        t_test= str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string')) ;
      
        
        
        if get(checkbox,'value')==1
            
        if max(fj1(t_test))> 1 || min(fj1(t_test))< -1
            set(err,'string','please check theta 1 limit','visible','on')
           set(hint,'string','use start=0, T end=90, j1=sin(t/5), j2=t, j3=t ','visible','on')
            err1=1;
        end
        if max(fj2(t_test))> 180 || min(fj2(t_test))< 0
            set(err,'string','please check theta 2 limit','visible','on')
             set(hint,'string','use start=0, T end=90, j1=sin(t/5), j2=t, j3=t ','visible','on')
            err1=1;
        end
        if max(fj3(t_test))> 90 || min(fj3(t_test))< -90
            set(err,'string','please check theta 3 limit','visible','on')
          set(hint,'string','use start=0, T end=90, j1=sin(t/5), j2=t, j3=t','visible','on')
            err1=1;
        end
        end

        if err1==1;
            return
        else
        
            [fout1, vout1, cout1] = rndread('base.slp');
            [fout2, vout2, cout2] = rndread('j13.slp');
            [fout3, vout3, cout3] = rndread('j14.slp');
            [fout4, vout4, cout4] = rndread('j5.slp');
            [fout5, vout5, cout5] = rndread('j6.slp');
            [fout6, vout6, cout6] = rndread('e1.slp');
            [fout7, vout7, cout7] = rndread('e4.slp');
            [fout8, vout8, cout8] = rndread('e5.slp');
            
            p1 = patch('faces', fout1, 'vertices' ,vout1);
            p2 = patch('faces', fout2, 'vertices' ,vout2);
            p3 = patch('faces', fout3, 'vertices' ,vout3);
            p4 = patch('faces', fout4, 'vertices' ,vout4);
            p5 = patch('faces', fout5, 'vertices' ,vout5);
            p6 = patch('faces', fout6, 'vertices' ,vout6);
            p7 = patch('faces', fout7, 'vertices' ,vout7);
            p8 = patch('faces', fout8, 'vertices' ,vout8);
            
            set(p1, 'facec', 'flat');
            set(p2, 'facec', 'flat');
            set(p3, 'facec', 'flat');
            set(p4, 'facec', 'flat');
            set(p5, 'facec', 'flat');
            set(p6, 'facec', 'flat');
            set(p7, 'facec', 'flat');
            set(p8, 'facec', 'flat');
        
            
            set(p1, 'FaceVertexCData', cout1); 
            set(p2, 'FaceVertexCData', cout2); 
            set(p3, 'FaceVertexCData', cout3);
            set(p4, 'FaceVertexCData', cout4);
            set(p5, 'FaceVertexCData', cout5);
            set(p6, 'FaceVertexCData', cout6);
            set(p7, 'FaceVertexCData', cout7);
            set(p8, 'FaceVertexCData', cout8);
            
            set(p1, 'EdgeColor','none'); 
            set(p2, 'EdgeColor','none'); 
            set(p3, 'EdgeColor','none'); 
            set(p4, 'EdgeColor','none'); 
            set(p5, 'EdgeColor','none'); 
            set(p6, 'EdgeColor','none'); 
            set(p7, 'EdgeColor','none'); 
            set(p8, 'EdgeColor','none');
            
            
            light                               % add a default light
            daspect([1 1 1])                    % Setting the aspect ratio
            view(3)                             
            xlabel('X'),ylabel('Y'),zlabel('Z')
            title(['KK  BH2 '])
    
            vout1 = vout1';
            vout1 = [vout1(1,:); vout1(2,:); vout1(3,:); ones(1,length(vout1))];
   
            vout2 = vout2';
            vout2 = [vout2(1,:); vout2(2,:); vout2(3,:); ones(1,length(vout2))];

            vout3 = vout3';
            vout3 = [vout3(1,:); vout3(2,:); vout3(3,:); ones(1,length(vout3))];
    
            vout4 = vout4';
            vout4 = [vout4(1,:); vout4(2,:); vout4(3,:); ones(1,length(vout4))];
    
            vout5 = vout5';
            vout5 = [vout5(1,:); vout5(2,:); vout5(3,:); ones(1,length(vout5))];
            
            vout6=vout6*1.6;
            vout7=vout7*4;
            vout8=vout8*40;
            vout6 = vout6';
            vout6 = [vout6(1,:); vout6(2,:); vout6(3,:); ones(1,length(vout6))];
    
            vout7 = vout7';
            vout7 = [vout7(1,:); vout7(2,:); vout7(3,:); ones(1,length(vout7))];
    
            vout8 = vout8';
            vout8 = [vout8(1,:); vout8(2,:); vout8(3,:); ones(1,length(vout8))];
            
            grid
            vsize =230; % or can be changed 
            axis([-100 vsize -vsize vsize 0 vsize]);
            
            hold on
            set(cal,'visible','off')
    if get(checkbox,'value')==0
            
         for t=0:1:90
               
            T1=tmat( 90,0 ,0,0);
            T2=tmat2(0,40,0);
            T3=tmat2(-50-30*sind(t),20,0);
            T4=tmat2(112.5,0,-7.5);                %change here
            T5=rx(0)*ry(0)*rz(t);
            T6=tmat2(75,0,0);
            T66=rx(0)*ry(0)*rz(t);
            T7=tmat2(52,2.5,7.50);
            T8=rx(90)*ry(-t)*rz(90);
            T9=tmat2(0,-7.5,2.2);
            T10=rx(-90)*ry(0)*rz(0);
            T11=tmat2(0,0,-35);
            T12=rx(0)*ry(100*t)*rz(0);
            
            nv1=T1*vout1;
            set(p1,'Vertices',nv1(1:3,:)');
            nv2=T1*T2*vout2;
            set(p2,'Vertices',nv2(1:3,:)');
            nv3=T1*T2*T3*vout3;
            set(p3,'Vertices',nv3(1:3,:)');
            nv4=T1*T2*T3*T4*T5*vout4;
            set(p4,'Vertices',nv4(1:3,:)');
            nv5=T1*T2*T3*T4*T5*T6*T66*vout5;
            set(p5,'Vertices',nv5(1:3,:)');
            nv6=T1*T2*T3*T4*T5*T6*T66*T7*T8*vout6;
            set(p6,'Vertices',nv6(1:3,:)');
            nv7=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*vout7;
            set(p7,'Vertices',nv7(1:3,:)');
            nv8=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*vout8;
            if rem(t,2)==0
            set(p8,'Vertices',nv8(1:3,:)');
            elseif rem(t,2)==1
                set(p8,'Vertices',[0 0 0]);
            end

            drawnow
            rotate3d
            TT=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12;
            x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
            
            end
    elseif get(checkbox,'value')==1
        
                    for t=str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string'))
        T1=tmat( 90,0 ,0,0);
            T2=tmat2(0,40,0);
            T3=tmat2(-50-30*fj1(t),20,0);
            T4=tmat2(112.5,0,-7.5);                %change here
            T5=rx(0)*ry(0)*rz(fj2(t));
            T6=tmat2(75,0,0);
            T66=rx(0)*ry(0)*rz(fj3(t));
            T7=tmat2(52,2.5,7.50);
            T8=rx(90)*ry(-t)*rz(90);
            T9=tmat2(0,-7.5,2.2);
            T10=rx(-90)*ry(0)*rz(0);
            T11=tmat2(0,0,-35);
            T12=rx(0)*ry(100*t)*rz(0);
            
            nv1=T1*vout1;
            set(p1,'Vertices',nv1(1:3,:)');
            nv2=T1*T2*vout2;
            set(p2,'Vertices',nv2(1:3,:)');
            nv3=T1*T2*T3*vout3;
            set(p3,'Vertices',nv3(1:3,:)');
            nv4=T1*T2*T3*T4*T5*vout4;
            set(p4,'Vertices',nv4(1:3,:)');
            nv5=T1*T2*T3*T4*T5*T6*T66*vout5;
            set(p5,'Vertices',nv5(1:3,:)');
            nv6=T1*T2*T3*T4*T5*T6*T66*T7*T8*vout6;
            set(p6,'Vertices',nv6(1:3,:)');
            nv7=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*vout7;
            set(p7,'Vertices',nv7(1:3,:)');
            nv8=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*vout8;
            if rem(t,2)==0
            set(p8,'Vertices',nv8(1:3,:)');
            elseif rem(t,2)==1
                set(p8,'Vertices',[0 0 0]);
            end

            drawnow
            rotate3d
        TT=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12;
            x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
         end 
    end
    set(p8,'Vertices',[0 0 0]);
        end
    end




    function prpw(varargin)
        
        set(joint1_movs,'string','joint1 displ')
        set(joint2_movs,'string','joint2 angle')
        set(joint3_movs,'string','joint3 displ.')
        
        fj1=inline(get(joint1_mov,'string'));
        fj2=inline(get(joint2_mov,'string'));
        fj3=inline(get(joint3_mov,'string'));
        err1=0;
        direction=1;
     
        if str2double(get(Tstart,'string')) > str2double(get(Tend,'string'))
           direction=-1 ;
        end
        t_test= str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string')) ;
      
        
        
        if get(checkbox,'value')==1
            
        if max(fj1(t_test))> 1 || min(fj1(t_test))< -1
            set(err,'string','please check theta 1 limit','visible','on')
           set(hint,'string','use start=0, T end=90, j1=sin(t/9), j2=t, j3=sin(t/7) ','visible','on')
            err1=1;
        end
        if max(fj2(t_test))> 180 || min(fj2(t_test))< 0
            set(err,'string','please check theta 2 limit','visible','on')
             set(hint,'string','use start=0, T end=90,  j1=sin(t/9), j2=t, j3=sin(t/7) ','visible','on')
            err1=1;
        end
        if max(fj3(t_test))> 1 || min(fj3(t_test))< -1
            set(err,'string','please check theta 3 limit','visible','on')
          set(hint,'string','use start=0, T end=90, j1=sin(t/9), j2=t, j3=sin(t/7) ','visible','on')
            err1=1;
        end
        end

        if err1==1;
            return
        else
        
            [fout1, vout1, cout1] = rndread('base.slp');
            [fout2, vout2, cout2] = rndread('j13.slp');
            [fout3, vout3, cout3] = rndread('j14.slp');
            [fout4, vout4, cout4] = rndread('j5.slp');
            [fout5, vout5, cout5] = rndread('j10.slp');
            [fout6, vout6, cout6] = rndread('j11.slp');
            [fout7, vout7, cout7] = rndread('j12.slp');
            [fout8, vout8, cout8] = rndread('e1.slp');
            [fout9, vout9, cout9] = rndread('e4.slp');
            [fout10, vout10, cout10] = rndread('e5.slp');
            
            
            p1 = patch('faces', fout1, 'vertices' ,vout1);
            p2 = patch('faces', fout2, 'vertices' ,vout2);
            p3 = patch('faces', fout3, 'vertices' ,vout3);
            p4 = patch('faces', fout4, 'vertices' ,vout4);
            p5 = patch('faces', fout5, 'vertices' ,vout5);
            p6 = patch('faces', fout6, 'vertices' ,vout6);
            p7 = patch('faces', fout7, 'vertices' ,vout7);
            p8 = patch('faces', fout8, 'vertices' ,vout8);
            p9 = patch('faces', fout9, 'vertices' ,vout9);
            p10 = patch('faces', fout10, 'vertices' ,vout10);
            
            set(p1, 'facec', 'flat');
            set(p2, 'facec', 'flat');
            set(p3, 'facec', 'flat');
            set(p4, 'facec', 'flat');
            set(p5, 'facec', 'flat');
            set(p6, 'facec', 'flat');
            set(p7, 'facec', 'flat');
            set(p8, 'facec', 'flat');
            set(p9, 'facec', 'flat');
            set(p10, 'facec', 'flat');
        
            
            set(p1, 'FaceVertexCData', cout1); 
            set(p2, 'FaceVertexCData', cout2); 
            set(p3, 'FaceVertexCData', cout3);
            set(p4, 'FaceVertexCData', cout4);
            set(p5, 'FaceVertexCData', cout5);
            set(p6, 'FaceVertexCData', cout6);
            set(p7, 'FaceVertexCData', cout7);
            set(p8, 'FaceVertexCData', cout8);
            set(p9, 'FaceVertexCData', cout9);
            set(p10, 'FaceVertexCData', cout10);
            
            set(p1, 'EdgeColor','none'); 
            set(p2, 'EdgeColor','none'); 
            set(p3, 'EdgeColor','none'); 
            set(p4, 'EdgeColor','none'); 
            set(p5, 'EdgeColor','none'); 
            set(p6, 'EdgeColor','none'); 
            set(p7, 'EdgeColor','none'); 
            set(p8, 'EdgeColor','none');
            set(p9, 'EdgeColor','none'); 
            set(p10, 'EdgeColor','none');
            
            
            light                               % add a default light
            daspect([1 1 1])                    % Setting the aspect ratio
            view(3)                             
            xlabel('X'),ylabel('Y'),zlabel('Z')
            title(['KK  BH2 '])
    
            vout1 = vout1';
            vout1 = [vout1(1,:); vout1(2,:); vout1(3,:); ones(1,length(vout1))];
   
            vout2 = vout2';
            vout2 = [vout2(1,:); vout2(2,:); vout2(3,:); ones(1,length(vout2))];

            vout3 = vout3';
            vout3 = [vout3(1,:); vout3(2,:); vout3(3,:); ones(1,length(vout3))];
    
            vout4 = vout4';
            vout4 = [vout4(1,:); vout4(2,:); vout4(3,:); ones(1,length(vout4))];
            
            vout5=vout5*1.3;
            vout5 = vout5';
            vout5 = [vout5(1,:); vout5(2,:); vout5(3,:); ones(1,length(vout5))];
            
            vout9=vout9*4;
            vout10=vout10*40;
            vout8=vout8*1.2;
            vout6 = vout6';
            vout6 = [vout6(1,:); vout6(2,:); vout6(3,:); ones(1,length(vout6))];
    
            vout7 = vout7';
            vout7 = [vout7(1,:); vout7(2,:); vout7(3,:); ones(1,length(vout7))];
    
            vout8 = vout8';
            vout8 = [vout8(1,:); vout8(2,:); vout8(3,:); ones(1,length(vout8))];
            
            vout9 = vout9';
            vout9 = [vout9(1,:); vout9(2,:); vout9(3,:); ones(1,length(vout9))];
    
            vout10 = vout10';
            vout10 = [vout10(1,:); vout10(2,:); vout10(3,:); ones(1,length(vout10))];
            
            grid
            vsize =230; % or can be changed 
            axis([-100 vsize -vsize vsize 0 vsize]);
             hold on
             set(cal,'visible','off')
    if get(checkbox,'value')==0
        
        
       for t=0:1:90
               
            T1=tmat( 90,0 ,0,0);
            T2=tmat2(0,40,0);
            T3=tmat2(-50-30*sind(t),20,0);
            T4=tmat2(112.5,0,-7.5);                %change here
            T5=rx(0)*ry(0)*rz(t);
            T6=tmat2(100,0,-2);
            T66=rx(0)*ry(0)*rz(90);
            T7=tmat2(0,10,5*sin(t/8)+4);
            T8=rx(90)*ry(0)*rz(00);
            T9=tmat2(0,32.5,0);
            T10=rx(0)*ry(90)*rz(0);
            T11=tmat2(-1,10,0);
            T12=rx(180)*ry(90)*rz(0);
            T13=tmat2(0,-7.5,2.2);
            T14=rx(-90)*ry(0)*rz(0);
            T15=tmat2(0,0,-35);
            T16=rx(0)*ry(100*t)*rz(0);
            
            nv1=T1*vout1;
            set(p1,'Vertices',nv1(1:3,:)');
            nv2=T1*T2*vout2;
            set(p2,'Vertices',nv2(1:3,:)');
            nv3=T1*T2*T3*vout3;
            set(p3,'Vertices',nv3(1:3,:)');
            nv4=T1*T2*T3*T4*T5*vout4;
            set(p4,'Vertices',nv4(1:3,:)');
            nv5=T1*T2*T3*T4*T5*T6*T66*vout5;
            set(p5,'Vertices',nv5(1:3,:)');
            nv6=T1*T2*T3*T4*T5*T6*T66*T7*T8*vout6;
            set(p6,'Vertices',nv6(1:3,:)');
            nv7=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*vout7;
            set(p7,'Vertices',nv7(1:3,:)');
            nv8=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*vout8;
            set(p8,'Vertices',nv8(1:3,:)');
            nv9=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*vout9;
            set(p9,'Vertices',nv9(1:3,:)');
            nv10=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*vout10;
            if rem(t,2)==0
            set(p10,'Vertices',nv10(1:3,:)');
            elseif rem(t,2)==1
                set(p10,'Vertices',[0 0 0]);
            end
            
            
            drawnow
            rotate3d
             TT=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16;
             x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
            
            end
    elseif get(checkbox,'value')==1
                for t=str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string'))
                  
                    T1=tmat( 90,0 ,0,0);
            T2=tmat2(0,40,0);
            T3=tmat2(-50-30*fj1(t),20,0);
            T4=tmat2(112.5,0,-7.5);                %change here
            T5=rx(0)*ry(0)*rz(fj2(t));
            T6=tmat2(100,0,-2);
            T66=rx(0)*ry(0)*rz(90);
            T7=tmat2(0,10,5*fj3(t)+4);
            T8=rx(90)*ry(0)*rz(00);
            T9=tmat2(0,32.5,0);
            T10=rx(0)*ry(90)*rz(0);
            T11=tmat2(-1,10,0);
            T12=rx(180)*ry(90)*rz(0);
            T13=tmat2(0,-7.5,2.2);
            T14=rx(-90)*ry(0)*rz(0);
            T15=tmat2(0,0,-35);
            T16=rx(0)*ry(100*t)*rz(0);
            
            nv1=T1*vout1;
            set(p1,'Vertices',nv1(1:3,:)');
            nv2=T1*T2*vout2;
            set(p2,'Vertices',nv2(1:3,:)');
            nv3=T1*T2*T3*vout3;
            set(p3,'Vertices',nv3(1:3,:)');
            nv4=T1*T2*T3*T4*T5*vout4;
            set(p4,'Vertices',nv4(1:3,:)');
            nv5=T1*T2*T3*T4*T5*T6*T66*vout5;
            set(p5,'Vertices',nv5(1:3,:)');
            nv6=T1*T2*T3*T4*T5*T6*T66*T7*T8*vout6;
            set(p6,'Vertices',nv6(1:3,:)');
            nv7=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*vout7;
            set(p7,'Vertices',nv7(1:3,:)');
            nv8=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*vout8;
            set(p8,'Vertices',nv8(1:3,:)');
            nv9=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*vout9;
            set(p9,'Vertices',nv9(1:3,:)');
            nv10=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*vout10;
            if rem(t,2)==0
            set(p10,'Vertices',nv10(1:3,:)');
            elseif rem(t,2)==1
                set(p10,'Vertices',[0 0 0]);
            end
            
            
            drawnow
            rotate3d
             TT=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16;
             x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
                    
                    
         end
    end
     set(p10,'Vertices',[0 0 0]);
        end
        
    
    end



    function pprw(varargin)
            
        
        set(joint1_movs,'string','joint1 displ.')
        set(joint2_movs,'string','joint2 displ.')
        set(joint3_movs,'string','joint3 angle')
        
        fj1=inline(get(joint1_mov,'string'));
        fj2=inline(get(joint2_mov,'string'));
        fj3=inline(get(joint3_mov,'string'));
        err1=0;
        direction=1;
     
        if str2double(get(Tstart,'string')) > str2double(get(Tend,'string'))
           direction=-1 ;
        end
        t_test= str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string')) ;
      
        
        
        if get(checkbox,'value')==1
            
        if max(fj1(t_test))> 1 || min(fj1(t_test))< -1
            set(err,'string','please check theta 1 limit','visible','on')
           set(hint,'string','use start=0, T end=90, j1=sin(t/8), j2=cos(t/9), j3=t ','visible','on')
            err1=1;
        end
        if max(fj2(t_test))> 1 || min(fj2(t_test))< -1
            set(err,'string','please check theta 2 limit','visible','on')
             set(hint,'string','use start=0, T end=90, j1=sin(t/8), j2=cos(t/9), j3=t ','visible','on')
            err1=1;
        end
        if max(fj3(t_test))> 200 || min(fj3(t_test))< -40
            set(err,'string','please check theta 3 limit','visible','on')
          set(hint,'string','use start=0, T end=90, j1=sin(t/8), j2=cos(t/9), j3=t ','visible','on')
            err1=1;
        end
        end

        if err1==1;
            return
        else
        
            
            
            [fout1, vout1, cout1] = rndread('base.slp');
            [fout2, vout2, cout2] = rndread('j13.slp');
            [fout3, vout3, cout3] = rndread('j14.slp');
            [fout4, vout4, cout4] = rndread('j7.slp');
            [fout5, vout5, cout5] = rndread('j8.slp');
            [fout6, vout6, cout6] = rndread('j9.slp');
            [fout7, vout7, cout7] = rndread('j6.slp');
            [fout8, vout8, cout8] = rndread('e1.slp');
            [fout9, vout9, cout9] = rndread('e4.slp');
            [fout10, vout10, cout10] = rndread('e5.slp');
            
            
            p1 = patch('faces', fout1, 'vertices' ,vout1);
            p2 = patch('faces', fout2, 'vertices' ,vout2);
            p3 = patch('faces', fout3, 'vertices' ,vout3);
            p4 = patch('faces', fout4, 'vertices' ,vout4);
            p5 = patch('faces', fout5, 'vertices' ,vout5);
            p6 = patch('faces', fout6, 'vertices' ,vout6);
            p7 = patch('faces', fout7, 'vertices' ,vout7);
            p8 = patch('faces', fout8, 'vertices' ,vout8);
            p9 = patch('faces', fout9, 'vertices' ,vout9);
            p10 = patch('faces', fout10, 'vertices' ,vout10);
            
            set(p1, 'facec', 'flat');
            set(p2, 'facec', 'flat');
            set(p3, 'facec', 'flat');
            set(p4, 'facec', 'flat');
            set(p5, 'facec', 'flat');
            set(p6, 'facec', 'flat');
            set(p7, 'facec', 'flat');
            set(p8, 'facec', 'flat');
            set(p9, 'facec', 'flat');
            set(p10, 'facec', 'flat');
        
            
            set(p1, 'FaceVertexCData', cout1); 
            set(p2, 'FaceVertexCData', cout2); 
            set(p3, 'FaceVertexCData', cout3);
            set(p4, 'FaceVertexCData', cout4);
            set(p5, 'FaceVertexCData', cout5);
            set(p6, 'FaceVertexCData', cout6);
            set(p7, 'FaceVertexCData', cout7);
            set(p8, 'FaceVertexCData', cout8);
            set(p9, 'FaceVertexCData', cout9);
            set(p10, 'FaceVertexCData', cout10);
            
            set(p1, 'EdgeColor','none'); 
            set(p2, 'EdgeColor','none'); 
            set(p3, 'EdgeColor','none'); 
            set(p4, 'EdgeColor','none'); 
            set(p5, 'EdgeColor','none'); 
            set(p6, 'EdgeColor','none'); 
            set(p7, 'EdgeColor','none'); 
            set(p8, 'EdgeColor','none');
            set(p9, 'EdgeColor','none'); 
            set(p10, 'EdgeColor','none');
            
            
            light                               % add a default light
            daspect([1 1 1])                    % Setting the aspect ratio
            view(3)                             
            xlabel('X'),ylabel('Y'),zlabel('Z')
            title(['KK  BH2 '])
    
            vout1 = vout1';
            vout1 = [vout1(1,:); vout1(2,:); vout1(3,:); ones(1,length(vout1))];
   
            vout2 = vout2';
            vout2 = [vout2(1,:); vout2(2,:); vout2(3,:); ones(1,length(vout2))];

            vout3 = vout3';
            vout3 = [vout3(1,:); vout3(2,:); vout3(3,:); ones(1,length(vout3))];
    
            vout4 = vout4';
            vout4 = [vout4(1,:); vout4(2,:); vout4(3,:); ones(1,length(vout4))];
            
            
            vout5 = vout5';
            vout5 = [vout5(1,:); vout5(2,:); vout5(3,:); ones(1,length(vout5))];
            
            vout9=vout9*4;
            vout10=vout10*40;
            vout8=vout8*1.5;
            vout6 = vout6';
            vout6 = [vout6(1,:); vout6(2,:); vout6(3,:); ones(1,length(vout6))];
    
            vout7 = vout7';
            vout7 = [vout7(1,:); vout7(2,:); vout7(3,:); ones(1,length(vout7))];
    
            vout8 = vout8';
            vout8 = [vout8(1,:); vout8(2,:); vout8(3,:); ones(1,length(vout8))];
            
            vout9 = vout9';
            vout9 = [vout9(1,:); vout9(2,:); vout9(3,:); ones(1,length(vout9))];
    
            vout10 = vout10';
            vout10 = [vout10(1,:); vout10(2,:); vout10(3,:); ones(1,length(vout10))];
            
            grid
            vsize =230; % or can be changed 
            axis([-100 vsize -vsize vsize 0 vsize]);
        
            
             hold on
             set(cal,'visible','off')
    if get(checkbox,'value')==0
        
        for t=0:1:90
               
            T1=tmat( 90,0 ,0,0);
            T2=tmat2(0,40,0);
            T3=tmat2(-50-30*sind(t),20,0);
            T4=tmat2(112.5,0,-7.5);                %change here
            T5=rx(0)*ry(0)*rz(90);
            T6=tmat2(60+10*sin(t/8),0,7.5);
            T66=rx(0)*ry(0)*rz(90);
            T7=tmat2(0,-2,0);
            T8=rx(180)*ry(90)*rz(0);
            T9=tmat2(0,4,-7.5);
            T10=rx(0)*ry(0)*rz(t);
            T11=tmat2(50,0,7.5);
            T12=rx(180)*ry(90)*rz(0);
            T13=tmat2(0,-7.5,2.2);
            T14=rx(-90)*ry(0)*rz(0);
            T15=tmat2(0,0,-35);
            T16=rx(0)*ry(100*t)*rz(0);
            
            nv1=T1*vout1;
            set(p1,'Vertices',nv1(1:3,:)');
            nv2=T1*T2*vout2;
            set(p2,'Vertices',nv2(1:3,:)');
            nv3=T1*T2*T3*vout3;
            set(p3,'Vertices',nv3(1:3,:)');
            nv4=T1*T2*T3*T4*T5*vout4;
            set(p4,'Vertices',nv4(1:3,:)');
            nv5=T1*T2*T3*T4*T5*T6*T66*vout5;
            set(p5,'Vertices',nv5(1:3,:)');
            nv6=T1*T2*T3*T4*T5*T6*T66*T7*T8*vout6;
            set(p6,'Vertices',nv6(1:3,:)');
            nv7=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*vout7;
            set(p7,'Vertices',nv7(1:3,:)');
            nv8=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*vout8;
            set(p8,'Vertices',nv8(1:3,:)');
            nv9=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*vout9;
            set(p9,'Vertices',nv9(1:3,:)');
            nv10=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*vout10;
            if rem(t,2)==0
            set(p10,'Vertices',nv10(1:3,:)');
            elseif rem(t,2)==1
                set(p10,'Vertices',[0 0 0]);
            end
            
            
            drawnow
            rotate3d
            
            TT=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16;
            x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
   
             end
    elseif get(checkbox,'value')==1
                for t=str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string'))
            
                    T1=tmat( 90,0 ,0,0);
            T2=tmat2(0,40,0);
            T3=tmat2(-50-30*fj1(t),20,0);
            T4=tmat2(112.5,0,-7.5);                %change here
            T5=rx(0)*ry(0)*rz(90);
            T6=tmat2(60+10*fj2(t),0,7.5);
            T66=rx(0)*ry(0)*rz(90);
            T7=tmat2(0,-2,0);
            T8=rx(180)*ry(90)*rz(0);
            T9=tmat2(0,4,-7.5);
            T10=rx(0)*ry(0)*rz(fj3(t));
            T11=tmat2(50,0,7.5);
            T12=rx(180)*ry(90)*rz(0);
            T13=tmat2(0,-7.5,2.2);
            T14=rx(-90)*ry(0)*rz(0);
            T15=tmat2(0,0,-35);
            T16=rx(0)*ry(100*t)*rz(0);
            
            nv1=T1*vout1;
            set(p1,'Vertices',nv1(1:3,:)');
            nv2=T1*T2*vout2;
            set(p2,'Vertices',nv2(1:3,:)');
            nv3=T1*T2*T3*vout3;
            set(p3,'Vertices',nv3(1:3,:)');
            nv4=T1*T2*T3*T4*T5*vout4;
            set(p4,'Vertices',nv4(1:3,:)');
            nv5=T1*T2*T3*T4*T5*T6*T66*vout5;
            set(p5,'Vertices',nv5(1:3,:)');
            nv6=T1*T2*T3*T4*T5*T6*T66*T7*T8*vout6;
            set(p6,'Vertices',nv6(1:3,:)');
            nv7=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*vout7;
            set(p7,'Vertices',nv7(1:3,:)');
            nv8=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*vout8;
            set(p8,'Vertices',nv8(1:3,:)');
            nv9=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*vout9;
            set(p9,'Vertices',nv9(1:3,:)');
            nv10=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*vout10;
            if rem(t,2)==0
            set(p10,'Vertices',nv10(1:3,:)');
            elseif rem(t,2)==1
                set(p10,'Vertices',[0 0 0]);
            end
            
            
            drawnow
            rotate3d
            
            TT=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16;
            x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
   
         end
    
    
        
    end
set(p10,'Vertices',[0 0 0]);
        end
    end





    function pppw(varargin)
        
        set(joint1_movs,'string','joint1 angle')
        set(joint2_movs,'string','joint2 angle')
        set(joint3_movs,'string','joint3 displ.')
        
        fj1=inline(get(joint1_mov,'string'));
        fj2=inline(get(joint2_mov,'string'));
        fj3=inline(get(joint3_mov,'string'));
        err1=0;
        direction=1;
     
        if str2double(get(Tstart,'string')) > str2double(get(Tend,'string'))
           direction=-1 ;
        end
        t_test= str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string')) ;
      
        
        
        if get(checkbox,'value')==1
            
        if max(fj1(t_test))> 1 || min(fj1(t_test))< -1
            set(err,'string','please check theta 1 limit','visible','on')
           set(hint,'string','use start=0, T end=90, j1=sin(t/10), j2=sin(t/10), j3=sin(t/10) ','visible','on')
            err1=1;
        end
        if max(fj2(t_test))> 1 || min(fj2(t_test))< -1
            set(err,'string','please check theta 2 limit','visible','on')
             set(hint,'string','use start=0, T end=90, j1=sin(t/10), j2=sin(t/10), j3=sin(t/10) ','visible','on')
            err1=1;
        end
        if max(fj3(t_test))> 1 || min(fj3(t_test))< -1
            set(err,'string','please check theta 3 limit','visible','on')
          set(hint,'string','use start=0, T end=90, j1=sin(t/10), j2=sin(t/10), j3=sin(t/10) ','visible','on')
            err1=1;
        end
        end

        if err1==1;
            return
        else
        
        
            [fout1, vout1, cout1] = rndread('base.slp');
            [fout2, vout2, cout2] = rndread('j13.slp');
            [fout3, vout3, cout3] = rndread('j14.slp');
            [fout4, vout4, cout4] = rndread('j7.slp');
            [fout5, vout5, cout5] = rndread('j8.slp');
            [fout6, vout6, cout6] = rndread('j10.slp');
            [fout7, vout7, cout7] = rndread('j11.slp');
            [fout8, vout8, cout8] = rndread('j12.slp');
            [fout9, vout9, cout9] = rndread('e1.slp');
            [fout10, vout10, cout10] = rndread('e4.slp');
            [fout11, vout11, cout11] = rndread('e5.slp');
        
            
            p1 = patch('faces', fout1, 'vertices' ,vout1);
            p2 = patch('faces', fout2, 'vertices' ,vout2);
            p3 = patch('faces', fout3, 'vertices' ,vout3);
            p4 = patch('faces', fout4, 'vertices' ,vout4);
            p5 = patch('faces', fout5, 'vertices' ,vout5);
            p6 = patch('faces', fout6, 'vertices' ,vout6);
            p7 = patch('faces', fout7, 'vertices' ,vout7);
            p8 = patch('faces', fout8, 'vertices' ,vout8);
            p9 = patch('faces', fout9, 'vertices' ,vout9);
            p10 = patch('faces', fout10, 'vertices' ,vout10);
            p11 = patch('faces', fout11, 'vertices' ,vout11);
            
            set(p1, 'facec', 'flat');
            set(p2, 'facec', 'flat');
            set(p3, 'facec', 'flat');
            set(p4, 'facec', 'flat');
            set(p5, 'facec', 'flat');
            set(p6, 'facec', 'flat');
            set(p7, 'facec', 'flat');
            set(p8, 'facec', 'flat');
            set(p9, 'facec', 'flat');
            set(p10, 'facec', 'flat');
            set(p11, 'facec', 'flat');
        
            
            set(p1, 'FaceVertexCData', cout1); 
            set(p2, 'FaceVertexCData', cout2); 
            set(p3, 'FaceVertexCData', cout3);
            set(p4, 'FaceVertexCData', cout4);
            set(p5, 'FaceVertexCData', cout5);
            set(p6, 'FaceVertexCData', cout6);
            set(p7, 'FaceVertexCData', cout7);
            set(p8, 'FaceVertexCData', cout8);
            set(p9, 'FaceVertexCData', cout9);
            set(p10, 'FaceVertexCData', cout10);
            set(p11, 'FaceVertexCData', cout11);
            
            set(p1, 'EdgeColor','none'); 
            set(p2, 'EdgeColor','none'); 
            set(p3, 'EdgeColor','none'); 
            set(p4, 'EdgeColor','none'); 
            set(p5, 'EdgeColor','none'); 
            set(p6, 'EdgeColor','none'); 
            set(p7, 'EdgeColor','none'); 
            set(p8, 'EdgeColor','none');
            set(p9, 'EdgeColor','none'); 
            set(p10, 'EdgeColor','none');
            set(p11, 'EdgeColor','none');
            
            
            light                               % add a default light
            daspect([1 1 1])                    % Setting the aspect ratio
            view(3)                             
            xlabel('X'),ylabel('Y'),zlabel('Z')
            title(['KK  BH2 '])
    
            vout1 = vout1';
            vout1 = [vout1(1,:); vout1(2,:); vout1(3,:); ones(1,length(vout1))];
   
            vout2 = vout2';
            vout2 = [vout2(1,:); vout2(2,:); vout2(3,:); ones(1,length(vout2))];

            vout3 = vout3';
            vout3 = [vout3(1,:); vout3(2,:); vout3(3,:); ones(1,length(vout3))];
    
            vout4 = vout4';
            vout4 = [vout4(1,:); vout4(2,:); vout4(3,:); ones(1,length(vout4))];
            
            
            vout5 = vout5';
            vout5 = [vout5(1,:); vout5(2,:); vout5(3,:); ones(1,length(vout5))];
            
            vout9=vout9*1.2;
            vout10=vout10*4;
            vout11=vout11*50;
            
            vout6 = vout6';
            vout6 = [vout6(1,:); vout6(2,:); vout6(3,:); ones(1,length(vout6))];
    
            vout7 = vout7';
            vout7 = [vout7(1,:); vout7(2,:); vout7(3,:); ones(1,length(vout7))];
    
            vout8 = vout8';
            vout8 = [vout8(1,:); vout8(2,:); vout8(3,:); ones(1,length(vout8))];
            
            vout9 = vout9';
            vout9 = [vout9(1,:); vout9(2,:); vout9(3,:); ones(1,length(vout9))];
    
            vout10 = vout10';
            vout10 = [vout10(1,:); vout10(2,:); vout10(3,:); ones(1,length(vout10))];
            
            vout11 = vout11';
            vout11 = [vout11(1,:); vout11(2,:); vout11(3,:); ones(1,length(vout11))];
            
            grid
            vsize =230; % or can be changed 
            axis([-100 vsize -vsize vsize 0 vsize]);
            
            hold on
            set(cal,'visible','off')
    if get(checkbox,'value')==0
            
            
        for t=0:1:90
               
            T1=tmat( 90,0 ,0,0);
            T2=tmat2(0,40,0);
            T3=tmat2(-50-30*sind(t),20,0);
            T4=tmat2(112.5,0,-7.5);                %change here
            T5=rx(0)*ry(0)*rz(90);
            T6=tmat2(60+10*sin(t/8),0,7.5);
            T66=rx(0)*ry(0)*rz(90);
            T7=tmat2(-7.5,0,0);
            T8=rx(180)*ry(90)*rz(0);
            T9=tmat2(25-5*sin(t/8),15,7.5);
            T10=rx(0)*ry(0)*rz(90);
            T11=tmat2(0,-2,0);
            T12=rx(180)*ry(90)*rz(0);
            T13=tmat2(-1,10,0);
            T14=rx(180)*ry(90)*rz(0);
            T15=tmat2(0,-7.5,2);
            T16=rx(-90)*ry(0)*rz(0);
            T17=tmat2(0,0,-35);
            T18=rx(0)*ry(100*t)*rz(0);
            
            nv1=T1*vout1;
            set(p1,'Vertices',nv1(1:3,:)');
            nv2=T1*T2*vout2;
            set(p2,'Vertices',nv2(1:3,:)');
            nv3=T1*T2*T3*vout3;
            set(p3,'Vertices',nv3(1:3,:)');
            nv4=T1*T2*T3*T4*T5*vout4;
            set(p4,'Vertices',nv4(1:3,:)');
            nv5=T1*T2*T3*T4*T5*T6*T66*vout5;
            set(p5,'Vertices',nv5(1:3,:)');
            nv6=T1*T2*T3*T4*T5*T6*T66*T7*T8*vout6;
            set(p6,'Vertices',nv6(1:3,:)');
            nv7=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*vout7;
            set(p7,'Vertices',nv7(1:3,:)');
            nv8=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*vout8;
            set(p8,'Vertices',nv8(1:3,:)');
            nv9=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*vout9;
            set(p9,'Vertices',nv9(1:3,:)');
            nv10=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*vout10;
            set(p10,'Vertices',nv10(1:3,:)');
            nv11=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*T17*T18*vout11;
            if rem(t,2)==0
                set(p11,'Vertices',nv11(1:3,:)');
            elseif rem(t,2)==1
                set(p11,'Vertices',[0 0 0]);
            end
            
            
            
            drawnow
            rotate3d
            
            TT=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*T17*T18;
             x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
            drawnow
            rotate3d
            
            end
            elseif get(checkbox,'value')==1
                
            for t=str2double(get(Tstart,'string')):direction:str2double(get(Tend,'string'))
          
                T1=tmat( 90,0 ,0,0);
            T2=tmat2(0,40,0);
            T3=tmat2(-50-30*fj1(t),20,0);
            T4=tmat2(112.5,0,-7.5);                %change here
            T5=rx(0)*ry(0)*rz(90);
            T6=tmat2(60+10*fj2(t),0,7.5);
            T66=rx(0)*ry(0)*rz(90);
            T7=tmat2(-7.5,0,0);
            T8=rx(180)*ry(90)*rz(0);
            T9=tmat2(25-5*fj3(t),15,7.5);
            T10=rx(0)*ry(0)*rz(90);
            T11=tmat2(0,-2,0);
            T12=rx(180)*ry(90)*rz(0);
            T13=tmat2(-1,10,0);
            T14=rx(180)*ry(90)*rz(0);
            T15=tmat2(0,-7.5,2);
            T16=rx(-90)*ry(0)*rz(0);
            T17=tmat2(0,0,-35);
            T18=rx(0)*ry(100*t)*rz(0);
            
            nv1=T1*vout1;
            set(p1,'Vertices',nv1(1:3,:)');
            nv2=T1*T2*vout2;
            set(p2,'Vertices',nv2(1:3,:)');
            nv3=T1*T2*T3*vout3;
            set(p3,'Vertices',nv3(1:3,:)');
            nv4=T1*T2*T3*T4*T5*vout4;
            set(p4,'Vertices',nv4(1:3,:)');
            nv5=T1*T2*T3*T4*T5*T6*T66*vout5;
            set(p5,'Vertices',nv5(1:3,:)');
            nv6=T1*T2*T3*T4*T5*T6*T66*T7*T8*vout6;
            set(p6,'Vertices',nv6(1:3,:)');
            nv7=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*vout7;
            set(p7,'Vertices',nv7(1:3,:)');
            nv8=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*vout8;
            set(p8,'Vertices',nv8(1:3,:)');
            nv9=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*vout9;
            set(p9,'Vertices',nv9(1:3,:)');
            nv10=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*vout10;
            set(p10,'Vertices',nv10(1:3,:)');
            nv11=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*T17*T18*vout11;
            if rem(t,2)==0
                set(p11,'Vertices',nv11(1:3,:)');
            elseif rem(t,2)==1
                set(p11,'Vertices',[0 0 0]);
            end
            
            
            
            drawnow
            rotate3d
            
            TT=T1*T2*T3*T4*T5*T6*T66*T7*T8*T9*T10*T11*T12*T13*T14*T15*T16*T17*T18;
             x=TT(1,4);
   y=TT(2,4);
   z=TT(3,4);
   plot3(x,y,z,'b.')
            drawnow
            rotate3d
                
            
         end
    
    
    end
     set(p11,'Vertices',[0 0 0]);
        end
    
        
    end


function Rx = rx(THETA)
% ROTATION ABOUT THE X-axis
%
% Rx = rx(THETA)
%
% This is the homogeneous transformation for
% rotation about the X-axis.
%
%	    NOTE:  The angle THETA must be in DEGREES.
%
THETA = THETA*pi/180;  % Note: THETA in radians.
c = cos(THETA);
s = sin(THETA);
Rx = [1 0 0 0; 0 c -s 0; 0 s c 0; 0 0 0 1];
end
%
function Ry = ry(THETA)
% ROTATION ABOUT THE Y-axis
%
% Ry = ry(THETA)
%
% This is the homogeneous transformation for
% rotation about the Y-axis.
%
%		NOTE: The angel THETA must be in DEGREES.
%
THETA = THETA*pi/180;  %Note: THETA is in radians.
c = cos(THETA);
s = sin(THETA);
Ry = [c 0 s 0; 0 1 0 0; -s 0 c 0; 0 0 0 1];
%
end
function Rz = rz(THETA)
% ROTATION ABOUT THE Z-axis
%
% Rz = rz(THETA)
%
% This is the homogeneous transformation for
% rotation about the Z-axis.
%
%		NOTE:  The angle THETA must be in DEGREES.
%
THETA = THETA*pi/180;  %Note: THETA is in radians.
c = cos(THETA);
s = sin(THETA);
%d= 30*THETA;
Rz = [c -s 0 0; s c 0 0; 0 0 1 0; 0 0 0 1];
end

    function T = tmat(alpha, a, d, theta)
        % tmat(alpha, a, d, theta) (T-Matrix used in Robotics)
        % The homogeneous transformation called the "T-MATRIX"
        % as used in the Kinematic Equations for robotic type
        % systems (or equivalent).
        %
        % This is equation 3.6 in Craig's "Introduction to Robotics."
        % alpha, a, d, theta are the Denavit-Hartenberg parameters.
        %
        % (NOTE: ALL ANGLES MUST BE IN DEGREES.)
        %
        alpha = alpha*pi/180;    %Note: alpha is in radians.
        theta = theta*pi/180;    %Note: theta is in radians.
        c = cos(theta);
        s = sin(theta);
        ca = cos(alpha);
        sa = sin(alpha);
        T = [c -s 0 a; s*ca c*ca -sa -sa*d; s*sa c*sa ca ca*d; 0 0 0 1];
        
    end

    function T=tmat2(px,py,pz)
        
       T=[1 0 0 px; 0 1 0 py; 0 0 1 pz; 0 0 0 1] ;
        
    end

function [fout, vout, cout] = rndread(filename)
% Reads CAD STL ASCII files, which most CAD programs can export.
% Used to create Matlab patches of CAD 3D data.
% Returns a vertex list and face list, for Matlab patch command.
% 

fid=fopen(filename, 'r'); %Open the file, assumes STL ASCII format.
if fid == -1 
    error('File could not be opened, check name or path.')
end
%
% Render files take the form:
%   
%solid BLOCK
%  color 1.000 1.000 1.000
%  facet
%      normal 0.000000e+00 0.000000e+00 -1.000000e+00
%      normal 0.000000e+00 0.000000e+00 -1.000000e+00
%      normal 0.000000e+00 0.000000e+00 -1.000000e+00
%    outer loop
%      vertex 5.000000e-01 -5.000000e-01 -5.000000e-01
%      vertex -5.000000e-01 -5.000000e-01 -5.000000e-01
%      vertex -5.000000e-01 5.000000e-01 -5.000000e-01
%    endloop
% endfacet
%
% The first line is object name, then comes multiple facet and vertex lines.
% A color specifier is next, followed by those faces of that color, until
% next color line.
%
CAD_object_name = sscanf(fgetl(fid), '%*s %s');  %CAD object name, if needed.
%                                                %Some STLs have it, some don't.   
vnum=0;       %Vertex number counter.
report_num=0; %Report the status as we go.
VColor = 0;
%
while feof(fid) == 0                    % test for end of file, if not then do stuff
    tline = fgetl(fid);                 % reads a line of data from file.
    fword = sscanf(tline, '%s ');       % make the line a character string
% Check for color
    if strncmpi(fword, 'c',1) == 1;    % Checking if a "C"olor line, as "C" is 1st char.
       VColor = sscanf(tline, '%*s %f %f %f'); % & if a C, get the RGB color data of the face.
    end                                % Keep this color, until the next color is used.
    if strncmpi(fword, 'v',1) == 1;    % Checking if a "V"ertex line, as "V" is 1st char.
       vnum = vnum + 1;                % If a V we count the # of V's
       report_num = report_num + 1;    % Report a counter, so long files show status
       if report_num > 249;
           %disp(sprintf('Reading vertix num: %d.',vnum));
           report_num = 0;
       end
       v(:,vnum) = sscanf(tline, '%*s %f %f %f'); % & if a V, get the XYZ data of it.
       c(:,vnum) = VColor;              % A color for each vertex, which will color the faces.
    end                                 % we "*s" skip the name "color" and get the data.                                          
end
%   Build face list; The vertices are in order, so just number them.
%
fnum = vnum/3;      %Number of faces, vnum is number of vertices.  STL is triangles.
flist = 1:vnum;     %Face list of vertices, all in order.
F = reshape(flist, 3,fnum); %Make a "3 by fnum" matrix of face list data.
%
%   Return the faces and vertexs.
%
fout = F';  %Orients the array for direct use in patch.
vout = v';  % "
cout = c';
%
fclose(fid);
end

end
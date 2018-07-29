% hankel_diff - calculates the Hankel transform and analyzes the data
%   [k2,D1k,D1,D2,gamma2,gamma0]=hankel_diff(r,t,R,g,w,A) where:
%
%   k2 =  spatial frequencies [um^-1]
%   D1k = D1(k2), the diffusion coefficient determined for each k
%       separately [um^2s^-1]
%   D1 and D2 = effective values of the diffusion coefficients D1 and
%       D2 [um^2s^-1]
%   gamma2 = the intensity fraction of component 2
%   gamma0 = the intensity fraction of immobile molecules
%   v_conv = the absolute velocity of the tracked center of mass [um/s]
%   a_conv = the angle the tracked center of mass moves in, with 0 degrees
%       corresponding to moving horizontally from the left to the right
%       [degrees]
%
%   r = radial distances
%   t = the times for each frame
%   R = a parameter roughly equal to max(r)
%   g = (Ir|r>R-Ir)/beta; containing the data to be Hankel transformed
%   w = the width (w(t)) of the Gaussian function Ir|r>R
%   A = the amplitude (A(t)) of the Gaussian function Ir|r>R
%   Nrp = the length of r
%   trc = parameter that if equal to 'y' leads to tracking of the center of
%       mass for each frame (otherwise the center of mass is determined from
%       the first post-bleach frame)
%   x_cm and y_cm = vector with the x- and y-position of the center of mass 
%       for each frame
%   dx = the pixel size (square pixels assumed)
%   Ixx and Iyy = the moments of inertia of the bleached spot
%   Ixy = the product of inertia of the bleached spot

function [k2,D1k,D1,D2,gamma2,gamma0,v_conv,a_conv]=...
    hankel_diff(r,t,R,g,w,A,Nrp,trc,x_cm,y_cm,dx,Ixx,Iyy,Ixy)

% Closes the figures
close(figure(3))
close(figure(4))
close(figure(5))
close(figure(6))
close(figure(7))
close(figure(8))

% Initiates variables
p=[];
p1=[];
p2=[];
p3=[];
p4=[];
fit_b=[];
y_fit_1=[];
y_fit_2=[];
y_fit_3=[];
y_fit_4=[];
R2_1=[];
R2_2=[];
R2_3=[];
R2_4=[];
k2=[];
D1k=[];
D1=[];
D2=[];
gamma2=[];
gamma0=[];
v_conv=[];
a_conv=[];

% Determines the range of k initially used
k_max=sqrt(5)/(pi*R/4);
k_min=k_max/200;
a=0;
while a==0
    [k,ftest]=dht(r',g(1,:)',[],R,k_min,k_max,Nrp); % A numerical Hankel transform
    ftest=ftest+A(1)*pi*w(1)^2*exp(-pi^2*k.^2*w(1)^2);
    pos=1;
    while ftest(pos)>ftest(1)*exp(-1) && pos<length(ftest)
        pos=pos+1;
    end
    k_max=5*k(pos);
    k_min=k_max/200;
        
    if pos<length(ftest)
        a=1;
    end
end

% Calculates the Hankel transform of the indata yielding F(k,t)
F=zeros(length(k),length(t));
Fr=zeros(size(F));
for i=1:length(t)   
    I=g(i,:);

    if i==1
        T=[];
    end
    % Calculates the Hankel transform, F(k,t)
    [k,F(:,i),T]=dht(r',I',T,R,k_min,k_max,Nrp);
    
    % Compensates for diffusion outside of the field of view
    F(:,i)=F(:,i)+A(i)*pi*w(i)^2*exp(-pi^2*k.^2*w(i)^2);
    Fr(:,i)=F(:,i)./F(:,1); % Fr(k,t) = F(k,t)/F(k,0)
end

%  Initializes the GUI and creates two panels to the left and two panels to
%  the right
f=figure(98);
clf
set(f,'Visible','off','Position',[0,0,750,500]);
leftTopPanel = uipanel('bordertype','etchedin',...
    'Position', [0.025 0.5 0.4625 0.45],...
    'Backgroundcolor','default','Visible','on',...
    'Parent',f);
leftBottomPanel = uipanel('bordertype','etchedin',...
    'Position', [0.025 0.05 0.4625 0.425],...
    'Backgroundcolor','default','Visible','on',...
    'Parent',f);
rightTopPanel = uipanel('bordertype','etchedin',...
    'Position', [0.5125 0.175 0.4625 0.775],...
    'Backgroundcolor','default','Visible','on',...
    'Parent',f);
rightBottomPanel = uipanel('bordertype','etchedin',...
    'Position', [0.5125 0.05 0.4625 0.1],...
    'Backgroundcolor','default','Visible','on',...
    'Parent',f);

% Construct the components in the gui
uicontrol(rightTopPanel,'Style','text','String','Choose k_max [um^-1]:',...
    'Units','normalized','FontSize',10,'HorizontalAlignment','left',...
    'Position',[0.05,0.11,0.5,0.05]);
edit_kmax=uicontrol(rightTopPanel,'Style','edit','String','','Units','normalized',...
    'Position',[0.6,0.11,0.35,0.05],'FontSize',10,'HorizontalAlignment','center',...
    'Callback',{@edit_kmax_Callback});

sh_kmax=uicontrol(rightTopPanel,'Style','slider',...
    'Max',max(k),'Min',min(k),'Value',0.02,'Visible','on',...
    'SliderStep',[(max(k)-min(k))*0.01 (max(k)-min(k))*0.05],'Units','normalized',...
    'Position',[0.05 0.04 0.9 0.05],...
    'Callback',{@sh_kmax_Callback});

uicontrol(leftBottomPanel,'Style','text','String','Fit to use:',...
    'Units','normalized','FontSize',10,'HorizontalAlignment','left',...
    'Position',[0.05,0.8,0.2,0.15]);
rad_f1=uicontrol(leftBottomPanel,'Style','radiobutton',...
    'String','1) Single component','Units','normalized',...
    'FontSize',10,'HorizontalAlignment','left',...
    'Value',1,'Position',[0.05 0.675 0.9 0.15],...
    'Callback',{@rad_f1_Callback});
rad_f2=uicontrol(leftBottomPanel,'Style','radiobutton',...
    'String','2) Single component + immobile fraction','Units','normalized',...
    'FontSize',10,'HorizontalAlignment','left',...
    'Value',0,'Position',[0.05 0.525 0.9 0.15],...
    'Callback',{@rad_f2_Callback});
rad_f3=uicontrol(leftBottomPanel,'Style','radiobutton',...
    'String','3) Two components','Units','normalized',...
    'FontSize',10,'HorizontalAlignment','left',...
    'Value',0,'Position',[0.05 0.375 0.9 0.15],...
    'Callback',{@rad_f3_Callback});
rad_f4=uicontrol(leftBottomPanel,'Style','radiobutton',...
    'String','4) Two components + immobile fraction','Units','normalized',...
    'FontSize',10,'HorizontalAlignment','left',...
    'Value',0,'Position',[0.05 0.225 0.9 0.15],...
    'Callback',{@rad_f4_Callback});

if trc=='y'
    uicontrol(leftBottomPanel,'Style','pushbutton','Units','normalized',...
        'String','Fit','Position',[0.05,0.05,0.2,0.125],...
        'FontSize',10,'Callback',{@btn_fit_Callback});
    uicontrol(leftBottomPanel,'Style','pushbutton','Units','normalized',...
        'String','Fit Dk','Position',[0.2833,0.05,0.2,0.125],...
        'FontSize',10,'Callback',{@btn_fitDk_Callback});
    uicontrol(leftBottomPanel,'Style','pushbutton','Units','normalized',...
        'String','Ellipticity','Position',[0.5167,0.05,0.2,0.125],'Visible','on',...
        'FontSize',10,'Callback',{@btn_ellipse_Callback});
    uicontrol(leftBottomPanel,'Style','pushbutton','Units','normalized',...
        'String','Calc v_c','Position',[0.75,0.05,0.2,0.125],'Visible','on',...
        'FontSize',10,'Callback',{@btn_vel_Callback});
else
    uicontrol(leftBottomPanel,'Style','pushbutton','Units','normalized',...
        'String','Fit','Position',[0.05,0.05,0.25,0.125],...
        'FontSize',10,'Callback',{@btn_fit_Callback});
    uicontrol(leftBottomPanel,'Style','pushbutton','Units','normalized',...
        'String','Fit Dk','Position',[0.375,0.05,0.25,0.125],...
        'FontSize',10,'Callback',{@btn_fitDk_Callback});
    uicontrol(leftBottomPanel,'Style','pushbutton','Units','normalized',...
        'String','Ellipticity','Position',[0.7,0.05,0.25,0.125],'Visible','on',...
        'FontSize',10,'Callback',{@btn_ellipse_Callback});
    uicontrol(leftBottomPanel,'Style','pushbutton','Units','normalized',...
        'String','Calc v_c','Position',[0.7,0.05,0.25,0.125],'Visible','off',...
        'FontSize',10,'Callback',{@btn_vel_Callback});
end

txt_D=uicontrol(rightBottomPanel,'Style','text','String','',...
    'Units','normalized','FontSize',10,'HorizontalAlignment','left',...
    'Position',[0.05,0.1,0.9,0.8]);

% Assigns the GUI a name to appear in the window title.
set(f,'NumberTitle','off')
set(f,'Name','Fit the data')

% Creates the menus
set(f,'MenuBar','none');

% Moves the GUI to the center of the screen.
movegui(f,'center')

% Makes the GUI visible.
set(f,'Visible','on');

% Creates axes to the images to appear in
ax_l=axes('Units','pixels','Parent',leftTopPanel,'Units','normalized',...
    'Position',[0.16 0.23 0.79 0.62],'Visible','on');
ax_r=axes('Units','pixels','Parent',rightTopPanel,'Units','normalized',...
    'Position',[0.16 0.33 0.79 0.58],'Visible','on');

h1=plot(k,Fr,'b-','LineWidth',2);
set(h1,'Parent',ax_l)
box(ax_l,'on');
xlabel(ax_l,'k [\mum^-^1]')
ylabel(ax_l,'Hankel transform [a.u.]')
title(ax_l,'F(k,t)/F(k,0)')
xlim(ax_l,[0,max(k)])
ylim(ax_l,[-0.1,1.1])

% Estimates k_max for the curve fits
df2=F(:,1)-F(:,end);
k_max0=min(k(df2==max(df2)));
k_max2=k_max0;
set(edit_kmax,'String',num2str(k_max2));
set(sh_kmax,'Value',k_max2);

[k2,y,y2,x,x2,nr]=update_graph_kmax;

% update_graph_kmax - updates the graph with the new value of k_max
    function [k2,y,y2,x,x2,nr]=update_graph_kmax
        % Only use values of k smaller than k_max2
        k2=k(k<=k_max2);
        y=Fr(k<=k_max2,:);

        % Puts the data in one vector and sort it in ascending order
        [Tt,Kk]=meshgrid(t,k2);
        tv=Tt(:);
        kv=Kk(:);
        x=4*pi^2*kv.^2.*tv;
        [x2,nr]=sort(x);
        y2=y(:);
        y2=y2(nr);

        h=plot(x2,y2,'b.','LineWidth',2);
        set(h,'Parent',ax_r)
        box(ax_r,'on');
        xlabel(ax_r,'4\pi^2k^2t [(\mum)^{-2}s]')
        ylabel(ax_r,'Hankel transform [a.u.]')
        title(ax_r,['k < ',num2str(k_max2),' \mum^{-1}'])
        axis(ax_r,'tight')
    end

% edit_kmax_Callback - updates the value of k_max
    function edit_kmax_Callback(source,eventdata)
        k_str=get(edit_kmax,'String');
        if ~isempty(k_str)
            k_max2=str2double(k_str);
        else
            k_max2=k_max0;
        end
        set(sh_kmax,'Value',k_max2);
        [k2,y,y2,x,x2,nr]=update_graph_kmax;
    end

% sh_kmax_Callback - updates the value of k_max using the slider
    function sh_kmax_Callback(source,eventdata)
        k_max2=get(sh_kmax,'Value');
        set(edit_kmax,'String',num2str(k_max2));
        [k2,y,y2,x,x2,nr]=update_graph_kmax;
    end

% btn_fit_Callback - initiates the curve fitting
    function btn_fit_Callback(source,eventdata)
        if get(rad_f1,'Value')==1
            fit_nr1(k2,y,y2,x,x2,nr);
            
            p=p1;
            fit_b=1;
            
            % Plots all curve fits in one graph. The steps below are to compensate for
            % errors in F(k,0).
            y_fit_1p=y_fit_1;
            yp=y;
            for i=1:length(k2)
                y_fit_1p(i,:)=y_fit_1(i,:)./p1(4+i);
                yp(i,:)=y(i,:)./p(4+i);
            end
            y_fit_1p=y_fit_1p(:);
            y_fit_1p=y_fit_1p(nr);
            yp=yp(:);
            yp=yp(nr);
            
            figure(3)
            ax1 = gca;
            set(ax1,'FontSize',12)
            plot(x2,yp,'b.',x2,y_fit_1p,'r-','MarkerSize',10,'LineWidth',2)
            legend(ax1,'Data',['Fit nr1: (R^2=',num2str(R2_1),')'])
            xlabel(ax1,'4\pi^2k^2t [(\mum)^{-2}s]','FontSize',12)
            ylabel(ax1,'Hankel transform [a.u.]','FontSize',12)
            title(ax1,'F(k,t)/F(k,0) as a function of 4\pi^2k^2t','FontSize',12)
            axis(ax1,'tight')

            figure(98)
            plot(ax_r,x2,yp,'b.',x2,y_fit_1p,'r-','LineWidth',2,'MarkerSize',10)
            box(ax_r,'on');
            xlabel(ax_r,'4\pi^2k^2t [(\mum)^{-2}s]')
            ylabel(ax_r,'Hankel transform [a.u.]')
            legend(ax_r,'Data','Fit nr1')
            axis(ax_r,'tight')
            
            set(txt_D,'String',sprintf(['D = ',num2str(p1(2)),' um^2s^-1','\n']))
        elseif get(rad_f2,'Value')==1
            fit_nr2(k2,y,y2,x,x2,nr);
            
            % Compares the different fits with the squared error sum of the fit with
            % the most parameters.
            qd_12=sum((y_fit_2(:)-y_fit_1(:)).^2)/sum((y_fit_2(:)-y(:)).^2);
            
            % Determines which fit that best describes the data (in relation to the
            % amount of parameters used in the fit).
            if qd_12>0.5
                fit_b=2;
                p=p2;
            else
                fit_b=1;
                p=p1;
            end
            
            % Plots all curve fits in one graph. The steps below are to compensate for
            % errors in F(k,0).
            y_fit_1p=y_fit_1;
            y_fit_2p=y_fit_2;
            yp=y;
            for i=1:length(k2)
                y_fit_1p(i,:)=y_fit_1(i,:)./p1(4+i);
                y_fit_2p(i,:)=y_fit_2(i,:)./p2(4+i);
                yp(i,:)=y(i,:)./p(4+i);
            end
            y_fit_1p=y_fit_1p(:);
            y_fit_1p=y_fit_1p(nr);
            y_fit_2p=y_fit_2p(:);
            y_fit_2p=y_fit_2p(nr);
            yp=yp(:);
            yp=yp(nr);
            
            figure(3)
            ax1 = gca;
            set(ax1,'FontSize',12)
            plot(x2,yp,'b.',x2,y_fit_2p,'g-','MarkerSize',10,'LineWidth',2)
            legend(ax1,'Data',['Fit nr2: (R^2=',num2str(R2_2),')'])
            xlabel(ax1,'4\pi^2k^2t [(\mum)^{-2}s]','FontSize',12)
            ylabel(ax1,'Hankel transform [a.u.]','FontSize',12)
            title(ax1,'F(k,t)/F(k,0) as a function of 4\pi^2k^2t','FontSize',12)
            axis(ax1,'tight')

            figure(98)
            plot(ax_r,x2,yp,'b.',x2,y_fit_1p,'r-',x2,y_fit_2p,'g-','LineWidth',2,'MarkerSize',10)
            box(ax_r,'on');
            legend(ax_r,'Data','Fit nr1','Fit nr2')
            xlabel(ax_r,'4\pi^2k^2t [(\mum)^{-2}s]')
            ylabel(ax_r,'Hankel transform [a.u.]')
            title(ax_r,['Fit nr',num2str(fit_b),' is statistically the best'])
            axis(ax_r,'tight')
            
            set(txt_D,'String',sprintf(['D = ',num2str(p2(2)),' um^2s^-1','\n','gamma0 = ',num2str(p2(4))]))
            
        elseif get(rad_f3,'Value')==1
            fit_nr3(k2,y,y2,x,x2,nr);
            
            % Compares the different fits with the squared error sum of the fit with
            % the most parameters.
            qd_23=sum((y_fit_3(:)-y_fit_2(:)).^2)/sum((y_fit_3(:)-y(:)).^2);
            qd_13=sum((y_fit_3(:)-y_fit_1(:)).^2)/sum((y_fit_3(:)-y(:)).^2);
            
            % Determines which fit that best describes the data (in relation to the
            % amount of parameters used in the fit).
            if qd_23>0.5
                fit_b=3;
                p=p3;
            elseif qd_13>0.5
                fit_b=2;
                p=p2;
            else
                fit_b=1;
                p=p1;
            end
            
            % Plots all curve fits in one graph. The steps below are to compensate for
            % errors in F(k,0).
            y_fit_1p=y_fit_1;
            y_fit_2p=y_fit_2;
            y_fit_3p=y_fit_3;
            yp=y;
            for i=1:length(k2)
                y_fit_1p(i,:)=y_fit_1(i,:)./p1(4+i);
                y_fit_2p(i,:)=y_fit_2(i,:)./p2(4+i);
                y_fit_3p(i,:)=y_fit_3(i,:)./p3(4+i);
                yp(i,:)=y(i,:)./p(4+i);
            end
            y_fit_1p=y_fit_1p(:);
            y_fit_1p=y_fit_1p(nr);
            y_fit_2p=y_fit_2p(:);
            y_fit_2p=y_fit_2p(nr);
            y_fit_3p=y_fit_3p(:);
            y_fit_3p=y_fit_3p(nr);
            yp=yp(:);
            yp=yp(nr);
            
            figure(3)
            ax1 = gca;
            set(ax1,'FontSize',12)
            plot(x2,yp,'b.',x2,y_fit_3p,'c-','MarkerSize',10,'LineWidth',2)
            legend(ax1,'Data',['Fit nr3: (R^2=',num2str(R2_2),')'])
            xlabel(ax1,'4\pi^2k^2t [(\mum)^{-2}s]','FontSize',12)
            ylabel(ax1,'Hankel transform [a.u.]','FontSize',12)
            title(ax1,'F(k,t)/F(k,0) as a function of 4\pi^2k^2t','FontSize',12)
            axis(ax1,'tight')

            figure(98)
            plot(ax_r,x2,yp,'b.',x2,y_fit_1p,'r-',x2,y_fit_2p,'g-',x2,y_fit_3p,'c-',...
                'LineWidth',2,'MarkerSize',10)
            box(ax_r,'on');
            legend(ax_r,'Data','Fit nr1','Fit nr2','Fit nr3')
            xlabel(ax_r,'4\pi^2k^2t [(\mum)^{-2}s]')
            ylabel(ax_r,'Hankel transform [a.u.]')
            title(ax_r,['Fit nr',num2str(fit_b),' is statistically the best'])
            axis(ax_r,'tight')
            
            set(txt_D,'String',sprintf(['D1 = ',num2str(p3(2)),' um^2s^-1, ',...
                'D2 = ',num2str(p3(3)),' um^2s^-1','\n','gamma2 = ',num2str(p3(1))]))
           
        else
            fit_nr4(k2,y,y2,x,x2,nr);
            
            % Compares the different fits with the squared error sum of the fit with
            % the most parameters.
            qd_34=sum((y_fit_4(:)-y_fit_3(:)).^2)/sum((y_fit_4(:)-y(:)).^2);
            qd_24=sum((y_fit_4(:)-y_fit_2(:)).^2)/sum((y_fit_4(:)-y(:)).^2);
            qd_14=sum((y_fit_4(:)-y_fit_1(:)).^2)/sum((y_fit_4(:)-y(:)).^2);
            
            % Determines which fit that best describes the data (in relation to the
            % amount of parameters used in the fit).
            if qd_34>0.5
                fit_b=4;
                p=p4;
            elseif qd_24>0.5
                fit_b=3;
                p=p3;
            elseif qd_14>0.5
                fit_b=2;
                p=p2;
            else
                fit_b=1;
                p=p1;
            end
            
            % Plots all curve fits in one graph. The steps below are to compensate for
            % errors in F(k,0).
            y_fit_1p=y_fit_1;
            y_fit_2p=y_fit_2;
            y_fit_3p=y_fit_3;
            y_fit_4p=y_fit_4;
            yp=y;
            for i=1:length(k2)
                y_fit_1p(i,:)=y_fit_1(i,:)./p1(4+i);
                y_fit_2p(i,:)=y_fit_2(i,:)./p2(4+i);
                y_fit_3p(i,:)=y_fit_3(i,:)./p3(4+i);
                y_fit_4p(i,:)=y_fit_4(i,:)./p4(4+i);
                yp(i,:)=y(i,:)./p(4+i);
            end
            y_fit_1p=y_fit_1p(:);
            y_fit_1p=y_fit_1p(nr);
            y_fit_2p=y_fit_2p(:);
            y_fit_2p=y_fit_2p(nr);
            y_fit_3p=y_fit_3p(:);
            y_fit_3p=y_fit_3p(nr);
            y_fit_4p=y_fit_4p(:);
            y_fit_4p=y_fit_4p(nr);
            yp=yp(:);
            yp=yp(nr);
            
            figure(3)
            ax1 = gca;
            set(ax1,'FontSize',12)
            plot(x2,yp,'b.',x2,y_fit_4p,'c-','MarkerSize',10,'LineWidth',2)
            legend(ax1,'Data',['Fit nr4: (R^2=',num2str(R2_2),')'])
            xlabel(ax1,'4\pi^2k^2t [(\mum)^{-2}s]','FontSize',12)
            ylabel(ax1,'Hankel transform [a.u.]','FontSize',12)
            title(ax1,'F(k,t)/F(k,0) as a function of 4\pi^2k^2t','FontSize',12)
            axis(ax1,'tight')

            figure(98)
            plot(ax_r,x2,yp,'b.',x2,y_fit_1p,'r-',x2,y_fit_2p,'g-',x2,y_fit_3p,'c-',...
                x2,y_fit_4p,'m-','LineWidth',2,'MarkerSize',10)
            box(ax_r,'on');
            legend(ax_r,'Data','Fit nr1','Fit nr2','Fit nr3','Fit nr4')
            xlabel(ax_r,'4\pi^2k^2t [(\mum)^{-2}s]')
            ylabel(ax_r,'Hankel transform [a.u.]')
            title(ax_r,['Fit nr',num2str(fit_b),' is statistically the best'])
            axis(ax_r,'tight')
            
            set(txt_D,'String',sprintf(['D1 = ',num2str(p4(2)),' um^2s^-1, ',...
                'D2 = ',num2str(p4(3)),' um^2s^-1','\n','gamma0 = ',num2str(p4(4)),...
                ', gamma2 = ',num2str(p(1))]))
        end
        D1=p(2);
        D2=p(3);
        gamma0=p(4);
        gamma2=p(1);
    end

% rad_f1_Callback - chooses fit number 1
    function rad_f1_Callback(source,eventdata)
        if get(rad_f1,'Value')==0
            set(rad_f1,'Value',1);
        else
            set(rad_f2,'Value',0);
            set(rad_f3,'Value',0);
            set(rad_f4,'Value',0);
        end
    end

% rad_f2_Callback - chooses fit number 2
    function rad_f2_Callback(source,eventdata)
        if get(rad_f2,'Value')==0
            set(rad_f2,'Value',1);
        else
            set(rad_f1,'Value',0);
            set(rad_f3,'Value',0);
            set(rad_f4,'Value',0);
        end
    end

% rad_f3_Callback - chooses fit number 3
    function rad_f3_Callback(source,eventdata)
        if get(rad_f3,'Value')==0
            set(rad_f3,'Value',1);
        else
            set(rad_f1,'Value',0);
            set(rad_f2,'Value',0);
            set(rad_f4,'Value',0);
        end
    end

% rad_f4_Callback - chooses fit number 4
    function rad_f4_Callback(source,eventdata)
        if get(rad_f4,'Value')==0
            set(rad_f4,'Value',1);
        else
            set(rad_f1,'Value',0);
            set(rad_f2,'Value',0);
            set(rad_f3,'Value',0);
        end
    end
 
% fit_nr1 - makes a single-exponential curve fit to the data, 
%   without an immobile fraction of molecules
    function fit_nr1(k2,y,y2,x,x2,nr)

        % Defines the options for the nonlinear fit
        options=optimset('Display','off');

        % Estimate starting values for the curve fits
        yg=y2;
        pos=1;
        while yg(pos)>exp(-1) && pos<length(yg)
            pos=pos+1;
        end
        Dg=abs(-log(yg(pos))/(x2(pos)-x2(1)));

        % Makes a single-exponential curve fit to the data, without an immobile
        % fraction of molecules
        p0=[0,Dg,0,0,ones(1,length(k2))];
        [p1,sse]=lsqnonlin(@(p) fkn_dbl_exp_fit(p,t,y,k2),p0,...
            [-realmin,0,-realmin,-realmin,-Inf*ones(1,length(k2))],...
            [realmin,Inf,realmin,realmin,Inf*ones(1,length(k2))],options);
        [dy,y_fit_1]=fkn_dbl_exp_fit(p1,t,y,k2);
        sst=abs(sum(sum((mean(y(:))-y).^2)));
        R2_1=1-sse/sst;
        
        p2=[];
        p3=[];
        p4=[];
        y_fit_2=[];
        y_fit_3=[];
        y_fit_4=[];
        R2_2=[];
        R2_3=[];
        R2_4=[];
    end
    
    % fit_nr2 - makes a single-exponential curve fit to the data, 
    %   with an immobile fraction of molecules
    function fit_nr2(k2,y,y2,x,x2,nr)

        fit_nr1(k2,y,y2,x,x2,nr);
        
        % Defines the options for the nonlinear fit
        options=optimset('Display','off');

        % Estimate starting values for the curve fits
        gamma0_g=max(abs(mean(y2(end-10:end))),0);
        yg=y2-gamma0_g;
        yg=yg/yg(1);
        pos=1;
        while yg(pos)>exp(-1) && pos<length(yg)
            pos=pos+1;
        end
        Dg=max(p1(2),abs(-log(yg(pos))/(x2(pos)-x2(1))));

        % Makes a single-exponential curve fit to the data, with an immobile
        % fraction of molecules
        p0=[0,Dg,0,gamma0_g,ones(1,length(k2))];
        [p2,sse]=lsqnonlin(@(p) fkn_dbl_exp_fit(p,t,y,k2),p0,...
            [-realmin,0,-realmin,-Inf,-Inf*ones(1,length(k2))],...
            [realmin,Inf,realmin,Inf,Inf*ones(1,length(k2))],options);
        [dy,y_fit_2]=fkn_dbl_exp_fit(p2,t,y,k2);
        sst=abs(sum(sum((mean(y(:))-y).^2)));
        R2_2=1-sse/sst;
        
         p3=[];
         p4=[];
         y_fit_3=[];
         y_fit_4=[];
         R2_3=[];
         R2_4=[];
    end
    
    % fit_nr3 - makes a double-exponential curve fit to the data,
    %   without an immobile fraction of molecules
    function fit_nr3(k2,y,y2,x,x2,nr)

        fit_nr2(k2,y,y2,x,x2,nr);

        % Defines the options for the nonlinear fit
        options=optimset('Display','off');

        % Estimate starting values for the curve fits
        yg=y2;
        pos=length(x2);
        while yg(pos)<(0.2+yg(end)) && pos>2
            pos=pos-1;
        end
        pos=pos-1;
        pos0=pos;
        yg=yg/yg(pos0);
        while yg(pos)>exp(-1) && pos<length(yg)
            pos=pos+1;
        end
        Dg2=abs(-log(yg(pos))/(x2(pos)-x2(pos0)));
        gamma2_g=min(1,abs(y2(pos)*exp(Dg2*x2(pos))));

        yg=yg-gamma2_g*exp(-Dg2*x2);
        yg=yg/yg(1);
        pos=1;
        while yg(pos)>exp(-1) && pos<length(yg)
            pos=pos+1;
        end
        Dg1=max(p2(2),abs(-log(yg(pos))/(x2(pos)-x2(1))));

        % Makes a double-exponential curve fit to the data, without an immobile
        % fraction of molecules
        p0=[gamma2_g,Dg1,Dg2,0,ones(1,length(k2))];
        [p3,sse]=lsqnonlin(@(p) fkn_dbl_exp_fit(p,t,y,k2),p0,...
            [-Inf,0,0,-realmin,-Inf*ones(1,length(k2))],...
            [Inf,Inf,Inf,realmin,Inf*ones(1,length(k2))],options);
        [dy,y_fit_3]=fkn_dbl_exp_fit(p3,t,y,k2);
        sst=abs(sum(sum((mean(y(:))-y).^2)));
        R2_3=1-sse/sst;
        
        p4=[];
        y_fit_4=[];
        R2_4=[];
    end
    
    % fit_nr4 - makes a double-exponential curve fit to the data, with an immobile
    %   fraction of molecules
    function fit_nr4(k2,y,y2,x,x2,nr)

        fit_nr3(k2,y,y2,x,x2,nr);
      
        % Defines the options for the nonlinear fit
        options=optimset('Display','off');

        % Estimate starting values for the curve fits
        gamma0_g=max(abs(mean(y2(end-10:end))),0);
        yg=y2-gamma0_g;
        yg=yg/yg(1);
        pos=length(x2);
        while yg(pos)<(0.1+yg(end)) && pos>2
            pos=pos-1;
        end
        pos=pos-1;
        pos0=pos;
        yg=yg/yg(pos0);
        while yg(pos)>exp(-1) && pos<length(yg)
            pos=pos+1;
        end
        Dg2=abs(-log(yg(pos))/(x2(pos)-x2(pos0)));
        gamma2_g=min(1,abs(y2(pos)*exp(Dg2*x2(pos))));

        yg=yg-gamma2_g*exp(-Dg2*x2);
        yg=yg/yg(1);
        pos=1;
        while yg(pos)>exp(-1) && pos<length(yg)
            pos=pos+1;
        end
        Dg1=max(p2(2),abs(-log(yg(pos))/(x2(pos)-x2(1))));

        % Makes a double-exponential curve fit to the data, with an immobile
        % fraction of molecules
        p0=[gamma2_g,Dg1,Dg2,gamma0_g,ones(1,length(k2))];
        [p4,sse]=lsqnonlin(@(p) fkn_dbl_exp_fit(p,t,y,k2),p0,...
            [-Inf,0,0,-Inf,-Inf*ones(1,length(k2))],...
            [Inf,Inf,Inf,Inf,Inf*ones(1,length(k2))],options);
        [dy,y_fit_4]=fkn_dbl_exp_fit(p4,t,y,k2);
        sst=abs(sum(sum((mean(y(:))-y).^2)));
        R2_4=1-sse/sst;

        p0=p3;
        [p4_2,sse]=lsqnonlin(@(p) fkn_dbl_exp_fit(p,t,y,k2),p0,...
            [0,0,0,0,-Inf*ones(1,length(k2))],...
            [1,Inf,Inf,1,Inf*ones(1,length(k2))],options);
        [dy,y_fit_4_2]=fkn_dbl_exp_fit(p4_2,t,y,k2);
        R2_42=1-sse/sst;

        if R2_42>R2_4
            p4=p4_2;
            y_fit_4=y_fit_4_2;
            R2_4=R2_42;
        end
        
    end

% btn_fitDk_Callback - initiates the curve fitting
    function btn_fitDk_Callback(source,eventdata)
        btn_fit_Callback;
        fit_Dk;
    end

% fit_Dk - Chooses whether to also calculate Dk. If two-component
%   diffusion is chosen then only one of the two D are calculated as Dk.
    function fit_Dk

        % Defines the options for the nonlinear fit
        options=optimset('Display','off');
        
        % Determines starting parameter for a double-exponential curve fit to the
        % data points with D1 allowed to change for each k
        p0=ones(1,length(k2)*2+3);
        p0(1)=gamma0;
        p0(2)=D2;
        p0(3)=gamma2;
        p0(4:2:end)=D1;
        p0(5:2:end)=p(5:end);

        % Chooses which of the parameters D2, gamma2 and gamma0 that are allowed to
        % vary (this is based on the choice of fit_b made above).
        if fit_b==4
            % Makes a double-exponential curve fit to the data, with an immobile
            % fraction of molecules
            pk=lsqnonlin(@(p) fkn_dbl_exp_fit_k(p,t,y,k2),p0,...
                [0,0,0,-Inf*ones(1,length(k2)*2)],...
                [Inf,Inf,Inf,Inf*ones(1,length(k2)*2)],options);
        elseif fit_b==3
            % Makes a double-exponential curve fit to the data, without an immobile
            % fraction of molecules
            pk=lsqnonlin(@(p) fkn_dbl_exp_fit_k(p,t,y,k2),p0,...
                [-realmin,0,0,-Inf*ones(1,length(k2)*2)],...
                [realmin,Inf,Inf,Inf*ones(1,length(k2)*2)],options);
        elseif fit_b==2
            % Makes a single-exponential curve fit to the data, with an immobile
            % fraction of molecules
            pk=lsqnonlin(@(p) fkn_dbl_exp_fit_k(p,t,y,k2),p0,...
                [0,-realmin,-realmin,-Inf*ones(1,length(k2)*2)],...
                [Inf,realmin,realmin,Inf*ones(1,length(k2)*2)],options);
        else
            % Makes a single-exponential curve fit to the data, without an immobile
            % fraction of molecules
            pk=lsqnonlin(@(p) fkn_dbl_exp_fit_k(p,t,y,k2),p0,...
                [-realmin,-realmin,-realmin,-Inf(1,length(k2)*2)],...
                [realmin,realmin,realmin,Inf*ones(1,length(k2)*2)],options);
        end
        [dy,y_fit_k]=fkn_dbl_exp_fit_k(pk,t,y,k2);

        figure(4)
        ax1 = gca;
        set(ax1,'FontSize',12)
        plot(t,y,'b.',t,y_fit_k,'r-','LineWidth',2)
        xlabel('Time [s]','FontSize',12)
        ylabel('Hankel transform [a.u.]','FontSize',12)
        title('Individual curve fits to all Hankel transforms','FontSize',12)
        axis tight

        D1k=pk(4:2:end);    % D1(k)
        figure(5)
        ax1 = gca;
        set(ax1,'FontSize',12)
        plot(k2,D1k,'r.','MarkerSize',10)
        maxD1k=max(D1k);
        xlabel('k [\mum^{-1}]','FontSize',12)
        ylabel('D [\mum^2s^{-1}]','FontSize',12)
        % The title of the plot stats the values of D2, gamma2 and gamma0 that are
        % common for all k
        title(['D_2 = ',num2str(pk(2)),' \mum^2s^{-1}, ',...
            '\gamma_2 = ',num2str(pk(3)),', ',...
            '\gamma_0 = ',num2str(pk(1))],'FontSize',12)
        axis tight
        ylim([0,1.5*maxD1k])

    end

% btn_ellipse_Callback - calculates the ellipticity of the bleached spot from the moments of
%   inertia and the product of inertia
    function btn_ellipse_Callback(source,eventdata)

        Imax=(Ixx+Iyy)/2+sqrt((Ixx-Iyy).^2+4*Ixy.^2)/2;
        Imin=(Ixx+Iyy)/2-sqrt((Ixx-Iyy).^2+4*Ixy.^2)/2;
        
        % Calculates the angle between the x-axis and the major semi-axis
        % of the ellipse
        theta=0.5*atan(2*Ixy./(Iyy-Ixx));
        Ix2=(Ixx+Iyy)/2+(Ixx-Iyy)/2.*cos(2*theta)-Ixy.*sin(2*theta);
        Iy2=(Ixx+Iyy)/2-(Ixx-Iyy)/2.*cos(2*theta)+Ixy.*sin(2*theta);
        theta(Ix2>Iy2)=theta(Ix2>Iy2)+pi/2;
        for i=2:length(theta)
            while (theta(i)-theta(i-1))>pi/2
                theta(i)=theta(i)-pi;
            end  
            while (theta(i)-theta(i-1))<-pi/2
                theta(i)=theta(i)+pi;
            end
        end

        figure(6)
        ax1 = gca;
        set(ax1,'FontSize',12)
        plot(t,sqrt(Imax./Imin),'b+','LineWidth',2)
        xlabel('t [s]','FontSize',12)
        ylabel('(I_{max}/I_{min})^{0.5}','FontSize',12)
        xlim([min(t),max(t)])
        title('The ellipticity of the bleached spot','FontSize',12)

        figure(7)
        ax1 = gca;
        set(ax1,'FontSize',12)
        plot(t,theta*180/pi,'b+','LineWidth',2)
        xlabel('t [s]','FontSize',12)
        ylabel('\theta [degrees]','FontSize',12)
        xlim([min(t),max(t)])
        title('The angle of I_{max} relative to the x-axis','FontSize',12)

    end

% btn_vel_Callback - calculates the convective velocity of the bleached
% spot
    function btn_vel_Callback(source,eventdata)

        if trc=='y'
            % the x- and y-velocities are calculated from a linear fit to the
            % movements in the center of mass
            x_cm2=(x_cm-x_cm(1))*dx;
            y_cm2=(y_cm-y_cm(1))*dx;
            
            cx=polyfit(t,x_cm2,1);
            x_cm_f=polyval(cx,t);
            vx=cx(1);
            cy=polyfit(t,y_cm2,1);
            y_cm_f=polyval(cy,t);
            vy=cy(1);
            
            v_conv=sqrt(vx.^2+vy.^2);
            a_conv=atan(vy/vx)*180/pi;
           
            figure(8)
            ax1 = gca;
            set(ax1,'FontSize',12)
            h=plot(t,x_cm2,'bv',t,y_cm2,'ro',t,x_cm_f,'b-',t,y_cm_f,'r-','LineWidth',2);
            set(h(1),'MarkerFaceColor','b','MarkerSize',6,'LineWidth',1)
            set(h(2),'MarkerFaceColor','r','MarkerSize',6,'LineWidth',1)
            xlabel('t [s]','FontSize',12)
            ylabel('Position [\mum]','FontSize',12)
            legend('x','y',2)
            xlim([min(t),max(t)])
            title(['v = ',num2str(v_conv),' \mum/s at ',...
                num2str(a_conv),'\circ angle'],'FontSize',12)
        end
    end
end
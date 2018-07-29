function [t, Sig, Tau, Eps]=Stress2Strain

%The function [T, SIG, TAU, EPS] = STRESS2STRAIN creates an interface 
%that allows computing strain courses EPS from stress courses SIG and TAU 
%using the incremental kinematic model of material hardening
%which was formulated by Mróz-Garud [1]. 
%Where: SIG is vector of normal stress course, TAU is vector of shear
%stress course, EPS is array of strain courses of the following order:
%[Eps_x(:) Eps_xy(:) Eps_y(:)] (x - the direction of SIG).
%
%This model is based on the Mróz idea [2] who introduced the plastic modulus fields.
%According to this idea for the one-dimensional case, 
%the non-linear curve of cyclic strain (strain - stress) is replaced
%by a sequence of linear segments. Each linear segment has its own modulus of plasticity
%(C(0), C(1), C(2), . . ., C(m-1)). The points on the new linearized 
%curve of cyclic strain where moduli of plasticity change, 
%determine fields with constant moduli of plasticity (fields of moduli of plasticity).
%The surfaces f(1), f(2), . . ., f(m) with constant module of plasticity are reduced
%to circles in the case of selection of a proper scale and application of the Huber-Mises-Hencky 
%condition of plasticity (H-M-H). The Mróz-Garud model assumes that the material 
%is homogeneous, isotropic, and influence of the loading rate can be neglected. 
%Moreover, the model does not include thermal phenomena and assumes 
%constancy of the Young's and Poisson's module.  
%
%The algorithm applies the following rules:
%The yield criterion: Huber-Mises-Hencky 
%The flow rule: Normal 
%The hardening rule: Mróz-Garud [2,3]
%
%The program accepts only two stress components: normal stress (e.g.
%SIG, i.e. \sigma_{xx}(t)) and shear stress (i.e. \tau_{xy}(t)). The outputs are:
%strain components: \epsilon{xx}(t), \epsilon{xy}(t), \espilon_{yy}.
%
%Material properties are based on Ramberg-Osgood relation:
%Eps_a = Sig_a/E+(Sig/K')^{1/n'},
%where three coefficients are required: K' (MPa), n' (-), E (MPa)
%The Ramberg-Osgood relation is replaced by sequence of linear segments.
%
%The stress courses are generated using sinusoidal shape.
%If you deal with non-proportional loading it is necessary to use option:
%'Slow start' which forces the initial stress state to be SIG = 0 and TAU = 0
%
%If you used this program or any of the included functions for scientific 
%purpose please respect my effort and cite the paper [3] in which the
%algorithm  was applied.
%
% [1] Garud Y.S. Prediction of stress-strain response under general multiaxial loading, 
%     Mechanical Testing for Deformation Model Development, ASTM STP 765, 1982, pp. 223-238.
% [2] Mróz Z. On the description of anisotropic work hardening., 
%     J. Appl. Phys. Solids, 15, 1967, pp.163-175
% [3] Karolczuk A. Non-local area approach to fatigue life
%     evaluation under combined reversed bending and torsion, 
%     International Journal of Fatigue, 30, 2008, pp. 1985-1996.
%
%Author: Aleksander Karolczuk, 14 August 2009, a.karolczuk@po.opole.pl
%Opole University of Technology, Poland


%--Main figure-------------------------------------------%
fh = figure('Name','Stress courses generation. Copyright: a.karolczuk@po.opole.pl',...
    'Position',[0,40,990,650],...
    'Resize', 'off',...
    'Toolbar','none',...
    'Menubar','none','Color',[0.941176 0.941176 0.941176]);

%--Panels------------------------------------------------%
panel1 = uipanel('Parent',fh,'Title','',...
    'Position',[.01 .91 .6 .08]);
panel2 = uipanel('Parent',fh,'Title','Courses of stresses and strains',...
    'Position',[.01 .01 .6 .89]);
panel3 = uipanel('Parent',fh,'Title','Hystersis loops',...
    'Position',[.62 .52 .37 .48]);
panel4 = uipanel('Parent',fh,'Title','Yield surfaces',...
    'Position',[.62 .01 .37 .51]);

%--Axes--------------------------------------------------%
axeshSig = axes('Parent',panel2,'units','normalized',...
    'Box','on',...
    'Fontsize',8,...
    'Position',[0.09 0.57 0.88 0.4]);
hStress=plot(0,0,'.-k',0,0,'.-r',0,0,'-k',0,0,'-r',0,0,'--b');
xlabel('Time, s')
ylabel('\sigma(t), \tau(t), MPa')
set(hStress([3 4]),'linewidth',3)      

axeshEps = axes('Parent',panel2,'units','normalized',...
    'Box','on',...
    'Fontsize',8,...
    'Position',[0.09 0.08 0.88 0.4]);
hEps=plot(0,0,'.-k',0,0,'.-r',0,0,'.-g');
xlabel('Time, s')
ylabel('\epsilon(t), -')
legend('\epsilon_{xx}', '\epsilon_{xy}', '\epsilon_{yy}')
       
axeshLoop = axes('Parent',panel3,'units','normalized',...
    'Box','on',...
    'Fontsize',8,...
    'Position',[0.15 0.15 0.81 0.82]);
hLoop=plot(0,0,'-k',0,0,'-r',0,0,'ok',0,0,'or');
xlabel('\epsilon(t), -')
ylabel('\sigma(t), \tau(t), MPa')

axeshSurf = axes('Parent',panel4,'units','normalized',...
    'Box','on',...
    'Fontsize',8,...
    'Position',[0.13 0.14 0.83 0.83]);
set(get(axeshSurf,'xlabel'),'string','\surd 3 \tau(t), MPa','fontsize',8)
set(get(axeshSurf,'ylabel'),'string','\sigma(t), MPa','fontsize',8)


%---buttons----------------------------------------%
bhStress = uicontrol(panel1,'Units','pixel',...
    'Position',[10 8 120 35],...
    'String','Stress generation',...
    'Callback',@buttonStress);

bhMaterial = uicontrol(panel1,'Units','pixel',...
    'Position',[152 8 92 35],...
    'String','Material',...
    'Callback',@buttonMaterial);

bhRun = uicontrol(panel1,'Units','pixel',...
    'Position',[264 8 92 35],...
    'Enable','off',...
    'String','Run',...
    'Callback',@buttonRun);

bhExport = uicontrol(panel1,'Units','pixel',...
    'Position',[376 8 92 35],...
    'Enable','off',...
    'String','Export',...
    'Callback',@buttonExport);

bhOk = uicontrol(panel1,'Units','pixel',...
    'Position',[488 8 92 35],...
    'String','Close',...
    'Callback',@buttonOK);

uiwait(fh);


%--------------------------------------------------%

    function buttonMaterial(hObject,eventdata)
        
        mate = matproperty;
        axes(axeshSurf)
        hsurfaces=staticsurfimage(mate.R);
        set(hObject,'userdata',1)
        setappdata(hObject,'mate',mate) 
        setappdata(hObject,'hsurfaces',hsurfaces) 
        if get(bhStress,'userdata')==1,
            set(bhRun,'enable','on')
        end
    end


%--------------------------------------------------%
    function buttonStress(hObject,eventdata)
        
        [t, Sig, Tau] = stressgener;
        
        set(hStress(1),'xdata',t,'ydata',Sig);
        set(hStress(2),'xdata',t,'ydata',Tau);
        set(axeshSig,'xlim',[0 t(end)])
         
        set(hObject,'userdata',1)
        if get(bhMaterial,'userdata')==1,
            set(bhRun,'enable','on')
        end
    end

%-------------------------------------------------%
    function buttonOK(hObject,eventdata)
        close(fh)
    end
%-------------------------------------------------%
    function buttonRun(hObject,eventdata)
        
        set(axeshEps,'xlim',[0 t(end)])
        
        mate = getappdata(bhMaterial,'mate');
        surfaces = getappdata(bhMaterial,'hsurfaces');
        
        a(1:length(mate.R),9)=0;
        i=0;
        Eps=zeros(length(t),9);
        
        fi=0:pi/80:2*pi;
        
        for j=1:length(t)-1,
            Sig_start=[Sig(j) 0 0 Tau(j) 0 0 Tau(j) 0 0];
            Dsig=[Sig(j+1)-Sig(j) 0 0 Tau(j+1)-Tau(j) 0 0 Tau(j+1)-Tau(j) 0 0];
            [DEps, i, a]=MGstress2s_en(Sig_start, Dsig, i, a, mate);
            Eps(j+1,:)=Eps(j,:)+DEps;
            
            for k=1:length(mate.R);
                x=mate.R(k)*cos(fi);
                y=mate.R(k)*sin(fi);
                ay=1.5*a(k,1);
                ax=sqrt(3)*a(k,4);
                set(surfaces(k),'xdata',x+ax,'ydata',y+ay)
            end
            
            set(hStress(3),'xdata',t(1:j+1),'ydata',Sig(1:j+1))
            set(hStress(4),'xdata',t(1:j+1),'ydata',Tau(1:j+1))
            set(hStress(5),'xdata',t(j+1)*[1 1],'ydata',get(axeshSig,'ylim'))
            
            set(hEps(1),'xdata',t(1:j+1),'ydata',Eps(1:j+1,1))
            set(hEps(2),'xdata',t(1:j+1),'ydata',Eps(1:j+1,4))
            set(hEps(3),'xdata',t(1:j+1),'ydata',Eps(1:j+1,2))
            
            set(hLoop(1),'xdata',Eps(1:j+1,1),'ydata',Sig(1:j+1))
            set(hLoop(2),'xdata',Eps(1:j+1,4),'ydata',Tau(1:j+1))
            set(hLoop(3),'xdata',Eps(j+1,1),'ydata',Sig(j+1))
            set(hLoop(4),'xdata',Eps(j+1,4),'ydata',Tau(j+1))
            
            set(surfaces(k+1),'ydata',Sig(j+1),'xdata',sqrt(3)*Tau(j+1))
            
            drawnow expose
        end
        Eps=[Eps(:,1) Eps(:,4) Eps(:,2)];
        set(bhExport,'enable','on')
        
    end
%--------------------------------------------------%
    function buttonExport(hObject,eventdata)

        X=[t(:) Sig(:) Tau(:) Eps];
        f = msgbox('Order of saving variables: [t Sig Tau Eps_x Eps_xy Eps_y]');
        uiwait(f)
        [file,path] = uiputfile('*.dat','Save: [t Sig Tau Eps_x Eps_xy Eps_y]');
        save([path file], 'X', '-ASCII')
    end
%--------------------------------------------------%
    function h=staticsurfimage(R)
        
        fi=0:pi/80:2*pi;
        for i=length(R):-1:1;
            x=R(i)*cos(fi);
            y=R(i)*sin(fi);
            h(i)=patch(x,y,i); hold on,
        end
        h(end+1)=plot(0,0,'ok','markerfacecolor','r','markersize',8);
        h(end+1)=plot(0,0,'--k');
        axis equal
        axis tight
    end
end
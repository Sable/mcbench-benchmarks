function euler_rule(ha)

hac=get(ha,'children');
for hacc=1:length(hac)
    if ishandle(hac(hacc))
        delete(hac(hacc));
    end
end
 
% test string
status=text('parent',ha,'Position',[0,0.68],'Interpreter','tex','String','Load...','HorizontalAlignment','left','VerticalAlignment','bottom');
ttsz=get(status,'Extent');
tsz=165*ttsz(3);
%tsz=100*ttsz(3);
drawnow;
delete(status);

xsh=-0.1;

status=text('parent',ha,'Position',[xsh,1.07],'Interpreter','latex','String','','HorizontalAlignment','left','VerticalAlignment','top');

%get(status,'FontSize'); % =10

%ssz(4)  % =768
%10*ssz(4)/768
set(status,'FontUnits','points','FontSize',tsz);

sa={};


sa={sa{:},'Euler angles $(\phi,\theta,\psi)$ to axis-angle $(\overrightarrow{n},\gamma,\delta,\alpha)$'};

sa={sa{:},' '};

sa={sa{:},['$R_E=R(z,\phi){\cdot}R(x,\theta){\cdot}R(z,\psi)=$']};

sa={sa{:},' '};

sa={sa{:},'$=\left[ \begin {array}{ccc} \cos \phi \;\;&\;\; -\sin \phi \;\;&\;\; 0 \\\noalign{\medskip} \sin \phi \;\;&\;\; \cos \phi \;\;&\;\; 0 \\\noalign{\medskip} 0 \;\;&\;\; 0 \;\;&\;\; 1 \end {array} \right]{\cdot}\left[ \begin {array}{ccc} 1 \;\;&\;\; 0 \;\;&\;\; 0 \\\noalign{\medskip} 0 \;\;&\;\; \cos \theta \;\;&\;\; -\sin \theta \\\noalign{\medskip} 0 \;\;&\;\; \sin \theta \;\;&\;\; \cos \theta \end {array} \right]{\cdot}\left[ \begin {array}{ccc} \cos \psi \;\;&\;\; -\sin \psi \;\;&\;\; 0 \\\noalign{\medskip} \sin \psi \;\;&\;\; \cos \psi \;\;&\;\; 0 \\\noalign{\medskip} 0 \;\;&\;\; 0 \;\;&\;\; 1 \end {array} \right]$'};

set(status,'Interpreter','latex','String',sa);

sa={};

sa={sa{:},'$\overrightarrow{v}=\left[ \begin {array}{c} (\cos (\phi-\psi) +1)(1-\cos \theta) \\\noalign{\medskip} \sin (\phi-\psi)(1-\cos \theta) \\\noalign{\medskip} \sin \theta (\sin \phi + \sin \psi) \end {array} \right]$'};


stex=get(status,'Extent');
status2=text('parent',ha,'Position',[xsh,stex(2)-stex(4)+0],'Interpreter','latex','String','','HorizontalAlignment','left','VerticalAlignment','top');
set(status2,'FontUnits','points','FontSize',tsz);

set(status2,'Interpreter','latex','String',sa);


sa={};

sa={sa{:},'$\gamma= \arctan  \frac {v_y} {v_x}$'};

sa={sa{:},' '};

sa={sa{:},'$\delta= \arctan  \frac {v_z} {\sqrt{{v_x}^2+{v_y}^2}}$'};

stex2=get(status2,'Extent');

status3=text('parent',ha,'Position',[stex2(1)+1.1*stex2(3),stex(2)-stex(4)-0.02],'Interpreter','latex','String','','HorizontalAlignment','left','VerticalAlignment','top');
set(status3,'FontUnits','points','FontSize',tsz);

set(status3,'Interpreter','latex','String',sa);

sa={};

sa={sa{:},'if $\theta=0$ then $v_x=0\;\;\;v_y=0\;\;\;v_z=1 $'};

sa={sa{:},' '};

sa={sa{:},'$\overrightarrow{n}=\frac{\overrightarrow{v}}{|\overrightarrow{v}|}$'};

sa={sa{:},' '};

sa={sa{:},'$\alpha=\arctan  \frac {-\epsilon_{ijk}{R_E}_{ij}n_k} {Tr(R_E)-1}$'};


status4=text('parent',ha,'Position',[xsh,stex2(2)-stex2(4)+0],'Interpreter','latex','String','','HorizontalAlignment','left','VerticalAlignment','top');
set(status4,'FontUnits','points','FontSize',tsz);

set(status4,'Interpreter','latex','String',sa);


drawnow;
%correct font size one more time:
exe=get(status4,'Extent');
dy=1-exe(2);
fzm=0.6/dy; % font zoom factor
tsz=fzm*tsz; % zoom font
set(status,'Position',[xsh,1.07],'fontsize',tsz);
stex=get(status,'Extent');
set(status2,'Position',[xsh,stex(2)-stex(4)+0],'fontsize',tsz);
stex2=get(status2,'Extent');
set(status3,'Position',[stex2(1)+1.1*stex2(3),stex(2)-stex(4)-0.02],'fontsize',tsz);
set(status4,'Position',[xsh,stex2(2)-stex2(4)+0]);
set(status4,'FontUnits','points','FontSize',tsz);
% rectangle('Position',stex,'parent',ha);
% rectangle('Position',stex2,'parent',ha);
% rectangle('Position',exe,'parent',ha);
%get(status3,'Units')
drawnow;

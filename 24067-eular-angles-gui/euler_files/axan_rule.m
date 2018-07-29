function axan_rule(ha)



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

sa={sa{:},'axis-angle $(\overrightarrow{n},\gamma,\delta,\alpha)$ to Euler angles $(\phi,\theta,\psi)$'};

sa={sa{:},' '};

sa={sa{:},['$\psi= \arctan  \frac {\sin \delta \cos \gamma (1-\cos \alpha)-\sin \alpha \sin \gamma} {\sin \delta \sin \gamma (1- \cos \alpha)+\sin \alpha \cos \gamma}$']};

sa={sa{:},' '};

sa={sa{:},['$\phi= \arctan  \frac {\sin \delta \cos \gamma (1-\cos \alpha)+\sin \gamma \sin \alpha}{\cos \gamma \sin \alpha - \sin \gamma \sin \delta + \sin \delta \sin \gamma \cos \alpha}$']};



set(status,'Interpreter','latex','String',sa);

sa={};

sa={sa{:},'$|\theta|= \arccos (\sin^2 \delta + \cos^2 \delta \cos \alpha)$'};

sa={sa{:},' '};

sa={sa{:},'if $\frac{\sin \delta \cos \gamma (1-\cos \alpha)-\sin \alpha \sin \gamma}{\sin \psi} \geq 0$ then $\theta \geq 0$'};

sa={sa{:},' '};

sa={sa{:},'if $\frac{\sin \delta \cos \gamma (1-\cos \alpha)-\sin \alpha \sin \gamma}{\sin \psi} < 0$ then $\theta < 0$'};

stex=get(status,'Extent');
status2=text('parent',ha,'Position',[xsh,stex(2)-stex(4)+0],'Interpreter','latex','String','','HorizontalAlignment','left','VerticalAlignment','top');
set(status2,'FontUnits','points','FontSize',tsz);

set(status2,'Interpreter','latex','String',sa);


drawnow;
%correct font size one more time:
exe=get(status2,'Extent');
dy=1-exe(2);
fzm=0.3/dy; % font zoom factor
tsz=fzm*tsz; % zoom font
set(status,'Position',[xsh,1.07],'fontsize',tsz);
stex=get(status,'Extent');
set(status2,'Position',[xsh,stex(2)-stex(4)+0],'fontsize',tsz);
stex2=get(status2,'Extent');
drawnow;


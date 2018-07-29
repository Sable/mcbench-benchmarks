function quat_rule(ha)

%set(ha,'UserData',[nx,ny,nz,alpha]);
nxyza=get(ha,'UserData');
nx=nxyza(1);
ny=nxyza(2);
nz=nxyza(3);
alpha=nxyza(4);


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

sa={sa{:},'Quaternion form'};

sa={sa{:},' '};

q1=cos(alpha/2);
q2=nx*sin(alpha/2);
q3=ny*sin(alpha/2);
q4=nz*sin(alpha/2);
sc=num2str(q1);
si=num2str(q2);
sj=num2str(q3);
sk=num2str(q4);
if si(1)~='-'
    si=['+' si];
end

if sj(1)~='-'
    sj=['+' sj];
end

if sk(1)~='-'
    sk=['+' sk];
end
sa={sa{:},['$q = \cos \frac {\alpha} {2} + \sin \frac {\alpha} {2} n_x i + \sin \frac {\alpha} {2} n_y j + \sin \frac {\alpha} {2} n_z k=$']};


sa={sa{:},' '};

sa={sa{:},['$=' sc  si 'i' sj 'j' sk 'k' '$']};

sa={sa{:},' '};

sa={sa{:},['see quaternion calculator']};



set(status,'Interpreter','latex','String',sa);



stex=get(status,'Extent');



drawnow;
%correct font size one more time:
exe=get(status,'Extent');
dy=1-exe(4);
fzm=1/dy; % font zoom factor
tsz=fzm*tsz; % zoom font
set(status,'Position',[xsh,1.07],'fontsize',tsz);

drawnow;


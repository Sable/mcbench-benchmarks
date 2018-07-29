function rules(nx,ny,nz,alpha)

ssz=get(0,'ScreenSize');

hf=figure;
x0=ssz(3)/2;
y0=ssz(4)/2;
kfsz=0.9;
fpos=[x0-kfsz*ssz(3)/2 y0-kfsz*ssz(4)/2 kfsz*ssz(3) kfsz*ssz(4)];
set(hf,'MenuBar','none','Color',[1 1 1],'name','rules','NumberTitle','off','units','pixels','position',fpos);

ha = axes('parent',hf);
set(ha,'Visible','off');

set(ha,'UserData',[nx,ny,nz,alpha]);

% menu:
 hm=uimenu(hf,'Label','Save Image / Print');
    uimenu(hm,'Label','Save Image As...','Callback',['save_im(' num2str(hf) ')']);
    uimenu(hm,'Label','Page Setup...','Callback',['pgs(' num2str(hf) ')'],'Separator','on');
    uimenu(hm,'Label','Print Preview...','Callback',['pp(' num2str(hf) ')']);
    uimenu(hm,'Label','Print...','Callback',['pd('  num2str(hf) ')']);
    

euler_rule(ha);


h1 = uicontrol('Style', 'pushbutton', 'String', 'Euler to axis angle',...
    'Position', [0.25*fpos(3) 0.03*fpos(4) 0.2*fpos(4) 0.04*fpos(4)], 'Callback', ['euler_rule(' num2str(ha,'%20.20e') ')']);

h2 = uicontrol('Style', 'pushbutton', 'String', 'axis angle to Euler',...
    'Position', [0.45*fpos(3) 0.03*fpos(4) 0.2*fpos(4) 0.04*fpos(4)], 'Callback', ['axan_rule(' num2str(ha,'%20.20e') ')']);

h3 = uicontrol('Style', 'pushbutton', 'String', 'quatenion form',...
    'Position', [0.65*fpos(3) 0.03*fpos(4) 0.2*fpos(4) 0.04*fpos(4)], 'Callback', ['quat_rule(' num2str(ha,'%20.20e') ')']);
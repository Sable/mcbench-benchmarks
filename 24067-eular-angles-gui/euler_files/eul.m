function fig=eul

clear
global axsz ts rhs lr rhs1 lr1 xs xst ys yst zs zst ks phi theta psi rad deg cl x y z gamma delta alpha vna vnat N Nt xb xbt yb ybt zb zbt sXYZ sxyz sav sN arcR arcth arctxtR phia1 phia2 phiat sa thetaa1 thetaa2 thetaat psia1 psia2 psiat gammaa1 gammaa2 gammaat saa deltaa1 deltaa2 deltaat arcvsh alphaa1 alphaa2 alphaat arcR1 arcth1 arctxtR1
ks=0.8; % in how much times xyz arrows smaller than XYZ



sz=get(0,'ScreenSize');
% -3 39 1024 660
% 1 1 1024 768
% 768-660=108

clr=[0.8313725490196079   0.8156862745098039   0.7843137254901961]; % background color
clr1=[0.6 0.6 0.6];


% empty figure initalization:
xc=sz(1)+sz(3)/2;
yc=sz(2)+sz(4)/2;
kz=0.9;
fig=figure('position',[xc-kz*sz(3)/2 yc-kz*sz(4)/2 kz*sz(3) kz*sz(4)],'MenuBar','none',...
    'name','Euler angles','NumberTitle','off',...
    'Color',clr);

unit=0.005;

x0=0.1;
y0=0.9;



% axes for symbols:
afsy0=0.7;
afsyl=1-afsy0;
pos=[0 afsy0 1 1-afsy0];
afs=axes('parent',fig,...
    'XTickLabel',[],...
    'YTickLabel',[],...
    'units','normalized','fontunits','normalized',...
    'Position',pos,...
    'Visible','off');


xt=x0-3*unit;
yt=y0+9*unit; yea=yt; % memorize
dx=21*unit;
dy=6*unit;
uicontrol('parent',fig,...
    'Style','text','units','normalized','fontunits','normalized',...
    'HorizontalAlignment','center',...
    'fontsize',0.8,...
    'position',[xt yt dx dy],'string','Euler angles');


clb='enter_eul_angs'; % from euler angles to axis-angle callback


xt=x0;
yt=y0;

% phi edit
dx=16*unit;
dy=6*unit;
phi=editpm(fig,xt,yt,dx,dy,'0',clb);

tphi=text('parent',afs,'position',[xt (yt-afsy0)/afsyl],'string','\phi ',...
    'HorizontalAlignment','right',...
    'VerticalAlignment','middle');


yt=yt-2*dy;

% theta edit
theta=editpm(fig,xt,yt,dx,dy,'0',clb);

ttheta=text('parent',afs,'position',[xt (yt-afsy0)/afsyl],'string','\theta ',...
    'HorizontalAlignment','right',...
    'VerticalAlignment','middle');


yt=yt-2*dy;

% psi edit
psi=editpm(fig,xt,yt,dx,dy,'0',clb);

tpsi=text('parent',afs,'position',[xt (yt-afsy0)/afsyl],'string','\psi ',...
    'HorizontalAlignment','right',...
    'VerticalAlignment','middle');

yt=yt-2*dy;
dx=16*unit;
xt=xt-5*unit;

% set zeros
cl=uicontrol('parent',fig,...
    'Style','pushbutton','units','normalized','fontunits','normalized',...
    'BackgroundColor',clr,...
    'HorizontalAlignment','center',...
    'fontsize',0.8,...
    'position',[xt yt dx dy],'string','set zeros',...
    'callback','set_zeros');


clbi='enter_ax_an_angs'; % from axis-angle to Euler angle


xt=x0+70*unit;;
yt=y0-7*unit;


dx=17*unit;
dy=6*unit;
uicontrol('parent',fig,...
    'Style','text','units','normalized','fontunits','normalized',...
    'HorizontalAlignment','left',...
    'fontsize',0.8,...
    'position',[xt+25*unit yea dx dy],'string','axis-angle');


dx=12*unit;
dy=6*unit;
uicontrol('parent',fig,...
    'Style','text','units','normalized','fontunits','normalized',...
    'HorizontalAlignment','left',...
    'fontsize',0.8,...
    'position',[xt+1*unit yt+6*unit dx dy],'string','axis v');

% X edit
dx=3*unit;
dy=6*unit;
uicontrol('parent',fig,...
    'Style','text','units','normalized','fontunits','normalized',...
    'HorizontalAlignment','right',...
    'fontsize',0.8,...
    'position',[xt-dx yt-dy/2 dx dy],'string','X ');
dx=16*unit;
dy=6*unit;
x=editpm2(fig,xt,yt,dx,dy,'0','');

yt=yt-2*dy;

ytY=yt; % memorize

% Y edit
dx=3*unit;
dy=6*unit;
uicontrol('parent',fig,...
    'Style','text','units','normalized','fontunits','normalized',...
    'HorizontalAlignment','right',...
    'fontsize',0.8,...
    'position',[xt-dx yt-dy/2 dx dy],'string','Y ');
dx=16*unit;
dy=6*unit;
y=editpm2(fig,xt,yt,dx,dy,'0','');

yt=yt-2*dy;


% Z edit
dx=3*unit;
dy=6*unit;
uicontrol('parent',fig,...
    'Style','text','units','normalized','fontunits','normalized',...
    'HorizontalAlignment','right',...
    'fontsize',0.8,...
    'position',[xt-dx yt-dy/2 dx dy],'string','Z ');
dx=16*unit;
dy=6*unit;
z=editpm2(fig,xt,yt,dx,dy,'1','');

xt1=xt;

yt=ytY;
xt=xt+30*unit;
yt=yt+1*dy;

% gamma edit
dx=16*unit;
dy=6*unit;
gamma=editpm(fig,xt,yt,dx,dy,'0',clbi);

tgamma=text('parent',afs,'position',[xt (yt-afsy0)/afsyl],'string','\gamma ',...
    'HorizontalAlignment','right',...
    'VerticalAlignment','middle');


yt=yt-2*dy;

% delta edit
delta=editpm(fig,xt,yt,dx,dy,'0',clbi);

tdelta=text('parent',afs,'position',[xt (yt-afsy0)/afsyl],'string','\delta ',...
    'HorizontalAlignment','right',...
    'VerticalAlignment','middle');

yt=ytY;
xt=xt1+70*unit;

% alpha edit
dx=10*unit;
dy=6*unit;
uicontrol('parent',fig,...
    'Style','text','units','normalized','fontunits','normalized',...
    'HorizontalAlignment','right',...
    'fontsize',0.8,...
    'position',[xt-dx-4*unit yt-dy/2 dx dy],'string','angle ');
talpha=text('parent',afs,'position',[xt (yt-afsy0)/afsyl],'string','\alpha ',...
    'HorizontalAlignment','right',...
    'VerticalAlignment','middle');
dx=16*unit;
dy=6*unit;
alpha=editpm(fig,xt,yt,dx,dy,'0',clbi);




% rad/deg
xt=x0+30*unit;
yt=y0-10*unit;
dx=21*unit;
dy=15*unit;
pnl=uibuttongroup('parent',fig,...
    'units','normalized','fontunits','normalized',...
    'fontsize',0.8,...
    'position',[xt yt dx dy]);

dx=18*unit;
dy=7*unit;

rad=uicontrol('parent',pnl,...
    'Style','radio','units','normalized','fontunits','normalized',...
    'HorizontalAlignment','right',...
    'fontsize',0.7,...
    'position',[0.01 0.5 1 0.5],'string','radians','value',false);

deg=uicontrol('parent',pnl,...
    'Style','radio','units','normalized','fontunits','normalized',...
    'HorizontalAlignment','right',...
    'fontsize',0.7,...
    'position',[0.01 0 1 0.5],'string','degrees','value',true);

% red/deg callback
set(pnl,'SelectionChangeFcn',['rad_deg_clb(' num2str(fig,'%20.20e') ',' num2str(deg,'%20.20e')  ')']);
rad_deg_clb(fig,deg); % for initial value

yt=yt-10*unit;

dx=15*unit;
dy=6*unit;

% rules
rl=uicontrol('parent',fig,...
    'Style','pushbutton','units','normalized','fontunits','normalized',...
    'BackgroundColor',clr,...
    'HorizontalAlignment','center',...
    'fontsize',0.8,...
    'position',[xt yt dx dy],'string','rules...',...
    'callback',['rules1']);

% axes:
afsy0=0.7;
afsyl=1-afsy0;
pos=[0.05 0.05 0.5 afsy0-0.07];
ax=axes('parent',fig,...
    'XTickLabel',[],...
    'YTickLabel',[],...
    'units','normalized','fontunits','normalized',...
    'Position',pos,...
    'View',[120 30],...
    'Visible','on','NextPlot','add');

xt=x0+120*unit;
yt=y0-60*unit;

dx=22*unit;
dy=8*unit;

% rotate view
rv=uicontrol('parent',fig,...
    'Style','togglebutton','units','normalized','fontunits','normalized',...
    'BackgroundColor',clr,...
    'HorizontalAlignment','center',...
    'fontsize',0.6,...
    'position',[xt yt dx dy],'string','rotate view',...
    'callback','');

yt=yt-1.5*dy;

% zoom view
zv=uicontrol('parent',fig,...
    'Style','togglebutton','units','normalized','fontunits','normalized',...
    'BackgroundColor',clr,...
    'HorizontalAlignment','center',...
    'fontsize',0.6,...
    'position',[xt yt dx dy],'string','zoom view',...
    'callback','');

yt=yt-1.5*dy;

% zoom 2x
z2x=uicontrol('parent',fig,...
    'Style','togglebutton','units','normalized','fontunits','normalized',...
    'BackgroundColor',clr,...
    'HorizontalAlignment','center',...
    'fontsize',0.6,...
    'position',[xt yt dx dy],'string','zoom 2x',...
    'callback','');

yt=yt-1.5*dy;

% pan view
pv=uicontrol('parent',fig,...
    'Style','togglebutton','units','normalized','fontunits','normalized',...
    'BackgroundColor',clr,...
    'HorizontalAlignment','center',...
    'fontsize',0.6,...
    'position',[xt yt dx dy],'string','pan view',...
    'callback','');



set(rv,'Callback',['rot_view(' num2str(rv,'%20.20e') ',' num2str(zv,'%20.20e') ',' num2str(pv,'%20.20e') ',' num2str(z2x,'%20.20e') ')']);
set(zv,'Callback',['zoom_view(' num2str(rv,'%20.20e') ',' num2str(zv,'%20.20e') ',' num2str(pv,'%20.20e') ',' num2str(z2x,'%20.20e') ')']);
set(z2x,'Callback',['z2x_view(' num2str(rv,'%20.20e') ',' num2str(zv,'%20.20e') ',' num2str(pv,'%20.20e') ',' num2str(z2x,'%20.20e') ',' num2str(ax,'%20.20e') ')']);
set(pv,'Callback',['pan_view(' num2str(rv,'%20.20e') ',' num2str(zv,'%20.20e') ',' num2str(pv,'%20.20e') ',' num2str(z2x,'%20.20e') ')']);

yt=yt-2.5*dy;

ytf=yt; % memorize this yt

dx=40*unit;
dy=6*unit;
xt=xt-5*unit;

% show xyz
sxyz=uicontrol('parent',fig,...
    'Style','checkbox','units','normalized','fontunits','normalized',...
    'BackgroundColor',clr,...
    'HorizontalAlignment','center',...
    'fontsize',0.8,...
    'position',[xt yt dx dy],'string','show xyz',...
    'Value',true,...
    'Callback','enter_eul_angs');

yt=yt-1.5*dy;

% show XYZ
sXYZ=uicontrol('parent',fig,...
    'Style','checkbox','units','normalized','fontunits','normalized',...
    'BackgroundColor',clr,...
    'HorizontalAlignment','center',...
    'fontsize',0.8,...
    'position',[xt yt dx dy],'string','show XYZ',...
    'Value',true,...
    'Callback','XYZ_visibility');

yt=yt-1.5*dy;





% show Euler angles
sa=uicontrol('parent',fig,...
    'Style','checkbox','units','normalized','fontunits','normalized',...
    'BackgroundColor',clr,...
    'HorizontalAlignment','center',...
    'fontsize',0.8,...
    'position',[xt yt dx dy],'string','show Euler angles',...
    'Value',true,...
    'Callback','enter_eul_angs');

yt=yt-1.5*dy;





% show line of nodes
sN=uicontrol('parent',fig,...
    'Style','checkbox','units','normalized','fontunits','normalized',...
    'BackgroundColor',clr,...
    'HorizontalAlignment','center',...
    'fontsize',0.8,...
    'position',[xt yt dx dy],'string','show line of nodes N',...
    'Value',true,...
    'Callback','enter_eul_angs');

yt=yt-1.5*dy;

% show axis v
sav=uicontrol('parent',fig,...
    'Style','checkbox','units','normalized','fontunits','normalized',...
    'BackgroundColor',clr,...
    'HorizontalAlignment','center',...
    'fontsize',0.8,...
    'position',[xt yt dx dy],'string','show axis v',...
    'Value',true,...
    'Callback','enter_ax_an_angs');

yt=yt-1.5*dy;

% show axis-angle angles
saa=uicontrol('parent',fig,...
    'Style','checkbox','units','normalized','fontunits','normalized',...
    'BackgroundColor',clr,...
    'HorizontalAlignment','center',...
    'fontsize',0.8,...
    'position',[xt yt dx dy],'string','show axis-angle angles',...
    'Value',true,...
    'Callback','enter_ax_an_angs');



xt=xt+35*unit;
yt=ytf-3*unit;
dx=25*unit;


% for Euler
fe=uicontrol('parent',fig,...
    'Style','pushbutton','units','normalized','fontunits','normalized',...
    'BackgroundColor',clr,...
    'HorizontalAlignment','center',...
    'fontsize',0.8,...
    'position',[xt yt dx dy],'string','for Euler',...
    'callback','for_euler');

yt=yt-1.5*dy;

% for axis-angle
faa=uicontrol('parent',fig,...
    'Style','pushbutton','units','normalized','fontunits','normalized',...
    'BackgroundColor',clr,...
    'HorizontalAlignment','center',...
    'fontsize',0.8,...
    'position',[xt yt dx dy],'string','for axis-angle',...
    'callback','for_axis_angle');

% for resize fonts:
fud=get(fig,'UserData');
fud{1}=[tphi ttheta tpsi talpha];
set(fig,'UserData',fud);
%get(fig,'Position');
resz(fig);
set(fig,'ResizeFcn',['resz(' num2str(fig,'%20.20e') ')']);

hpar=ax;

set(hpar,'DataAspectRatio',[1,1,1]);

light('parent',hpar);

naner=false;

vx=str2num(get(x,'String'));
if length(vx)==0
    naner=true;
end

vy=str2num(get(y,'String'));
if length(vy)==0
    naner=true;
end

vz=str2num(get(z,'String'));
if length(vz)==0
    naner=true;
end

if naner
    nan_error;
end

vl=sqrt(vx^2+vy^2+vz^2);
minlim=min([-vx -vy -vz  0  vx vy vz -vl vl]);
maxlim=max([-vx -vy -vz  0  vx vy vz -vl vl]);
meanlim=(maxlim+minlim)/2;
axsz=maxlim-minlim;
if axsz==0
    minlim=-1;
    maxlim=1;
    meanlim=(maxlim+minlim)/2;
    
    axsz=maxlim-minlim;
end
ts=axsz*0.05; % text shift
rhs=axsz*0.05; % arrow tip size
rhs1=axsz*0.04;
lr=axsz*0.005; % arrow type size
lr1=axsz*0.004;
r=0.03*rhs;
h=0.1*rhs;
kt=1.05;
set(hpar,'Xlim',[meanlim-1.4*axsz/2 meanlim+1.4*axsz/2]);
set(hpar,'Ylim',[meanlim-1.4*axsz/2 meanlim+1.4*axsz/2]);
set(hpar,'Zlim',[meanlim-1.4*axsz/2 meanlim+1.4*axsz/2]);
set(hpar,'DataAspectRatio',[1,1,1]);
set(hpar,'UserData',axsz);

% X:
xb=arrow(-1.2*axsz/2,0,0,1.2*axsz,0,0,rhs*0.8,lr*0.8,[1 0 0],hpar);
xbt=text('parent',hpar,'position',[1.2*axsz/2 0 0]+ts*[1 0 0],'string','X','HorizontalAlignment','center','VerticalAlignment','middle');

% Y:
yb=arrow(0,-1.2*axsz/2,0,0,1.2*axsz,0,rhs*0.8,lr*0.8,[0 1 0],hpar);
ybt=text('parent',hpar,'position',[0 1.2*axsz/2 0]+ts*[0 1 0],'string','Y','HorizontalAlignment','center','VerticalAlignment','middle');

% Z:
zb=arrow(0,0,-1.2*axsz/2,0,0,1.2*axsz,rhs*0.8,lr*0.8,[0 0 1],hpar);
zbt=text('parent',hpar,'position',[0 0 1.2*axsz/2]+ts*[0 0 1],'string','Z','HorizontalAlignment','center','VerticalAlignment','middle');

if ~get(sXYZ,'value')
    
    arrow_visible_off_on(xb,false);
    set(xbt,'visible','off');
    
    arrow_visible_off_on(yb,false);
    set(ybt,'visible','off');
    
    arrow_visible_off_on(zb,false);
    set(zbt,'visible','off');
    
end

% memorize axes position for 2x zoom
posa=get(ax,'Position');
set(z2x,'UserData',posa);




% initial draw of xyz:

naner=false;

phin=str2num(get(phi,'String'));
if length(phin)==0
    naner=true;
end

thetan=str2num(get(theta,'String'));
if length(thetan)==0
    naner=true;
end

psin=str2num(get(psi,'String'));
if length(psin)==0
    naner=true;
end

if naner
    nan_error;
end

if get(deg,'Value')
    phin=pi*phin/180;
    thetan=pi*thetan/180;
    psin=pi*psin/180;
end

an=ea_bounding(phin,thetan,psin); % correct angles
if an(1)
    phin=an(2);
    thetan=an(3);
    psin=an(4);
    if get(deg,'Value')
        set(phi,'String',num2str(180*phin/pi));
        set(theta,'String',num2str(180*thetan/pi));
        set(psi,'String',num2str(180*psin/pi));
    else
        set(phi,'String',num2str(phin));
        set(theta,'String',num2str(thetan));
        set(psi,'String',num2str(psin));
    end
end

Ms=matrices(phin,thetan,psin);
M=Ms{1}*Ms{2}*Ms{3};

als=0.5; % transparensy of xyz
lcs=[0.4 0.4 0.4]; %labels color


% x
xsv=M*[1;0;0];
xsv1=ks*xsv;
xs=arrowa(0,0,0,xsv1(1),xsv1(2),xsv1(3),rhs1*0.8,lr1*0.8,[1 0 0],als,hpar);
xst=text('parent',hpar,'position',xsv1+ts*xsv,'string','x','HorizontalAlignment','center','VerticalAlignment','middle','color',lcs);

% y
ysv=M*[0;1;0];
ysv1=ks*ysv;
ys=arrowa(0,0,0,ysv1(1),ysv1(2),ysv1(3),rhs1*0.8,lr1*0.8,[0 1 0],als,hpar);
yst=text('parent',hpar,'position',ysv1+ts*ysv,'string','y','HorizontalAlignment','center','VerticalAlignment','middle','color',lcs);

% z
zsv=M*[0;0;1];
zsv1=ks*zsv;
zs=arrowa(0,0,0,zsv1(1),zsv1(2),zsv1(3),rhs1*0.8,lr1*0.8,[0 0 1],als,hpar);
zst=text('parent',hpar,'position',zsv1+ts*zsv,'string','z','HorizontalAlignment','center','VerticalAlignment','middle','color',lcs);

if ~get(sxyz,'value')
    
    arrow_visible_off_on(xs,false);
    set(xst,'visible','off');
    
    arrow_visible_off_on(ys,false);
    set(yst,'visible','off');
    
    arrow_visible_off_on(zs,false);
    set(zst,'visible','off');
    
end

% axis v
axan=euler2axan(phin,thetan,psin,M);
% {{gamma,delta,alpha},v}
gda=axan{1};
gamman=gda{1};
deltan=gda{2};
alphan=gda{3};
vn=axan{2};
if get(deg,'Value')
    set(gamma,'string',num2str(180*gamman/pi));
    set(delta,'string',num2str(180*deltan/pi));
    set(alpha,'string',num2str(180*alphan/pi));
else
    set(gamma,'string',num2str(gamman));
    set(delta,'string',num2str(deltan));
    set(alpha,'string',num2str(alphan));
end

set(x,'string',num2str(vn(1)));
set(y,'string',num2str(vn(2)));
set(z,'string',num2str(vn(3)));

vn1=ks*vn;
vna=arrow(0,0,0,vn(1),vn(2),vn(3),rhs1*0.8,lr1*0.8,[0.9 0.2 1],hpar);
vnat=text('parent',hpar,'position',vn+ts*vn1,'string','v','HorizontalAlignment','center','VerticalAlignment','middle','color',lcs);

if ~get(sav,'value')
    arrow_visible_off_on(vna,false);
    set(vnat,'visible','off');
end

% line of nodes
Nv=Ms{1}*[1;0;0];
Nv1=ks*Nv;
N=arrow(-Nv(1),-Nv(2),-Nv(3),2*Nv(1),2*Nv(2),2*Nv(3),rhs1*0.8,lr1*0.8,[0.4 0.4 0.4],hpar);
Nt=text('parent',hpar,'position',Nv+ts*Nv1,'string','N','HorizontalAlignment','center','VerticalAlignment','middle','color',lcs);

if ~get(sN,'value')
    
    arrow_visible_off_on(N,false);
    set(Nt,'visible','off');
    
end




% angles

arcR=0.3; % arc radius
arcth=arcR*0.3; % arc tip height
arctxtR=1.2*arcR; % arc text radius

arcvsh=0.7; % sift of alpha arc, relative value
arcR1=0.1; % arc radius for alpha
arcth1=arcR1*0.5; % arc tip height
arctxtR1=1.4*arcR1; % arc text radius for alpha

% phi:
an=arc_data(phin,arcR,arcth,arctxtR);
Ml=an{1};
Mt=an{2};
txv=an{3};
phia1=plot3(Ml(1,:),Ml(2,:),zeros(1,length(Ml(1,:))),'-k','parent',hpar);
phia2=plot3(Mt(1,:),Mt(2,:),zeros(1,length(Mt(1,:))),'-k','parent',hpar);
phiat=text('parent',hpar,'position',[txv 0],'string','\phi','HorizontalAlignment','center','VerticalAlignment','middle','color',lcs);

% theta:
an=arc_data(thetan,arcR,arcth,arctxtR);
Ml1=an{1};
Ml=Ms{1}*[zeros(1,length(Ml1(1,:))); -Ml1(2,:); Ml1(1,:)];
Mt1=an{2};
Mt=Ms{1}*[zeros(1,length(Mt1(1,:))); -Mt1(2,:); Mt1(1,:)];
txv1=an{3};
txv=Ms{1}*[0; -txv1(2); txv1(1)];
thetaa1=plot3(Ml(1,:),Ml(2,:),Ml(3,:),'-k','parent',hpar);
thetaa2=plot3(Mt(1,:),Mt(2,:),Mt(3,:),'-k','parent',hpar);
thetaat=text('parent',hpar,'position',txv,'string','\theta','HorizontalAlignment','center','VerticalAlignment','middle','color',lcs);

% psi:
an=arc_data(psin,arcR,arcth,arctxtR);
Ml1=an{1};
Ml=Ms{1}*Ms{2}*[Ml1(1,:); Ml1(2,:); zeros(1,length(Ml1(1,:)))];
Mt1=an{2};
Mt=Ms{1}*Ms{2}*[Mt1(1,:); Mt1(2,:); zeros(1,length(Mt1(1,:)))];
txv1=an{3};
txv=Ms{1}*Ms{2}*[txv1(1); txv1(2); 0];
psia1=plot3(Ml(1,:),Ml(2,:),Ml(3,:),'-k','parent',hpar);
psia2=plot3(Mt(1,:),Mt(2,:),Mt(3,:),'-k','parent',hpar);
psiat=text('parent',hpar,'position',txv,'string','\psi','HorizontalAlignment','center','VerticalAlignment','middle','color',lcs);

if ~get(sa,'value')
    set(phia1,'visible','off');
    set(phia2,'visible','off');
    set(phiat,'visible','off');
    
    set(thetaa1,'visible','off');
    set(thetaa2,'visible','off');
    set(thetaat,'visible','off');
    
    set(psia1,'visible','off');
    set(psia2,'visible','off');
    set(psiat,'visible','off');
end



% axis-angle angles

% gamma:
an=arc_data(gamman,arcR,arcth,arctxtR);
Ml=an{1};
Mt=an{2};
txv=an{3};
gammaa1=plot3(Ml(1,:),Ml(2,:),zeros(1,length(Ml(1,:))),'-k','parent',hpar);
gammaa2=plot3(Mt(1,:),Mt(2,:),zeros(1,length(Mt(1,:))),'-k','parent',hpar);
gammaat=text('parent',hpar,'position',[txv 0],'string','\gamma','HorizontalAlignment','center','VerticalAlignment','middle','color',lcs);

% delta:
an=arc_data(deltan,arcR,arcth,arctxtR);
csgm=cos(gamman);
sngm=sin(gamman);
Mrot=[csgm, -sngm, 0;
      sngm, csgm,  0;
      0,    0,     1];
Ml1=an{1};
Ml=Mrot*[Ml1(1,:); zeros(1,length(Ml1(1,:))); Ml1(2,:)];
Mt1=an{2};
Mt=Mrot*[Mt1(1,:); zeros(1,length(Mt1(1,:))); Mt1(2,:)];
txv1=an{3};
txv=Mrot*[txv1(1); 0; txv1(2)];
deltaa1=plot3(Ml(1,:),Ml(2,:),Ml(3,:),'-k','parent',hpar);
deltaa2=plot3(Mt(1,:),Mt(2,:),Mt(3,:),'-k','parent',hpar);
deltaat=text('parent',hpar,'position',txv,'string','\delta','HorizontalAlignment','center','VerticalAlignment','middle','color',lcs);


% alpha:
an=arc_data(alphan,arcR1,arcth1,arctxtR1);
csdl=cos(deltan);
sndl=sin(deltan);
Mrot1=[csdl, 0,  -sndl;
       0,    1,  0    ;
       sndl, 0,  csdl ];
Ml1=an{1};
Ml=Mrot*Mrot1*[zeros(1,length(Ml1(1,:))); -Ml1(2,:); Ml1(1,:)];
Mt1=an{2};
Mt=Mrot*Mrot1*[zeros(1,length(Mt1(1,:))); -Mt1(2,:); Mt1(1,:)];
txv1=an{3};
txv=Mrot*Mrot1*[0; -txv1(2); txv1(1)];
alphaa1=plot3(Ml(1,:)+vn(1)*arcvsh,Ml(2,:)+vn(2)*arcvsh,Ml(3,:)+vn(3)*arcvsh,'-k','parent',hpar);
alphaa2=plot3(Mt(1,:)+vn(1)*arcvsh,Mt(2,:)+vn(2)*arcvsh,Mt(3,:)+vn(3)*arcvsh,'-k','parent',hpar);
alphaat=text('parent',hpar,'position',txv+vn*arcvsh,'string','\alpha','HorizontalAlignment','center','VerticalAlignment','middle','color',lcs);


if ~get(saa,'value')
    
    set(gammaa1,'visible','off');
    set(gammaa2,'visible','off');
    set(gammaat,'visible','off');
    
    set(deltaa1,'visible','off');
    set(deltaa2,'visible','off');
    set(deltaat,'visible','off');
    
    set(alphaa1,'visible','off');
    set(alphaa2,'visible','off');
    set(alphaat,'visible','off');
    
end
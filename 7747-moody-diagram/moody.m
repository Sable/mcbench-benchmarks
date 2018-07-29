function moody(units,paper,name)
% Moody Diagram (R13)
%   MOODY(UNITS,PAPER,NAME) generates a four axis, publication quality
%   Moody diagram as a PAPER size encapsulated postscript file NAME with
%   UNITS.  Default units are IMPERIAL.  If units are SI, the default
%   paper size is A4.  If units are IMPERIAL, the default paper size is
%   LETTER.  The default file name is MOODY.EPS.
% Examples:
%   MOODY % writes letter size moody.eps with imperial units
%   MOODY SI % writes A4 size moody.eps with SI units
%   MOODY IMPERIAL A4 % writes A4 size moody.eps with imperial units
%   MOODY SI LETTER % writes letter size moody.eps with SI units
%   MOODY SI A4 MOODY.SI.EPS % writes A4 size moody.si.eps with SI units

% Copyright(c)2004-2008
% Tom Davis (tdavis@metzgerwillard.com)
%
% Last revision: 03/10/2008

r=[0,1e-6,5e-6,1e-5,2e-5,5e-5,1e-4,2e-4:2e-4:1e-3,...
  1.5e-3,2e-3,3e-3,4e-3:2e-3:1e-2,1.25e-2,1.5e-2,1.75e-2,...
  2e-2:0.5e-2:4.5e-2,5e-2,6e-2,7e-2]; % Relative roughness
R=logspace(3,8,100);                  % Reynolds number
L=[600,2300];                         % Laminar flow
T=[2300,R(R>2300)];                   % Turbulent flow
start=[2.3e2,5.5e6,1.5e6,4.5e5,2.6e5,9e4,4.5e4,2e4,...
  7e3,1.5e4,1.2e4,2.3e2,7e3,2.3e2*ones(1,18)];

figure(1), clf, cf=gcf; ca=gca;
set(cf,'PaperOrientation','landscape',...
  'name','MoodyDiagram','PaperUnits','points');
set(ca,'xscale','log','yscale','log','box','on',...
  'fontsize',8,'DefaultTextFontSize',8);
axis([600,1e8,0.008,0.1]); pbaspect([13.5,9.5,1]); hold on

% Units and paper size
u='imp'; p='Letter';
if nargin
  if strcmpi(units,'si')
    u='si'; p='A4';
  end
  if nargin>1
    if strcmpi(paper,'a4')
      p='A4';
    else
      p='Letter';
    end
  end
end
units=u; paper=p; white=[1 1 1];

% Critical zone patch
patch([2e3,2e3,4e3,4e3],[8e-3,1e-1,1e-1,8e-3],0.96*white)

% Grid
logminorgrid('y',7,40,1)
logmajorgrid('y',1,0.1)
logminorgrid('x',7,0.0003,0)
logmajorgrid('x',0,0.1)
logmajorgrid('x',-1,0.4)

% Friction factor curves
loglog(L,64./L,'b','linewidth',1)
for i=1:length(r)
  loglog(T(T>=start(i)),colebrook(T(T>=start(i)),r(i)),...
    'b','linewidth',1)
  if r(i)>5e-6
    text(1.1e8,colebrook(1e8,r(i)),num2str(r(i)),'fontsize',7)
  end
end

% Zone labels
set(ca,'DefaultTextVerticalAlignment','top');
loglog(T,(1.14-2*log10(3500./T)).^(-2),'linewidth',0.1,'color','k')
text(1.08e3,0.096,{'Laminar','flow'},...
  'HorizontalAlignment','center','BackgroundColor',white)
text(2.83e3,0.096,{'Critical','zone'},...
  'HorizontalAlignment','center','BackgroundColor',0.96*white)
text(1.3e4,0.096,'Transition zone',...
  'HorizontalAlignment','center','BackgroundColor',white)
text(1.4e6,0.096,['Complete turbulence, rough pipes, {\itR}  ',...
  '> 3500/{\itr},  1/\surd{\itf}  = 1.14 - 2 log {\itr}'],...
  'HorizontalAlignment','center','BackgroundColor',white)
set(ca,'DefaultTextVerticalAlignment','middle',...
  'DefaultTextFontSize',10);
text(2.0e3,9.4e-2,'\rightarrow','HorizontalAlignment','right')
text(4.08e4,9.4e-2,'\rightarrow','HorizontalAlignment','right')
text(4.0e3,9.4e-2,'\leftarrow')
text(4.08e4,9.4e-2,'\leftarrow')

% VD water
VD1=[0.1,0.2:0.2:1,2:2:10,20:20:100,200:200:1000,2000:2000:10000];
ul=char(95*ones(1,94));

% VD air
VD2=[2:2:10,20:20:100,200:200:1000,2000:2000:10000,20000:20000:100000];

if strcmp(units,'si') % SI units
  Runits='({\itV} in m/s, {\itD} in m, \nu in m^{\fontsize{6} 2}/s)';
  runits='(\epsilon in mm, {\itD} in mm)';
  x=1.8e5; y=0.02912; viscosity='\nu (m^2/s) ';
  VD1=[0.06,0.08,VD1]; VD2=[1,VD2]; ul=[ul,'____'];
  nuWater=1.003e-6; nuAir=1.511E-5; mult=100; temp='20\circC';
  pressure='(101.325 kPa)'; sep2='{\fontname{MS LineDraw}ÄÄÄÄÄÄÄÄÄ}';
  vdunits='({\itV} in m/s, {\itD} in cm)';
  epsilon={'\epsilon (mm)',sep2,'0.9-9','0.3-3',...
    '0.18-0.9','0.25','0.15','0.12','0.046','0.0015'};
  acceleration={'{\itg} (m/s^2)',sep2,'9.78033','9.80665','9.83219'};
else                  % Imperial units
  Runits='({\itV} in fps, {\itD} in ft, \nu in ft^{\fontsize{6} 2}/s)';
  runits='(\epsilon in ft, {\itD} in ft)';
  x=1.95e5; y=0.031; viscosity='\nu (ft^2/s) ';
  nuWater=1.217e-5; nuAir=1.583e-4; mult=12; temp='60\circF';
  pressure='(14.70 psia)'; sep2='{\fontname{MS LineDraw}ÄÄÄÄÄÄÄÄÄÄ}';
  vdunits='({\itV} in fps, {\itD} in inches)';
  epsilon={'\epsilon (ft)',sep2,'0.003-0.03','0.001-0.01',...
    '0.0006-0.003','0.00085','0.0005','0.0004','0.00015','0.000005'};
  acceleration={'{\itg} (ft/s^2)',sep2,'32.0877','32.1740','32.2578'};
end

% Miscellaneous labels
div1='{\fontname{MS LineDraw}Í Ä}  ';
div2='{\fontname{MS LineDraw}Í ÄÄ}  ';
div4='{\fontname{MS LineDraw}Í ÄÄÄÄ}';
xlabel(['Reynolds number  {\itR}  ',div2,Runits],'fontsize',10)
text(x,0.00695,{'{\itVD}','{\fontsize{1}  }','  \nu'})
ylabel(['Darcy-Weisbach friction factor  {\itf}  ',div4],'fontsize',10)
text(360,0.0413,{'2{\ithDg}','{\fontsize{3}  }',...
  '{ \itLV}^{\fontsize{6}  2}'},'rotation',90)
text(1.9e8,0.028,['Relative roughness  {\itr}  ',div1,runits],...
  'rotation',90,'HorizontalAlignment','center')
text(1.93e8,y,{' \epsilon','{\fontsize{1}  }','{\itD}'},'rotation',90)
text(600,0.007,'\it\bfMoody Diagram','fontsize',12)
text(1.77e7,0.007,{'{\fontsize{9}\bfMetzger & Willard, Inc.}',...
  '{\fontsize{7}http://www.metzgerwillard.com}'})
index=find(T>=start(3)); T1=T(index(1));
f1=colebrook(T1,5e-6);
plot([1e6,T1],[f1,f1],'k')
index=find(T>=start(2)); T2=T(index(1));
f2=colebrook(T2,1e-6);
plot([4e6,T2],[f2,f2],'k')
set(ca,'DefaultTextFontSize',8);
text(1e6,f1,'{\itr}  = 5e-006',...
  'HorizontalAlignment','right','BackgroundColor',white)
text(4e6,f2,'{\itr}  = 1e-006',...
  'HorizontalAlignment','right','BackgroundColor',white)
f3=colebrook(2e5,0);
plot([1.18e5,2e5],[f3,f3],'k'), hold off
text(2.55e4,1.65e-2,{'Smooth pipes, {\itr}  = 0',...
  '1/\surd{\itf}  = 2 log({\itR} \surd{\itf} ) - 0.8',' '},...
  'VerticalAlignment','top','BackgroundColor',white)
text(2.55e4,1.385e-2,{'Hagen-Poisseuille equation',...
  '{\itR}  \leq 2300,  {\itf}  = 64/{\itR}',' ',...
  'Colebrook equation, {\itR}  \geq 2300',...
  ['1/\surd{\itf}  = -2 log({\itr} /3.7 + ',...
  '2.51/({\itR} \surd{\itf} ))'],' ',...
  'Continuity equation, {\itQ}  = {\itAV}','{\fontsize{2}  }',...
  ['{\itA}  = \pi {\itD}^{ 2}/4,  {\itV}  = ',...
  '4{\itQ} /(\pi {\itD}^{ 2})']},...
  'VerticalAlignment','top','BackgroundColor',white)

% Surd overbars
set(ca,'DefaultTextVerticalAlignment','bottom');
text(4.3200e6,9.5500e-2,'__','interpreter','none','fontsize',4)
text(3.0956e4,1.5600e-2,'__','interpreter','none','fontsize',4)
text(7.1850e4,1.5600e-2,'__','interpreter','none','fontsize',4)
text(3.0956e4,1.1115e-2,'__','interpreter','none','fontsize',4)
text(1.8850e5,1.1115e-2,'__','interpreter','none','fontsize',4)

% VD water axis
text(2.41e5,0.126,['{\itVD} for water at ',temp,' ',vdunits],...
  'HorizontalAlignment','center','VerticalAlignment','middle')
for i=1:length(VD1)
  R=VD1(i)/(mult*nuWater);
  if VD1(i)~=80*[0.001,1,10,100]
    text(R,0.120,num2str(VD1(i)),'fontsize',6,...
      'HorizontalAlignment','center','VerticalAlignment','middle')
  end
  text(R,0.114,'|','fontsize',6,'HorizontalAlignment','center')
end
text(VD1(1)/(mult*nuWater),0.11379,ul,'interpreter','none','fontsize',6)
text(VD1(end)/(mult*nuWater),0.11379,ul,'fontsize',6,'interpreter',...
  'none','HorizontalAlignment','right')

% VD air axis
text(2.41e5,0.110,['{\itVD} for atmospheric air at ',temp],...
  'HorizontalAlignment','center','VerticalAlignment','middle')
for i=1:length(VD2)
  R=VD2(i)/(nuAir*mult);
  if VD2(i)~=80*[1,10,100,1000]
    text(R,0.105,num2str(VD2(i)),'fontsize',6,...
      'HorizontalAlignment','center','VerticalAlignment','middle')
  end
  text(R,0.1,'|','fontsize',6,'HorizontalAlignment','center')
end

% Material epsilon table
set(ca,'DefaultTextBackgroundColor',white,'DefaultTextMargin',5);
sep1='{\fontname{MS LineDraw}ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}';
text(1.08e3,1.52e-2,{'Material',sep1,'Riveted steel',...
  'Concrete','Wood stave','Cast iron','Galvanized iron',...
  'Asphalted cast iron','Commercial steel','Drawn tubing'})
text(4.4e3,1.52e-2,epsilon)

% Fluid viscosity table
text(1.08e3,1.2e-2,{['Fluid at ',temp],sep1,'Water',['Air ',pressure]})
text(4.4e3,1.2e-2,{viscosity,sep2,num2str(nuWater),num2str(nuAir)})

% Accleration table
space='            '; degrees=' {\fontsize{7.5}\circ}';
text(1.08e3,9.0e-3,{'Latitude (WGS84)',sep1,...
  [space,'Sea level'],[space,'Standard'],[space,'Sea level']})
text(1.44e3,9.0e-3,{'0.0','45.5','90.0'},'BackgroundColor','none',...
  'HorizontalAlignment','right')
text(1.39e3,9.04e-3,{degrees,degrees,degrees},'BackgroundColor','none')
text(4.4e3,9.0e-3,acceleration)

% Write eps
if strcmp(paper,'A4') % A4 letter paper size
  set(cf,'PaperSize',[842 595],'PaperPosition',[-20 -52 842 644]);
else                  % US letter paper size
  set(cf,'PaperSize',[792 612],'PaperPosition',[-45 -43 842 644]);
end
print -depsc -r720 MoodyDiagram

% Insert orientation and size comments
fin =fopen('MoodyDiagram.eps','rt');
if nargin<3, name='moody.eps'; end
fout=fopen(name,'wt');
line=fgets(fin);
while ~strncmp(line,'%%EndComments',13)
  fprintf(fout,'%s',line);
  line=fgets(fin);
end
fprintf(fout,'%s\n%s%s\n%s','%%Orientation: Landscape',...
  '%%DocumentPaperSizes: ',paper,line);
while ~feof(fin)
  line=fgets(fin);
  fprintf(fout,'%s',line);
end
fclose all;
delete MoodyDiagram.eps

%-------------------------------------------------------------------------
function f=colebrook(R,r)
% Colebrook Equation
%   f = Darcy-Weisbach friction factor
%   R = Reynolds number
%   r = relative roughness

f=zeros(size(R)); f0=0.04;
for i=1:length(R)
  for j=1:5
    f0=(2*log10(r/3.7+2.51/R(i)/sqrt(f0)))^-2;
  end
  f(i)=f0;
end

%-------------------------------------------------------------------------
function logmajorgrid(xystr,space,width)
% Log Major Grid
%   xystr = 'x' for x axis grid
%           'y' for y axis grid
%   space = -1 for sparse grid
%            0 for normal grid
%            1 for dense  grid
%   width = grid line width

v=axis;
if strcmp(xystr,'y'), v=[v(3) v(4) v(1) v(2)]; end
switch space
case -1
  tk=1;
case 0
  tk=1:9;
case 1
  tk=[1:0.5:5.5,6:9];
end
for i=floor(log10(v(1))):ceil(log10(v(2)))
  for k=1:length(tk)  % grid lines only
    tk10=tk(k)*10^i;
    if tk10 < v(2) && tk10 > v(1)
      if strcmp(xystr,'x')
        plot(tk10*[1,1],[v(3),v(4)],'k-','linewidth',width)
      else
        plot([v(3),v(4)],tk10*[1,1],'k-','linewidth',width)
      end
    end
  end
end

%-------------------------------------------------------------------------
function logminorgrid(xystr,fntsz,off,space)
% Log Minor Grid
%   xystr = 'x' for x axis grid
%           'y' for y axis grid
%   fntsz = font size
%   off   = text offset
%   space = -1 for sparse grid
%            0 for normal grid
%            1 for dense  grid

v=axis; grey=0.5*[1,1,1];
if strcmp(xystr,'y'), v=[v(3) v(4) v(1) v(2)]; end
switch space
case -1
  tk=[1.2:0.2:1.8,2.5:1:3.5]; tx=2:5;
case 0
  tk=[1.2:0.2:2.8,3.5:1:5.5]; tx=2:8;
case 1
  tk=[1.1:0.1:5.9,6.2:0.2:6.8,7.5:1:9.5];
  tx=[1.2:0.2:1.8,2:0.5:6,7,8,9];
end
for i=floor(log10(v(1))):ceil(log10(v(2)))
  for j=1:length(tx)  % grid labels
    tx10=tx(j)*10^i;
    if tx10 < 1.01*v(2) && tx10 > 0.99*v(1)
      if strcmp(xystr,'x')
        text(tx10,v(3)-off,num2str(tx(j)),'fontsize',fntsz,...
          'horizontalalignment','center')
      else
        text(v(3)-off,tx10,num2str(tx(j)),'fontsize',fntsz,...
          'horizontalalignment','right')
      end
    end
  end
  for k=1:length(tk)  % grid lines
    tk10=tk(k)*10^i;
    if tk10 < v(2) && tk10 > v(1)
      if strcmp(xystr,'x')
        plot(tk10*[1,1],[v(3),v(4)],'-','linewidth',0.1,'color',grey)
      else
        plot([v(3),v(4)],tk10*[1,1],'-','linewidth',0.1,'color',grey)
      end
    end
  end
end

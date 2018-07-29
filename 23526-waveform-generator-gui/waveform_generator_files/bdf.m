function bdf(ha,hfl,uf)
% Button Down Function
% ha - axes handler
% hfl - fill handle (circle)

global xys
% 
% xys

% memorize xys when clicked:
xys1=xys(1,:);
xys2=xys(2,:);

% get figure handle
hf=get(ha,'parent');

% initial pointer location in pixels:
pl=get(0,'PointerLocation');
xp=pl(1);
yp=pl(2);


xd=get(hfl,'XData')';
yd=get(hfl,'YData')';



% calculate kk, kk is scale coefficient between pixels and units of axes:
set(ha,'units','pixels');
ap=get(ha,'position');
set(ha,'units','normalized');

xlm=get(ha,'Xlim');
xun=xlm(2)-xlm(1);
ylm=get(ha,'Ylim');
yun=ylm(2)-ylm(1);

% set(ha,'PlotBoxAspectRatioMode','manual');
% set(ha,'DataAspectRatioMode','manual');
aba=get(ha,'PlotBoxAspectRatio');

%if ap(4)>ap(3)
%if 1>ap(3)/ap(4)
if (aba(1)/aba(2))>(ap(3)/ap(4))
    kkx=xun/ap(3);
    ap4s=aba(2)*ap(3)/aba(1);
    kky=yun/ap4s;
else
    ap3s=aba(1)*ap(4)/aba(2);
    kkx=xun/ap3s;
    kky=yun/ap(4);
end

% kk=xun/ap(3);
% kk=yun/ap(4);



% what to do when move:
wbmf=['move(' num2str(hfl,'%20.20f') ',' num2str(xp,'%20.20f') ',' num2str(yp,'%20.20f') ',' '[' num2str(xd,'%20.20f ') ']' ',' '[' num2str(yd,'%20.20f ') ']' ',' num2str(kkx,'%20.20f ') ',' num2str(kky,'%20.20f ') ',' '[' num2str(xys1,'%20.20f ') ']' ',' '[' num2str(xys2,'%20.20f ') ']' ',''' uf '''' ')'];
set(hf,'WindowButtonMotionFcn',wbmf);

% what to do when release button:
wbuf=['set(' num2str(hf,'%20.20f') ',''WindowButtonMotionFcn'','''')']; % not do moving any more
set(hf,'WindowButtonUpFcn',wbuf);
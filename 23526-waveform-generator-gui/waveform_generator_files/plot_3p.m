
T=1/f;


sl=3*T; % signal length

xl=get(handles.axes1,'Xlim');
yl=get(handles.axes1,'Ylim');
dxl=xl(2)-xl(1);
dyl=yl(2)-yl(1);

xc1=0:dxl/res:sl;
xc=mod(xc1,T); % turn to one period
if iscnt
    yc=interp1([xys(1,:)-dxl xys(1,:) xys(1,:)+dxl],[xys(2,:) xys(2,:) xys(2,:)],xc,mth,'extrap');
else
    yc=interp1(xys(1,:),xys(2,:),xc,mth,'extrap');
end

nf=max(abs(yc)); % normalization factor
yc=yc/nf; % mormalize

figure;
plot(xc1,yc,'b-',xys(1,:),xys(2,:)/nf,'rx',[T T],[-1 1],'k--',[2*T 2*T],[-1 1],'k--');
xlabel('time, s');
ylabel('signal, notmalized');
title('3 periods of the signal');
ylim([-1 1]);

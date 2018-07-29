Fs=44100;
dt=1/Fs;

T=1/f;

sls=get(handles.sl,'string');
sl=str2num(sls); % signal length

xl=get(handles.axes1,'Xlim');
yl=get(handles.axes1,'Ylim');
dxl=xl(2)-xl(1);
dyl=yl(2)-yl(1);

xc1=0:dt:sl;
xc=mod(xc1,T); % turn to one period
if iscnt
    yc=interp1([xys(1,:)-dxl xys(1,:) xys(1,:)+dxl],[xys(2,:) xys(2,:) xys(2,:)],xc,mth,'extrap');
else
    yc=interp1(xys(1,:),xys(2,:),xc,mth,'extrap');
end

yc=(yc-mean(yc))/max(abs(yc)); % mormalize, debias
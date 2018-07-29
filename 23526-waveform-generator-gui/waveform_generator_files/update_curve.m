xc=xl(1):(dxl/res):xl(2);
if iscnt
    yc=interp1([xys(1,:)-dxl xys(1,:) xys(1,:)+dxl],[xys(2,:) xys(2,:) xys(2,:)],xc,mth,'extrap');
else
    yc=interp1(xys(1,:),xys(2,:),xc,mth,'extrap');
end
%handles.cr=plot(xc,yc,'k-');
set(hc,'XData',xc,'YData',yc);
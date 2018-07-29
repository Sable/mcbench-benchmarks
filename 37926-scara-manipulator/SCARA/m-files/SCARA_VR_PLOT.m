function plotVR=SCARA_VR_PLOT(T1,T2,T4,d4b,dist)
SCARA30 = vrworld('SCARA30.wrl');
open(SCARA30)
    radian=T1*pi/180;
    SCARA30.a1.rotation = [1, 0, 0, radian];
    
    radian=-T2*pi/180;
    SCARA30.a2.rotation = [1, 0, 0, radian];
    
    radian=T4*pi/180;
    SCARA30.d4b.rotation = [0, 1, 0, radian];
    
    SCARA30.d4b.translation = [0, d4b, 0];
    
    
    
EndV1=SCARA30.EndV1.translation;
EndV2=SCARA30.EndV2.translation;
x1=EndV1(1);
x2=EndV2(1);
% y1=EndV1(2);
% y2=EndV2(2);
% sighn=sign([y1 y2]);
% y1f=.5*sighn(1)*dist
% y2f=.5*sighn(2)*dist
y1=-.5*dist;
y2=.5*dist;



SCARA30.EndV1.translation = [x1, y1, 0];
SCARA30.EndV2.translation = [x2, y2, 0];
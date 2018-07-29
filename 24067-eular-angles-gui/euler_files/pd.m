function pgs(hf)
ss2=get(hf,'UserData');
status=ss2(1);
status2=ss2(2);

ssz=get(0,'ScreenSize');

set(status,'FontUnits','points','FontSize',8*ssz(4)/768);
set(status2,'FontUnits','points','FontSize',8*ssz(4)/768);
drawnow;
printdlg(hf);

set(status,'FontUnits','points','FontSize',10*ssz(4)/768);
set(status2,'FontUnits','points','FontSize',10*ssz(4)/768);
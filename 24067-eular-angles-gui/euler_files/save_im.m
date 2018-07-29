function save_im(hf)

% rszs=get(hf,'ResizeFcn');
% set(hf,'ResizeFcn','');

%set(hf,'UserData',[status status2]);
ss2=get(hf,'UserData');
status=ss2(1);
status2=ss2(2);
status3=ss2(3);

ssz=get(0,'ScreenSize');

% set(status,'FontUnits','points','FontSize',8*ssz(4)/768);
% set(status2,'FontUnits','points','FontSize',8*ssz(4)/768);
% set(status3,'FontUnits','points','FontSize',8*ssz(4)/768);
fs=get(status,'FontSize');
set(status,'FontSize',round(0.7*fs));
fs=get(status2,'FontSize');
set(status2,'FontSize',round(0.7*fs));
fs=get(status3,'FontSize');
set(status3,'FontSize',round(0.7*fs));
drawnow;


[file,path] = uiputfile({'*.png'; '*.jpg'; '*.tif'; '*.bmp'; '*.emf'; '*.eps'; '*.fig '; '*.mat'},'Save Image As');
%set(hf,'PaperPositionMode','manual','PaperOrientation','portrait');
saveas(hf,[path file],'png');
%set(hf,'PaperPositionMode','manual','PaperOrientation','Landscape');

% set(hf,'ResizeFcn',rszs);

% set(status,'FontUnits','points','FontSize',10*ssz(4)/768);
% set(status2,'FontUnits','points','FontSize',10*ssz(4)/768);
% set(status3,'FontUnits','points','FontSize',10*ssz(4)/768);

set(status,'FontSize',fs);
set(status2,'FontSize',fs);
set(status3,'FontSize',fs);
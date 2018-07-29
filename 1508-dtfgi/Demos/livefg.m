function livefg(ma)
% livefg(m) where m is a initialized handle to a framegrabber shows live image
% in a window.

% Vladimir Smutny 22.10.1999

global loop

f = figure;
set(f, 'Name', 'Camera Viewer',...
   'NumberTitle', 'off',...
   'Interruptible','on',...
   'KeyPressFcn','global loop; loop=0;' );
colormap gray(256)
set(gca,'Position',[0,0,1,1]);

%image(grabfg(ma)')

mov=[];
mov.cdata = grabfg(ma)';
mov.colormap=gray(256);
movsize=size(mov.cdata);
set(gcf,'Position',[50,50,movsize(2),movsize(1)]);
loop = 1;
while (loop ~= 0),
   mov.cdata=grabfg(ma)';
   movie(mov);
   pause(0.1);
end

function livefg2(alias)
% livefg2(alias) 
% example: livefg2('DT3155')
% Vladimir Smutny 22.10.1999
% modified June 2000 R. Heil, C. L. Wauters
ma=openfg(alias);
figure
colormap gray(256)
set(gca,'Position',[0,0,1,1]);
%image(grabfg(ma)')
mov=[];
mov.cdata = grabfg(ma)';
mov.colormap=gray(256);
movsize=size(mov.cdata);
set(gcf,'Position',[100,300,movsize(2),movsize(1)]);
while 1,mov.cdata=grabfg(ma)';movie(mov),pause(0.1),end

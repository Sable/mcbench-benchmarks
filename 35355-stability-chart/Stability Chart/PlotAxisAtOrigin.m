function PlotAxisAtOrigin
%PlotAxisAtOrigin Plot 2D axes through the origin

% GET TICKS
X=get(gca,'Xtick');
Y=get(gca,'Ytick');

% GET LABELS
XL=get(gca,'XtickLabel');
YL=get(gca,'YtickLabel');

% GET OFFSETS
Xoff=diff(get(gca,'XLim'))./40;
Yoff=diff(get(gca,'YLim'))./40;

% DRAW AXIS LINEs
plot(get(gca,'XLim'),[0 0],'k');
plot([0 0],get(gca,'YLim'),'k');

% Plot new ticks  
for i=1:length(X)
    plot([X(i) X(i)],[0 Yoff],'-k');
end;
for i=1:length(Y)
   plot([Xoff, 0],[Y(i) Y(i)],'-k');
end;

% ADD LABELS
t1 = text(X,zeros(size(X))-2.*Yoff,XL);
t2 = text(zeros(size(Y))-3.*Xoff,Y,YL);
set(t1,'FontName','TimesNewRoman','Fontsize',8) ;
set(t2,'FontName','TimesNewRoman','Fontsize',8) ;
% Add Axis Labels
l1 = text(1.5,max(Y),'\epsilon') ;
set(l1,'FontName','TimesNewRoman','Fontsize',8) ;
l2 = text(max(X),2.,'\delta') ;
set(l2,'FontName','TimesNewRoman','Fontsize',8) ;
% Add title
t = title('Stability chart of Mathieu Equation') ;
set(t,'FontName','TimesNewRoman','Fontsize',8) ;
box off;
% axis square;
axis off;
set(gcf,'color','w');


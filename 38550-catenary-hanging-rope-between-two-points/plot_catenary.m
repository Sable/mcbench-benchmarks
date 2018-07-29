function plot_catenary

global axs lin pnt

figure(1);
clf
axs = gca;
set(axs,'xlim',[-2 2],'ylim',[-2 2],'xtick',[],'ytick',[])
axis square
box on
lin = line(0,0,'LineWidth',2);
pnt = line(0,0,'marker','o','color','r','MarkerSize',10,'linestyle','none');

title('click and drag below','FontSize',14)

set(gcf,'WindowButtonDown',@fDown,'WindowButtonUpFcn',@fUp)

function fDown(src, ~)
set(src, 'WindowButtonMotionFcn', @fMove);

function fMove(~, ~)
global axs lin pnt
cp    = get(axs, 'CurrentPoint');  
cp		= cp(1, 1:2);

n_points	= 100;
length	= 1.8;
[X,Y] = catenary([0 0],cp,length,n_points);

set(lin,'xdata',X,'ydata',Y)
set(pnt,'xdata',[0 cp(1)],'ydata',[0 cp(2)])
   
function fUp(src, ~)
global lin pnt
set(lin,'xdata',0,'ydata',0)
set(pnt,'xdata',0,'ydata',0)
set(src, 'WindowButtonMotionFcn', '');
function [h,hg,htick]=terplot(number)
%FUNCTION [h,hg,htick]=TERPLOT perpares a ternary axis system that is
% needed for the ternaryc function. It returns three handels:
% - h:      to modify the patch created by the fill function;
% - hg:     to change each grid line separately (must probably be
% modified);
% - htick:  to edit the tick labels (probably very inconvinient)
%
% Uli Theune, Geophysics, University of Alberta
%
if nargin<1
    number=11;
end
h=fill([0 1 0.5 0],[0 0 0.866 0],'w','linewidth',2);
%set(h,'facecolor',[0.7 0.7 0.7],'edgecolor','w')
%set(gcf,'color',[0 0 0.3])
d1=cos(pi/3);
d2=sin(pi/3);
l=linspace(0,1,number);
hold on
for i=2:length(l)-1
   hg(i-1,3)=plot([l(i)*d1 1-l(i)*d1],[l(i)*d2 l(i)*d2],':k','linewidth',0.25);
   hg(i-1,1)=plot([l(i) l(i)+(1-l(i))*d1],[0 (1-l(i))*d2],':k','linewidth',0.25);
   hg(i-1,2)=plot([(1-l(i))*d1 1-l(i)],[(1-l(i))*d2 0],':k','linewidth',0.25);
end
hold off
axis image
axis off
% Make x-tick labels
for i=1:number
    htick(i,1)=text(l(i),-0.025,num2str(l(i)));
    htick(i,3)=text(1-l(i)*cos(pi/3)+0.025,l(i)*sin(pi/3)+0.025,num2str(l(i)));
    htick(i,2)=text(0.5-l(i)*cos(pi/3)-0.06,sin(pi/3)*(1-l(i)),num2str(l(i)));
end

set(gcf,'WindowButtonDownFcn','InitTerExpl');
global hx;




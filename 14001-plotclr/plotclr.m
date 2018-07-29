% function h = plotclr(x,y,v,marker,vlim)
% plots the values of v colour coded
% at the positions specified by x and y.
% A colourbar is added on the right side of the figure.
%
% The colourbar strectches from the minimum value of v to its
% maximum.
%
% 'marker' is optional to define the marker being used. The
% default is a point. To use a different marker (such as circles, ...) send
% its symbol to the function (which must be enclosed in '; see example).
%
% 'vlim' is optional, to define the limits of the colourbar.
% v values outside vlim are not plotted
%
% modified by Stephanie Contardo, CSIRO, 2009
% from 'plotc' by Uli Theune, University of Alberta, 2004
%

function h = plotclr(x,y,v,marker,vlim)

if nargin <4
    marker='.';
end

map=colormap;
if nargin >4
    miv = vlim(1) ;
    mav = vlim(2) ;
else
    miv=min(v);
    mav=max(v);
end
clrstep = (mav-miv)/size(map,1) ;
% Plot the points
hold on
for nc=1:size(map,1)
    iv = find(v>miv+(nc-1)*clrstep & v<=miv+nc*clrstep) ;
    plot(x(iv),y(iv),marker,'color',map(nc,:),'markerfacecolor',map(nc,:))
end
hold off

% Re-format the colorbar
h=colorbar;

%set(h,'ylim',[1 length(map)]);
yal=linspace(1,length(map),10);
set(h,'ytick',yal);
% Create the yticklabels
ytl=linspace(miv,mav,10);
s=char(10,4);
for i=1:10
    if min(abs(ytl)) >= 0.001
        B=sprintf('%-4.3f',ytl(i));
    else
        B=sprintf('%-3.1E',ytl(i));
    end
    s(i,1:length(B))=B;
end
set(h,'yticklabel',s);
grid on
view(2)


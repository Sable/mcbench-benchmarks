function plot3c(x,y,z,v,marker,string)
%FUNCTION PLOT3C(X,Y,Z,V,'MARKER','TitleString') plots the values in vector v colour coded
% at the positions specified by the vectors x, y, and z in a 3-D axis
% system. A colourbar is added on the right side of the figure.
%
% The colorbar strectches from the minimum value of v to its
% maximum in 9 steps (10 values).
%
% The second last argument is optional to define the marker being used. The
% default is a point. To use a different marker (such as circles, ...) send
% its symbol to the function (which must be enclosed in '; see example):
% plot3c(X,Y,Z,V,'o')
%
% A title can be optionally added to the colorbar.:
% plot3c(X,Y,Z,V,'o','Title')
% 
% This function is an extension of PLOTC.
%
% Example:
% The seismic P-velocity (v) depends on the three parameters porosity (por) and the
% bulk moduli of the saturating fluid (kf) and the elastic frame (kd). To plot the
% velocity data as a function of these three parameters use (assuming that
% all data are given in vectors):
%
% plot3c(por,kd,kf,v,'d','Velocity')
%
% Uli Theune, University of Alberta, 2004
% utheune@phys.ualberta.ca
%

if mod(length(x)+length(y)+length(z)+length(v),4)
    disp('All vectors must be of same length')
    return
end
delete(gca)
if nargin <5
    marker='.';
end
if nargin < 6
    string=' ';
end
% Define the data range
miv=min(v);
mav=max(v);
% Get the current colormap
map=colormap;
% Plot the points
hold on
for i=1:length(x)
    in=round((v(i)-miv)*(length(map)-1)/(mav-miv));
    %--- Catch the out-of-range numbers
    if in==0;in=1;end
    if in > length(map);in=length(map);end
    plot3(x(i),y(i),z(i),marker,'color',map(in,:),'markerfacecolor',map(in,:))
end
hold off

% Re-format the colorbar
h=colorbar;

set(h,'ylim',[1 length(map)]);
yal=linspace(1,length(map),10);
set(h,'ytick',yal);
% Create the yticklabels
ytl=linspace(miv,mav,10);
s=char(10,4);
for i=1:10
    if abs(min(log10(abs(ytl)))) <= 3
        B=sprintf('%-4.3f',ytl(i));
    else
        B=sprintf('%-4.2E',ytl(i));
    end
    s(i,1:length(B))=B;
end
set(h,'yticklabel',s,'fontsize',9);
grid on
set(get(h,'title'),'string',string,'fontweight','bold')
view(3)
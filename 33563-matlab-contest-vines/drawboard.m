function [ha,ph] = drawboard(varargin)
% DRAWBOARD Draws the board and the vine
%
% USAGE:
%   DRAWBOARD(BOARD)
%   DRAWBOARD(BOARD,VINE)
%   DRAWBOARD(BOARD,MOVES,VINE)

% The MATLAB Contest Team 
% Copyright 2011 The MathWorks, Inc.

if isscalar(varargin{1}) && ishandle(varargin{1}) && strcmp(get(varargin{1},'Type'),'axes')
    ha = varargin{1};
    axes(ha); cla; hold on; box off
    set(ha,'Ytick',[],'Ydir','reverse','Xtick',[],'Ycolor','w','Xcolor','w')
    board = varargin{2};
    vine = varargin{3};
else
    clf
    figure(gcf)
    set(gcf,'MenuBar','none','Name','The Vines MATLAB Contest','NumberTitle','off','color','w')
    if nargin == 3
        subplot(1,2,1)
        set(gca,'Position',[0 0 .5 1])
        drawboard(gca,varargin{1},[]);
        [~,newboard] = grade(varargin{2},varargin{3},varargin{1},inf);
        subplot(1,2,2)
        set(gca,'Position',[.5 0 .5 1])
        [ha,ph] = drawboard(gca,newboard,varargin{3});
    else
        if nargin==1
            [ha,ph] = drawboard(gca,varargin{1},[]);
        else
            [ha,ph] = drawboard(gca,varargin{1},varargin{2});
        end
    end
    if nargout ==0
        clear ha
    end
    return
end

[i,j] = find(board);
[x,y,z] = cubephere(.40,30);
[m,n] = size(board);
mn = numel(board);

% Draw pieces
ph = zeros(numel(i));
for k = 1:numel(i)
    if mn<500
        ph(i(k),j(k)) = surf(x+j(k),y+i(k),z+board(i(k),j(k)));
        text(j(k),i(k),1+board(i(k),j(k)),num2str(board(i(k),j(k))),'color','w','horizontalalignment','center','FontWeight','bold','FontUnits','normalized','FontSize',1/m/3);
    else
       ph(i(k),j(k)) = patch(j(k)+[-.40 -.40 .40 .40],i(k)+[-.40 .40 .40 -.40],board(i(k),j(k)).*[1 1 1 1]);
    end
end

axis equal
shading interp
axis([0.5-1 n+.5+1 0.5-1 m+.5+1])
lightangle(223.1066,58.59)
lighting phong
if mn>=500
    colorbar
end
set(ha,'CliMmode','manual')

for i = 1:n
    for j = 1:m
       h = patch([i-.48 i-.48 i+.48 i+.48],[j-.48 j+.48 j+.48 j-.48],[-1 -1 -1 -1],[1 1 .93]);
       set(h,'EdgeColor',[.8 .8 .8])
       if any(sub2ind([m,n],j,i) == vine)
           set(h,'FaceColor',[0 .5 0])
       end
    end
end

end

function [x,y,z] = cubephere(r,n)
theta = (-n:2:n)'/n*pi;
phi = ([-n:1:-n/2+1 n/2-1:1:n])/n*pi/2;
r1 = sqrt((1./(tan(theta).^8+1)).^(1/4)+(1./(tan(theta).^-8+1)).^(1/4));
r2 = sqrt((1./(tan(phi).^8+1)).^(1/4)+(1./(tan(phi).^-8+1)).^(1/4));
x = r*r1.*cos(theta)*(r2.*cos(phi));
y = r*r1.*sin(theta)*(r2.*cos(phi));
z = r*ones(numel(theta),1)*(r2.*sin(phi));
end
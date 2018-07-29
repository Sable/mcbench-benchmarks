function visualizetiles(board, orientation, tiles, visualizationMethod)
% VISUALIZETILES Draws the board and the tiles

% The MATLAB Contest Team
% Copyright 2012 The MathWorks, Inc.

clf;
if visualizationMethod == 1
    BoardVisualizer(tiles, board, orientation);
elseif visualizationMethod == 2
    ScoreVisualizer(tiles, board ,orientation);
end

end

function h = BoardVisualizer(tiles, pos, rot)

[row,col] = size(pos);
boardcapacity = nnz(pos);
y_tile_loc = (pos.') ~= 0;
x_tile_loc = (pos.') ~= 0;

%Rotate tiles matrix into correct position
tiles = rotateTiles(tiles,rot);

%Rearrange tiles and add zeros
inds = pos';
inds = inds(:);
inds(inds == 0) = [];
tiles = tiles(inds,:);

%Set up figure
axis equal
axis off
hold on
colormap(rot90(pink,2));
set(gcf,'color','w')

%Plot background mesh
h.mesh = mesh(0:col,0:row,zeros(row+1,col+1));
set(h.mesh,'facealpha',0,'linewidth',1,'edgecolor','k');

if isempty(tiles)
    return;  % empty board -- nothing else to do
end

%Plot patch for north, east, south, and west wedges
X = repmat([0:col-1; .5:col; 1:col],1,row);
X = X(:,x_tile_loc);
y1 = repmat(row:-1:1,col,1);
y1 = y1(y_tile_loc);
Y = [reshape(y1,1,boardcapacity);
    reshape(y1,1,boardcapacity)-.5;
    reshape(y1,1,boardcapacity)];
h.north = patch('XData',X, 'YData',Y, 'CDataMapping','scaled', 'CData',tiles(:,1)','linestyle','none', 'FaceColor','flat');
hold on
Xt = X(2,:);
Yt = Y(1,:) - 1/6;
h.northText = text(Xt,Yt,num2str(tiles(:,1)),'fontweight','bold');

X = repmat([1:col; .5:col; 1:col],1,row);
X = X(:,x_tile_loc);
y1 = repmat(row:-1:1,col,1);
y1 = y1(y_tile_loc);
Y = [reshape(y1,1,boardcapacity);
    reshape(y1,1,boardcapacity)-.5;
    reshape(y1,1,boardcapacity)-1];
h.east = patch('XData',X, 'YData',Y, 'CDataMapping','scaled', 'CData',tiles(:,2)','linestyle','none', 'FaceColor','flat');
Xt = X(1,:) - 1/6;
Yt = Y(2,:);
h.eastText = text(Xt,Yt,num2str(tiles(:,2)),'fontweight','bold');

X = repmat([0:col-1; .5:col; 1:col],1,row);
X = X(:,x_tile_loc);
y1 = repmat(row-1:-1:0,col,1);
y1 = y1(y_tile_loc);
Y = [reshape(y1,1,boardcapacity);
    reshape(y1,1,boardcapacity)+.5;
    reshape(y1,1,boardcapacity)];
h.south = patch('XData',X, 'YData',Y, 'CDataMapping','scaled', 'CData',tiles(:,3)','linestyle','none', 'FaceColor','flat');
Xt = X(2,:);
Yt = Y(1,:) + 1/6;
h.southText = text(Xt,Yt,num2str(tiles(:,3)),'fontweight','bold');

X = repmat([0:col-1; .5:col; 0:col-1],1,row);
X = X(:,x_tile_loc);
y1 = repmat(row:-1:1,col,1);
y1 = y1(y_tile_loc);
Y = [reshape(y1,1,boardcapacity);
    reshape(y1,1,boardcapacity)-.5;
    reshape(y1,1,boardcapacity)-1];
h.west = patch('XData',X, 'YData',Y, 'CDataMapping','scaled', 'CData',tiles(:,4)','linestyle','none', 'FaceColor','flat');
Xt = X(1,:) + 1/6;
Yt = Y(2,:);
h.westText = text(Xt,Yt,num2str(tiles(:,4)),'fontweight','bold');

clim = [min(tiles(:)), max(tiles(:))];
range = diff(clim);
clim(1) = clim(1) - 0.1*range;
clim(2) = clim(2) + 0.1*range;
set(gca,'CLim',clim);
end

function h = ScoreVisualizer(tiles,pos,rot)

%Get size information and initialize values matrix
brow = size(pos,1);
bcol = size(pos,2);
bsize = [brow, bcol];
vsize = [2*brow+1,bcol+1];

%Rotate tiles matrix into correct position
tiles = rotateTiles(tiles,rot);
%Determine the score of each element in values matrix
values = evaluateBoard(tiles,pos,vsize,bsize);

h = drawResults(values,bsize);
end

function tout = rotateTiles(tin,rot)
tout = zeros(size(tin));
for i = 1:length(rot)
    tout(i,:) = circshift(tin(i,:), [0 1-rot(i)]);
end
end

function values = evaluateBoard(tiles,pos,vsize,bsize)
values = zeros(vsize(1),vsize(2));
values(logical(mod(1:vsize(1),2)),end) = NaN(bsize(1)+1,1);
for r = 1:2:vsize(1)
    for c = 1:vsize(2)-1
        above = (r-1)/2;
        below = (r+1)/2;
        if r == 1 %first row
            if pos(below,c) ~= 0
                values(r,c) = abs(tiles(pos(below,c),1));
            end
        elseif r == vsize(1) %last row
            if pos(above,c) ~= 0
                values(r,c) = abs(tiles(pos(above,c),3));
            end
        else %middle rows
            if pos(below,c) ~= 0 && pos(above,c) ~= 0
                values(r,c) = abs(tiles(pos(above,c),3)-...
                    tiles(pos(below,c),1));
            elseif pos(below,c) ~= 0 && pos(above,c) == 0
                values(r,c) = abs(tiles(pos(below,c),1));
            elseif pos(below,c) == 0 && pos(above,c) ~= 0
                values(r,c) = abs(tiles(pos(above,c),3));
            end
        end
    end
end
for r = 2:2:vsize(1)
    for c = 1:vsize(2)
        left = c-1;
        right = c;
        if c == 1 % first column
            if pos(r/2,right) ~= 0
                values(r,c) = abs(tiles(pos(r/2,right),4));
            end
        elseif c == vsize(2) % last column
            if pos(r/2,left) ~= 0
                values(r,c) = abs(tiles(pos(r/2,left),2));
            end
        else % middle columns
            if pos(r/2,right) ~= 0 && pos(r/2,left) ~= 0
                values(r,c) = abs(tiles(pos(r/2,right),4)-...
                    tiles(pos(r/2,left),2));
            elseif pos(r/2,right) ~= 0 && pos(r/2,left) == 0
                values(r,c) = abs(tiles(pos(r/2,right),4));
            elseif pos(r/2,right) == 0 && pos(r/2,left) ~= 0
                values(r,c) = abs(tiles(pos(r/2,left),2));
            end
        end
    end
end
end

function h = drawResults(values,b)
%Define x coordinates of patches
X = repmat([  0:b(2)-1  -0.5:b(2)  ;
    0.5:b(2)       0:b(2)  ;
    1:b(2)     0.5:b(2)+1;
    0.5:b(2)       0:b(2)   ],1,b(1));
X = [X [  0:b(2)-1  ;
    0.5:b(2)    ;
    1:b(2)    ;
    0.5:b(2)]];

%Define y coordinates of patches
Y =    repmat([b(1)     b(1)-.5  b(1)     b(1)+.5]',1,b(2));
Y = [Y repmat([b(1)-.5  b(1)-1   b(1)-.5  b(1)   ]',1,b(2)+1)];
Y = repmat(Y,1,b(1));
start = 1;
for i = 1:b(1)
    Y(:,start:i*(b(2)*2+1)) = Y(:,start:i*(b(2)*2+1)) - (i-1);
    start = i*(b(2)*2+1) + 1;
end
Y = [Y repmat([0 -.5 0 .5]',1,b(2))];

%Define colors of patches
C = values';
C = C(:)';
C(isnan(C)) = [];

h.p = patch(X,Y,C);
set(h.p,'linestyle','none');
axis equal
axis off
set(gcf,'color','k')
colormap copper
if max(values(:)) < 1e-8
    set(gca,'climmode','manual','clim',[0 1]);
end

hold on
h.m = mesh(0:b(2),0:b(1),zeros(b(1)+1,b(2)+1));
set(h.m,'facealpha',0,'linewidth',2,'edgecolor','w')
hold off
end
function board = designboard(file)

%
% This program allows you to draw a board, based on some image (file). Each
% territory is drawn by clicking the coordinates of its vertices. On
% clicking the first vertex again, the patch is closed. To finish the
% territory, click again somewhere in the middle. This determines the
% position where the number of troops will be shown. You can ofcourse draw
% any kind of board, having arbitrary names and continents. However, to be
% fully compatible with the playrisk-program, the board should have the
% same continents as the original game: Asia, North-America, Europe,
% Africa, Australia and South-America. Moreover, the map should be fully
% interconnected. This means that it should be possible to travel from any
% territory to any other territory: no isolated patches. This program keeps
% track of the neighbouring patches, but oversea connections should be
% specified manually using the 'connect()' function. If you downloaded this
% file from the Mathworks Central File Exchange, there should be a
% predesigned board included meeting these requirements. An optional
% feature is the display of lines between two patches. This should also
% be done outside this program using the lines() function.
%

sz = [800, 600];
close(findobj('Name', 'Board'))
board = struct('Name',[],'Continent',[],'Neighbors',[],'xy',[],'TextPos',[], 'lines', []);
res = get(0, 'ScreenSize');
fig = figure('Name', 'Board', 'Position', res);
ax  = axes('Parent', fig, 'XLim', [0, sz(1)], 'YLim', [0, sz(2)]);

if nargin == 1 && exist(file, 'file')
    pic = imread(file);
    imshow(pic, 'Parent', ax, 'InitialMagnification', 'fit');
end

eps = 5;    % Welding treshold

%% MAKE BOARD
count = 1;
while true
    prompt = {'Name','Continent'};
    data = inputdlg(prompt, 'Name', 1, {'',''});
    if isempty(data)
        break
    end
    [x, y, nblist, tp] = getxy(board, eps);
    poly = patch(x, y, [0 0 0]);
    set(poly, 'EdgeColor', [1 0 0], 'Marker', '.', 'MarkerEdgeColor', [0 0 1]);
    ok = questdlg('OK?', 'Verify', 'Yes', 'No', 'Yes');
    if strcmp(ok, 'Yes')
        board(count) = struct('Name', data{1},          ...
                              'Continent', data{2},     ...
                              'Neighbors', nblist,      ...
                              'xy', [x,y],              ...
                              'TextPos', tp, ...
                              'lines', []);
        count = count + 1;
        set(poly, 'FaceColor', [.5 .5 .5])
    else
        delete(poly);
    end
end

%% SYNCHRONIZE NEIGHBORS
for i = 1:numel(board)
    for j = board(i).Neighbors
        if isempty(find(board(j).Neighbors == i, 1))
            board(j).Neighbors = [board(j).Neighbors, i];
        end
    end
end

%% FINALIZE
if isempty(board(1).Name)
    close(fig);
    return
end

for i = 1:numel(board)
    board(i).xy(:,2) =  sz(2) - board(i).xy(:,2);
    board(i).TextPos(2) = sz(2) - board(i).TextPos(2);
end
close(fig);
    
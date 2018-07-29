function board = lines(board)

% Add lines to your board by clicking the begin- and endcoordinates. Exit
% by right clicking.

ui = questdlg('Continuing will destroy all line-information that is already in your current board.', ...
              'Continue?', 'Continue', 'Stop');

if ~strcmp(ui, 'Continue')
    return;
end

for i = 1:numel(board)
    p = patch(board(i).xy(:,1), board(i).xy(:,2), [1 1 1]);
    set(p, 'EdgeColor', [0 0 0]);
end

set(gca, 'XTick', [], 'YTick', [], 'box', 'on')
xlim([0, 800])
ylim([0, 600])

eps = 5;

while true
    [x1,y1,button] = ginput(1);
    if button == 3
        break
    end
    
    [x2,y2,button] = ginput(1);
    if button == 3
        continue
    end
    
    % Try to make straight lines
    if abs(x1 - x2) < eps
        x1 = 1/2 * (x1 + x2);
        x2 = x1;
    end
    if abs(y1 - y2) < eps
        y1 = 1/2 * (y1 + y2);
        y2 = y1;
    end 
    
    % No lines outside the borders (800x600)
    x = [x1, x2];
    x(x < 0) = 0;
    x(x > 800) = 800;
    y = [y1, y2];
    y(y < 0) = 0;
    y(y > 600) = 600;
    
    l = line(x, y, 'LineStyle', '--');
    ui = questdlg('OK?', 'OK?', 'Yes', 'No', 'Yes');
    switch ui
        case 'Yes'
            L(end + 1, :) = [x, y]; %#ok<AGROW>
        otherwise
            delete(l)
            continue
    end
end

close(gcf);

function thyme = maze(row,col,pattern)
% usage  thyme = maze(30,45,'c');
% row - number of rows in the maze
% col - number of column in the maze
% pattern - random(r), vertical(v), horizontal(h), checkerboard(c), spiral(s), burst(b)

% Written by Rodney Meyer
% rodney_meyer@yahoo.com
%
% Construct graph system for maze. The graph entities are an id for each
% intersection(id), the physical row(rr) and column(cc) of the
% intersection, membership to a connected region (state), and a link to 
% adjacent intersections(ptr_up ptr_down ptr_left ptr_right). 
% Prior to "make_pattern" the maze has all of the walls intact and
% there are row*col of unconnected states. After "make_pattern" some of the
% walls are broken down and there is only one connected state for the maze.
% A broken wall(allowed passage) in some direction is signified by a negative
% value of the pointer in that direction. A solid wall(unallowed passage) 
% in some direction is signified by a positive value of the pointer in that 
% direction. The absolute value of the pointer is the id of the
% intersection in that direction.

rand('state',sum(100*clock))

[cc,rr]=meshgrid(1:col,1:row);
state = reshape([1:row*col],row,col); % state identifies connected regions
id = reshape([1:row*col],row,col); % id identifies intersections of maze

% create pointers to adjacent intersections
ptr_left = zeros(size(id));
ptr_up = zeros(size(id));
ptr_right = zeros(size(id));
ptr_down = zeros(size(id));

ptr_left(:,2:size(id,2)) = id(:,1:size(id,2)-1);
ptr_up(2:size(id,1),:) = id(1:size(id,1)-1,:);
ptr_right(:,1:size(id,2)-1) = id(:,2:size(id,2));
ptr_down(1:size(id,1)-1,:) = id(2:size(id,1),:);

% sort graph entities by id
the_maze = cat(2,reshape(id,row*col,1),reshape(rr,row*col,1),reshape(cc,row*col,1),reshape(state,row*col,1),...
    reshape(ptr_left,row*col,1),reshape(ptr_up,row*col,1),reshape(ptr_right,row*col,1),reshape(ptr_down,row*col,1)  );

the_maze = sortrows(the_maze);

id=the_maze(:,1);
rr=the_maze(:,2);
cc=the_maze(:,3);
state=the_maze(:,4);
ptr_left=the_maze(:,5);
ptr_up=the_maze(:,6);
ptr_right=the_maze(:,7);
ptr_down=the_maze(:,8);
clear the_maze;

% create a random maze
[state, ptr_left, ptr_up, ptr_right, ptr_down]=...
    make_pattern(row,col,pattern,id, rr, cc, state, ptr_left, ptr_up, ptr_right, ptr_down);

% show maze
h=figure('KeyPressFcn',@move_spot,'color','white');
show_maze(row, col, rr, cc, ptr_left, ptr_up, ptr_right, ptr_down,h);

% start play
cursor_pos=[1,1];
current_id=1;
figure(h)
text(cursor_pos(1),cursor_pos(2),'\diamondsuit','HorizontalAlignment','Center','color','r');
set(gcf,'Units','normalized');
set(gcf,'position',[0 0 1 .91]);
tic

% keep processing keystrokes until the maze is solved
while ~all(cursor_pos == [col,row])
    waitfor(gcf,'CurrentCharacter')
    set(gcf,'CurrentCharacter','~') % update to another character so repeats are recognized
    % key is updated by move_spot
    switch double(key(1))
        case 108 % left
            if ptr_left(current_id)<0 % check for legal move
                current_id=-ptr_left(current_id);
                text(cursor_pos(1),cursor_pos(2),'\diamondsuit','HorizontalAlignment','Center','color',[.8,.8,.8]);
                cursor_pos(1)=cursor_pos(1)-1;
                text(cursor_pos(1),cursor_pos(2),'\diamondsuit','HorizontalAlignment','Center','color','r');
            end
        case 114 % right
            if ptr_right(current_id)<0 % check for legal move
                current_id=-ptr_right(current_id);
                text(cursor_pos(1),cursor_pos(2),'\diamondsuit','HorizontalAlignment','Center','color',[.8,.8,.8]);
                cursor_pos(1)=cursor_pos(1)+1;
                text(cursor_pos(1),cursor_pos(2),'\diamondsuit','HorizontalAlignment','Center','color','r');
            end
        case 117 % up
            if ptr_up(current_id)<0 % check for legal move
                current_id=-ptr_up(current_id);
                text(cursor_pos(1),cursor_pos(2),'\diamondsuit','HorizontalAlignment','Center','color',[.8,.8,.8]);
                cursor_pos(2)=cursor_pos(2)-1;
                text(cursor_pos(1),cursor_pos(2),'\diamondsuit','HorizontalAlignment','Center','color','r');
            end
        case 100 % down
            if ptr_down(current_id)<0 % check for legal move
                current_id=-ptr_down(current_id);
                text(cursor_pos(1),cursor_pos(2),'\diamondsuit','HorizontalAlignment','Center','color',[.8,.8,.8]);
                cursor_pos(2)=cursor_pos(2)+1;
                text(cursor_pos(1),cursor_pos(2),'\diamondsuit','HorizontalAlignment','Center','color','r');
            end

        otherwise
    end

end

thyme=toc;
title(cat(2,' Winning Time ',num2str(round(thyme*100)/100),'(sec)'),'FontSize',20)
return

function move_spot(src,evnt)
assignin('caller','key',evnt.Key)
return


function show_maze(row, col, rr, cc, ptr_left, ptr_up, ptr_right, ptr_down,h)
figure(h)
line([.5,col+.5],[.5,.5]) % draw top border
line([.5,col+.5],[row+.5,row+.5]) % draw bottom border
line([.5,.5],[1.5,row+.5]) % draw left border
line([col+.5,col+.5],[.5,row-.5])  % draw right border
for ii=1:length(ptr_right)
    if ptr_right(ii)>0 % right passage blocked
        line([cc(ii)+.5,cc(ii)+.5],[rr(ii)-.5,rr(ii)+.5]);
        hold on
    end
    if ptr_down(ii)>0 % down passage blocked
        line([cc(ii)-.5,cc(ii)+.5],[rr(ii)+.5,rr(ii)+.5]);
        hold on
    end
    
end
axis equal
axis([.5,col+.5,.5,row+.5])
axis off
set(gca,'YDir','reverse')
return




function [state, ptr_left, ptr_up, ptr_right, ptr_down]=make_pattern(row,col,pattern,id, rr, cc, state, ptr_left, ptr_up, ptr_right, ptr_down)

while max(state)>1 % remove walls until there is one simply connected region
    tid=ceil(col*row*rand(15,1)); % get a set of temporary ID's
    cityblock=cc(tid)+rr(tid); % get distance from the start
    is_linked=(state(tid)==1); % The start state is in region 1 - see if they are linked to the start
    temp = sortrows(cat(2,tid,cityblock,is_linked),[3,2]); % sort id's by start-link and distance
    tid = temp(1,1); % get the id of the closest unlinked intersection
    
    % The pattern is created by selective random removal of vertical or 
    % horizontal walls as a function of position in the maze. I find the
    % checkerboard option the most challenging. Other patterns can be added
    switch upper(pattern) 
    case 'C' % checkerboard
        dir = ceil(8*rand);
        nb=3;
        block_size =  min([row,col])/nb;
        while block_size>12
            nb=nb+2;
            block_size =  min([row,col])/nb;
        end
        odd_even = (ceil(rr(tid)/block_size)*ceil(col/block_size) + ceil(cc(tid)/block_size));
        if odd_even/2 == floor(odd_even/2)
            if dir>6
                dir=4;
            end
            if dir>4
                dir=3;
            end
        else
            if dir>6
                dir=2;
            end
            if dir>4
                dir=1;
            end
        end
    case 'B' % burst
        dir = ceil(8*rand);
        if abs((rr(tid)-row/2))<abs((cc(tid)-col/2))
            if dir>6
                dir=4;
            end
            if dir>4
                dir=3;
            end
        else
            if dir>6
                dir=2;
            end
            if dir>4
                dir=1;
            end
        end
    case 'S' %spiral
        dir = ceil(8*rand);
        if abs((rr(tid)-row/2))>abs((cc(tid)-col/2))
            if dir>6
                dir=4;
            end
            if dir>4
                dir=3;
            end
        else
            if dir>6
                dir=2;
            end
            if dir>4
                dir=1;
            end
        end
    case 'V'
        dir = ceil(8*rand);
        if dir>6
            dir=4;
        end
        if dir>4
            dir=3;
        end
    case 'H'
        dir = ceil(8*rand);
        if dir>6
            dir=2;
        end
        if dir>4
            dir=1;
        end
        otherwise % random
        dir = ceil(4*rand);
    end
    
    % after a candidate for wall removal is found, the candidate must pass
    % two conditions. 1) it is not an external wall  2) the regions on
    % each side of the wall were previously unconnected. If successful the
    % wall is removed, the connected states are updated to the lowest of
    % the two states, the pointers between the connected intersections are
    % now negative.
    switch dir
    case -1
        
    case 1
        if ptr_left(tid)>0 & state(tid)~=state(ptr_left(tid))
            state( state==state(tid) | state==state(ptr_left(tid)) )=min([state(tid),state(ptr_left(tid))]);
            ptr_right(ptr_left(tid))=-ptr_right(ptr_left(tid));
            ptr_left(tid)=-ptr_left(tid);
        end
    case 2
        if ptr_right(tid)>0 & state(tid)~=state(ptr_right(tid))
            state( state==state(tid) | state==state(ptr_right(tid)) )=min([state(tid),state(ptr_right(tid))]);
            ptr_left(ptr_right(tid))=-ptr_left(ptr_right(tid));
            ptr_right(tid)=-ptr_right(tid);
        end
    case 3
        if ptr_up(tid)>0 & state(tid)~=state(ptr_up(tid))
            state( state==state(tid) | state==state(ptr_up(tid)) )=min([state(tid),state(ptr_up(tid))]);
            ptr_down(ptr_up(tid))=-ptr_down(ptr_up(tid));
            ptr_up(tid)=-ptr_up(tid);
        end
    case 4
        if ptr_down(tid)>0 & state(tid)~=state(ptr_down(tid))
            state( state==state(tid) | state==state(ptr_down(tid)) )=min([state(tid),state(ptr_down(tid))]);
            ptr_up(ptr_down(tid))=-ptr_up(ptr_down(tid));
            ptr_down(tid)=-ptr_down(tid);
        end
    otherwise
        dir
        error('quit')
    end
    
end
return
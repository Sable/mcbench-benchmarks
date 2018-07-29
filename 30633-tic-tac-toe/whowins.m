function [winner] = whowins (plr, box)
    winner=0;
    % logic for winner
    if box(1,1)==plr && box(1,2)==plr && box(1,3)==plr
        winner=box(1,1);
        return;
    elseif box(2,1)==plr && box(2,2)==plr && box(2,3)==plr
        winner=box(2,1);
        return;
    elseif box(3,1)==plr && box(3,2)==plr && box(3,3)==plr
        winner=box(3,1);
        return;
    elseif box(1,1)==plr && box(2,1)==plr && box(3,1)==plr
        winner=box(1,1);
        return;
    elseif box(1,2)==plr && box(2,2)==plr && box(3,2)==plr
        winner=box(1,2);
        return;
    elseif box(1,3)==plr && box(2,3)==plr && box(3,3)==plr
        winner=box(1,3);
        return;
    elseif box(1,1)==plr && box(2,2)==plr && box(3,3)==plr
        winner=box(1,1);
        return;
    elseif box(1,3)==plr && box(2,2)==plr && box(3,1)==plr
        winner=box(1,3);
        return;
    % logic for a draw that is winner=3
    % all boxes should be full
    elseif box(1)~=0 && box(2)~=0 && box(3)~=0 && box(4)~=0 && box(5)~=0 && box(6)~=0 && box(7)~=0 && box(8)~=0 && box(9)~=0
        winner=-1;
    end
end
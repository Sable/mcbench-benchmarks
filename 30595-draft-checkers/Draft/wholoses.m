function [loser] = wholoses(plr,box)
    loser=0; % "0" means no loser yet
    % the player having no piece on table will lose
    for x=1:8
        for y=1:8
            if box(x,y)==plr
                loser=0;
                return;
            elseif box(x,y)~=plr
                loser=plr;
            end
        end
    end
end
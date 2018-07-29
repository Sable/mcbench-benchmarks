function [loser] = wholoses(plr,box)
    loser=0; % "0" means no loser yet
    % the player having no piece on table will lose
    for x=1:8
        for y=1:8
            if plr==1 && box(x,y)==10   %king1 is present KING=10
                loser=0;
                return;
            elseif plr==2 && box(x,y)==-10 %king2 is present king=-10
                loser=0;
                return;
            else
                loser=plr;
            end
        end
    end
end
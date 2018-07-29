function [h] = playerturn(ha,h)
% if it is the start of the turn then...    
% act only if the player is trying to move his own piece
if (h.plr==1 && h.box(h.r,h.c)>0) || ...
   (h.plr==2 && h.box(h.r,h.c)<0)
        h.ipr=h.r;
        h.ipc=h.c;   
        rc=h.r*10+h.c;
        h.plrpiece=get(ha(rc),'CData');
        h.plrmark=whichpiece(h);
% if it is the completion of turn then...    
else % it should not be the foremost turn
    h.fpr=h.r;
    h.fpc=h.c;
    %first check whether its a valid turn or not.
    [check,h] = checkfp(ha,h);
    if check==1
%         if valid change the display of the buttons accordingly
%         changing the initial button's display
        rc=h.ipr*10+h.ipc;
        if rem(h.ipr+h.ipc,2)==0
            set(ha(rc),'CData',h.white);
        elseif rem(h.ipr+h.ipc,2)~=0
            set(ha(rc),'CData',h.black);
        end
%         changing the destination button's display
        rc=h.fpr*10+h.fpc;
        h.plrpiece=reqmark(h);  % conversion of plrmark(like -1) to piece(like whitepawn)
        set(ha(rc),'CData',h.plrpiece);
%         if valid then update box
        h.box(h.ipr,h.ipc)=0;
        h.box(h.fpr,h.fpc)=h.plrmark;
%         and update player
        if h.plr==1
            h.plr=2;
            set(ha(1),'CData',h.whiteking1);
        else
           h.plr=1;
           set(ha(1),'CData',h.blackking2);
        end
%       now zero the initial position
        h.ipr=0;
        h.ipc=0;
%        loser command is applied after updating plr becoz one will turn
%        and other will lose, so ohter one needs to be checked
        loser=wholoses(h.plr,h.box);
        if loser~=0
            if loser==2
                msgbox('CHESS KING','Winner','custom',h.blackking2);
            elseif loser==1
                msgbox('CHESS KING','Winner','custom',h.whiteking1);
            elseif loser==-1
                msgbox('Its a Draw');
            end
            close(gcbf);
        end
    else
%       if wrong input then initialize the positions so as to get input again
        msgbox('Wrong input','Error');
        h.ipr=0;
        h.ipc=0;
        h.fpr=0;
        h.fpc=0;
    end
end
end
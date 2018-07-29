function [handles] = playerturn(ha,handles)
%if it is the start of the turn then...    
if handles.ipx==0
%     act only if the player is trying to move his own piece
    if handles.box(handles.x,handles.y)==handles.plr
        handles.ipx=handles.x;
        handles.ipy=handles.y;    
    end
%if it is the completion of turn then...    
else
    handles.fpx=handles.x;
    handles.fpy=handles.y;
    %first check whether its a valid turn or not.
    [check,handles.box] = checkfp(ha,handles.plr,handles.box,handles.ipx,handles.ipy,handles.fpx,handles.fpy,handles.dblbox,handles.blank);
    if check==1
%         if valid then update box
        handles.box(handles.ipx,handles.ipy)=0;
        handles.box(handles.fpx,handles.fpy)=handles.plr;
%         when someone's piece reaches its end line it is now double
        if handles.plr==1 && handles.fpx==8
            handles.dblbox(handles.fpx,handles.fpy)=1;
        end
        if handles.plr==2 && handles.fpx==1
            handles.dblbox(handles.fpx,handles.fpy)=1;
        end
%     if trying to move already doubled piece then update dblbox with new location
        if handles.dblbox(handles.ipx,handles.ipy)==1
            handles.dblbox(handles.ipx,handles.ipy)=0;
            handles.dblbox(handles.fpx,handles.fpy)=1;
        end
%         and change the display of the buttons accordingly
%         changing the initial button's string
        xy=handles.ipx*10+handles.ipy;
        set(ha(xy),'CData',handles.blank)
%         changing the destination button's string
        xy=handles.fpx*10+handles.fpy;
        if handles.dblbox(handles.fpx,handles.fpy)==1 && handles.plr==1
            set(ha(xy),'CData',handles.plr1dblmark)
        elseif handles.dblbox(handles.fpx,handles.fpy)==1 && handles.plr==2
            set(ha(xy),'CData',handles.plr2dblmark)
        elseif handles.plr==1
            set(ha(xy),'CData',handles.plr1mark)
        elseif handles.plr==2
            set(ha(xy),'CData',handles.plr2mark)
        end
%         and update player
        if handles.plr==1
            handles.plr=2;
            axes(ha(1));
            image(handles.plr2mark);    
            axis off;
        else
            handles.plr=1;
            axes(ha(1));
            image(handles.plr1mark);
            axis off;

        end
%       now zero the initial position
        handles.ipx=0;
        handles.ipy=0;
%        loser command is applied after updating plr becoz one will turn
%        and other will lose, so ohter one needs to be checked
        loser=wholoses(handles.plr,handles.box);
        if loser~=0
            if loser==2
                msgbox('BLACK Wins','Winner','custom',handles.plr1mark);
            elseif loser==1
                msgbox('RED Wins','Winner','custom',handles.plr2mark);
            elseif loser==-1
                msgbox('Its a Draw');
            end
            close(handles.figure1);
        end
    else
%       if wrong input then initialize the positions so as to get input again
        msgbox('Wrong input','Error');
        handles.ipx=0;
        handles.ipy=0;
        handles.fpx=0;
        handles.fpy=0;
    end
end
end
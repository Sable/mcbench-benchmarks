function button(hObject,eventdata,h)
    for ii=1:h.row+2
        for jj=1:h.column+2
            if h.box(ii,jj)==hObject
                h.x=ii;
                h.y=jj;
            end
        end
    end
    if get(hObject,'string')=='X'
        set(hObject,'string','?');
        return
    end
    dgt=h.game(h.x,h.y);
    if dgt<9 && dgt>0
        open(h.box(h.x,h.y),h.x,h.y,h.game);
    elseif dgt==0
        open0(h.box,h.x,h.y,h.game);
    elseif dgt==9
        openall(h);
    end
    for ii=1:h.row+2
        for jj=1:h.column+2    
            if ~isempty(get(h.box(ii,jj),'string')) || ~isempty(get(h.box(ii,jj),'cdata'))
                h.win=1;
            else h.win=0;
            end
        end
    end
    if h.win==1
        msgbox('YOU WIN','Game Ends');
    end
end
function [chk] = open(btn,x,y,game)
    
    if (isempty(get(btn,'string')) || get(btn,'string')=='?' ) && x>1 && y>1 && x<size(game,1) && y<size(game,2)
        set(btn,'String',game(x,y),'foregroundcolor','b');
        if game(x,y)==0
            set(btn,'String','.','foregroundcolor','b');
        end
        chk=game(x,y);%to store what in that place so that if zero we can reopen blocks adjacent to it
    else
        chk=.1;%if that block is not zero then atleast return something so that this bloxk should not get checked while rechecking
    end
    
end
function open0(box,x,y,game)  
    if open(box(x,y),x,y,game)==0
        open0(box,x,y,game);
    end
    if open(box(x+1,y),x+1,y,game)==0
            open0(box,x+1,y,game);
    end
    if open(box(x+1,y+1),x+1,y+1,game)==0
        open0(box,x+1,y+1,game);
    end
    if open(box(x+1,y-1),x+1,y-1,game)==0
        open0(box,x+1,y-1,game);
    end
    if open(box(x-1,y),x-1,y,game)==0
        open0(box,x-1,y,game);
    end
    if open(box(x-1,y+1),x-1,y+1,game)==0
        open0(box,x-1,y+1,game);
    end
    if open(box(x-1,y-1),x-1,y-1,game)==0
        open0(box,x-1,y-1,game);
    end
    if open(box(x,y+1),x,y+1,game)==0
        open0(box,x,y+1,game);
    end
    if open(box(x,y-1),x,y-1,game)==0
        open0(box,x,y-1,game);
    end
    
end
function openall(h)
    for ii=1:h.row+2
        for jj=1:h.column+2
            if h.game(ii,jj)==9
                if isempty(get(h.box(ii,jj),'string')) || get(h.box(ii,jj),'string')=='?'
                    set(h.box(ii,jj),'string','');
                    set(h.box(ii,jj),'cdata',h.mine);    
                end
            elseif get(h.box(ii,jj),'string')=='X'
                set(h.box(ii,jj),'string',h.game(ii,jj));
            else
                open(h.box(ii,jj),ii,jj,h.game);
            end
        end
    end
end
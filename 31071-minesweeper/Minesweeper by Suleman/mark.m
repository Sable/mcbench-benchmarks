function mark(btn,eventdata,h)
    xx=get(btn,'string');
    if isempty(xx) || xx=='?'
        set(btn,'string','X','foregroundcolor','r');
        
    end
end
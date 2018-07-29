function arrow_visible_off_on(arr,off_on)
% set arrow visible/invisible
if off_on % if visible
    for arrc=1:length(arr)
        set(arr{arrc},'visible','on');
    end
else
    for arrc=1:length(arr)
        set(arr{arrc},'visible','off');
    end
end
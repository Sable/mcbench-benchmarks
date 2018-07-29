function set_wolf(hiaw,i1,i2,is_visible)
ii=i1+(i2-1)*2;
if is_visible
    set(hiaw(ii),'visible','on');
else
    set(hiaw(ii),'visible','off');
end

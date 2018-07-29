function set_visible(hia,v)
for c=1:length(v)
    v1=v(c);
    set(hia(v1),'visible','on');
end
    
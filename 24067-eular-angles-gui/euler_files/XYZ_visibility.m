function XYZ_visibility
global xb xbt yb ybt zb zbt sXYZ

if get(sXYZ,'value') % if visible
    
    arrow_visible_off_on(xb,true);
    set(xbt,'visible','on');
    
    arrow_visible_off_on(yb,true);
    set(ybt,'visible','on');
    
    arrow_visible_off_on(zb,true);
    set(zbt,'visible','on');
    
else
    
    arrow_visible_off_on(xb,false);
    set(xbt,'visible','off');
    
    arrow_visible_off_on(yb,false);
    set(ybt,'visible','off');
    
    arrow_visible_off_on(zb,false);
    set(zbt,'visible','off');
    
end
function zoom_view(rv,zv,pv,z2x)
if get(zv,'Value')
    
    set(rv,'Value',false);
    set(pv,'Value',false);
        
    zoom on;
else
    zoom off;
end

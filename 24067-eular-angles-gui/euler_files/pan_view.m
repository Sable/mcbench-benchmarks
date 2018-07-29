function zoom_view(rv,zv,pv,z2x)
if get(pv,'Value')
    
    set(rv,'Value',false);
    set(zv,'Value',false);
        
    pan on;
else
    pan off;
end

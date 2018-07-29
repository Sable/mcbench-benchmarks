function rot_view(rv,zv,pv,z2x)
if get(rv,'Value')
    
    set(zv,'Value',false);
    set(pv,'Value',false);
            
    rotate3d on;
else
    rotate3d off;
end

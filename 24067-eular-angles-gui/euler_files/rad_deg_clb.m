function rad_deg_clb(fig,deg)
%red/deg callback
if get(deg,'Value')
    st=90/18;
else
    st=(pi/2)/18;
end

fud=get(fig,'UserData');
fud{2}=st;
set(fig,'UserData',fud);


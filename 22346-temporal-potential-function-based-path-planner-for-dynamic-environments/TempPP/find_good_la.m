function new_la = find_good_la(rows,cols,obs,goal,start,old_la,curveset)
%
%find a good look-ahead value to use
%
limits = 0.05;%set threshold
w = extend_world(rows,cols,obs,goal,old_la);
p = calc_pot_value(w);
stpot = p(start.r,start.c,1);
ti = 1;
for i = 1:16
    if curveset.cy(i) <= stpot
        ti = i;
    else
        break;
    end
end
la1 = curveset.cx(ti);
la0 = old_la;
la2 = 500;
for i = ti+1:16
    sig = std(curveset.pty((1:25)+25*(i-1)));
    mu = curveset.cy(i);
    z = (stpot - mu)/sig;
    zVal = normcdf(z);% z table value
    if (zVal <= limits)
        la2 = curveset.cx(i);
    else
        break;
    end
end
a = la2 - la0;
b = la2 - la1;
new_la = la0 + max([a b]);
end
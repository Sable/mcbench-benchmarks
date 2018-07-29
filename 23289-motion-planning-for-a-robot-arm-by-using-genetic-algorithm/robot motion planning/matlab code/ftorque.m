function f=ftorque(tt)
t1max=34;t2max=12;
t1=tt(1,:);t2=tt(2,:);
f=0;
for i=1:size(tt,2)
    if abs(t1(i)) < t1max
        tc1=0;
    else
        tc1=abs(t1(i))-t1max;
    end
    if abs(t2(i)) < t2max
        tc2=0;
    else
        tc2=abs(t2(i))-t2max;
    end
    f=f+tc1+tc2;
end

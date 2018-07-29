function f=ftorque3(tt)
t1max=45;t2max=20;t3max=5;
t1=tt(1,:);t2=tt(2,:);t3=tt(3,:);
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
    if abs(t3(i)) < t3max
        tc3=0;
    else
        tc3=abs(t3(i))-t3max;
    end
    f=f+tc1+tc2+tc3;
end
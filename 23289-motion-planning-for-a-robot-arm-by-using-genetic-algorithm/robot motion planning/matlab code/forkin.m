function m=forkin(h)
l1=1;l2=1;
for i=1:size(h,2)
    x(i)=l1*cos(h(1,i))+l2*cos(h(1,i)+h(2,i));
    y(i)=l1*sin(h(1,i))+l2*sin(h(1,i)+h(2,i));
end
m=[x;y];

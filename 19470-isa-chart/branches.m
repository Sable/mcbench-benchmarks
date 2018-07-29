i=0
for h=h1:100:h2,
    i=i+1
    chart(i,2)=T12(h)/T1;
    chart(i,3)=p12(h)/p1;
    chart(i,4)=rho12(h)/rho1;
end

for h=(h2+100):100:h3,
    i=i+1
    chart(i,2)=T23(h)/T1;
    chart(i,3)=p23(h)/p1;
    chart(i,4)=rho23(h)/rho1;
    
end

for h=(h3+100):100:h4,
    i=i+1
    chart(i,2)=T34(h)/T1;
    chart(i,3)=p34(h)/p1;
    chart(i,4)=rho34(h)/rho1;
end

for h=(h4+100):100:h5,
    i=i+1
    chart(i,2)=T45(h)/T1;
    chart(i,3)=p45(h)/p1;
    chart(i,4)=rho45(h)/rho1;
end

for h=(h5+100):100:h6,
    i=i+1
    chart(i,2)=T56(h)/T1;
    chart(i,3)=p56(h)/p1;
    chart(i,4)=rho56(h)/rho1;
end

for h=(h6+100):100:h7,
    i=i+1
    chart(i,2)=T67(h)/T1;
    chart(i,3)=p67(h)/p1;
    chart(i,4)=rho67(h)/rho1;
    
end

for h=(h7+100):100:h8,
    i=i+1
    chart(i,2)=T78(h)/T1;
    chart(i,3)=p78(h)/p1;
    chart(i,4)=rho78(h)/rho1;
end
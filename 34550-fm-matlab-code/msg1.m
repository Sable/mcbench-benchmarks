% Function of Msg(tri)
function a = msg1(t,Ta)

t1 = -0.02:1.e-4:0;
t2 = 0:1.e-4:0.02;


m1 = 1 - abs((t1+Ta)/Ta);
m1 = [zeros([1 200]),m1,zeros([1 400])];
m2 = 1 - abs((t2-Ta)/Ta);
m2 = [zeros([1 400]),m2,zeros([1 200])];

a = m1 - m2;

end
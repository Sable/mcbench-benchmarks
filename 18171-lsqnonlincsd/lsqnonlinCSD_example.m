n=128;
x0(1:n,1) = -1.9;
x0(2:2:n,1) = 2;
[x,resnorm] = lsqnonlinCSD(@bananaobj,x0,[],[],optimset('display','iter'));
n=64;
x0(1:n,1) = -1.9;
x0(2:2:n,1) = 2;
[x,resnorm] = lsqnonlinSym(@bananaobj,x0,[],[],optimset('display','iter'));
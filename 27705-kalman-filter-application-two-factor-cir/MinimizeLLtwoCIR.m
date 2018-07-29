function MinimizeLLtwoCIR
clear all
for j=1:3
method=1;
lb=[0.0001,0.0001,0.0001,-1,0.0001,0.0001,0.0001,-1,0.00001*ones(1,4)];
ub=[ones(1,length(lb))];
tau = [1/4,1/2,2,5];
if j==1
    Ya = xlsread('US.xls');
    para0=[ 0.0456    0.2228    0.0645   -0.1006    0.0039 0.1956    0.0214   -0.1450   -0.0017   -0.0000 -0.0330    0.0088];
elseif j==2
    Ya = xlsread('GER.xls');
    para0=[0.0262    0.2182    0.0283   -0.1096    0.0112    0.2033  0.0020   -0.1410  0.0012    0.0002    0.0034    0.0064];
elseif j==3
    Ya = xlsread('UK.xls');
    para0= [0.0493    0.0397    0.0366   -0.0904    0.0105    0.0762    0.0057   -0.1682   -0.0082    0.0070    0.0003   -0.0424];
end
Y=Ya(:,1:4)/100;
[nrow,ncol]=size(Y);
if method==1
    f=@(para)LLtwoCIR(para,Y,tau,nrow,ncol); %trick to pass parameter using anonymous function
    [x,fval]=fminunc(f,para0)
elseif method==2
    [x,fval]=fmincon(@LLtwoCIR,para0,[],[],[],[],lb,ub,[],[],Y, tau, nrow, ncol);
elseif method==3
    f=@(para)LLtwoCIR(para,Y,tau,nrow,ncol);
    [x,fval]=patternsearch(f,para0,[],[],[],[],lb,ub);
end
end



    
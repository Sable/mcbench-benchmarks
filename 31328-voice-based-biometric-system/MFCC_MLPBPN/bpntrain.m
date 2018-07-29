%Voice Based Biometric System
%By Ambavi K. Patel.

function bpntrain
%to generate database file use adddb.m
load db;%loading database file
cd1=cdb;
[r,c]=size(cd1);
n=1;
s=floor(r/n);
d(s*n,s*n)=0;
d(1:n,1)=1;
for t1=2:s

    d(((t1-1)*n)+1:((t1-1)*n)+n,1:s*n)=circshift(d(((t1-2)*n)+1:((t1-2)*n)+n,1:s*n),[-1 1]);    
end;
%d=eye(r);%target or desired data
net = newff(cd1',d',20);
net.divideParam.trainRatio = 100/100;  % Adjust as desired
net.divideParam.valRatio = 15/100;  % Adjust as desired
net.divideParam.testRatio = 15/100;  % Adjust as desired
% net.trainParam.epochs = 50;
%net.trainParam.goal = 0.00000000000000000000000001;
net = train(net,cd1',d');
save('nnnet','net');
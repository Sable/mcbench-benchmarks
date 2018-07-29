%Voice Based Biometric System
%By Ambavi K. Patel.

function bpntest
cb=fextr();
load db;
[r,c]=size(cdb);
n=1;
s=floor(r/n);
d(s*n,s*n)=0;
d(1:n,1)=1;
for t1=2:s

    d(((t1-1)*n)+1:((t1-1)*n)+n,1:s*n)=circshift(d(((t1-2)*n)+1:((t1-2)*n)+n,1:s*n),[-1 1]);    
end;
%d=eye(r);%target or desired data
load nnnet;
op = sim(net,cb');
y=op';


for i=1:r
    outputs = sim(net,cb');
    y=outputs';
    j=num2str(i);
   % plotregression(d(i,:),op,j)
    rgrsn(i)=d(i,:)/y;

end;


display(rgrsn);
disply(rgrsn);
% mx=max(max(rgrsn));
% mn=min(min(rgrsn));
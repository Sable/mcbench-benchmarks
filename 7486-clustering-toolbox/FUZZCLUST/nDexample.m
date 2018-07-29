function data=nDexample(cx,N,n,seedi)
rand('seed',seedi);
mu = rand(cx,n)*10;
x=[];
C=[];
for i=1:cx
    r=[];
    dum=rand(n,n)-0.5+diag(rand(n,1))+diag(ones(n,1))/3;
 %   R=dum*dum';
    R=eye(n)/3;
    for j=1:N
         r(j,:) = randn(1,size(R,1)) * R + mu(i,:);
    end  
    C=[C;ones(N,1)*i];
    x=[x;r];
end
%plot(x(:,1),x(:,2),'.');
data=[x];





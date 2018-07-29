%Voice Based Biometric System
%By Ambavi K. Patel.


function op1=cmpr(cb,cd,n,k,r,c)
op1(1:n)=0;
for j=1:n      % finding euclidian distance

  x(j)=sqrt(sum((cb(1,1:r)-cd((n*(k-1))+j,1:r)).^2));
    y(j)=sqrt(sum((cb(1,r+1:r+c)-cd((n*(k-1))+j,r+1:r+c)).^2));
    

    if x(j)<0.05 && y(j)<3     % comparing with threshold values
        op1(j)=1;
    else op1(j)=0;
    end;
end;
% display(x);
% display(y);
%   


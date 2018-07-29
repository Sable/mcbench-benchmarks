%Voice Based Biometric System
%By Ambavi K. Patel.


function cb=centr(var)
[r1,c1]=size(var);

    for j=1:c1
     cbc1(1,j)=sqrt(sum(var(1:r1,j).^2))/r1;  % to find centroid value of each column
    end;
    for j=1:r1
        cbr1(1,j)=sqrt(sum(var(j,1:c1).^2))/c1; %to find centroid value for each row
    end;
    
    cb(1,1:r1)=cbr1(1,:);cb(1,r1+1:r1+c1)=cbc1(1,:);
  
end
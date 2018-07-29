%Voice Based Biometric System
%By Ambavi K. Patel.


function w1=nanclr(w1)  % to replace  'not a number' vlues
[r1,c1]=size(w1);
for i=1:r1
    temp=isnan(w1(i,1:c1));
    for j=1:c1
        if temp(j)==1
            w1(i,j)=0.0001;
        else
        end;
    end;
end;
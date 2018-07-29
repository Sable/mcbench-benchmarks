function [U]=routh(R1,R2)
%these function make next row of routh hurwits
%R2 , R1 must be vector array or cell vector but both format must be same
%length R2 should be same with R1
%these function use match.m for same dimension
%output is a vector
nu=0;
ce=0;
if isnumeric(R1) && isnumeric(R2)
    a=[];
    nu=1;
elseif iscell(R1) && iscell(R2)
    a=sym;
    ce=1;
else
    nu=0;
    ce=0;
end    
m=length(R1);
n=length(R2);
if m<n
    R1=match(R1,R2);
end

if n<m
    R2=match(R2,R1);
end
k=2;

if nu==1
    a(1,1)=R1(1,1);
    a(2,1)=R2(1,1);
elseif ce==1
    a(1,1)=R1{1,1};
    a(2,1)=R2{1,1};
end

for f=1:m
    if k~=f
        if nu==1
            a(1,2)=R1(1,k);
            a(2,2)=R2(1,k);
            U(1,f)=(-det(a))/R2(1,1);
        elseif ce==1
            a(1,2)=R1{1,k};
            a(2,2)=R2{1,k};
            U(1,f)=(-det(a))/R2{1,1};
        end
    end
    if k~=m
        k=k+1;
    end
end

if length(U)<m
    U=match(U,R1);
end
    
    

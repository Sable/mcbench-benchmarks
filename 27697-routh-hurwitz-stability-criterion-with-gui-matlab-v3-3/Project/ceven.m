function [B]=ceven(C)
%these function choice element of vector with even indices of column
k=1;
for i=2:2:length(C)
    B(1,k)=C(1,i);
    k=k+1;
end

function [Z]=csz(S)
%these function set one by one zero between start and end input vector
r=1;
o=2;
for a=1:length(S)
    Z(1,r)=S(1,a);
    r=r+2;
    Z(1,o)=0;
    o=o+2;
end
Z(o-2)=[];
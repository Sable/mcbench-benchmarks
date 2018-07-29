% Apply boundary conditions
function [kk,ff]=feaplyc(kk,ff,bcdof,bcval)
syms X1 X2 X3
n=length(bcdof);
sdof=size(kk);
for i=1:n
    c=bcdof(i);
    ff(c)=bcval(i);
    for j=1:sdof
        kk(c,j)=0;
        kk(j,c)=0;
    end
    kk(c,c)=1;
end
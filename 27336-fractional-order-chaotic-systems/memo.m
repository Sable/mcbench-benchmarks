function [yo] = memo(r, c, k)
%
temp = 0;
for j=1:k-1
   temp = temp + c(j)*r(k-j);
end
yo = temp;
%
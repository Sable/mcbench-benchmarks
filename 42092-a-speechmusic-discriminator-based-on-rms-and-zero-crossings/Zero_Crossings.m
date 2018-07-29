
%Computes the number of Zero_Crossings of signal y
function [zc] = Zero_Crossings(y)

zc = 0;
for i=2:length(y),
   if y(i)*y(i-1) < 0,
      zc = zc+1;
   end,
end,

   
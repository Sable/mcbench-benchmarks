% 
% VBOTTFUNC
%
% Räknar ut vikingaskeppets köls xyz-kordinater givet xkordinaterna.

function z=vbottfunc(x,ztop,ztop2)
z=[];

for i=1:size(x,1)
  if x(i)>3
    z=[z;ztop2*(x(i)-3)^2];
  else
    if x(i)<1
      z=[z;ztop*(-x(i)+1)^2];
    else
      z=[z;0];
    end
  end
end



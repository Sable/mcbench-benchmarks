function [dy] = dmodel2D(t,y,a)
dy = zeros(2,1);
dy(1) = y(2);
dy(2) = (1 - a(2)*y(2)-a(1)*y(1))/a(3);
%
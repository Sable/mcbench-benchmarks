function [z]=chooseart(rotation,incr)
if rotation == 0
    z=ceil((180/incr)*16);
elseif (rotation > 0 & rotation <= 180)
    z=ceil((180/incr)*160);
end
function [z]=choosesbp(upto,increment)
if upto == 0
    z=ceil((180/increment)*1);
elseif (upto > 0 & upto <= 180)
    z=ceil((180/increment)*32);
end
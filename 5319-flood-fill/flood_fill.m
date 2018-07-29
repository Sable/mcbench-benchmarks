function flood_fill(xc,yc,x,y,new,old,width,height)
% flood fills area of matrix
% (xc,yc) = start point of flood fill
% (x,y) = current test location
% new = new value to be filled
% old = old value to replace
%
% example use:
% global fill
% width = 20;
% height = 20;
% fill = zeros(width,height);
% new = 1;
% old = 0;
% xc = 10;
% yc = 10;
% flood_fill(xc,yc,xc,yc,new,old,width,height);
%
% Results:
% The flood fill will alter all values of 0 to one flood filling from a
% start point (xc,yc)
% If the flood fill starts in an enclosed space it will fill up to the
% boundary
%
% Author: James Goodwin, June 2003
% email: JamesRichardGoodwin@lyocs.com


global fill;
global call;

call = call + 1;

if (x<2 || x>=width)
    x = xc;
end

if (y<2 || y>=height)
    y = yc;
end

if (fill(y,x) == old) 
    fill(y,x) = new;
    flood_fill(xc,yc,x+1,y,new,old,width,height);
    flood_fill(xc,yc,x,y+1,new,old,width,height);
    flood_fill(xc,yc,x-1,y,new,old,width,height);
    flood_fill(xc,yc,x,y-1,new,old,width,height);
end

 
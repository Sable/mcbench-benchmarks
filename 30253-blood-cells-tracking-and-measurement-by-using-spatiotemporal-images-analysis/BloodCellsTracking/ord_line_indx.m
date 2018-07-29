function index = ord_line_indx(I,x,y)
% This function is used to calculate the order index of the trackpath. 
% input:
% I is a trackpath image, x and y are coordinate of the start point.
% output:
% ordered index of the trackpath; 

if size(I,3)>1;
    I = rgb2gray(I);
end
I(1,:) = 0;
I(size(I,1),:) = 0;
t = max(max(I));
ind = find(I==t);            
[m,n] = size(I);             
l = length(ind);           


for i=1:l                  % eight neighbors;
    if I(x,y+1) ==t
        temx=x;temy=y+1;
    elseif I(x-1,y+1) ==t
        temx=x-1;temy=y+1;
    elseif I(x-1,y) ==t
        temx=x-1;temy=y;
    elseif I(x-1,y-1) ==t
        temx=x-1;temy=y-1;
    elseif I(x,y-1) ==t
        temx=x;temy=y-1;
    elseif I(x+1,y-1) ==t
        temx=x+1;temy=y-1;
    elseif I(x+1,y) ==t
        temx=x+1;temy=y;
    elseif I(x+1,y+1) ==t
        temx=x+1;temy=y+1;
    end
        I(x,y)=0;
        x=temx;
        y=temy;
        index(i)=y*m+x;
end


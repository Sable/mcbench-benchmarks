function [x,y] = startpoint(I)
% this function is used to search one of the start point coordinate (x,y) of the trackpath;
I = double(I);
if size(I,3)>1;
    I = rgb2gray(I);
end

t = max(max(I)); % find the max value;
if t > 1
   index = I<255; 
   I(index) = 0; 
end

[Linex,Liney] = find(I==t);
StartX=[]; StartY=[];
for k=1:length(Linex)
    sum=0;sum=double(sum);
        for i=-1:1
            for j=-1:1
                  sum = sum + double(I((Linex(k)+i),(Liney(k)+j))); % for each pixels, search its 8 neighbors;
            end
        end
        if t<sum && sum<3*t     % because 'start' and 'end' points belong to (t,3*t);
            StartX = [StartX,Linex(k)]; StartY = [StartY,Liney(k)];
        end
end

if StartY(1)>StartY(2);
    x=StartX(2);y=StartY(2);
else
    x=StartX(1); y=StartY(1);
end    
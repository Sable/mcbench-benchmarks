clc
clear all;
rgb = imread('ngc6543a.jpg');
[sy sx ~] = size(rgb);
x = sx /2;
y = sy /2- 40;

rgb = RGBCircle(rgb,x,y,[230 210],[255 100 255]);
h = figure('keypressfcn',callstr, ...
    'windowstyle','modal',...    
    'position',[0 0 1 1],...
    'Name','GETKEY', ...
    'userdata','timeout');
imshow(rgb);

for i=1:0.5:1000
    r = round(abs(cos(i/10)*255));
    g = round(abs(cos(i/9)*255));
    b = round(abs(cos(i/7)*255));
    
    time = i;
    phase = [time/9 max(500 - time,0)/5];
    time = i - 50;
    phaseOld = [time/9 max(500 - time,0)/5];
    rgb = RGBCircle(rgb,x,y, 50 + cos((i-50)/10)*80,[0 0 0], 20, phaseOld);
    rgb = RGBCircle(rgb,x,y, 50 + cos(i/10)*80,[r g b], 20, phase);
    h = image(rgb);
    drawnow;
    ch = get(h,'Userdata');
    if ~isempty(ch),
        break;
    end   
end

%rectangle('Position',[x,y,w,h])
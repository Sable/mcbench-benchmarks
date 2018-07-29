function htmlStr = color2htmlStr(rgbcolor)
htmlColor = 'aaaaaa';
for i = 1:length(rgbcolor)
    dig(1) = floor(round(double(rgbcolor(i))*255)/16);
    dig(2) = rem(round(double(rgbcolor(i))*255),16);
    htmlColor(i*2-1:i*2) = [dec2hex(dig(1)),dec2hex(dig(2))];
end
htmlStr = ['<html><font bgcolor="',htmlColor,'" color="',htmlColor,'">_____</font></html>'];
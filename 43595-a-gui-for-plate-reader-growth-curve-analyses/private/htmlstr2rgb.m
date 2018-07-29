function rgb = htmlstr2rgb(htmlcolor)
tok = regexp(htmlcolor,'="(\w+)','tokens');
tok = tok{1,1}{1,1};
r = (hex2dec(tok(1))*16 + hex2dec(tok(2)))/255;
g = (hex2dec(tok(3))*16 + hex2dec(tok(4)))/255;
b = (hex2dec(tok(5))*16 + hex2dec(tok(6)))/255;
rgb = {r,g,b};
end
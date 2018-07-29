function imwritescale(f,name)
vmin=min(min(f));vmax=max(max(f));
g=(f-vmin)*255/(vmax-vmin);
imwrite(uint8(g),name,'quality',100);
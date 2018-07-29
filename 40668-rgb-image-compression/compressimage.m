function [Ioutput]= compressimage(Iinput)
I=rgb2ycbcr(Iinput);
Y=I(:,:,1);
cb=I(:,:,2);
cr=I(:,:,3);
[Y1]= DCTcompressionluma(Y);
[cb1]= DCTcompressioncroma(cb);
[cr1]= DCTcompressioncroma(cr);

Ioutput(:,:,1)=Y1;
Ioutput(:,:,2)=cb1;
Ioutput(:,:,3)=cr1;
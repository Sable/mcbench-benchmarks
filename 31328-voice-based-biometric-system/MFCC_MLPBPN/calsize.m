%Voice Based Biometric System
%By Ambavi K. Patel.


function [fsize1,osize1,nwin1]=calsize(stime1,intval1,len1)
fsize1=floor((len1*stime1)/(intval1)); %frame size
osize1=floor(fsize1/2);       % overlaping size
nwin1=floor((len1-1)/osize1);  % no of window



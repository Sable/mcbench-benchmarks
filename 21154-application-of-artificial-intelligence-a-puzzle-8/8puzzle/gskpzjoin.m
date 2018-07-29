function [pzinl] =  gskpzjoin(pzinl,pzstat,intv00f,intv00g,intv00h)
[intv000,intv001] = size(pzinl);
pzinl(intv000+1,1:3) = pzstat(1,:);
pzinl(intv000+1,4:6) = pzstat(2,:);
pzinl(intv000+1,7:9) = pzstat(3,:);
pzinl(intv000+1,10) = intv00f;
pzinl(intv000+1,11) = intv00g;
pzinl(intv000+1,12) = intv00h;
 
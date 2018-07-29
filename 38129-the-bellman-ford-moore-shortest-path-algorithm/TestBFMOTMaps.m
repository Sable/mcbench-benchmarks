function [t] = TestBFMOTMaps;
% Test Bellman-Ford-Moore Shortest Path algorith on real maps.
% The smaller maps in Matlab sparse matrix format are available here: 
% http://www.derekroconnor.net/SPathProbs/
% 
% Derek O'Connor 12 Sep 2012
 t = zeros(20,1);

MapNo = 0;
load 'spusaNY'; G = spusaNY;
r = 1; MapNo = MapNo + 1;
tic;[p,D,iter] = BFMSpathOT(G,r); t(MapNo) = toc; n=length(p); disp([MapNo r n iter iter/n t(MapNo)]);

load 'spusaBAY'; G = spusaBAY;
r = 1; MapNo = MapNo + 1;
tic;[p,D,iter] = BFMSpathOT(G,r); t(MapNo) = toc; n=length(p); disp([MapNo r n iter iter/n t(MapNo)]);


load 'spusaCOL'; G = spusaCOL;
r = 1; MapNo = MapNo + 1;
tic;[p,D,iter] = BFMSpathOT(G,r); t(MapNo) = toc; n=length(p); disp([MapNo r n iter iter/n t(MapNo)]);

load 'spusaFLA'; G = spusaFLA;
r = 1; MapNo = MapNo + 1;
tic;[p,D,iter] = BFMSpathOT(G,r); t(MapNo) = toc; n=length(p); disp([MapNo r n iter iter/n t(MapNo)]);

load 'spusaNW'; G = spusaNW;
r = 1; MapNo = MapNo + 1;
tic;[p,D,iter] = BFMSpathOT(G,r); t(MapNo) = toc; n=length(p); disp([MapNo r n iter iter/n t(MapNo)]);

load 'spusaNE'; G = spusaNE;
r = 1; MapNo = MapNo + 1;
tic;[p,D,iter] = BFMSpathOT(G,r); t(MapNo) = toc; n=length(p); disp([MapNo r n iter iter/n t(MapNo)]);

load 'spusaCAL'; G = spCAL;
r = 1; MapNo = MapNo + 1;
tic;[p,D,iter] = BFMSpathOT(G,r); t(MapNo) = toc; n=length(p); disp([MapNo r n iter iter/n t(MapNo)]);

load 'spusaLKS'; G = spusaLKS;
r = 1; MapNo = MapNo + 1;
tic;[p,D,iter] = BFMSpathOT(G,r); t(MapNo) = toc; n=length(p); disp([MapNo r n iter iter/n t(MapNo)]);


load 'spusaE'; G = spusaE;
r = 1; MapNo = MapNo + 1;
tic;[p,D,iter] = BFMSpathOT(G,r); t(MapNo) = toc; n=length(p); disp([MapNo r n iter iter/n t(MapNo)]);

load 'spusaW'; G = spusaW;
r = 1; MapNo = MapNo + 1;
tic;[p,D,iter] = BFMSpathOT(G,r); t(MapNo) = toc; n=length(p); disp([MapNo r n iter iter/n t(MapNo)]);

load 'spusaCTR'; G = spusaCTR;
r = 1; MapNo = MapNo + 1;
tic;[p,D,iter] = BFMSpathOT(G,r); t(MapNo) = toc; n=length(p); disp([MapNo r n iter iter/n t(MapNo)]);

















function [S,T]=sensifcn(G,Gc,H)
if nargin<=2, H=1; end
S=feedback(1,Gc*G*H); T=1-S;
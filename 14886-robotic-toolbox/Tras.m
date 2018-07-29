%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

%%input: x,y,z coordinates
%%ouput: a traslational matrix
function [Tmat]=Tras(px,py,pz)

pos=[px;py;pz];

Tmat=[eye(3,3),pos;zeros(1,3),1];

end
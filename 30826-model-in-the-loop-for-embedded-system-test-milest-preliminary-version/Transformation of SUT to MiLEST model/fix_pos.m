function [] = fix_pos(blocka,blockb,r,t)

% fix the height distance between 2 blocks 
% blocka acts as the origin of coordinates
% blockb is the one move around the blocka
% t is for the down, r is for the left

Pos = get_param(blocka, 'Position');
Posb = get_param(blockb, 'Position');
B = Posb(3)-Posb(1);
H = Posb(4)-Posb(2);
pos1 = Pos(1)+r;
pos3 = pos1+B;
pos2 = Pos(4)+t;
pos4 = pos2+H;
set_param(blockb, 'Position',[pos1 pos2 pos3 pos4]);
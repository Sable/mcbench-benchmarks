function sp=plus(sp1,sp2)
% sympoly/minus: Subtracts two sympoly objects, or a sympoly and a numeric array
% usage: sp = sp1 - sp2;
% 
% arguments:
%  sp,sp1,sp2 - sympoly objects or scalars

% negate the second term, then add
sp = sp1 + uminus(sp2);


function sq=mrdivide(sp1,sp2)
% sympoly/mrdivide: divide a sympoly object by a scalar or another polynom
% usage: sq = sp1/sp2;
% 
% arguments:
%  sp1,sp2 - sympoly objects or scalars
%  sq      - sympoly (quotient) object

% check the size of sp2
if numel(sp2)==1
  % / is only an option if a scalar in the denomenator
  sq = sp1./sp2;
else
  % denomenator 
  error 'Cannot use / when denomenator is an array or vector'
end




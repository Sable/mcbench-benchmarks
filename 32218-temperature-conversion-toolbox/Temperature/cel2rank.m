function rank = cel2rank(cel)
%CEL2RANK Convert temperature from celsius to rankine
%
%  rank = CEL2RANK(cel) converts temperature from celsius to rankine.
%
%  See also RANK2CEL, CEL2FAR, CEL2KEL.

rank = (cel + 273.15) * 1.8;

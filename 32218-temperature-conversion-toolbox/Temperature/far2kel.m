function kel = far2kel(far)
%FAR2KEL Convert temperature from fahrenheit to kelvin
%
%  kel = FAR2KEL(far) converts temperature from fahrenheit to kelvin.
%
%  See also KEL2FAR, FAR2CEL, FAR2RANK.

kel = (far + 459.67) / 1.8;
function far = kel2far(kel)
%KEL2FAR Convert temperature from kelvin to fahrenheit
%
%  far = KEL2FAR(kel) converts temperature from kelvin to fahrenheit.
%
%  See also FAR2KEL, KEL2RANK, KEL2CEL.

far = kel * 1.8 - 459.67;
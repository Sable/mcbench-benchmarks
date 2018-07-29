function cel = far2cel(far)
%FAR2CEL Convert temperature from fahrenheit to celsius
%
%  cel = FAR2CEL(far) converts temperature from fahrenheit to celsius.
%
%  See also CEL2FAR, FAR2RANK, FAR2KEL.

cel = (far - 32) / 1.8;

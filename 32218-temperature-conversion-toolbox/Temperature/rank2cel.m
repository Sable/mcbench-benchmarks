function cel = rank2cel(rank)
%RANK2FAR Convert temperature from rankine to celsius
%
%  cel = RANK2CEL(rank) converts temperature from rankine to celsius.
%
%  See also CEL2RANK, RANK2FAR, RANK2KEL.

cel = (rank - 459.67) / 1.8;
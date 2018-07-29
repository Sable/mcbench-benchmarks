%---Tinh ung suat trong cac thanh dan theo X---
function S=stress(X)
P=35;
S(1)=0;
S(2)=-P/X(1);
S(3)=3*sqrt(34)*P/(50*X(2));
S(4)=26*P/(25*X(2));
S(5)=13*sqrt(34)*P/(50*X(2));
S(6)=-7*P/(10*X(3));
S(7)=-13*P/(10*X(3));
S(8)=-13*sqrt(29)*P/(50*X(3));
S(9)=-13*sqrt(29)*P/(50*X(3));
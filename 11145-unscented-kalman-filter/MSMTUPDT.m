function [KGain,XNEW,PT1,PT2,PT3,YNEW] = MSMTUPDT(Xinew1,Xinew2,Xinew3,Yinew1,Yinew2,Yinew3,Xbark,Ybark,Pbark,Wco,Wci,Wcin,XNEW,VTt);

PYbarkYbark1 = Wco*(Yinew1 - Ybark)*(Yinew1 - Ybark)';
PYbarkYbark2 = Wci*(Yinew2 - Ybark)*(Yinew2 - Ybark)';
PYbarkYbark3 = Wcin*(Yinew3 - Ybark)*(Yinew3 - Ybark)';

PXbarkYbark1 = Wco*(Xinew1 - Xbark)*(Yinew1 - Ybark)';
PXbarkYbark2 = Wci*(Xinew2 - Xbark)*(Yinew2 - Ybark)';
PXbarkYbark3 = Wcin*(Xinew3 - Xbark)*(Yinew3 - Ybark)';

DENUP = sum(sum(PYbarkYbark1) + sum(PYbarkYbark2) + sum(PYbarkYbark3));
NUMUP = sum(sum(PXbarkYbark1) + sum(PXbarkYbark2) + sum(PXbarkYbark3));

KGain = NUMUP/DENUP;

YNEW = (sin(XNEW)).^2 + exp(VTt);
XNEW = Xbark + KGain*(YNEW - Ybark);

PT1 = Pbark - KGain*PYbarkYbark1*KGain;
PT2 = Pbark - KGain*PYbarkYbark2*KGain;
PT3 = Pbark - KGain*PYbarkYbark3*KGain;

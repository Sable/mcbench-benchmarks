function [Xinew1,Xinew2,Xinew3,Yinew1,Yinew2,Yinew3,Xbark,Ybark,Pbark] = TMUPDT(Wmo,Wmi,Wmin,Wco,Wci,Wcin,Sg11,Sg12,Sg13,Sg21,Sg22,Sg23,Sg31,Sg32,Sg33);

Xinew1  = (sin(Sg11))^2 + exp(Sg21);   %FIRST STEP
Xinew2  = (sin(Sg12))^2 + exp(Sg22);   %FIRST STEP
Xinew3  = (sin(Sg13))^2 + exp(Sg23);   %FIRST STEP

[RW CL] = size(Sg12);
NxMean1 = Wmo*Xinew1;
NxMean2 = Wmi*Xinew2;    %SECOND STEP
NxMean3 = Wmin*Xinew3;   %SECOND STEP

Xbark = sum(sum(NxMean1) + sum(NxMean2) + sum(NxMean3));

NxCov1 = Wco*(Xinew1-Xbark);
NxCov2 = Wci*[(Xinew2-Xbark)*(Xinew2-Xbark)'];
NxCov3 = Wcin*[(Xinew3-Xbark)*(Xinew3-Xbark)'];

Pbark = sum(sum(NxCov1) + sum(NxCov2) + sum(NxCov3));

Yinew1 = (Xinew1)^2 + cos(Sg31);
Yinew2 = (Xinew2)^2 + cos(Sg32);
Yinew3 = (Xinew3)^2 + cos(Sg33);

NYMean1 = Wmo*Yinew1;
NYMean2 = Wmi*Yinew2;    %FIFTH STEP
NYMean3 = Wmin*Yinew3;   %FIFTH STEP

Ybark = sum(sum(NYMean1) + sum(NYMean2) + sum(NYMean3));


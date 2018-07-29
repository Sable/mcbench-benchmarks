function IESM_NewSpin = IndexElementStateMatrix_3D_QPOTTS_NewSpin(IESM,Q);

IESM_NewSpin = IESM;
for count=1:100000000
    IESM_NewSpin(2,2,2)=floor(1+Q*rand);
    if IESM_NewSpin(2,2,2)~=IESM(2,2)
        break
    end
end
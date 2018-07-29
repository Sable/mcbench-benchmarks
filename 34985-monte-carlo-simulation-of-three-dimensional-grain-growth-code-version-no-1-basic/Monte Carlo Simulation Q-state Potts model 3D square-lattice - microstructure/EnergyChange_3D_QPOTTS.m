function [E1,IESM_NewSpin,E2,DelE] = EnergyChange_3D_QPOTTS(IESM,Q);

E1 = Energy1_3D_QPOTTS(IESM);
IESM_NewSpin = IndexElementStateMatrix_3D_QPOTTS_NewSpin(IESM,Q);
E2 = Energy2_3D_QPOTTS(IESM_NewSpin);
DelE = E1-E2;
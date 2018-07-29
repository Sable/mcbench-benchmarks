function state = AssignRandomInitialStateMatrix_3D_QPOTTS(x,Q)
Sx = size(x,1);
state=floor(1+Q*rand(Sx,Sx,Sx));
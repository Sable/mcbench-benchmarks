function [x,y,z] = MakeSquareLattice_3D_QPOTTS(NoLatticePoints)

X=0:1/(NoLatticePoints-1):1;
Y=X;
[xt,yt]=meshgrid(X,Y);
x=repmat(xt,[1 1 NoLatticePoints]);
y=repmat(yt,[1 1 NoLatticePoints]);
for count=1:(NoLatticePoints)
    z(:,:,count)=(count-1)*ones(NoLatticePoints,NoLatticePoints)/(NoLatticePoints-1);
end
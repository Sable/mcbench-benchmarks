function [x,y] = MakeSquare2DLattice(nlp)

X=0:1:nlp;
Y=X;
[x,y]=meshgrid(X,Y);
x=x/nlp;
y=y/nlp;
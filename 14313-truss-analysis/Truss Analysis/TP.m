function TP(D,U,Sc)
C=[D.Coord;D.Coord+Sc*U];e=D.Con(1,:);f=D.Con(2,:);
for i=1:6
    M=[C(i,e);C(i,f);repmat(NaN,size(e))];X(:,i)=M(:);    
end
plot3(X(:,1),X(:,2),X(:,3),'k',X(:,4),X(:,5),X(:,6),'m');axis('equal');
if D.Re(3,:)==1;view(2);end
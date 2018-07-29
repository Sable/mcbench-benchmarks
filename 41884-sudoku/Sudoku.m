% Ulrich Reif, 05/22/13
% This is a minimalist Sudoku solver

function Y=Sudoku(X)               
E=eye(9);e=eye(3);O=ones(9);o=ones(3);
K=kron(E,O)|kron(O,E)|kron(e,kron(o,kron(e,o)));
P=1.0*K*(X(:)*o(:)'==O(:)*(1:9));     
[m,k]=min(~P*o(:)+10*X(:));Y=X*(m>9);E(:)=1:81;
for i=find(m>0&m<10&~P(k,:))
  Y=Sudoku(X+i*(E==k));
  if Y,return,end
end
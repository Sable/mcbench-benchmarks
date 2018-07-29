function W=ufdwt(h,pts,order)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ufdwt.m
%
% Compute Finite Difference Weights for a Uniform Grid
%
% Input Parameters:
%
% h     - spacing between FD nodes
% pts   - number of FD points in scheme (3-pt, 5-pt, etc)
% order - order of the derivative operator to compute weights for
%         (note: order<pts-1!)
%         1 computes first derivative differences       
%         2 computes second derivative differences, etc
%  
% Output Parameter:
%
% W is the weight matrix. Each row contains a different set of weights
% (centered or off). If, for example, the number of finite difference points
% is odd, the centered difference weights will appear in the middle row.
%
% Written by: Greg von Winckel - 06/16/04
% Contact: gregvw@chtm.unm.edu
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


N=2*pts-1;  p1=pts-1;

A=repmat((0:p1)',1,N);      B=repmat((-p1:p1)*h,pts,1);

M=(B.^A)./gamma(A+1); 

rhs=zeros(pts,1);   rhs(order+1)=1;

W=zeros(pts,pts);

for k=1:pts
    W(:,k)=M(:,(0:p1)+k)\rhs;
end

W=W';   W(1:pts,:)=W(pts:-1:1,:);



function [jacobian]=Jacobian(nnel,dhdr,dhds,xcoord,ycoord)

%------------------------------------------------------------------------
%  Purpose:
%     determine the Jacobian for two-dimensional mapping
%
%  Synopsis:
%     [jacobian]=Jacobian(nnel,dhdr,dhds,xcoord,ycoord) 
%
%  Variable Description:
%     jacob2 - Jacobian for one-dimension
%     nnel - number of nodes per element   
%     dhdr - derivative of shape functions w.r.t. natural coordinate r
%     dhds - derivative of shape functions w.r.t. natural coordinate s
%     xcoord - x axis coordinate values of nodes
%     ycoord - y axis coordinate values of nodes
%------------------------------------------------------------------------

 jacobian=zeros(2,2);

 for i=1:nnel
 jacobian(1,1)=jacobian(1,1)+dhdr(i)*xcoord(i);
 jacobian(1,2)=jacobian(1,2)+dhdr(i)*ycoord(i);
 jacobian(2,1)=jacobian(2,1)+dhds(i)*xcoord(i);
 jacobian(2,2)=jacobian(2,2)+dhds(i)*ycoord(i);
 end

function [dhdx,dhdy]=shapefunctionderivatives(nnel,dhdr,dhds,invjacob)

%------------------------------------------------------------------------
%  Purpose:
%     determine derivatives of  isoparametric Q4 shape functions with 
%     respect to physical coordinate system
%
%  Synopsis:
%     [dhdx,dhdy]=shapefunctionderivatives(nnel,dhdr,dhds,invjacob)  
%
%  Variable Description:
%     dhdx - derivative of shape function w.r.t. physical coordinate x
%     dhdy - derivative of shape function w.r.t. physical coordinate y
%     nnel - number of nodes per element   
%     dhdr - derivative of shape functions w.r.t. natural coordinate r
%     dhds - derivative of shape functions w.r.t. natural coordinate s
%     invjacob - inverse of  Jacobian matrix
%------------------------------------------------------------------------

 for i=1:nnel
 dhdx(i)=invjacob(1,1)*dhdr(i)+invjacob(1,2)*dhds(i);
 dhdy(i)=invjacob(2,1)*dhdr(i)+invjacob(2,2)*dhds(i);
 end

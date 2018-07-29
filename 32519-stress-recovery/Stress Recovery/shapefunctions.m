function [shapeQ4,dhdrQ4,dhdsQ4]=shapefunctions(xi,eta)

%------------------------------------------------------------------------
%  Purpose:
%     compute isoparametric four-node Quadilateral shape functions
%     and their derivatves at the selected (integration) point
%     in terms of the natural coordinate 
%
%  Synopsis:
%     [shapeQ4,dhdrQ4,dhdsQ4]=shapefunctions(xi,eta)  
%
%  Variable Description:
%     shapeQ4 - shape functions for four-node element
%     dhdrQ4 - derivatives of the shape functions w.r.t. r
%     dhdsQ4 - derivatives of the shape functions w.r.t. s
%     xi - r coordinate value of the selected point   
%     eta - s coordinate value of the selected point
%
%  Notes:
%     1st node at (-1,-1), 2nd node at (1,-1)
%     3rd node at (1,1), 4th node at (-1,1)
%------------------------------------------------------------------------

% shape functions

 shapeQ4(1)=0.25*(1-xi)*(1-eta);
 shapeQ4(2)=0.25*(1+xi)*(1-eta);
 shapeQ4(3)=0.25*(1+xi)*(1+eta);
 shapeQ4(4)=0.25*(1-xi)*(1+eta);

% derivatives

 dhdrQ4(1)=-0.25*(1-eta);
 dhdrQ4(2)=0.25*(1-eta);
 dhdrQ4(3)=0.25*(1+eta);
 dhdrQ4(4)=-0.25*(1+eta);

 dhdsQ4(1)=-0.25*(1-xi);
 dhdsQ4(2)=-0.25*(1+xi);
 dhdsQ4(3)=0.25*(1+xi);
 dhdsQ4(4)=0.25*(1-xi);

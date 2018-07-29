function [pb]=PlateBending(nnel,dhdx,dhdy)

%--------------------------------------------------------------------------
%  Purpose:
%     determine the kinematic matrix expression relating bending curvatures 
%     to rotations and displacements for shear deformable plate bending
%
%  Synopsis:
%     [pb]=PlateBending(nnel,dhdx,dhdy) 
%
%  Variable Description:
%     nnel - number of nodes per element
%     dhdx - derivatives of shape functions with respect to x   
%     dhdy - derivatives of shape functions with respect to y
%--------------------------------------------------------------------------

 for i=1:nnel
 i1=(i-1)*3+1;  
 i2=i1+1;
 i3=i2+1;
 pb(2,i2)=dhdy(i);
 pb(3,i2)=dhdx(i);
 pb(1,i3)=-dhdx(i);
 pb(3,i3)=-dhdy(i);
 pb(3,i1)=0;
 end

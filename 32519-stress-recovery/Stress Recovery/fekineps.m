function [kinmtps]=fekineps(nnel,dhdx,dhdy)

%--------------------------------------------------------------------------
%  Purpose:
%     determine the kinematic matrix expression for plane stress relating  
%     two displacements UX and UY
%
%  Synopsis:
%     [kinmtpb]=fekinepb(nnel,dhdx,dhdy) 
%
%  Variable Description:
%     nnel - number of nodes per element
%     dhdx - derivatives of shape functions with respect to x   
%     dhdy - derivatives of shape functions with respect to y
%--------------------------------------------------------------------------

 for i=1:nnel
 i1=(i-1)*2+1;  
 i2=i1+1;
 kinmtps(1,i1)=dhdx(i);
 kinmtps(2,i2)=dhdy(i);
 kinmtps(3,i1)=dhdy(i);
 kinmtps(3,i2)=dhdx(i);
 end

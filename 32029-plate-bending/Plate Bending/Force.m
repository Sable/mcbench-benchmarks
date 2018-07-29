function [f] = Force(nnel,shape,P)

%--------------------------------------------------------------------------
% Purpose :
%         Determines the force vector for the element 'iel'
% Synopsis :
%          [f] = Force(nnel,shape,P) 
% Variable Description:
%           f - element force vector
%           nnel - number of nodes per element
%           shape - Shape functions for the element
%           P - applied transverse pressure
%--------------------------------------------------------------------------

fef = shape*P ;

for i = 1:nnel
    i1=(i-1)*3+1;  
    i2=i1+1;
    i3=i2+1;
    f(i1,1) = fef(1) ;
    f(i2,1) = 0 ;
    f(i3,1) = 0 ;
end

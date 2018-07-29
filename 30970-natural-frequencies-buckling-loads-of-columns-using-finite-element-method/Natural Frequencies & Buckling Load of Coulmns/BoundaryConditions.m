function [nbcd,bcdof] = BoundaryConditions(sdof,bc)

%--------------------------------------------------------------------------
% Purpose :                                                                
%         To get the arrested degree's of freedom for the beam depending on
% type of the boundary conditions      
%
% Synopsis : 
%          [nbcd,bcdof] = BoundaryConditions(sdof,bc)
% 
% Variable Description:
% INPUT parameters:
%           sdof : system degrees of freedom
%           bc : boundary condition type
%
% OUTPUT PARAMETERS :
%           bcdof : boundary degrees of freedom
%           nbcd : number of boundary conditions
%
%--------------------------------------------------------------------------
 

 if bc == 'c-c'     % clamped-clamped beam
    bcdof = [1 2 sdof-1 sdof] ;
    nbcd = length(bcdof) ;
     
 elseif bc == 'c-f' % clamped-free beam
    bcdof = [1 2] ;
    nbcd = length(bcdof) ;
     
 elseif bc == 'c-s'     % clamped-supported beam
     bcdof = [1 2 sdof-1] ;
     nbcd = length(bcdof) ; 
      
 elseif bc == 's-s'     % supported-supported beam
     bcdof = [ 1 sdof-1] ;
     nbcd = length(bcdof) ;
     
 end
 
     

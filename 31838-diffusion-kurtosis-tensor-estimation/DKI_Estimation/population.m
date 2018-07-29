function counter=population(i,j,k,order)
%-fanDTasia ToolBox------------------------------------------------------------------
% This Matlab script is part of the fanDTasia ToolBox: a Matlab library for Diffusion 
% Weighted MRI (DW-MRI) Processing, Diffusion Tensor (DTI) Estimation, High-order 
% Diffusion Tensor Analysis, Tensor ODF estimation, Visualization and more.
%
% A Matlab Tutorial on DW-MRI can be found in:
% http://www.cise.ufl.edu/~abarmpou/lab/fanDTasia/tutorial.php
%
%-CITATION---------------------------------------------------------------------------
% If you use this software please cite the following work:
% A. Barmpoutis and B.C. Vemuri, "A Unified Framework for Estimating Diffusion Tensors 
% of any order with Symmetric Positive-Definite Constraints", 
% In the Proceedings of ISBI, 2010
%
%-DESCRIPTION------------------------------------------------------------------------
% This function computes how many identical copies of a tensor coefficient appear in
% a fully symmetric high order tensor in 3 variables of spesific order.
%
%-USE--------------------------------------------------------------------------------
% counter=population(i,j,k,order)
%
% order: is the order of the symmetric tensor in 3 variables (x,y,z)
% i,j,k: is a triplet that represent the coefficient which is weighted by the monomial
% x^i*y^j*z^k, where i+j+k=order
%
%-DISCLAIMER-------------------------------------------------------------------------
% You can use this source code for non commercial research and educational purposes 
% only without licensing fees and is provided without guarantee or warrantee expressed
% or implied. You cannot repost this file without prior written permission from the 
% authors. If you use this software please cite the following work:
% A. Barmpoutis and B.C. Vemuri, "A Unified Framework for Estimating Diffusion Tensors 
% of any order with Symmetric Positive-Definite Constraints", In Proc. of ISBI, 2010.
%
%-AUTHOR-----------------------------------------------------------------------------
% Angelos Barmpoutis, PhD
% Computer and Information Science and Engineering Department
% University of Florida, Gainesville, FL 32611, USA
% abarmpou at cise dot ufl dot edu
%------------------------------------------------------------------------------------


    size=3^order;
    counter=0;
    for z=0:size-1
        c=populationBasis(z,order,[0 0 0]);
        if (c(1)==i)&(c(2)==j)&(c(3)==k)
            counter=counter+1;
        end
    end
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret=populationBasis(i,order,c)
	if order==0  
        ret=c;
    else
	    j=mod(i,3);
	    c(j+1)=c(j+1)+1;
	    ret=populationBasis((i-j)/3,order-1,c);
    end
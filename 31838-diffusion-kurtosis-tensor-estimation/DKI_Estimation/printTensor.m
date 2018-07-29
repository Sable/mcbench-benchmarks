function printTensor(tensor,order)
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
% This function prints in the command line the tensor coefficients of a given tensor
% (in 3 variables) of a specific order.
%
%-USE--------------------------------------------------------------------------------
% printTensor(tensor,order);
%
% tensor: is a vector that contains all the unique coefficients of a symmetric tensor
% order: is the order of the tensor
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

    c=1;
    for i=0:order
		for j=0:order-i
			fprintf(1,'D%d%d%d = %.8f\n',i,j,order-i-j,tensor(c));
			c=c+1;
        end
    end
   
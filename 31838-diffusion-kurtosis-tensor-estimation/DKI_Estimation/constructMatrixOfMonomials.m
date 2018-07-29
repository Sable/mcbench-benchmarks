function G=constructMatrixOfMonomials(g,order)
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
% This function computes all possible monomials in 3 variables of a certain order. 
% The 3 variables are given in the form of 3-dimensional vectors.
%
%-USE--------------------------------------------------------------------------------
% G=constructMatrixOfMonomials(g,order);
%
% g: is a list of N 3-dimensional vectors stacked in a matrix of size Nx3
% order: is the order of the computed monomials
% G: contains the computed monomials. It is a matrix of size N x (2+order)!/2(order)!
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

fprintf(1,'Constructing matrix of monomials G...');
for k=1:length(g)
    c=1;
    for i=0:order
		for j=0:order-i
			G(k,c)=(g(k,1)^i)*(g(k,2)^j)*(g(k,3)^(order-i-j));
			c=c+1;
        end
    end
end
fprintf(1,'Done\n');
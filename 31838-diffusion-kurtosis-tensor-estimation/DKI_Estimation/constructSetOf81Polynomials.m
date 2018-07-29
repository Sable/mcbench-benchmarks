function C=constructSetOf321Polynomials(order)
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
% This function computes the coefficients of homogenous polynomials in 3 variables of
% a given order, which correspond to squares of lower (half) order polynomials. 
%
%-USE--------------------------------------------------------------------------------
% C=constructSetOfPolynomialCoef(order);
%
% order: is the order of the computed homogeneous polynomials
% C: contains the computed list of polynomial coefficients. 
%    It is a matrix of size Mprime x (2+order)!/2(order)!
%    Mprime is defined here =321. This implementation is one way of choosing polynomials,
%    there are many different ways. A slightly different way is described in the above
%    reference (Barmpoutis et al. ISBI'10).
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

fprintf(1,'Constructing matrix of 81 polynomials C...');
UnitVectors;
Mprime=81;
g=g(1:Mprime,:);
for i=0:order
    for j=0:order-i
        pop(i+1,j+1,order-i-j+1)=population(i,j,order-i-j,order);
    end
end
for k=1:length(g)
    c=1;
    for i=0:order
		for j=0:order-i
			C(k,c)=pop(i+1,j+1,order-i-j+1)*(g(k,1)^i)*(g(k,2)^j)*(g(k,3)^(order-i-j));
			c=c+1;
        end
    end
end
fprintf(1,'Done\n');
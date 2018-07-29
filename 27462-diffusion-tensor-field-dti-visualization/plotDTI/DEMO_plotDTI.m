function DEMO_plotDTI()
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
% A. Barmpoutis, B. C. Vemuri, T. M. Shepherd, and J. R. Forder "Tensor splines for 
% interpolation and approximation of DT-MRI with applications to segmentation of 
% isolated rat hippocampi", IEEE TMI: Transactions on Medical Imaging, Vol. 26(11), 
% pp. 1537-1546 
%
%-DESCRIPTION------------------------------------------------------------------------
% This demo script shows how to use plotDTI.m in order to plot a 2D field of 
% 3D tensors as ellipsoidal glyphs. The 3D tensors must be in the form of 3x3 
% symmetric positive definite matrices. The field can contain either a single tensor, 
% or a row of tensors or a 2D field of tensors.
%
% NOTE: This DEMO plots only 2nd-order tensors (i.e. traditional DTI). For higher-order
% tensors (such as 4th-order tensor visualization) please use the DEMO_plotTensors.m
%
%-USE--------------------------------------------------------------------------------
% DEMO_plotDTI;
%
%-DISCLAIMER-------------------------------------------------------------------------
% You can use this source code for non commercial research and educational purposes 
% only without licensing fees and is provided without guarantee or warrantee expressed
% or implied. You cannot repost this file without prior written permission from the 
% authors. If you use this software please cite the following work:
% A. Barmpoutis, B. C. Vemuri, T. M. Shepherd, and J. R. Forder "Tensor splines for 
% interpolation and approximation of DT-MRI with applications to segmentation of 
% isolated rat hippocampi", IEEE TMI: Transactions on Medical Imaging, Vol. 26(11), 
% pp. 1537-1546 
%
%-AUTHOR-----------------------------------------------------------------------------
% Angelos Barmpoutis, PhD
% Computer and Information Science and Engineering Department
% University of Florida, Gainesville, FL 32611, USA
% abarmpou at cise dot ufl dot edu
%------------------------------------------------------------------------------------


%we open a demo tensor field
D=openFDT('DTI_field.fdt');
%D is a matrix of size 3 x 3 x SizeX x SizeY

fprintf(1,'What do you want to do?\n');
fprintf(1,' 1. Plot a single tensor.\n');
fprintf(1,' 2. Plot a row of tensors.\n');
fprintf(1,' 3. Plot a 2D field of tensors.\n');
a=input('Answer [1,2,3]:');

if a==1
    plotDTI(D(:,:,[10],[10]));
elseif a==2
    plotDTI(D(:,:,[10:22],[16]),0.0004);
elseif a==3
    plotDTI(D(:,:,[10:22],[10:22]),0.0004);
end
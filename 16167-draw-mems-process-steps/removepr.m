function removepr(PR)
%*************************************************
%DATE: 13/8/2007 (created); 	13/8/2007 (modified)
%FUNCTION:
%INPUTS:
%OUTPUTS:
%muwn.gu@gmail.com
%*************************************************
global layerMatrix;

layerMatrix (find(layerMatrix == 9)) = 0;

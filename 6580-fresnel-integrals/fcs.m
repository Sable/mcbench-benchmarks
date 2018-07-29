function [C, S] = fcs(x)
%FCS Computes Fresnel integrals.
%[C, S] = fcs(x) returns Fresnel integrals C ans S for argument x,
% x must be double and real.
% F = fcs(x) returns complex F = C+i*S
% 
% Algorithm:
% This function uses an improved method for computing Fresnel integrals
% with an error of less then 1x10-9, described in:
% 
% Klaus D. Mielenz, Computation of Fresnel Integrals. II
% J. Res. Natl. Inst. Stand. Technol. 105, 589 (2000), pp 589-590
% 
% Copyright (c) 2002 by Peter L. Volegov (volegov@unm.edu)   
% All Rights Reserved.                                       

error('You need to compile fcs.c to a mex file for your platform.');

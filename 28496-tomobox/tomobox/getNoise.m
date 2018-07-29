function e = getNoise(rnl,b)
% GETNOISE   Create white noise with specified relative noise level
%
% e = getNoise(rnl,b) creates a Gaussian white noise vector e of same size 
% as b such that ||e||_2 / ||b||_2 = rnl, i.e., the relative magnitude
% (2-norm) of e to b is equal to the scalar rnl.

% Jakob Heide Jørgensen (jakj@imm.dtu.dk)
% Department of Informatics and Mathematical Modelling (IMM)
% Technical University of Denmark (DTU)
% August 2009

% This code is released under the Gnu Public License (GPL). 
% For more information, see
% http://www.gnu.org/copyleft/gpl.html

e = randn(size(b));
e = e/norm(e(:));
e = rnl*norm(b(:))*e;
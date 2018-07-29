function [Y_F,U] = SimulateFactorsResiduals(Corr_Y_F, volU, J)
%[Y_F,U] = SimulateFactorsResiduals(Corr_Y_F, volU, J)
%  Generates simulations of unit normal factors Y_F and residuals U. The
%  first two sample joint moments of Y_F are forced to match the given
%  inputs and assumptions. Sample covariance of each residual U with each
%  factor is enforced to be zero, but the sample covariances between
%  elements of U are not forced to be zero (for complexity reasons).
%  U is assumed to be zero-mean, uncorrelated and jointly normal.
%
% IMPORTANT: The order of computations in the following expressions is
% important for efficiency. Please use the same order, or have a good reason
% to change it! 
% Code by S. Gollamudi. This version December 2009. 

K = size(Corr_Y_F,1);
N = length(volU);
if size(volU,2)==1, volU = volU'; end
    
% Simulate Y_F with sample mean and covariance exactly matching the
% desired values
Y_F = MvnRndMatchCrossCov(Corr_Y_F, zeros(0,K), zeros(J,0));

% Simulate residuals that are orthogonal to columns of F
U = randn(J/2,N);
U = [U
     -U];
U = U - (Y_F/Corr_Y_F)*((Y_F'*U)/J);

% Scale residuals to have the correct sample variance
norm_factors = volU./sqrt(mean(U.^2,1));
U = U .* repmat(norm_factors,J,1);

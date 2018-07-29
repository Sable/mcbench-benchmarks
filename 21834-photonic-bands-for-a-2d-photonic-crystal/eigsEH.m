%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% this function solves the eigenvalue problem omega=f(epsi,kx,ky) for
%%% in-plane propagation (i.e. z=0) in a 2D-PhC; the problem can be
%%% separated in two orthogonal polarizations, E-pol & H-pol
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [omegaE, omegaH]=eigsEH(kGx,kGy,epsi,N,bands)
eta=inv(epsi);
A=inv(eta*(kGx^2+kGy^2)); %%% matrix for E-pol
B=inv(kGx*eta*kGx+kGy*eta*kGy); %%% matrix for H-pol
%%% options used in "eigs" calculations - tolerance 1e-12, intermediate results of iterations will
%%% not be displayed
opts.tol=1e-12; opts.disp=0; 
%%% calculate the largest eigs, which become the smallest after inversion
De=eigs(A,bands,'lr',opts);
Dh=eigs(B,bands,'lr',opts);
%%% eigenvalues "omega" are put in a column vector and sorted in ascending order
omegaE=sqrt(sort(1./De));
omegaH=sqrt(sort(1./Dh));
 


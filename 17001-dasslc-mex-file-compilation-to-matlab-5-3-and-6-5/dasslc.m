%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [t,y,yp,outp] = dasslc(f,tspan,y0,rpar,rtol,atol,index,inputfile,jac)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DASSLC solves fully implicit differential algebraic equations by the BDF 
% formula. The differential equations solved must be on the form:
%
%   F(t,y,y') = 0
%
% The index of the DAE may be of any size.
%
% The short documentation to the mex interface is found below.
%
% Do 'help dasslc' from Matlab to see this help
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      
% Input arguments: total of 9 (minimum of 3)
%
%  f    : string : name of residual function [res,ires]=dydt(t,y,yp,rpar)
%                  where ires=0 if no error in dydt and rpar is optional
%  tspan: vector : [T0 T1 ... TFINAL]
%  y0   : vector : initial condition
%  rpar : array  : optional arguments transfered to function 'f'
%  rtol : scalar : optional relative tolerance parameter (defautl: 1e-8)
%  atol : scalar : optional absolute tolerance parameter (defautl: 0)
%  index: vector : optional differential index of each variable
%  inputfile : string : optional input file as described in dasslc manual
%  jac  : string : name of the user-provided jacobian function [M,ires]=jacmx(t,y,yp,cj,rpar)
%                  where M is the transpose of the iteration matrix cj*dF_dyp(t,y,yp)+dF_dy,
%                  ires=0 if no error in jacmx and rpar is optional
%
% Output arguments: total of 4 (minimum of 2)
%
%  t    : vector : vector of independent variable
%  y    : matrix : matrix of dependent variables (each line is a timestep)
%  yp   : matrix : optional matrix of time-derivative of dependent variables
% outp  : scalar : optional solution flag, positive and 0 if successful
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% REFERENCE;
%     K.E. Brenan, S.L. Campbell and L.R. Petzold
%     Numerical solution of initial-value problems
%     in differential-algebraic equations.
%     Elsevier Science Publishing Co., Inc., 1989
%
% C source written by
%     Argimiro R. Secchi
% Simulation Laboratory - LASIM
% GIMSCOP (Group of Integration, Modeling, Simulation,
%          Control, and Optimization of Processes)
% Department of Chemical Engineering
% Federal University of Rio Grande do Sul
% Porto Alegre, RS - Brazil
% e-mail: arge@enq.ufrgs.br
%
% Mex implementation by A.R. Secchi based on the work of
% S. Hauan and S. Storen (2005)
%

function y = integrateFx(x, a0, a1, a2, a3, a4, a5)
% integrateFx - Equation of a curve (f(x))
% -------------------------------------------------------------
% Abstract: Equation of a curve - f(x) used by the integration function
%
% Syntax:
%           integrateFx(x, a0, a1, a2, a3, a4, a5)
%
% Inputs:
%           a0, a1, a2, a3, a4, a5 - Coefficients of the polynomial
%
% Outputs:
%           Equation of a polynomial/curve
%
% Examples:
%           none
%
% Notes: none
%

% Copyright 2008 The MathWorks, Inc.
%
% Auth/Revision:  VAH
%                 The MathWorks Consulting Group 
%                 $Id$
% -------------------------------------------------------------------------

y = a0+a1*x+a2*x.^2+a3*x.^3+a4*x.^4+a5*x.^5;

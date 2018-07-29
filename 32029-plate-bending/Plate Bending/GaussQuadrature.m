function [Gausspoint,Gaussweight] = GaussQuadrature(order)
%-------------------------------------------------------------------
%  Purpose:
%     Determine the integration points and weighting coefficients
%     of Gauss-Legendre quadrature
%
%  Synopsis:
%     [point,weight]=GaussQuadrature(order) 
%
%  Variable Description:
%     order - order of the Gaussian integration
%     Gausspoint - vector containing integration points   
%     Gaussweight - vector containing weighting coefficients 
%-------------------------------------------------------------------

switch order
    case 'second' 
   
        % corresponding integration points and weights
        % 2-point quadrature rule
        Gausspoint = [-0.577350269189626 -0.577350269189626;
                       0.577350269189626  0.577350269189626] ;
        Gaussweight = [1 1;1 1];        
    case 'first'
       
        % Corresponding integration points and weigts
        % 1-point quadrature eule
        Gausspoint = [0 0] ;
        Gaussweight = [2. 2.] ;
        
end
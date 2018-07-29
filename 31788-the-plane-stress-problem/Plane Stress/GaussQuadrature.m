function [Gausspoint,Gaussweight] = GaussQuadrature(ngl)
%-------------------------------------------------------------------
%  Purpose:
%     determine the integration points and weighting coefficients
%     of Gauss-Legendre quadrature for two-dimensional integration
%
%  Synopsis:
%     [point,weight]=GaussQuadrature(nglx,ngly) 
%
%  Variable Description:
%     ngl - number of integration points
%     point - vector containing integration points   
%     weight - vector containing weighting coefficients 
%-------------------------------------------------------------------
%  initialization
  
   Gausspoint=zeros(ngl,1);
   Gaussweight=zeros(ngl,1);
   
%  corresponding integration points and weights
    % 2-point quadrature rule
    Gausspoint(1)=-0.577350269189626;
    Gausspoint(2)=-Gausspoint(1);
    Gaussweight(1)=1.0;
    Gaussweight(2)=Gaussweight(1);
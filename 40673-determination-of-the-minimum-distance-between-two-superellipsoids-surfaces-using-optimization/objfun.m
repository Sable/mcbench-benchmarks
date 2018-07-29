function [f gradf] = objfun(x)
% =========================================================================
% The Objective Function is the square distance between the superellipsoids
% surfaces
%
% Credits:
% Ricardo Fontes Portal
% IDMEC - Instituto Superior Tecnico - Universidade Técnica de Lisboa
% ricardo.portal(at)dem(.)ist(.)utl(.)pt
%
% April 2009 original version
% March 2013 updated version
% =========================================================================
% Objective Function
 f=((x(1))-(x(4)))^2+((x(2))-(x(5)))^2+((x(3))-(x(6)))^2;

if nargout > 1
    gradf=[2*x(1)-2*x(4);  2*x(2)-2*x(5);  2*x(3)-2*x(6);
          -2*x(1)+2*x(4); -2*x(2)+2*x(5); -2*x(3)+2*x(6)];
end
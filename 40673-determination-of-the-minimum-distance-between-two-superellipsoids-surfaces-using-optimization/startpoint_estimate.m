function [f gradf] = startpoint_estimate(u,a1,a2,a3,e1,e2,TR)
% =========================================================================
% This function constitute the equations that enble the determination of
% the contact points initial estimate. That estimation garantees that the
% initial points are located on the superellipsoids surfaces
%
% Credits:
% Ricardo Fontes Portal
% IDMEC - Instituto Superior Tecnico - Universidade Técnica de Lisboa
% ricardo.portal(at)dem(.)ist(.)utl(.)pt
%
% April 2009 original version
% March 2013 updated version
% =========================================================================
global p1 p2 p3 p4 p5 p6;

A=(u*(p4-p1)*TR(1,1) + u*(p5-p2)*TR(2,1) + u*(p6-p3)*TR(3,1))/a1;
B=(u*(p4-p1)*TR(1,2) + u*(p5-p2)*TR(2,2) + u*(p6-p3)*TR(3,2))/a2;
C=(u*(p4-p1)*TR(1,3) + u*(p5-p2)*TR(2,3) + u*(p6-p3)*TR(3,3))/a3;

%% constraints

 f = [((A^2)^(1.0/e2)+(B^2)^(1.0/e2))^(e2/e1)+(C^2)^(1.0/e1)-1.0];

if nargout > 1
        gradf=[];
end
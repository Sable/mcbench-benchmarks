function [vol,area] = triangulationVolume(TRI,X,Y,Z)
%[VOLUME,AREA] = triangulationVolume(TRI,X,Y,Z)
%
%  Computes the VOLUME and AREA of a closed surface defined
%  by the triangulation in indices TRI and coordinates X, Y and Z,
%  using the divergence theorem of Gauss (volume/surface integral).
%  The unit of the volume equals to UNIT^3 and the unit of the area
%  equals to UNIT^2, with UNIT the unit of the coordinates X,Y,Z.
%  The surface needs to be closed, this is not checked.
%
%  Example:
%  >> [vol,area]  = triangulationVolume(tri,x,y,z);
%
%  See also:
%    testTriangulationVolume.m
%
%Copyright © 2001-2007, Jeroen P.A. Verbunt - Amsterdam, The Netherlands

%====================================================================================================
% © 2001-2007, Jeroen P.A. Verbunt - Amsterdam, The Netherlands
%
% History
%
% Who	When        What
%
% JPAV    29.01.2001  Creation (Jeroen P.A. Verbunt) (V0.0)
% JPAV    30.01.2001  Finished (V1.0)
% JPAV    06.06.2007  Published on Matlab File Exchnage
%
%====================================================================================================

APPNAME = 'triangulationVolume';
VERSION = '1.0';
DATE    = '30 January 2001';
AUTHOR  = 'Jeroen P.A. Verbunt';

vol  = 0;
area = 0;

nTri = size(TRI,1);           % Number of triangles

if (nTri > 3)                 % Need at least 4 triangles to form a closed surface
   for i=1:nTri
      U = [X(TRI(i,1)) Y(TRI(i,1)) Z(TRI(i,1))]; % First  point of triangle
      V = [X(TRI(i,2)) Y(TRI(i,2)) Z(TRI(i,2))]; % Second point of triangle
      W = [X(TRI(i,3)) Y(TRI(i,3)) Z(TRI(i,3))]; % Third  point of triangle
   
      A = V - U;              % One side of triangle (from U to V)
      B = W - U;              % Another side of triangle (from U to W)
      
      C = cross(A, B);        % Length of C equals to the area of the parallelogram [A,B]
      normC = norm(C);
   
      a = 0.5 * normC;        % Area of triangle [U,V,W]
   
      P = (U + V + W) / 3;    % Middle of triangle
      N = C / normC;          % Normal vector of triangle

      vol  = vol + abs(P(1) * N(1) * a);
      area = area + a;
   end
end

vol  = abs(vol);  % Not shure whether taking the absolute value is really necessary.
area = abs(area); % If the normal vectors are oriented outwards, this should not be necessary.
                  % But can you guarantee that the normal vectors are oriented outwards...?

                  
%--------------------------------------------------------------------------------------------------------------
% Divergence theorem of Gauss:
% (see "Advanced engineering mathematics" by E. Kreyszig, 6th ed., p.551, eq.2):
%
%   ---    _         --_ _
%  /// div F dV  =  // F.n dA
% ---              --
%  T                S
%
% volume integral   surface integral (closed surface)
%
% Divergence:
% (see "Advanced engineering mathematics" by E. Kreyszig, 6th ed., p.492, eq.1):
%     _     dV1    dV2   dV3
% div V  =  ---  + --- + ---
%            dx     dy    dz
%
%
% To compute the volume V of a closed surface S:
%        _                     _
% Define F = [x,0,0], with div F = 1 + 0 + 0 = 1
%
%      ---          --_ _
% V = /// 1 dV  =  // x.n dA
%    ---          --
%     T            S
%
% Jeroen P.A. Verbunt
%
%= triangulationVolume =======================================================================================
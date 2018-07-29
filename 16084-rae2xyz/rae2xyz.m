function [east, north, up] = rae2xyz(rae, azimuth, elevation)
% rae2xyz - Transforms radar coordinates R,Az,El to cartesian (XYZ = East,North,Up)
%   input  format #1: [...] = rae2xyz(range, azimuth, elevation)
%   input  format #2: [...] = rae2xyz(rae)
%   output format #1: [east, north, up] = rae2xyz(...)
%   output format #2: xyz = rae2xyz(...)
%
%   Inputs:
%     Format #1:
%       range     - sqrt(x^2 + y^2 + z^2)
%       azimuth   - radian angle clockwize from north (= positive y axis)
%       elevation - radian angle from xy plane to positive z axis
%
%     Format #2:
%       rae - same as format #1, with all 3 values/vector bunched together in a vector/matrix
%
%   Outputs:
%     Format #1:
%       x - see definition in help for cart2sph; positive x = East
%       y - see definition in help for cart2sph; positive y = North
%       z - see definition in help for cart2sph; positive z = Up
%
%     Format #2:
%       xyz - same as format #1, with all 3 values/vector bunched together in a vector/matrix
%
%   Example:
%     [east,north,up] = rae2xyz(1,1,1) => east=0.455, north=0.292, up=0.841
%     xyz = rae2xyz([1,1,1])           => xyz = [0.455, 0.292, 0.841]
%
%   Notes:
%     Note the different definitions of azimuth here vs. Malab's sph2cart.
%     Also note the different format of input and output args: The input
%     coordinates here may be either singular values or a vector of
%     coordinate points.
%
%     Use the corresponding xyz2rae function for the reverse transformation.
%
%     rae2xyz does NOT take into account earth curvature, Ionosphere beam
%     curving etc. - this simple function uses a simple flat-earth free-space
%     model.
%
%   See also: xyz2rae, sph2cart, pol2cart

% Programmed by Yair M. Altman: altmany(at)gmail.com
% $Revision: 1.4 $  $Date: 2007/08/24 10:00:39 $

  %try
      % Process input args
      transposed = 0;
      if nargin < 2
          if isempty(rae),  east = [];  north = [];  up = [];  return;  end
          % ensure that coord points are column-wise
          if size(rae,2) == 1
              rae = rae';
              transposed = 1;
          end
          % ensure that we have enough coord data
          if size(rae,2) == 1
              error('input must be a vactor or matrix with at least 2 coordinate values');
          elseif size(rae,2) == 2
              rae(:,3) = 0;
          elseif size(rae,2) > 3
              warning('input must be a 2- or 3-dimensional vector/matrix - extra data is ignored');  %#ok for ML6
          end
          range     = rae(:,1);
          azimuth   = rae(:,2);
          elevation = rae(:,3);
      else
          range = rae;
          if nargin == 2
              % handle 2-D data (el=0)
              elevation = zeros(size(range));
          end
      end

      % Transform the azimuth and convert using Matlab's generic sph2cart
      % Note: use -a instead of pi/2-a if azimuth 0 is Eastward, not Northward
      [x,y,z] = sph2cart(pi/2-azimuth, elevation, range);

      % Send to output args
      if nargout > 1
          % format #1:
          east = x;
          north = y;
          if nargout > 2,  up = z;  end
      else%if nargout
          % format #2:
          if all(size(x) > 1)
              east = {x, y, z};
          elseif size(x,2) > size(x,1)
              east = [x; y; z];
          else
              east = [x, y, z];
          end
      end

      % Transpose result if inputs were transposed
      if transposed
          east = east';
          if exist('north','var'),  north = north';  end
          if exist('up','var'),  up = up';  end
      end

  %catch
  %    handleError;
  %end

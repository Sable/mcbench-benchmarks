function R = getR(theta,varargin)
% compute a rotation matrix given an angle and an axis
% if no axis specified then give the 2x2 rotation matrix about theta
%
% © Copyright Phil Tresadern, University of Oxford, 2006

if (length(theta(:)) > 1)
  error('Cannot do vector values');
end

c = cos(theta);
s = sin(theta);

if (length(varargin) > 0)
	ax	= varargin{1};

	switch (lower(ax))
	  case 'x'
	    R = [1 0 0; 0 c -s; 0 s c];
	  case 'y'
	    R = [c 0 s; 0 1 0; -s 0 c];
	  case 'z'
	    R = [c -s 0; s c 0; 0 0 1];
	  otherwise
	    error('Invalid axis');
	end
else
	R = [c -s; s c];
end
function W = lr2W(l,r,varargin)
% Takes two views of N points over T frames in the format:
% 
% l  = [ x1(1) y1(1) x2(1) y2(1) ... xN(1) yN(1) ]
%      [ x1(2) y1(2) x2(2) y2(2) ... xN(2) yN(2) ]
%      [                  ...                    ]
%      [ x1(T) y1(T) x2(T) y2(T) ... xN(T) yN(T) ]
% 
% r  = [ u1(1) v1(1) u2(1) v2(1) ... uN(1) vN(1) ]
%      [ u1(2) v1(2) u2(2) v2(2) ... uN(2) vN(2) ]
%      [                  ...                    ]
%      [ u1(T) v1(T) u2(T) v2(T) ... uN(T) vN(T) ]
%
% and gives a 3-dimensional matrix of the form:
% 
% W(:,:,t) = [ x1(t) x2(t) ... xN(t) ]
%            [ y1(t) y2(t) ... yN(t) ]
%            [ u1(t) u2(t) ... uN(t) ]
%            [ v1(t) v2(t) ... vN(t) ]
%
% © Copyright Phil Tresadern, University of Oxford, 2006

W = [];

nargchk(2,3,nargin);

% normalize with respect to the centroid?
normalize = 0;
if length(varargin)>0, normalize = varargin{1}; end

nframes = size(l,1);
npoints	= size(l,2) / 2;

W = zeros(4,npoints,nframes);

for f = 1:nframes
	ltemp	= reshape(l(f,:),[2,npoints]);
	rtemp = reshape(r(f,:),[2,npoints]);

	temp = [ltemp; rtemp];
	if (normalize)
		temp = temp - (mean(temp,2)*ones(1,npoints));
	end

	W(:,:,f) = temp;
end

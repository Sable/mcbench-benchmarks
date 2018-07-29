function [nps_r, f_r] = cart2rad(nps_x, f_x, n, unq)

% [nps_r, f_r] = cart2rad(nps_x, f_x, n, unq)
%
% Converts an n-dimensional symmetric noise-power spectrum (NPS) from
% Cartesian to radial coordinates.
%
% Several NPS measurements may be stacked along the last array
% dimension of nps_x, which is indicated by ndim(nps_x) = n + 1. If unq is
% set, non-unique data points are averaged. This latter is a slow function
% that should be improved.
%
% Erik Fredenberg, Royal Institute of Technology (KTH) (2010).
% Please reference this package if you find it useful.
% Feedback is welcome: fberg@kth.se.

% input checking
if nargin<4 || isempty(unq), unq=0; end
size_nps = size(nps_x); if any(diff(size_nps(1:n))), error('ROI must be symmetric'); end

if length(size_nps)==2 && size_nps(1)==1, nps_x=nps_x'; end

roi_size = size(nps_x,1);
stack_size = size(nps_x,n+1);

% radial frequency vector
f_x=repmat(f_x',[1 ones(1,n-1)*roi_size]);
f_r2=0; for p=1:n, f_r2=f_r2+shiftdim(f_x.^2,p-1); end, f_r=sqrt(f_r2);

% radial NPS
nps_r=reshape(nps_x,[roi_size^n stack_size]);
f_r=f_r(:);

% remove non-unique points if fitting in log domain because 
% sum of log \neq log of sum
if unq, [f_r, nps_r]=uniquify(f_r, nps_r); end

end

function [A_out,B_out]=uniquify(A_in,B_in)
% Makes vectors unique for repetitive values in A_in by taking the mean
% for the corresponding elements in B_in. This is a very slow function that
% could be immensely improved.

if size(A_in,2)==1, A_in=A_in';
elseif size(A_in,1)~=1, error('A_in must be a vector')
end

if size(B_in,1)==size(A_in,2), B_in=B_in';
elseif size(B_in,1)==size(A_in,2), error('B_in must have one dimension that matches A_in')
end

A_out=unique(A_in);
B_out=nan(size(B_in,1),size(A_out,2));
for a=1:numel(A_out)
    for b=1:size(B_in,1)
        B_out(b,a)=mean(B_in(b,A_in==A_out(a)));
    end
end
end
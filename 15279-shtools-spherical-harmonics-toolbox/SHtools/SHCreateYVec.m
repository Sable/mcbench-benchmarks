function [outvec,istart,iend] = SHCreateYVec(lmax,lon,colat,unit)

% [outvec,start,end] = SHCreateYVec(lmax,phi,theta[,unit])
%
% For a given degree lmax and a given longitude phi and colatitude theta
% in radians, creates an array of Ylm(phi,theta) for all -l<=m<=l, l<=lmax.
% If the input arguments are in degrees, set unit='deg'
% If lmax is an array, the output vector is the concatenation of the
% sections specified by lmax.
%
% The arrays 'start' and 'end' contain the first and the last indices
% for each of the N sections, so that vec(start(i):end(i)) exactly
% corresponds to the spherical harmonics degree lmax(i).

if nargin > 3,
  if strcmp(unit,'deg')
    lon=lon*pi/180;
    colat=colat*pi/180;
  elseif strcmp(unit,'rad')
    % do nothing
  else
    disp('unit argument must be "deg" or "rad". Assumed "rad"');
  end
end

if find(lmax<0)
    error('invalid usage: lmax must be a non-negative integer');
end

vec = SHCreateVec(max(lmax));

for l=0:max(lmax)
    Pl=legendre(l,cos(colat),'sch');
    for m=0:l
        Plm=Pl(m+1);
        value=cos(m*lon)*Plm;
        vec=SHSetValue(vec,value,l,m);
        if m~=0
            value=sin(m*lon)*Plm;
            vec=SHSetValue(vec,value,l,-m);
        end
    end
end

[outvec,i,j] = SHCreateVec(lmax);

for k=1:length(lmax)
    nmax = SHl2n(lmax(k));
    outvec(i(k):j(k)) = vec(1:nmax);
end

if nargout > 1
    istart = i;
    iend = j;
end
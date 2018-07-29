function [vec,istart,iend] = SHCreateVec(lmax)

% [vec,start,end] = SHCreateVec(lmax)
%
% For a given degree lmax, creates an array of zero-valued spherical
% harmonic coefficients. If lmax is a vector of length N, returns a 
% concatenated vector of spherical harmonics of degrees lmax(1) .. lmax(N).
% The arrays 'start' and 'end' contain the first and the last indices
% for each of the N sections, so that vec(start(i):end(i)) exactly
% corresponds to the spherical harmonics degree lmax(i).

N = length(lmax);

nmax=zeros(1,N);
istart=zeros(1,N);
vec=[];

for k=1:N
    if lmax(k)<0
        error('invalid usage: lmax must be a non-negative integer');
    end
    nmax(k)=SHl2n(lmax(k));
    section=zeros(1,nmax(k))';
    vec = [vec;section];
end

istart(1)=1;
for k=2:N
    istart(k)=istart(k-1)+nmax(k-1);
end
iend = istart+nmax-1;
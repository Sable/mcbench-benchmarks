function [resp] = my_sinthSISO_planresp( pos,freq,tar,tar_amp )
%MY_SINTHSISO_PLANRESP calculates synthetic SISO at position pos response 
%in frequency range freq on target tar(target postion), tar_amp: RCS like.
%Targets and Array must be in the same (image) plane, which XY-coordinate
%are represented as complex values.

if nargin < 4, tar_amp=ones(size(tar)); end % tar_amp = 1 if not given

%speed of light
co=299792458;
%redistribution of input data
tar_dim=numel(tar);
tar=reshape(tar,[1,1,tar_dim]);
tar_amp=reshape(tar_amp,[1,1,tar_dim]);

freq_dim=numel(freq);
freq=reshape(freq,[1,freq_dim,1]);

pos_dim=numel(pos);
pos=reshape(pos,[pos_dim,1,1]);

%% algo
%targets-elements radial-distances matrix
D=abs(repmat(tar,[pos_dim,1,1])-repmat(pos,[1,1,tar_dim]));
D=repmat(D,[1,freq_dim,1]);
%wavenumber
k=2*pi*repmat(freq,[pos_dim,1,tar_dim])/co;
%target amplitude
tar_amp=repmat(tar_amp,[pos_dim,freq_dim,1]);
%SISO response
resp=tar_amp.*exp(-1j*k*2.*D);
resp=sum(resp,3);

end


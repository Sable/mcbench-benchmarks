function y=akfrader(x,M);
% AKFRADER	calculation of autocorrelation by the method of Rader
%
%		Y=AKFRADER(X,[M])
%
%		X	: stationary random process (Vektor)
%		Y	: autocorrelation (Vector of length M)
%		M	: number for subsequence splitting
%
%		Literature:
%			Kammeyer, Karl Dirk
%			"DIGITALE SIGNALVERARBEITUNG : Filterung und Spektralanalyse"
%			Teubner-Verlag 1989, Teubner-Studienbücher: Elektrotechnik
%			ISBN 3-519-06122-8

if nargin==1,
	lx=length(x);
	M=64;
	Nges=floor(lx/M);
else
	lx=length(x);
	Nges=floor(lx/M);
end
					                    % CROPPING
x=x(:);					                % make column vector
x=x(1:(M*Nges)); lx=length(x);

x=[reshape(x,M,Nges);zeros(M,Nges)];	% subsequence splitting and appending
					                    % M zeros
SX=fft(x);				                % columnwise 2*M-DFT

SXI=SX(:,1:Nges-1); SXI1=SX(:,2:Nges);

kx=0:1:(2*M-1); kx=(-1) .^kx;
kx=meshgrid(kx,1:1:Nges-1).';		    % Alternating spectral functions

S=sum( (conj(SXI) .*(SXI + SXI1 .*kx)).' );
y=real(ifft(S)) ./lx;
y=y(1:M);				                % end of procedure
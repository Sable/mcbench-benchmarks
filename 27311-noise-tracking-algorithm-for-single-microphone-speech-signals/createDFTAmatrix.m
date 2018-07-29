function Amatrix=createDFTAmatrix(X,H);
% function Amatrix=createDFTAmatrix(X,H);
% Creates matrix of DFT-amplitudes for a signal X.
% In each column is a spectrum (1:N/2+1), row indices are time-frame indices.
% H is the analysis window. N is the frame length, 50% overlap is used.

% Turn into column vector
X=X(:);
H=H(:);
Nx=length(X);
N=length(H);
M=floor(2*Nx/N-1);
Amatrix=zeros(N/2+1,M);
for k=1:M
    index=(k-1)*N/2+1:(k+1)*N/2;
    F=abs(fft(X(index).*H'));
    Amatrix(:,k)=F(1:N/2+1);
end

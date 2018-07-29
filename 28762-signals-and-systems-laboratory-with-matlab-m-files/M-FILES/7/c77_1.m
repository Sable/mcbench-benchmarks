% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% DFT of a circularly shifted sequence



% circular shift in time 
x=[ 1 0 3 4 7];
m=2;
xc=circshift(x',m);
Left=dft(xc);
Left.'

X=dft(x);
N=length(x);
k=0:N-1;
Right=X.*exp(-j*2*pi*m*k/N);
Right.'


% circular shift in frequency 
x=[ 1 0 3 4 7];
N=length(x);
n=0:N-1;
m=2;
Left=dft(x.*exp(j*2*pi*n*m/N));
Left.'

X=dft(x);
Right=circshift(X.',m)

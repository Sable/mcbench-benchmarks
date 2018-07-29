% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% Discrete Fourier Transform  properties


% symmetry

x=[1 2 3 4 5];
Xk=dft(x)

k=0:4
N=5
R=Xk(1+mod(N-k,N))
Xnk=conj(R)


% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% N- point DFTs of a 4-point sequence 


% 4-point DFT 
x=[1 2 3 4];
fft(x)

% 6-point DFT 
fft(x,6)
xx=[x 0 0];

% 6-point DFT 
fft(xx)

% 3-point DFT 
fft(x,3)

% 3-point DFT 
xx=[1 2 3];
fft(xx)

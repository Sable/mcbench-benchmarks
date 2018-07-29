% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% N- point IDFTs of a 4-point sequence 



X=[10 -2+2j -2 -2-2j];

% 4-point IDFT 
ifft(X)

% 4-point IDFT 
idft(X)

% 6-point IDFT 
ifft(X,6)

% 6-point IDFT 
X(6)=0
ifft(X)

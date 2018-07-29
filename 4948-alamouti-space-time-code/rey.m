function H=rey(Nt,Nr)

%This function builds a matrix of Rayleigh Channel Coefficients. The input variables are
%the number of TX antenna Nt and the number of RX antenna. The matrix is useful just for 
%one symbol. I u want a frame, u should use this function a number of time that depends
%on the length of your frame.
%
%
%Take care!
%
%
%Max

H=zeros(Nt,Nr);
R=eye(Nt*Nr);                                               %Correlation matrix. 
X=randn(Nt*Nr,1)/sqrt(2)+j*randn(Nt*Nr,1)/sqrt(2);          %Channel coefficients
H=reshape(R'*X,Nt,Nr);                                      %The matrix.





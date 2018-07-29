function w=papouliswin(M)
% Usage window=papouliswin(SIZE of WINDOW);
% The variance of the resulting estimate is smaller than that obtained 
% with the known windows of the same size.
% Details of the property of the window can be found in
% A. Papoulis, “Minimum-bias windows for high-resolution spectral es-
% timates,” IEEE Trans. Inform. Theory, vol. IT-19, no. 1, pp. 9-12
% This code is written by Md. Sahidullah.
% Any query, comment or suggestion can be mailed to sahidullahmd@gmail.com
X=(M-1)/2;
n=(-X:X)';
w=(abs(sin(pi*n/M))/pi)+(1-abs(n)/M).*cos(pi*n/M);
function[Uhat] = d_filter(d,Z)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%the (1-L)^d filter in MATLAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Jx = fft(Z);
w1 = (0:2*pi/length(Jx):2*pi - 2*pi/length(Jx))';
w1(1,1) = w1(2,1)/2;
ei = ones(length(w1),1);
%the vectorized algorithm - luckily,exp can and should be used instead of expm in this case 
t = 1:1:length(Jx);
Uhat =(length(Jx)^(-1))*(exp(sqrt(-1)*w1*t))'*(((ei - exp(-sqrt(-1)*w1)).^d).*Jx); 
Uhat = real(Uhat);
end
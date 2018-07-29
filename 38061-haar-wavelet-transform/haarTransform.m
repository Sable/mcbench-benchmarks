% program for haar wavelet transform
% it shows the plot of input signal as well as the transformed parts of the
% signal i.e. first trend and first fluctuation
function haarTransform(f)
% Sample Signal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% t=0:0.0001:1;
% f=20*(t.^2).*(1-t).^4.*cos(12*t.*pi); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v=[1/sqrt(2) 1/sqrt(2)]; %haar scaling function 
w=[1/sqrt(2) -1/sqrt(2)]; %haar wavelet function
% making the input even in length %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if mod(length(f),2)~=0
    f=[f 0];
end
% haar wavelet transform %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d=length(f);
m=1:d/2;
a1=f(2*m-1).*v(1) + f(2*m).*v(2);
d1=f(2*m-1).*w(1) + f(2*m).*w(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plots
figure(1)
subplot(3,2,[1 2])
plot(f)
title('Original Signal') %plot of the original signal
ylabel('Amplitude')
xlabel('Time')
axis tight

subplot(3,2,3)
plot(a1)
title('First Trend') %plot of first trend after haar wavelet transform
ylabel('Amplitude')
xlabel('Time')
axis tight

subplot(3,2,4)
plot(d1)
title('First Fluctuation') %plot of first fluctuation after haar wavelet transform
ylabel('Amplitude')
xlabel('Time')
axis tight

subplot(3,2,[5 6])
plot([a1 d1])
title('Transformed Signal') %plot of the final signal obtained after the transformation
xlabel('Amplitude')
ylabel('Time')
axis tight

end
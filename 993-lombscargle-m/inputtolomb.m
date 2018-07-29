function indata = inputtolomb
%CREATE TEST DATA FOR lombscargle.m

%Create time points
t=[0:pi/32:8*pi];

%Keep random time points, discard the rest
%Note: To increase the number of points retained, decrease the multiplier (and vice versa)
discpct = 30; %Percent of data points to discard
ndiscards = floor((discpct/100)*length(t));
keeps = randperm(length(t));
keeps = sort(keeps(ndiscards+1:end)); %Discard 25% of the samples, selected randomly
t=t(keeps);

%USER-SPECIFIED FREQUENCIES AND AMPLITUDES (for testing purposes)
%Frequencies (Hz) = [0.9  3.3  4.0  4.5]
%Amplitudes       = [2.0  1.8  3.0  1.5]
foft = 2.0*sin(2*pi*0.9*t) + 1.8*sin(2*pi*3.3*t) + 3.0*sin(2*pi*4*t) + 1.5*sin(2*pi*4.5*t);
indata=[t' foft'];
%lombscargle(indata);


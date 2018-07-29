% Testsignal -- creates a test signal for the Simulink
% detector Detector1.  Load the model and runs it.

% Audio data is passed through the model in blocks
buffersize = 256;
fs=1024;
N=8192;

if ~exist('c:\temp\calls','dir'),
   !mkdir c:\temp\calls
end

y=randn(N,1);
x=0.01*randn(size(y));

m=200;n=310;
x(m:n)=y(m:n);
m=500;n=830;
x(m:n)=y(m:n);
m=1800;n=2036;
x(m:n)=y(m:n);
m=3000;n=3050;
x(m:n)=y(m:n);
m=6000;n=6100;
x(m:n)=y(m:n);


x=x(1:buffersize*floor(length(x)/buffersize));
x=x/max(abs(x));
x=reshape(x,buffersize,length(x)/buffersize)';

open_system('detector1')
sim('detector1')





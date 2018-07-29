%this is a simple example, demonstrating delay estimation. Estimates the
%delay of yn1 with respect to yn0 in the presence of noise.

N_p=256;%number of points;

d=5*rand;%delay

y0=randn(1,N_p);%reference signal

y1=fft_circshift(y0,d);%perform circular shift

yn0=0.05*randn(1,N_p);%noise
yn1=0.05*randn(1,N_p);%noise

y0n=y0+yn0;%add noise to signals
y1n=y1+yn1;

alpha=-1;%tuning parameter for modified gaussian method 
%(only used in the case of negative xc if alpha is negative, otherwise
%always use it. See delayest_3point.m)

%estimate delays
d_hat_parabola=delayest_3point(y1n,y0n,'parabola','xc');
d_hat_Gaussian=real(delayest_3point(y1n,y0n,'Gaussian','xc'));
d_hat_modGaussian=delayest_3point(y1n,y0n,'modGaussian','xc',alpha);
d_hat_cosine=real(delayest_3point(y1n,y0n,'cosine','xc'));
d_hat_phase=delayest_fft(y1n,y0n);
d_hat_iterative=delayest_iterative(y1n,y0n);

fprintf('Delay=%f samples\n',d);
fprintf('Estimates (samples):\nparabola %f\nGaussian %f\nmodified Gaussian %f\ncosine %f\nphase %f\niterative %f\n',...
    d_hat_parabola,d_hat_Gaussian,d_hat_modGaussian,d_hat_cosine,d_hat_phase,d_hat_iterative);

figure(1)
plot([y0n;y1n]','.-')